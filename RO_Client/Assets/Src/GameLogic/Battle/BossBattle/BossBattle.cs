using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class ActorSeatInfo
{
    public int seatId;
    public Vector3 pos;
    public bool occupied;

    public ActorSeatInfo(int id,Vector3 pos,bool occupied)
    {
        this.seatId = id;
        this.pos = pos;
        this.occupied = occupied;
    }
}

public class BossBattle : BaseBattle
{
    BossBattleField mField;
    BossBattleState mState;

    private List<ActorSeatInfo> mFrontActorSeats = null;
    private List<ActorSeatInfo> mBackActorSeats = null;

    private List<ActorData> mActors = null;
    private List<ActorData> mEnemyActors = new List<ActorData>();
    private ActorData mBossActor = null;           //boss actor
    private BossMapData mBossMapData;
    private ReadyPoint mActorReadyPoint;
    private SpawnPointCfg mBossSpawnCfg;
    private BattleSubMode mBossMode;
    private int mBossServerLife = 0;        //服务器同步的boss血量
    private bool mBossDirty = false;
    private bool mPepareResOk = false;
    private bool mFighterResOk = false;

    int m_nAsyncLoadintCount = 0;
    public string BgMusic { get { return mBossMapData != null ? mBossMapData.bgmMusic : ""; } }

    public string LevelName { get { return mBossMapData != null ? mBossMapData.levelName : ""; } }

    public override BattleSubMode SubBattleMode
    {
        get { return mBossMode; }
    }

    public BossBattleStateType CurrentState
    {
        get { return mState == null ? BossBattleStateType.None : mState.State; }
        set
        {
            if (CurrentState == value) return;

            int oldState = (int)CurrentState;
            if (mState != null)
                mState.OnLeave();

            mState = BossBattleState.Create(this, value);
            if (mState != null)
                mState.OnEnter();
        }
    }

    public BossBattleScene BattleScene { get; set; }

    public BattleSubMode BossMode
    {
        get { return mBossMode; }
    }

    public SpawnPointCfg SpawnCfg
    {
        get { return mBossSpawnCfg; }
    }

    public override List<ActorData> TeamActors
    {
        get { return mActors; }
    }

    public override List<ActorData> EnemyActors
    {
        get { return mEnemyActors; }
    }

    public bool HasBossComingAnim
    {
        get { return mBossMapData != null ? mBossMapData.hasBossComingAnim : false; }
    }

    public float BossComingTime
    {
        get { return mBossMapData != null ? mBossMapData.bossComingTime : 0; }
    }

    public BossBattle(ActorData[] actors,ActorData bossActor,int sceneId,BattleSubMode mode, List<BattleEndCondition> endCondList) :
        base(BattleMode.Boss,endCondList)
    {
        IsLogicOnly = true;
        mBossMapData = new BossMapData(sceneId);
        mBossMode = mode;
        if (mActors == null)
            mActors = new List<ActorData>();
        else
            mActors.Clear();
        mActors.AddRange(actors);
        mBossActor = bossActor;
        mEnemyActors.Add(mBossActor);
        LoadBossSpawnPointCfg();
        InitBattleField();
    }

    public override void Start(int randSeed = 0, ValType[] factors = null)
    {
        base.Start(randSeed,factors);
        CurrentState = BossBattleStateType.Start;
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
        base.ShutDown();

        CurrentState = BossBattleStateType.None;
        mField = null;
        mBossActor = null;
        mBossMapData = null;
        mActorReadyPoint = null;
        mBossSpawnCfg = null;
        mBossMode = BattleSubMode.None;

        if (mActors != null)
            mActors.Clear();
        m_nAsyncLoadintCount = 0;
        mEnemyActors.Clear();
    }

    public override void MoveToNextBattleField(bool setStopDistance)
    {
        if (mField == null) return;

        for (int idx = FighterMgr.TeamHeroFighters.Count - 1; idx >= 0; idx--)
        {
            Fighter f = FighterMgr.TeamHeroFighters[idx];
            f.Ctrl.EnableNavAgent(true);

            if(mBossMode != BattleSubMode.NewbieBoss)
            {
                var pointCfg = mActorReadyPoint.GetReadyPointPos(f.Actor.Profession, f.ReadyPosOrder);
                f.AutoMoveTo(pointCfg.heroPos);
                if (f.UsedPetId > 0)
                {
                    f.SyncPetMoveDestPos(pointCfg.petPos, true, true);
                }
            }
        }
    }

    public override void AddActor(ActorData actor, eTeamType teamSide = eTeamType.Friend, bool spawn = true)
    {
        if (actor == null) return;

        if (FighterMgr.HasTeamHero(actor.ID))
        {
            DebugHelper.LogError("玩家已经存在"+ actor.ID.ToString());
            return;
        }

        Fighter f = FighterMgr.AddFighter(actor, teamSide);

        IsLoadingActor = true;
        mPepareResOk = false;
        mFighterResOk = false;

        EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_FIGHTER_ASYNC_LOADED, OnFighterAsyncLoaded);
        EventMgr.AddEventListener<bool>(ECoreEventType.EID_PREPARE_LOAD_OK, OnPrepareLoadOk);

        f.Ctrl.AsyncLoad();
        m_nAsyncLoadintCount += 1;
        BattlePrepareManager.Instance.StartLoad();
    }

    void OnFighterAsyncLoaded(CoreEvent<Fighter> ce)
    {
        m_nAsyncLoadintCount -= 1;
        Fighter f = ce.Data;
        if (f.IsPlayer)
        {
            f.Spawn(Vector3.zero, Vector3.forward, Quaternion.identity);  /*mActorReadyPoint.GetBornPointPos(f.Actor.Profession, f.ReadyPosOrder)*/
            EnterSeat(f);
            IsLoadingActor = false;
            mFighterResOk = true;
            if(m_nAsyncLoadintCount<=0)
                EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_FIGHTER_ASYNC_LOADED, OnFighterAsyncLoaded);
        }
    }

    void OnPrepareLoadOk(CoreEvent<bool> ce)
    {
        EventMgr.RemoveEventListener<bool>(ECoreEventType.EID_PREPARE_LOAD_OK, OnPrepareLoadOk);
        mPepareResOk = true;
    }

    public override void RemoveActor(long actorId)
    {
        Fighter f = FighterMgr.GetTeamMemberById(actorId);
        if(f!=null)
        {
            //DebugHelper.LogError("移除玩家ID:" + actorId + " fighter:" + f.Name);
            LeaveSeat(f.SeatId);
            FighterMgr.RemoveFighter(f);
            mActors.Remove(f.Actor);
            f.Destroy();
        }
        else
        {
            ActorData actor = FindActor(actorId);
            if(actor!=null)
            {
                mActors.Remove(actor);
            }
        }
    }

    public override void SyncActorLife(long actorId, int hp)
    {
        Fighter f = FighterMgr.GetTeamMemberById(actorId);
        if(f!=null)
        {
            f.Life = hp;
        }
    }

    public override void SyncBossLife(int life)
    {
        mBossServerLife = life;
        
        if(mBossActor!=null)
        {
            Fighter boss = FighterMgr.GetFighterByID(mBossActor.ID,eTeamType.Enemy);
            if(boss != null)
            {
                boss.Life = mBossServerLife;
                return;
            }
        }
        mBossDirty = true;
    }

    public void SetActorReadyPoint(ReadyPoint readyPoint)
    {
        mActorReadyPoint = readyPoint;
    }

    
    public void BeginFight()
    {
        Fight();
    }

    public void CalcTransferPoint()
    {
        Vector3 forward = mBattleField.EnemyFighters[0].Ctrl.transform.forward;
        Vector3 rot = mBossSpawnCfg.Rot;
        rot.y = 180 + rot.y;

        Vector3 center = mBossSpawnCfg.TransferPos;
        mActorReadyPoint.CalcNextBattleFieldPoints(center, rot);
    }

    public override void CalcNextPoint()
    {
        Vector3 forward = mBattleField.EnemyFighters[0].Ctrl.transform.forward;
        Vector3 rot = mBossSpawnCfg.Rot;
        rot.y = 180 + rot.y;

        Vector3 center = mBossSpawnCfg.Pos + forward * mBossSpawnCfg.ActorReadyDist;
        mActorReadyPoint.CalcNextBattleFieldPoints(center, rot);
    }

    /// <summary>
    /// 立刻战斗
    /// </summary>
    public void Fight()
    {
        if(mBossMode == BattleSubMode.WorldBoss)
        {
            mField.Fight();
        }
        else
        {
            mField.Start();
        }
    }

    public void SpawnActors()
    {
        Fighter boss = null;
        for (int idx = FighterMgr.AllFighters.Count - 1; idx >= 0; idx--)
        {
            Fighter f = FighterMgr.AllFighters[idx];
            if (f.IsPlayer)
            {
                if (mBossMode == BattleSubMode.WorldBoss)
                {
                    f.Spawn(Vector3.zero, Vector3.forward, Quaternion.identity);
                    EnterSeat(f);
                }
                else
                {
                    f.Spawn(mActorReadyPoint.GetBornPointPos(f.Actor.Profession, f.ReadyPosOrder).heroPos, Vector3.forward, Quaternion.identity, false);
                    f.Ctrl.SetLayer(LayerMask.NameToLayer(BattleCamera.HideLayerName));
                }
            }
            else
            {
                if (f.IsSummoned)
                {
                    f.Ctrl.SetLayer(LayerMask.NameToLayer(BattleCamera.HideLayerName));
                }
                else
                {
                    MonsterSpawnLoc loc = mBossSpawnCfg.PointList[1];
                    f.Spawn(loc.pos, Vector3.forward, Quaternion.Euler(loc.rot));
                    //f.SetRotation(Quaternion.Euler(loc.rot));
                    f.IgnoreLife = mBossMode == BattleSubMode.WorldBoss;
                    if (mBossDirty)
                    {
                        f.Life = mBossServerLife;
                        mBossDirty = false;
                    }
                    boss = f;
                    if (mBossMode == BattleSubMode.NewbieBoss)
                    {
                        f.Ctrl.SetLayer(LayerMask.NameToLayer(BattleCamera.HideLayerName));
                    }
                }
            }
        }

        if(boss!=null)
        {
            EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_BOSS_SPAWNED, boss));
        }
    }

    public override void SyncFighterPos(Fighter f)
    {
        if (f == null) return;

        f.SyncPosition(mActorReadyPoint.GetReadyPointPos(f.Actor.Profession, f.ReadyPosOrder).heroPos);
    }

    public override void FighterMove2BattleCenter(Fighter f, Vector3 pos)
    {
        if (f == null) return;

        if(pos == Vector3.zero)
        {
            f.AutoMoveTo(mActorReadyPoint.GetReadyPointPos(f.Actor.Profession, f.ReadyPosOrder).heroPos, true);
        }
        else
        {
            f.AutoMoveTo(pos, true);
        }
    }

    public override void StartStoryScript()
    {
        //DebugHelper.LogError("StartStoryScript");
        if (globalTrigger != null)
        {
            BattleMgr.Instance.DisableBattleCamera();
            globalTrigger.PrepareFight();
        }
    }

    private void InitBattleField()
    {
        mField = new BossBattleField(this, mBossSpawnCfg);
        SetBattleField(mField);
    }

    private void LoadBossSpawnPointCfg()
    {
        if (mBossMapData == null || string.IsNullOrEmpty(mBossMapData.levelName)) return;

        string bornFileName = "Born_" + mBossMapData.levelName;
        string ta = ConfigMgr.Instance.GetXmlCfg(bornFileName);
        if (ta == null)
        {
            DebugHelper.LogError(bornFileName + " 出生点文件不存在");
            return;
        }

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
            if(mBossSpawnCfg == null)
            {
                mBossSpawnCfg = new SpawnPointCfg();
            }
            mBossSpawnCfg.LoadCfgXml(spNode);
            break;
        }

        if(mFrontActorSeats == null)
        {
            mFrontActorSeats = new List<ActorSeatInfo>();
        }
        else
        {
            mFrontActorSeats.Clear();
        }

        if(mBackActorSeats == null)
        {
            mBackActorSeats = new List<ActorSeatInfo>();
        }
        else
        {
            mBackActorSeats.Clear();
        }

        MonsterSpawnLoc loc = mBossSpawnCfg.PointList[1];
        Vector3 centerPos = loc.pos;
        Vector3 dir = Quaternion.AngleAxis(loc.rot.y, Vector3.up) * Vector3.forward;

        int seatId = 1;
        List<Vector3> points = SamplePos(centerPos, dir, -30, 30, 20, 3);
        if (points != null)
        {
            for (int idx = 0; idx < points.Count; idx++)
            {
                mFrontActorSeats.Add(new ActorSeatInfo(seatId++, points[idx], false));
            }
        }

        points = SamplePos(centerPos, dir, -30, 30, 20, 5);
        if (points != null)
        {
            for (int idx = 0; idx < points.Count; idx++)
            {
                mFrontActorSeats.Add(new ActorSeatInfo(seatId++, points[idx], false));
            }
        }

        points = SamplePos(centerPos, dir, -15, 15, 10, 8);
        if (points != null)
        {
            for (int idx = 0; idx < points.Count; idx++)
            {
                mBackActorSeats.Add(new ActorSeatInfo(seatId++, points[idx], false));
            }
        }

        points = SamplePos(centerPos, dir, -15, 15, 10, 10);
        if (points != null)
        {
            for (int idx = 0; idx < points.Count; idx++)
            {
                mBackActorSeats.Add(new ActorSeatInfo(seatId++, points[idx], false));
            }
        }

#if UNITY_EDITOR
       for (int idx =0; idx < mFrontActorSeats.Count;idx++)
       {
           GameObject p = GameObject.CreatePrimitive(PrimitiveType.Cube);
           p.name = "front_p_"+idx;
           p.layer = LayerMask.NameToLayer("Hide");
           p.transform.SetParent(BattleMgr.Instance.transform);
           p.transform.position = mFrontActorSeats[idx].pos;
       }

       for(int idx =0; idx < mBackActorSeats.Count;idx++)
       {
           GameObject p = GameObject.CreatePrimitive(PrimitiveType.Cube);
           p.name = "back_p_" + idx;
           p.layer = LayerMask.NameToLayer("Hide");
           p.transform.SetParent(BattleMgr.Instance.transform);
           p.transform.position = mBackActorSeats[idx].pos;
       }
#endif
    }

    List<Vector3> SamplePos(Vector3 center,Vector3 dir, int minAngle, int maxAngle, int intervalAngle,float radius)
    {
        if (intervalAngle <= 0) return null;

        Vector3 temp = center + dir * radius;

        List<Vector3> points = new List<Vector3>();
        int num = (maxAngle - minAngle) / intervalAngle;

        for(int idx = 0; idx <= num;idx++)
        {
            int angle = minAngle + idx * intervalAngle;
            Vector3 pos = MathUtil.RotateRound(temp, center, Vector3.up, angle);
            points.Add(pos);
        }

        return points;
    }

    List<int> tempInts = new List<int>();
    
    public void EnterSeat(Fighter fighter)
    {
        if (fighter == null) return;

        ActorSeatInfo seat = GetIdleSeat(fighter.IsFront);
        if (seat != null)
        {
            seat.occupied = true;
            fighter.SeatId = seat.seatId;
            fighter.SyncPosition(seat.pos);
            //DebugHelper.LogError("玩家进入:" + fighter.Id+" name:"+fighter.Name + " seat:" + fighter.SeatId);
        }
    }

    public void LeaveSeat(int seatId)
    {
        ActorSeatInfo seat = FindSeat(seatId);
        if (seat != null)
            seat.occupied = false;
    }

    public ActorSeatInfo FindSeat(int seatId)
    {
        if(mFrontActorSeats!=null)
        {
            for(int idx =0; idx < mFrontActorSeats.Count;idx++)
            {
                if (mFrontActorSeats[idx].seatId == seatId)
                    return mFrontActorSeats[idx];
            }
        }

        if(mBackActorSeats != null)
        {
            for(int idx = 0; idx < mBackActorSeats.Count;idx++)
            {
                if (mBackActorSeats[idx].seatId == seatId)
                    return mBackActorSeats[idx];
            }
        }
        return null;
    }

    public ActorSeatInfo GetIdleSeat(bool front)
    {
        if (front)
        {
            if (mFrontActorSeats == null)
            {
                return null;
            }
            else
            {
                tempInts.Clear();
                for (int idx = 0; idx < mFrontActorSeats.Count; idx++)
                {
                    if (!mFrontActorSeats[idx].occupied)
                    {
                        tempInts.Add(mFrontActorSeats[idx].seatId);
                    }
                }
                if (tempInts.Count > 0)
                {
                    int idx = Random.Range(0, tempInts.Count);
                    int seatId = tempInts[idx];
                    return FindSeat(seatId);
                }
            }
        }
        else
        {
            if (mBackActorSeats == null)
            {
                return null;
            }
            else
            {
                tempInts.Clear();
                for (int idx = 0; idx < mBackActorSeats.Count; idx++)
                {
                    if (!mBackActorSeats[idx].occupied)
                    {
                        tempInts.Add(mBackActorSeats[idx].seatId);
                    }
                }
                if (tempInts.Count > 0)
                {
                    int idx = Random.Range(0, tempInts.Count);
                    int seatId = tempInts[idx];
                    return FindSeat(seatId);
                }
            }
        }

        return null;
    }

    private ActorData FindActor(long actorId)
    {
        if (mActors == null) return null;

        for(int idx = mActors.Count - 1;idx>=0;idx--)
        {
            if (mActors[idx].ID == actorId) return mActors[idx];
        }
        return null;
    }
}
