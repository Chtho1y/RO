using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BreakFunEvent : DurationFunctionEvent
{
    public static BreakFunEvent Creator(BuffFunctionData data)
    {
        return new BreakFunEvent(data);
    }


    public BreakFunEvent(BuffFunctionData data):base(data)
    {
        mType = Buff_Function_Type.Break;
    }

    public override void Enter(Fighter fighter)
    {
        base.Enter(fighter);
        fighter.EndSkill(true);
        fighter.ForceBreak();
    }

    public override void Exit(Fighter fighter)
    {
        base.Exit(fighter);
        if(fighter.IsAlive)
            fighter.ForceIdle();
    }
}
