using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class VersusBattleFieldStateFighting : VersusBattleFieldState
{
    public static VersusBattleFieldState Creator(VersusBattleField field)
    {
        return new VersusBattleFieldStateFighting(field);
    }

    public VersusBattleFieldStateFighting(VersusBattleField field)
        : base(field, VersusBattleFieldStateType.Fighting)
    {
    }

    public override void OnEnter()
    {
        mField.Battle.StartStatistics();
        BattleCamera.Instance.DisableDynamicCamera();
        mField.OnFightingStart();
        mField.Battle.AddBattleMark();
    }

    public override void OnLeave()
    {      
        mField.OnFightingEnd();
    }

    public override void Update(float deltaTime)
    {
        mField.Battle.FighterMgr.FixedUpdate(deltaTime);

        if (mField.Result == FightingResult.None)
            mField.CheckFightingResult(mField.Battle);

        switch (mField.Result)
        {
            case FightingResult.Win:
                ChangeState(VersusBattleFieldStateType.Win);
                break;
            case FightingResult.Failed:
                ChangeState(VersusBattleFieldStateType.Failed);
                break;
        }
    }

    public override void OnDataChanged()
    {

    }
}
