using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class TimeBattleFieldStateFailed : TimeBattleFieldState
{
    public static TimeBattleFieldStateFailed Creator(TimeBattleField field)
    {
        return new TimeBattleFieldStateFailed(field);
    }

    public TimeBattleFieldStateFailed(TimeBattleField field) :
        base(field, TimeBattleFieldStateType.Win)
    {
        
    }

    float delayTime = 3;
    public override void OnEnter()
    {
        delayTime = 0;
    }

    public override void Update(float deltaTime)
    {
        delayTime -= deltaTime;
        mField.Battle.FighterMgr.FixedUpdate(deltaTime);

        if (delayTime <= 0)
        {
            ChangeState(TimeBattleFieldStateType.End);
        }
    }

    public override void OnLeave()
    {
        Dispose();
    }

    public override void OnDataChanged()
    {

    }

    void Dispose()
    {
        List<Fighter> fighters = mField.EnemyFighters;
        for (int i = fighters.Count-1; i >= 0; i--)
        {
            Fighter fighter = fighters[i];
            if (fighter.IsAlive)
            {
                if(fighter.IsBoss)
                {
                    mField.BossLife = (int)fighter.Life;
                    mField.BossSp = (int)fighter.Sp;
                }
                fighter.Dispose();
            }
        }
    }
}
