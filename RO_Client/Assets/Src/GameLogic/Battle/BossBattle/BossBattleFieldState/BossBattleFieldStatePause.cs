using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class BossBattleFieldStatePause : BossBattleFieldState
{
    public static BossBattleFieldState Creator(BossBattleField field)
    {
        return new BossBattleFieldStatePause(field);
    }

    public BossBattleFieldStatePause(BossBattleField field)
        :base(field,BossBattleFieldStateType.Pause)
    {

    }

    public override void OnEnter()
    {
        for (int idx = 0; idx < mField.Fighters.Count; idx++)
        {
            if (mField.Fighters[idx].IsAlive)
            {
                mField.Fighters[idx].ForceIdle();
            }
        }
    }

    public override void Update(float deltaTime)
    {
        //if (IsFieldFightersReady())
        //{
        //    ChangeState(BossBattleFieldStateType.Fighting);
        //}
        //else
        //{
            mField.Battle.FighterMgr.FixedUpdate(deltaTime);
        //}
    }

    public override void OnLeave()
    {

    }

    public override void OnDataChanged()
    {

    }

    private bool IsFieldFightersReady()
    {
        List<Fighter> fighters = mField.Fighters;

        for (int idx = 0; idx < fighters.Count; idx++)
        {
            bool idleState = fighters[idx].IsIdle;
            if (!idleState)
                return false;
        }
        return true;
    }
}
