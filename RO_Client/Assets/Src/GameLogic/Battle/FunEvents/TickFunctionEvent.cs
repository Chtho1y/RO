using UnityEngine;
using System.Collections;

public class TickFunctionEvent : FunctionEvent
{
    public TickFunctionEvent(BuffFunctionData data):base(data)
    {
        mType = data.functionType;
    }

    public virtual bool Expired()
    {
        return true;
    }

    public override void Enter(Fighter fighter)
    {
        base.Enter(fighter);
    }
}
