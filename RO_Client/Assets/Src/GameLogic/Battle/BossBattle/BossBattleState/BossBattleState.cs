using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public enum BossBattleStateType
{
    None,               //无状态，不执行任何操作
    Start,              //起始状态，执行初始化操作。自动进入预加载
    Preloading,         //预加载状态，加载部分战斗资源（场景信息等）。结束后进入战斗状态
    Battle,             //战斗状态。
    BattleWin,          //副本胜利状态
    BattleFailed,       //副本失败状态
    End,                //结束,释放资源等
}

delegate BossBattleState BossBattleStateCreator(BossBattle battle);

public abstract class BossBattleState
{
    static Dictionary<BossBattleStateType, BossBattleStateCreator> creators;

    public static BossBattleState Create(BossBattle battle, BossBattleStateType state)
    {
        if (creators == null)
            RegisterCreators();
        return creators.ContainsKey(state) ? creators[state](battle) : null;
    }

    static void RegisterCreators()
    {
        creators = new Dictionary<BossBattleStateType, BossBattleStateCreator>();
        creators.Add(BossBattleStateType.Start, BossBattleStateStart.Creator);
        creators.Add(BossBattleStateType.Preloading, BossBattleStatePreloading.Creator);
        creators.Add(BossBattleStateType.Battle, BossBattleStateBattle.Creator);
        creators.Add(BossBattleStateType.BattleWin, BossBattleStateWin.Creator);
        creators.Add(BossBattleStateType.BattleFailed, BossBattleStateFailed.Creator);
        creators.Add(BossBattleStateType.End, BossBattleStateEnd.Creator);
    }

    protected BossBattleStateType mState;
    protected BossBattle mBattle;

    protected BossBattleState(BossBattle battle, BossBattleStateType state)
    {
        mBattle = battle;
        mState = state;
    }

    public BossBattleStateType State { get { return mState; } }

    protected void ChangeState(BossBattleStateType state)
    {
        if (mBattle != null)
            mBattle.CurrentState = state;
    }

    public abstract void OnEnter();

    public abstract void OnLeave();

    public abstract void Update(float deltaTime);
}
