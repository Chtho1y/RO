using UnityEngine;
using System.Collections;

public class VertigoFunEvent : DurationFunctionEvent
{
    public static VertigoFunEvent Creator(BuffFunctionData data)
    {
        return new VertigoFunEvent(data);
    }

    public VertigoFunEvent(BuffFunctionData data):base(data)
    {
        mType = Buff_Function_Type.Vertigo;
    }

    public override void Enter(Fighter fighter)
    {
        if(Caster!=null)
        {
            Caster.Battle.Output(OutputType.Vertigo, Caster, fighter, SkillName,Data.duration);
        }
        fighter.StateData.IsVertigo = true;
        base.Enter(fighter);
    }

    public override void Exit(Fighter fighter)
    {
        fighter.StateData.IsVertigo = false;
        base.Exit(fighter);
    }
}
