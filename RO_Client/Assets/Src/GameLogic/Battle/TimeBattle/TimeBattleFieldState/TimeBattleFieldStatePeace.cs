using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class TimeBattleFieldStatePeace : TimeBattleFieldState
{
    public static TimeBattleFieldStatePeace Creator(TimeBattleField field)
    {
        return new TimeBattleFieldStatePeace(field);
    }

    public TimeBattleFieldStatePeace(TimeBattleField field) :
       base(field, TimeBattleFieldStateType.Peace)
    {

    }

    float delayTime = 2;
    public override void OnEnter()
    {
        for (int idx = 0; idx < mField.TeamFighters.Count; idx++)
        {
            if (mField.TeamFighters[idx].IsAlive)
            {
                mField.TeamFighters[idx].ForceIdle();
            }
        }

        List<Fighter> fighters = mField.EnemyFighters;
        for (int i = fighters.Count - 1; i >= 0 ; i--)
        {
            Fighter fighter = fighters[i];
            if (fighter.IsAlive)
            {
                fighter.Dispose();
            }
        }
    }

    public override void Update(float deltaTime)
    {
        mField.Battle.FighterMgr.FixedUpdate(deltaTime);

        delayTime -= deltaTime;
        if (delayTime <= 0)
        {
            ChangeState(TimeBattleFieldStateType.End);
        }
    }

    public override void OnLeave()
    {
    }

    public override void OnDataChanged()
    {

    }
}
