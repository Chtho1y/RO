using UnityEngine;
using System.Collections;

/// <summary>
/// 狂暴状态
/// </summary>
public class RageStatusFunEvent : DurationFunctionEvent
{
    public static RageStatusFunEvent Creator(BuffFunctionData data)
    {
        return new RageStatusFunEvent(data);
    }

    public RageStatusFunEvent(BuffFunctionData data):base(data)
    {
        mType = Buff_Function_Type.RageStatus;
    }

    public override void Enter(Fighter fighter)
    {
        base.Enter(fighter);

        fighter.SetRageStatus(true);
    }

    public override void Exit(Fighter fighter)
    {
        base.Exit(fighter);
        fighter.SetRageStatus(false);
    }
}
