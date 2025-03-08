using UnityEngine;

public class TriggerBuffUsingFunctionPoint : TickFunctionEvent
{
    public static TriggerBuffUsingFunctionPoint Creator(BuffFunctionData data)
    {
        return new TriggerBuffUsingFunctionPoint(data);
    }

    public TriggerBuffUsingFunctionPoint(BuffFunctionData data) : base(data)
    {

    }

    public override void Enter(Fighter fighter)
    {
        base.Enter(fighter);

        int pointBuffId = (int)Data.BaseValue;
        int point = 0;
        if (Data.TargetType == 1)
        {
            point = Caster.GetFunctionPoint(pointBuffId);

        }
        else if (Data.TargetType == 2)
        {
            point = fighter.GetFunctionPoint(pointBuffId);
        }

        int newBuffId = 0;
        int costPoint = 0;
        BattleBuff buff = Caster.BuffMgr.GetBuff(BuffId);
        if (buff != null && buff.Data.extendBuffs!=null)
        {
            for (int idx = buff.Data.extendBuffs.Count - 1; idx >= 0; idx--)
            {
                ValType val = buff.Data.extendBuffs[idx];
                if (val.val <= point)
                {
                    newBuffId = val.id;
                    costPoint = val.val;
                    break;
                }
            }
        }

        //DebugHelper.LogError("targetType:" + Data.TargetType + " newBuffId:" + newBuffId + " costPoint:" + costPoint);
        if (newBuffId > 0)
        {
            int buffLevel = buff.Data.BuffLevel;
            buff.Stop();

            BattleBuff castBuff = Caster.CastBuff(null, newBuffId, buffLevel);
            if (castBuff != null)
            {
                castBuff.IsEnhance = true;
            }
        }
    }
}