using UnityEngine;
using System.Collections;

public class InvincibleFunEvent : DurationFunctionEvent
{
    public static InvincibleFunEvent Creator(BuffFunctionData data)
    {
        return new InvincibleFunEvent(data);
    }

    public InvincibleFunEvent(BuffFunctionData data):base(data)
    {
        mType = Buff_Function_Type.Invincible;
    }

    public override void Enter(Fighter fighter)
    {
        fighter.StateData.IsInvincible = true;
        base.Enter(fighter);
    }

    public override void Exit(Fighter fighter)
    {
        fighter.StateData.IsInvincible = false;
        base.Exit(fighter);
    }
}
