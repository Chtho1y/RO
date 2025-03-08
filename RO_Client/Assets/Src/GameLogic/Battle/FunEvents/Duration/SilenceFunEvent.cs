using UnityEngine;
using System.Collections;

public class SilenceFunEvent : DurationFunctionEvent
{
    public static SilenceFunEvent Creator(BuffFunctionData data)
    {
        return new SilenceFunEvent(data);
    }

    public SilenceFunEvent(BuffFunctionData data):base(data)
    {
        mType = Buff_Function_Type.Silence;
    }

    public override void Enter(Fighter fighter)
    {       
        fighter.StateData.IsSilence = true;
        EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_Fighter_Silence, fighter));
        base.Enter(fighter);
    }

    public override void Exit(Fighter fighter)
    {
        fighter.StateData.IsSilence = false;
        base.Exit(fighter);
    }
}
