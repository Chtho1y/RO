using UnityEngine;
using System.Collections;

public class ReflectFixHurtFunEvent : DurationFunctionEvent
{
    int internalFrame = 0;
    int nextRecoverFrame = 0;
    bool bIsCanReflect = false;
    public static ReflectFixHurtFunEvent Creator(BuffFunctionData data)
    {
        return new ReflectFixHurtFunEvent(data);
    }

    public ReflectFixHurtFunEvent(BuffFunctionData data) : base(data)
    {
        mType = data.functionType;
        internalFrame = (int)(data.intervalTime * Constants.frame_to_time);
        nextRecoverFrame = 0;
        bIsCanReflect = false;
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

    public override void Update(float deltaTime)
    {
        base.Update(deltaTime);

        if (bIsCanReflect)
            return;

        nextRecoverFrame--;

        if (nextRecoverFrame <= 0)
        {
            nextRecoverFrame = internalFrame;
            bIsCanReflect = true;
        }
    }
    private void OnFighterHurt(CoreEvent<UIEventParamFighterHurt> ce)
    {
        if (!bIsCanReflect)
            return;
        else
            bIsCanReflect = false;

        UIEventParamFighterHurt param = ce.Data;
        Fighter caster = param.mCaster;
        Fighter target = param.mTarget;

        if (mHitInfo.Target.Id == target.Id)
        {
            caster.ProcessReflectDamage(Data.value,"", target);
        }
    }
}
