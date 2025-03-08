using UnityEngine;
using System.Collections;

public class FearFunEvent : DurationFunctionEvent
{
    public static FearFunEvent Creator(BuffFunctionData data)
    {
        return new FearFunEvent(data);
    }

    public FearFunEvent(BuffFunctionData data):base(data)
    {
        mType = Buff_Function_Type.Fear;
    }

    public override void Enter(Fighter fighter)
    {
        fighter.ProcessStiff(true);
        base.Enter(fighter);
    }

    public override void Exit(Fighter fighter)
    {
        fighter.ProcessStiff(false);
        base.Exit(fighter);
    }
}
