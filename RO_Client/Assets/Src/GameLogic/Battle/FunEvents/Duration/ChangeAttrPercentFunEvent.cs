using UnityEngine;
using System.Collections;

public class ChangeAttrPercentFunEvent : DurationFunctionEvent
{
    public static ChangeAttrPercentFunEvent Creator(BuffFunctionData data)
    {
        return new ChangeAttrPercentFunEvent(data);
    }

    public ChangeAttrPercentFunEvent(BuffFunctionData data):base(data)
    {
        mType = data.functionType;
    }

    public override float GetValue()
    {
        float fCostHp;
        float fCostPrecent;
        int MaxPrecent = 0;
        int.TryParse(Data.extendParam, out MaxPrecent);
        switch (mType)
        {
            case Buff_Function_Type.Attack_Change_ByTargetCostHpPercent:
            case Buff_Function_Type.MagicAttack_Change_ByTargetCostHpPercent:
                fCostHp = HitInfo.Target.MaxLife - HitInfo.Target.Life;
                fCostPrecent = (float)fCostHp / (float)HitInfo.Target.MaxLife;                
                return Mathf.Min( fCostPrecent * base.GetValue() * 0.01f, MaxPrecent);
            case Buff_Function_Type.Attack_Change_BySourceCostHpPercent:
            case Buff_Function_Type.MagicAttack_Change_BySourceCostHpPercent:
                fCostHp = HitInfo.Caster.MaxLife - HitInfo.Caster.Life;
                fCostPrecent = (float)fCostHp / (float)HitInfo.Target.MaxLife;
                return Mathf.Min(fCostPrecent * base.GetValue() * 0.01f,MaxPrecent);
            case Buff_Function_Type.Attack_Change_ByTargetCurHpPercent:
            case Buff_Function_Type.MagicAttack_Change_ByTargetCurHpPercent:
                fCostPrecent = (float)HitInfo.Target.Life / (float)HitInfo.Target.MaxLife;
                return Mathf.Min(fCostPrecent * base.GetValue() * 0.01f,MaxPrecent);
            case Buff_Function_Type.Attack_Change_BySourceCurHpPercent:
            case Buff_Function_Type.MagicAttack_Change_BySourceCurHpPercent:
                fCostPrecent = (float)HitInfo.Caster.Life / (float)HitInfo.Caster.MaxLife;
                return Mathf.Min(fCostPrecent * base.GetValue() * 0.01f,MaxPrecent);
            default:
                return base.GetValue();
        }
    }
}
