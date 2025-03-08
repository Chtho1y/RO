using UnityEngine;
using System.Collections;

public class VersusBattleFieldStateStartingFight : VersusBattleFieldState
{
    public static VersusBattleFieldState Creator(VersusBattleField field)
    {
        return new VersusBattleFieldStateStartingFight(field);
    }

    public VersusBattleFieldStateStartingFight(VersusBattleField field)
        :base(field,VersusBattleFieldStateType.StartingFight)
    {

    }

    public override void OnEnter()
    {
        BattleMgr.Instance.StartingFight();
        BattleMgr.Instance.SetFollowCamera(mField.TeamFighters[0].Forward,true);
        mField.Battle.MoveToNextBattleField(false);
        if (mField.Battle.IsShowPressPointEffect)//压制特效
        {
            BattleMgr.Instance.ShowPVPPressPoint();
        }       
    }

    public override void OnLeave()
    {
        
    }

    public override void Update(float deltaTime)
    {
        if (mField.Battle.IsAllFightersReady())
        {
            ChangeState(VersusBattleFieldStateType.Fighting);
        }
        else
        {
            mField.Battle.FighterMgr.FixedUpdate(deltaTime);
        }
    }

    public override void OnDataChanged()
    {
        
    }
}
