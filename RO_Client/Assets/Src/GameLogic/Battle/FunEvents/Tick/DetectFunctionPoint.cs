using UnityEngine;
using System.Collections;

public class DetectFunctionPoint : TickFunctionEvent
{
    public static DetectFunctionPoint Creator(BuffFunctionData data)
    {
        return new DetectFunctionPoint(data);
    }

    public DetectFunctionPoint(BuffFunctionData data) : base(data)
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

        }else if(Data.TargetType == 2)
        {
            point = fighter.GetFunctionPoint(pointBuffId);
        }

        int newBuffId = 0;
        int costPoint = 0;
        BattleBuff buff = Caster.BuffMgr.GetBuff(BuffId);
        if (buff != null && buff.Data.extendBuffs!=null)
        {
            for (int idx = buff.Data.extendBuffs.Count - 1; idx>=0 ; idx--)
            {
                ValType val = buff.Data.extendBuffs[idx];
                if(val.val <= point)
                {
                    costPoint = val.val;
                    newBuffId = val.id;
                    break;
                }
            }
        }

        //DebugHelper.LogError("BuffId:"+ BuffId+" extendStr:"+ buff.Data.extendFunStr+" point: "+point+ " pointBuffId: "+ pointBuffId + " targetType:" +Data.TargetType+" newBuffId:"+newBuffId+" costPoint:"+costPoint);
        if(newBuffId > 0)
        {
            if(Data.TargetType == 1)
            {
                Caster.DetuctFunctionPoint(pointBuffId, costPoint);
            }
            else if(Data.TargetType == 2)
            {
                fighter.DetuctFunctionPoint(pointBuffId, costPoint);
            }

            int buffLevel = buff.Data.BuffLevel;
            buff.Stop();

            BattleBuff castBuff =  Caster.CastBuff(null, newBuffId, buffLevel);
            if(castBuff!=null)
            {
                castBuff.IsEnhance = true;
            }
        }
    }
}
