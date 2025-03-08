using UnityEngine;
using System.Collections;

public class TimeBattleFieldStateEnd : TimeBattleFieldState
{
    public static TimeBattleFieldStateEnd Creator(TimeBattleField field)
    {
        return new TimeBattleFieldStateEnd(field);
    }

    public TimeBattleFieldStateEnd(TimeBattleField field) :
        base(field, TimeBattleFieldStateType.Win)
    {

    }

    public override void OnEnter()
    {
        mField.Battle.EndStatistics();

        if (mField.Battle.Recorder != null)
        {
            mField.Battle.CloseRecorder();
        }
    }

    public override void Update(float deltaTime)
    {
        ChangeState(TimeBattleFieldStateType.None);
    }

    public override void OnLeave()
    {

    }

    public override void OnDataChanged()
    {

    }
}
