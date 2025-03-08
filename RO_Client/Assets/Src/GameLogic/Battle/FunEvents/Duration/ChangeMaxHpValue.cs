using UnityEngine;
using System.Collections;

public class ChangeMaxHpValue : DurationFunctionEvent
{
    public static ChangeMaxHpValue Creator(BuffFunctionData data)
    {
        return new ChangeMaxHpValue(data);
    }

    public ChangeMaxHpValue(BuffFunctionData data):base(data)
    {
        mType = Buff_Function_Type.Change_MaxHP_Value;
    }

    SInt maxLife = 0;
    public override void Enter(Fighter fighter)
    {
        base.Enter(fighter);
        maxLife = fighter.MaxLife;
        fighter.MaxLife = Mathf.RoundToInt(mData.value + maxLife);
        fighter.RefreshLife();
    }

    public override void Exit(Fighter fighter)
    {
        fighter.MaxLife = maxLife;
        fighter.RefreshLife();
        base.Exit(fighter);
    }
}
