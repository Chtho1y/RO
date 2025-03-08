using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class VersusBattleField : BattleField
{
    private VersusBattle mBattle;
    private TowerBattleInfo mBattleInfo;
    private VersusBattleFieldState mState;
    private ReadyPoint mOwnReadyPoint;
    private ReadyPoint mEnemyReadyPoint;

    public VersusBattle Battle
    {
        get { return mBattle; }
    }
    public VersusBattleFieldStateType CurrentState
    {
        get { return mState != null ? mState.State : VersusBattleFieldStateType.None; }
        set
        {
            if (CurrentState == value)
                return;
            int oldState = (int)CurrentState;
            if (mState != null)
                mState.OnLeave();

            mState = VersusBattleFieldState.Create(this, value);

            mCurrentStateFrame = 0;
            if (mState != null)
            {
                mState.OnEnter();
            }
        }
    }

    public override bool IsIdleState
    {
        get { return CurrentState == VersusBattleFieldStateType.None; }
    }

    public override bool IsFightingState
    {
        get { return CurrentState == VersusBattleFieldStateType.Fighting; }
    }

    public override float FloorY
    {
        get { return mBattleInfo!=null ? mBattleInfo.fieldPos.y : 0; }
    }

    public override Vector3 FieldCenter
    {
        get { return mBattleInfo!= null ? mBattleInfo.fieldPos : Vector3.zero; }
    }

    public override Vector3 FieldFocus
    {
        get {  return mBattleInfo != null ? mBattleInfo.fieldPos : Vector3.zero; }
    }

    public TowerBattleInfo battleInfo
    {
        get { return mBattleInfo; }
    }

    public override string Name
    {
        get { return "TowerBattleField"; }
    }

    public Vector3 TeamFocus
    {
        get
        {
            if (TeamFighters.Count == 0)
                return Vector3.zero;

            Vector3 min = Vector3.zero;
            Vector3 max = Vector3.zero;
            bool hasSet = false;
            for (int idx = 0; idx < TeamFighters.Count; idx++)
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

    public override int CurrentFieldState
    {
        get { return (int)CurrentState; }
    }


    public VersusBattleField(VersusBattle battle, TowerBattleInfo bi, float maxBattleTime)
        : base(battle,bi.fieldPos, new Vector3(20, 20, 20), Vector3.forward)
    {
        Init(battle, bi);
        MaxFightingTime = maxBattleTime;
    }

    private void Init(VersusBattle battle, TowerBattleInfo bi)
    {
        mBattle = battle;
        mBattleInfo = bi;
        FightingTime = 0;
    }

    public void Start()
    {
        Result = FightingResult.None;
        FightingTime = 0;
        CurrentState = VersusBattleFieldStateType.Start;
    }

    public override void AddFighter(Fighter fighter)
    {
        base.AddFighter(fighter);
        if (mBattle != null)
            mBattle.FighterMgr.AddFighterToBattleField(fighter);

        if(fighter.IsTeamMember)
        {
            SortTeamFighters();
        }
        else
        {
            SortEnemyFighters();
        }
    }

    public override void RemoveFighter(Fighter fighter)
    {
        base.RemoveFighter(fighter);
        if (mBattle != null)
            mBattle.FighterMgr.RemoveFighterFromBattleField(fighter);

        if(fighter.IsTeamMember)
        {
            SortTeamFighters();
        }
        else
        {
            SortEnemyFighters();
        }
    }

    public override void Update(float deltaTime)
    {
        base.Update(deltaTime);

        if (mState != null)
        {
#if PROFILE
            UnityEngine.Profiling.Profiler.BeginSample("TowerBattleField update:" + mState.State);
#endif
            mState.Update(deltaTime);

#if PROFILE
            UnityEngine.Profiling.Profiler.EndSample();
#endif
        }
    }
}
