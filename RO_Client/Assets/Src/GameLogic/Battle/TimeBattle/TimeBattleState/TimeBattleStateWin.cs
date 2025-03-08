using UnityEngine;
using System.Collections;

public class TimeBattleStateWin : TimeBattleState
{
    public static TimeBattleStateWin Creator(TimeBattle battle)
    {
        return new TimeBattleStateWin(battle);
    }

    public TimeBattleStateWin(TimeBattle battle):
        base(battle,TimeBattleStateType.BattleWin)
    {

    }

    float mWaitTime = 0;
    public override void OnEnter()
    {
        mWaitTime = 1;
        BattleMgr.Instance.OnBattleWin(true);
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
