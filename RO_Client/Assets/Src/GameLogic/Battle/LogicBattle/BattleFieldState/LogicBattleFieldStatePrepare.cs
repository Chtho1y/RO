using UnityEngine;
using System.Collections;
using System.Collections.Generic;

//开始准备状态
public class LogicBattleFieldStatePrepare : LogicBattleFieldState
{
	public static LogicBattleFieldState Creator (LogicBattleField field)
	{
		return new LogicBattleFieldStatePrepare (field);
	}

	public LogicBattleFieldStatePrepare (LogicBattleField field) 
        : base (field, LogicBattleFieldStateType.Prepare)
	{
	}

	public override void OnEnter ()
	{
        List<Fighter> fighters = mField.Battle.FighterMgr.TeamFighters;
        for (int idx = 0; idx < fighters.Count; idx++)
        {
            fighters[idx].ForceIdle();
        }     
    }

	public override void OnLeave ()
	{
	}

	public override void Update (float deltaTime)
	{
        mField.Battle.FighterMgr.FixedUpdate(deltaTime);

        if (CheckBothTeamFighterReady())
        {
            ChangeState(LogicBattleFieldStateType.StartingFight);
        }
    }

    public override void OnDataChanged()
    {

    }

    bool CheckBothTeamFighterReady ()
	{
		bool hasLeft = false;
		bool hasRight = false;
		foreach (var fighter in mField.Fighters) {
			if (!fighter.IsIdle)
				return false;
			hasLeft |= fighter.TeamSide == eTeamType.Friend;
			hasRight |= fighter.TeamSide == eTeamType.Enemy;
		}
		return hasLeft && hasRight;
	}
}
