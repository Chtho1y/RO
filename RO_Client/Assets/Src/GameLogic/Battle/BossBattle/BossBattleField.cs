using UnityEngine;
using System.Collections;

public class BossBattleField : BattleField
{
    private BossBattle mBattle;
    private SpawnPointCfg mBossSpawnCfg;
    private BossBattleFieldState mState;
    private ReadyPoint mActorReadyPoint;
    private bool ignoreBossCheck;

    public bool Pause
    {
        get;private set;
    }

    public override string Name
    {
        get { return "BossBattleField"; }
    }

    public BossBattle Battle
    {
        get { return mBattle; }
    }

    public BossBattleFieldStateType CurrentState
    {
        get { return mState != null ? mState.State : BossBattleFieldStateType.None; }
        set
        {
            if (CurrentState == value) return;

            int oldState = (int)CurrentState;
            if (mState != null)
                mState.OnLeave();

            mState = BossBattleFieldState.Create(this, value);

            mCurrentStateFrame = 0;
            if (mState != null)
                mState.OnEnter();
        }
    }

    public override bool IsIdleState
    {
        get { return CurrentState == BossBattleFieldStateType.None; }
    }

    public override bool IsFightingState
    {
        get { return CurrentState == BossBattleFieldStateType.Fighting && !Pause; }
    }

    public override float FloorY
    {
        get { return mBossSpawnCfg != null ? mBossSpawnCfg.Pos.y : 0; }
    }

    public override Vector3 FieldCenter
    {
        get
        {
            return mBossSpawnCfg != null ? mBossSpawnCfg.PointList[1].pos : Vector3.zero;
        }
    }

    public override Vector3 FieldFocus
    {
        get
        {
            if (Fighters.Count == 0)
                return mBossSpawnCfg.Pos;

            Vector3 min = Vector3.zero;
            Vector3 max = Vector3.zero;
            bool hasSet = false;
            for (int idx = 0; idx < Fighters.Count; idx++)
            {
                Fighter f = Fighters[idx];
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

    public BossBattleField(BossBattle battle,SpawnPointCfg cfg):
        base(battle,cfg.Pos,new Vector3(20,20,20),Vector3.forward)
    {
        mBattle = battle;
        mBossSpawnCfg = cfg;
        FightingTime = 0;
    }

    public void Start()
    {
        Result = FightingResult.None;
        FightingTime = 0;
        CurrentState = BossBattleFieldStateType.Start;
    }

    public void Fight()
    {
        Result = FightingResult.None;
        FightingTime = 0;
        CurrentState = BossBattleFieldStateType.Fighting;
    }

    public override void AddFighter(Fighter fighter)
    {
        base.AddFighter(fighter);
        if (mBattle != null)
            mBattle.FighterMgr.AddFighterToBattleField(fighter);
    }

    public override void RemoveFighter(Fighter fighter)
    {
        base.RemoveFighter(fighter);
        if (mBattle != null)
            mBattle.FighterMgr.RemoveFighterFromBattleField(fighter);
    }

    public override void Update(float deltaTime)
    {
        base.Update(deltaTime);

        if (mState != null)
        {
#if PROFILE
            UnityEngine.Profiling.Profiler.BeginSample("BossBattleField update:" + mState.State);
#endif
            mState.Update(deltaTime);

#if PROFILE
            UnityEngine.Profiling.Profiler.EndSample();
#endif
        }
    }

    public override void DoPauseFight(bool pause)
    {
        Pause = pause;
        if (Pause)
        {
            EffectManager.Instance.PauseAllEffects();
        }
        else
        {
            EffectManager.Instance.ResumeAllEffects();
        }
    }

    public override void GetFieldSummonPos(int posVal, out Vector3 pos, out Vector3 rot)
    {
        if (mBattle.SpawnCfg == null)
        {
            pos = Vector3.zero;
            rot = Vector3.zero;
            return;
        }

        MonsterSpawnLoc loc = mBattle.SpawnCfg.PointList[posVal - 1];
        pos = loc.pos;
        rot = loc.rot;
    }
}
