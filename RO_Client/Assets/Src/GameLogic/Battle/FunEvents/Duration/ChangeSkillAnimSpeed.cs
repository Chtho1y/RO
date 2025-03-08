using UnityEngine;
using System.Collections;

public class ChangeSkillAnimSpeed : DurationFunctionEvent
{
    public static ChangeSkillAnimSpeed Creator(BuffFunctionData data)
    {
        return new ChangeSkillAnimSpeed(data);
    }

    public ChangeSkillAnimSpeed(BuffFunctionData data):base(data)
    {
        mType = Buff_Function_Type.ChangeSkillSpeed;
    }

    public override void Enter(Fighter fighter)
    {
        base.Enter(fighter);
        fighter.StateData.SetAnimSpeed(mData.value * fighter.StateData.AnimSpeed);
    }

    public override void Exit(Fighter fighter)
    {
        base.Exit(fighter);
        fighter.StateData.SetAnimSpeed(1);
    }
}
