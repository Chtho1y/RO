using UnityEngine;
using System.Collections;

public class ConfusionFunEvent : DurationFunctionEvent
{
    public static ConfusionFunEvent Creator(BuffFunctionData data)
    {
        return new ConfusionFunEvent(data);
    }

    public ConfusionFunEvent(BuffFunctionData data) : base(data)
    {
        mType = Buff_Function_Type.Confusion;
    }

    public override void Enter(Fighter fighter)
    {
        fighter.StateData.IsConfused = true;
        base.Enter(fighter);
    }

    public override void Exit(Fighter fighter)
    {
        fighter.StateData.IsConfused = false;
        base.Exit(fighter);
    }
}
