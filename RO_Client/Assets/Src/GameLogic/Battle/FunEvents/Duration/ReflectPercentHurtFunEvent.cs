using UnityEngine;
using System.Collections;

public class ReflectPercentHurtFunEvent : DurationFunctionEvent
{
    int internalFrame = 0;
    int nextRecoverFrame = 0;
    bool bIsCanReflect = false;
    public static ReflectPercentHurtFunEvent Creator(BuffFunctionData data)
    {
        return new ReflectPercentHurtFunEvent(data);
    }

    public ReflectPercentHurtFunEvent(BuffFunctionData data) : base(data)
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

        if (HitInfo.Target.Id == target.Id)
        {
            //Debug.Log("百分比反伤!");
            SFloat ReflectDamage = 0f;
            switch (mType)
            {
                case Buff_Function_Type.Reflect_Hurt_ByTargetAttr:
                    //Debug.Log("属性 " + target.GetAttrByType(Data.fromAttr).ToString());
                    //Debug.Log("百分比 " + (Data.value * 0.01f).ToString());
                    ReflectDamage = target.GetAttrByType(Data.fromAttr) * Data.value * 0.01f;
                    break;
                case Buff_Function_Type.Reflect_Hurt_BySourceAttr:
                    //Debug.Log("属性 "+ Caster.GetAttrByType(Data.fromAttr).ToString());
                    //Debug.Log("百分比 " + (Data.value * 0.01f).ToString());
                    ReflectDamage = Caster.GetAttrByType(Data.fromAttr) * Data.value * 0.01f;
                    break;
            }
            //Debug.Log("ReflectDamage "+ ReflectDamage.ToString());
            if(ReflectDamage > 0)
                caster.ProcessReflectDamage(ReflectDamage, "", target);
        }
    }
}
