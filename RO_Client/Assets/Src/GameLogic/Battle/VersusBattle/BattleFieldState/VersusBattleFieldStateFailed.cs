using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class VersusBattleFieldStateFailed : VersusBattleFieldState
{
    public static VersusBattleFieldState Creator(VersusBattleField field)
    {
        return new VersusBattleFieldStateFailed(field);
    }

    public VersusBattleFieldStateFailed(VersusBattleField field)
        : base(field, VersusBattleFieldStateType.Failed)
    {
    }

    float delayTime = 3;
    public override void OnEnter()
    {
        delayTime = 0;
    }

    public override void OnLeave()
    {
        Dispose();
    }

    public override void Update(float deltaTime)
    {
        delayTime -= deltaTime;
        mField.Battle.FighterMgr.FixedUpdate(deltaTime);

        if (delayTime <= 0)
        {
            ChangeState(VersusBattleFieldStateType.End);
        }
    }

    public override void OnDataChanged()
    {

    }

    void Dispose()
    {
        List<Fighter> fighters = mField.EnemyFighters;
        for (int i = fighters.Count -1; i >= 0; i--)
        {
            Fighter fighter = fighters[i];
            if (fighter.IsAlive)
            {
                fighter.Dispose();
            }
        }
    }
}