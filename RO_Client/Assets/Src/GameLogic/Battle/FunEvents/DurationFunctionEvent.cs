using UnityEngine;
using System.Collections;

public class DurationFunctionEvent : FunctionEvent
{
    //protected float mContinueTime = 0;
    //protected float mDuration;
    protected int mTotalFrame = 0;
    protected int mFrame = 0;
    private int effectInstanceId = 0;
    protected SkillHitFighterInfo mHitInfo;

    public SkillHitFighterInfo HitInfo
    {
        get { return mHitInfo; }
        set { mHitInfo = value; }
    }

    //伤害类型效果
    public bool IsHurtEvent
    {
        get { return mData.buffType == BattleBuffType.Hurt; }
    }

    //增益类型效果
    public bool IsEnhanceEvent
    {
        get { return mData.buffType == BattleBuffType.Enhance; }
    }

    //减益效果类型
    public bool IsNegativeEvent
    {
        get { return mData.buffType == BattleBuffType.Negative; }
    }

    //特殊效果类型
    public bool IsSpecialEvent
    {
        get { return mData.buffType == BattleBuffType.Special; }
    }

    //治疗效果类型
    public bool IsHealEvent
    {
        get { return mData.buffType == BattleBuffType.Heal; }
    }

    public DurationFunctionEvent(BuffFunctionData data):base(data)
    {
        //mDuration = data.duration;
        mTotalFrame = (int)(data.duration * Constants.frame_to_time);
    }

    public override void Enter(Fighter fighter)
    {
        if(Data.effectId > 0)
            effectInstanceId = EffectManager.Instance.PlayEffect(Data.effectId, fighter, fighter);

        if(!string.IsNullOrEmpty(Data.icon))
        {
            bool debuff = (Data.buffType == BattleBuffType.Negative || Data.buffType == BattleBuffType.SpecialNegative);
        }
    }

    public override void Exit(Fighter fighter)
    {
        if (effectInstanceId > 0)
        {
            EffectManager.Instance.RemoveEffectByInstanceID(effectInstanceId);
            effectInstanceId = 0;
        }
        if (Data.endeffectId > 0)
            EffectManager.Instance.PlayEffect(Data.endeffectId, fighter, fighter);
    }

    public virtual void Update(float deltaTime)
    {
        //mContinueTime += deltaTime;
        mFrame++;
    }

    public virtual bool Expired(Fighter figher)
    {
        //return mContinueTime >= mDuration;
        return mFrame >= mTotalFrame;
    }


    public void ResetData(BuffFunctionData data)
    {
        mData = data;
    }

    public void ResetDuration(float duration)
    {
        //if(mDuration - mContinueTime < duration)
        //{
        //    //DebugHelper.Log(Data.functionType + " resetduration");
        //    mDuration = duration;
        //    mContinueTime = 0;

        //}
        int frame =(int) (duration * Constants.frame_to_time);
        if(mTotalFrame - mFrame < frame)
        {
            mTotalFrame = frame;
            mFrame = 0;
        }
    }
}
