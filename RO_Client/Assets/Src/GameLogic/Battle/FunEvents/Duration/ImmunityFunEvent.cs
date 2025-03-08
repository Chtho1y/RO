using UnityEngine;
using System.Collections;

public class ImmunityFunEvent : DurationFunctionEvent
{
    public static ImmunityFunEvent Creator(BuffFunctionData data)
    {
        return new ImmunityFunEvent(data);
    }

    public ImmunityFunEvent(BuffFunctionData data):base(data)
    {
        mType = Buff_Function_Type.Immunity;
    }

    public override void Enter(Fighter fighter)
    {
        fighter.StateData.IsImmunity = true;
        base.Enter(fighter);
    }

    public override void Exit(Fighter fighter)
    {
        fighter.StateData.IsImmunity = false;
        base.Exit(fighter);
    }
}
