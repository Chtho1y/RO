using UnityEngine;
using System.Collections;

public class ForbidNormalSkillFunEvent : DurationFunctionEvent
{
    public static ForbidNormalSkillFunEvent Creator(BuffFunctionData data)
    {
        return new ForbidNormalSkillFunEvent(data);
    }

    public ForbidNormalSkillFunEvent(BuffFunctionData data):base(data)
    {
        mType = Buff_Function_Type.Forbid_NormalSkill;
    }

    public override void Enter(Fighter fighter)
    {
        fighter.StateData.IsForbidNormalSkill = true;
        base.Enter(fighter);
    }

    public override void Exit(Fighter fighter)
    {
        fighter.StateData.IsForbidNormalSkill = false;
        base.Exit(fighter);
    }
}
