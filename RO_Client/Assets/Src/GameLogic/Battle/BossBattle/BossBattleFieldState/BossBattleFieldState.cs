using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public enum BossBattleFieldStateType
{
    None,                       //无状态，不执行任何操作
    Start,                      //起始状态
    AnimationBeforeInterlude,   //过场前动画
    DialogBeforeInterlude,      //过场前对话
    Interlude,                  //过场(in：相机TransitionIn，执行开场相机动画 （若有），激活更新触发器逻辑  out：所有角色就位准备)
    Fighting,                   //战斗
    Pause,                      //暂停
    Win,                        //胜利（人物归位）
    Failed,                     //失败（人物归位）
    End,                        //结束
}

delegate BossBattleFieldState BossBattleFieldStateCreator(BossBattleField field);

public abstract class BossBattleFieldState
{
    static Dictionary<BossBattleFieldStateType, BossBattleFieldStateCreator> creators;

    public static BossBattleFieldState Create(BossBattleField field, BossBattleFieldStateType state)
    {
        if (creators == null)
            RegisterCreators();

        return creators.ContainsKey(state) ? creators[state](field) : null;
    }

    static void RegisterCreators()
    {
        creators = new Dictionary<BossBattleFieldStateType, BossBattleFieldStateCreator>();
        creators.Add(BossBattleFieldStateType.Start, BossBattleFieldStateStart.Creator);
        creators.Add(BossBattleFieldStateType.AnimationBeforeInterlude, BossBattleFieldStateAnimationBI.Creator);
        creators.Add(BossBattleFieldStateType.DialogBeforeInterlude, BossBattleFieldStateDialogBI.Creator);
        creators.Add(BossBattleFieldStateType.Interlude, BossBattleFieldStateInterlude.Creator);
        creators.Add(BossBattleFieldStateType.Fighting, BossBattleFieldStateFighting.Creator);
        creators.Add(BossBattleFieldStateType.Win, BossBattleFieldStateWin.Creator);
        creators.Add(BossBattleFieldStateType.Failed, BossBattleFieldStateFailed.Creator);
        creators.Add(BossBattleFieldStateType.End, BossBattleFieldStateEnd.Creator);
    }

    protected BossBattleFieldStateType mState;
    protected BossBattleField mField;

    protected BossBattleFieldState(BossBattleField field, BossBattleFieldStateType state)
    {
        mField = field;
        mState = state;
    }

    public BossBattleFieldStateType State { get { return mState; } }

    public float StateTime { get; protected set; }

    protected void ChangeState(BossBattleFieldStateType state)
    {
        if (mField != null)
            mField.CurrentState = state;
    }

    public abstract void OnEnter();

    public abstract void OnLeave();

    public abstract void Update(float deltaTime);

    public abstract void OnDataChanged();
}
