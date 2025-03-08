using UnityEngine;
using System.Collections;

public class PassiveSkillTriggerEvent : DurationFunctionEvent
{
    public static DurationFunctionEvent Creator(BuffFunctionData data)
    {
        return new PassiveSkillTriggerEvent(data);
    }

    public PassiveSkillTriggerEvent(BuffFunctionData data) : base(data)
    {
        mType = data.functionType;
    }

    int buffId = 0;
    BuffTriggerType tType;
    int intervalFrame = 0;
    int nextFrame = 0;
    Fighter mFighter = null;

    public override void Enter(Fighter fighter)
    {
        base.Enter(fighter);

        mFighter = fighter;
        buffId = (int)Data.BaseValue;
        float buffRate = Data.IncVal * 0.01f;
        int temp = 0;
        if (Data.fromAttr.Length > 0)
             temp = Data.fromAttr[0];
        int casterType = temp / 100;
        int type = temp - casterType * 100;

        tType = (BuffTriggerType)type;
        if(tType != BuffTriggerType.Trigger_FixedTime)
        {
            BuffTriggerCasterType cType = (BuffTriggerCasterType)casterType;
            TriggerBuffData buffData = new TriggerBuffData(buffId, buffRate, Data.intervalTime, tType, cType,Data.extendParam);
            buffData.BuffLevel = Data.SkillLv;
            if (!string.IsNullOrEmpty(Data.extendParam))
            {
                int val = 0;
                int.TryParse(Data.extendParam, out val);
                buffData.CheckVal = val;
            }

            fighter.AddTriggerBuffData(buffData);
        }
        else
        {
            intervalFrame = (int)(Data.intervalTime * Constants.frame_to_time);
            nextFrame = intervalFrame;
        }
        
    }

    public override void Update(float deltaTime)
    {
        base.Update(deltaTime);
        if(tType == BuffTriggerType.Trigger_FixedTime)
        {
            nextFrame--;
            if (nextFrame <= 0)
            {
                TriggerBuff();
            }
        }
    }

    public override void Exit(Fighter fighter)
    {
        fighter.RemoveTriggerBuffData(buffId);
        base.Exit(fighter);
        mFighter = null;
    }

    private void TriggerBuff()
    {
        nextFrame = intervalFrame;
        mFighter.CastBuff(null, buffId, Data.SkillLv);
    }
}
