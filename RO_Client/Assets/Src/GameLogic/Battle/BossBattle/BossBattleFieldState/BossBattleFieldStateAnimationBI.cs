using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class BossBattleFieldStateAnimationBI : BossBattleFieldState
{
    public static BossBattleFieldState Creator(BossBattleField field)
    {
        return new BossBattleFieldStateAnimationBI(field);
    }

    public BossBattleFieldStateAnimationBI(BossBattleField field)
        :base(field,BossBattleFieldStateType.AnimationBeforeInterlude)
    {

    }

    float waitingTime = 0;
    public override void OnEnter()
    {
        waitingTime = mField.Battle.BossComingTime;
        BattleMgr.Instance.HideBattleUI();
        BattleMgr.Instance.DisableBattleCamera();
        BattleMgr.Instance.ShowComingCamera();
    }

    public override void Update(float deltaTime)
    {
        mField.Battle.FighterMgr.FixedUpdate(deltaTime);
        waitingTime -= deltaTime;
        if(waitingTime <=0 && IsFieldFightersReady() && !mField.Pause)
        {
            ChangeState(BossBattleFieldStateType.Fighting);
        }
    }

    public override void OnLeave()
    {
        BattleMgr.Instance.HideComingCamera();
        BattleMgr.Instance.ShowBattleUI();
        BattleMgr.Instance.EnableBattleCamera();
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

    public override void OnDataChanged()
    {
        
    }
}
