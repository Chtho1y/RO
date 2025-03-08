using UnityEngine;
using System.Collections;

public class AddFunctionPoint : TickFunctionEvent
{

    public static AddFunctionPoint Creator(BuffFunctionData data)
    {
        return new AddFunctionPoint(data);
    }

    public AddFunctionPoint(BuffFunctionData data) : base(data)
    {

    }

    public override void Enter(Fighter fighter)
    {
        base.Enter(fighter);

        if(Data.TargetType == 1)
        {
            if (Caster != null)
            {
                Caster.AddFunctionPoint((int)Data.BaseValue, (int)Data.IncVal,Data.SkillLv);
            }
        }
        else if(Data.TargetType == 2)
        {
            fighter.AddFunctionPoint((int)Data.BaseValue, (int)Data.IncVal, Data.SkillLv);
        }
        //DebugHelper.LogError("AddFunctionPoint TargetType = " + Data.TargetType + " pointBuffId = "+Data.BaseValue + " point = "+Data.IncVal);
    }
}
