using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class BossBattleFieldStateFighting : BossBattleFieldState
{
    public static BossBattleFieldState Creator(BossBattleField field)
    {
        return new BossBattleFieldStateFighting(field);
    }

    public BossBattleFieldStateFighting(BossBattleField field)
        : base(field, BossBattleFieldStateType.Fighting)
    {
    }

    public override void OnEnter()
    {
        mField.OnFightingStart();
    }

    public override void OnLeave()
    {
        mField.OnFightingEnd();
    }

    public override void Update(float deltaTime)
    {
        mField.Battle.FighterMgr.FixedUpdate(deltaTime);

        if (!mField.Pause)
        {
            if (mField.Result == FightingResult.None)
                mField.CheckFightingResult(mField.Battle);

            switch (mField.Result)
            {
                case FightingResult.Win:
                    ChangeState(BossBattleFieldStateType.Win);
                    break;
                case FightingResult.Failed:
                    ChangeState(BossBattleFieldStateType.Failed);
                    break;
            }
        }
    }

    public override void OnDataChanged()
    {

    }
}
