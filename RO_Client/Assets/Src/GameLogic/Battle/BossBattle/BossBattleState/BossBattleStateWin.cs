using UnityEngine;
using System.Collections;

public class BossBattleStateWin : BossBattleState
{
    public static BossBattleStateWin Creator(BossBattle battle)
    {
        return new BossBattleStateWin(battle);
    }

    public BossBattleStateWin(BossBattle battle) :
        base(battle, BossBattleStateType.BattleWin)
    {

    }

    float mWaitTime = 0;
    public override void OnEnter()
    {
        mWaitTime = 1;
        BattleMgr.Instance.OnBattleWin(true);
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
