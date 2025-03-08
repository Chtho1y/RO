using UnityEngine;
using System.Collections;

public class ChangeAttrValueFunEvent : DurationFunctionEvent
{
    public static ChangeAttrValueFunEvent Creator(BuffFunctionData data)
    {
        return new ChangeAttrValueFunEvent(data);
    }

    public ChangeAttrValueFunEvent(BuffFunctionData data):base(data)
    {
        mType = data.functionType;
    }

    public override float GetValue()
    {
        switch(mType)
        {
            case Buff_Function_Type.Attack_Change_ByTargetAttr:
            case Buff_Function_Type.MagicAttack_Change_ByTargetAttr:
            case Buff_Function_Type.AttackDefense_Change_ByTargetAttr:
            case Buff_Function_Type.MagicDefense_Change_ByTargetAttr:
                return HitInfo.Target.GetAttrByType(Data.fromAttr) * base.GetValue() * 0.01f;
            case Buff_Function_Type.Attack_Change_BySourceAttr:
            case Buff_Function_Type.MagicAttack_Change_BySourceAttr:
            case Buff_Function_Type.AttackDefense_Change_BySourceAttr:
            case Buff_Function_Type.MagicDefense_Change_BySourceAttr:
                return HitInfo.Caster.GetAttrByType(Data.fromAttr) * base.GetValue() * 0.01f;           
            default:
                return base.GetValue();                
        }
    }
}
