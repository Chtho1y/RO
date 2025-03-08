using UnityEngine;
using System.Collections;

public class ForgetFunEvent : DurationFunctionEvent
{
    public static ForgetFunEvent Creator(BuffFunctionData data)
    {
        return new ForgetFunEvent(data);
    }

    public ForgetFunEvent(BuffFunctionData data):base(data)
    {
        mType = Buff_Function_Type.Forget;
    }

    public override void Enter(Fighter fighter)
    {
        fighter.StateData.IsForget = true;
        base.Enter(fighter);
    }

    public override void Exit(Fighter fighter)
    {
        fighter.StateData.IsForget = false;
        base.Exit(fighter);
    }
}
