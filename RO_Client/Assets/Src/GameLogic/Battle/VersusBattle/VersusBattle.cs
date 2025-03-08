using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 英灵殿战斗逻辑
/// </summary>
public class VersusBattle : BaseBattle
{
    #region fields
    private VersusBattleField mVersusBattleField;
    private VersusBattleState mState;
    private List<ActorData> mOwnActors;
    private List<ActorData> mEnemyActors;
    private List<ActorData> mOurPlayerActors;
    private List<ActorData> mEnemyPlayerActors;

    private TowerTeamBornInfo mTeamBornInfo;
    private ReadyPoint mActorReadyPoint;
    private ReadyPoint mEnemyReadyPoint;
    private string mSceneName;

    public VersusBattleScene BattleScene { get; set; }

    public VersusBattleStateType CurrentState
    {
        get { return mState == null ? VersusBattleStateType.None : mState.State; }
        set
        {
            if (CurrentState == value)
                return;
            int oldState = (int)CurrentState;
            if (mState != null)
                mState.OnLeave();
            mState = VersusBattleState.Create(this, value);
            if (mState != null)
                mState.OnEnter();
        }
    }

    public Vector3 BornCamPos
    {
        get { return mTeamBornInfo.camPos; }
    }

    public Vector3 BornCamRot
    {
        get { return mTeamBornInfo.camRot; }
    }

    public Vector3 BornCenter
    {
        get
        {

            Vector3 min = Vector3.zero;
            Vector3 max = Vector3.zero;
            bool hasSet = false;
            for (int idx = 0; idx < mTeamBornInfo.bornPosList.Length; idx++)
            {
                Vector3 p = mTeamBornInfo.bornPosList[idx];
                if (!hasSet)
                {
                    min = p;
                    max = p;
                    hasSet = true;
                }
                else
                {
                    min = Vector3.Min(p, min);
                    max = Vector3.Max(p, max);
                }
            }

            return 0.5f * (min + max) + Vector3.up * 1.0f;
        }
    }

    public float BornCamFov
    {
        get { return mTeamBornInfo.fov; }
    }

    public string SceneName
    {
        get { return mSceneName; }
    }

    public string BgMusic
    {
        get
        {
            return "";
        }
    }

    public override List<ActorData> TeamActors
    {
        get { return mOwnActors; }
    }

    public override List<ActorData> EnemyActors
    {
        get { return mEnemyActors; }
    }

    public override List<ActorData> TeamPlayerActors
    {
        get { return mOurPlayerActors; }
    }

    public override List<ActorData> EnemyPlayerActors
    {
        get { return mEnemyPlayerActors; }
    }

    private BattleSubMode mVersusBattleMode;
    public override BattleSubMode SubBattleMode
    {
        get { return mVersusBattleMode; }
    }
    public bool IsShowPressPointEffect
    {
        get { return mbIsPresspoint; }
    }
    private bool mbIsPresspoint = false;//是否被压制 用于显示压制特效
    private GvGMark[] mArrayGvGMark = null;
    private GvGMark[] mArrayEnemyGvGMark = null;
    #endregion

    
    public VersusBattle(BattleSubMode mode, TowerBattleInfo bi, ActorData[] ownActors, ActorData[] enemyActors, string sceneName, float maxBattlingTime, List<BattleEndCondition> endCondList,GvGMark[] OurMarks,GvGMark[] EnemyMarks,bool IsPresspoint
        ,int nPresspoint)
        : base(BattleMode.Versus, endCondList)
    {
        mbIsPresspoint = IsPresspoint;
        mVersusBattleMode = mode;
        IsLogicOnly = true;
        mSceneName = sceneName;
        mTeamBornInfo = TowerBattleCfgMgr.Instance.TeamBornData;
        FighterLifeRatio = GetLifeRatio(nPresspoint);
        BattleBeginMarkId = GlobalConfig.Instance.GetConfigIntValue(290);
        CreateTowerBattleField(bi, ownActors, enemyActors, maxBattlingTime);
        SortActors();
        if (null == OurMarks)
        {
            mArrayGvGMark = null;
        }
        else
        {
            mArrayGvGMark = new GvGMark[OurMarks.Length];
            for (int idx = 0; idx < OurMarks.Length; idx++)
            {
                mArrayGvGMark[idx] = OurMarks[idx];
            }
        }
        if (null == EnemyMarks)
        {
            mArrayEnemyGvGMark = null;
        }
        else
        {
            mArrayEnemyGvGMark = new GvGMark[EnemyMarks.Length];
            for (int idx = 0; idx < EnemyMarks.Length; idx++)
            {
                mArrayEnemyGvGMark[idx] = EnemyMarks[idx];
            }
        }
    }
    //根据压制差 计算生命系数
    private float GetLifeRatio(int nValue)
    {
        float fRatio = 1.0f;
        string strCfg = GlobalConfig.Instance.GetConfigStrValue(181);
        string[] ListRange = strCfg.Split(';');
        for (int i = 0; i < ListRange.Length; i++)
        {
            string[] info = ListRange[i].Split(':');
            if (info.Length < 2)
            {
                Debug.LogError("Global 181 配置错误！");
                continue;
            }
            int nRange = 0;
            float fRangeRatio = 1.0f;
            bool bIsOk = int.TryParse(info[0], out nRange) && float.TryParse(info[1], out fRangeRatio);
            if (!bIsOk)
            {
                Debug.LogError("Global 181 解析错误！");
                continue;
            }
            if (nValue >= nRange)
            {
                fRatio = fRangeRatio;
            }
        }

        return fRatio;
    }

    private void SortActors()
    {
        if (mOurPlayerActors == null)
        {
            mOurPlayerActors = new List<ActorData>();
        }
        else
        {
            mOurPlayerActors.Clear();
        }

        for (int idx = 0; idx < mOwnActors.Count; idx++)
        {
            if (!mOwnActors[idx].IsPet)
            {
                mOurPlayerActors.Add(mOwnActors[idx]);
            }
        }

        if (mEnemyPlayerActors == null)
        {
            mEnemyPlayerActors = new List<ActorData>();
        }
        else
        {
            mEnemyPlayerActors.Clear();
        }

        for (int idx = 0; idx < mEnemyActors.Count; idx++)
        {
            if (!mEnemyActors[idx].IsPet)
            {
                mEnemyPlayerActors.Add(mEnemyActors[idx]);
            }
        }
    }

    public override void Start(int randSeed = 0, ValType[] factors = null)
    {
        base.Start(randSeed, factors);
        CurrentState = VersusBattleStateType.Start;
    }

    public override void Update(float deltaTime)
    {
        base.Update(deltaTime);

        if (mState != null)
            mState.Update(deltaTime);
    }

    public override void Dispose()
    {
        base.Dispose();
        if (BattleScene != null)
        {
            BattleScene.Dispose();
            BattleScene = null;
        }
    }

    public override void ShutDown()
    {
        if (fieldPoint != null)
        {
            GameObject.Destroy(fieldPoint);
            fieldPoint = null;
        }
        base.ShutDown();
        CurrentState = VersusBattleStateType.None;
        mVersusBattleField = null;
        mTeamBornInfo = null;
        mActorReadyPoint = null;
        mEnemyReadyPoint = null;
        if (mOwnActors != null)
            mOwnActors.Clear();

        if (mEnemyActors != null)
            mEnemyActors.Clear();

        mOwnActors = null;
        mEnemyActors = null;
    }

    //跑向战场
    public override void MoveToNextBattleField(bool setStopDistance)
    {
        if (mVersusBattleField == null) return;

        for (int idx = 0; idx < FighterMgr.TeamFighters.Count; idx++)
        {
            Fighter f = FighterMgr.TeamFighters[idx];

            if (f.IsPlayer)
            {
                var pointCfg = mActorReadyPoint.GetReadyPointPos(f.Actor.Profession, f.ReadyPosOrder);
                f.Ctrl.EnableNavAgent(true);
                f.AutoMoveTo(pointCfg.heroPos);
                f.SyncPetMoveDestPos(pointCfg.petPos, true, true);
            }
        }

        for (int idx = 0; idx < FighterMgr.EnemyFighters.Count; idx++)
        {
            Fighter f = FighterMgr.EnemyFighters[idx];
            if (f.IsPlayer)
            {
                var pointCfg = mEnemyReadyPoint.GetReadyPointPos(f.Actor.Profession, f.ReadyPosOrder);
                f.Ctrl.EnableNavAgent(true);
                f.AutoMoveTo(pointCfg.heroPos);
                f.SyncPetMoveDestPos(pointCfg.petPos, true, true);
            }
        }
    }

    public void SetVersusActors(ActorData[] ownActors, ActorData[] enemyActors, float maxBattlingTime)
    {
        TowerBattleInfo bi = TowerBattleCfgMgr.Instance.GetTowerBattleInfo();
        CreateTowerBattleField(bi, ownActors, enemyActors, maxBattlingTime);

        FighterMgr.AddFighters(TeamActors.ToArray(), eTeamType.Friend);
        FighterMgr.AddFighters(EnemyActors.ToArray(), eTeamType.Enemy);
        FighterMgr.ParseLoad();

        EventMgr.AddEventListener<bool>(ECoreEventType.EID_PREPARE_LOAD_OK, OnPrepareLoadOk);
        BattlePrepareManager.Instance.StartLoad();
    }

    public void SetReadyPoint(ReadyPoint ownPoint, ReadyPoint enemyPoint)
    {
        mActorReadyPoint = ownPoint;
        mEnemyReadyPoint = enemyPoint;
    }

    private GameObject fieldPoint = null;
    public void CreateTowerBattleField(TowerBattleInfo bi, ActorData[] ownActors, ActorData[] enemyActors, float maxBattlingTime)
    {
        if (mOwnActors == null)
            mOwnActors = new List<ActorData>();
        else
            mOwnActors.Clear();

        if (mEnemyActors == null)
            mEnemyActors = new List<ActorData>();
        else
            mEnemyActors.Clear();

        for (int idx = 0; idx < ownActors.Length; idx++)
        {
            var actor = ownActors[idx];
            mOwnActors.Add(actor);
            if (actor.HasPet)
                mOwnActors.Add(actor.PetData);
        }

        for (int idx = 0; idx < enemyActors.Length; idx++)
        {
            var actor = enemyActors[idx];
            mEnemyActors.Add(actor);
            if (actor.HasPet)
                mEnemyActors.Add(actor.PetData);
        }

        if (mVersusBattleField != null)
        {
            //DebugHelper.LogError("CNT:" + FighterMgr.AllFighters.Count);
            if (FighterMgr.AllFighters.Count > 0)
            {
                for (int idx = FighterMgr.AllFighters.Count - 1; idx >= 0; idx--)
                {
                    Fighter f = FighterMgr.AllFighters[idx];
                    f.Destroy();
                    FighterMgr.RemoveFighter(f);
                }
            }
        }

        mVersusBattleField = new VersusBattleField(this, bi, maxBattlingTime);
        SetBattleField(mVersusBattleField);

#if UNITY_EDITOR
        if (fieldPoint == null)
        {

            fieldPoint = GameObject.CreatePrimitive(PrimitiveType.Cube);
            fieldPoint.name = "fieldPoint";
            fieldPoint.layer = LayerMask.NameToLayer("Hide");
            fieldPoint.transform.SetParent(BattleMgr.Instance.transform);
        }
        fieldPoint.transform.position = mVersusBattleField.battleInfo.fieldPos;
        fieldPoint.transform.forward = mVersusBattleField.battleInfo.fieldForward;
        fieldPoint.transform.rotation = Quaternion.Euler(mVersusBattleField.battleInfo.fieldRot);
#endif
    }

    public void StartVersus()
    {
        if (CurrentState != VersusBattleStateType.Battle) return;

        if (mVersusBattleField == null) return;

        if (!mVersusBattleField.IsIdleState) return;

        mVersusBattleField.Start();
    }

    public void BackToBorn()
    {
        BackCamToBorn();

        if (mVersusBattleField == null) return;
    }

    public void CreateTeamFighters()
    {
        if (mActorReadyPoint == null) return;

        for (int idx = 0; idx < FighterMgr.TeamHeroFighters.Count; idx++)
        {
            Fighter fighter = FighterMgr.TeamHeroFighters[idx];
            fighter.Spawn(mTeamBornInfo.bornPosList[idx], mTeamBornInfo.forward, Quaternion.identity);
            fighter.LookAt(mTeamBornInfo.camPos);
            if (fighter.Actor.HasPet)
            {
                Fighter pet = FighterMgr.GetTeamMemberById(fighter.Actor.PetData.ID);
                pet.Spawn(mTeamBornInfo.bornPosList[idx], mTeamBornInfo.forward, Quaternion.identity);
                pet.OwnerId = fighter.Id;
                fighter.UsedPetId = pet.Id;
            }
        }
    }

    public void CreateEnemyFighters()
    {
        if (mEnemyReadyPoint == null) return;

        CalcStartPos();
        for (int idx = 0; idx < FighterMgr.EnemyFighters.Count; idx++)
        {
            Fighter f = FighterMgr.EnemyFighters[idx];
            if (f.IsPlayer)
            {
                var pointCfg = mEnemyReadyPoint.GetReadyPointPos(f.Actor.Profession, f.ReadyPosOrder);
                f.Spawn(pointCfg.heroPos, mVersusBattleField.battleInfo.fieldForward, Quaternion.Euler(mVersusBattleField.battleInfo.fieldRot));

                if (f.Actor.HasPet)
                {
                    Fighter pet = FighterMgr.GetFighterByID(f.Actor.PetData.ID, eTeamType.Enemy);
                    pet.Spawn(pointCfg.petPos, mVersusBattleField.battleInfo.fieldForward, Quaternion.Euler(mVersusBattleField.battleInfo.fieldRot));
                    pet.OwnerId = f.Id;
                    f.UsedPetId = pet.Id;
                }
            }
        }
    }

    public void AddBattleMarkToFighter(Fighter f)
    {
        GvGMark[] ArrayMark = f.TeamSide == eTeamType.Friend ? mArrayGvGMark : mArrayEnemyGvGMark;
        if (null != ArrayMark)
        for (int i = 0; i < ArrayMark.Length; i++)
        {
            f.AddMark(ArrayMark[i].m_nMarkid, ArrayMark[i].m_nMarkNum);          
        }
    }

    public void AddBattleMark()
    {
        //if (SubBattleMode != BattleSubMode.Arena)
        //    return;
        if (null != mArrayGvGMark)
        for (int idx = 0; idx < FighterMgr.AllFighters.Count; idx++)
        {
            Fighter f = FighterMgr.AllFighters[idx];
            AddBattleMarkToFighter(f);          
        }   
    }

    public void SetSpawnedFighterPosition()
    {
        Vector3 rot = mVersusBattleField.battleInfo.fieldRot;
        rot.y = 180 + rot.y;

        CalcStartPos();

        for (int idx = 0; idx < FighterMgr.TeamHeroFighters.Count; idx++)
        {
            Fighter f = FighterMgr.TeamHeroFighters[idx];
            var pointCfg = mActorReadyPoint.GetReadyPointPos(f.Actor.Profession, f.ReadyPosOrder);
            f.SyncPosition(pointCfg.heroPos);
            f.SetRotation(Quaternion.Euler(rot));
            if (f.Actor.HasPet)
            {
                Fighter pet = FighterMgr.GetTeamMemberById(f.Actor.PetData.ID);
                pet.SyncPosition(pointCfg.petPos); ;
                pet.SetRotation(Quaternion.Euler(rot));
                pet.OwnerId = f.Id;
                f.UsedPetId = pet.Id;
            }
        }

        for (int idx = 0; idx < FighterMgr.EnemyFighters.Count; idx++)
        {
            Fighter f = FighterMgr.EnemyFighters[idx];
            if (f.IsPlayer)
            {
                var pointCfg = mEnemyReadyPoint.GetReadyPointPos(f.Actor.Profession, f.ReadyPosOrder);
                f.SyncPosition(pointCfg.heroPos);
                f.SetRotation(Quaternion.Euler(mVersusBattleField.battleInfo.fieldRot));
                if (f.Actor.HasPet)
                {
                    Fighter pet = FighterMgr.GetFighterByID(f.Actor.PetData.ID, eTeamType.Enemy);
                    pet.SyncPosition(pointCfg.petPos);
                    pet.SetRotation(Quaternion.Euler(mVersusBattleField.battleInfo.fieldRot));
                    pet.OwnerId = f.Id;
                    f.UsedPetId = pet.Id;
                }
            }
        }

        CalcFighterReadyPos();
        SetCameraInBattleField();
    }

    public void CalcStartPos()
    {
        Vector3 center = center = mVersusBattleField.battleInfo.fieldPos + mVersusBattleField.battleInfo.fieldForward * mVersusBattleField.battleInfo.spawnDist;
        Vector3 rot = mVersusBattleField.battleInfo.fieldRot;
        rot.y = 180 + rot.y;
        mActorReadyPoint.CalcNextBattleFieldPoints(center, rot);

        center = mVersusBattleField.battleInfo.fieldPos - mVersusBattleField.battleInfo.fieldForward * mVersusBattleField.battleInfo.spawnDist;
        mEnemyReadyPoint.CalcNextBattleFieldPoints(center, mVersusBattleField.battleInfo.fieldRot);
    }

    public void CalcFighterReadyPos()
    {
        if (mVersusBattleField == null || mActorReadyPoint == null || mEnemyReadyPoint == null) return;

        Vector3 center = mVersusBattleField.battleInfo.fieldPos + mVersusBattleField.battleInfo.fieldForward * mVersusBattleField.battleInfo.battleDist;
        Vector3 rot = mVersusBattleField.battleInfo.fieldRot;
        rot.y = 180 + rot.y;
        mActorReadyPoint.CalcNextBattleFieldPoints(center, rot);

        center = mVersusBattleField.battleInfo.fieldPos - mVersusBattleField.battleInfo.fieldForward * mVersusBattleField.battleInfo.battleDist;
        mEnemyReadyPoint.CalcNextBattleFieldPoints(center, mVersusBattleField.battleInfo.fieldRot);
    }

    private float mCamMoveSpeed = 0;
    private float mCamRotSpeed = 0;
    private float mCamFovSpeed = 0;

    public void MoveCamToBattleField()
    {
        //MapCameraConfig camCfg = mTowerBattleField.battleInfo.cameraConfig;
        //mCamMoveSpeed = camCfg.moveSpeed;
        //mCamRotSpeed = camCfg.rotSpeed;
        //mCamFovSpeed = camCfg.fovSpeed;
        //BattleCamera.Instance.SetCameraTweeningMove(camCfg.pos, mTowerBattleField.battleInfo.fieldPos, camCfg.fov, mCamMoveSpeed, mCamRotSpeed, mCamFovSpeed);

    }

    public void BackCamToBorn()
    {
        BattleCamera.Instance.SetCamera(BornCamPos, BornCenter, BornCamRot, BornCamFov);
    }

    public void CleanAllFighter()
    {
        if (mVersusBattleField == null) return;

        for (int idx = mVersusBattleField.Fighters.Count - 1; idx >= 0; idx--)
        {
            var f = mVersusBattleField.Fighters[idx];
            FighterMgr.RemoveFighter(f);
            f.Destroy();
        }
    }

    public void SetCameraInBattleField()
    {
        var bi = mVersusBattleField.battleInfo;
        Quaternion tempQuaternion = Quaternion.identity;
        tempQuaternion.eulerAngles = bi.fieldRot;

        //Vector3 targetForward = (tempQuaternion * Vector3.forward).normalized;
        //Vector3 targetFocus = mTowerBattleField.TeamFocus;
        Vector3 targetPos = bi.fieldPos + BattleCamera.Instance.CamCfg.followCamOffset;
        BattleCamera.Instance.SetCamera(targetPos, targetPos, bi.fieldRot, 75);
    }

    private void OnPrepareLoadOk(CoreEvent<bool> ce)
    {
        if (ce.Data)
        {
            EventMgr.RemoveEventListener<bool>(ECoreEventType.EID_PREPARE_LOAD_OK, OnPrepareLoadOk);
            CreateTeamFighters();
            CreateEnemyFighters();
        }
    }

}
