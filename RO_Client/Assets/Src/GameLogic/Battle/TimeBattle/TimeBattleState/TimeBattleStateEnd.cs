using UnityEngine;
using System.Collections;

public class TimeBattleStateEnd : TimeBattleState
{
    public static TimeBattleStateEnd Creator(TimeBattle battle)
    {
        return new TimeBattleStateEnd(battle);
    }

    float delayTime = 1;
    public TimeBattleStateEnd(TimeBattle battle):
        base(battle, TimeBattleStateType.End)
    {
        BattleCamera.Instance.DisableDynamicCamera();
        mBattle.CleanAllFighter();
        delayTime = 1;
    }

    public override void OnEnter()
    {
        BattleMgr.Instance.OnBattleEnd();
    }

    public override void Update(float deltaTime)
    {
        if (delayTime > 0)
        {
            delayTime -= deltaTime;
            if (delayTime <= 0)
            {
                ChangeState(TimeBattleStateType.None);
            }
        }
    }

    public override void OnLeave()
    {
        
    }
}
