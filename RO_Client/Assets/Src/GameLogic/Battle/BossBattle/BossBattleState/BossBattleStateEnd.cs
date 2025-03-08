using UnityEngine;
using System.Collections;

public class BossBattleStateEnd : BossBattleState
{
    public static BossBattleStateEnd Creator(BossBattle battle)
    {
        return new BossBattleStateEnd(battle);
    }

    public BossBattleStateEnd(BossBattle battle) :
        base(battle, BossBattleStateType.End)
    {

    }

    public override void OnEnter()
    {
        BattleMgr.Instance.OnBattleEnd(mBattle.CurBattleField.IsWin?1:2);
    }

    public override void OnLeave()
    {

    }

    public override void Update(float deltaTime)
    {
        ChangeState(BossBattleStateType.None);
    }
}
