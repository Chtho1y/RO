using UnityEngine;
using System.Collections;
using UnityEngine.SceneManagement;
using System.Collections.Generic;
using System.Runtime.InteropServices;

public class LogicBattleScene : BaseBattleScene
{
    const string bossintro_camera_go = "bossIntro_cam";
    const string scene_root_name = "SceneRoot";

    #region fields
    private string switchGoName;
    private GameObject[] mRootObjs = null;
    private List<SpawnPointCfg> mBossSpawnPointList = new List<SpawnPointCfg>();
    private List<SpawnPointCfg> mSpawnPointList = new List<SpawnPointCfg>();
    private ReadyPoint mActorBornPoint;
    private LogicBattle mLogicBattle;
    private MapItemData mMapItem;
    private int mBattleIdx = -1;
    private int[] pathList = null;
    private int mCurMonsterSpawnPointIdx = 0;
    private SpawnPointCfg mCurrentMonsterSpawnPoint;

    private BossBattleEffect mBattleEffect;
    private CruiseEffect mCruiseEffect;
    private SceneSkyboxMatContainer mSceneSkyboxMatContainer;

    private Tree mTree;
    public float delTime = 2;

    public ReadyPoint ActorBornPoint
    {
        get { return mActorBornPoint; }
    }
   
    public List<SpawnPointCfg> SpawnPointList
    {
        get { return mSpawnPointList; }
    }

    public SpawnPointCfg MapMonsterSpawnPoint
    {
        get
        {
            return mCurrentMonsterSpawnPoint;
        }
    }

    public SpawnPointCfg BossSpawnPoint
    {
        get
        {
            if (mBossSpawnPointList == null || mBossSpawnPointList.Count == 0) return null;
            return mBossSpawnPointList[CurrentBattleInfo.bossBornIdx];
        }
    }

    public LogicBattle Battle { get { return mLogicBattle; } }

    public MapItemData MapData { get { return mMapItem; } }

    public LevelItem CurrentBattleInfo { get; private set; }

    public LogicBattleField CurrentBattleField { get; private set; }

    public GameMode GameMode { get { return mMapItem != null ? mMapItem.gameMode : GameMode.GameMode_Normal; } }

    public GameObject BossIntroCamGo { get; private set; }

    public GameObject SceneRootGo { get; private set; }

    public int CurrentBattleIdx { get { return mBattleIdx; } }

    public bool HasNextBattle { get { return mMapItem != null && mMapItem.battles != null && mBattleIdx + 1 < mMapItem.battles.Length; } }

    SceneObjData[] mObjDataList;
    #endregion

    public LogicBattleScene(LogicBattle battle)
        :base(battle,"")
    {
        mLogicBattle = battle;
        if (mMapItem == null)
        {
            mMapItem = new MapItemData(battle.SceneId,mLogicBattle.CurSceneItem.LevelItems);
            LoadMapSpawnPointCfg(mMapItem.levelname);
            mSceneName = mMapItem.levelname;
        }

        mBattleIdx = battle.StartInfo.StartBattleIdx - 1;
        RegisterEvents();
    }

    public void CreateReplayBattle(int battleIdx)
    {
        CurrentBattleInfo = mMapItem.battles[battleIdx];
        pathList = CurrentBattleInfo.PathList;
        if (pathList == null || pathList.Length == 0)
        {
            pathList = new int[mSpawnPointList.Count];
            for (int idx = 0; idx < pathList.Length; idx++)
            {
                pathList[idx] = idx;
            }
        }
        SelectSpawnPoint();
        CurrentBattleField = CreateBattleField(CurrentBattleInfo.LevelId);
        CurrentBattleField.FieldCenter = mCurrentMonsterSpawnPoint.PointList[1].pos;
        mLogicBattle.SetBattleField(CurrentBattleField);
        mLogicBattle.StartInfo.curLevelItem = CurrentBattleInfo;
        CurrentBattleField.killBoss = true;
        CurrentBattleField.IsPlayingRecorder = true;
    }

    public void ReopenBattle()
    {
        if (mMapItem != null &&
            mMapItem.battles != null &&
            mBattleIdx < mMapItem.battles.Length &&
            mBattleIdx >= 0)
        {
            CurrentBattleInfo = mMapItem.battles[mBattleIdx];
            pathList = CurrentBattleInfo.PathList;
            if (pathList == null || pathList.Length == 0)
            {
                pathList = new int[mSpawnPointList.Count];
                for (int idx = 0; idx < pathList.Length; idx++)
                {
                    pathList[idx] = idx;
                }
            }
            SelectSpawnPoint();
            CurrentBattleField = CreateBattleField(CurrentBattleInfo.LevelId);
            CurrentBattleField.FieldCenter = mCurrentMonsterSpawnPoint.PointList[1].pos;
            mLogicBattle.SetBattleField(CurrentBattleField);
            mLogicBattle.StartInfo.curLevelItem = CurrentBattleInfo;
        }
    }

    public bool NextBattle()
    {
        mBattleIdx++;
        if (mMapItem != null &&
            mMapItem.battles != null &&
            mBattleIdx < mMapItem.battles.Length &&
            mBattleIdx >= 0)
        {
            CurrentBattleInfo = mMapItem.battles[mBattleIdx];
            pathList = CurrentBattleInfo.PathList;
            if (pathList == null || pathList.Length == 0)
            {
                pathList = new int[mSpawnPointList.Count];
                for (int idx = 0; idx < pathList.Length; idx++)
                {
                    pathList[idx] = idx;
                }
            }
            SelectSpawnPoint();
            CurrentBattleField = CreateBattleField(CurrentBattleInfo.LevelId);
            CurrentBattleField.FieldCenter = mCurrentMonsterSpawnPoint.PointList[1].pos;
            mLogicBattle.SetBattleField(CurrentBattleField);

            mLogicBattle.StartInfo.curLevelItem = CurrentBattleInfo;
            return true;
        }
        else
        {
            CurrentBattleInfo = null;
            CurrentBattleField = null;
            mLogicBattle.SetBattleField(null);
            return false;
        }
    }

    public void SelectSpawnPoint()
    {
        if (mSpawnPointList == null) return;

        int idx = pathList[mCurMonsterSpawnPointIdx++];
        if (mCurMonsterSpawnPointIdx >= pathList.Length)
            mCurMonsterSpawnPointIdx = 0;

        if(idx < 0)
        {
            DebugHelper.LogError("mCurMonsterSpawnPointIdx 从pathList中获取的下表小于0"+ mCurMonsterSpawnPointIdx);
            idx = 0;
        }

        mCurrentMonsterSpawnPoint = mSpawnPointList[idx];
    }

    public void SetEffectVisible(bool bossBattle)
    {
        if(bossBattle)
        {
            if(mBattleEffect != null)
            {
                mBattleEffect.gameObject.SetActive(true);
            }
            if(mCruiseEffect != null)
            {
                mCruiseEffect.gameObject.SetActive(false);
            }
        }
        else
        {
            if (mBattleEffect != null)
            {
                mBattleEffect.gameObject.SetActive(false);
            }
            if (mCruiseEffect != null)
            {
                mCruiseEffect.gameObject.SetActive(true);
            }
        }
    }

    public void ChangeSkyboxMat(string matName)
    {
        if (mSceneSkyboxMatContainer == null) return;

        if(mSceneSkyboxMatContainer.ChangeSkyboxMat(matName))
        {
            bRestoreSkyboxDirty = true;
        }
    }

    private bool bRestoreSkyboxDirty = false;
    public void RestoreSkyboxMat()
    {
        if (mSceneSkyboxMatContainer == null) return;


        if (bRestoreSkyboxDirty)
        {
            mSceneSkyboxMatContainer.RestoreSkyboxMat();
            bRestoreSkyboxDirty = false;
        }
    }

    private void RegisterEvents()
    {
        EventMgr.AddEventListener<string>(ECoreEventType.EID_SHOW_SCENE_GO, OnShowSceneGo);
        EventMgr.AddEventListener<bool>(ECoreEventType.EID_RESTORE_SCENE, OnRestoreScene);
        EventMgr.AddEventListener<string>(ECoreEventType.EID_CHAGNE_SKYBOX_MATERIAL, OnChangeSkyboxMat);
    }

    private void UnregisterEvents()
    {
        EventMgr.RemoveEventListener<string>(ECoreEventType.EID_SHOW_SCENE_GO, OnShowSceneGo);
        EventMgr.RemoveEventListener<bool>(ECoreEventType.EID_RESTORE_SCENE, OnRestoreScene);
        EventMgr.RemoveEventListener<string>(ECoreEventType.EID_CHAGNE_SKYBOX_MATERIAL, OnChangeSkyboxMat);
    }

    private void OnChangeSkyboxMat(CoreEvent<string> ce)
    {
        ChangeSkyboxMat(ce.Data);
    }

    private void OnShowSceneGo(CoreEvent<string> ce)
    {
        switchGoName = ce.Data;
        GameObject go = mRootObjs.FindFirst(a => a.name.CompareTo(switchGoName) == 0);
        if (go != null)
            go.SetActive(true);

        if (SceneRootGo != null)
            SceneRootGo.SetActive(false);
    }

    private void OnRestoreScene(CoreEvent<bool> ce)
    {
        GameObject go = mRootObjs.FindFirst(a => a.name.CompareTo(switchGoName) == 0);
        if (go != null)
            go.SetActive(false);

        if (SceneRootGo != null)
            SceneRootGo.SetActive(true);
    }

    public override void OnSceneLoaded()
    {
        mRootObjs = mScene.GetRootGameObjects();

        for(int idx =0; idx < mRootObjs.Length;idx++)
        {
            if(mCruiseEffect == null)
                mCruiseEffect = mRootObjs[idx].GetComponentInChildren<CruiseEffect>();

            if (mBattleEffect == null)
                mBattleEffect = mRootObjs[idx].GetComponentInChildren<BossBattleEffect>();

            if (mCruiseEffect != null && mBattleEffect != null)
                break;
        }

        SceneRootGo =  mRootObjs.FindFirst(a => a.name.CompareTo(scene_root_name) == 0);
        if(SceneRootGo!=null)
        {
            mSceneSkyboxMatContainer = SceneRootGo.GetComponentInChildren<SceneSkyboxMatContainer>();
            SceneRoot root = SceneRootGo.GetComponent<SceneRoot>();
            if(root != null)
            {
                mObjDataList = SceneRootGo.GetComponentsInChildren<SceneObjData>();
                if (mObjDataList != null && mObjDataList.Length > 0)
                {
                    if (mTree == null)
                    {
                        mTree = new Tree(root.mainBound);
                        for (int idx = 0; idx < mObjDataList.Length; idx++)
                        {
                            mTree.InsertObj(mObjDataList[idx]);
                        }

                        root.T = mTree;
                        root.InitEnd = true;
                    }
                }
            }
        }

        BossIntroCamGo = mRootObjs.FindFirst(a => a.name.CompareTo(bossintro_camera_go) == 0);

        GameObject spawnPoint = mRootObjs.FindFirst(a => a.name.CompareTo(Constants.actor_born_point) == 0);
        if (spawnPoint != null)
        {
            mActorBornPoint = spawnPoint.GetComponent<ReadyPoint>();
        }
    }

    private void LoadMapSpawnPointCfg(string sceneName)
    {
        string ta = ConfigMgr.Instance.GetXmlCfg("Born_" + sceneName);
        if (ta == null)
        {
            DebugHelper.LogError(sceneName + " 出生点文件不存在");
            return;
        }

        mSpawnPointList.Clear();
        mBossSpawnPointList.Clear();

        Mono.Xml.SecurityParser doc = new Mono.Xml.SecurityParser();
        try
        {
            doc.LoadXml(ta);
        }
        catch (System.Exception e)
        {
            DebugHelper.Assert(false, "exception = {0}", e.Message);
            return;
        }

        System.Security.SecurityElement root = doc.SelectSingleNode("SpawnPoints");
        if (root == null || root.Children == null) return;

        for (int idx = 0; idx < root.Children.Count; idx++)
        {
            var spNode = root.Children[idx] as System.Security.SecurityElement;
            SpawnPointCfg spCfg = new SpawnPointCfg();
            spCfg.LoadCfgXml(spNode);
            if (spCfg.PointType == SpawnPointType.Boss)
            {
                mBossSpawnPointList.Add(spCfg);
            }
            else
            {
                mSpawnPointList.Add(spCfg);
            }
        }

        //DebugHelper.LogError("----------------LoadMapSpawnPointCfg----------------");
    }

    private LogicBattleField CreateBattleField (int fieldId)
	{
		return new LogicBattleField (mLogicBattle, CurrentBattleInfo);
	}

    public override void SetSceneOjbVis(SceneObjData obj)
    {
        float dist = Vector3.Distance(obj.Center, mBattle.CurBattleField.TeamFighters[0].Position);
        if (dist < 60)
        {
            CommonUtil.SetGameObjectLayer(obj.gameObject, BattleCamera.defalutLayer);
        }
        else
        {
            CommonUtil.SetGameObjectLayer(obj.gameObject, BattleCamera.hideLayer);
        }
    }

    public void UpdateSceneTree(Vector3 pos)
    {
        if (mTree != null)
        {
            mTree.TriggerMove(BattleCamera.Instance.RealCamera, this);
        }
    }

    public override void Dispose()
    {
        if (IsDisposed)
            return;

        base.Dispose();

        mObjDataList = null;
        UnregisterEvents();
        mRootObjs = null;
        mMapItem = null;
        mLogicBattle = null;
        mBattleIdx = -1;
        CurrentBattleInfo = null;
        CurrentBattleField = null;
        mCurMonsterSpawnPointIdx = 0;
        mCurrentMonsterSpawnPoint = null;

        if (mActorBornPoint != null)
        {
            mActorBornPoint.Dispose();
            mActorBornPoint = null;
        }

        mSpawnPointList.Clear();
        mBossSpawnPointList.Clear();
    }

}
