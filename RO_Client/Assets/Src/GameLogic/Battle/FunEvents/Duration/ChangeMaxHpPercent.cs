using UnityEngine;
using System.Collections;

public class ChangeMaxHpPercent : DurationFunctionEvent
{
    public static ChangeMaxHpPercent Creator(BuffFunctionData data)
    {
        return new ChangeMaxHpPercent(data);
    }

    public ChangeMaxHpPercent(BuffFunctionData data):base(data)
    {
        mType = Buff_Function_Type.Change_MaxHP_Percent;
    }

    SInt maxLife = 0;
    public override void Enter(Fighter fighter)
    {
        base.Enter(fighter);
        maxLife = fighter.MaxLife;
        fighter.MaxLife = Mathf.RoundToInt((mData.value * 0.01f + 1.0f) * maxLife);
        fighter.RefreshLife();
    }

    public override void Exit(Fighter fighter)
    {
        fighter.MaxLife = maxLife;
        fighter.RefreshLife();
        base.Exit(fighter);
    }
}
