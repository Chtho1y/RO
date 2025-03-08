using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class VersusBattleFieldStateWin : VersusBattleFieldState
{
    public static VersusBattleFieldState Creator(VersusBattleField field)
    {
        return new VersusBattleFieldStateWin(field);
    }

    public VersusBattleFieldStateWin(VersusBattleField field)
        : base(field, VersusBattleFieldStateType.Win)
    {
    }

    float delayTime = 0;
    public override void OnEnter()
    {
        for (int idx = 0; idx < mField.TeamFighters.Count; idx++)
        {
            if (mField.TeamFighters[idx].IsAlive)
            {
                mField.TeamFighters[idx].ForceIdle();
            }
        }
    }

    public override void OnLeave()
    {
    }

    public override void Update(float deltaTime)
    {
        mField.Battle.FighterMgr.FixedUpdate(deltaTime);

        delayTime -= deltaTime;
        if (delayTime <= 0)
        {
            ChangeState(VersusBattleFieldStateType.End);
        }
    }

    public override void OnDataChanged()
    {

    }
}
