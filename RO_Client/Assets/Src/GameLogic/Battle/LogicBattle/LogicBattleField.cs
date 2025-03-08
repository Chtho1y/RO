using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;

public class LogicBattleField : BattleField
{
	public const float default_size_x = 8;
	public const float default_size_y = 0;
	public const float default_size_z = 10;

	LogicBattle mBattle;
	LevelItem mBattleInfo;
    LogicBattleFieldState mState;
    SpawnPointCfg mCurrentSpawnCfg = null;

    float mHalfHeight;


    public bool muteMusic = false;

    public bool playingBattleMusic = false;

    public float rushLeftTime = 0;

    private bool bKillBoss = false;

    public override bool killBoss
    {
        get { return bKillBoss; }
        set
        {
            if(bKillBoss !=value)
            {
                bKillBoss = value;
                if(mState!=null)
                    mState.OnDataChanged();
            }
        }
    }

    public override float FloorY
    {
        get
        {
            return mCurrentSpawnCfg != null ? Math.Max(mCurrentSpawnCfg.Pos.y,0) : 0;
        }
    }

    public override bool IsIdleState
    {
        get { return CurrentState == LogicBattleFieldStateType.None; }
    }

    public override bool IsFightingState
    {
        get
        {
            return CurrentState == LogicBattleFieldStateType.Fighting || CurrentState == LogicBattleFieldStateType.EditorFighting;
        }
    }

    public override int CurrentFieldState
    {
        get { return (int)CurrentState; }
    }

    public LogicBattleField (LogicBattle battle, LevelItem bi)
		: base (battle,Vector3.zero, new Vector3 (default_size_x, default_size_y, default_size_z), Vector3.forward)
	{
		Init (battle, bi);
	}

    private void Init(LogicBattle battle, LevelItem bi)
    {
        mBattle = battle;
        mBattleInfo = bi;
        mHalfHeight = Size.y * 0.5f;
        FightingTime = 0;
        DisableWaitFighterReadyOnWin = true;
        if(battle!=null)
        {
            killBoss = battle.ChallengeBoss;
            battle.ChallengeBoss = false;
        }

        mEnemyActors.Clear();
        if (killBoss)
        {
            mEnemyActors.Add(bi.BossActor);

            if (bi.Monsters != null)
            {
                for (int idx = 0; idx < bi.Monsters.Count; idx++)
                {
                    mEnemyActors.Add(bi.Monsters[idx]);
                }
            }
        }
    }

    public LogicBattle Battle { get { return mBattle; } }

	public override LevelItem BattleInfo { get { return mBattleInfo; } }

	public LogicBattleScene Scene { get { return mBattle.BattleScene; } }

	public int BattleIdx { get { return mBattle.BattleIdx; } }

	public bool DisableWaitFighterReadyOnWin { get; set; }

	public LogicBattleFieldStateType CurrentState {
		get { return mState != null ? mState.State : LogicBattleFieldStateType.None; }
		set {
			if (CurrentState == value)
				return;
			int oldState = (int)CurrentState;
			if (mState != null)
				mState.OnLeave ();

			mState = LogicBattleFieldState.Create (this, value);

            mCurrentStateFrame = 0;
			if (mState != null)
            {
				mState.OnEnter ();
            }
        }
	}

    private Vector3 mFieldCenter = Vector3.zero;
    public override Vector3 FieldCenter
    {
        get
        {
            return mFieldCenter;
        }
        set
        {
            mFieldCenter = value;
        }
    }

    public override Vector3 FieldFocus
    {
        get
        {
            if (Fighters.Count == 0)
                return mCurrentSpawnCfg.Pos;

            Vector3 min = Vector3.zero;
            Vector3 max = Vector3.zero;
            bool hasSet = false;
            for (int idx = 0; idx < Fighters.Count; idx++)
            {
                Fighter f = Fighters[idx];
                if(f.IsFront)
                {
                    if (!hasSet)
                    {
                        min = f.Position;
                        max = f.Position;
                        hasSet = true;
                    }
                    else
                    {
                        min = Vector3.Min(f.Position, min);
                        max = Vector3.Max(f.Position, max);
                    }
                }
            }

            return 0.5f * (min + max) + Vector3.up * 1.0f;
        }
    }

    public Vector3 MosterFighterFocus
    {
        get
        {
            if (EnemyFighters.Count == 0)
                return mCurrentSpawnCfg.Pos;

            Vector3 min = Vector3.zero;
            Vector3 max = Vector3.zero;
            bool hasSet = false;
            for (int idx = 0; idx < EnemyFighters.Count; idx++)
            {
                Fighter f = EnemyFighters[idx];
                if (!hasSet)
                {
                    min = f.Position;
                    max = f.Position;
                    hasSet = true;
                }
                else
                {
                    min = Vector3.Min(f.Position, min);
                    max = Vector3.Max(f.Position, max);
                }
            }

            return 0.5f * (min + max) + Vector3.up * 1.0f;
        }
    }

    public override Vector3 FighterForward
    {
        get
        {
            if (EnemyFighters.Count == 0)
                return Vector3.forward;
            return EnemyFighters[0].Ctrl != null ? EnemyFighters[0].Ctrl.transform.forward : EnemyFighters[0].Forward;
        }
    }

    public override bool CanKillBoss { get { return CurrentState <= LogicBattleFieldStateType.Search; } }

    private Vector3 mPreSpawnPos;
    public Vector3 PreSpawnPos
    {
        get { return mPreSpawnPos; }
    }

    public SpawnPointCfg CurrentWavePoint
    {
        get { return mCurrentSpawnCfg; }
    }

    public override string Name
    {
        get { return "LogicBattleField"; }
    }

    public void Start ()
	{
		Result = FightingResult.None;
		FightingTime = 0;
		CurrentState = LogicBattleFieldStateType.DialogBeforeSearch;
	}

    public void BeginReplay()
    {
        Result = FightingResult.None;
        FightingTime = 0;
        CurrentState = LogicBattleFieldStateType.Search;
    }

    public override void Update (float deltaTime)
	{
        base.Update(deltaTime);
        
		if (mState != null)
        {
#if PROFILE
            UnityEngine.Profiling.Profiler.BeginSample("LogicBattleField update:" + mState.State);
#endif
            mState.Update (deltaTime);
#if PROFILE
            UnityEngine.Profiling.Profiler.EndSample();
#endif
        }
	}

	public override void AddFighter (Fighter fighter)
	{
        base.AddFighter(fighter);
        if (mBattle != null)
            mBattle.FighterMgr.AddFighterToBattleField(fighter);

        if (fighter.IsTeamMember)
        {
            SortTeamFighters();
        }
    }

	public override void RemoveFighter (Fighter fighter)
	{
        base.RemoveFighter(fighter);
        if (mBattle != null)
            mBattle.FighterMgr.RemoveFighterFromBattleField(fighter);

        if (fighter.IsTeamMember)
        {
            SortTeamFighters();
        }
	}

    public bool bIsAllFighterIdle()
    {
        if (mBattle == null)
            return false;
        for (int i = 0; i < mFighters.Count; i++)
        {
            Fighter fighter = mFighters[i];
            if (!fighter.IsSpawned || (!fighter.IsDisposed && fighter.IsAlive))
            {
                if(!fighter.IsIdle)
                {
                    return false;
                }
            }
        }
        return true;
    }

    public override void GetFieldSummonPos(int posVal, out Vector3 pos, out Vector3 rot)
    {
        if (CurrentWavePoint == null)
        {
            pos = Vector3.zero;
            rot = Vector3.zero;
            return;
        }

        MonsterSpawnLoc loc = CurrentWavePoint.PointList[posVal - 1];
        pos = loc.pos;
        rot = loc.rot;
    }

    public bool HasTeamMemberDead()
    {
        if (mTeamFighters == null) return false;
        for(int idx =0; idx < mTeamFighters.Count;idx++)
        {
            if (!mTeamFighters[idx].IsAlive) return true;
        }

        return false;
    }

    public void RemoveMonsters()
    {
        for(int idx =0; idx < mEnemyFighters.Count;idx++)
        {
            mFighters.Remove(mEnemyFighters[idx]);
            mEnemyFighters[idx].Dispose();
        }
        mEnemyFighters.Clear();
    }

    public void SpawnMonster()
    {
        RecordSpawnCfg();
        Vector3 forward = Vector3.forward;
        Vector3 rot = mCurrentSpawnCfg.Rot;
        rot.y = 180 + rot.y;

        for(int idx =0; idx < mCurrentSpawnCfg.PointList.Count;idx++)
        {
            MonsterSpawnLoc loc = mCurrentSpawnCfg.PointList[idx];
            if(loc.npcInstanceId > 0)
            {
                Fighter fighter = mBattle.FighterMgr.GetFighterByID(loc.npcInstanceId,eTeamType.Enemy);
                fighter.Actor.SetLevel(BattleInfo.MonsterLv);
                fighter.Spawn(loc.pos, Vector3.forward, Quaternion.Euler(loc.rot));
                //fighter.SetRotation(Quaternion.Euler(loc.rot));
                forward = fighter.Ctrl.transform.forward;
            }
        }

        Vector3 center = mCurrentSpawnCfg.Pos + forward * mCurrentSpawnCfg.ActorReadyDist;
        mBattle.BattleScene.ActorBornPoint.CalcNextBattleFieldPoints(center, rot);
    }

    public void RecordSpawnCfg()
    {
        mCurrentSpawnCfg = mBattle.BattleScene.MapMonsterSpawnPoint;
    }

    public void SpawnBoss()
    {
        Battle.BattleScene.SetEffectVisible(true);
        mBattle.StartStatistics();
        if (mBattle.IsPlayRecord)
        {
            mPreSpawnPos = mCurrentSpawnCfg.Pos;
            mCurrentSpawnCfg = mBattle.BattleScene.BossSpawnPoint;

            mBattle.Recorder.ProcessFrameRecord(BattleRecorder.RecordType.FighterSpawn);
            mBattle.BattleScene.ActorBornPoint.CalcNextBattleFieldPoints(mCurrentSpawnCfg.TransferPos, mCurrentSpawnCfg.TransferRot);
            mBattle.CheckTeamPlayerActors();
            EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_BOSS_SPAWNED, EnemyFighters[0]));
        }
        else
        {
            mPreSpawnPos = mCurrentSpawnCfg.Pos;
            mCurrentSpawnCfg = mBattle.BattleScene.BossSpawnPoint;

            ActorData ad = BattleInfo.BossActor;
            Fighter fighter = Battle.FighterMgr.GetFighterByInstanceID(ad.FighterInstanceId);
            if (fighter != null)
            {
                MonsterSpawnLoc loc = mCurrentSpawnCfg.PointList[ad.PositionValue - 1];
                fighter.Spawn(loc.pos, Vector3.forward, Quaternion.Euler(loc.rot));
                //fighter.SetRotation(Quaternion.Euler(loc.rot));
            }

            if (BattleInfo.Monsters != null)
            {
                for (int idx = 0; idx < BattleInfo.Monsters.Count; idx++)
                {
                    ActorData npcAd = BattleInfo.Monsters[idx];
                    Fighter f = Battle.FighterMgr.GetFighterByInstanceID(npcAd.FighterInstanceId);
                    if (f != null)
                    {
                        MonsterSpawnLoc loc = mCurrentSpawnCfg.PointList[npcAd.PositionValue - 1];
                        f.Actor.SetLevel(BattleInfo.MonsterLv);
                        f.Spawn(loc.pos, Vector3.forward, Quaternion.Euler(loc.rot));
                        //f.SetRotation(Quaternion.Euler(loc.rot));
                    }
                }
            }

            mBattle.BattleScene.ActorBornPoint.CalcNextBattleFieldPoints(mCurrentSpawnCfg.TransferPos, mCurrentSpawnCfg.TransferRot);
            mBattle.CheckTeamPlayerActors();
            EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_BOSS_SPAWNED, fighter));
        }
    }

    public override void PeaceEnd()
    {
        if (bKillBoss)
        {
            Result = FightingResult.Peace;
            if (CurrentState == LogicBattleFieldStateType.Failed || CurrentState == LogicBattleFieldStateType.Win)
            {
                CurrentState = LogicBattleFieldStateType.End;
                CurrentState = LogicBattleFieldStateType.None;               
            }
            else if (CurrentState == LogicBattleFieldStateType.End)
            {
                BattleMgr.Instance.OnBattleForceStop(killBoss);
                CurrentState = LogicBattleFieldStateType.None;               
            }
            else
            {
                CurrentState = LogicBattleFieldStateType.End;
                CurrentState = LogicBattleFieldStateType.None;
            }
        }
        else
        {
            Result = FightingResult.Peace;
            if (CurrentState == LogicBattleFieldStateType.Failed || CurrentState == LogicBattleFieldStateType.Win)
            {
                CurrentState = LogicBattleFieldStateType.End;
                CurrentState = LogicBattleFieldStateType.None;               
            }
            else if (CurrentState == LogicBattleFieldStateType.End)
            {
                BattleMgr.Instance.OnBattleForceStop(killBoss);
                CurrentState = LogicBattleFieldStateType.None;               
            }
            else if (CurrentState == LogicBattleFieldStateType.None)
            {
               
            }
            else
            {
                CurrentState = LogicBattleFieldStateType.End;
                CurrentState = LogicBattleFieldStateType.None;                
            }
        }
    }

    public void DropItems()
    {
        if (!IsWin) return;

        int gold = BattleInfo.Zeny;
        int dropCnt = 0;
        if (gold > 0)
        {
            dropCnt = GlobalConfig.Instance.GetConfigIntValue(GlobalConfig.c_default_dropmoney_cnt);
        }
        if (BattleInfo.DropItems != null)
        {
            dropCnt += BattleInfo.DropItems.Length;
        }

        Vector3 camPos = BattleCamera.Instance.CamPosition;
        Vector3[] posList = new Vector3[dropCnt];
        for (int idx = 0; idx < dropCnt; idx++)
        {
            Vector3 pos = MosterFighterFocus;
            pos.x += UnityEngine.Random.Range(-CurrentWavePoint.HorSpace, CurrentWavePoint.HorSpace);
            pos.z += UnityEngine.Random.Range(-2 * CurrentWavePoint.VerSpace, CurrentWavePoint.VerSpace);

            posList[idx] = pos;
        }

        EventMgr.DispatchEvent<Vector3[]>(new CoreEvent<Vector3[]>(ECoreEventType.EID_DROP_ITEMS, posList));
    }
}
