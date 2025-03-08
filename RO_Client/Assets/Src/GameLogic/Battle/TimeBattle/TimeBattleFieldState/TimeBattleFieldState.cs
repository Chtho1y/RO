using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum TimeBattleFieldStateType
{
    None,                       //无状态，不执行任何操作
    Start,                      //起始状态
    Fighting,                   //战斗
    Win,                        //胜利
    Failed,                     //失败
    Peace,                      //
    End,                        //结束
}

delegate TimeBattleFieldState TimeBattleFieldStateCreator(TimeBattleField field);

public abstract class TimeBattleFieldState
{
    static Dictionary<TimeBattleFieldStateType, TimeBattleFieldStateCreator> creators;

    public static TimeBattleFieldState Create(TimeBattleField field, TimeBattleFieldStateType state)
    {
        if (creators == null)
            RegisterCreators();

        return creators.ContainsKey(state) ? creators[state](field) : null;
    }

    static void RegisterCreators()
    {
        creators = new Dictionary<TimeBattleFieldStateType, TimeBattleFieldStateCreator>();
        creators.Add(TimeBattleFieldStateType.Start, TimeBattleFieldStateStart.Creator);
        creators.Add(TimeBattleFieldStateType.Fighting, TimeBattleFieldStateFighting.Creator);
        creators.Add(TimeBattleFieldStateType.Win, TimeBattleFieldStateWin.Creator);
        creators.Add(TimeBattleFieldStateType.Failed, TimeBattleFieldStateFailed.Creator);
        creators.Add(TimeBattleFieldStateType.Peace, TimeBattleFieldStatePeace.Creator);
        creators.Add(TimeBattleFieldStateType.End, TimeBattleFieldStateEnd.Creator);
    }

    protected TimeBattleFieldStateType mState;
    protected TimeBattleField mField;

    protected TimeBattleFieldState(TimeBattleField field, TimeBattleFieldStateType state)
    {
        mField = field;
        mState = state;
    }

    public TimeBattleFieldStateType State { get { return mState; } }

    public float StateTime { get; protected set; }

    protected void ChangeState(TimeBattleFieldStateType state)
    {
        if (mField != null)
            mField.CurrentState = state;
    }

    public abstract void OnEnter();

    public abstract void OnLeave();

    public abstract void Update(float deltaTime);

    public abstract void OnDataChanged();
}
