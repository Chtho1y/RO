using UnityEngine;
using System.Collections;

public class SleepFunEvent : DurationFunctionEvent
{
    public static SleepFunEvent Creator(BuffFunctionData data)
    {
        return new SleepFunEvent(data);
    }

    public SleepFunEvent(BuffFunctionData data):base(data)
    {
        mType = Buff_Function_Type.Sleep;
    }

    public override void Enter(Fighter fighter)
    {
        fighter.StateData.IsSleep = true;
        base.Enter(fighter);
    }

    public override void Exit(Fighter fighter)
    {
        fighter.StateData.IsSleep = false;
        base.Exit(fighter);
    }
}
