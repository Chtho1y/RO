using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public enum VersusBattleFieldStateType
{
    None,                       //无状态，不执行任何操作
    Start,                      //准备阶
    Interlude,                  //过场 （in：相机TransitionIn，执行开场相机动画 （若有），激活更新触发器逻辑  out：所有角色就位准备）
    StartingFight,              //开始战斗（角色跑到战场）
    Fighting,                   //战斗
    Win,                        //胜利（人物归位）
    Failed,                     //失败（人物归位）
    End,                        //结束
}

delegate VersusBattleFieldState VersusBattleFieldStateCreator(VersusBattleField field);

public abstract class VersusBattleFieldState
{
    static Dictionary<VersusBattleFieldStateType, VersusBattleFieldStateCreator> creators;

    public static VersusBattleFieldState Create(VersusBattleField field,VersusBattleFieldStateType state)
    {
        if (creators == null)
            RegisterCreators();

        return creators.ContainsKey(state) ? creators[state](field) : null;
    }

    static void RegisterCreators()
    {
        creators = new Dictionary<VersusBattleFieldStateType, VersusBattleFieldStateCreator>();
        creators.Add(VersusBattleFieldStateType.Start, VersusBattleFieldStateStart.Creator);
        creators.Add(VersusBattleFieldStateType.Interlude, VersusBattleFieldStateInterlude.Creator);
        creators.Add(VersusBattleFieldStateType.StartingFight, VersusBattleFieldStateStartingFight.Creator);
        creators.Add(VersusBattleFieldStateType.Fighting, VersusBattleFieldStateFighting.Creator);
        creators.Add(VersusBattleFieldStateType.Win, VersusBattleFieldStateWin.Creator);
        creators.Add(VersusBattleFieldStateType.Failed, VersusBattleFieldStateFailed.Creator);
        creators.Add(VersusBattleFieldStateType.End, VersusBattleFieldStateEnd.Creator);
    }

    protected VersusBattleFieldStateType mState;
    protected VersusBattleField mField;

    protected VersusBattleFieldState(VersusBattleField field, VersusBattleFieldStateType state)
    {
        mField = field;
        mState = state;
    }

    public VersusBattleFieldStateType State { get { return mState; } }

    public float StateTime { get; protected set; }

    protected void ChangeState(VersusBattleFieldStateType state)
    {
        if (mField != null)
            mField.CurrentState = state;
    }

    public abstract void OnEnter();

    public abstract void OnLeave();

    public abstract void Update(float deltaTime);

    public abstract void OnDataChanged();
}
