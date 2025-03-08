using UnityEngine;
using System.Collections;

public class PoisonFunEvent : DurationFunctionEvent
{
    public static PoisonFunEvent Creator(BuffFunctionData data)
    {
        return new PoisonFunEvent(data);
    }

    public PoisonFunEvent(BuffFunctionData data):base(data)
    {
        mType = Buff_Function_Type.Poison;
    }

    public override void Enter(Fighter fighter)
    {
        fighter.StateData.IsPoison = true;
        base.Enter(fighter);
    }

    public override void Exit(Fighter fighter)
    {
        fighter.StateData.IsPoison = false;
        base.Exit(fighter);
    }
}
