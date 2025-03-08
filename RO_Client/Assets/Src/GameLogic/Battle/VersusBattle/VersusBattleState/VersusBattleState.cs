using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public enum VersusBattleStateType
{
    None,               //无状态，不执行任何操作
    Start,              //起始状态，执行初始化操作。自动进入预加载
    Preloading,         //预加载状态，加载部分战斗资源（场景信息等）。结束后进入战斗状态
    Battle,             //战斗状态。
    BattleWin,          //副本胜利状态
    BattleFailed,       //副本失败状态
    End,                //结束。释放资源等
}

delegate VersusBattleState VersusBattleStateCreator(VersusBattle battle);


public abstract class VersusBattleState
{
    static Dictionary<VersusBattleStateType, VersusBattleStateCreator> creators;

    public static VersusBattleState Create(VersusBattle battle, VersusBattleStateType state)
    {
        if (creators == null)
            RegisterCreators();
        return creators.ContainsKey(state) ? creators[state](battle) : null;
    }

    static void RegisterCreators()
    {
        creators = new Dictionary<VersusBattleStateType, VersusBattleStateCreator>();
        creators.Add(VersusBattleStateType.Start, VersusBattleStateStart.Creator);
        creators.Add(VersusBattleStateType.Preloading, VersusBattleStatePreloading.Creator);
        creators.Add(VersusBattleStateType.Battle, VersusBattleStateBattle.Creator);
        creators.Add(VersusBattleStateType.BattleWin, VersusBattleStateWin.Creator);
        creators.Add(VersusBattleStateType.BattleFailed, VersusBattleStateFailed.Creator);
        creators.Add(VersusBattleStateType.End, VersusBattleStateEnd.Creator);
    }

    protected VersusBattleStateType mState;
    protected VersusBattle mBattle;

    protected VersusBattleState(VersusBattle battle, VersusBattleStateType state)
    {
        mBattle = battle;
        mState = state;
    }

    public VersusBattleStateType State { get { return mState; } }

    protected void ChangeState(VersusBattleStateType state)
    {
        if (mBattle != null)
            mBattle.CurrentState = state;
    }

    public abstract void OnEnter();

    public abstract void OnLeave();

    public abstract void Update(float deltaTime);
}
