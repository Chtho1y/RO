using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public enum BattleBuffType
{
    None = 0,
    Hurt = 1,           //伤害
    Enhance = 2,        //增益
    Negative = 3,       //减益
    Special = 4,        //特殊
    Heal = 5,           //治疗
    SpecialNegative = 6,    //特殊减益
}

public enum BuffHitType
{
    Perfect_Dodge = 1,      //可完美闪避 
    Dodge = 2,              //可普通闪避
    Resist = 4,             //可抵抗
    Critical = 8,           //可暴击
}

public enum Buff_Function_Type
{
    Body_Size_Change_Value = 1,            //  体型变大/体型变小
    Phyx_Damage_Change_Percent = 2,        //  物理伤害加成/减免百分比
    Magic_Damage_Change_Percent = 3,       //  魔法伤害加成/减免百分比 
    Fixed_Damage_Change_Value = 4,         //  固定伤害数值

    STR_Change_Percent = 10,                       //   降低/提升一定比例的STR
    STR_Change_Value = 11,                         //   降低/提升一定数值的STR
    INT_Change_Percent = 12,                       //   降低/提升一定比例的INT
    INT_Change_Value = 13,                         //   降低/提升一定数值的INT
    AGI_Change_Percent = 14,                       //   降低/提升一定比例的AGI
    AGI_Change_Value = 15,                         //   降低/提升一定数值的AGI
    Change_MaxHP_Percent = 16,                        //   降低/提升一定比例的HP
    Change_MaxHP_Value = 17,                          //   降低/提升一定数值的HP
    SP_Change_Percent = 18,                        //   造成以target来源属性为比例的回蓝
    SP_Change_Value = 19,                          //   降低/提升一定数值的SP
    Phyx_Defense_Change_Percent = 20,              //   降低/提升一定比例的物防
    Phyx_Defense_Change_Value = 21,                //   降低/提升一定数值的物防
    Magic_Defense_Change_Percent = 22,             //   降低/提升一定比例的魔防
    Magic_Defense_Change_Value = 23,               //   降低/提升一定数值的魔防
    Invincible  = 24,                              //   无敌
    Immunity    = 25,                              //   免疫
    Vertigo   = 26,                              //   眩晕
    Silence     = 27,                              //   沉默
    Forget      = 28,                              //   遗忘
    Confusion   = 29,                              //   混乱
    Fear        = 30,                              //   恐惧
    Frozen      = 31,                              //   冰冻
    Heal_Change_Percent = 32,                      //   治疗增幅/降幅百分比
    Sleep       = 33,                              //   睡眠
    Stiff = 34,                             //   石化
    Curse        = 35,                             //   诅咒
    Poison       = 36,                            //    中毒
    Break        = 37,                              //  打断
    Forbid_NormalSkill = 38,                        //  禁止普攻
    Clean       = 39,                               //  净化
    Disperse    = 40,                               //  驱散
    Sneer       = 41,                               //  嘲讽
    Heal_Target_HP_Change_Percent = 42,             //  治疗目标一定比例的HP
    Heal_Target_HP_Change_Value = 43,               //  治疗目标一定数值的HP
    Summon_Monster  = 44,                               // 召唤一定数量的怪物
    Shield_AbsortAttack_Change_Percent = 45,             // 一个数值为DEF%的吸收伤害护盾
    ChangeHP_FromAttr_Percent = 46,                     //给目标加一个以来源数值为比例的治疗buff
    Shield_AbsortAttack_Fixed_Change_Value = 47,        // 一个固定值吸收伤害的护盾
    LUK_Change_Value = 48,                              // 降低/提升固定值的LUK
    LUK_Change_Percent = 49,                            // 降低/提升 一定比例的LUK
    AttackCD_Change_Percent = 50,                       // 降低/提升 一定比例的攻击间隔
    AttackCD_Change_Value = 51,                         // 降低/提升 固定值的间隔
    Ten_Change_Percent = 52,                            // 降低/提升 一定比例的韧性
    Ten_Change_Value = 53,                              // 降低/提升 固定值的韧性
    Crit_Change_Percent = 54,                           // 降低/提升 暴击率百分比
    Crit_Change_Value = 55,                             // 降低/提升 固定值的暴击率
    RageStatus = 56,                                    // 狂暴状态
    Damage_Change_Percent = 57,                         // 伤害百分比
    ChangeSkill = 58,                                   // 替换技能
    Attack_Change_Percent = 59,                         // 提升/降低 一定比例的物理攻击百分比
    Attack_Change_Value = 60,                           // 提升/降低 一定数值的物理攻击力
    MagicAttack_Change_Percent = 61,                    // 提升/降低 一定比例的魔防攻击百分比
    MagicAttack_Change_Value = 62,                      // 提升/降低 一定数值的魔防攻击力
    ChangeSkillSpeed = 63,                              // 加速/减速技能效果
    Change_FromNature__Damage_Percent = 64,             // 提升/降低 一定比例源于对应属性的伤害
    Change_ToNature_Damage_Percent = 65,                // 提升/降低 一定比例面向对应属性的伤害
    AttackSpeed_Change_Percent = 66,                    // 提升/降低 一定比例的攻速百分比
    Add_Function_Point_Value = 67,                      // 获得效果点数值
    Deduct_Function_Point_Value = 68,                   // 扣除点数额外加成
    ChangeBuff_Using_Function_Point = 69,               // 拥有点数额外加成
    Hit_Change_Percent = 70,                            // 降低/提升一定比例的命中
    Hit_Change_Value = 71,                              // 降低/提升一定数值的命中
    Dodge_Change_Percent = 72,                          // 降低/提升一定比例的闪避
    Dodge_Change_Value = 73,                            // 降低/提升一定数值的闪避

    Add_Hurt_From_Caster_Attr = 74,                     // 造成以自身来源属性为比例的伤害
    Add_Hurt_From_Target_Attr = 75,                     // 造成以目标来源属性为比例的伤害
    IgnorePhysicDefense_Change_Value = 76,              // 提升/降低一定数值的忽视物防
    IgnoreMagicDefense_Change_Value = 77,               // 提升/降低一定数值的忽视魔防
    Add_Duration_Hurt = 78,                             // 造成固定值的持续伤害
    PhysicDamagePercent_Change_Value = 79,              // 提升一定数值的物伤加成百分比
    MagicDamagePercent_Change_Value = 80,               // 提升一定数值的魔法伤害加成百分比
    CritDamagePercent_Change_Value = 81,                // 提升/降低一定数值的暴击伤害百分比
    PhysicDamageReflectPercent_Change_Value = 82,       // 提升/降低一定数值的物理伤害反射百分比
    MagicDamageReflectPercent_Change_Value = 83,        // 提升/降低一定数值的魔法伤害反射百分比
    AntiPhysicDamagePercent_Change_Value = 84,          // 提升/降低一定数值的抗物伤加成百分比
    AntiMagicDamagePercent_Change_Value = 85,           // 提升/降低一定数值的抗魔伤加成百分比

    Hurt_Change_Value_From_Caster_STR = 86,             // 造成以自身的力量为比例的持续伤害
    Hurt_Change_Value_From_Caster_AGI = 87,             // 造成以自身的敏捷为比例的持续伤害
    Hurt_Change_Value_From_Caster_INT = 88,             // 造成以自身的智力为比例的持续伤害
    Hurt_Change_Value_From_Caster_VIT = 89,             // 造成以自身的体质为比例的持续伤害
    Hurt_Change_Value_From_Caster_DEX = 90,             // 造成以自身的灵巧为比例的持续伤害
    Hurt_Change_Value_From_Caster_LUK = 91,             // 造成以自身的幸运为比例的持续伤害
    Hurt_Change_Value_From_Caster_HP = 92,              // 造成以自身的生命为比例的持续伤害
    Hurt_Change_Value_From_Caster_SP = 93,              // 造成以自身的蓝量为比例的持续伤害
    Hurt_Change_Value_From_Caster_Attack = 94,          // 造成以自身的物攻为比例的持续伤害
    Hurt_Change_Value_From_Caster_MagicAttack = 95,     // 造成以自身的魔攻为比例的持续伤害
    Hurt_Change_Value_From_Caster_Defense = 96,         // 造成以自身的物防为比例的持续伤害
    Hurt_Change_Value_From_Caster_MagicDefense = 97,    // 造成以自身的魔防为比例的持续伤害
    Hurt_Change_Value_From_Caster_Hit = 98,             // 造成以自身的命中为比例的持续伤害
    Hurt_Change_Value_From_Caster_Dodge = 99,           // 造成以自身的闪避为比例的持续伤害
    Hurt_Change_Value_From_Caster_Crit = 100,           // 造成以自身的暴击为比例的持续伤害
    Hurt_Change_Value_From_Caster_Ten = 101,            // 造成以自身的韧性为比例的持续伤害
    Hurt_Change_Value_From_Caster_AttackSpeed = 102,    //造成以自身的攻击速度为比例的持续伤害
    Hurt_Change_Value_From_Caster_MaxHp = 103,          // 造成以自身的最大血量为比例的持续伤害
    Hurt_Change_Value_From_Caster_MaxSP = 104,          // 造成以自身的最大蓝量为比例的持续伤害
    Shield_AbsortAttack_Change_Percent_From_Caster = 105,  //以caster属性来源为比例的护盾
    Heal_Change_Percent_From_Caster = 106,                 //以caster属性来源为比例的治疗
    Heal_Change_Percent_From_Target = 107,                  //以自身属性来源为比例的治疗

    Add_SP_From_Caster = 109,                               //造成以caster来源属性为比例的回蓝
    Hurt_Change_Value_From_Target_HP = 110,                 // 造成以目标的当前生命为比例的持续伤害
    Hurt_Change_Value_From_Target_MaxHP = 111,              // 造成以目标的当前生命为比例的持续伤害
    PassiveSkill_Trigger = 112,                             // 被动技能触发效果
    
    Nature_None_Change_Value = 113,
    Nature_Water_Change_Value = 114,
    Nature_Ground_Change_Value = 115,
    Nature_Fire_Change_Value = 116,
    Nature_Wind_Change_Value = 117,
    Nature_Saint_Change_Value = 118,
    Nature_Dark_Change_Value = 119,
    Nature_Read_Change_Value = 120,

    AntiNature_None_Change_Value = 121,
    AntiNature_Water_Change_Value = 122,
    AntiNature_Ground_Change_Value = 123,
    AntiNature_Fire_Change_Value = 124,
    AntiNature_Wind_Change_Value = 125,
    AntiNature_Saint_Change_Value = 126,
    AntiNature_Dark_Change_Value = 127,
    AntiNature_Read_Change_Value = 128,

    ChangeHP_From_CasterAttr_Percent = 129,                     //给caster加一个以来源数值为比例的治疗buff

    //---------------------------------------------new
    Hurt_Targert_SuckBlood = 130,                                       //回复自身造成目标伤害的比例
    Attack_Change_ByTargetAttr = 131,                                   //根据目标属性 提升降低目标物理攻击
    MagicAttack_Change_ByTargetAttr = 132,                              //根据目标属性 提升降低目标魔法攻击
    AttackDefense_Change_ByTargetAttr = 133,                            //根据目标属性 提升降低目标物理防御
    MagicDefense_Change_ByTargetAttr = 134,                             //根据目标属性 提升降低目标魔法防御

    Attack_Change_BySourceAttr = 135,                                   //根据施法者属性 提升降低目标物理攻击
    MagicAttack_Change_BySourceAttr = 136,                              //根据施法者属性 提升降低目标魔法攻击
    AttackDefense_Change_BySourceAttr = 137,                            //根据施法者属性 提升降低目标物理防御
    MagicDefense_Change_BySourceAttr = 138,                             //根据施法者属性 提升降低目标魔法防御

    Attack_Change_ByTargetCostHpPercent = 139,                          //根据目标损失血量比例 增加自身攻击
    MagicAttack_Change_ByTargetCostHpPercent = 140,                     //根据目标损失血量比例 增加自身攻击
    Attack_Change_BySourceCostHpPercent = 141,                          //根据施法者损失血量比例 增加自身攻击
    MagicAttack_Change_BySourceCostHpPercent = 142,                     //根据施法者损失血量比例 增加自身攻击

    Attack_Change_ByTargetCurHpPercent = 143,                           //根据目标血量比例 增加自身攻击
    MagicAttack_Change_ByTargetCurHpPercent = 144,                      //根据目标血量比例 增加自身攻击
    Attack_Change_BySourceCurHpPercent = 145,                           //根据施法者血量比例 增加自身攻击
    MagicAttack_Change_BySourceCurHpPercent = 146,                      //根据施法者血量比例 增加自身攻击

    Reflect_Hurt_ByTargetAttr = 150,                                    //反弹自身受到傷害给 源伤害 更具目標屬性比例
    Reflect_Hurt_BySourceAttr = 151,                                    //反弹自身受到傷害给 源伤害 更具施法者屬性比例
    Reflect_Fix_Hurt = 152,                                             //自身受到伤害，反弹固定伤害

    Hurt_Attack_SuckDamage = 153,                                       //受到物理伤害吸收护盾
    Hurt_MagicAttack_SuckDamage = 154,                                  //受到魔法伤害吸收护盾

    Change_Hit_Value = 155,                                             //增加 降低 命中
    Change_Doge_Value = 156,                                            //增加 降低 闪避
    Change_Crit_Value = 157,                                            //增加 降低 暴击
    Change_Ten_Value = 158,                                             //增加 降低 抗暴

    //tick
    Target_Hurt_FixVal_ByTargetCostHp = 147,                            //根据目标损失血量 造成目标伤害
    Target_Hurt_FixVal_BySourceCostHp = 148,                            //根据施法者损失血量 造成目标伤害
    Target_Hurt_FixVal_BySourceTargetAttrDiff = 149,                    //根据目标与施法者属性差的比例伤害 造成目标伤害
    //----------------------------------------------------------------------

    Bullet_BeHurt_Change_Percent = 1000,                  // 子弹 伤害百分比
    Bullet_BeHurt_Change_Value = 10001,                    // 子弹 伤害数值
}

/// <summary>
/// 概率触发buff结构
/// </summary>
public class TriggerBuffData
{
    private int mBuffId;
    private float mTriggerRatio;
    private BuffTriggerType mTriggerType;
    private BuffTriggerCasterType mCasterType;

    private float mCD;
    private float mLastTriggerTime = 0;

    private int mCDFrame = 0;
    private int mBuffLevel = 1;
    
    //RunParam
    private int mLastTriggerFrame = 0;
    private int mTriggeredNum = 0;
    private Fix64 mTriggerFrame = Fix64.Zero;
    private Fix64 mCurFrame = Fix64.Zero;

    public int BuffLevel
    {
        get { return mBuffLevel; }
        set { mBuffLevel = value; }
    }

    public int BuffId
    {
        get { return mBuffId; }
    }

    public float TriggerRatio
    {
        get { return mTriggerRatio; }
    }

    public float CD
    {
        get { return mCD; }
    }

    public BuffTriggerType TriggerType
    {
        get { return mTriggerType; }
    }

    public BuffTriggerCasterType CasterType
    {
        get { return mCasterType; }
    }

    public float LastTriggerTime
    {
        get { return mLastTriggerTime; }
        set { mLastTriggerTime = value; }
    }

    public int LastTriggerFrame
    {
        get { return mLastTriggerFrame; }
    }

    private int mCheckVal;
    public int CheckVal
    {
        get { return mCheckVal; }
        set { mCheckVal = value; }
    }

    private string mFunParamStr;
    public string FunParamStr
    {
        get { return mFunParamStr; }
    }

    private int mExtendParam = 0;
    public TriggerBuffData(int id,float ratio,float cd,BuffTriggerType type, BuffTriggerCasterType casterType,string extendParam,string funParam = null)
    {
        mBuffId = id;
        mTriggerRatio = ratio;
        mCD = cd;
        mTriggerType = type;
        mCasterType = casterType;
        mCDFrame =(int) (mCD * Constants.frame_to_time);
        mFunParamStr = funParam;
        if (!string.IsNullOrEmpty(extendParam))
        {
            int.TryParse(extendParam, out mExtendParam);
            if(type == BuffTriggerType.Trigger_FixedTime)
            {
                mTriggerFrame = (Fix64)mExtendParam * (Fix64)Constants.frame_to_time;               
            }
        }
    }

    public bool CanTrigger(int frame)
    {        
        if(mLastTriggerFrame != 0)
        if (frame - mLastTriggerFrame < mCDFrame) return false;
        return CanExcut();
    }

    public bool CanExcut()
    {
        float randomValue = BattleMgr.Instance.Battle.RandomValue(true);
        return randomValue < mTriggerRatio;
    }

    public bool CanCheckCondition(Fighter fighter)
    {
        if(TriggerType == BuffTriggerType.Trigger_Negative_Fun)
        {
            return fighter.NegativeBuffCnt >= mExtendParam;
        }
        else if(TriggerType == BuffTriggerType.Trigger_HP_Lower)
        {
            bool IsTrigger = (SDouble)fighter.Life / fighter.MaxLife * 100 < mExtendParam;
            return IsTrigger;
        }else if(TriggerType == BuffTriggerType.Trigger_Accumulative_TakeDamage)
        {
            return fighter.TotalTakeDamage >= mExtendParam && mLastTriggerFrame == 0;  //只能执行一次
        }else if(TriggerType == BuffTriggerType.Trigger_Multi_Accumulative_TakeDamage)
        {
            return fighter.TotalTakeDamage >= (mExtendParam * (mTriggeredNum +1));  
        }
        else if (TriggerType == BuffTriggerType.Trigger_Multi_Accumulative_TakeDamage_Precent)
        {
            int nMaxSetpHp = (int)(fighter.MaxLife * mExtendParam * 0.01f);
            return fighter.TotalTakeDamage >= (nMaxSetpHp * (mTriggeredNum + 1));
        }
        else if (TriggerType == BuffTriggerType.Trigger_Accumulative_TakeDamage_Precent)
        {
            int nMaxSetpHp = (int)(fighter.MaxLife * mExtendParam * 0.01f);
            return fighter.TotalTakeDamage >= nMaxSetpHp && mLastTriggerFrame == 0;  //只能执行一次
        }
        return true;
    }

    public void DoTrigger(Fighter pFighter, int curFrame)
    {
        pFighter.CastBuff(null, BuffId, BuffLevel);
        mLastTriggerFrame = curFrame;
        mTriggeredNum++;
    }

    public void DoUpdateTrigger(Fighter pFighter, int curFrame)
    {
        if (TriggerType == BuffTriggerType.Trigger_FixedTime)
        {
            if(mCurFrame == mTriggerFrame)
            {
                if(CanExcut())
                    DoTrigger(pFighter, curFrame);
                mCurFrame = Fix64.Zero;
                return;
            }            
            mCurFrame += 1;
        }        
    }

    public void ResetData()
    {
        mCurFrame = Fix64.Zero;
        mLastTriggerFrame = 0;
        mTriggeredNum = 0;
    }
}

public class BuffFunctionData
{
    public int id;
    public BattleBuffType buffType;
    public Buff_Function_Type functionType;
    public bool canHurtStop;            //是否可以伤害打断
    public bool forbidMove;             //是否影响动作
    public bool forbidNormalAttack;     //禁止普攻
    public bool forbidSkill;            //禁止技能释放
    public bool canIgnoreDodge;         //是否可以闪避

    public float intervalTime;      //间隔时长
    public int[] fromAttr;            //来源属性
    public string icon;                //图标
    public int effectId;            //特效id
    public int endeffectId;         //结束特效id
    public string word;             //文字
    public string extendParam;

    private int mTargetType = 0;        //作用目标类型: 1 施法者， 2 目标
    public int TargetType
    {
        get { return mTargetType; }
        set { mTargetType = value; }
    }

    private int mGroup = 0;
    public int Group
    {
        get { return mGroup; }
    }

    private float mVal;
    private float mDuration;
    private float mIncVal;
    private float mIncDur;

    private int mSkillLv = 1;


    public int SkillLv
    {
        get { return mSkillLv; }
    }

    //是否为瞬发效果
    public bool IsInstantFunc
    {
        get { return duration <= 0; }
    }

    public float IncVal
    {
        get { return mIncVal; }
    }

    public float value
    {
        get
        {
            return mVal + (mSkillLv - 1) * mIncVal;
        }
    }

    public float duration
    {
        get
        {
            return mDuration + (mSkillLv - 1) * mIncDur;
        }
    }

    public float BaseValue
    {
        get { return mVal; }
    }

    public float BaseDuration
    {
        get { return mDuration; }
    }

    public BuffFunctionData(int id, float val, float incVal, float duration, float incDur, int[] fromAttr, float intervalTime,string extendParam)
    {
        Dictionary<string, string> dic = ConfigMgr.Instance.getLine(id, Config.FunctionCfgName);
        if (dic == null) return;

        this.id = id;
        this.mVal = val;
        this.mIncVal = incVal;

        this.mDuration = duration;
        this.mIncDur = incDur;

        this.fromAttr = fromAttr;
        this.intervalTime = intervalTime;
        this.extendParam = extendParam;
        int temp;
        if (dic.ContainsKey("FunctionType"))
        {
            int.TryParse(dic["FunctionType"], out temp);
            functionType = (Buff_Function_Type)temp;
        }

        if(dic.ContainsKey("BuffType"))
        {
            int.TryParse(dic["BuffType"], out temp);
            this.buffType = (BattleBuffType)temp;
        }

        if(dic.ContainsKey("HurtStop"))
        {
            int.TryParse(dic["HurtStop"], out temp);
            this.canHurtStop = temp > 0;
        }

        if(dic.ContainsKey("ForbidMove"))
        {
            int.TryParse(dic["ForbidMove"], out temp);
            this.forbidMove = temp > 0;
        }

        if(dic.ContainsKey("ForbidAttack"))
        {
            int.TryParse(dic["ForbidAttack"], out temp);
            this.forbidNormalAttack = temp > 0;
        }

        if(dic.ContainsKey("ForbidSkill"))
        {
            int.TryParse(dic["ForbidSkill"], out temp);
            this.forbidSkill = temp > 0;
        }

        if(dic.ContainsKey("Dodge"))
        {
            int.TryParse(dic["Dodge"], out temp);
            this.canIgnoreDodge = temp > 0;
        }

        if(dic.ContainsKey("Icon"))
        {
            icon = dic["Icon"];
        }

        if(dic.ContainsKey("Effect"))
        {
            int.TryParse(dic["Effect"], out effectId);
        }

        if (dic.ContainsKey("EndEffect"))
        {
            int.TryParse(dic["EndEffect"], out endeffectId);
        }

        if (dic.ContainsKey("Word"))
        {
            word = dic["Word"];
        }

        if(dic.ContainsKey("Group"))
        {
            int.TryParse(dic["Group"], out mGroup);
        }
    }

    public void SetLevel(int skillLevel)
    {
        mSkillLv = skillLevel;
    }

    public void Dispose()
    {

    }
}

public class TriggerMarkParam
{
    public int markId;
    public int markVal;
    public int markTargetType;

    public TriggerMarkParam(int id, int val, int targetType)
    {
        this.markId = id;
        this.markVal = val;
        this.markTargetType = targetType;
    }
}

public struct TargetFilterRule
{
    public FilterTeamType teamType;
    public FilterActorType actorType;
    public FilterParamType paramType;
    public int paramVal;
    public int extendParam1;
    public int extendParam2;

    public TargetFilterRule(int teamType,int actorType, int paramType,int paramVal,int extendParam1,int extendParam2)
    {
        this.teamType = (FilterTeamType)teamType;
        this.actorType = (FilterActorType)actorType;
        this.paramType = (FilterParamType)paramType;
        this.paramVal = paramVal;
        this.extendParam1 = extendParam1;
        this.extendParam2 = extendParam2;
    }

    public TargetFilterRule(int  teamType,int actorType)
    {
        this.teamType = (FilterTeamType)teamType;
        this.actorType = (FilterActorType)actorType;
        this.paramType = FilterParamType.Param_Type_None;
        this.paramVal = 0;
        this.extendParam1 = 0;
        this.extendParam2 = 0;
    }

    public TargetFilterRule(int teamType,int actorType,int paramType,int paramVal)
    {
        this.teamType = (FilterTeamType)teamType;
        this.actorType = (FilterActorType)actorType;
        this.paramType = (FilterParamType)paramType;
        this.paramVal = paramVal;
        this.extendParam1 = 0;
        this.extendParam2 = 0;
    }
}

public class BuffData
{
    public int buffID;
    public string buffDescription;
    public string icon;
    public int totalFrame;
    public Target_Select_Rule funTargetType;
    public TargetFilterRule filterRule;
    public float rate;
    public int sortValue;
    public int hitType;
    public Damage_Type damageType;          //伤害类型
    public bool ignoreMultiHurt;        //是否忽略多段伤害
    public float multiHurtIntervalTime;
    public int multiHurtCnt;
    public string extendFunStr;
    public List<ValType> extendBuffs = null;
    public bool removeFunAfterStop = false;
    public int cloneBossId = 0;

    public TriggerMarkParam markData = null;
    public List<ValType> markExtendList = null;

    protected SkillActionFrameEvent[] mBuffActionFrameEvents;

    private List<BuffFunctionData> mBuffFunList = new List<BuffFunctionData>();

    public List<BuffFunctionData> BuffFunList
    {
        get { return mBuffFunList; }
    }

    public SkillActionFrameEvent[] ActionFrameEvents
    {
        get { return mBuffActionFrameEvents; }
    }

    public SkillActionFrameEvent SingFrameEvent = null;

    public BuffData(int id, int gender, ProfessionType jobType, int jobStage, int jobBranch)
    {
        Dictionary<string, string> dic = ConfigMgr.Instance.getLine(id, Config.BuffCfgName);
        if (dic == null)
        {
            DebugHelper.LogWarning(string.Format("{0} buff 在buff配表中不存在", id));
            mBuffActionFrameEvents = new SkillActionFrameEvent[0];
            return;
        }

        this.buffID = id;
        if(dic.ContainsKey("Desc"))
        {
            buffDescription = dic["Desc"];
        }

        if(dic.ContainsKey("Icon"))
        {
            icon = dic["Icon"];
        }

        int temp;
        if (dic.ContainsKey("TargetType"))
        {
            int.TryParse(dic["TargetType"], out temp);
            funTargetType = (Target_Select_Rule)temp;
        }

        if(dic.ContainsKey("FilterType"))
        {
            string filterTypeStr = dic["FilterType"];
            if(!string.IsNullOrEmpty(filterTypeStr))
            {
                int[] iVals = StringUtil.split2Int(filterTypeStr, ';');
                if(iVals.Length == 2)
                {
                    filterRule = new TargetFilterRule(iVals[0], iVals[1]);
                }else if(iVals.Length == 4)
                {
                    filterRule = new TargetFilterRule(iVals[0], iVals[1], iVals[2], iVals[3]);
                }else if(iVals.Length == 6)
                {
                    filterRule = new TargetFilterRule(iVals[0], iVals[1], iVals[2], iVals[4], iVals[5], iVals[6]);
                }
            }
        }

        if (dic.ContainsKey("HitType"))
        {
            int.TryParse(dic["HitType"], out hitType);
        }

        if (dic.ContainsKey("Effectiveness"))
        {
            float.TryParse(dic["Effectiveness"], out rate);
            rate = rate / 10000.0f;
        }

        if(dic.ContainsKey("DamageType"))
        {
            int.TryParse(dic["DamageType"], out temp);
            damageType = (Damage_Type)temp;
        }

        if(dic.ContainsKey("IgnoreMultiHurt"))
        {
            int.TryParse(dic["IgnoreMultiHurt"], out temp);
            ignoreMultiHurt = temp > 0;
        }

        if (dic.ContainsKey("Function"))
        {
            SetFunData(dic["Function"]);
        }

        if(dic.ContainsKey("ExtendFunction"))
        {
            extendFunStr = dic["ExtendFunction"];
        }

        if (dic.ContainsKey("RemoveFunWhenStop"))
        {
            int.TryParse(dic["RemoveFunWhenStop"], out temp);
            removeFunAfterStop = temp > 0;
        }

        if(!string.IsNullOrEmpty(extendFunStr))
        {
            extendBuffs = new List<ValType>();
            string[] extendFunList = StringUtil.split(extendFunStr, ';');
            for (int idx = 0; idx < extendFunList.Length; idx++)
            {
                int[] funVals = StringUtil.split2Int(extendFunList[idx], ':');
                if(funVals.Length >= 2)
                {
                    ValType valType = new ValType(funVals[1], funVals[0]);
                    extendBuffs.Add(valType);
                }
            }
        }

        if(dic.ContainsKey("Mark"))
        {
            var tempStr = dic["Mark"];
            if(!string.IsNullOrEmpty(tempStr))
            {
                string[] tempStrList = tempStr.Split(':');
                if(tempStrList.Length == 3)
                {
                    int markId, val, targetType;
                    int.TryParse(tempStrList[0], out markId);
                    int.TryParse(tempStrList[1], out val);
                    int.TryParse(tempStrList[2], out targetType);
                    if(markId > 0)
                        markData = new TriggerMarkParam(markId,val,targetType);
                }
            }
        }

        if(markData!=null)
        {
            if(dic.ContainsKey("MarkExtend"))
            {
                var tempStr = dic["MarkExtend"];
                if (!string.IsNullOrEmpty(tempStr))
                {
                    markExtendList = new List<ValType>();
                    string[] tempStrList = tempStr.Split(';');
                    for(int idx =0; idx < tempStrList.Length;idx++)
                    {
                        var str = tempStrList[idx];
                        string[] tempStrList2 = str.Split(':');
                        if(tempStrList2.Length == 2)
                        {
                            int layer = 0, buffId = 0;
                            int.TryParse(tempStrList2[0], out layer);
                            int.TryParse(tempStrList2[1], out buffId);
                            ValType val = new ValType(layer, buffId);
                            markExtendList.Add(val);
                        }
                    }
                }
            }
        }

        LoadEventsData(gender,(int)jobType,jobStage,jobBranch);
    }

    public void SetFunData(string funStr)
    {
        if (string.IsNullOrEmpty(funStr)) return;

        string[] funStrList = funStr.Split(';');
        mBuffFunList = new List<BuffFunctionData>(funStrList.Length);
        for (int idx = 0; idx < funStrList.Length; idx++)
        {
            string[] funTemp = funStrList[idx].Split(':');
            if (funTemp.Length < 2) continue;

            int funId = 0;
            float funVal = 0;
            float funIncVal = 0;

            float funDuration = 0;
            float funIncDuration = 0;

            int[] fromAttr = new int[1];
            fromAttr[0] = 0;
            float intervalTime = 0;

            int targetType = 0;
            string extendParam = null;

            if (funTemp.Length > 1)
            {
                float[] funValList = StringUtil.split2Float(funTemp[1], '_');
                if (funValList.Length > 0)
                    funVal = funValList[0];

                if (funValList.Length > 1)
                    funIncVal = funValList[1];
            }

            if (funTemp.Length > 2)
            {
                float[] funDurList = StringUtil.split2Float(funTemp[2], '_');
                if (funDurList.Length > 0)
                    funDuration = funDurList[0];

                if (funDurList.Length > 1)
                    funIncDuration = funDurList[1];
            }

            if (funTemp.Length > 3)
            {
                fromAttr = StringUtil.split2Int(funTemp[3], '_');              
            }

            if (funTemp.Length > 4)
            {
                float.TryParse(funTemp[4], out intervalTime);
            }

            if (funTemp.Length > 5)
            {
                int.TryParse(funTemp[5], out targetType);
            }

            if (funTemp.Length > 6)
            {
                extendParam = funTemp[6];
            }

            if (int.TryParse(funTemp[0], out funId))
            {
                BuffFunctionData fun = new BuffFunctionData(funId, funVal, funIncVal, funDuration, funIncDuration, fromAttr, intervalTime, extendParam);
                fun.TargetType = targetType;
                BuffFunList.Add(fun);
            }
        }
    }

    void LoadEventsData(int gender, int jobType, int jobStage, int jobBranch)
    {
        bool calc = false;

        SkillActionFrameEvent hitFE = null;
        try
        {
            ActionEventData aeData = SkillActionEventCfgMgr.Instance.GetActionEventData(buffID,gender,jobType,jobStage,jobBranch);
            if (aeData == null)
            {
                DebugHelper.LogError("LoadEventsData:中没有buffID = " + buffID);
                mBuffActionFrameEvents = new SkillActionFrameEvent[0];
                return;
            }

            totalFrame = aeData.TotalFrame;
            //totalTime = aeData.TotalFrame / Constants.frame_to_time;

            List<ActionEventParam> aeParams = aeData.ActionEventList;
            if (aeParams == null || aeParams.Count == 0) return;

            List<SkillActionFrameEvent> eventList = new List<SkillActionFrameEvent>(aeParams.Count);
            for (int idx = 0; idx < aeParams.Count; idx++)
            {
                ActionEventParam aep = aeParams[idx];

                SkillActionFrameEvent frameEventData = new SkillActionFrameEvent(this.buffID);
                frameEventData.initStartTime = (Fix64)aep.startFrame / (Fix64)Constants.frame_to_time;
                frameEventData.initEndTime = (Fix64)aep.endFrame / (Fix64)Constants.frame_to_time;

                frameEventData.initStartFrame = aep.startFrame;
                frameEventData.initEndFrame = aep.endFrame;
                frameEventData.bAffectBySing = aep.bAffectBySing;
                frameEventData.eventType = (SkillActionFrameEventType)aep.eventType;
                frameEventData.name = frameEventData.initStartFrame.ToString() + "," + ((int)frameEventData.eventType).ToString();
                frameEventData.paramerters = aep.frameParams.ToArray();
                eventList.Add(frameEventData);
                if (frameEventData.eventType == SkillActionFrameEventType.FE_Skill_Sing)
                {
                    SingFrameEvent = frameEventData;
                }
                if(frameEventData.eventType == SkillActionFrameEventType.FE_Hit || 
                    frameEventData.eventType == SkillActionFrameEventType.FE_Bullet)
                {

                    if (hitFE != null && !calc)
                    {
                        multiHurtIntervalTime = (frameEventData.initStartFrame - hitFE.initStartFrame) / Constants.frame_to_time;
                        calc = true;
                    }
                    else
                    {
                        hitFE = frameEventData;
                    }

                    multiHurtCnt++;
                }
            }

            CommonUtil.SortList(eventList, (a, b) => (int)(a.startTime * Constants.frame_to_time) - (int)(b.startTime * Constants.frame_to_time));
            mBuffActionFrameEvents = eventList.ToArray();
        }
        catch (System.Exception e)
        {
            DebugHelper.LogError("加载buff {0} 的动作帧事件失败：{1}", buffID, e.Message);
            mBuffActionFrameEvents = new SkillActionFrameEvent[0];
        }
    }

    private int mBuffLevel = 1;
    public int BuffLevel
    {
        get { return mBuffLevel; }
    }

    public void SetLevel(int skillLv)
    {
        mBuffLevel = skillLv;
        if (BuffFunList == null) return;

        for(int idx =0; idx < BuffFunList.Count;idx++)
        {
            BuffFunctionData funData = BuffFunList[idx];
            funData.SetLevel(skillLv);
        }
    }

    public void Dispose()
    {
        //清理buff的帧事件数据
        if (mBuffActionFrameEvents != null)
        {
            for (int i = 0; i < mBuffActionFrameEvents.Length; ++i)
            {
                if (mBuffActionFrameEvents[i] != null)
                {
                    mBuffActionFrameEvents[i].Dispose();
                    mBuffActionFrameEvents[i] = null;
                }
            }
            mBuffActionFrameEvents = null;
        }
    }
}
