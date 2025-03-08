using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class TimeBattleFieldStateWin : TimeBattleFieldState
{
    public static TimeBattleFieldStateWin Creator(TimeBattleField field)
    {
        return new TimeBattleFieldStateWin(field);
    }

    public TimeBattleFieldStateWin(TimeBattleField field) :
        base(field, TimeBattleFieldStateType.Win)
    {

    }

    float delayTime = 0;
    public override void OnEnter()
    {
        for (int idx = 0; idx < mField.TeamFighters.Count; idx++)
        {
            if (mField.TeamFighters[idx].IsAlive)
            {
                mField.TeamFighters[idx].ForceIdle();
            }
        }

        if (mField.Battle.Recorder != null)
        {
            if (!mField.Battle.IsPlayRecord)
            {
                mField.Battle.Recorder.RecordBattleEnd(mField.IsWin);
                mField.Battle.RecorderStr = mField.Battle.Recorder != null ? mField.Battle.Recorder.RecordStr : null;
                delayTime = 0;
            }
            else
            {
                delayTime = 2;
                mField.Battle.Recorder.CalculateReplayResult();
            }
        }
    }

    public override void Update(float deltaTime)
    {
        mField.Battle.FighterMgr.FixedUpdate(deltaTime);

        delayTime -= deltaTime;
        if (delayTime <= 0)
        {
            ChangeState(TimeBattleFieldStateType.End);
        }
    }

    public override void OnLeave()
    {
    }

    public override void OnDataChanged()
    {

    }
}
