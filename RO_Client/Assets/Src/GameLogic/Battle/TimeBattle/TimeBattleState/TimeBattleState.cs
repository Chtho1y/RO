using System.Collections;
using System.Collections.Generic;
using UnityEngine;

 public enum TimeBattleStateType
{
    None,               //无状态，不执行任何操作
    Start,              //起始状态，执行初始化操作。自动进入预加载
    Preloading,         //预加载状态，加载部分战斗资源（场景信息等）。结束后进入战斗状态
    Battle,             //战斗状态。
    BattleWin,          //副本胜利状态
    BattleFailed,       //副本失败状态
    End,                //结束,释放资源等
}

delegate TimeBattleState TimeBattleStateCreator(TimeBattle battle);


public abstract class TimeBattleState
{
    static Dictionary<TimeBattleStateType, TimeBattleStateCreator> creators;

    public static TimeBattleState Create(TimeBattle battle, TimeBattleStateType state)
    {
        if (creators == null)
            RegisterCreators();
        return creators.ContainsKey(state) ? creators[state](battle) : null;
    }

    static void RegisterCreators()
    {
        creators = new Dictionary<TimeBattleStateType, TimeBattleStateCreator>();
        creators.Add(TimeBattleStateType.Start, TimeBattleStateStart.Creator);
        creators.Add(TimeBattleStateType.Preloading, TimeBattleStatePreloading.Creator);
        creators.Add(TimeBattleStateType.Battle, TimeBattleStateBattle.Creator);
        creators.Add(TimeBattleStateType.BattleWin, TimeBattleStateWin.Creator);
        creators.Add(TimeBattleStateType.BattleFailed, TimeBattleStateFailed.Creator);
        creators.Add(TimeBattleStateType.End, TimeBattleStateEnd.Creator);
    }

    protected TimeBattleStateType mState;
    protected TimeBattle mBattle;

    protected TimeBattleState(TimeBattle battle, TimeBattleStateType state)
    {
        mBattle = battle;
        mState = state;
    }

    public TimeBattleStateType State { get { return mState; } }

    protected void ChangeState(TimeBattleStateType state)
    {
        if (mBattle != null)
            mBattle.CurrentState = state;
    }

    public abstract void OnEnter();

    public abstract void OnLeave();

    public abstract void Update(float deltaTime);
}
