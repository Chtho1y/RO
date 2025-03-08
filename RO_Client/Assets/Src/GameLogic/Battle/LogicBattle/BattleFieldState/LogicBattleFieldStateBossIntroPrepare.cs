using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// boss出场结束后的就位阶段
/// </summary>
public class LogicBattleFieldStateBossIntroPrepare : LogicBattleFieldState
{

    public static LogicBattleFieldStateBossIntroPrepare Creator(LogicBattleField field)
    {
        return new LogicBattleFieldStateBossIntroPrepare(field);
    }

    public LogicBattleFieldStateBossIntroPrepare(LogicBattleField field)
       : base(field, LogicBattleFieldStateType.BossIntroPrepare)
    {
    }

    float leftTime = 1;

    public override void OnEnter()
    {
       
    }

    public override void Update(float deltaTime)
    {
        leftTime -= deltaTime;
        if (leftTime <= 0)
        {
            //ChangeState(LogicBattleFieldStateType.Prepare);
        }
        else
        {
            mField.Battle.FighterMgr.FixedUpdate(deltaTime);
        }
    }

    public override void OnLeave()
    {
    }

    public override void OnDataChanged()
    {

    }
}
