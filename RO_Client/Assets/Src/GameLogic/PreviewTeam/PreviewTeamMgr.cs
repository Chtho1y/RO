using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;
using UnityEngine.SceneManagement;

public class PreviewTeamMgr : SingletonMono<PreviewTeamMgr>
{
    private List<ActorAvatar> mActors;
    private bool bSceneLoaded = false;
    private bool bActorsLoaded = false;
    private LuaTable mLuaTbl;
    private TowerTeamBornInfo mTeamBornInfo;
    private GameObject mCamGo = null;
    private Camera mCam;
    private bool bInPreview = false;

    public bool InPreview
    {
        get
        {
            return bInPreview;
        }
    }

    int layerMask = 0;
    public override void InitMgr()
    {
        base.InitMgr();
    }

    private void Update()
    {
        if (mCam == null) return;

        for (int idx = 0; idx < mActors.Count; idx++)
            mActors[idx].Update(mCam);

        if (SceneEventCtl.UpdateRaycastHit(mCam, layerMask))
        {
            OnHitActor();
        }
    }

    public void LoadPreviewActorsAndScene(ActorData[] actors, string sceneName, LuaTable tbl)
    {
        if (actors == null || actors.Length == 0 || string.IsNullOrEmpty(sceneName))
            return;

        if (mActors == null)
            mActors = new List<ActorAvatar>();
        else
            CleanActors();

        mLuaTbl = tbl;
        mTeamBornInfo = TowerBattleCfgMgr.Instance.TeamBornData;
        if(mTeamBornInfo == null)
        {
            TowerBattleCfgMgr.Instance.ReadCfg();
        }
      
        for (int idx = 0; idx < actors.Length; idx++)
        {
            ActorAvatar avatar = new ActorAvatar(actors[idx]);
            mActors.Add(avatar);
            avatar.ParseLoad();
        }
        LoadScene(sceneName);

        bInPreview = true;
    }

    public void Show()
    {
        if (mActors == null) return;

        for (int idx = 0; idx < mActors.Count; idx++)
            mActors[idx].IsVisible = true;

        SetCamera();
        BattleFlyWordMgr.Instance.SetHudVisible(true);
    }

    public void Hide()
    {
        if (mActors == null) return;

        for (int idx = 0; idx < mActors.Count; idx++)
            mActors[idx].IsVisible = false;
    }

    public void PlayEffect(int uid)
    {
        ActorAvatar actor = FindAvatarById(uid);
        if (actor == null) return;

        actor.PlayEffect();
    }
    
    public void StopEffect(int uid)
    {
        ActorAvatar actor = FindAvatarById(uid);
        if (actor == null) return;

        actor.StopEffect();
    }
    
    public void PlayAnim(int uid, string animName)
    {
        if (string.IsNullOrEmpty(animName)) return;

        ActorAvatar actor = FindAvatarById(uid);
        if (actor == null) return;

        actor.PlayAnim(animName);
    }

    public void SetBattleFlag(int uid, bool inBattle)
    {
        ActorAvatar actor = FindAvatarById(uid);
        if (actor == null) return;

        actor.SetBattleFlag(inBattle);
        if (inBattle)
        {
            actor.PlayAnim(Constants.ArenaOnBattleAniName);
            actor.PlayEffect();
        }
        else
        {
            actor.PlayAnim(Constants.ArenaOffBattleAniName);
            actor.StopEffect();
        }
    }

    private ActorAvatar FindAvatarById(long uid)
    {
        if (mActors == null) return null;

        for(int idx =0; idx < mActors.Count;idx++)
        {
            if (mActors[idx].Data.ID == uid) return mActors[idx];
        }

        return null;
    }

    private void LoadScene(string sceneName)
    {
        EventMgr.AddEventListener<string>(ECoreEventType.EID_Scene_Loaded, OnSceneLoaded);
        SceneMgr.Instance.AsyncLoadMainScene(sceneName);
        if (mLuaTbl != null)
            mLuaTbl.CallCS2Lua("OnLoadBegin");
    }

    private void OnSceneLoaded(CoreEvent<string> ce)
    {
        if (mLuaTbl != null)
            mLuaTbl.CallCS2Lua("OnLoadProgress",0.3f);

        EventMgr.RemoveEventListener<string>(ECoreEventType.EID_Scene_Loaded, OnSceneLoaded);
        bSceneLoaded = true;
        Scene mScene = SceneManager.GetSceneByName(ce.Data);
        if (mScene.isLoaded)
        {
            GameObject[] rootObjs = mScene.GetRootGameObjects();

            mCamGo = rootObjs.FindFirst(a => a.name.CompareTo(Constants.go_name_camera_target) == 0);
            mCamGo.SetActive(true);
            SetCamera();
        }

        layerMask = LayerMask.NameToLayer(BattleCamera.FighterLayerName);
        LoadActors();
    }

    private void LoadActors()
    {
        EventMgr.AddEventListener<bool>(ECoreEventType.EID_PREPARE_LOAD_OK, OnPrepareLoadOk);
        BattlePrepareManager.Instance.StartLoad();
    }

    private void OnPrepareLoadOk(CoreEvent<bool> ce)
    {
        if (ce.Data)
        {
            if (mLuaTbl != null)
                mLuaTbl.CallCS2Lua("OnLoadProgress", 0.7f);

            EventMgr.RemoveEventListener<bool>(ECoreEventType.EID_PREPARE_LOAD_OK, OnPrepareLoadOk);
            bActorsLoaded = true;
            CheckLoadingStatus();
        }
    }

    private void CheckLoadingStatus()
    {
        if(bSceneLoaded && bActorsLoaded)
        {
            CreateActors();
            if (mLuaTbl != null)
                mLuaTbl.CallCS2Lua("OnLoadComplete");

            EventMgr.DispatchEvent<bool>(new CoreEvent<bool>(ECoreEventType.EID_LOAD_COMPLETE, true));

            if (mLuaTbl != null)
            {
                mLuaTbl.CallCS2Lua("OnStartPreview");
            }

        }

    }

    private void CreateActors()
    {
        for(int idx =0; idx < mActors.Count;idx++)
        {
            if (mLuaTbl != null)
                mLuaTbl.CallCS2Lua("OnLoadProgress", 0.7f + (idx/mActors.Count) * 0.3f);

            mActors[idx].CreateGo(mTeamBornInfo.bornPosList[idx],mCam);
        }
        BattleFlyWordMgr.Instance.SetHudVisible(true);
    }

    private void OnHitActor()
    {
        var hitActorTrans = SceneEventCtl.hit.transform;
        ActorAvatar avatar = FindActorByTrans(hitActorTrans);
        if(avatar!=null)
        {
            if (mLuaTbl != null)
                mLuaTbl.CallCS2Lua("OnHitActor", avatar.Data.ID);
        }
    }

    private ActorAvatar FindActorByTrans(Transform trans)
    {
        if (mActors == null || trans == null) return null;

        for(int idx =0; idx < mActors.Count;idx++)
        {
            if (mActors[idx].AvatarGo != null && mActors[idx].AvatarGo.transform == trans) return mActors[idx];
        }

        return null;
    }

    private void SetCamera()
    {
        if (mCamGo != null)
        {
            Transform camTrans = mCamGo.transform;
            camTrans.position = mTeamBornInfo.camPos;
            camTrans.rotation = Quaternion.Euler(mTeamBornInfo.camRot);
            mCam = mCamGo.GetComponentInChildren<Camera>();
            if (mCam != null)
            {
                mCam.fieldOfView = mTeamBornInfo.fov;
                mCam.enabled = true;
                mCam.cullingMask = BattleCamera.Instance.CullingMask;
            }
            mCamGo.SetActive(true);
        }
    }

    private void CleanActors()
    {
        if (mActors == null) return;

        for(int idx =0; idx < mActors.Count;idx++)
        {
            mActors[idx].Dispose();
        }
        mActors.Clear();
    }

    public void Clean()
    {
        CleanActors();
        mTeamBornInfo = null;
        mLuaTbl = null;
        bSceneLoaded = false;
        bActorsLoaded = false;
        bInPreview = false;
        mCamGo = null;
        mCam = null;
    }
}
