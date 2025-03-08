using UnityEngine;
using System.Collections;

public class TimeBattleStateFailed : TimeBattleState
{
    public static TimeBattleStateFailed Creator(TimeBattle battle)
    {
        return new TimeBattleStateFailed(battle);
    }

    public TimeBattleStateFailed(TimeBattle battle):
        base(battle,TimeBattleStateType.BattleFailed)
    {

    }

    float mWaitTime = 0;
    public override void OnEnter()
    {
        mWaitTime = 1;      
        BattleMgr.Instance.OnBattleFailed(false,mBattle.BossLife,mBattle.BossSp);
    }

    public override void Update(float deltaTime)
    {
        mBattle.FighterMgr.FixedUpdate(deltaTime);

        mWaitTime -= deltaTime;
        if (mWaitTime <= 0)
            ChangeState(TimeBattleStateType.End);
    }

    public override void OnLeave()
    {
        
    }
}
