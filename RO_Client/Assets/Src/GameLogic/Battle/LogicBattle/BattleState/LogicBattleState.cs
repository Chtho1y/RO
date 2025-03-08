using System.Collections.Generic;

public enum LogicBattleStateType
{
	None,               //无状态，不执行任何操作
	Start,              //起始状态，执行初始化操作。自动进入预加载
	Preloading,         //预加载状态，加载部分战斗资源（场景信息等）。结束后进入战斗状态
	Battle,             //战斗状态。
	BattleWin,          //副本胜利状态
	BattleFailed,       //副本失败状态
	End,                //结束。释放资源等
}

delegate LogicBattleState LogicBattleStateCreator (LogicBattle battle);

public abstract class LogicBattleState
{
	static Dictionary<LogicBattleStateType, LogicBattleStateCreator> creators;

	public static LogicBattleState Create (LogicBattle battle, LogicBattleStateType state)
	{
		if (creators == null)
			RegisterCreators ();
		return creators.ContainsKey (state) ? creators [state] (battle) : null;
	}

	static void RegisterCreators ()
	{
		creators = new Dictionary<LogicBattleStateType, LogicBattleStateCreator> ();
		creators.Add (LogicBattleStateType.Start, LogicBattleStateStart.Creator);
		creators.Add (LogicBattleStateType.Preloading, LogicBattleStatePreloading.Creator);
		creators.Add (LogicBattleStateType.Battle, LogicBattleStateBattle.Creator);
		creators.Add (LogicBattleStateType.BattleWin, LogicBattleStateWin.Creator);
		creators.Add (LogicBattleStateType.End, LogicBattleStateEnd.Creator);
	}

	protected LogicBattleStateType mState;
	protected LogicBattle mBattle;

	protected LogicBattleState (LogicBattle battle, LogicBattleStateType state)
	{
		mBattle = battle;
		mState = state;
	}

	public LogicBattleStateType State { get { return mState; } }

	protected void ChangeState (LogicBattleStateType state)
	{
		if (mBattle != null)
			mBattle.CurrentState = state;
	}

	public abstract void OnEnter ();

	public abstract void OnLeave ();

	public abstract void Update (float deltaTime);
}
