using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class LogicBattleFieldStateFailed : LogicBattleFieldState
{
	public static LogicBattleFieldState Creator (LogicBattleField field)
	{
		return new LogicBattleFieldStateFailed (field);
	}

	public LogicBattleFieldStateFailed (LogicBattleField field) 
        : base (field, LogicBattleFieldStateType.Failed)
	{
       
    }

    float delayTime = 3;
    public override void OnEnter ()
	{
        PlayExitAnim();
        if (mField.killBoss)
        { 
            delayTime = mField.BattleInfo.BossDelayEndTime;
        }
        else
        { 
            delayTime = mField.BattleInfo.MonsterDelayEndTime;
        }
        //DebugHelper.LogError("delayTime:"+ delayTime);
    }

	public override void OnLeave ()
	{        
        Dispose();       
    }

	public override void Update (float deltaTime)
	{
        delayTime -= deltaTime;       
		if (delayTime <= 0)
        {
            ChangeState(LogicBattleFieldStateType.End);
        }
	}


    public override void OnDataChanged()
    {

    }

    void PlayExitAnim()
    {
        List<Fighter> fighters = mField.Fighters;
        for (int i = 0; i < fighters.Count; i++)
        {
            Fighter fighter = fighters[i];
            if (fighter.IsAlive)
            {
                fighter.ForceIdle();
                //fighter.StateData.PlayAnim("f_exit");
            }
        }
    }

    void Dispose()
	{   //刪除存活的敌方
		List<Fighter> fighters = mField.Fighters;
		for (int i = fighters.Count -1; i>=0 ; i--) {
            Fighter fighter = fighters[i];
            if (fighter.IsTeamMember)//如果非正常失败 角色没有死亡 会被删除 后续无法复活
                continue;
			if (fighter.IsAlive)
            {
                fighter.Dispose();
            }
		}
	}
}
