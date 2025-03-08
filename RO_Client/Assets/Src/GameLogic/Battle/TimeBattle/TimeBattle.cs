using UnityEngine;
using System.Collections.Generic;

public class TimeBattle : BaseBattle
{
    #region fields
    private TimeBattleField mTimeBattleField;
    private TimeBattleState mState;
    private List<ActorData> mOwnActors;
    private List<ActorData> mEnemyActors;
    private List<ActorData> mOurPlayerActors;
    private List<ActorData> mEnemyPlayerActors;
    private ReadyPoint mActorReadyPoint;
    private SpawnPoint mEnemyReadyPoint;
    private string mSceneName;

    public int BossLife { get { return mTimeBattleField.BossLife; } }

    public int BossSp { get { return mTimeBattleField.BossSp; } }

    public TimeBattleScene BattleScene { get; set; }

    public TimeBattleStateType CurrentState
    {
        get { return mState == null ? TimeBattleStateType.None : mState.State; }
        set
        {
            if (CurrentState == value)
                return;
            int oldState = (int)CurrentState;
            if (mState != null)
                mState.OnLeave();
            mState = TimeBattleState.Create(this, value);
            if (mState != null)
                mState.OnEnter();
        }
    }

    public string SceneName
    {
        get { return mSceneName; }
    }

    private string mBgmMusic;
    public string BgMusic
    {
        get
        {
            return mBgmMusic;
        }
    }

    public override List<ActorData> TeamActors
    {
        get { return mOwnActors; }
    }

    public override List<ActorData> TeamPlayerActors
    {
        get { return mOurPlayerActors; }
    }

    public override List<ActorData> EnemyActors
    {
        get { return mEnemyActors; }
    }

    public override List<ActorData> EnemyPlayerActors
    {
        get { return mEnemyPlayerActors; }
    }

    private BattleSubMode mTimeBattleMode;
    public BattleSubMode BattMode
    {
        get { return mTimeBattleMode; }
    }

    public override BattleSubMode SubBattleMode
    {
        get { return mTimeBattleMode; }
    }

    private ServerFighterParam[] mSrvFighterParams = null;
    private GvGMark[] mArrayGvGMark = null;
    private GvGMark[] mArrayEnemyGvGMark = null;
    private int m_nRestoreSp = 0;
    #endregion

    public TimeBattle(BattleSubMode mode,ActorData[] ownActors,ActorData[] enemyActors,string sceneName,float maxBattlingTime,string bgmMusic, ServerFighterParam[] paramList, 
                                List<BattleEndCondition> endCondList,int nRestoreSp, GvGMark[] OurMarks, GvGMark[] EnemyMarks)
        : base(BattleMode.Time,endCondList)
    {
        mTimeBattleMode = mode;
        IsLogicOnly = true;
        mSceneName = sceneName;
        mBgmMusic = bgmMusic;
        CreateBattleField(ownActors,enemyActors, maxBattlingTime);
        SortActors();
        if (paramList == null)
        {
            mSrvFighterParams = null;
        }
        else
        {
            mSrvFighterParams = new ServerFighterParam[paramList.Length];
            for (int idx = 0; idx < paramList.Length; idx++)
            {
                mSrvFighterParams[idx] = paramList[idx];
            }
        }
        if(null == OurMarks)
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
        m_nRestoreSp = nRestoreSp;   
    }

    public TimeBattle(BattleSubMode mode, string sceneName, float maxBattlingTime, string bgmMusic, BattleRecorder battleRecorder, List<BattleEndCondition> endCondList)
        : base(BattleMode.Time, endCondList)
    {
        mTimeBattleMode = mode;
        IsLogicOnly = true;
        mSceneName = sceneName;
        mBgmMusic = bgmMusic;
        Recorder = battleRecorder;
        IsPlayRecord = true;
        LoadReplayActors();
        mTimeBattleField = new TimeBattleField(this, maxBattlingTime);
        SetBattleField(mTimeBattleField);
        SortActors();
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

        for(int idx =0; idx < mOwnActors.Count;idx++)
        {
            if(!mOwnActors[idx].IsPet)
            {
                mOurPlayerActors.Add(mOwnActors[idx]);
            }
        }

        if(mEnemyPlayerActors == null)
        {
            mEnemyPlayerActors = new List<ActorData>();
        }
        else
        {
            mEnemyPlayerActors.Clear();
        }

        for(int idx =0; idx < mEnemyActors.Count;idx++)
        {
            if(!mEnemyActors[idx].IsPet)
            {
                mEnemyPlayerActors.Add(mEnemyActors[idx]);
            }
        }
    }

    private void LoadReplayActors()
    {
        if (mOwnActors == null)
            mOwnActors = new List<ActorData>();
        else
            mOwnActors.Clear();

        mOwnActors.AddRange(Recorder.LeftActors);

        if (mEnemyActors == null)
            mEnemyActors = new List<ActorData>();
        else
            mEnemyActors.Clear();

        mEnemyActors.AddRange(Recorder.RightActors);
    }

    private void CreateBattleField(ActorData[] ownActors, ActorData[] enemyActors,float maxBattlingTime)
    {
        if (mOwnActors == null)
            mOwnActors = new List<ActorData>();
        else
            mOwnActors.Clear();

        if (mEnemyActors == null)
            mEnemyActors = new List<ActorData>();
        else
            mEnemyActors.Clear();

        for(int idx =0; idx < ownActors.Length;idx++)
        {
            var actor = ownActors[idx];
            mOwnActors.Add(actor);
            if(actor.HasPet)
            {
                mOwnActors.Add(actor.PetData);
            }
        }
        
        mEnemyActors.AddRange(enemyActors);

        if (mTimeBattleField != null)
        {
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

        mTimeBattleField = new TimeBattleField(this,maxBattlingTime);
        SetBattleField(mTimeBattleField);
    }

    public override void Start(int randSeed = 0, ValType[] factors = null)
    {
        base.Start(randSeed,factors);
        CurrentState = TimeBattleStateType.Start;
        if (mTimeBattleMode == BattleSubMode.ClimbingTower)
        {
            InitRecorder();
        }
    }

    public void Fight()
    {
        mTimeBattleField.Start();
    }

    public override void Update(float deltaTime)
    {
        base.Update(deltaTime);

        if (mState != null)
            mState.Update(deltaTime);
    }

    public override void MoveToNextBattleField(bool setStopDistance)
    {
        if (mTimeBattleField == null) return;

        for (int idx = 0; idx < FighterMgr.AllFighters.Count; idx++)
        {
            Fighter f = FighterMgr.AllFighters[idx];
            f.Ctrl.EnableNavAgent(true);
            if (f.IsTeamMember)
            {
                f.AutoMoveTo(mActorReadyPoint.GetReadyPointPos(f.Actor.Profession, f.ReadyPosOrder).heroPos);
            }
            else
            {
                MonsterSpawnLoc loc = mEnemyReadyPoint.spawnLocs[f.Actor.PositionValue-1];
                f.AutoMoveTo(loc.pos);
            }
        }
    }

    public void SetReadyPoint(ReadyPoint ownPoint, SpawnPoint enemyPoint)
    {
        mActorReadyPoint = ownPoint;
        mEnemyReadyPoint = enemyPoint;
    }

    public void SpawnActors()
    {
        if (mActorReadyPoint == null || mEnemyReadyPoint == null) return;

        FighterMgr.SortTeamFighters();

        if (IsPlayRecord)
        {
            Recorder.ProcessFrameRecord(BattleRecorder.RecordType.FighterSpawn);
            for(int idx =0; idx < FighterMgr.TeamHeroFighters.Count;idx++)
            {
                Fighter f = FighterMgr.TeamHeroFighters[idx];
                if (f.Actor.HasPet)
                {
                    Fighter pet = FighterMgr.GetTeamMemberById(f.Actor.PetData.ID);
                    pet.OwnerId = f.Id;
                    f.UsedPetId = pet.Id;
                }
            }
        }
        else
        {
            for (int idx = 0; idx < FighterMgr.TeamHeroFighters.Count; idx++)
            {
                Fighter f = FighterMgr.TeamHeroFighters[idx];
                var pointCfg = mActorReadyPoint.GetBornPointPos(f.Actor.Profession, f.ReadyPosOrder);
                f.Spawn(pointCfg.heroPos, Vector3.forward, Quaternion.identity, true);

                if(f.Actor.HasPet)
                {
                    Fighter pet = FighterMgr.GetTeamMemberById(f.Actor.PetData.ID);
                    pet.Spawn(pointCfg.petPos, Vector3.forward, Quaternion.identity, true);
                    pet.OwnerId = f.Id;
                    f.UsedPetId = pet.Id;
                }

                ServerFighterParam srvParam = GetServerParamById(f.Actor.ID);
                if(srvParam != null)
                {
                    int life = (int)(srvParam.hpPercent * f.MaxLife);
                    life = (life == 0 && srvParam.hpPercent > 0.0f) ? 1 : life;    //保底1
                    f.Life = life > srvParam.hp ? life : srvParam.hp;

                    float sp = srvParam.spPercent * f.MaxSp;
                    sp = (sp == 0 && srvParam.spPercent > 0.0f) ? 1 : sp;        //保底1
                    f.Sp = sp > srvParam.sp ? sp : srvParam.sp;

                    f.RefreshLife();
                    f.RefreshSp();
                }
                
                //初始MARK
                //if (null != mArrayGvGMark && SubBattleMode == BattleSubMode.GvG)
                //{
                //    for (int i = 0; i < mArrayGvGMark.Length; i++)
                //    {
                //        f.AddMark(mArrayGvGMark[i].m_nMarkid, mArrayGvGMark[i].m_nMarkNum);
                //    }
                //}
            }

            for (int idx = 0; idx < FighterMgr.EnemyFighters.Count; idx++)
            {
                Fighter f = FighterMgr.EnemyFighters[idx];
                MonsterSpawnLoc loc = mEnemyReadyPoint.spawnLocs[f.Actor.PositionValue - 1];
                f.Spawn(loc.pos, Vector3.forward, Quaternion.Euler(loc.rot));

                ServerFighterParam srvParam = GetServerParamById(f.Actor.ID);
                if (srvParam != null)
                {
                    int life = (int)(srvParam.hpPercent * f.MaxLife);
                    life = (life == 0 && srvParam.hpPercent > 0.0f) ? 1 : life;    //保底1
                    f.Life = life > srvParam.hp ? life : srvParam.hp;

                    float sp = srvParam.spPercent * f.MaxSp;
                    sp = (sp == 0 && srvParam.spPercent > 0.0f) ? 1 : sp;        //保底1
                    f.Sp = sp > srvParam.sp ? sp : srvParam.sp;
                    f.RefreshLife();
                    f.RefreshSp();
                }
                //初始MARK
                //if(null != mArrayEnemyGvGMark && SubBattleMode == BattleSubMode.GvG)
                //{
                //    for(int i=0;i< mArrayEnemyGvGMark.Length;i++)
                //    {
                //        f.AddMark(mArrayEnemyGvGMark[i].m_nMarkid, mArrayEnemyGvGMark[i].m_nMarkNum);
                //    }
                //}
            }
        }
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
        base.ShutDown();
        CurrentState = TimeBattleStateType.None;
        mTimeBattleField = null;
        mActorReadyPoint = null;
        mEnemyReadyPoint = null;
        if (mOwnActors != null)
            mOwnActors.Clear();

        if (mEnemyActors != null)
            mEnemyActors.Clear();

        mOwnActors = null;
        mEnemyActors = null;
    }

    public void CleanAllFighter()
    {
        if (mTimeBattleField == null) return;

        for (int idx = mTimeBattleField.Fighters.Count - 1; idx >= 0; idx--)
        {
            var f = mTimeBattleField.Fighters[idx];
            FighterMgr.RemoveFighter(f);
            f.Destroy();
        }
    }

    public float GetRestoreSp()
    {
        return m_nRestoreSp * 0.01f;
    }

    private ServerFighterParam GetServerParamById(long uid)
    {
        if (mSrvFighterParams == null) return null;

        for(int idx =0; idx < mSrvFighterParams.Length;idx++)
        {
            if (mSrvFighterParams[idx].uid == uid)
                return mSrvFighterParams[idx];
        }

        return null;
    }
}
