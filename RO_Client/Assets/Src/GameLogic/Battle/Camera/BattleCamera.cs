using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;

#region data
public enum CameraMoveMode
{
	Camera_SyncFocusPosition = 0,   //同步焦点和位置
	Camera_MoveFocusPosition = 1,   //焦点和位置同时移动
	Camera_MoveFocusFirst = 2,      //优先移动焦点
	Camera_MovePositionFirst = 3,   //优先移动位置
    Camera_FollowFighterPosition = 5,   //同步fighter的位置
    Camera_Follow_FixedTarget = 6,
    Camera_SyncRotPosition = 7,     //同步旋转和位置
    Camera_ManualRotate = 8,
}

public enum CameraMode
{
	Camera_None = 0,
	Camera_BattleAuto = 1,
	Camera_FollowLeftFighters = 2,
	Camera_LockFighter = 3,
    Camera_Fixed_Target = 4,
    Camera_Move_BattleFieldCenter = 5,
    Camera_TweeningMove = 6,
    Camera_TweeningJump = 7,
    Camera_ManualRotate = 8,
}

public enum BattleTransitionState
{
	BTS_None = 0,
	BTS_Out = 1,    //离场
	BTS_Black = 2,  //黑屏
	BTS_In = 3,     //进场
}

public class CameraFollowFighterHelper
{
	public Fighter FollowFighter { get; set; }

	public Vector3 TargetOffset { get; set; }

	public Vector3 CameraOffset{ get; set; }

    public float FollowDist { get; set; }

	public float Fov{ get; set; }

	public float FollowSpeedRate{ get; set; }

	public float ContinueTime{ get; set; }

	public CameraMoveMode MoveMode{ get; set; }

	public bool IsFollow{ get; set; }

	public bool IsUnscaleTime { get; set; }

	public bool IsActive { get { return mHasStart && (IsUnscaleTime ? Time.unscaledTime < mStartTime + ContinueTime : Time.time < mStartTime + ContinueTime); } }

	float mStartTime;

	bool mHasStart;

	Vector3 mStartFocus;

	Vector3 mStartCameraPosition;

	public void Start ()
	{		
		mStartTime = IsUnscaleTime ? Time.unscaledTime : Time.time;
		mHasStart = true;
		if (!IsFollow)
        {
			mStartFocus = FollowFighter == null ? Vector3.zero : FollowFighter.Position + TargetOffset;
            mStartCameraPosition = mStartFocus + CameraOffset;
        }
	}

	public void Stop ()
	{
		FollowFighter = null;
		mHasStart = false;
	}

	public Vector3 GetFocus ()
	{
		return IsFollow ? (FollowFighter == null ? Vector3.zero : FollowFighter.Position + TargetOffset) : mStartFocus;
	}

	public Vector3 GetCameraPosition ()
	{
        return IsFollow ?(GetFocus ()  - FollowFighter.Ctrl.transform.forward * FollowDist + CameraOffset) : mStartCameraPosition;
	}

    public Vector3 GetCameraPosition(Vector3 forward)
    {
        return GetFocus() - forward * FollowDist + CameraOffset;
    }

    public Vector3 Forward
    {
        get { return IsFollow ? (FollowFighter != null ? FollowFighter.Ctrl.transform.forward : Vector3.zero):Vector3.zero; }
    }
}

#endregion

public class BattleCamera : Singleton<BattleCamera>
{
	#region static_and_const

	public const string FighterLayerName = "Fighter";
	public const string SceneEffectLayerName = "FX";
	public const string DisableLayerName = "Disable";
	public const string BackGroudLayerName = "Background";
	public const string WaterLayerName = "Water";
	public const string GroundLayerName = "Ground";
	public const string ReflectionLayerName = "Reflection";
	public const string BackScreenLayerName = "BackScreenEffect";
    public const string HideLayerName = "Hide";
    public const string T4M5LayerName = "T4M5";

	public const float camera_view_border_blank = 0.1f;
	public const float camera_view_bottom_blank = 0.2f;
    public const float camera_far_clip = 100;

    public static int defalutLayer = LayerMask.NameToLayer("Default");
    public static int hideLayer = LayerMask.NameToLayer("Hide");

    //"Water", "MainCity", "Ground", "Reflection", "InvalidLayer"

    //public int FighterLayerMask;

    //public int FullLayerMask;
    #endregion

    #region fields

    private bool tracePosition;
	private bool mIsDoingSpecialCamera;

    private Camera mRealCam;
	public Camera RealCamera
    {
        get
        {
            return mRealCam;
        }
    }

    public bool BattleCameraEnabled
    {
        get { return mRealCam != null ? mRealCam.enabled : false; }
    }


    private Shake mShake = null;

    CameraMode currentCameraMode = CameraMode.Camera_BattleAuto;
	CameraMoveMode moveMode = CameraMoveMode.Camera_FollowFighterPosition;
	bool enableUpdateTo;
	bool enableUpdateCurrent;
	bool enableAutoFov = true;
    const float updateToInterval = 1.0f/60;
    float currentUpdateToInterval;

    const int maxCallUpdateCnt = 2;
    int callUpdateToCnt = 0;

    //相机目标属性
    Vector3 toFocus = Vector3.zero;
	Vector3 toPosition = Vector3.zero;
    Vector3 toElerAngle = Vector3.zero;
	float toFov;

	//相机当前属性
	Vector3 currentFocus = Vector3.zero;
	Vector3 currentPosition = Vector3.zero;
    Vector3 currentElerAngle = Vector3.zero;
	float currentFov;

	int cullingMask;

    public int CullingMask
    {
        get { return cullingMask; }
    }

	CameraClearFlags clearFlag;

	bool hasSetCamera;

	CameraClearFlags realCameraClearFlags;

	public bool syncSpeed = true;

	float syncFovSpeedRate = 1f;

	Transform efxBattleTransition;

	public bool enableDynamicSpeed = true;

	CameraFollowFighterHelper mFollowFighterHelper;

    GameObject camContainer = null;
    BattleCamConfig mCameraCfg = null;
    Animator camAnimator = null;
    RadialBlurEffect mBlurEffect = null;
    CameraRotateAround mCamRotateCom = null;

    private GameObject mComingCameraGo = null;
    #endregion

    public GameObject ComingCameraGo { get { return mComingCameraGo; } }

    public GameObject CamContainer { get { return camContainer; } }

    public BattleCamConfig CamCfg
    {
        get { return mCameraCfg; }
    }

    private Vector3 mCameraOffset;
    public Vector3 CameraOffset
    {
        get { return mCameraOffset; }
    }

    private BossIntroCameraCfg mBossIntroCamCfg;

    private bool mCustomFollowCamera;
    Vector3 followCameraOffset;
    float followCameraFov;
    #region properties

    Animator AnimatorCom {
		get {
            return camAnimator;
        }
	}

	public bool IsPlayingAnimation {
		get {
			if (AnimatorCom != null && AnimatorCom.isActiveAndEnabled)
				return true;

			return false;
		}
	}

	public Vector3 Forward {
		get {
			return RealCamera.transform.forward;
		}
	}

	public Vector3 Right {
		get {
			return RealCamera.transform.right;
		}
	}

	bool IsCurrentCloseToTarget {
		get {
			return currentPosition.CloseTo (toPosition) && currentFocus.CloseTo (toFocus) && Mathf.Abs (currentFov - toFov) < 0.0001f;
		}
	}

	CameraMode CurrentCameraMode {
		get {
			return currentCameraMode;
		}

		set {
			currentCameraMode = value;

			switch (currentCameraMode)
            {
			    case CameraMode.Camera_None:
				    enableUpdateTo = false;
				    enableUpdateCurrent = false;
				    mIsDoingSpecialCamera = false;
				    break;
                case CameraMode.Camera_FollowLeftFighters:
                    enableUpdateTo = true;
                    enableUpdateCurrent = true;
                    moveMode = CameraMoveMode.Camera_SyncFocusPosition;
                    enableAutoFov = false;
                    mIsDoingSpecialCamera = false;
                    syncSpeed = true;
                    enableDynamicSpeed = false;
                    break;
                case CameraMode.Camera_LockFighter:
                    enableUpdateTo = true;
                    enableUpdateCurrent = true;
                    enableAutoFov = false;
                    mIsDoingSpecialCamera = false;
                    enableDynamicSpeed = true;
                    break;
                case CameraMode.Camera_BattleAuto:
                    enableUpdateTo = true;
                    enableUpdateCurrent = true;
                    moveMode = CameraMoveMode.Camera_SyncFocusPosition;
                    enableAutoFov = false;
                    mIsDoingSpecialCamera = false;
                    enableDynamicSpeed = true;
                    break;
                case CameraMode.Camera_Fixed_Target:
                    enableUpdateTo = false;
                    enableUpdateCurrent = false;
                    moveMode = CameraMoveMode.Camera_Follow_FixedTarget;
                    enableAutoFov = false;
                    mIsDoingSpecialCamera = false;
                    enableDynamicSpeed = false;
                    break;
                case CameraMode.Camera_Move_BattleFieldCenter:
                    enableUpdateTo = true;
                    enableUpdateCurrent = true;
                    moveMode = CameraMoveMode.Camera_MoveFocusPosition;
                    enableAutoFov = false;
                    mIsDoingSpecialCamera = false;
                    syncSpeed = false;
                    mCustomFollowCamera = false;
                    enableDynamicSpeed = false;
                    break;
                case CameraMode.Camera_TweeningMove:
                    enableUpdateTo = false;
                    enableUpdateCurrent = true;
                    enableAutoFov = false;
                    mIsDoingSpecialCamera = true;
                    enableDynamicSpeed = false;
                    moveMode = CameraMoveMode.Camera_SyncFocusPosition;
                    break;
                case CameraMode.Camera_ManualRotate:
                    enableUpdateTo = true;
                    enableUpdateCurrent = true;
                    moveMode = CameraMoveMode.Camera_ManualRotate;
                    enableAutoFov = false;
                    mIsDoingSpecialCamera = false;
                    enableDynamicSpeed = false;
                    break;
            }
		}
	}

    public Vector3 CamPosition
    {
        get {
            return camContainer!= null ? camContainer.transform.position : Vector3.zero;
        }
        set
        {
            if(camContainer!=null)
                camContainer.transform.position = value;
        }
    }

    public Vector3 CamForward
    {
        get 
        {
            return camContainer!= null ? camContainer.transform.forward : CamEulerAngle.normalized;
        }
    }

    public Vector3 CamEulerAngle
    {
        get { return mCurCamEulerAngle; }
        set
        {
            if(mCurCamEulerAngle!=value)
            {
                mCurCamEulerAngle = value;
                if(null != camContainer)
                    camContainer.transform.rotation = Quaternion.Euler(mCurCamEulerAngle);
            }
        }
    }

    public float CamFov
    {
        get { return mRealCam != null?mRealCam.fieldOfView : 60; }
        set
        {
            if(mRealCam!=null)
                mRealCam.fieldOfView = Mathf.Max(value, 0.1f);
        }
    }
    bool initialized;

    Vector3 mCurCamEulerAngle;
    BaseBattle mBattle;

    private float mMoveSpeed = 0;
    public float MoveSpeed
    {
        get { return mMoveSpeed; }
        set { mMoveSpeed = value; }
    }

    private float mRotSpeed = 0;
    public float RotSpeed
    {
        get { return mRotSpeed; }
        set { mRotSpeed = value; }
    }

    private float mFovSpeed = 0;
    public float FovSpeed
    {
        get { return mFovSpeed; }
        set { mFovSpeed = value; }
    }

    public float MoveSpeedInBattle
    {
        get { return CamCfg.CamMoveSpeedInBattle; }
    }
    #endregion

    public override void Init()
    {
        base.Init();  
    }

    public override void UnInit()
    {
        base.UnInit();
    }

	public void Initialize (LogicBattle battle)
	{
		if (initialized)
			return;

        mBattle = battle;
		//FighterLayerMask = LayerMask.GetMask (new [] { FighterLayerName });

		//FullLayerMask = LayerMask.GetMask (new [] {
		//	FighterLayerName,
		//	SceneEffectLayerName,
		//	WaterLayerName,
		//	ReflectionLayerName,
		//	GroundLayerName,
		//	BackGroudLayerName
		//});

        mComingCameraGo = battle.BattleScene.ComingCamera;
        camContainer = battle.BattleScene.CameraContainer;
        if (camContainer == null)
            return;

        mCameraCfg = camContainer.GetComponent<BattleCamConfig>();

        if (!camContainer.activeInHierarchy)
            camContainer.SetActive(true);

        camAnimator = camContainer.GetComponentInChildren<Animator>();
        mCamRotateCom = camContainer.GetComponentInChildren<CameraRotateAround>();
        if (mCamRotateCom != null)
        {
            mCamRotateCom.target = battle.TeamCenterPoint;
        }

        if (battle.BattleScene.BossIntroCamGo != null)
        {
            mBossIntroCamCfg = battle.BattleScene.BossIntroCamGo.GetComponent<BossIntroCameraCfg>();
        }

        if (AnimatorCom != null)
			AnimatorCom.enabled = false;

        mRealCam = battle.BattleScene.CameraTrans.GetComponent<Camera>();
        if (Camera.main == null)
            mRealCam.tag = "MainCamera";
        cullingMask = mRealCam.cullingMask;
        clearFlag = mRealCam.clearFlags;
        mRealCam.allowHDR = false;
        mRealCam.allowMSAA = false;
        mRealCam.farClipPlane = camera_far_clip;


        InitComponents ();

		initialized = true;

        toFocus = battle.BattleScene.ActorBornPoint.GetReadyPointPos(0, 1).heroPos;
        toPosition = toFocus - battle.BattleScene.ActorBornPoint.transform.forward * mCameraCfg.followDist + mCameraCfg.followCamOffset;
        toFov = mCameraCfg.followCameraFov;
        mCurCamEulerAngle = camContainer.transform.rotation.eulerAngles;
        SetCurrentCamera(false, true,0);

        mBlurEffect = mRealCam.GetComponent<RadialBlurEffect>();

        mMoveSpeed = CamCfg.CamMoveSpeed;
        mRotSpeed = CamCfg.CamRotSpeed;
        mFovSpeed = CamCfg.CamFovSpeed;

        InitShake();
    }

    public void Initialize(VersusBattle battle)
    {
        if (initialized)
            return;

        mBattle = battle;
        //FighterLayerMask = LayerMask.GetMask(new[] { FighterLayerName });

        //FullLayerMask = LayerMask.GetMask(new[] {
        //    FighterLayerName,
        //    SceneEffectLayerName,
        //    WaterLayerName,
        //    ReflectionLayerName,
        //    GroundLayerName,
        //    BackGroudLayerName
        //});

        if (battle == null) return;

        mComingCameraGo = battle.BattleScene.ComingCamera;
        camContainer = battle.BattleScene.CameraContainer;
        if (camContainer == null)
            return;

        if (!camContainer.activeInHierarchy)
            camContainer.SetActive(true);

        camAnimator = camContainer.GetComponentInChildren<Animator>();
        mCameraCfg = camContainer.GetComponent<BattleCamConfig>();

        mRealCam = battle.BattleScene.CameraTrans.GetComponent<Camera>();
        if (Camera.main == null)
            mRealCam.tag = "MainCamera";
        cullingMask = mRealCam.cullingMask;
        clearFlag = mRealCam.clearFlags;
        mRealCam.allowHDR = false;
        mRealCam.allowMSAA = false;

        InitComponents();
        initialized = true;

        SetCamera(battle.BornCamPos,battle.BornCenter,battle.BornCamRot,battle.BornCamFov);
        mBlurEffect = mRealCam.GetComponent<RadialBlurEffect>();

        InitShake();
    }

    public void Initialize(BossBattle battle)
    {
        if (initialized)
            return;

        mBattle = battle;
        //FighterLayerMask = LayerMask.GetMask(new[] { FighterLayerName });

        //FullLayerMask = LayerMask.GetMask(new[] {
        //    FighterLayerName,
        //    SceneEffectLayerName,
        //    WaterLayerName,
        //    ReflectionLayerName,
        //    GroundLayerName,
        //    BackGroudLayerName
        //});

        if (battle == null) return;

        mComingCameraGo = battle.BattleScene.ComingCamera;
        camContainer = battle.BattleScene.CameraContainer;
        if (camContainer == null)
            return;

        if (!camContainer.activeInHierarchy)
            camContainer.SetActive(true);

        camAnimator = camContainer.GetComponentInChildren<Animator>();
        mCameraCfg = camContainer.GetComponent<BattleCamConfig>();

        mRealCam = battle.BattleScene.CameraTrans.GetComponent<Camera>();
        if (Camera.main == null)
            mRealCam.tag = "MainCamera";
        cullingMask = mRealCam.cullingMask;
        clearFlag = mRealCam.clearFlags;
        mRealCam.allowHDR = false;
        mRealCam.allowMSAA = false;

        initialized = true;

        //SetCameraPosAndRot(battle.SpawnCfg.BossCamPos, battle.SpawnCfg.BossCamRot, 50);
        CurrentCameraMode = CameraMode.Camera_None;
        mBlurEffect = mRealCam.GetComponent<RadialBlurEffect>();

        InitShake();
    }


    public void Initialize(TimeBattle battle)
    {
        if (initialized)
            return;

        mBattle = battle;
        if (battle == null) return;

        mComingCameraGo = battle.BattleScene.ComingCamera;
        camContainer = battle.BattleScene.CameraContainer;
        if (camContainer == null)
            return;

        if (!camContainer.activeInHierarchy)
            camContainer.SetActive(true);

        camAnimator = camContainer.GetComponentInChildren<Animator>();
        mCameraCfg = camContainer.GetComponent<BattleCamConfig>();

        mRealCam = battle.BattleScene.CameraTrans.GetComponent<Camera>();
        if (Camera.main == null)
            mRealCam.tag = "MainCamera";
        cullingMask = mRealCam.cullingMask;
        clearFlag = mRealCam.clearFlags;
        mRealCam.allowHDR = false;
        mRealCam.allowMSAA = false;
        initialized = true;
        CurrentCameraMode = CameraMode.Camera_None;

        mBlurEffect = mRealCam.GetComponent<RadialBlurEffect>();
        InitShake();
    }

    private void InitShake()
    {
        if (mRealCam == null) return;

        mShake = mRealCam.GetComponent<Shake>();
        if (mShake == null)
        {
            mShake = mRealCam.gameObject.AddComponent<Shake>();
        }
    }

    public void Update(float deltaTime)
    {
        if (!initialized)
        {
            return;
        }

        if (manualRotating) return;

        //if (CurrentCameraMode == CameraMode.Camera_BattleAuto)
        //{
        //    if (callUpdateToCnt < maxCallUpdateCnt)
        //    {
        //        if (currentUpdateToInterval <= 0f)
        //        {
        //            callUpdateToCnt++;
        //            UpdateTo();
        //            currentUpdateToInterval = updateToInterval;
        //        }
        //        currentUpdateToInterval -= deltaTime;
        //    }
        //}
        //else
        //{
        //}

        UpdateTo();
        UpdateCurrent(deltaTime);
    }

    public void Clear()
    {
        DisableBattleCam();
        //Camera_UI3D.Instance.Clear();
        if(mCamRotateCom!=null)
            mCamRotateCom.target = null;
        mFollowFighterHelper = null;
        initialized = false;
        camContainer = null;
        camAnimator = null;
        mBossIntroCamCfg = null;
        mRealCam = null;
        mCamRotateCom = null;
        CurrentCameraMode = CameraMode.Camera_None;
    }

    void InitComponents ()
	{
		mFollowFighterHelper = new CameraFollowFighterHelper ();
	}

	void UpdateFollowFighter ()
	{
        if (mBattle != null)
        {
            toFocus = mBattle.TeamCenter + mFollowFighterHelper.TargetOffset;
            toFov = mFollowFighterHelper.Fov;
            toPosition = toFocus - mFollowFighterHelper.FollowFighter.Ctrl.transform.forward * mFollowFighterHelper.FollowDist + mFollowFighterHelper.CameraOffset;
        }
        else
        {
            toFocus = mFollowFighterHelper.GetFocus();
            toFov = mFollowFighterHelper.Fov;
            toPosition = mFollowFighterHelper.GetCameraPosition();
        }
    }

    void UpdateFollowFighter(Vector3 forward)
    {
        if(mBattle!=null)
        {
            toFocus = mBattle.TeamCenter + mFollowFighterHelper.TargetOffset;
            toFov = mFollowFighterHelper.Fov;
            toPosition = toFocus - forward * mFollowFighterHelper.FollowDist + mFollowFighterHelper.CameraOffset;
        }
        else
        {
            toFocus = mFollowFighterHelper.GetFocus();
            toFov = mFollowFighterHelper.Fov;
            toPosition = mFollowFighterHelper.GetCameraPosition(forward);
        }
    }

    void UpdateTo ()
	{
		if (!enableUpdateTo)
			return;

		if (IsPlayingAnimation)
			return;

        if(CurrentCameraMode == CameraMode.Camera_BattleAuto)
        {
            if(mFollowFighterHelper != null && mFollowFighterHelper.IsActive)
            {
                UpdateFollowFighter(mBattleAutoForward);
            }
        }
        else if (mFollowFighterHelper != null && mFollowFighterHelper.IsActive)
        {
            UpdateFollowFighter();
		}
        else if (CurrentCameraMode == CameraMode.Camera_FollowLeftFighters)
        {
            if(mBattle!=null)
            {
                toFocus = mBattle.FighterMgr.TeamFighterFocus;
                Vector3 focusForward = mBattle.FighterMgr.TeamFighterForward;
                toPosition = toFocus + FollowCameraOffset;
                toFov = FollowCameraFov;
            }
		} 
	}

	void UpdateCurrent (float deltaTime)
	{
		if (!enableUpdateCurrent) {
            return;
        }

        switch (MoveMode)
        {
            case CameraMoveMode.Camera_SyncFocusPosition:
                CamSyncFocusPosition(deltaTime);
                break;
            case CameraMoveMode.Camera_SyncRotPosition:
                currentPosition = Vector3.MoveTowards(currentPosition, toPosition, deltaTime * MoveSpeed);
                currentElerAngle = Vector3.MoveTowards(currentElerAngle, toElerAngle, deltaTime * RotSpeed);
                break;
            case CameraMoveMode.Camera_MoveFocusPosition:
                currentFocus = Vector3.MoveTowards(currentFocus, toFocus, deltaTime * MoveSpeed);
                currentPosition = Vector3.MoveTowards(currentPosition, toPosition, deltaTime * MoveSpeed);
                break;
            case CameraMoveMode.Camera_MoveFocusFirst:
                currentFocus = Vector3.MoveTowards(currentFocus, toFocus, deltaTime * MoveSpeed);
                if (currentFocus.CloseTo(toFocus))
                    currentPosition = Vector3.MoveTowards(currentPosition, toPosition, deltaTime * MoveSpeed);
                break;
            case CameraMoveMode.Camera_MovePositionFirst:
                currentPosition = Vector3.MoveTowards(currentPosition, toPosition, deltaTime * MoveSpeed);
                if (currentPosition.CloseTo(toPosition))
                    currentElerAngle = Vector3.MoveTowards(currentElerAngle, toElerAngle, deltaTime * RotSpeed);
                break;
            case CameraMoveMode.Camera_FollowFighterPosition:
                currentFocus = Vector3.MoveTowards(currentFocus, toFocus, deltaTime * MoveSpeed);
                currentPosition = Vector3.MoveTowards(currentPosition, toPosition, deltaTime * MoveSpeed);
                break;
            case CameraMoveMode.Camera_Follow_FixedTarget:
                currentFocus = Vector3.MoveTowards(currentFocus, toFocus, deltaTime * MoveSpeed);
                currentPosition = Vector3.MoveTowards(currentPosition, toPosition, deltaTime * MoveSpeed);
                break;
            case CameraMoveMode.Camera_ManualRotate:
                //currentFocus = Vector3.MoveTowards(currentFocus, toFocus, deltaTime * MoveSpeed);
                currentFocus = toFocus;
                if (currentFocus.CloseTo(toFocus))
                    currentPosition = Vector3.MoveTowards(currentPosition, toPosition, deltaTime * MoveSpeed);
                break;
        }

		SetCurrentCamera (EnableAutoFov, !hasSetCamera,deltaTime);
	}

    void CamSyncFocusPosition(float deltaTime)
    {
        float currentMoveSpeed = MoveSpeed;
        float currentRotateSpeed = RotSpeed;
        float currentFovSpeed = FovSpeed;
        Vector3 vTo = toFocus - toPosition;
        currentPosition = CamPosition;
        currentFocus = currentPosition + CamForward * vTo.magnitude;
        Vector3 vCurrent = currentFocus - currentPosition;
        float angleBetween = Vector3.Angle(vTo, vCurrent);
        float magnitudeDiff = Mathf.Abs(vTo.magnitude - vCurrent.magnitude);
        float positionDistance = Vector3.SqrMagnitude(toPosition - currentPosition);
        float focusDistance = Vector3.SqrMagnitude(toFocus - currentFocus);
        float magnitudeSpeed = MoveSpeed;

        if (syncSpeed)
        {
            if (focusDistance < positionDistance)
            {
                if (enableDynamicSpeed)
                {
                    if (focusDistance < 0.5f)
                        currentMoveSpeed = Mathf.Max(0.1f, 0.05f * MoveSpeed * focusDistance * 2f);
                    else if (focusDistance < 10f)
                        currentMoveSpeed = MoveSpeed * focusDistance * 0.1f;
                }
                float time1 = focusDistance / currentMoveSpeed;
                float time2 = angleBetween / currentRotateSpeed;
                float time = Mathf.Max(time1, time2);
                if (time > 0f)
                {
                    currentMoveSpeed = focusDistance / time;
                    currentRotateSpeed = angleBetween / time;
                    magnitudeSpeed = magnitudeDiff / time;
                }
            }
            else
            {
                if (enableDynamicSpeed)
                {
                    if (positionDistance < 0.5f)
                        currentMoveSpeed = Mathf.Max(0.1f, 0.05f * MoveSpeed * positionDistance * 2f);
                    else if (positionDistance < 10f)
                        currentMoveSpeed = MoveSpeed * positionDistance * 0.1f;
                }
                float time1 = positionDistance / currentMoveSpeed;
                float time2 = angleBetween / currentRotateSpeed;
                float time = Mathf.Max(time1, time2);
                if (time > 0f)
                {
                    currentMoveSpeed = focusDistance / time;
                    currentRotateSpeed = angleBetween / time;
                    magnitudeSpeed = magnitudeDiff / time;
                }
            }
            syncFovSpeedRate = currentFovSpeed / FovSpeed;
        }
        else
        {
            if (angleBetween > 0f && currentRotateSpeed > 0f)
                magnitudeSpeed = magnitudeDiff / (angleBetween / currentRotateSpeed);
        }

        //Vector3 v = Vector3.MoveTowards(vCurrent, vTo, deltaTime * currentMoveSpeed);
        //currentPosition = Vector3.MoveTowards(currentPosition, toPosition, deltaTime * currentMoveSpeed);
        //currentFocus = currentPosition + v;
        if (magnitudeSpeed < 0.5f)
        {
            magnitudeSpeed = 0.5f;
        }

        Vector3 v = Vector3.RotateTowards(vCurrent, vTo, deltaTime * currentRotateSpeed * Mathf.Deg2Rad, deltaTime * magnitudeSpeed);
        if (focusDistance < positionDistance)
        {
            currentFocus = Vector3.MoveTowards(currentFocus, toFocus, deltaTime * currentMoveSpeed);
            currentPosition = currentFocus - v;
        }
        else
        {
            currentPosition = Vector3.MoveTowards(currentPosition, toPosition, deltaTime * currentMoveSpeed);
            currentFocus = currentPosition + v;
        }
    }

    Quaternion tempQuaternion;

	void SetCurrentCamera (bool autoFov, bool immediate,float deltaTime)
	{
        if(immediate)
        {
            //DebugHelper.LogError("currentPosition:" + currentPosition + " CamEulerAngle:" + CamEulerAngle);
            currentPosition = toPosition;
            currentFocus = toFocus;
        }
        
        CamPosition = currentPosition;

        tempQuaternion.SetLookRotation(currentFocus - currentPosition, Vector3.up);
        CamEulerAngle = tempQuaternion.eulerAngles;

        if (immediate)
        { 
            currentFov = toFov;
        }
        else
        {
            if (syncSpeed && MoveMode == CameraMoveMode.Camera_SyncFocusPosition)
                currentFov = Mathf.MoveTowards(currentFov, toFov, syncFovSpeedRate * FovSpeed * deltaTime);
            else
                currentFov = Mathf.MoveTowards(currentFov, toFov, FovSpeed * deltaTime);
        }

        CamFov = currentFov;

        hasSetCamera |= immediate;
        //DebugHelper.LogError("currentPosition:" + currentPosition + " CamEulerAngle:" + CamEulerAngle);
	}
    
    void GetCurrentCameraValues()
    {
        currentPosition = CamPosition;
        currentElerAngle = CamEulerAngle;
        currentFov = CamFov;
    }

	public void LockFighter (Fighter fighter, Vector3 CameraOffset, Vector3 forward,float fov,float followDist,bool immediate)
	{
        if (mRealCam != null)
        {
            mRealCam.farClipPlane = camera_far_clip;
        }
        
        if (mFollowFighterHelper.IsActive)
        {
            currentUpdateToInterval = 0;
            mMoveSpeed = CamCfg.CamMoveSpeed;
            mRotSpeed = CamCfg.CamRotSpeed;
            if (manualRotating)
            {
                backupCameraMode = CameraMode.Camera_LockFighter;
            }
            else
            {
                SetCameraMode(CameraMode.Camera_LockFighter);
            }
             
            return;
        }

        mFollowFighterHelper.Fov = fov.FEqual (0) ? 30 : fov;
		mFollowFighterHelper.FollowFighter = fighter;
		mFollowFighterHelper.TargetOffset = Vector3.zero;
        mFollowFighterHelper.CameraOffset = CameraOffset;
		mFollowFighterHelper.FollowSpeedRate = 1;
		mFollowFighterHelper.ContinueTime = 10000f;
		mFollowFighterHelper.MoveMode = CameraMoveMode.Camera_SyncFocusPosition;
        mFollowFighterHelper.FollowDist = followDist;
		mFollowFighterHelper.IsFollow = true;
		mFollowFighterHelper.IsUnscaleTime = false;
		mFollowFighterHelper.Start ();

        if (manualRotating)
        {
            backupCameraMode = CameraMode.Camera_LockFighter;
        }
        else
        {
            SetCameraMode(CameraMode.Camera_LockFighter);

            mMoveSpeed = CamCfg.CamMoveSpeed;
            mRotSpeed = CamCfg.CamRotSpeed;
            if (immediate)
            {
                UpdateFollowFighter(forward);

                Vector3 oldRot = CamEulerAngle;
                currentPosition = CamPosition = toPosition;
                currentFocus = toFocus;
                tempQuaternion.SetLookRotation(currentFocus - currentPosition, Vector3.up);
                currentElerAngle = CamEulerAngle = tempQuaternion.eulerAngles;
                DebugHelper.Log("TeamCenter:" + mBattle.TeamCenter + " CameraOffset:" + CameraOffset.ToString());
            }
        }
    }

    public void StopLockFighter ()
	{
        if(mFollowFighterHelper!=null)
		    mFollowFighterHelper.Stop ();
	}
   
	public void SetCameraWithFocus (Vector3 targetPosition, Vector3 targetFocus, float targetFov)
	{
        StopLockFighter();
        toFocus = targetFocus;
		toPosition = targetPosition;
		toFov = targetFov;
        SetCameraMode(CameraMode.Camera_Move_BattleFieldCenter);
    }

    private float mRecordRotSpeed = 0;
    private float mRecordMoveSpeed = 0;
    public void SetCameraPosAndRot(Vector3 pos,Vector3 rot,float fov = 0,float far = 0)
    {
        if(manualRotating)
        {
            RestoreCamRotate();
        }

        StopLockFighter();
        toPosition = pos;
        toElerAngle = rot;
        currentFov = toFov = fov < 1 ? mCameraCfg.bossCameraFov:fov;

        SetCameraMode(CameraMode.Camera_Fixed_Target);

        CamFov = currentFov;
        currentPosition = CamPosition = toPosition;
        currentElerAngle = CamEulerAngle = toElerAngle;
        if(far > 0)
        {
            mRealCam.farClipPlane = far;
        }
    }

    public void SetCamera(Vector3 targetPos,Vector3 targetFocus,Vector3 targetAngles,float targetFov)
    {
        toPosition = targetPos;
        toFocus = targetFocus;
        toElerAngle = targetAngles;
        currentFov = toFov = targetFov;

        CamFov = currentFov;
        currentPosition = CamPosition = toPosition;
        currentElerAngle = CamEulerAngle = toElerAngle;
        currentFocus = toFocus;
        SetCameraMode(CameraMode.Camera_None);
    }

    Vector3 mBattleAutoForward = Vector3.zero;
    public void SetBattleAuto(Vector3 forward)
    {
        mBattleAutoForward = forward;
        MoveSpeed = CamCfg.CamMoveSpeedInBattle;
        RotSpeed = CamCfg.CamRotSpeedInBattle;
        if(!manualRotating)
        {
            SetCameraMode(CameraMode.Camera_BattleAuto);
        }
        else
        {
            backupCameraMode = CurrentCameraMode;
        }
    }

	public void SetCameraMode (CameraMode mode)
	{
        if (mIsDoingSpecialCamera)
            BattleMgr.Instance.StopCoroutine(specialCameraCoroutine);

        if(currentCameraMode!=mode)
		    CurrentCameraMode = mode;

        //DebugHelper.LogError("--------------------------SetCameraMode---------------------"+ mode);
    }

	public void DisableDynamicCamera ()
	{
		SetCameraMode (CameraMode.Camera_None);
	}

	public bool IsDoingSpecialCamera {
		get {
			return mIsDoingSpecialCamera;
		}
	}

	public Vector3 FollowCameraOffset {
		get {
			return mCustomFollowCamera ? followCameraOffset : mCameraCfg.followCamOffset;

		}
	}

	public float FollowCameraFov {
		get {
			return mCustomFollowCamera ? followCameraFov : mCameraCfg.followCameraFov;

		}
	}

	public bool EnableAutoFov {
		get {
			if (mFollowFighterHelper != null && mFollowFighterHelper.IsActive)
				return false;
			return enableAutoFov;
		}
	}

	public CameraMoveMode MoveMode {
		get {
			if (mFollowFighterHelper != null && mFollowFighterHelper.IsActive)
				return mFollowFighterHelper.MoveMode;
			return moveMode;
		}
	}

	static string mEffectLayerNameInBattle = SceneEffectLayerName;

	public static string CurrentEffectLayerName {
		get { return BattleMgr.Instance != null ? mEffectLayerNameInBattle : SceneEffectLayerName; }
		set {
			if (BattleMgr.Instance != null)
				mEffectLayerNameInBattle = value;
		}
	}

	public bool IsLoadingTransitionEffect { get; private set; }

    public void EnableBattleCam()
    {
        if(RealCamera!=null /*&& !RealCamera.enabled*/)
        {
            RealCamera.cullingMask = cullingMask;
        }
    }

    public void DisableBattleCam()
    {
        if (RealCamera != null/* && RealCamera.enabled*/)
        {
            RealCamera.cullingMask = 0;
        }
    }

    public void EnterBossIntroCam()
    {
        if (mBossIntroCamCfg != null)
        {
            mBossIntroCamCfg.Begin();
            DisableBattleCam();
            //Camera_UI3D.Instance.SetCameraEnabled(false);
        }
    }

    public void ExitBossIntroCam()
    {
        if (mBossIntroCamCfg != null)
        {
            mBossIntroCamCfg.Stop();
            EnableBattleCam();
            //Camera_UI3D.Instance.SetCameraEnabled(true);
        }
    }

    bool manualRotating= false;
    CameraMode backupCameraMode = CameraMode.Camera_None;


    public void BeginCamRotate()
    {
        if (mCamRotateCom == null)
            return;

        manualRotating = true;
        mCamRotateCom.StartRotate();
        backupCameraMode = CurrentCameraMode;
    }

    public void RestoreCamRotate()
    {
        if (mCamRotateCom == null)
            return;

        manualRotating = false;
        SetCameraMode(backupCameraMode);
        mCamRotateCom.StopRotate();
    }

    public void Shake(float leftRight, float upDown, float forwardBackward, float time, int cycle)
    {
        if (mShake == null) return;

        mShake.positionShake = new Vector3(leftRight, upDown, forwardBackward);
        mShake.angleShake = Vector3.zero;
        if (Mathf.Abs(time) < Mathf.Epsilon)
            time = 0.1f;
        mShake.cycleTime = time;
        mShake.fCycleCount = cycle;
        mShake.unscaleTime = false;
        mShake.bothDir = true;
        mShake.autoDisable = true;
        mShake.Restart();
    }

    public void SetBlurEffectEnabled(bool flag)
    {
        if (mBlurEffect == null) return;

        if(flag)
        {
            mBlurEffect.FadeIn();
        }
        else
        {
            mBlurEffect.FadeOut();
        }
    }

    #region 转场镜头
    Coroutine specialCameraCoroutine;
    public void PerformStartCamera(List<MapCameraConfig> camCfgs, bool tweenTo)
    {
        BattleMgr.Instance.StartCoroutine(DoStartCamera(camCfgs, tweenTo));
    }

    IEnumerator DoStartCamera(List<MapCameraConfig> camCfgs, bool tweenTo)
    {
        if (camCfgs == null || camCfgs.Count == 0) yield break;

        mIsDoingSpecialCamera = true;

        syncSpeed = false;

        //DebugHelper.LogError("start camera start");
        MapCameraConfig cfg = camCfgs[0];

        if (tweenTo)
        {
            tempQuaternion.eulerAngles = cfg.rot;
            Vector3 targetForward = (tempQuaternion * Vector3.forward).normalized;
            Vector3 targetFocus = cfg.pos + targetForward * 20;
            ReadyForSpecailCamera();
            MoveSpeed = cfg.moveSpeed;
            RotSpeed = cfg.rotSpeed;
            FovSpeed = cfg.fovSpeed;
            CamEulerAngle = cfg.rot;
            specialCameraCoroutine =BattleMgr.Instance.StartCoroutine(DoTween(cfg.pos, targetFocus, cfg.fov, 0, CameraMoveMode.Camera_SyncFocusPosition));
            while (mIsDoingSpecialCamera)
                yield return 1;
        }
        else
        {
            SetCamera(cfg.pos,cfg.pos, cfg.rot, cfg.fov);
        }

        for (int i = 1; i < camCfgs.Count; i++)
        {
            MapCameraConfig nextCfg = camCfgs[i];
            tempQuaternion.eulerAngles = nextCfg.rot;
            Vector3 targetForward = (tempQuaternion * Vector3.forward).normalized;
            Vector3 targetFocus = nextCfg.pos + targetForward * 20;
            ReadyForSpecailCamera();
            MoveSpeed = cfg.moveSpeed;
            RotSpeed = cfg.rotSpeed;
            FovSpeed = cfg.fovSpeed;
            CamEulerAngle = nextCfg.rot;
            specialCameraCoroutine = BattleMgr.Instance.StartCoroutine(DoTween(nextCfg.pos, targetFocus, nextCfg.fov, 0, CameraMoveMode.Camera_SyncFocusPosition));
            while (mIsDoingSpecialCamera)
                yield return 1;
        }

        //DebugHelper.LogError("start camera end");

        syncSpeed = true;

        mIsDoingSpecialCamera = false;
    }

    IEnumerator DoTween(Vector3 targetPosition, Vector3 targetFocus, float targetFov, float tweenSpeedRate, CameraMoveMode tweenMoveMode)
    {
        if (tweenSpeedRate.FEqual(0))
            tweenSpeedRate = 1f;

        CurrentCameraMode = CameraMode.Camera_TweeningMove;

        moveMode = tweenMoveMode;

        toPosition = targetPosition;
        toFocus = targetFocus;
        toFov = targetFov;

        //DebugHelper.LogError("tween from11 {0}, {1}, {2} to {3}, {4}, {5}, has set : {6}", currentPosition, currentFocus, currentFov, toPosition, toFocus, toFov, hasSetCamera);

        while (!IsCurrentCloseToTarget)
            yield return 1;

        RestoreModeAfterSpecialCamera();
    }

    CameraMode modeBackupBeforeSpecialCamera;
    float moveSpeedBeforeSpecialCamera;
    float rotSpeedBeforeSpecialCamera;
    float fovSpeedBeforeSpecialCamera;
    Vector3 posBackupBeforeSpecialCamera;
    Vector3 rotBackupBeforeSpecialCamera;
    float fovBackupBeforeSpecialCamera;

    void BackupModeBeforeSpecialCamera()
    {
        modeBackupBeforeSpecialCamera = CurrentCameraMode;
        moveSpeedBeforeSpecialCamera = MoveSpeed;
        rotSpeedBeforeSpecialCamera = RotSpeed;
        fovSpeedBeforeSpecialCamera = FovSpeed;
        posBackupBeforeSpecialCamera = CamPosition;
        rotBackupBeforeSpecialCamera = CamEulerAngle;
        fovBackupBeforeSpecialCamera = CamFov;

    }

    void RestoreModeAfterSpecialCamera()
    {
        CurrentCameraMode = modeBackupBeforeSpecialCamera;
        MoveSpeed = moveSpeedBeforeSpecialCamera;
        RotSpeed = rotSpeedBeforeSpecialCamera;
        FovSpeed = fovSpeedBeforeSpecialCamera;
        CamPosition = posBackupBeforeSpecialCamera;
        CamEulerAngle = rotBackupBeforeSpecialCamera;
        CamFov = fovBackupBeforeSpecialCamera;
    }

    void ReadyForSpecailCamera()
    {
        if (specialCameraCoroutine != null && mIsDoingSpecialCamera)
        {
            BattleMgr.Instance.StopCoroutine(specialCameraCoroutine);
            RestoreModeAfterSpecialCamera();
        }
        BackupModeBeforeSpecialCamera();
    }
    #endregion
}
