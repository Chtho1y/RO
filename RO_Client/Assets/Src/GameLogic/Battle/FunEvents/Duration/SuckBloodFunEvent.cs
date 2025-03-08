using UnityEngine;
using System.Collections;

//吸血
public class SuckBloodFunEvent : DurationFunctionEvent
{
    public static SuckBloodFunEvent Creator(BuffFunctionData data)
    {
        return new SuckBloodFunEvent(data);
    }

    public SuckBloodFunEvent(BuffFunctionData data) : base(data)
    {
        mType = data.functionType;
    }

    public override void Enter(Fighter fighter)
    {
        EventMgr.AddEventListener<UIEventParamFighterHurt>(ECoreEventType.EID_FIGHTER_HURT, OnFighterHurt);
        base.Enter(fighter);
    }
    public override void Exit(Fighter fighter)
    {
        EventMgr.RemoveEventListener<UIEventParamFighterHurt>(ECoreEventType.EID_FIGHTER_HURT, OnFighterHurt);
        base.Exit(fighter);
    }

    private void OnFighterHurt(CoreEvent<UIEventParamFighterHurt> ce)
    {
        UIEventParamFighterHurt param = ce.Data;
        Fighter caster = param.mCaster;
        Fighter target = param.mTarget;     

        if(mHitInfo.Target.Id == caster.Id)
        {
            int nValidSuck = 0;
            int.TryParse(Data.extendParam, out nValidSuck);
            nValidSuck = (int)(nValidSuck * 0.01f * mHitInfo.Target.MaxLife);
            nValidSuck = Mathf.Min((int)(Data.value * 0.01f * param.mHurtVal), nValidSuck);
            mHitInfo.Target.Life += nValidSuck;
            mHitInfo.Target.RefreshLife();

            //if (mHitInfo.Target.Statistics != null)
            //    mHitInfo.Target.Statistics.StatHealInfo(mHitInfo.Target, param.mHurtVal);
            //if (param.mHurtVal > 0)
            //    Caster.Battle.Output(OutputType.Heal, Caster, Caster, SkillName, (int)param.mHurtVal);
            if (nValidSuck > 0)
                EventMgr.DispatchEvent<object[]>(new CoreEvent<object[]>(ECoreEventType.EID_FIGHTER_HEAL, new object[] { mHitInfo.Target, nValidSuck }));
        }
    }
}
