using UnityEngine;
using System.Collections;

public class HealHPFromCaster : TickFunctionEvent
{
    public static HealHPFromCaster Creator(BuffFunctionData data)
    {
        return new HealHPFromCaster(data);
    }

    public HealHPFromCaster(BuffFunctionData data):base(data)
    {

    }

    public override void Enter(Fighter fighter)
    {        
        base.Enter(fighter);
        if (null == fighter) return;

        //宠物不能加血
        if (fighter.IsPet)
            return;

        if (mCaster!=null && fighter.IsAlive)
        {
            float hp = (mCaster.GetAttrByType(Data.fromAttr) * fighter.GetBuffPercentValue(Buff_Function_Type.Heal_Change_Percent_From_Caster));
            int addHp =(int)(hp * (1 + fighter.GetBuffPercentValue(Buff_Function_Type.Heal_Change_Percent)));
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
