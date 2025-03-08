using UnityEngine;
using System.Collections;

public class SPChangeFromCaster : TickFunctionEvent
{
    public static SPChangeFromCaster Creator(BuffFunctionData data)
    {
        return new SPChangeFromCaster(data);
    }

    public SPChangeFromCaster(BuffFunctionData data):base(data)
    {

    }

    public override void Enter(Fighter fighter)
    {
        base.Enter(fighter);

        if (mCaster != null && fighter.IsAlive)
        {
            float addSp = (mCaster.GetAttrByType(Data.fromAttr) * fighter.GetBuffPercentValue(Buff_Function_Type.Add_SP_From_Caster));
            fighter.Sp += addSp;
            if(mCaster.Statistics != null)
                mCaster.Statistics.StatSPInfo(mCaster, (int)addSp);
            fighter.RefreshSp();

            EventMgr.DispatchEvent<Fighter,int>(new CoreEvent<Fighter,int>(ECoreEventType.EID_Fighter_AddSp, fighter,(int)addSp));
        }
    }
}
