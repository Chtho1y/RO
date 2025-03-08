using UnityEngine;
using System.Collections;

public class TimeBattleFieldStateFighting : TimeBattleFieldState
{
    public static TimeBattleFieldStateFighting Creator(TimeBattleField field)
    {
        return new TimeBattleFieldStateFighting(field);
    }

    public TimeBattleFieldStateFighting(TimeBattleField field):
        base(field, TimeBattleFieldStateType.Fighting)
    {

    }

    public override void OnEnter()
    {
        mField.Battle.StartStatistics();
        mField.OnFightingStart();
        mField.Battle.FighterMgr.SetPveMark();
    }

    public override void Update(float deltaTime)
    {
        mField.Battle.FighterMgr.FixedUpdate(deltaTime);

        if (mField.Result == FightingResult.None) 
        {
            mField.CheckFightingResult(mField.Battle);
        }

        switch (mField.Result)
        {
            case FightingResult.Win:
                ChangeState(TimeBattleFieldStateType.Win);
                break;
            case FightingResult.Failed:
                ChangeState(TimeBattleFieldStateType.Failed);
                break;
            case FightingResult.Peace:
                ChangeState(TimeBattleFieldStateType.Peace);
                break;
        }
    }

    public override void OnLeave()
    {
        if (BattleMgr.Instance.Battle.IsPlayRecord)
        {
            BattleMgr.Instance.OnReplayEnd();
        }
        mField.OnFightingEnd();
    }

    public override void OnDataChanged()
    {
        
    }
}
  