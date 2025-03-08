using UnityEngine;
using System.Collections;

public class VersusBattleStateFailed : VersusBattleState
{
    public static VersusBattleState Creator(VersusBattle battle)
    {
        return new VersusBattleStateFailed(battle);
    }

    public VersusBattleStateFailed(VersusBattle battle)
        : base(battle, VersusBattleStateType.BattleFailed)
    {
    }

    float mWaitTime = 0;
    public override void OnEnter()
    {
        mWaitTime = 3;
        BattleMgr.Instance.OnBattleFailed(false);
    }

    public override void OnLeave()
    {
    }

    public override void Update(float deltaTime)
    {
        mBattle.FighterMgr.FixedUpdate(deltaTime);

        mWaitTime -= deltaTime;
        if (mWaitTime <= 0)
            ChangeState(VersusBattleStateType.End);
    }
}
