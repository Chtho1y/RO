using UnityEngine;
using System.Collections;

public class VersusBattleStateWin : VersusBattleState
{
    public static VersusBattleState Creator(VersusBattle battle)
    {
        return new VersusBattleStateWin(battle);
    }

    public VersusBattleStateWin(VersusBattle battle)
        : base(battle, VersusBattleStateType.BattleWin)
    {
    }

    float mWaitTime = 0;
    public override void OnEnter()
    {
        mWaitTime = 3;
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
            ChangeState(VersusBattleStateType.End);
    }
}