using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class LogicBattleFieldStateWin : LogicBattleFieldState
{
	public static LogicBattleFieldState Creator (LogicBattleField field)
	{
		return new LogicBattleFieldStateWin (field);
	}

	public LogicBattleFieldStateWin (LogicBattleField field) 
        : base (field, LogicBattleFieldStateType.Win)
	{
	}

    float delayTime = 3;
	public override void OnEnter ()
	{
        for(int idx = 0; idx < mField.TeamFighters.Count;idx++)
        {
            if (mField.TeamFighters[idx].IsAlive)
            {
                mField.TeamFighters[idx].ForceIdle();
            }

        }

        if (mField.Battle.Recorder != null)
        {
            if (!mField.Battle.IsPlayRecord)
            {
                mField.Battle.Recorder.RecordBattleEnd(mField.IsWin);
            }
            else
            {
                mField.Battle.Recorder.CalculateReplayResult();
            }
        }

        mField.BattleInfo.HasPassed = mField.killBoss;
        if (!mField.Battle.IsPlayRecord)
        {
            if (mField.killBoss)
                delayTime = mField.BattleInfo.BossDelayEndTime;
            else
                delayTime = mField.BattleInfo.MonsterDelayEndTime;
        }
        else
        {
            delayTime = GlobalConfig.Instance.GetConfigIntValue(166);
        }
    }

	public override void OnLeave ()
	{
    }

	public override void Update (float deltaTime)
	{
        delayTime -= deltaTime;
        if (CheckAllFightersReady() && delayTime<=0)
        {			
			ChangeState(LogicBattleFieldStateType.End);
        }
	}

    public override void OnDataChanged()
    {

    }

    bool CheckAllFightersReady()
	{
		List<Fighter> fighters = mField.Fighters;
		for (int i = 0; i < fighters.Count; i++)
        {
            Fighter fighter = fighters[i];
            if (fighter.IsDisposed || fighter.IsDestroy || null == fighter.Actor)
				continue;

			if (fighter.IsAlive)
            {
				if (mField.DisableWaitFighterReadyOnWin)
					ForceSetFighter (fighter);	
				else if (!fighter.IsIdle)
					return false;
			}
		}
		return true;
	}

	void ForceSetFighter(Fighter fighter)
	{
		if (!fighter.IsIdle)
			fighter.ForceIdle ();
	}
}
