using UnityEngine;
using System.Collections;

public class CurseFunEvent : DurationFunctionEvent
{
    public static CurseFunEvent Creator(BuffFunctionData data)
    {
        return new CurseFunEvent(data);
    }

    public CurseFunEvent(BuffFunctionData data):base(data)
    {
        mType = Buff_Function_Type.Curse;
    }

    public override void Enter(Fighter fighter)
    {
        fighter.StateData.IsCurse = true;
        EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_Fighter_Curse, fighter));
        base.Enter(fighter);
    }

    public override void Exit(Fighter fighter)
    {
        fighter.StateData.IsCurse = false;
        base.Exit(fighter);
    }
}
