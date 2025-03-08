using UnityEngine;
using System.Collections;

public class StiffFunEvent : DurationFunctionEvent
{
    public static StiffFunEvent Creator(BuffFunctionData data)
    {
        return new StiffFunEvent(data);
    }

    public StiffFunEvent(BuffFunctionData data):base(data)
    {
        mType = Buff_Function_Type.Stiff;
    }

    public override void Enter(Fighter fighter)
    {
        fighter.StateData.IsStiff = true;
        base.Enter(fighter);
    }

    public override void Exit(Fighter fighter)
    {
        fighter.StateData.IsStiff = false;
        base.Exit(fighter);
    }
}
