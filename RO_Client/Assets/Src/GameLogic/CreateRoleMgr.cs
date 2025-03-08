using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.SceneManagement;
using LuaInterface;

public class CreateRoleMgr : Singleton<CreateRoleMgr>
{
    private bool bLoaded = false;
    private bool bHasStartLoad = false;

    private GameObject mMaleRoot;
    private GameObject mFemaleRoot;
    private GameObject mShowRoot;
    private Camera mCam;
    private DepthOfFieldPostEffect dof;
    private int layerMask = 0;
    private int mUpdateTimer = -1;

    private LuaTable mCreateRoleLuaTbl;
    private Animator mAnimator;
    private int mTransferEffectId = 0;
    private CapsuleCollider mMaleCapsuleCollider = null;
    private CapsuleCollider mFemaleCapsuleCollider = null;


    public GameObject MaleRoot
    {
        get { return mMaleRoot; }
    }

    public GameObject FemaleRoot
    {
        get { return mFemaleRoot; }
    }

    public GameObject ShowRoot
    {
        get { return mShowRoot; }
    }

    private GameObject mMaleGo;
    private GameObject mFemaleGo;

    public override void Init()
    {
        base.Init();
        layerMask = 1 << LayerMask.NameToLayer(BattleCamera.FighterLayerName);
    }

    public void Clear()
    {
        if (mMaleGo != null)
        {
            GameObject.Destroy(mMaleGo);
            mMaleGo = null;
        }

        if (mFemaleGo != null)
        {
            GameObject.Destroy(mFemaleGo);
            mFemaleGo = null;
        }

        bLoaded = false;
        bHasStartLoad = false;
        mCreateRoleLuaTbl = null;
        if (mUpdateTimer > 0)
        {
            TimerManager.Instance.RemoveTimer(mUpdateTimer);
            mUpdateTimer = 0;
        }
    }

    public void SetLuaTable(LuaTable luaTbl)
    {
        mCreateRoleLuaTbl = luaTbl;
        if (mCreateRoleLuaTbl != null)
        {
            Animator maleAnim = mMaleGo.GetComponent<Animator>();
            Animator femaleAnim = mFemaleGo.GetComponent<Animator>();
            mCreateRoleLuaTbl.CallCS2Lua("SetActorAnim", maleAnim, femaleAnim);
        }
    }

    public void LoadScene()
    {
        if (bHasStartLoad) return;

        bHasStartLoad = true;

        EventMgr.AddEventListener<string>(ECoreEventType.EID_Scene_Loaded, OnSceneLoaded);
        EventMgr.DispatchEvent<bool>(new CoreEvent<bool>(ECoreEventType.EID_LOAD_BEGIN, true));
        SceneMgr.Instance.AsyncLoadMainScene("Scene_CreateRole");
        PreDownProcessManager.Instance.StartLoad();
        if (mUpdateTimer > 0)
        {
            TimerManager.Instance.RemoveTimer(mUpdateTimer);
        }
        mUpdateTimer = TimerManager.Instance.AddTimer(16, -1, Update);
    }

    public void PlayAnim(string animName, bool forward)
    {
        if (mAnimator != null)
        {
            mAnimator.Play(animName);
        }
    }

    public bool IsPlayAnimEnd(string animName)
    {
        if (mAnimator == null)
        {
            return false;
        }
        var stateInfo = mAnimator.GetCurrentAnimatorStateInfo(0);
        if (!stateInfo.IsName(animName))
        {
            return false;
        }
        if (stateInfo.loop)
        {
            return false;
        }
        if (stateInfo.normalizedTime < 1)
        {
            return false;
        }
        return true;
    }

    public void EnableCam()
    {
        if (mCam != null)
            mCam.gameObject.SetActive(true);
    }

    public void OpenDof()
    {
        if (dof != null)
            dof.enabled = true;
    }

    public void CloseDof()
    {
        if (dof != null)
            dof.enabled = false;
    }

    public void PlayTransferEffect()
    {
        if (mTransferEffectId == 0) return;

        EffectManager.Instance.PlayEffect(mTransferEffectId, selectedRole, selectedRole);
    }

    private void OnSceneLoaded(CoreEvent<string> sceneName)
    {
        EventMgr.RemoveEventListener<string>(ECoreEventType.EID_Scene_Loaded, OnSceneLoaded);
        bLoaded = true;
        bHasStartLoad = false;
        PreDownProcessManager.Instance.Clear();
        string bgmName = GlobalConfig.Instance.GetConfigStrValue(132);
        if (!string.IsNullOrEmpty(bgmName))
            MusicMgr.Instance.PlayBGMusic(bgmName);
        Scene scene = SceneManager.GetSceneByName(sceneName.Data);
        GameObject[] rootObjs = scene.GetRootGameObjects();
        mMaleRoot = rootObjs.FindFirst(a => a.name.CompareTo("MaleRoot") == 0);
        mFemaleRoot = rootObjs.FindFirst(a => a.name.CompareTo("FemaleRoot") == 0);
        mShowRoot = rootObjs.FindFirst(a => a.name.CompareTo("ShowRoot") == 0);

        mCam = Camera.main;
        mAnimator = mCam.GetComponent<Animator>();
        dof = mCam.GetComponent<DepthOfFieldPostEffect>();
        if (dof != null)
            dof.enabled = false;

        string malePrefabName = GlobalConfig.Instance.GetConfigStrValue(128);
        string femalePrefabName = GlobalConfig.Instance.GetConfigStrValue(129);
        List<string> models = new List<string>();
        if (!string.IsNullOrEmpty(malePrefabName))
            models.Add(malePrefabName);

        if (!string.IsNullOrEmpty(femalePrefabName))
            models.Add(femalePrefabName);
        ResourceMgr.Instance.LoadAsset<List<GameObject>>(OnLoadModelCompleted, Constants.HeroPath, models.ToArray());

        mTransferEffectId = GlobalConfig.Instance.GetConfigIntValue(134);   //开启传送门特效
        if (mTransferEffectId > 0)
        {
            BattlePrepareManager.Instance.PrecacheEffect(mTransferEffectId);
            BattlePrepareManager.Instance.StartLoad();
        }
    }

    private void OnLoadModelCompleted(List<GameObject> goes, string assetPath, string[] assetNames)
    {
        mMaleGo = GameObject.Instantiate(goes[0]);
        if (mMaleRoot != null)
        {
            mMaleGo.transform.SetParent(mMaleRoot.transform);
            mMaleGo.transform.localPosition = Vector3.zero;
            mMaleGo.transform.localRotation = Quaternion.identity;
            mMaleGo.name = "Male";
            mMaleCapsuleCollider = LuaBattleBridge.AddCapsuleCollider(mMaleGo, 2.5f, new Vector3(0, 1, 0));
        }

        mFemaleGo = GameObject.Instantiate(goes[1]);
        if (mFemaleRoot != null)
        {
            mFemaleGo.transform.SetParent(mFemaleRoot.transform);
            mFemaleGo.transform.localPosition = Vector3.zero;
            mFemaleGo.transform.localRotation = Quaternion.identity;
            mFemaleGo.name = "Female";
            mFemaleCapsuleCollider = LuaBattleBridge.AddCapsuleCollider(mFemaleGo, 2.5f, new Vector3(0, 1, 0));
        }

        //DebugHelper.LogError(DebugHelper.Tag_BHY + " CreateRoleMgr LoadCompleted");
        EventMgr.DispatchEvent<bool>(new CoreEvent<bool>(ECoreEventType.EID_LOAD_COMPLETE, true));
    }

    private void Update(int timer)
    {
        if (mCam == null) return;

        if (SceneEventCtl.UpdateRaycastHit(mCam, layerMask))
        {
            OnHitActor();
        }
        if(bHasStartLoad)
        {
            PreDownProcessManager.Instance.updateLoadStatus();
        }
        //else if(Input.GetMouseButtonUp(0))
        //{
        //    OnCancelActor();
        //}
    }

    private Transform selectedRole = null;
    private void OnHitActor()
    {
        var newSelectedRole = SceneEventCtl.hit.transform;
        bool isMale = newSelectedRole.name == "Male";
        if (mCreateRoleLuaTbl != null)
        {
            bool changed = mCreateRoleLuaTbl.InvokeCS2Lua<bool, GameObject, bool>("OnSelectRole", isMale, newSelectedRole.gameObject);
            if (changed)
            {
                selectedRole = newSelectedRole;
                mFemaleCapsuleCollider.radius = 1;
                mMaleCapsuleCollider.radius = 1;
                if (isMale)
                {
                    mFemaleCapsuleCollider.enabled = true;
                    mMaleCapsuleCollider.enabled = false;
                }
                else
                {
                    mFemaleCapsuleCollider.enabled = false;
                    mMaleCapsuleCollider.enabled = true;
                }
            }
        }
    }

    private void OnCancelActor()
    {
        if (selectedRole != null)
        {
            if (mCreateRoleLuaTbl != null)
            {
                mCreateRoleLuaTbl.CallCS2Lua("CancelSelected");
            }
            selectedRole = null;
        }
    }
}
