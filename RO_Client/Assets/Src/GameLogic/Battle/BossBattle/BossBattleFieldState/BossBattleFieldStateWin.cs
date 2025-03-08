using UnityEngine;
using System.Collections;

public class BossBattleFieldStateWin : BossBattleFieldState
{
    public static BossBattleFieldState Creator(BossBattleField field)
    {
        return new BossBattleFieldStateWin(field);
    }

    public BossBattleFieldStateWin(BossBattleField field)
        : base(field, BossBattleFieldStateType.Win)
    {
    }

    float delayTime = 3;
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
            ChangeState(BossBattleFieldStateType.End);
        }
    }

    public override void OnDataChanged()
    {

    }
}