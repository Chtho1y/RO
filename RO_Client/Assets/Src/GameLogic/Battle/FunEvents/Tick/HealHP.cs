using UnityEngine;
using System.Collections;

public class HealHP : TickFunctionEvent
{
    public static HealHP Creator(BuffFunctionData data)
    {
        return new HealHP(data);
    }

    public HealHP(BuffFunctionData data) : base(data)
    {

    }

    public override void Enter(Fighter fighter)
    {
        base.Enter(fighter);

        if (!fighter.IsAlive) return;

        int addHp = (int)(fighter.GetBuffFunctionValue(Buff_Function_Type.Heal_Target_HP_Change_Value) * (1+ fighter.GetBuffPercentValue(Buff_Function_Type.Heal_Change_Percent)));
        fighter.Life += addHp;

        if (Caster != null)
        {
            EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_Fighter_Treatment, mCaster));

            if (Caster.Statistics != null)
                Caster.Statistics.StatHealInfo(Caster, addHp);
            if (addHp > 0)
                Caster.Battle.Output(OutputType.Heal, Caster, fighter, SkillName, (int)addHp);
        }
        if (addHp > 0)
            EventMgr.DispatchEvent<object[]>(new CoreEvent<object[]>(ECoreEventType.EID_FIGHTER_HEAL, new object[] { fighter, addHp }));
    }
}
