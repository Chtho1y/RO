using UnityEngine;
using System.Collections;

public class HurtChangeValueFromTargetAttr : DurationFunctionEvent
{

    public static DurationFunctionEvent Creator(BuffFunctionData data)
    {
        return new HurtChangeValueFromTargetAttr(data);
    }

    int intervalFrame = 0;
    int nextFrame = 0;
    Fighter mFighter = null;
    public HurtChangeValueFromTargetAttr(BuffFunctionData data) : base(data)
    {
        mType = data.functionType;
        intervalFrame = (int)(data.intervalTime * Constants.frame_to_time);
    }


    public override void Enter(Fighter fighter)
    {
        base.Enter(fighter);
        mFighter = fighter;
        AddHurt();
        //Debug.LogError("fighter:" + mFighter.Name + " Enter "+ internalTime);
    }

    public override void Update(float deltaTime)
    {
        base.Update(deltaTime);
        nextFrame--;
        if (nextFrame <= 0)
        {
            AddHurt();
        }
    }

    public override void Exit(Fighter fighter)
    {
        //Debug.LogError("fighter:" + mFighter.Name + " Exit");
        base.Exit(fighter);
        mFighter = null;
    }


    void AddHurt()
    {
        nextFrame = intervalFrame;
        int subHp = 0;
        if (mType == Buff_Function_Type.Add_Duration_Hurt)
        {
            subHp = (int)Data.value;
        }
        else
        {
            subHp = (int)(mFighter.GetAttrByType(Data.fromAttr) * Data.value * 0.01f);
        }

        //Debug.LogError("fighter:" + mFighter.Name + " AddHurt:" + subHp);
        if (!mFighter.IsAlive) return;
        if (subHp > 0)
        {
            if (mFighter.StateData.IsInvincible)
                return;
            mFighter.Life -= subHp;

            if (Caster != null)
            {
                if (Caster.Statistics != null)
                    Caster.Statistics.StatOtherDamage(Caster, subHp);
                if (subHp > 0)
                    Caster.Battle.Output(OutputType.Damage, Caster, mFighter, "", (int)subHp);
            }

            UIEventParamFighterHurt hurtParam = new UIEventParamFighterHurt(Caster, mFighter, Mathf.RoundToInt(subHp), false, 0, 1, 1, 1, 0,0,0);
            EventMgr.DispatchEvent<UIEventParamFighterHurt>(new CoreEvent<UIEventParamFighterHurt>(ECoreEventType.EID_FIGHTER_HURT, hurtParam));
        }
    }
}
