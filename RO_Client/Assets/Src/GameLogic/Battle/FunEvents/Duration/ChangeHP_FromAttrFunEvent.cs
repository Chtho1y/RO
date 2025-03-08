using UnityEngine;
using System.Collections;

public class ChangeHP_FromAttrFunEvent : DurationFunctionEvent
{
    public static ChangeHP_FromAttrFunEvent Creator(BuffFunctionData data)
    {
        return new ChangeHP_FromAttrFunEvent(data);
    }

    int internalFrame = 0;
    int nextRecoverFrame = 0;
    Fighter mFighter;
    public ChangeHP_FromAttrFunEvent(BuffFunctionData data):base(data)
    {
        mType = Buff_Function_Type.ChangeHP_FromAttr_Percent;
        internalFrame = (int)(data.intervalTime * Constants.frame_to_time);
    }

    public override void Enter(Fighter fighter)
    {
        base.Enter(fighter);
        EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_Fighter_Treatment, mCaster));
        mFighter = fighter;
        HealHp();
    }

    public override void Update(float deltaTime)
    {
        base.Update(deltaTime);
        nextRecoverFrame--;
        if(nextRecoverFrame <= 0)
        {
            HealHp();
        }
    }

    public override void Exit(Fighter fighter)
    {
        base.Exit(fighter);
        mFighter = null;
    }

    void HealHp()
    {
        if (null == mFighter) return;
        if (!mFighter.IsAlive) return;

        nextRecoverFrame = internalFrame;
        int addHp = (int)(mFighter.GetAttrByType(Data.fromAttr) * Data.value * 0.01f * (1 + mFighter.GetBuffPercentValue(Buff_Function_Type.Heal_Change_Percent)));
        mFighter.Life += addHp;
        if(Caster != null)
        {
            if(Caster.Statistics!=null)
                Caster.Statistics.StatHealInfo(Caster, addHp);
            if(addHp > 0)
                Caster.Battle.Output(OutputType.Heal, Caster, mFighter, SkillName, (int)addHp);
        }
        if (addHp > 0)
            EventMgr.DispatchEvent<object[]>(new CoreEvent<object[]>(ECoreEventType.EID_FIGHTER_HEAL, new object[] { mFighter, addHp }));
    }
}
