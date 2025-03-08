using UnityEngine;
using System.Collections.Generic;

//战斗结束传递信息
public class BattleEndInfo
{
    public bool IsPlayRecord { get; set; }
}

/// <summary>
///挂机战斗逻辑
/// </summary>
public class LogicBattle : BaseBattle
{
    LogicBattleStartInfo mStartInfo;
    LogicBattleState mState;
    #region properties

    public float PreviousFightingTime { get; set; }  //上一次的战斗时长

    public int SceneId { get { return mStartInfo.SceneId; } }

    public int LevelId { get { return mStartInfo.LevelId; } }

    public int LevelType { get { return mStartInfo.LevelType; } }

    public override LevelItem CurLevelItem { get { return mStartInfo.curLevelItem; } }

    public SceneItem CurSceneItem { get { return mStartInfo.curSceneItem; } }

    public LogicBattleField CurrentBattleField { get { return BattleScene.CurrentBattleField; } }

    public LogicBattleStartInfo StartInfo { get { return mStartInfo; } }

    public LogicBattleScene BattleScene { get; set; }

    public override List<ActorData> MyFighters { get { return mStartInfo.GetMyFighters(); } }

    public override List<ActorData> EnemyFighters { get { return mStartInfo.GetEnemyFighters(BattleScene); } }

    private List<ActorData> mTeamPlayerActors;
    public override List<ActorData> TeamPlayerActors
    {
        get { return mTeamPlayerActors; }
    }

    public GameMode GameMode { get { return BattleScene.GameMode; } }

    public Transform TeamCenterPoint
    {
        get; private set;
    }

    public string BgMusic { get { return BattleScene.MapData == null || string.IsNullOrEmpty(BattleScene.MapData.bgmusic)
            ? MusicMgr.music_battle_default : BattleScene.MapData.bgmusic; } }

    public LogicBattleStateType CurrentState
    {
        get { return mState == null ? LogicBattleStateType.None : mState.State; }
        set
        {
            if (CurrentState == value)
                return;
            int oldState = (int)CurrentState;
            if (mState != null)
                mState.OnLeave();
            mState = LogicBattleState.Create(this, value);
            if (mState != null)
                mState.OnEnter();
        }
    }

    public int BattleIdx { get { return BattleScene.CurrentBattleIdx; } }

    public override int CurLevelMonsterLv
    {
        get { return CurLevelItem != null ? CurLevelItem.MonsterLv : 1; }
    }

    public override Vector3 BattleBossCamPos
    {
        get { return CurrentBattleField.CurrentWavePoint.BossCamPos; }
    }

    public override Vector3 BattleBossCamRot
    {
        get { return CurrentBattleField.CurrentWavePoint.BossCamRot; }
    }

    public override float BattleCamFar
    {
        get { return CurrentBattleField.CurrentWavePoint.CamFar; }
    }

    public override bool IsKillingBoss
    {
        get { return CurrentBattleField.killBoss; }
    }

    public bool IsAllFighterIdle
    {
        get { return CurrentBattleField.bIsAllFighterIdle(); }
    }

    private bool bNeedBackToLastPos = false;
    public bool NeedBackToLastPos
    {
        get { return bNeedBackToLastPos; }
        set { bNeedBackToLastPos = value; }
    }

    public Vector3 BackToPos
    {
        get;set;
    }
    #endregion //properties

    public LogicBattle(LogicBattleStartInfo startData, bool logicOnly, List<BattleEndCondition> endCondList)
        :base(BattleMode.Normal,endCondList)
    {
        IsLogicOnly = logicOnly;
        mStartInfo = startData;
    }

    public override void Start(int randSeed = 0, ValType[] factors = null)
    {
        base.Start(randSeed,factors);
        ChallengeBoss = false;
        CurrentState = LogicBattleStateType.Start;
        BattleMgr.Instance.SyncTeams(false);
        if (TeamCenterPoint == null)
        {
            GameObject point = new GameObject("TeamCenterPoint");
            point.layer = LayerMask.NameToLayer("Hide");
            TeamCenterPoint = point.transform;
            GameObject.DontDestroyOnLoad(point);
        }
    }

    public override void Update(float deltaTime)
    {
        base.Update(deltaTime);

        if(TeamCenterPoint!=null && !BattleMgr.Instance.IsRotatingCam)
        {
            TeamCenterPoint.position = TeamCenter;
        }

#if PROFILE
        UnityEngine.Profiling.Profiler.BeginSample("LogicBattleState Update:"+ mState.ToString());
#endif        
        if (mState != null)
            mState.Update(deltaTime);
#if PROFILE
        UnityEngine.Profiling.Profiler.EndSample();
#endif
        
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
        if (TeamCenterPoint != null)
        {
            GameObject.Destroy(TeamCenterPoint.gameObject);
            TeamCenterPoint = null;
        }

        base.ShutDown();
        CurrentState = LogicBattleStateType.None;
        mStartInfo = null;
    }

    public override void EnterNextBattle()
    {
        SetRandSeed(Random.Range(1, int.MaxValue));
        BattleScene.NextBattle();
        StartBattleField();
        if (BattleIdx > 0)
        {
            EventMgr.DispatchEvent<string>(new CoreEvent<string>(ECoreEventType.EID_BATTLE_NEW_NEXT_WAVE, CurrentBattleField.BattleInfo.Name));
        }
        if(BattleMgr.Instance.Battle.CanPrintLog)
        {
            DebugHelper.LogError("curMapId:" + CurLevelItem.MapId + " curLevelId:" + CurLevelItem.LevelId);
        }
    }

    public override void ContinueCurrentBattle()
    {
        SetRandSeed(Random.Range(1, int.MaxValue));
        BattleScene.ReopenBattle();
        StartBattleField();
        EventMgr.DispatchEvent<bool>(new CoreEvent<bool>(ECoreEventType.EID_BATTLE_CONTINUE_WAVE, true));
    }


    void StartBattleField()
    {
        if (CurrentBattleField != null)
        {
            BackToLastPos();
            CurrentBattleField.Start();
        }
    }

    public override void MoveToNextBattleField(bool setStopDistance)
    {
        if (CurrentBattleField == null) return;

        ReadyPoint nextWaveSP = BattleScene.ActorBornPoint;
        List<Fighter> heros = FighterMgr.TeamHeroFighters;

        for (int idx = 0; idx < heros.Count && idx < 4; idx++)
        {
            Fighter hero = heros[idx];
            if (hero.IsDestroy || hero.IsDisposed)
                continue;
            hero.Ctrl.EnableNavAgent(true);
            float stopDist = setStopDistance ? CurrentBattleField.CurrentWavePoint.ActorReadyDist : 0;

            var pointCfg = nextWaveSP.GetReadyPointPos(hero.Actor.Profession, hero.ReadyPosOrder);
            Vector3 destPos = pointCfg.heroPos;
            hero.AutoMoveTo(destPos);
            hero.SyncPetMoveDestPos(pointCfg.petPos, true, true);
        }
    }

    public void ReadyTransfer()
    {
        List<Fighter> members = FighterMgr.TeamFighters;
        for (int idx = 0; idx < members.Count; idx++)
        {
            Fighter member = members[idx];
            member.Ctrl.OnEnterTransfer();
            member.Ctrl.EnableNavAgent(false);
            member.ForceIdle();
        }
        BattleCamera.Instance.DisableDynamicCamera();
        int effectId = GlobalConfig.Instance.GetConfigIntValue(GlobalConfig.c_transfer_effectid);
        if(effectId > 0)
        {
            EffectManager.Instance.PlayEffect(effectId);
        }
    }

    //拉到传送点
    public void GoToTransferPoint()
    {
        ReadyPoint nextWaveSp = BattleScene.ActorBornPoint;

        List<Fighter> heros = FighterMgr.TeamHeroFighters;
        for (int idx = 0; idx < heros.Count; idx++)
        {
            Fighter hero = heros[idx];
            var pointCfg = nextWaveSp.GetReadyPointPos(hero.Actor.Profession, hero.ReadyPosOrder);
            hero.SyncPosition(pointCfg.heroPos);
            hero.SyncPetPosition(pointCfg.petPos);
        }

        Vector3 forward = CurrentBattleField.EnemyFighters[0].Ctrl.transform.forward;
        Vector3 rot = CurrentBattleField.CurrentWavePoint.Rot;
        rot.y = 180 + rot.y;

        Vector3 center = CurrentBattleField.CurrentWavePoint.Pos + forward * CurrentBattleField.CurrentWavePoint.ActorReadyDist;
        CurrentBattleField.Battle.BattleScene.ActorBornPoint.CalcNextBattleFieldPoints(center, rot);
        BattleMgr.Instance.SetBossBattleCamera();
    }

    //回到传送之前的位置点
    public void BackToLastPos()
    {
        if (!bNeedBackToLastPos) return;

        Vector3 rot = BattleScene.MapMonsterSpawnPoint.Rot;
        rot.y = 180 + rot.y;
        BattleScene.ActorBornPoint.CalcNextBattleFieldPoints(BackToPos, rot);

        List<Fighter> Heros = FighterMgr.TeamHeroFighters;
        for (int idx = 0; idx < Heros.Count && idx < 4; idx++)
        {
            Fighter hero = Heros[idx];
            hero.Ctrl.EnableNavAgent(false);

            var pointCfg = BattleScene.ActorBornPoint.GetReadyPointPos(hero.Actor.Profession, hero.ReadyPosOrder);
            hero.SyncPosition(pointCfg.heroPos);
            hero.SyncPetPosition(pointCfg.petPos,true,false);
        }
        BattleMgr.Instance.SetFollowCamera(BattleScene.ActorBornPoint.transform.forward,true);
    }

    public override bool IsAllFightersReady()
    {
        List<Fighter> Members = FighterMgr.TeamFighters;

        for (int idx = 0; idx < Members.Count; idx++)
        {
            if (!Members[idx].IsIdle)
                return false;
        }
        return true;
    }

    public bool IsSelfReady()
    {
        List<Fighter> Members = FighterMgr.TeamFighters;
        if (Members.Count == 0) return false;
        return Members[0].IsIdle;
    }

    public void  CheckTeamPlayerActors()
    {
        if(mTeamPlayerActors == null)
        {
            mTeamPlayerActors = new List<ActorData>();
        }
        else
        {
            mTeamPlayerActors.Clear();
        }

        for(int idx =0; idx < FighterMgr.TeamFighters.Count;idx++)
        {
            if (!FighterMgr.TeamFighters[idx].IsPet)
            {
                mTeamPlayerActors.Add(FighterMgr.TeamFighters[idx].Actor);
            }
        }
    }

    int actorCnt = 0;
    int curLoadCnt = 0;
    public override bool AddNewActors(List<ActorData> actors,eTeamType teamside=eTeamType.Friend,bool spawn =true)
    {
        if (actors == null || actors.Count == 0) return false;

        List<ActorData> tempPetActors = new List<ActorData>();
        for(int idx =0; idx < actors.Count;idx++)
        {
            if(actors[idx].HasPet)
            {
                tempPetActors.Add(actors[idx].PetData);
            }
        }

        //销毁 现有队伍中不存在 或者 已转职的角色 (包括其宠物) 否则重置数据
        for(int idx = FighterMgr.TeamHeroFighters.Count-1; idx >=0;idx--)
        {
            Fighter f = FighterMgr.TeamHeroFighters[idx];
            ActorData ad = NeedRemove(actors, f.Actor);
            if (ad == null || ad.IsTransferred)
            {
                if(ad == null && f.UsedPetId > 0)
                {
                    Fighter pet = FighterMgr.GetTeamMemberById(f.UsedPetId);
                    pet.Destroy();
                    FighterMgr.RemoveFighter(pet);
                }
                f.Destroy();
                FighterMgr.RemoveFighter(f);
            }
            else
            {
                f.ResetActor(ad);
            }
        }

        for (int idx = actors.Count - 1; idx >= 0; idx--)
        {
            if (FighterMgr.HasTeamHero(actors[idx].ID) && !actors[idx].IsTransferred)
            {
                actors.RemoveAt(idx);
            }
        }

        //删除在新数据中不存在的宠物 同步已有宠物信息
        for (int idx = FighterMgr.TeamPetFighters.Count -1;idx>=0;idx--)
        {
            Fighter pet = FighterMgr.TeamPetFighters[idx];
            ActorData petData = NeedRemove(tempPetActors, pet.Actor);
            if(petData == null)
            {
                pet.Destroy();
                FighterMgr.RemoveFighter(pet);
            }
            else
            {
                pet.ResetActor(petData);
            }
        }
        //删除新数据 已经同步过得宠物数据
        for(int idx = tempPetActors.Count -1; idx >= 0;idx--)
        {
            if (FighterMgr.HasPet(tempPetActors[idx].ID))
            {
                tempPetActors.RemoveAt(idx);
            }
        }

        actorCnt = actors.Count + tempPetActors.Count;
        if(actorCnt > 0)//创建新数据角色
        {
            fighterResOk = false;
            FighterMgr.AddFighters(actors.ToArray(), teamside);
            FighterMgr.AddFighters(tempPetActors.ToArray(), teamside);

            for(int idx =0; idx < FighterMgr.TeamHeroFighters.Count;idx++)
            {
                if(FighterMgr.TeamHeroFighters[idx].Actor.PetData!=null)
                {
                    var pet = FighterMgr.GetTeamMemberById(FighterMgr.TeamHeroFighters[idx].Actor.PetData.ID);
                    pet.OwnerId = FighterMgr.TeamHeroFighters[idx].Id;
                    FighterMgr.TeamHeroFighters[idx].UsedPetId = pet.Id;
                }
            }

            curLoadCnt = 0;
            IsLoadingActor = true;
            EventMgr.DispatchEvent<bool>(new CoreEvent<bool>(ECoreEventType.EID_FIGHTERS_LOAD_OK, false));
            EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_FIGHTER_ASYNC_LOADED, OnFighterAsyncLoaded);
            for (int idx = 0; idx < actors.Count; idx++)
            {
                Fighter f = FighterMgr.GetFighterByID(actors[idx].ID, teamside);
                if (f!=null &&  f.Ctrl != null)
                    f.Ctrl.AsyncLoad();
                else
                    DebugHelper.LogError("fighter id:" + actors[idx].ID+" not exist");
            }

            for(int idx =0; idx < tempPetActors.Count;idx++)
            {
                Fighter pet = FighterMgr.GetFighterByID(tempPetActors[idx].ID, teamside);
                if (pet != null && pet.Ctrl != null)
                    pet.Ctrl.AsyncLoad();
            }
        }
        else
        {
            for (int idx = 0; idx < FighterMgr.TeamHeroFighters.Count; idx++)
            {
                if (FighterMgr.TeamHeroFighters[idx].Actor.PetData != null)
                {
                    var pet = FighterMgr.GetTeamMemberById(FighterMgr.TeamHeroFighters[idx].Actor.PetData.ID);
                    pet.OwnerId = FighterMgr.TeamHeroFighters[idx].Id;
                    FighterMgr.TeamHeroFighters[idx].UsedPetId = pet.Id;
                }
            }
        }

        if (actorCnt > 0)
        {
            prepareResOk = false;
            EventMgr.AddEventListener<bool>(ECoreEventType.EID_PREPARE_LOAD_OK, OnPrepareLoadOk);
            BattlePrepareManager.Instance.StartLoad();
            return true;
        }
        return false;
    }

    ActorData NeedRemove(List<ActorData> actors, ActorData ad)
    {
        for(int idx =0; idx < actors.Count;idx++)
        {
            if (actors[idx].ID == ad.ID) return actors[idx];
        }

        return null;
    }

    bool prepareResOk = false;
    bool fighterResOk = false;
    void OnFighterAsyncLoaded(CoreEvent<Fighter> ce)
    {
        Fighter f = ce.Data;
        if (f.IsPlayer || f.IsPet)
        {
            curLoadCnt++;
            
            Vector3 forward = FighterMgr.TeamFighters[0].Forward;
            Vector3 pos = FighterMgr.TeamFighters[0].Position + forward * Random.Range(-3,3);
            f.Spawn(pos, forward, Quaternion.identity);

            if (curLoadCnt == actorCnt)
            {
                IsLoadingActor = false;
                fighterResOk = true;
                EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_FIGHTER_ASYNC_LOADED, OnFighterAsyncLoaded);
                CheckLoadOK();
            }
        }
    }

    void OnPrepareLoadOk(CoreEvent<bool> ce)
    {
        EventMgr.RemoveEventListener<bool>(ECoreEventType.EID_PREPARE_LOAD_OK, OnPrepareLoadOk);
        prepareResOk = true;
        CheckLoadOK();
    }

    void CheckLoadOK()
    {
        if(prepareResOk && fighterResOk)
            EventMgr.DispatchEvent<bool>(new CoreEvent<bool>(ECoreEventType.EID_FIGHTERS_LOAD_OK, true));
    }
}
