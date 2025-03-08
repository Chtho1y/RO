using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public struct stDamageParam
{
    public long targetId;
    public int targetBaseId;
    public int targetTeamSide;

    public SFloat perfectDodge;
    public SFloat dodge;
    public SFloat critRate;
    public bool IsPerfectDodge;
    public bool IsDodge;
    public bool IsCrit;
    public SFloat attack;
    public SFloat magicAttack;
    public SFloat physicDamPercent;
    public SFloat magicDamPercent;
    public SFloat antiPhysicDamPercent;
    public SFloat antiMagicDamPercent;
    public SFloat casterNatureDamPer;
    public SFloat targetAntiNatureDamPer;
    public SFloat critDamPercent;
    public SFloat realHurt;
    public SFloat defense;
    public SFloat defPercent;
    public SFloat ignoreDefense;
    public SFloat decreaseDefPercent;
    public SFloat magicDefense;
    public SFloat magicDefPercent;
    public SFloat ignoreMagicDefense;
    public SFloat decreaseMagicDefPercent;
    public SInt damage;
    public SInt realDamage;

    public void Reset()
    {
        perfectDodge = 0;
        dodge = 0;
        critRate = 0;
        IsPerfectDodge = false;
        IsDodge = false;
        IsCrit = false;
        attack = 0;
        magicAttack = 0;
        physicDamPercent = 0;
        magicDamPercent = 0;
        antiPhysicDamPercent = 0;
        antiMagicDamPercent = 0;
        casterNatureDamPer = 0;
        targetAntiNatureDamPer = 0;
        critDamPercent = 0;
        realHurt = 0;
        defense = 0;
        defPercent = 0;
        ignoreDefense = 0;
        decreaseDefPercent = 0;
        magicDefense = 0;
        magicDefPercent = 0;
        ignoreMagicDefense = 0;
        decreaseMagicDefPercent = 0;
        damage = 0;
        realDamage = 0;
    }

    public string ToString()
    {
        string str = string.Format(" perfectDodge:{21},dodge:{22},critRate:{23}" +
            "IsPerfectDodge:{0},IsDodge:{1}," +
            "IsCrit:{2},attack:{3},magicAttack:{4},physicDamPercent:{5}," +
            "magicDamPercent:{6},antiPhysicDamPercent:{7},antiMagicDamPercent:{8}," +
            "casterNatureDamPer:{9},targetAntiNatureDamPer:{10},critDamPercent:{11},realHurt:{12}," +
            "defense:{13},defPercent:{14},ignoreDefense:{15},decreaseDefPercent:{16}" +
            "magicDefense:{17},magicDefPercent:{18},ignoreMagicDefense:{19},decreaseMagicDefPercent:{20}",
           IsPerfectDodge,IsDodge,IsCrit,
           attack,magicAttack,physicDamPercent, magicDamPercent,
           antiPhysicDamPercent, antiMagicDamPercent, casterNatureDamPer, targetAntiNatureDamPer, critDamPercent, realHurt,
           defense, defPercent, ignoreDefense, decreaseDefPercent, magicDefense, magicDefPercent, ignoreMagicDefense, decreaseMagicDefPercent,
           perfectDodge,dodge,critRate);
        return str;
    }
}

public class SkillHitFighterInfo
{
	public Fighter Caster { get; private set; }     //施法者

	public Fighter Target { get; private set; }     //目标

	public SkillActionAttackInfo AttackInfo { get; private set; }

	public Bullet HitBullet { get; private set; }

	public SFloat Damage { get; set; }      //自身+元素 总伤害

    public SFloat BaseDamge { get; set; }   //自身总伤害

    public SFloat NatureDamge { get; set; } //元素总伤害

    public SFloat ReflectDamage { get; set; }

    //护盾吸收
	public SFloat Absorb { get;  set; }

    public SFloat Attack { get; set; }

    //吸收治疗
    public SFloat SuckDamge { get; set; }

    //暴击
	public bool IsCrit { get; private set; }

    //闪避
	public bool IsDodge { get; private set; }

    //完美闪避
    public bool IsPerfectDodge { get; private set; }

    //免疫
	public bool IsImmunity { get; private set; }

	public bool HitflyCheckFlag { get; private set; }

	public bool HitBreakCheckFlag { get; private set; }

	public BaseSkill Skill { get; private set; }

	public SkillData SkillDataInfo { get; private set; }

	public bool IsDamage { get; private set; }

	public bool IsKillEnemyHit { get; set; }

	public SkillActionFrameEvent FixHurtWordEvent { get; set; }

    private stDamageParam mHitParam;
    public stDamageParam HitParam
    {
        get { return mHitParam; }
    }

    private int mBuffId;
    public int BuffId
    {
        get { return mBuffId; }
    }

    public SkillHitFighterInfo (Fighter caster, 
                                Fighter target, 
                                int buffId,
                                SkillActionAttackInfo attackInfo, 
                                Bullet bullet = null)
	{
		Caster = caster;
		Target = target;
        mBuffId = buffId;
		AttackInfo = attackInfo;
		HitBullet = bullet;
		Skill = attackInfo.skill;
        if(Skill!=null)
		    SkillDataInfo = Skill.SkillDataInfo;
		Damage = 0;
        BaseDamge = 0;
        NatureDamge = 0;
        ReflectDamage = 0;
        Absorb = 0;
        SuckDamge = 0;
        IsCrit = false;
		IsDodge = false;
		IsImmunity = false;
		HitflyCheckFlag = true;
		HitBreakCheckFlag = true;
		IsKillEnemyHit = false;

        if (Target != null)
        {
            mHitParam.targetId = target.Id;
            mHitParam.targetBaseId = target.Actor.BaseId;
            mHitParam.targetTeamSide = (int)target.TeamSide;
        }
    }

	public SInt CalculateDamage (Damage_Type damageType,int hitType)
	{
        mHitParam.Reset();

        //无敌状态
        if (Target.StateData.IsInvincible)
        {
            return 0;
        }

        string skillName = this.Skill != null ? this.Skill.SkillName : "";
               
        SFloat fNatureAddPercent = 0;
        StrategyMgr.Instance.GetAllAntiVals(Caster, Target, out fNatureAddPercent);        
       
        if (!Target.FuncMgr.HaveIgoreDodgeFunction())
        {
            if((hitType & (int)BuffHitType.Perfect_Dodge) == (int)BuffHitType.Perfect_Dodge)
            {
                PerfectDodge();
                mHitParam.IsPerfectDodge = IsPerfectDodge;

                if (IsPerfectDodge)
                {
                    mHitParam.damage = 0;
                    return 0;
                }
            }
        
            
            if((hitType & (int)BuffHitType.Dodge) == (int)BuffHitType.Dodge)
            {
                RandomDodge();
                mHitParam.IsDodge = IsDodge;

                if (IsDodge)
                {
                    mHitParam.damage = 0;
                    return 0;
                }
            }
        }

        if((hitType & (int)BuffHitType.Critical) == ((int)BuffHitType.Critical))
            RandomCrit();

        mHitParam.IsCrit = IsCrit;
        mHitParam.realHurt = 0;
        mHitParam.critDamPercent = Caster.CritDamagePercent;

        Caster.HitTarget = Target;

        //神威
        SFloat p = BattleFormulaParamMgr.Instance.GetParam(37);
        SFloat GodPwerPercent = Caster.GetAttrByType(ActorData.Attr_GodPow) - Target.GetAttrByType(ActorData.Attr_GodPow);
        GodPwerPercent = Mathf.Max((1 + GodPwerPercent / (10 + Mathf.Abs(GodPwerPercent) *p) * 0.01f),0.01f);

        //统一计算               
        Attack = Caster.Attack * Caster.GetBuffPercentValue(Buff_Function_Type.Phyx_Damage_Change_Percent) +
            Caster.MagicAttack * Caster.GetBuffPercentValue(Buff_Function_Type.Magic_Damage_Change_Percent) + 
            Caster.GetBuffFunctionValue(Buff_Function_Type.Fixed_Damage_Change_Value);        
        if (Caster.FuncMgr.TickEventList != null)
        {
            for (int idx = Caster.FuncMgr.TickEventList.Count - 1; idx >= 0; idx--)
            {
                var ev = Caster.FuncMgr.TickEventList[idx];
                if (ev.Type == Buff_Function_Type.Add_Hurt_From_Caster_Attr)
                {
                    Attack += Caster.GetAttrByType(ev.Data.fromAttr) * ev.Data.value * 0.01f;
                }
                 if (ev.Type == Buff_Function_Type.Add_Hurt_From_Target_Attr)
                {
                    if (Target != null)
                    {
                        Attack += Target.GetAttrByType(ev.Data.fromAttr) * ev.Data.value * 0.01f;
                    }
                }

                if (ev.Type == Buff_Function_Type.Target_Hurt_FixVal_ByTargetCostHp)
                {
                    if (Target != null)
                    {
                        Attack += (int)(ev.Data.value * 0.01f * (Target.MaxLife - Target.Life));
                    }                        
                }
                if (ev.Type == Buff_Function_Type.Target_Hurt_FixVal_BySourceCostHp)
                {
                    if (Target != null)
                    {
                        Attack += (int)(ev.Data.value * 0.01f * (Caster.MaxLife - Caster.Life));                        
                    }
                }
                if (ev.Type == Buff_Function_Type.Target_Hurt_FixVal_BySourceTargetAttrDiff)
                {
                    if (Target != null)
                    {
                        Attack += (int)Mathf.Max((Caster.GetAttrByType(ev.Data.fromAttr) - Target.GetAttrByType(ev.Data.fromAttr)) * ev.Data.value * 0.01f,0.0f);
                    }
                }
            }
        }
        Attack *= (1 + Caster.GetBuffPercentValue(Buff_Function_Type.Damage_Change_Percent));

        if (IsCrit)
        {    
            SFloat a = BattleFormulaParamMgr.Instance.GetParam(23);
            if (damageType == Damage_Type.Attack_Type_Physic)
            {
                mHitParam.attack = Attack;
                mHitParam.physicDamPercent = Caster.PhysicDamagePercent;
                mHitParam.antiPhysicDamPercent = Target.AntiPhysicDamPercent;
                
                BaseDamge = (int)(mHitParam.attack * 
                    Mathf.Max((1 + mHitParam.physicDamPercent - mHitParam.antiPhysicDamPercent), 0.01f) *                   
                    (a + mHitParam.critDamPercent));

                BaseDamge *= GodPwerPercent;

                NatureDamge = (int)(BaseDamge * Mathf.Max(fNatureAddPercent, 0));
                Damage = BaseDamge + NatureDamge;
            }
            else if (damageType == Damage_Type.Attack_Type_Magic)
            {
                mHitParam.magicAttack = Attack;
                mHitParam.magicDamPercent = Caster.MagicDamagePercent;
                mHitParam.antiMagicDamPercent = Target.AntiMagicDamPercent;

                BaseDamge = (int)(mHitParam.magicAttack * 
                    Mathf.Max((1 + mHitParam.magicDamPercent - mHitParam.antiMagicDamPercent), 0.01f) *                     
                    (a + mHitParam.critDamPercent));

                BaseDamge *= GodPwerPercent;

                NatureDamge = (int)(BaseDamge * Mathf.Max(fNatureAddPercent, 0));
                Damage = BaseDamge + NatureDamge;
            }
            else
            {
                BaseDamge = Attack;
                NatureDamge = 0;
                Damage = Attack;
            }
            EventMgr.DispatchEvent<Fighter,BaseSkill>(new CoreEvent<Fighter, BaseSkill>(ECoreEventType.EID_Fighter_Damage_WithCrit, Caster,Skill));
        }
        else
        {
            if (damageType == Damage_Type.Attack_Type_Physic)
            {
                SFloat a = BattleFormulaParamMgr.Instance.GetParam(19);
                SFloat b = BattleFormulaParamMgr.Instance.GetParam(20);

                SFloat def = Target.Defense * (1 + Target.DefPercent - Caster.IgnoreDefense);
                if (def < 0)
                    def = 0;

                SFloat decreaseDefPercent = ((9 * def) / (a + def * b));


                mHitParam.attack = Attack;
                mHitParam.defense = def;
                mHitParam.decreaseDefPercent = decreaseDefPercent;
                mHitParam.physicDamPercent = Caster.PhysicDamagePercent;
                mHitParam.antiPhysicDamPercent = Target.AntiPhysicDamPercent;

                BaseDamge = (int)(Mathf.Max((mHitParam.attack - mHitParam.defense),1) * (1 - mHitParam.decreaseDefPercent) * 
                Mathf.Max(1+ mHitParam.physicDamPercent - mHitParam.antiPhysicDamPercent, 0.01f));

                BaseDamge *= GodPwerPercent;

                NatureDamge = (int)(BaseDamge * Mathf.Max(fNatureAddPercent, 0));
                Damage = BaseDamge + NatureDamge;
            }
            else if (damageType == Damage_Type.Attack_Type_Magic)
            {
                //Debug.Log("damage Type = Magic");
                SFloat a = BattleFormulaParamMgr.Instance.GetParam(21);
                SFloat b = BattleFormulaParamMgr.Instance.GetParam(22);

                SFloat def = Target.MagicDefense * (1 + Target.MagicDefPercent - Caster.IgnoreMagicDefense);
                if (def < 0)
                    def = 0;

                SFloat decreaseMagicDefPercent = ((9 * def) / (a + def * b));

                mHitParam.magicAttack = Attack;
                mHitParam.magicDefense = def;
                mHitParam.decreaseMagicDefPercent = decreaseMagicDefPercent;
                mHitParam.magicDamPercent = Caster.MagicDamagePercent;
                mHitParam.antiMagicDamPercent = Target.AntiMagicDamPercent;

                BaseDamge = (int)(Mathf.Max((mHitParam.magicAttack - mHitParam.magicDefense), 1) *
                    (1 - mHitParam.decreaseMagicDefPercent) * Mathf.Max(1 + mHitParam.magicDamPercent - mHitParam.antiMagicDamPercent, 0.01f));

                BaseDamge *= GodPwerPercent;

                NatureDamge = (int)(BaseDamge * Mathf.Max(fNatureAddPercent, 0));

                Damage = BaseDamge + NatureDamge;
            }
            else
            {
                BaseDamge = Attack;
                NatureDamge = 0;
                Damage = Attack;
            }
        }
           

        //吸收
        SFloat SuckPrecent;
        int nMaxSuck;
        bool bIsSuckDamage = Target.IsSuckDamage(damageType, out SuckPrecent, out nMaxSuck);
        if(bIsSuckDamage)
        {
            nMaxSuck = (int)(nMaxSuck * 0.01f * Target.MaxLife);
            SuckDamge = SuckPrecent * 0.01f * Damage;
            SuckDamge = Mathf.Min(nMaxSuck,(int)SuckDamge);

            if(SuckDamge < 1)
            {
                SuckDamge = 1;               
            }
        }

        //反弹
        if (damageType == Damage_Type.Attack_Type_Physic)
            ReflectDamage = Damage * Target.PhysicDamageReflectPercent;
        else
            ReflectDamage = Damage * Target.MagicDamageReflectPercent;

        if (BattleMgr.Instance.Battle.CanPrintLog)
            DebugHelper.LogError("------fighter:" + Caster.Id + " skillName: " + skillName + mHitParam.ToString());

        Caster.HitTarget = null;

        if (Damage < 1)
        {
            Damage = 1;
            BaseDamge = Damage;
        }
        else
        {
            Damage = Mathf.Round(Damage);
        }   
        
        IsKillEnemyHit = Target.Life <= Damage && !Target.IsUndead;
        mHitParam.damage = (int)Damage;
       
        return (int)Damage;
	}

    public void SetRealDamage(int damage)
    {
        mHitParam.realDamage = damage;
    }

    //完美闪避
    void PerfectDodge()
    {
        SFloat randomValue = Caster.Battle.RandomValue(true);
        IsPerfectDodge = randomValue < Target.PerfectDodgeRate;

        //if (BattleMgr.Instance.Battle.IsPlayRecord || BattleMgr.Instance.Battle.IsKillingBoss)
        //    DebugHelper.LogError(Caster.Id + "----------------target:" + Target.Name + " PerfectDodgeRate:" + Target.PerfectDodgeRate + " frameCnt:" + Time.frameCount);
    }

    //普通闪避
	void RandomDodge ()
	{
        SFloat Hit = Caster.GetBuffFunctionValue(Buff_Function_Type.Change_Hit_Value);
        SFloat Doge = Target.GetBuffFunctionValue(Buff_Function_Type.Change_Doge_Value);
        SFloat FunPrecent = Doge - Hit;

        SFloat a = BattleFormulaParamMgr.Instance.GetParam(16);
        SFloat p1 = Mathf.Max(25 + Target.Dodge - Caster.Hit, 0) / (5 + Mathf.Max((Target.Dodge - Caster.Hit) * a, 0));
        SFloat p2 = Mathf.Max(p1 + FunPrecent, 0);
        SFloat percent = Mathf.Min(p2, 95) * 0.01f ;
        SFloat dodgeRate =Mathf.Max(percent, 0);

        SFloat randomValue = Caster.Battle.RandomValue(true);
        IsDodge = randomValue < dodgeRate;

        //if (BattleMgr.Instance.Battle.IsPlayRecord || BattleMgr.Instance.Battle.IsKillingBoss)
        //    DebugHelper.LogError(Caster.Id + "----------------target:" + Target.Name + " RandomDodge:" + dodgeRate);
    }

    //暴击伤害判断
	void RandomCrit ()
	{
        SFloat Crit = Caster.GetBuffFunctionValue(Buff_Function_Type.Change_Crit_Value);
        SFloat Ten = Target.GetBuffFunctionValue(Buff_Function_Type.Change_Ten_Value);
        SFloat FunPrecent = Crit - Ten;        

        SFloat a = BattleFormulaParamMgr.Instance.GetParam(17);
        SFloat b = BattleFormulaParamMgr.Instance.GetParam(18);

        SFloat p1 = (1 + Mathf.Max((Caster.Crit - Target.Ten), 0) / (a + Mathf.Max((Caster.Crit - Target.Ten), 0) * b));
        SFloat p2 = Mathf.Max(p1 + FunPrecent, 0);
        SFloat critRate = Mathf.Min(p2 * 0.01f, 1);
        SFloat randomValue = Caster.Battle.RandomValue(true);
        IsCrit = randomValue < critRate;

        //if (BattleMgr.Instance.Battle.IsPlayRecord || BattleMgr.Instance.Battle.IsKillingBoss)
        //    DebugHelper.LogError("----------------fighter:" + Caster.Id + " Target:" + Target.Name + " critRate:" + critRate);
    }
}

