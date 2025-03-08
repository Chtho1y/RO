using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class LogicBattleStateWin : LogicBattleState
{
	public static LogicBattleState Creator (LogicBattle battle)
	{
		return new LogicBattleStateWin (battle);
	}

	public LogicBattleStateWin (LogicBattle battle) 
        : base (battle, LogicBattleStateType.BattleWin)
	{
	}

	float mWaitTime = 0;

	public override void OnEnter ()
	{
	}

	public override void OnLeave ()
	{
	}

	public override void Update (float deltaTime)
	{
		mBattle.FighterMgr.FixedUpdate (deltaTime);

		mWaitTime -= deltaTime;
		if (mWaitTime <= 0)
			ChangeState (LogicBattleStateType.End);
	}
}