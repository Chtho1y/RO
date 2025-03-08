using UnityEngine;
using System.Collections;

public class VersusBattleStateEnd : VersusBattleState
{
    public static VersusBattleState Creator(VersusBattle battle)
    {
        return new VersusBattleStateEnd(battle);
    }

    public VersusBattleStateEnd(VersusBattle battle)
        : base(battle, VersusBattleStateType.End)
    {
    }

    float delayTime = 1;
    public override void OnEnter()
    {
        BattleMgr.Instance.ShowBattleEndInterlude();
        BattleCamera.Instance.DisableDynamicCamera();
        mBattle.CleanAllFighter();
        delayTime = 1;
    }

    public override void OnLeave()
    {
        BattleMgr.Instance.OnBattleEnd();
    }

    public override void Update(float deltaTime)
    {
        if(delayTime > 0)
        {
            delayTime -= deltaTime;
            if(delayTime<=0)
            {
                ChangeState(VersusBattleStateType.None);
            }
        }
    }
}