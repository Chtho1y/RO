using UnityEngine;
using System.Collections;

public class BossBattleStateFailed : BossBattleState
{

    public static BossBattleStateFailed Creator(BossBattle battle)
    {
        return new BossBattleStateFailed(battle);
    }

    public BossBattleStateFailed(BossBattle battle) :
        base(battle, BossBattleStateType.BattleFailed)
    {

    }

    float mWaitTime = 0;

    public override void OnEnter()
    {
        mWaitTime = 1;
        BattleMgr.Instance.OnBattleFailed(true);
    }

    public override void OnLeave()
    {

    }

    public override void Update(float deltaTime)
    {
        mBattle.FighterMgr.FixedUpdate(deltaTime);

        mWaitTime -= deltaTime;
        if (mWaitTime <= 0)
            ChangeState(BossBattleStateType.End);
    }
}
