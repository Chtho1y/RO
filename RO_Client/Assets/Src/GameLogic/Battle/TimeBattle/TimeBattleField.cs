using UnityEngine;
using System.Collections;

public class TimeBattleField:BattleField
{
    private TimeBattle mBattle;
    private TimeBattleFieldState mState;
    private ReadyPoint mOwnReadyPoint;
    private ReadyPoint mEnemyReadyPoint;

    private int mBossLife;
    private int mBossSp;
    public int BossLife
    {
        get { return mBossLife; }
        set { mBossLife = value; }
    }

    public int BossSp
    {
        get { return mBossSp; }
        set { mBossSp = value; }
    }

    public TimeBattle Battle
    {
        get { return mBattle; }
    }

    public TimeBattleFieldStateType CurrentState
    {
        get { return mState != null ? mState.State : TimeBattleFieldStateType.None; }
        set
        {
            if (CurrentState == value)
                return;
            int oldState = (int)CurrentState;
            if (mState != null)
                mState.OnLeave();

            mState = TimeBattleFieldState.Create(this, value);

            mCurrentStateFrame = 0;
            if (mState != null)
            {
                mState.OnEnter();
            }
        }
    }

    public override bool IsIdleState
    {
        get { return CurrentState == TimeBattleFieldStateType.None; }
    }

    public override bool IsFightingState
    {
        get { return CurrentState == TimeBattleFieldStateType.Fighting; }
    }

    public override int CurrentFieldState
    {
        get { return (int)CurrentState; }
    }


    public override string Name
    {
        get { return "TimeBattleField"; }
    }

    public TimeBattleField(TimeBattle battle,float maxBattleTime):
        base(battle,Vector3.zero,new Vector3(20,20,20),Vector3.forward)
    {
        mBattle = battle;
        FightingTime = 0;
        MaxFightingTime = maxBattleTime;
    }

    public void Start()
    {
        Result = FightingResult.None;
        FightingTime = 0;
        CurrentState = TimeBattleFieldStateType.Start;
    }

    public override void AddFighter(Fighter fighter)
    {
        base.AddFighter(fighter);
        if (mBattle != null)
            mBattle.FighterMgr.AddFighterToBattleField(fighter);

        if (fighter.IsTeamMember)
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

        if (fighter.IsTeamMember)
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
            UnityEngine.Profiling.Profiler.BeginSample("TimeBattleField update:" + mState.State);
#endif
            mState.Update(deltaTime);

#if PROFILE
            UnityEngine.Profiling.Profiler.EndSample();
#endif
        }
    }

    public override void PeaceEnd()
    {
        //if (Result != FightingResult.None)  //戰鬥已經有有結束 不可打斷結束
        //    return;
        //if (CurrentState != TimeBattleFieldStateType.Failed &&//不在退出流程 可以退出
        //      CurrentState != TimeBattleFieldStateType.Win &&
        //      CurrentState != TimeBattleFieldStateType.End &&
        //      CurrentState != TimeBattleFieldStateType.None)
        //{           
        //    Result = FightingResult.Failed;
        //    CurrentState = TimeBattleFieldStateType.Failed;           
        //    CurrentState = TimeBattleFieldStateType.End;
        //    CurrentState = TimeBattleFieldStateType.None;
        //}
        if (BattleSubMode.ClimbingTower == mBattle.BattMode && !Battle.IsPlayRecord)
        {
            if (Result == FightingResult.None)
            {
                Result = FightingResult.Peace;
            }
        }
        else
        {
            Result = FightingResult.Peace;
        }
    }
}
