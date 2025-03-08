using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public enum LogicBattleFieldStateType
{
	None,                       //无状态，不执行任何操作
	DialogBeforeSearch,			//巡游前对话
	Search,                     //寻敌阶段(英雄一直往前跑)
	Start,                      //刷怪阶段（提示信息，怪物刷新，站位变化）
	Prepare,                    //准备阶段（buff Debuff阶段，接近阶段，战场位置说明）
    BossIntro,                  //boss出场阶段
    BossIntroPrepare,           //boss出场结束后，准备阶段
    StartingFight,              //开始战斗（开始战斗UI动画，相机切换到开战）
	Fighting,                   //战斗
	Win,                        //胜利（人物归位）
	Failed,                     //失败（人物归位）
	End,                        //结束


    EditorFighting,             //编辑器单机战斗
}

delegate LogicBattleFieldState LogicBattleFieldStateCreator (LogicBattleField field);


public abstract class LogicBattleFieldState
{
	static Dictionary<LogicBattleFieldStateType, LogicBattleFieldStateCreator> creators;

	public static LogicBattleFieldState Create (LogicBattleField field, LogicBattleFieldStateType state)
	{
		if (creators == null)
			RegisterCreators ();
		return creators.ContainsKey (state) ? creators [state] (field) : null;
	}

	static void RegisterCreators ()
	{
		creators = new Dictionary<LogicBattleFieldStateType, LogicBattleFieldStateCreator> ();
		creators.Add(LogicBattleFieldStateType.DialogBeforeSearch, LogicBattleFieldStateDialogBS.Creator);
        creators.Add(LogicBattleFieldStateType.Search, LogicBattleFieldStateSearch.Creator);
		creators.Add(LogicBattleFieldStateType.Start, LogicBattleFieldStateStart.Creator);
        creators.Add(LogicBattleFieldStateType.BossIntro, LogicBattleFieldStateBossIntro.Creator);
        creators.Add(LogicBattleFieldStateType.BossIntroPrepare, LogicBattleFieldStateBossIntroPrepare.Creator);
		creators.Add(LogicBattleFieldStateType.StartingFight, LogicBattleFieldStateStartingFight.Creator);
		creators.Add(LogicBattleFieldStateType.Fighting, LogicBattleFieldStateFighting.Creator);
		creators.Add(LogicBattleFieldStateType.Win, LogicBattleFieldStateWin.Creator);
		creators.Add(LogicBattleFieldStateType.Failed, LogicBattleFieldStateFailed.Creator);
		creators.Add(LogicBattleFieldStateType.End, LogicBattleFieldStateEnd.Creator);

        creators.Add(LogicBattleFieldStateType.EditorFighting, LogicBattleFieldStateEditorFighting.Creator);
	}

	protected LogicBattleFieldStateType mState;
	protected LogicBattleField mField;

	protected LogicBattleFieldState (LogicBattleField field, LogicBattleFieldStateType state)
	{
		mField = field;
		mState = state;
	}

    public LogicBattleFieldStateType State { get { return mState; } }

	public float StateTime { get; protected set; }

	protected void ChangeState (LogicBattleFieldStateType state)
	{
		if (mField != null)
			mField.CurrentState = state;
	}

	public abstract void OnEnter ();

	public abstract void OnLeave ();

	public abstract void Update (float deltaTime);

    public abstract void OnDataChanged();
}
