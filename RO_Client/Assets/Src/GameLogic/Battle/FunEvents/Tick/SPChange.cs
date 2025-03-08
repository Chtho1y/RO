using UnityEngine;
using System.Collections;

public class SPChange : TickFunctionEvent
{

    public static SPChange Creator(BuffFunctionData data)
    {
        return new SPChange(data);
    }

    public SPChange(BuffFunctionData data) : base(data)
    {

    }

    public override void Enter(Fighter fighter)
    {
        base.Enter(fighter);

        if (!fighter.IsAlive) return;

        int addSp = (int)fighter.GetBuffFunctionValue(Buff_Function_Type.SP_Change_Value);
        fighter.Sp += addSp;
        if(mCaster.Statistics!=null)
            mCaster.Statistics.StatSPInfo(mCaster, addSp);
        fighter.RefreshSp();

        EventMgr.DispatchEvent<Fighter,int>(new CoreEvent<Fighter,int>(ECoreEventType.EID_Fighter_AddSp, fighter, addSp));
    }
}
