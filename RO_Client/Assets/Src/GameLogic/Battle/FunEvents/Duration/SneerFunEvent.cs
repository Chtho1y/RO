using UnityEngine;
using System.Collections;

public class SneerFunEvent : DurationFunctionEvent
{
    public static SneerFunEvent Creator(BuffFunctionData data)
    {
        return new SneerFunEvent(data);
    }

    public SneerFunEvent(BuffFunctionData data):base(data)
    {
        mType = Buff_Function_Type.Sneer;
    }

    public override void Enter(Fighter fighter)
    {
        if(Caster!=null && !Caster.IsPet)
        {
            fighter.StateData.IsSneer = true;
        }

        base.Enter(fighter);
    }

    public override void Exit(Fighter fighter)
    {
        fighter.StateData.IsSneer = false;
        base.Exit(fighter);
    }

    public override bool Expired(Fighter figher)
    {
        if (mCaster == null || !mCaster.IsAlive || mCaster.IsDisposed)
            return true;



        return base.Expired(figher);
    }
}
