using UnityEngine;
using System.Collections;

public class BossBattleFieldStateFailed : BossBattleFieldState
{
    public static BossBattleFieldState Creator(BossBattleField field)
    {
        return new BossBattleFieldStateFailed(field);
    }

    public BossBattleFieldStateFailed(BossBattleField field)
        : base(field, BossBattleFieldStateType.Failed)
    {
    }

    float delayTime = 3;
    public override void OnEnter()
    {
        delayTime = 3;
    }

    public override void OnLeave()
    {
    }

    public override void Update(float deltaTime)
    {
        delayTime -= deltaTime;
        mField.Battle.FighterMgr.FixedUpdate(deltaTime);

        if (delayTime <= 0)
        {
            ChangeState(BossBattleFieldStateType.End);
        }
    }

    public override void OnDataChanged()
    {

    }
}