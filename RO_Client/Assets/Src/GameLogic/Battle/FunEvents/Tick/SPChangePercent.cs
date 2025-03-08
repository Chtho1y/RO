using UnityEngine;
using System.Collections;

public class SPChangePercent : TickFunctionEvent
{

    public static SPChangePercent Creator(BuffFunctionData data)
    {
        return new SPChangePercent(data);
    }

    public SPChangePercent(BuffFunctionData data) : base(data)
    {

    }

    public override void Enter(Fighter fighter)
    {
        base.Enter(fighter);

        if (fighter.IsAlive)
        {
            float addSp = (fighter.GetAttrByType(Data.fromAttr) * fighter.GetBuffPercentValue(Buff_Function_Type.SP_Change_Percent));
            fighter.Sp += addSp;
            if(mCaster.Statistics!=null)
                mCaster.Statistics.StatSPInfo(mCaster, (int)addSp);
            fighter.RefreshSp();

            EventMgr.DispatchEvent<Fighter,int>(new CoreEvent<Fighter,int>(ECoreEventType.EID_Fighter_AddSp, fighter,(int)addSp));
        }
    }
}
