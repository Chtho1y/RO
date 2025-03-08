using UnityEngine;
using System.Collections;

public class HealHPPercent : TickFunctionEvent
{
    public static HealHPPercent Creator(BuffFunctionData data)
    {
        return new HealHPPercent(data);
    }

    public HealHPPercent(BuffFunctionData data):base(data)
    {
        
    }

    public override void Enter(Fighter fighter)
    {       
        base.Enter(fighter);
        if (null == fighter) return;
        if (fighter.IsAlive)
        {
            float hp = (fighter.GetAttrByType(Data.fromAttr) * fighter.GetBuffPercentValue(Buff_Function_Type.Heal_Change_Percent_From_Target));
            int addHp = (int)(hp * (1 + fighter.GetBuffPercentValue(Buff_Function_Type.Heal_Change_Percent)));
            fighter.Life += addHp;

            if (Caster != null)
            {
                EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_Fighter_Treatment, mCaster));
                if (Caster.Statistics!=null)
                    Caster.Statistics.StatHealInfo(Caster, addHp);
                if (addHp > 0)
                    Caster.Battle.Output(OutputType.Heal, Caster, fighter, SkillName, (int)addHp);
            }
            if (addHp > 0)
                EventMgr.DispatchEvent<object[]>(new CoreEvent<object[]>(ECoreEventType.EID_FIGHTER_HEAL, new object[] { fighter, addHp }));
        }
    }
}
