using UnityEngine;
using System.Collections;

public class TimeBattleFieldStateStart : TimeBattleFieldState
{
    public static TimeBattleFieldStateStart Creator(TimeBattleField field)
    {
        return new TimeBattleFieldStateStart(field);
    }

    public TimeBattleFieldStateStart(TimeBattleField field):
        base(field,TimeBattleFieldStateType.Start)
    {

    }

    public override void OnEnter()
    {
    }

    public override void OnLeave()
    {
        
    }

    public override void Update(float deltaTime)
    {
        if (mField.Battle.IsAllFightersReady())
        {
            ChangeState(TimeBattleFieldStateType.Fighting);
        }
        else
        {
            mField.Battle.FighterMgr.FixedUpdate(deltaTime);
        }
    }

    public override void OnDataChanged()
    {
        
    }
}
