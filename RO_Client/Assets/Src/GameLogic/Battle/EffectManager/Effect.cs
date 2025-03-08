using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;

public class Effect
{
	static int mAutoIncInstanceId = 1;

	#region Fields
	EffectData mData;
	GameObject mEffectGO;
	Transform mOwnerTransform;
	Transform mTargetTransform;
	Transform mBulletTransform;

	float mLifeTime;
	bool ignoreTimeScale = false;
	bool fixFloor = false;
	int lookType = 0;
	bool mirrorable = true;
	string mForceLayer = string.Empty;
	#endregion

	#region Properties

	public int InstanceID { get; private set; }

	public int EffectID { get { return mData.id; } }

	public float MaxLifeTime { get { return mData.lifeTime; } }

	public bool Valid { get { return mData != null && mData.valid; } }

	public EffectFollowType FollowType { get { return mData.followTargetType; } }

	public EffectTargetType TargetType { get { return mData.targetType; } }

	public GameObject EffectGo { get { return mEffectGO; } }

	public bool IsPaused { get; private set; }

	public bool IsDisposed { get; private set; }

	public Transform OwnerTransform { get { return mOwnerTransform; } }

	public Transform TargetTransform { get { return mTargetTransform; } }
	 
	public Fighter OwnerFighter {get { return GetTransformFighter (mOwnerTransform);}}

	public Fighter TargetFighter {get { return GetTransformFighter (mTargetTransform);}}


	#endregion

	public Effect (EffectData data)
	{
		InstanceID = mAutoIncInstanceId++;
		mData = data;
		IsPaused = false;
		IsDisposed = false;
		mLifeTime = 0;
	}

	public void Play (Transform selfTransform, Transform targetTransform = null, Transform bulletTransform = null
		, bool ignoreTimescale = false, bool fixFloor = false, int lookType = 0, bool mirrorable = true, string forceLayer = "")
	{
		mOwnerTransform = selfTransform;
		mTargetTransform = targetTransform;
		mBulletTransform = bulletTransform;
		this.ignoreTimeScale = ignoreTimescale;
		this.fixFloor = fixFloor;
		this.lookType = lookType;
		this.mirrorable = mirrorable;
		this.mForceLayer = forceLayer;

		Initialze ();
	}

	public void Pause ()
	{
		if (IsPaused)
			return;

        UnityEngineUtils.PauseEffectParticle (mEffectGO);
		IsPaused = true;
	}

	public void ResumeFromPause ()
	{
		if (!IsPaused)
			return;

        UnityEngineUtils.ResumeEffectParticle (mEffectGO);
		IsPaused = false;
	}

	public void Update (float deltaTime)
	{
		if (IsPaused) {
			return;
        }

        mLifeTime += deltaTime;
		UpdateFollowFloorPosition ();

		if (mEffectGO == null || (mData.lifeTime > 0 && mLifeTime > MaxLifeTime))
			EffectManager.Instance.RemoveEffectByInstanceID (InstanceID);
	}

	void CreateEffectGo ()
	{
		if (mEffectGO != null)
			return;

		if (string.IsNullOrEmpty(mData.effect)) return;

		mEffectGO = EffectManager.Instance.CreateEffectGo(mData.effect);
		if (mEffectGO == null)
		{
			//DebugHelper.LogError("effect go is null" + mData.effect);
			return;
		}

		mEffectGO.name = mData.effect;

		if (ignoreTimeScale)
            UnityEngineUtils.SetUnscalTimePartical (mEffectGO);
		
		if (mData.followTargetType == EffectFollowType.Effect_Follow_Camera_Back)
			CommonUtil.SetGameObjectLayer (mEffectGO, BattleCamera.BackScreenLayerName);
		else if (mOwnerTransform != null) {
			if (!string.IsNullOrEmpty (mForceLayer))
                CommonUtil.SetGameObjectLayer (mEffectGO, mForceLayer);
			else if (mData.followTargetType == EffectFollowType.Effect_Follow_Camera_Normal)
                CommonUtil.SetGameObjectLayer (mEffectGO, BattleCamera.SceneEffectLayerName);
			else
                CommonUtil.SetGameObjectLayer (mEffectGO, BattleCamera.CurrentEffectLayerName);	
		}
	}

	void SetFollowParent ()
	{
		if (mEffectGO == null)
			return;

		if (mData.followTargetType == EffectFollowType.Effect_Follow_None)
        {
			mEffectGO.transform.SetParent(null);
			return;
        }

		if (mData.followTargetType == EffectFollowType.Effect_Follow_Self 
			|| mData.followTargetType == EffectFollowType.Effect_Follow_Self_Bloodbar
			|| mData.followTargetType == EffectFollowType.Effect_Follow_Self_Floor)
        {
			AttachTransform (mOwnerTransform, mEffectGO.transform, mData.targetObjName);
		}
        else if (mData.followTargetType == EffectFollowType.Effect_Follow_Target 
			|| mData.followTargetType == EffectFollowType.Effect_Follow_Target_Bloodbar
			|| mData.followTargetType == EffectFollowType.Effect_Follow_Target_Floor)
        {
			AttachTransform (mTargetTransform, mEffectGO.transform, mData.targetObjName);
		}
        else if (mData.followTargetType == EffectFollowType.Effect_Follow_Camera_Back
			|| mData.followTargetType == EffectFollowType.Effect_Follow_Camera_Normal)
        {
			if (BattleCamera.Instance != null)
				mEffectGO.transform.SetParent (BattleCamera.Instance.RealCamera.transform);
		}

		mEffectGO.transform.localPosition = new Vector3 (0f, 0f, 0f);
        mEffectGO.transform.localEulerAngles = mData.rot;
        mEffectGO.transform.localScale = new Vector3 (1f, 1f, 1f);
		UpdateFollowFloorPosition ();
	}

	void AttachTransform (Transform tParent, Transform tChild, string name)
	{
		var attachParent = UnityEngineUtils.RecurisiveFindTransformChild (tParent, name);
		if (attachParent == null)
			attachParent = tParent;
		tChild.SetParent (attachParent);
	}

	void SyncPosition (Transform toSync, Transform targetTransform, string name)
	{
		if (toSync == null || targetTransform == null)
			return;
		Transform t = UnityEngineUtils.RecurisiveFindTransformChild (targetTransform, name);
		toSync.position = t != null ? targetTransform.TransformPoint (targetTransform.InverseTransformPoint (t.position)) : targetTransform.TransformPoint (Vector3.zero);
	}

	void SetTargetPosition ()
	{
		if (mEffectGO == null)
			return;

		//如果设置了跟随，忽略目标属性
		if (mData.followTargetType != EffectFollowType.Effect_Follow_None)
			return;

        LookAtOwnerForward ();
        mEffectGO.transform.localPosition = Vector3.zero;
        mEffectGO.transform.localEulerAngles = mData.rot;
        mEffectGO.transform.localScale = Vector3.one;

        if (mData.targetType == EffectTargetType.Effect_Target_Self || mData.targetType == EffectTargetType.Effect_Target_Self_Floor) {
			SyncPosition (mEffectGO.transform, mOwnerTransform, mData.targetObjName);	
		} else if (mData.targetType == EffectTargetType.Effect_Target_Target || mData.targetType == EffectTargetType.Effect_Target_Target_Floor) {
			SyncPosition (mEffectGO.transform, mTargetTransform, mData.targetObjName);
		} else if (mData.targetType == EffectTargetType.Effect_Target_Bullet) {
			SyncPosition (mEffectGO.transform, mBulletTransform, mData.targetObjName);
		} else if (mData.targetType == EffectTargetType.Effect_Target_To_Self)
        {
			if (mOwnerTransform != null && mTargetTransform != null) {
				MoveFromToWithTransform moveFromTo = mEffectGO.GetComponent<MoveFromToWithTransform> (true);
				mEffectGO.transform.position = mTargetTransform.position;
				moveFromTo.from = mTargetTransform;
				moveFromTo.to = mOwnerTransform;
				moveFromTo.enabled = true;
			}
			return;
		} else if (mData.targetType == EffectTargetType.Effect_Self_To_Target)
        {
			if (mOwnerTransform != null && mTargetTransform != null) {
				MoveFromToWithTransform moveFromTo = mEffectGO.GetComponent<MoveFromToWithTransform> (true);
				mEffectGO.transform.position = mOwnerTransform.position;
				moveFromTo.from = mOwnerTransform;
				moveFromTo.to = mTargetTransform;
				moveFromTo.enabled = true;
			}
			return;
		}
	}

	void LookAtOwnerForward()
	{
		if (mEffectGO == null)
			return;
		if (mOwnerTransform != null)
			mEffectGO.transform.LookAt (mEffectGO.transform.position + mOwnerTransform.position);
	}

	void SetLocalTransform ()
	{
		if (mEffectGO == null)
			return;

		if (mData.followTargetType != EffectFollowType.Effect_Follow_None)
        {
			if (mData.followTargetType == EffectFollowType.Effect_Follow_Self_Bloodbar) {
				Fighter fighter = GetTransformFighter (mOwnerTransform);
				if (fighter != null)
					mEffectGO.transform.localPosition += fighter.Actor.AvatarData.bloodBarPos.y * Vector3.up;
			} else if (mData.followTargetType == EffectFollowType.Effect_Follow_Target_Bloodbar) {
				Fighter fighter = GetTransformFighter (mTargetTransform);
				if (fighter != null)
					mEffectGO.transform.localPosition += fighter.Actor.AvatarData.bloodBarPos.y * Vector3.up;
			}
		}
	}

	Fighter GetTransformFighter (Transform t)
	{
		if (t == null)
			return null;
		FighterGoCtrl fighterCtrl = t.GetComponent<FighterGoCtrl> ();
		return fighterCtrl == null ? null : fighterCtrl.Fighter;
	}

	void SetFloorPosition ()
	{
		if (mEffectGO == null)
			return;

		if (mData.followTargetType == EffectFollowType.Effect_Follow_None
		    && (mData.targetType == EffectTargetType.Effect_Target_Self_Floor || mData.targetType == EffectTargetType.Effect_Target_Target_Floor)
		    && BattleMgr.Instance != null && BattleMgr.Instance.Battle.CurBattleField != null)
			mEffectGO.transform.position = mEffectGO.transform.position.SetY (BattleMgr.Instance.Battle.CurBattleField.FloorY);
	}

	void UpdateFollowFloorPosition()
	{
		if (mEffectGO == null)
			return;

		if ((mData.followTargetType == EffectFollowType.Effect_Follow_Self_Floor || mData.followTargetType == EffectFollowType.Effect_Follow_Target_Floor)
			&& BattleMgr.Instance != null && BattleMgr.Instance.Battle.CurBattleField != null)
			mEffectGO.transform.position = mEffectGO.transform.position.SetY (BattleMgr.Instance.Battle.CurBattleField.FloorY);
	}

	void SetLookAt ()
	{
		if (lookType == 1 && mTargetTransform != null) {
			mEffectGO.transform.LookAt (mTargetTransform.position);
		}
	}

	void SetUnscalTimePartical ()
	{
		if (mEffectGO == null)
			return;

		UnityEngineUtils.SetUnscalTimePartical (mEffectGO);
	}

	void Show ()
	{
		if (mEffectGO != null)
			mEffectGO.SetActive (true);
	}

	void Initialze ()
	{
		CreateEffectGo ();
		SetFollowParent ();
		SetTargetPosition ();
		SetLocalTransform ();
		SetFloorPosition ();
		SetLookAt ();
		Show ();
	}

	public void Hide ()
	{
		if (EffectGo != null)
			CommonUtil.SetGameObjectLayer (EffectGo, BattleCamera.DisableLayerName);
	}

	public void UnHide ()
	{
		if (EffectGo != null) {
			if (mData.followTargetType == EffectFollowType.Effect_Follow_Camera_Back)
                CommonUtil.SetGameObjectLayer (mEffectGO, BattleCamera.BackScreenLayerName);
			else if (mOwnerTransform != null) {
				if (!string.IsNullOrEmpty (mForceLayer))
                    CommonUtil.SetGameObjectLayer (mEffectGO, mForceLayer);
				else
                    CommonUtil.SetGameObjectLayer (mEffectGO, BattleCamera.CurrentEffectLayerName);	
			}
		}
	}

    public void SetScale(float scale)
    {
        if(EffectGo != null)
        {
            EffectGo.transform.localScale = new Vector3(scale, scale, scale);
        }
    }

    public void Dispose()
    {
        if (IsDisposed)
            return;
        if (mEffectGO != null)
        {
            ResourceMgr.Instance.RecycleGO(Constants.EffectPath, mData.effect, mEffectGO);
            mEffectGO = null;
        }
        IsDisposed = true;
    }

    public void Destroy()
    {
        Dispose();
        mData = null;
        mOwnerTransform = null;
        mTargetTransform = null;
        mBulletTransform = null;
    }
}

