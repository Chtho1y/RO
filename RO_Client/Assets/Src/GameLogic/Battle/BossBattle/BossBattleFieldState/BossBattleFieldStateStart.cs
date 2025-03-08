using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class BossBattleFieldStateStart : BossBattleFieldState
{
    public static BossBattleFieldState Creator(BossBattleField field)
    {
        return new BossBattleFieldStateStart(field);
    }

    public BossBattleFieldStateStart(BossBattleField field)
        : base(field, BossBattleFieldStateType.Start)
    {
    }

    public override void OnEnter()
    {
        if(mField.Battle.HasBossComingAnim)
        {
            BattleMgr.Instance.DisableBattleCamera();
        }

        mField.Battle.MoveToNextBattleField(false);
    }

    public override void OnLeave()
    {
    }

    public override void Update(float deltaTime)
    {
        if (IsFieldFightersReady())
        {
            if(mField.Battle.HasBossComingAnim)
            {
                ChangeState(BossBattleFieldStateType.AnimationBeforeInterlude);
            }
            else
            {
                ChangeState(BossBattleFieldStateType.Fighting);
            }
        }
        else
        {
            mField.Battle.FighterMgr.FixedUpdate(deltaTime);
        }
    }

    private bool IsFieldFightersReady()
    {
        List<Fighter> fighters = mField.Fighters;

        for (int idx = 0; idx < fighters.Count; idx++)
        {
            bool idleState = fighters[idx].IsIdle || fighters[idx].IsComing;
            if(!idleState)
                return false;
        }
        return true;
    }

    public override void OnDataChanged()
    {

    }
}
