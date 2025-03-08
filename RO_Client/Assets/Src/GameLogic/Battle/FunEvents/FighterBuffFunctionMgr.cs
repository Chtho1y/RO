using UnityEngine;
using System.Collections;
using System.Collections.Generic;

delegate DurationFunctionEvent DurationFunctionEventCreator(BuffFunctionData data);
delegate TickFunctionEvent TickFunctionEventCreator(BuffFunctionData data);

public class FighterBuffFunctionMgr
{
    Dictionary<Buff_Function_Type, DurationFunctionEventCreator> creators;
    Dictionary<Buff_Function_Type, TickFunctionEventCreator> tickCreators;

    Fighter mFighter;
    List<DurationFunctionEvent> mFunEventList;
    List<TickFunctionEvent> mInstanceEventList = null;
    SInt mCurrentShieldValue = 0;
    int mShieldEffectInstanceID = 0;
    int mShieldEndEffectId = 0;
    //float mShieldDurationTime = 0;  //护盾时长
    private int mShieldFrame = 0;
    bool mIsShield = false;     //是否处于护盾状态

    public List<TickFunctionEvent> TickEventList
    {
        get { return mInstanceEventList; }
    }

    public FighterBuffFunctionMgr(Fighter fighter)
    {
        mFighter = fighter;
        mFunEventList = new List<DurationFunctionEvent>();
        mInstanceEventList = new List<TickFunctionEvent>();
        RegisterCreators();
    }

    void RegisterCreators()
    {
        creators = new Dictionary<Buff_Function_Type, DurationFunctionEventCreator>();
        creators.Add(Buff_Function_Type.Body_Size_Change_Value, ChangeModelSizeFunEvent.Creator);
        creators.Add(Buff_Function_Type.Confusion, ConfusionFunEvent.Creator);
        creators.Add(Buff_Function_Type.Curse, CurseFunEvent.Creator);
        creators.Add(Buff_Function_Type.Fear, FearFunEvent.Creator);
        creators.Add(Buff_Function_Type.Forbid_NormalSkill, ForbidNormalSkillFunEvent.Creator);
        creators.Add(Buff_Function_Type.Forget, ForgetFunEvent.Creator);
        creators.Add(Buff_Function_Type.Frozen, FrozenFunEvent.Creator);
        creators.Add(Buff_Function_Type.Immunity, ImmunityFunEvent.Creator);
        creators.Add(Buff_Function_Type.Invincible, InvincibleFunEvent.Creator);
        creators.Add(Buff_Function_Type.Poison, PoisonFunEvent.Creator);
        creators.Add(Buff_Function_Type.Silence, SilenceFunEvent.Creator);
        creators.Add(Buff_Function_Type.Sleep, SleepFunEvent.Creator);
        creators.Add(Buff_Function_Type.Sneer, SneerFunEvent.Creator);
        creators.Add(Buff_Function_Type.Stiff, StiffFunEvent.Creator);
        creators.Add(Buff_Function_Type.Vertigo, VertigoFunEvent.Creator);
        creators.Add(Buff_Function_Type.STR_Change_Percent, ChangeAttrPercentFunEvent.Creator);
        creators.Add(Buff_Function_Type.INT_Change_Percent, ChangeAttrPercentFunEvent.Creator);
        creators.Add(Buff_Function_Type.AGI_Change_Percent, ChangeAttrPercentFunEvent.Creator);
        creators.Add(Buff_Function_Type.Change_MaxHP_Percent, ChangeMaxHpPercent.Creator);
        creators.Add(Buff_Function_Type.SP_Change_Percent, ChangeAttrPercentFunEvent.Creator);
        creators.Add(Buff_Function_Type.LUK_Change_Percent, ChangeAttrPercentFunEvent.Creator);
        creators.Add(Buff_Function_Type.Ten_Change_Percent, ChangeAttrPercentFunEvent.Creator);
        creators.Add(Buff_Function_Type.Crit_Change_Percent, ChangeAttrPercentFunEvent.Creator);
        creators.Add(Buff_Function_Type.AttackCD_Change_Percent, ChangeAttrPercentFunEvent.Creator);
        creators.Add(Buff_Function_Type.Phyx_Defense_Change_Percent, ChangeAttrPercentFunEvent.Creator);
        creators.Add(Buff_Function_Type.Magic_Defense_Change_Percent, ChangeAttrPercentFunEvent.Creator);
        creators.Add(Buff_Function_Type.Damage_Change_Percent, ChangeAttrPercentFunEvent.Creator);
        creators.Add(Buff_Function_Type.ChangeSkill, ChangeSkillFunEvent.Creator);
        creators.Add(Buff_Function_Type.Attack_Change_Percent, ChangeAttrPercentFunEvent.Creator);
        creators.Add(Buff_Function_Type.MagicAttack_Change_Percent, ChangeAttrPercentFunEvent.Creator);
        creators.Add(Buff_Function_Type.Heal_Change_Percent, ChangeAttrPercentFunEvent.Creator);
        creators.Add(Buff_Function_Type.Hit_Change_Percent, ChangeAttrPercentFunEvent.Creator);
        creators.Add(Buff_Function_Type.Dodge_Change_Percent, ChangeAttrPercentFunEvent.Creator);

        creators.Add(Buff_Function_Type.Hit_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.Dodge_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.IgnorePhysicDefense_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.IgnoreMagicDefense_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.PhysicDamagePercent_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.MagicDamagePercent_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.CritDamagePercent_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.PhysicDamageReflectPercent_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.MagicDamageReflectPercent_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.AntiPhysicDamagePercent_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.AntiMagicDamagePercent_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.Nature_None_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.Nature_Water_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.Nature_Ground_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.Nature_Fire_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.Nature_Wind_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.Nature_Saint_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.Nature_Dark_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.Nature_Read_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.AntiNature_None_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.AntiNature_Water_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.AntiNature_Ground_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.AntiNature_Fire_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.AntiNature_Wind_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.AntiNature_Saint_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.AntiNature_Dark_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.AntiNature_Read_Change_Value, ChangeAttrValueFunEvent.Creator);


        creators.Add(Buff_Function_Type.Attack_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.MagicAttack_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.STR_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.INT_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.AGI_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.Change_MaxHP_Value, ChangeMaxHpValue.Creator);
        creators.Add(Buff_Function_Type.SP_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.LUK_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.Ten_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.Crit_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.AttackCD_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.Phyx_Defense_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.Magic_Defense_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.Shield_AbsortAttack_Fixed_Change_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.ChangeHP_FromAttr_Percent, ChangeHP_FromAttrFunEvent.Creator);
        creators.Add(Buff_Function_Type.ChangeHP_From_CasterAttr_Percent, ChangeHP_FromCasterAttrFunEvent.Creator);
        creators.Add(Buff_Function_Type.Break, BreakFunEvent.Creator);
        creators.Add(Buff_Function_Type.RageStatus, RageStatusFunEvent.Creator);
        creators.Add(Buff_Function_Type.ChangeSkillSpeed, ChangeSkillAnimSpeed.Creator);
        creators.Add(Buff_Function_Type.AttackSpeed_Change_Percent, ChangeAttrValueFunEvent.Creator);

        creators.Add(Buff_Function_Type.Add_Duration_Hurt, HurtChangeValueFromCasterAttr.Creator);
        creators.Add(Buff_Function_Type.Hurt_Change_Value_From_Caster_STR, HurtChangeValueFromCasterAttr.Creator);
        creators.Add(Buff_Function_Type.Hurt_Change_Value_From_Caster_AGI, HurtChangeValueFromCasterAttr.Creator);
        creators.Add(Buff_Function_Type.Hurt_Change_Value_From_Caster_INT, HurtChangeValueFromCasterAttr.Creator);
        creators.Add(Buff_Function_Type.Hurt_Change_Value_From_Caster_VIT, HurtChangeValueFromCasterAttr.Creator);
        creators.Add(Buff_Function_Type.Hurt_Change_Value_From_Caster_DEX, HurtChangeValueFromCasterAttr.Creator);
        creators.Add(Buff_Function_Type.Hurt_Change_Value_From_Caster_LUK, HurtChangeValueFromCasterAttr.Creator);
        creators.Add(Buff_Function_Type.Hurt_Change_Value_From_Caster_HP, HurtChangeValueFromCasterAttr.Creator);
        creators.Add(Buff_Function_Type.Hurt_Change_Value_From_Caster_SP, HurtChangeValueFromCasterAttr.Creator);
        creators.Add(Buff_Function_Type.Hurt_Change_Value_From_Caster_Attack, HurtChangeValueFromCasterAttr.Creator);
        creators.Add(Buff_Function_Type.Hurt_Change_Value_From_Caster_MagicAttack, HurtChangeValueFromCasterAttr.Creator);
        creators.Add(Buff_Function_Type.Hurt_Change_Value_From_Caster_Defense, HurtChangeValueFromCasterAttr.Creator);
        creators.Add(Buff_Function_Type.Hurt_Change_Value_From_Caster_MagicDefense, HurtChangeValueFromCasterAttr.Creator);
        creators.Add(Buff_Function_Type.Hurt_Change_Value_From_Caster_Hit, HurtChangeValueFromCasterAttr.Creator);
        creators.Add(Buff_Function_Type.Hurt_Change_Value_From_Caster_Dodge, HurtChangeValueFromCasterAttr.Creator);
        creators.Add(Buff_Function_Type.Hurt_Change_Value_From_Caster_Crit, HurtChangeValueFromCasterAttr.Creator);
        creators.Add(Buff_Function_Type.Hurt_Change_Value_From_Caster_Ten, HurtChangeValueFromCasterAttr.Creator);
        creators.Add(Buff_Function_Type.Hurt_Change_Value_From_Caster_AttackSpeed, HurtChangeValueFromCasterAttr.Creator);
        creators.Add(Buff_Function_Type.Hurt_Change_Value_From_Caster_MaxHp, HurtChangeValueFromCasterAttr.Creator);
        creators.Add(Buff_Function_Type.Hurt_Change_Value_From_Caster_MaxSP, HurtChangeValueFromCasterAttr.Creator);
        creators.Add(Buff_Function_Type.Hurt_Change_Value_From_Target_HP, HurtChangeValueFromTargetAttr.Creator);
        creators.Add(Buff_Function_Type.Hurt_Change_Value_From_Target_MaxHP, HurtChangeValueFromTargetAttr.Creator);
        creators.Add(Buff_Function_Type.PassiveSkill_Trigger, PassiveSkillTriggerEvent.Creator);

        //-----------new
        creators.Add(Buff_Function_Type.Hurt_Targert_SuckBlood, SuckBloodFunEvent.Creator);
        creators.Add(Buff_Function_Type.Attack_Change_ByTargetAttr, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.MagicAttack_Change_ByTargetAttr, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.AttackDefense_Change_ByTargetAttr, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.MagicDefense_Change_ByTargetAttr, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.Attack_Change_BySourceAttr, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.MagicAttack_Change_BySourceAttr, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.AttackDefense_Change_BySourceAttr, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.MagicDefense_Change_BySourceAttr, ChangeAttrValueFunEvent.Creator);
        
        creators.Add(Buff_Function_Type.Attack_Change_ByTargetCostHpPercent, ChangeAttrPercentFunEvent.Creator);
        creators.Add(Buff_Function_Type.MagicAttack_Change_ByTargetCostHpPercent, ChangeAttrPercentFunEvent.Creator);
        creators.Add(Buff_Function_Type.Attack_Change_BySourceCostHpPercent, ChangeAttrPercentFunEvent.Creator);
        creators.Add(Buff_Function_Type.MagicAttack_Change_BySourceCostHpPercent, ChangeAttrPercentFunEvent.Creator);

        creators.Add(Buff_Function_Type.Attack_Change_ByTargetCurHpPercent, ChangeAttrPercentFunEvent.Creator);
        creators.Add(Buff_Function_Type.MagicAttack_Change_ByTargetCurHpPercent, ChangeAttrPercentFunEvent.Creator);
        creators.Add(Buff_Function_Type.Attack_Change_BySourceCurHpPercent, ChangeAttrPercentFunEvent.Creator);
        creators.Add(Buff_Function_Type.MagicAttack_Change_BySourceCurHpPercent, ChangeAttrPercentFunEvent.Creator);

        creators.Add(Buff_Function_Type.Reflect_Hurt_ByTargetAttr, ReflectPercentHurtFunEvent.Creator);
        creators.Add(Buff_Function_Type.Reflect_Hurt_BySourceAttr, ReflectPercentHurtFunEvent.Creator);
        creators.Add(Buff_Function_Type.Reflect_Fix_Hurt, ReflectFixHurtFunEvent.Creator);

        creators.Add(Buff_Function_Type.Hurt_Attack_SuckDamage, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.Hurt_MagicAttack_SuckDamage, ChangeAttrValueFunEvent.Creator);

        creators.Add(Buff_Function_Type.Change_Hit_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.Change_Doge_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.Change_Crit_Value, ChangeAttrValueFunEvent.Creator);
        creators.Add(Buff_Function_Type.Change_Ten_Value, ChangeAttrValueFunEvent.Creator);
        //------------------------------------------------------------

        tickCreators = new Dictionary<Buff_Function_Type, TickFunctionEventCreator>();
        tickCreators.Add(Buff_Function_Type.Heal_Change_Percent_From_Target, HealHPPercent.Creator);
        tickCreators.Add(Buff_Function_Type.Heal_Target_HP_Change_Value, HealHP.Creator);
        tickCreators.Add(Buff_Function_Type.Heal_Change_Percent_From_Caster, HealHPFromCaster.Creator);
        tickCreators.Add(Buff_Function_Type.SP_Change_Percent, SPChangePercent.Creator);
        tickCreators.Add(Buff_Function_Type.SP_Change_Value, SPChange.Creator);
        tickCreators.Add(Buff_Function_Type.Add_SP_From_Caster, SPChangeFromCaster.Creator);
        tickCreators.Add(Buff_Function_Type.Add_Function_Point_Value, AddFunctionPoint.Creator);
        tickCreators.Add(Buff_Function_Type.Deduct_Function_Point_Value, DetectFunctionPoint.Creator);
        tickCreators.Add(Buff_Function_Type.ChangeBuff_Using_Function_Point, TriggerBuffUsingFunctionPoint.Creator);
    }

    public FunctionEvent AddFunctionEvent(int buffId,BuffFunctionData data,Fighter caster, SkillHitFighterInfo hitInfo)
    {
        if (mFighter == null || !mFighter.IsAlive) return null;

        //判断是否处于免疫效果
        if (mFighter.StateData.IsImmunity && data.buffType == BattleBuffType.Negative) {
            //DebugHelper.LogError(mFighter.Name + " 当前处于免疫，不能增加" + data.functionType);
            return null;
        }

        //被诅咒时，不能增加增益效果
        if (mFighter.StateData.IsCurse && data.buffType == BattleBuffType.Enhance)
        {
            return null;
        }

        if (data == null) return null;

        string skillName = null;
        if (hitInfo.Skill != null && !hitInfo.Skill.IsNormalAttack)
            skillName = hitInfo.Skill.SkillName;

        if (data.functionType == Buff_Function_Type.Shield_AbsortAttack_Change_Percent || 
           data.functionType == Buff_Function_Type.Shield_AbsortAttack_Fixed_Change_Value ||
           data.functionType == Buff_Function_Type.Shield_AbsortAttack_Change_Percent_From_Caster)
        {
            CheckShield(caster,data, skillName);
            return null;
        }

        if (!string.IsNullOrEmpty(data.word))
        {
            if(data.buffType == BattleBuffType.Negative)
            {
                EventMgr.DispatchEvent<Fighter, string>(new CoreEvent<Fighter, string>(ECoreEventType.EID_NEGATIVE_FUNCTION, mFighter, data.word));
            }
            else
            {
                EventMgr.DispatchEvent<Fighter, string>(new CoreEvent<Fighter, string>(ECoreEventType.EID_ADD_FUNCTION, mFighter, data.word));
            }
        }


        if (caster != null)
        {
            if (data.buffType == BattleBuffType.Negative)
            {
                if(caster.Statistics!=null)
                    caster.Statistics.StatBuffInfo(caster, true);
            }
            else if (data.buffType == BattleBuffType.Enhance)
            {
                if(caster.Statistics!=null)
                    caster.Statistics.StatBuffInfo(caster, false);
            }
        }

        if (data.IsInstantFunc)
        {
            int skillLv = data.SkillLv;
            if (hitInfo.Skill != null)
            {
                skillLv = hitInfo.Skill.Level;
            }
            skillLv = skillLv < 1 ? 1 : skillLv;
            return ExecuteInstanceFunc(buffId,data,caster, skillLv,skillName);
        }

        //DebugHelper.Log("----fighter: " + mFighter.Name + " 增加效果id:" + data.functionType);
        if (ExistBuffFunction(data.functionType,data.buffType,data.Group))
        {
            DurationFunctionEvent funEvent = GetFunctionByType(data.functionType,data.Group);
            if (funEvent.Data.value > data.value) return funEvent;

            funEvent.Caster = caster;
            funEvent.BuffId = buffId;
            funEvent.HitInfo = hitInfo;
            funEvent.ResetData(data);
            funEvent.ResetDuration(data.duration);
            return funEvent;
        }

        if (!creators.ContainsKey(data.functionType)) return null;

        //打断
        if (data.functionType == Buff_Function_Type.Break)
        {
            if (mFighter.CurrentSkill != null && mFighter.CurrentSkill.CanBreak)
            {
                DurationFunctionEvent newEvt = creators[data.functionType](data);
                newEvt.Caster = caster;
                newEvt.BuffId = buffId;
                newEvt.HitInfo = hitInfo;
                newEvt.Enter(mFighter);
                mFunEventList.Add(newEvt);

                //if(caster!=null && caster.StateData.CurrentSkill != null && caster.StateData.CurrentSkill.HasBuff(buffId))
                //{
                //    caster.TriggerBuffByType(caster.StateData.CurrentSkill, SkillTriggerBuffType.Skill_Break_Trigger);
                //}

                if(caster!=null && caster.StateData.CurrentSkill!= null)
                {
                    string sName = null;
                    if(!caster.StateData.CurrentSkill.IsNormalAttack)
                    {
                        sName = caster.StateData.CurrentSkill.SkillName;
                    }

                    string targetSkillName = mFighter.CurrentSkill != null ? mFighter.CurrentSkill.SkillName : "";
                    caster.Battle.Output(OutputType.Break, caster, mFighter, sName, targetSkillName);

                    EventMgr.DispatchEvent<Fighter, BaseSkill>(new CoreEvent<Fighter, BaseSkill>(ECoreEventType.EID_Fighter_Break_Skill, caster,caster.StateData.CurrentSkill));
                }

                return newEvt;
            }
        }
        else
        {           
            DurationFunctionEvent newEvt = creators[data.functionType](data);
            newEvt.Caster = caster;
            newEvt.BuffId = buffId;
            newEvt.HitInfo = hitInfo;
            newEvt.SkillName = skillName;
            newEvt.Enter(mFighter);
            mFunEventList.Add(newEvt);

            //判断效果清除
            if (newEvt.IsHurtEvent)
            {
                RemoveFunctionByHurtBreak();
            }
            return newEvt;
        }
        return null;
    }

    public int NegativeFunCnt
    {
        get
        {
            int cnt = 0;
            if(mFunEventList != null)
            {
                for (int idx = 0; idx < mFunEventList.Count; idx++)
                {
                    if(mFunEventList[idx].BuffType == BattleBuffType.Negative)
                    {
                        cnt++;
                    }
                }
            }

            if(mInstanceEventList != null)
            {
                for(int idx =0; idx < mInstanceEventList.Count;idx++)
                {
                    if (mInstanceEventList[idx].BuffType == BattleBuffType.Negative)
                        cnt++;
                }
            }
            return cnt;
        }
    }
    //是否存在释放技能效果
    public bool HaveForbidSkillFunc()
    {
        if (mFunEventList == null) return false;

        //if (mFighter.Battle.IsPlayRecord) return false;

        for (int idx =0; idx < mFunEventList.Count;idx++)
        {
            if (mFunEventList[idx].Data.forbidSkill)
            {
                return true;
            }
        }
        return false;
    }

    //判断是否存在禁止普攻释放
    public bool HaveForbidNormalAttackFunc()
    {
        if (mFunEventList == null) return false;

        for (int idx =0; idx < mFunEventList.Count;idx++)
        {
            if (mFunEventList[idx].Data.forbidNormalAttack)
                return true;
        }
        return false;
    }

    //是否存在禁止移动
    public bool HaveForbidMoveFunc()
    {
        if (mFunEventList == null) return false;

        for(int idx =0; idx < mFunEventList.Count;idx++)
        {
            if (mFunEventList[idx].Data.forbidMove)
                return true;
        }
        return false;
    }

    //是否存在忽视闪避的效果
    public bool HaveIgoreDodgeFunction()
    {
        if (mFunEventList == null) return false;

        for (int idx = 0; idx < mFunEventList.Count; idx++)
        {
            if (mFunEventList[idx].Data.canIgnoreDodge)
                return true;
        }
        return false;
    }

    public bool ExistBuffFunction(Buff_Function_Type type,BattleBuffType buffType,int group)
    {
        for(int idx =0; idx < mFunEventList.Count;idx++)
        {
            if (mFunEventList[idx].Type == type && mFunEventList[idx].BuffType == buffType && mFunEventList[idx].Group == group) return true;
        }

        for(int idx =0; idx < mInstanceEventList.Count;idx++)
        {
            if (mInstanceEventList[idx].Type == type && mInstanceEventList[idx].BuffType == buffType && mFunEventList[idx].Group == group) return true;
        }

        return false;
    }

    public bool HaveBuffFunction(Buff_Function_Type type)
    {
        for (int idx = 0; idx < mFunEventList.Count; idx++)
        {
            if (mFunEventList[idx].Type == type) return true;
        }

        for (int idx = 0; idx < mInstanceEventList.Count; idx++)
        {
            if (mInstanceEventList[idx].Type == type) return true;
        }

        return false;
    }

    public bool HaveBuffType(BattleBuffType buffType)
    {
        for(int idx =0; idx < mFunEventList.Count;idx++)
        {
            if (mFunEventList[idx].Data.buffType == buffType)
                return true;
        }

        for(int idx =0; idx < mInstanceEventList.Count;idx++)
        {
            if (mInstanceEventList[idx].Data.buffType == buffType)
                return true;
        }

        return false;
    }

    public DurationFunctionEvent GetFunctionByType(Buff_Function_Type type)
    {
        for (int idx = 0; idx < mFunEventList.Count; idx++)
        {
            if (mFunEventList[idx].Type == type) return mFunEventList[idx];
        }

        return null;
    }

    public DurationFunctionEvent GetFunctionByType(Buff_Function_Type type, int group)
    {
        for (int idx = 0; idx < mFunEventList.Count; idx++)
        {
            if (mFunEventList[idx].Type == type && mFunEventList[idx].Group == group) return mFunEventList[idx];
        }

        return null;
    }

    public SFloat GetBuffValue(Buff_Function_Type functionType)
    {
        SFloat val = 0;

        if(mFunEventList != null)
        {
            for (int idx = mFunEventList.Count - 1; idx >= 0; idx--)
            {
                var fun = mFunEventList[idx];
                if (fun.Data.functionType == functionType)
                {
                    val += fun.GetValue();
                }

            }
        }

        if(mInstanceEventList!=null)
        {
            for (int idx = mInstanceEventList.Count - 1; idx >= 0; idx--)
            {
                var fun = mInstanceEventList[idx];
                if (fun.Data.functionType == functionType)
                {
                    val += fun.GetValue();
                }
            }
        }
        return val;
    } 

    public bool GetSuckDamage(Buff_Function_Type functionType,out SFloat val, out int nMaxHpPercent)
    {
        val = 0;
        nMaxHpPercent = 0;

        if(functionType == Buff_Function_Type.Hurt_Attack_SuckDamage || functionType == Buff_Function_Type.Hurt_MagicAttack_SuckDamage)
        if (mFunEventList != null)
        {
            for (int idx = mFunEventList.Count - 1; idx >= 0; idx--)
            {
                var fun = mFunEventList[idx];
                if (fun.Data.functionType == functionType)
                {
                    val += fun.GetValue();                    
                    int MaxHp = 0;
                    int.TryParse(fun.Data.extendParam, out MaxHp);
                    nMaxHpPercent = Mathf.Max(MaxHp,nMaxHpPercent);
                }

            }
        }
        return val != 0;
    }

    public SInt DamageOnShield(SInt damage)
    {
        if (mIsShield && damage > 0)
        {
            SInt decValue = Mathf.Min(damage, mCurrentShieldValue);
            damage -= decValue;
            mCurrentShieldValue -= decValue;
            if(mCurrentShieldValue <= 0)
            {
                mCurrentShieldValue = 0;
                ClearShield(true);
            }

            if(decValue > 0)
            {
                EventMgr.DispatchEvent<Fighter, int>(new CoreEvent<Fighter, int>(ECoreEventType.EID_SHIELD_ABSORT_HURT, mFighter, -decValue));
                //DebugHelper.Log("Fighter:" + mFighter.Name + "  DamageOnShield" + decValue);
            }   
        }
        return damage;
    }

    public void Update(float deltaTime)
    {
        if(mIsShield)
        {
            //mShieldDurationTime -= deltaTime;
            //if(mShieldDurationTime <=0)
            //{
            //    ClearShield();
            //}
            mShieldFrame--;
            if(mShieldFrame<=0)
            {
                ClearShield(true);
            }
        }

        for(int idx =0; idx < mFunEventList.Count;idx++)
        {
            mFunEventList[idx].Update(deltaTime);
        }

        for(int idx = mFunEventList.Count -1; idx>=0;idx--)
        {
            if(mFunEventList[idx].Expired(mFighter))
            {
                mFunEventList[idx].Exit(mFighter);
                mFunEventList.RemoveAt(idx);
            }
        }

        for(int idx = mInstanceEventList.Count - 1;idx >=0;idx--)
        {
            if (mInstanceEventList[idx].Expired())
            {
                mInstanceEventList.RemoveAt(idx);
            }
        }
    }

    public void OnFightingEnd()
    {
        Clear();
    }

    public void RemoveNegativeFunction()
    {
        RemoveFunctionByBuffType(BattleBuffType.Negative);
    }

    public void RemoveEnhanceFunction()
    {
        RemoveFunctionByBuffType(BattleBuffType.Enhance);
    }

    //异常伤害打断的效果
    public void RemoveFunctionByHurtBreak()
    {
        for(int idx = mFunEventList.Count - 1; idx >= 0;idx--)
        {
            var evt = mFunEventList[idx];
            if(evt.Data.canHurtStop)
            {
                evt.Exit(mFighter);
                mFunEventList.RemoveAt(idx);
            }
        }
    }

    public void RemoveFunctionByBuffType(BattleBuffType type)
    {
        for(int idx = mFunEventList.Count -1;idx>=0;idx--)
        {
            if(mFunEventList[idx].Data.buffType == type)
            {
                mFunEventList[idx].Exit(mFighter);
                mFunEventList.RemoveAt(idx);
            }
        }

        for(int idx = mInstanceEventList.Count-1; idx >=0;idx--)
        {
            if (mInstanceEventList[idx].Data.buffType == type)
            {
                mInstanceEventList[idx].Exit(mFighter);
                mInstanceEventList.RemoveAt(idx);
            }
        }
    }

    public void RemoveFunctionByBuffType(BattleBuffType type,int group)
    {
        for (int idx = mFunEventList.Count - 1; idx >= 0; idx--)
        {
            if (mFunEventList[idx].Data.buffType == type && mFunEventList[idx].Group == group)
            {
                mFunEventList[idx].Exit(mFighter);
                mFunEventList.RemoveAt(idx);
            }
        }

        for (int idx = mInstanceEventList.Count - 1; idx >= 0; idx--)
        {
            if (mInstanceEventList[idx].Data.buffType == type && mInstanceEventList[idx].Group == group)
            {
                mInstanceEventList[idx].Exit(mFighter);
                mInstanceEventList.RemoveAt(idx);
            }
        }
    }

    public void RemoveFunctionByFunType(Buff_Function_Type type)
    {
        for(int idx = mFunEventList.Count -1; idx>=0;idx--)
        {
            if(mFunEventList[idx].Data.functionType == type)
            {
                mFunEventList[idx].Exit(mFighter);
                mFunEventList.RemoveAt(idx);
            }
        }

        for (int idx = mInstanceEventList.Count - 1; idx >= 0; idx--)
        {
            if (mInstanceEventList[idx].Data.functionType == type)
            {
                mInstanceEventList[idx].Exit(mFighter);
                mInstanceEventList.RemoveAt(idx);
            }
        }
    }

    public void RemoveDurationFunEvent(int funId,int group)
    {
        for(int idx =mFunEventList.Count -1; idx>=0; idx--)
        {
            if(mFunEventList[idx].Data.id == funId && mFunEventList[idx].Group == group)
            {
                mFunEventList[idx].Exit(mFighter);
                mFunEventList.RemoveAt(idx);
            }
        }
    }

    public void Clear()
    {
        for(int idx = 0; idx < mFunEventList.Count;idx++)
        {
            mFunEventList[idx].Exit(mFighter);
        }
        mFunEventList.Clear();

        for (int idx = mInstanceEventList.Count - 1; idx >= 0; idx--)
        {
            mInstanceEventList[idx].Exit(mFighter);
        }
        mInstanceEventList.Clear();

        ClearShield();
    }

    public void Dispose()
    {
        Clear();
        creators.Clear();
        mFighter = null;
        mFunEventList = null;
        creators = null;
    }

    void CheckShield(Fighter caster,BuffFunctionData data,string skillName)
    {
        SInt value = 0;
        if (data.functionType == Buff_Function_Type.Shield_AbsortAttack_Change_Percent)
        {
            value = (SInt)(mFighter.GetAttrByType(data.fromAttr) * data.value * 0.01f);
        }
        else if(data.functionType == Buff_Function_Type.Shield_AbsortAttack_Fixed_Change_Value)
        {
            value = (SInt)data.value;
        }else if(data.functionType == Buff_Function_Type.Shield_AbsortAttack_Change_Percent_From_Caster)
        {
            if(caster!=null)
            {
                value = (SInt)(caster.GetAttrByType(data.fromAttr) * data.value * 0.01f);
            }
        }
        
        if(value > mCurrentShieldValue)
        {
            mShieldFrame = (int)(data.duration * Constants.frame_to_time);
            mCurrentShieldValue = value;

            if(caster!=null)
            {
                caster.Battle.Output(OutputType.Shield, caster, mFighter, skillName, (int)mCurrentShieldValue);
            }
        }
      
        if(!mIsShield && mCurrentShieldValue > 0)
        {
            EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_FIGHTER_ADD_SHIELD, mFighter));
            if(data.effectId > 0)
                mShieldEffectInstanceID = EffectManager.Instance.PlayEffect(data.effectId, mFighter, mFighter);
            mShieldEndEffectId = data.endeffectId;
        }
        mIsShield = mCurrentShieldValue > 0;
    }

    void ClearShield(bool notified =false)
    {
        if(mShieldEffectInstanceID > 0)
        {
            EffectManager.Instance.RemoveEffectByInstanceID(mShieldEffectInstanceID);
            mShieldEffectInstanceID = 0;

            if (mShieldEndEffectId > 0)
                EffectManager.Instance.PlayEffect(mShieldEndEffectId, mFighter, mFighter);
        }
        mShieldEndEffectId = 0;
        mCurrentShieldValue = 0;
        mIsShield = false;
        mShieldFrame = 0;
        if(notified)
        {
            EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_FIGHTER_CLEAR_SHIELD, mFighter));
        }
    }

    FunctionEvent ExecuteInstanceFunc(int BuffId,BuffFunctionData data,Fighter caster,int castingSkillLv,string skillName)
    {
        if (tickCreators.ContainsKey(data.functionType))
        {
            data.SetLevel(castingSkillLv);
            TickFunctionEvent newEvt = tickCreators[data.functionType](data);
            newEvt.Caster = caster;
            newEvt.BuffId = BuffId;
            newEvt.SkillName = skillName;
            mInstanceEventList.Add(newEvt);
            newEvt.Enter(mFighter);
            mInstanceEventList.Remove(newEvt);
            return newEvt;
        }

        TickFunctionEvent evt = new TickFunctionEvent(data);
        evt.SkillName = skillName;
        mInstanceEventList.Add(evt);

        //净化
        if(HaveBuffFunction(Buff_Function_Type.Clean))
        {
            if (caster != null && HaveBuffType(BattleBuffType.Negative))
            {
                caster.Battle.Output(OutputType.Clean, caster, mFighter, skillName, 0);
                if (caster != null && caster.StateData.CurrentSkill != null && caster.StateData.CurrentSkill.HasBuff(BuffId))
                {
                    //caster.TriggerBuffByType(caster.StateData.CurrentSkill, SkillTriggerBuffType.Purify_Target_Debuff_Trigger);
                    EventMgr.DispatchEvent<Fighter, BaseSkill>(new CoreEvent<Fighter, BaseSkill>(ECoreEventType.EID_Fighter_Purify_Debuff, caster, caster.StateData.CurrentSkill));
                }
            }

            RemoveNegativeFunction();
        }

        //驱散
        if(HaveBuffFunction(Buff_Function_Type.Disperse))
        {
            if(caster!=null && (HaveBuffType(BattleBuffType.Enhance) || mIsShield))
            {
                caster.Battle.Output(OutputType.Disperse, caster, mFighter, skillName, 0);
                if (caster != null && caster.StateData.CurrentSkill != null && caster.StateData.CurrentSkill.HasBuff(BuffId))
                {
                    //caster.TriggerBuffByType(caster.StateData.CurrentSkill, SkillTriggerBuffType.Disperse_Target_Buff_Trigger);
                    EventMgr.DispatchEvent<Fighter, BaseSkill>(new CoreEvent<Fighter, BaseSkill>(ECoreEventType.EID_Fighter_Disperse_Buff, caster, caster.StateData.CurrentSkill));
                }
            }

            RemoveEnhanceFunction();
            ClearShield();
        }
        return evt;
    }
}
