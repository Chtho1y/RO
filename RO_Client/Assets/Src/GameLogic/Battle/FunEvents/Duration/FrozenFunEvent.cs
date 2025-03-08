using UnityEngine;
using System.Collections;

public class FrozenFunEvent : DurationFunctionEvent
{
    public static FrozenFunEvent Creator(BuffFunctionData data)
    {
        return new FrozenFunEvent(data);
    }

    public FrozenFunEvent(BuffFunctionData data) : base(data)
    {
        mType = Buff_Function_Type.Frozen;
    }

    public override void Enter(Fighter fighter)
    {
        fighter.StateData.IsFrozen = true;
        base.Enter(fighter);
    }

    public override void Exit(Fighter fighter)
    {
        fighter.StateData.IsFrozen = false;
        base.Exit(fighter);
    }
}
