using UnityEngine;
using System.Collections;
using System;
using System.Collections.Generic;
using LuaInterface;

public enum ActorType
{
    None = 0,
    Hero = 1,
    Fellow = 2,
    Monster = 3,
    Pet = 4
}

public class ActorData
{
    #region ATTR_TYPE
    public const int Attr_STR = 1;         //力量 [一级]
    public const int Attr_AGI = 2;         //敏捷 [一级]
    public const int Attr_INT = 3;         //智力 [一级]
    public const int Attr_VIT = 4;         //体质 [一级]
    public const int Attr_DEX = 5;         //灵巧 [一级]
    public const int Attr_LUK = 6;         //幸运 [一级]
    public const int Attr_Life = 7;         // 生命   [二级]
    public const int Attr_Sp = 8;           //蓝量    [二级]
    public const int Attr_Attack = 9;       //物攻    [二级]
    public const int Attr_MagicAttack = 10;  //魔攻    [二级]
    public const int Attr_Defense = 11;      //物防    [二级]
    public const int Attr_MagicDefense = 12; //魔防    [二级]
    public const int Attr_Hit = 13;          //命中    [二级]  
    public const int Attr_Dodge = 14;        //闪避    [二级]
    public const int Attr_Crit = 15;         //暴击    [二级]
    public const int Attr_Ten = 16;         //韧性    [二级]
    public const int Attr_AttackSpeed = 17;             //攻速
    public const int Attr_CastAcceleration = 18;        //施法加速
    public const int Attr_MaxHp = 19;
    public const int Attr_MaxSp = 20;
    public const int Attr_GodPow = 21;                //神威

    public const int Attr_STR_Percent = 31;
    public const int Attr_AGI_Percent = 32;
    public const int Attr_INT_Percent = 33;
    public const int Attr_VIT_Percent = 34;
    public const int Attr_DEX_Percent = 35;
    public const int Attr_LUK_Percent = 36;
    public const int Attr_Life_Percent = 37;         
    public const int Attr_Sp_Percent = 38;
    public const int Attr_Attack_Percent = 39;
    public const int Attr_MagicAttack_Percent = 40;
    public const int Attr_Defense_Percent = 41;
    public const int Attr_MagicDefense_Percent = 42; 
    public const int Attr_Hit_Percent = 43;
    public const int Attr_Dodge_Percent = 44;        
    public const int Attr_Crit_Percent = 45;         
    public const int Attr_Ten_Percent = 46;        
    public const int Attr_AttackSpeed_Percent = 47;
    public const int Attr_CastAcceleration_Percent = 48;
    public const int Attr_MaxHp_Percent = 49;
    public const int Attr_MaxSp_Percent = 50;
    public const int Attr_RealHurt_Percent = 51;

    public const int Attr_Nature_None_Damage_Percent = 71;      //对无属性目标伤害加成/减免百分比
    public const int Attr_Nature_Water_Damage_Percent = 72;     //对水属性目标的伤害加成/减免百分比
    public const int Attr_Nature_Ground_Damage_Percent = 73;    //对地属性目标的伤害加成/减免百分比
    public const int Attr_Nature_Fire_Damage_Percent = 74;      //对火属性目标的伤害加成/减免百分比
    public const int Attr_Nature_Wind_Damage_Percent = 75;      //对风属性目标的伤害加成/减免百分比
    public const int Attr_Nature_Saint_Damage_Percent = 76;     //对圣属性目标的伤害加成/减免百分比
    public const int Attr_Nature_Dark_Damage_Percent = 77;      //对暗属性目标的伤害加成/减免百分比
    public const int Attr_Nature_Read_Damage_Percent = 78;      //对念属性目标的伤害加成/减免百分比

    public const int Attr_Nature_None_AntiDamage_Percent = 81;      //抗无属性伤害加成/减免百分比
    public const int Attr_Nature_Water_AntiDamage_Percent = 82;     //抗水属性伤害加成/减免百分比
    public const int Attr_Nature_Ground_AntiDamage_Percent = 83;    //抗地属性伤害加成/减免百分比
    public const int Attr_Nature_Fire_AntiDamage_Percent = 84;      //抗火属性伤害加成/减免百分比
    public const int Attr_Nature_Wind_AntiDamage_Percent = 85;      //抗风属性伤害加成/减免百分比
    public const int Attr_Nature_Saint_AntiDamage_Percent = 86;     //抗圣属性伤害加成/减免百分比
    public const int Attr_Nature_Dark_AntiDamage_Percent = 87;      //抗暗属性伤害加成/减免百分比
    public const int Attr_Nature_Read_AntiDamage_Percent = 88;      //抗念属性伤害加成/减免百分比

    public const int Attr_Penetration_Percent = 91;             //忽视物防
    public const int Attr_Magic_Penetration_Percent = 92;       //忽视魔防
    public const int Attr_PhysicDamage_Percent = 93;            //物伤加成/减免百分比
    public const int Attr_MagicDamage_Percent = 94;             //魔法伤害加成/减免百分比
    public const int Attr_Anti_PhysicDamage_Percent = 95;       //抗物伤加成
    public const int Attr_Anti_MagicDamage_Percent = 96;        //抗魔法加成
    public const int Attr_CritDamage_Percent = 97;               //暴击伤害百分比
    public const int Attr_PhysicDamageReflect_Percent = 98;      //物理伤害反射百分比
    public const int Attr_MagicDamageReflect_Percent = 99;       //魔法伤害反射百分比
    public const int Attr_FixedSingTime_Percent = 100;           //固定吟唱加成/减免百分比
    public const int Attr_VariableSingTime_Percent = 101;        //可变吟唱加成/减免百分比


    public const int s_FirstAttrNum = 6;
    public const int s_SecondAttrNum = 10;  //二级属性的个数
    public const int s_AttrNum = 30;
    public const int s_AllAttrNum = 101;
    #endregion

    #region BASIC_PROPERTIES
    protected SFloat[] mAdditionalAttrs = null;
    protected SFloat[] mAttrPercent = null;
    protected SFloat[] mServerAttrs = null;//服务器计算的2级属性 只有伙伴 主角 宠物有  NPC还走本地二级属性
    protected Dictionary<int, SFloat> mExtendAttrPercentDic = null;
    protected List<TriggerBuffData> mTriggerBuffs = null;    
    public List<TriggerBuffData> TriggerBuffs
    {
        get { return mTriggerBuffs; }
    }

    public SFloat[] AdditionAttrs
    {
        get { return mAdditionalAttrs; }
    }

    public SFloat[] AttrPercents
    {
        get { return mAttrPercent; }
    }

    public int IActorType
    {
        get { return (int)mActorType; }
    }

    public int JobType
    {
        get { return (int)Profession; }
    }


    protected ActorType mActorType = ActorType.None;

    public ActorType AType
    {
        get { return mActorType; }
    }

    public bool valid = false;
    private int mBaseId = 0;
    public int BaseId 
    { 
        get { return mBaseId; }
        set { mBaseId = value; }
    }

    private long mId = 0;
    public long ID
    {
        get { return mId; }
        set { mId = value; }
    }


    private bool mIsRecordActor = false;
    public bool IsRecordActor
    {
        get { return mIsRecordActor; }
        set { mIsRecordActor = value; }
    }

    private CastSkillData mCastSkillData;

    protected AvatarData mAvatarData;

    protected SkillManager mSkillMgr;
    
    public AvatarData AvatarData { get { return mAvatarData; } }
    
    public SkillManager SkillMgr { get { return mSkillMgr; } }

    //站位
    public Position_Type PositionRule
    {
        get
        {
            if (PositionValue <= 3)
                return Position_Type.Position_Front;
            else
                return Position_Type.Position_Back;
        }
    }

    public Vector3 Rot { get { return mAvatarData.rot; } }

    public Vector3 Offset { get { return mAvatarData.offset; } }

    public bool IsFront { get { return PositionRule == Position_Type.Position_Front; } }

    public bool IsBack { get { return PositionRule == Position_Type.Position_Back; } }

    public virtual int AvatarID { get { return 0; } }

    public virtual string Name { get { return ""; }  set { } }

    public virtual string Description { get { return ""; } }

    public virtual ProfessionType Profession { get { return ProfessionType.Pro_Type_0; } }

    public virtual int JobStage { get { return 0; } }

    public virtual int JobBranch { get { return 0; } }

    public virtual int PositionValue { get { return 0; } set { } }
    public virtual bool IgnoreLife { get { return false; } set { } }

    public virtual ulong FighterInstanceId { get; set; }

    public virtual bool IsHero { get { return false; } }

    public virtual bool IsFellow { get { return false; } }

    public virtual bool IsNpc { get { return false; } }

    public virtual bool IsPet { get { return false; } }

    public virtual bool IsBoss { get; set; }

    public virtual string HeadIcon { get; set;}

    public virtual int HeadFrameId { get; set;}

    public virtual string BattleBigIcon { get; }

    public virtual int NatureId { get { return 0; } }

    public virtual bool ShowHpBar { get { return false; } }

    public virtual string AnimCtrlName
    {
        get { return ""; }
    }

    public virtual string ShowAnimCtrlName
    {
        get { return ""; }
    }

    //狂暴id
    public int RageId { get; set; }

    public bool IsMainRole { get; set; }

    public virtual NpcBaseData NpcData { get { return null; } }

    public bool IsHaving = false;

    public bool IsShowBoss { get; set; }

    public virtual int Gender { get; set; }

    protected int mLevel;

    public int Level
    {
        get { return mLevel; }
        set { mLevel = value; }
    }

    protected int mStrengthLevel;

    public int StrengthLevel
    {
        get { return mStrengthLevel; }
        set { mStrengthLevel = value; }
    }

    //UI 显示的等级 1.推图BOOSlv = 关卡 2.爬塔lv = 爬塔层数 
    protected int mShowLevel;

    public int ShowLevel
    {
        get { return mShowLevel; }
        set { mShowLevel = value; }
    }
    private SBool bInvincible = false;
    public SBool Invincible
    {
        get { return bInvincible; }
        set { bInvincible = value; }
    }

    protected Dictionary<int, SFloat> mEquipTotalAttrs;

    public Dictionary<int, SFloat> MEquipTotalAttrs
    {
        get { return mEquipTotalAttrs; }
        set { mEquipTotalAttrs = value; }
    }

    private bool bDisposed = false;
    public bool IsDisposed
    {
        get { return bDisposed; }
    }

    public virtual string SkillFrameEventName { get { return ""; } }

    public virtual string ProfessionIcon { get { return ""; } }

    public virtual CastSkillData CastSkillParam
    {
        get { return mCastSkillData; }
    }

    public bool IsTransferred { get; set; }     //是否转职
    
    public string IdleSound { get { return mAvatarData != null ? mAvatarData.IdleSound : ""; } }

    public string RunSound { get { return mAvatarData != null ? mAvatarData.RunSound : ""; } }

    public string DieSound { get { return mAvatarData != null ? mAvatarData.DieSound : ""; } }

    public string HitSound { get { return mAvatarData != null ? mAvatarData.HitSound : ""; } }


    public string PetIcon { get { return mPetData != null ? mPetData.HeadIcon : ""; } }

    public virtual int BornEffectId { get { return 0; } }
    #endregion

    #region ATTR_PROPERTIES

    /*****************************一级属性**********************************************/
    public virtual SInt BaseSTR { get { return 1; } set { } }
    public virtual SInt BaseAGI { get { return 1; } set { } }
    public virtual SInt BaseINT { get { return 1; } set { } }
    public virtual SInt BaseVIT { get { return 1; } set { } }
    public virtual SInt BaseDEX { get { return 1; } set { } }
    public virtual SInt BaseLUK { get { return 1; } set { } }

    public virtual SInt STR { get { return 0; } }            //力量
    public virtual SInt AGI { get { return 0; } }            //敏捷
    public virtual SInt INT { get { return 0; } }            //智力
    public virtual SInt VIT { get { return 0; } }            //体质
    public virtual SInt DEX { get { return 0; } }            //灵巧
    public virtual SInt LUK { get { return 0; } }            //幸运

    /********************************角色基础成长二级属性属性*****************************/
    public virtual SFloat BaseLife { get { return 0; } }    
    
    public virtual SFloat BaseSp { get { return 0; } }

    public virtual SFloat BaseAttack { get { return 0; } }

    public virtual SFloat BaseMagicAttack { get { return 0; } }

    public virtual SFloat BaseDefense {get { return 0; } }

    public virtual SFloat BaseMagicDefense { get { return 0; } }

    public virtual SFloat BaseCrit { get { return 0; } }

    public virtual SFloat BaseCritDamage { get { return 0; } }

    public virtual SFloat BaseDodge { get { return 0; } }

    public virtual SFloat BaseHit { get { return 0; } }

    public virtual SFloat BaseTen { get { return 0; } }

    public virtual SFloat BaseAttackSpeed { get { return 0; } }

    //(有服务器数据返回服务器 无 返回本地) 
    /********************************二级属性[in battle]*******************************************/
    public virtual SFloat Life { get { return 0; }}                 //生命 
    public virtual SFloat LocalLife
    {
        get
        {
            return CalcSecondAttr(Attr_Life);
        }
    }

    public virtual SFloat Sp { get { return 0; }}                   //蓝量  
    public virtual SFloat LocalSp
    {
        get
        {
            return CalcSecondAttr(Attr_Sp);
        }
    }
    public virtual SFloat MinAttack { get { return Attack; } }                  //最小物攻

    public virtual SFloat Attack { get { return 0; } }                       //物攻
    public virtual SFloat LocalAttack
    {
        get
        {
            return CalcSecondAttr(Attr_Attack);
        }
    }

    public virtual SFloat MinMagicAttack { get { return MagicAttack; } }                //最少魔攻

    public virtual SFloat MagicAttack { get { return 0; } }                 //魔攻
    public virtual SFloat LocalMagicAttack
    {
        get
        {
            return CalcSecondAttr(Attr_MagicAttack);
        }
    }

    public virtual SFloat Defense { get { return 0; } }                 //物防  
    public virtual SFloat LocalDefense
    {
        get
        {
            return CalcSecondAttr(Attr_Defense);
        }
    }

    public virtual SFloat MagicDefense { get { return 0; } }            //魔防
    public virtual SFloat LocalMagicDefense
    {
        get
        {
            return CalcSecondAttr(Attr_MagicDefense);
        }
    }

    public virtual SFloat Crit { get { return 0; } }             //暴击
    public virtual SFloat LocalCrit
    {
        get
        {
            return CalcSecondAttr(Attr_Crit);
        }
    }

    public virtual SFloat CritDamagePercent { get { return GetAdditionalAttrPercent(Attr_CritDamage_Percent); } }       //暴击伤害百分比

    public virtual SFloat Dodge { get { return 0; } }                   //闪避
    public virtual SFloat LocalDodge
    {
        get
        {
            return CalcSecondAttr(Attr_Dodge);
        }
    }

    public virtual SFloat Hit { get { return 0; } }                     //命中率
    public virtual SFloat LocalHit
    {
        get
        {
            return CalcSecondAttr(Attr_Hit);
        }
    }

    public virtual SFloat Ten { get { return 0; } }                    //韧性
    public virtual SFloat LocalTen
    {
        get
        {
            return CalcSecondAttr(Attr_Ten);
        }
    }

    public virtual SFloat AttackSpeed { get { return 0; } }            //攻击速度
    public virtual SFloat LocalAttackSpeed
    {
        get
        {
            return CalcSecondAttr(Attr_AttackSpeed);
        }
    }

    public virtual SFloat CastAcceleration { get { return 0; } }            //施法加速
    public virtual SFloat LocalCastAcceleration
    {
        get
        {
            return CalcSecondAttr(Attr_CastAcceleration);
        }
    }
    public virtual SFloat GodPower { get { return 0; } }         //神威值
    public virtual SFloat LocalGodPower { get { return 0; } }     //神威值

    public virtual SFloat Penetration { get { return GetAdditionalAttrPercent(Attr_Penetration_Percent); } }          //忽视物防

    public virtual SFloat MagicPenetration { get { return GetAdditionalAttrPercent(Attr_Magic_Penetration_Percent); } }     //忽视魔防

    public virtual SFloat VariableSingTime { get { return 0; } }

    public virtual SInt PerfectDodgeRate { get { return 0; } }

    public virtual SFloat DefPercent { get { return GetAdditionalAttrPercent(ActorData.Attr_Defense_Percent); } }        //防御百分比

    public virtual SFloat MagicDefPercent { get {  return GetAdditionalAttrPercent(ActorData.Attr_MagicDefense_Percent); } } //魔防百分比
    #endregion


    private long mPetId = 0;
    public long PetId
    {
        get { return mPetId; }
        set { mPetId = value; }
    }

    private ActorData mPetData = null;
    public ActorData PetData
    {
        get { return mPetData; }
    }

    public long GetuId()
    {
        return ID;
    }

    public long GetBaseId()
    {
        return BaseId;
    }

    public bool HasPet { get { return mPetData!=null; } }

    protected ActorData(int id)
    {
        IsMainRole = false;
        mBaseId = id;
        mAdditionalAttrs = new SFloat[s_AttrNum];
        mAttrPercent = new SFloat[s_AttrNum];
        mServerAttrs = new SFloat[s_AllAttrNum];
        mExtendAttrPercentDic = new Dictionary<int, SFloat>();
        ResetServerSecondAttr();
    }

    public virtual void RefreshSkills(SkillParam[] usedSkills)
    {
        
    }

    protected void SetUsedSkill(SkillParam[] usedSkills)
    {
        mUsedSkills = usedSkills;
    }

    private SkillParam[] mUsedSkills = null;
    public virtual void Initialize(int id, int level, SkillParam[] usedSkills)
    {
        mBaseId = id;
        mLevel = level;
        mShowLevel = level;
        mUsedSkills = usedSkills;

        mEquipTotalAttrs = new Dictionary<int, SFloat>();
        for (int i = Attr_Life; i <= Attr_MaxSp_Percent; ++i)
        {
            mEquipTotalAttrs.Add(i, 0);
        }
    }

    //平均技能等级
    public virtual int GetNverageSkillsLv()
    {        
        int nNverageSkilllv = 0;
        if(null != mUsedSkills)
        {
            for (int i = 0; i < mUsedSkills.Length; i++)
            {
                nNverageSkilllv += mUsedSkills[i].skillLv;
            }
            //if (mUsedSkills.Length > 0)
            //{
            //    nNverageSkilllv = (int)Math.Ceiling((float)nNverageSkilllv / mUsedSkills.Length);
            //}
            nNverageSkilllv = nNverageSkilllv - mUsedSkills.Length;
        }      
        return nNverageSkilllv>=0 ? nNverageSkilllv:0;
    }

    public virtual float GetScale()
    {
        float fCurScale = 1;
        if (IsPet)
        {
            int nNverageSkillLv = GetNverageSkillsLv();
            string strScales = GlobalConfig.Instance.GetConfigStrValue(GlobalConfig.c_pet_scale_level);
            string[] strInfos = StringUtil.split(strScales, ';');
            for (int i = 0; i < strInfos.Length; i++)
            {
                string[] strDatas = StringUtil.split(strInfos[i], ':');
                if (strDatas.Length >= 2)
                {
                    int nLevel = 0;
                    float fScale = 1;
                    int.TryParse(strDatas[0], out nLevel);
                    float.TryParse(strDatas[1], out fScale);
                    if (nLevel <= nNverageSkillLv)
                    {                       
                        fCurScale = fScale;
                    }
                    else
                    {
                        break;
                    }
                }
            }            
        }
        return fCurScale;
    }

    public void SetEquipTotalAttr(int id, float val)
    {
        mEquipTotalAttrs[id] = val;
    }

    public float GetEquipTotalAttr(int id)
    {
        return mEquipTotalAttrs[id];
    }
    //-----------------------------------------服务器二级属性
    public SFloat GetSeverSecondAttr(int attrId)
    {
        if (mServerAttrs.Length < attrId) return 0;

        return mServerAttrs[attrId - 1];
    }

    public void SetServerSecondAttr(int id, double val)
    {
        float fVal = (float)val;
        float.TryParse(val.ToString(), out fVal);
        if (id < Attr_STR || id > Attr_GodPow)
        {
           
            mServerAttrs[id - 1] = fVal * 0.0001f;
        }
        else
        {
            mServerAttrs[id - 1] = fVal;
        }
    }

    public void SetServerSecondAttr(int id, float val)
    {
        if (id < Attr_STR || id > Attr_GodPow)
        {
            mServerAttrs[id - 1] = val * 0.0001f;
        }
        else
        {
            mServerAttrs[id - 1] = val;
        }
    }

    public void SetServerSecondAttr(int id, SFloat val)
    {
        if (id < Attr_STR || id > Attr_GodPow)
        {
            mServerAttrs[id - 1] = val * 0.0001f;
        }
        else
        {
            mServerAttrs[id - 1] = val;
        }
    }
    public void ResetServerSecondAttr()
    {
        for (int i = 0; i < mServerAttrs.Length; i++)
        {
            mServerAttrs[i] = -1;//服务器没有计算 默认-1 取本地       
            if (i >= Attr_Nature_Water_Damage_Percent - 1 && i <= Attr_VariableSingTime_Percent - 1)//下面区间服务器有计算 默认为0
            {
                mServerAttrs[i] = 0;
            }
        }
    }
    //----------------------------------------
    public SFloat GetAdditionalAttr(int attrId)
    {
        if (attrId < Attr_STR || attrId > Attr_GodPow) return 0;

        return mAdditionalAttrs[attrId - 1];
    }

    public void SetAdditionalAttr(int id, float val)
    {
        if (id < Attr_STR || id > Attr_GodPow) return;

        mAdditionalAttrs[id - 1] = val;
    }

    public void SetAdditionalAttr(int id, SFloat val)
    {
        if (id < Attr_STR || id > Attr_GodPow) return;

        mAdditionalAttrs[id - 1] = val;
    }

    public void ResetAdditionalAttr()
    {
        for(int i = 0; i < mAdditionalAttrs.Length; ++i)
        {
            mAdditionalAttrs[i] = 0;
        }
    }

    public void ResetAdditionalAttrPercent()
    {
        for (int i = 0; i < mAttrPercent.Length; ++i)
        {
            mAttrPercent[i] = 0;
        }
    }

    public SFloat GetAdditionalAttrPercent(int attrId)
    {
        if (attrId < Attr_STR_Percent) return 0;

        if(attrId >= Attr_Nature_None_Damage_Percent && attrId <= Attr_VariableSingTime_Percent)
        {           
            SFloat val;
            val = mServerAttrs[attrId - 1];
            if (val >= 0)
                return val;
            mExtendAttrPercentDic.TryGetValue(attrId, out val);
            return val;
        }

        return mAttrPercent[attrId - Attr_STR_Percent];
    }

    public void SetAdditionalAttrPercent(int id, float val)
    {
        if (id < Attr_STR_Percent) return;

        if (id >= Attr_Nature_None_Damage_Percent && id <= Attr_VariableSingTime_Percent)
        {
            if (mExtendAttrPercentDic.ContainsKey(id))
                mExtendAttrPercentDic[id] = val;
            else
                mExtendAttrPercentDic.Add(id, val);
            return;
        }

        mAttrPercent[id - Attr_STR_Percent] = val;
    }

    public void SetAdditionalAttrPercent(int id, SFloat val)
    {
        if (id < Attr_STR_Percent) return;

        if (id > Attr_RealHurt_Percent && id < Attr_Nature_None_Damage_Percent) return;

        if (id >= Attr_Nature_None_Damage_Percent && id <= Attr_VariableSingTime_Percent)
        {
            if (mExtendAttrPercentDic.ContainsKey(id))
                mExtendAttrPercentDic[id] = val;
            else
                mExtendAttrPercentDic.Add(id, val);
            return;
        }

        mAttrPercent[id - Attr_STR_Percent] = val;
    }

    public SFloat GetFinalAttr(int attrId)
    {
        if (attrId <= Attr_GodPow)
            return GetAttr(attrId);
        else
            return GetAdditionalAttrPercent(attrId);
    }

    public void CloneAllAttributes(ActorData actorData)
    {
        for(int idx = Attr_STR;idx<=Attr_LUK;idx++)
        {
            SetBaseFirstAttr(idx, actorData.GetBaseFirstAttr(idx));
        }
        int length = 0;
        if (actorData.AdditionAttrs != null)
        {
            length = actorData.AdditionAttrs.Length;
            if (mAdditionalAttrs == null || mAdditionalAttrs.Length != length)
                mAdditionalAttrs = new SFloat[length];
            for (int idx = 0; idx < length; idx++)
                mAdditionalAttrs[idx] = actorData.AdditionAttrs[idx];
        }

        if (actorData.AttrPercents != null)
        {
            length = actorData.AttrPercents.Length;
            if (mAttrPercent == null || mAttrPercent.Length != length)
                mAttrPercent = new SFloat[length];
            for (int idx = 0; idx < length; idx++)
                mAttrPercent[idx] = actorData.AttrPercents[idx];
        }

        if(actorData.mExtendAttrPercentDic != null)
        {
            if (mExtendAttrPercentDic == null)
                mExtendAttrPercentDic = new Dictionary<int, SFloat>();
            else
                mExtendAttrPercentDic.Clear();

            foreach(var p in actorData.mExtendAttrPercentDic)
            {
                mExtendAttrPercentDic.Add(p.Key, p.Value);
            }
        }
    }

    public void CloneData(ActorData from)
    {
        //DebugHelper.LogError("----------------CloneData-------------");
        if(from.AdditionAttrs != null)
        {
            for(int idx = 0; idx < from.AdditionAttrs.Length;idx++)
            {
                mAdditionalAttrs[idx] = from.AdditionAttrs[idx];
                //DebugHelper.LogError("AdditionalAttr: " + mAdditionalAttrs[idx]);
            }
        }

        if(from.AttrPercents!=null)
        {
            for (int idx = 0; idx < from.AttrPercents.Length; idx++)
            {
                mAttrPercent[idx] = from.AttrPercents[idx];
            }
        }
    }

    public SFloat GetBaseSecondAttr(int attrId)
    {
        switch (attrId)
        {
            case Attr_Life:
                return BaseLife;
            case Attr_Sp:
                return BaseSp;
            case Attr_Attack:
                return BaseAttack;
            case Attr_MagicAttack:
                return BaseMagicAttack;
            case Attr_Defense:
                return BaseDefense;
            case Attr_MagicDefense:
                return BaseMagicDefense;
            case Attr_Hit:
                return BaseHit;
            case Attr_Crit:
                return BaseCrit;
            case Attr_Dodge:
                return BaseDodge;
            case Attr_Ten:
                return BaseTen;
            case Attr_AttackSpeed:
                return BaseAttackSpeed;
        }

        return 0;
    }

    //返回本地计算属性
    public SFloat GetLocalSecondAttr(int attrId)
    {
        switch (attrId)
        {
            case Attr_Life:
                return LocalLife;
            case Attr_Sp:
                return LocalSp;
            case Attr_Attack:
                return LocalAttack;
            case Attr_MagicAttack:
                return LocalMagicAttack;
            case Attr_Defense:
                return LocalDefense;
            case Attr_MagicDefense:
                return LocalMagicDefense;
            case Attr_Hit:
                return LocalHit;
            case Attr_Crit:
                return LocalCrit;
            case Attr_Dodge:
                return LocalDodge;
            case Attr_Ten:
                return LocalTen;
            case Attr_AttackSpeed:
                return LocalAttackSpeed;
            case Attr_CastAcceleration:
                return LocalCastAcceleration;
        }
        return 0;
    }

    //有服务器属性 返回服务器属性 没有返回本地属性
    public SFloat GetSecondAttr(int attrId)
    {
        switch(attrId)
        {
            case Attr_Life:
                return Life;
            case Attr_Sp:
                return Sp;
            case Attr_Attack:
                return Attack;
            case Attr_MagicAttack:
                return MagicAttack;
            case Attr_Defense:
                return Defense;
            case Attr_MagicDefense:
                return MagicDefense;
            case Attr_Hit:
                return Hit;
            case Attr_Crit:
                return Crit;
            case Attr_Dodge:
                return Dodge;
            case Attr_Ten:
                return Ten;
            case Attr_AttackSpeed:
                return AttackSpeed;
            case Attr_CastAcceleration:
                return CastAcceleration;
            case Attr_GodPow:
                return GodPower;
        }
        return 0;
    }

    public SFloat GetFirstAttr(int id)
    {
        switch (id)
        {
            case ActorData.Attr_STR:
                return STR;
            case ActorData.Attr_AGI:
                return AGI;
            case ActorData.Attr_INT:
                return INT;
            case ActorData.Attr_VIT:
                return VIT;
            case ActorData.Attr_DEX:
                return DEX;
            case ActorData.Attr_LUK:
                return LUK;  
        }
        return 0;
    }

    public SFloat GetBaseFirstAttr(int id)
    {
        switch (id)
        {
            case ActorData.Attr_STR:
                return BaseSTR;
            case ActorData.Attr_AGI:
                return BaseAGI;
            case ActorData.Attr_INT:
                return BaseINT;
            case ActorData.Attr_VIT:
                return BaseVIT;
            case ActorData.Attr_DEX:
                return BaseDEX;
            case ActorData.Attr_LUK:
                return BaseLUK;
        }
        return 0;
    }

    public void SetBaseFirstAttr(int id, SFloat val)
    {
        if (id == ActorData.Attr_STR)
        {
            BaseSTR = (int)val;
        }
        else if (id == ActorData.Attr_AGI)
        {
            BaseAGI = (int)val;
        }
        else if (id == ActorData.Attr_INT)
        {
            BaseINT = (int)val;
        }
        else if (id == ActorData.Attr_VIT)
        {
            BaseVIT = (int)val;
        }
        else if (id == ActorData.Attr_DEX)
        {
            BaseDEX = (int)val;
        }
        else if (id == ActorData.Attr_LUK)
        {
            BaseLUK = (int)val;
        }
    }

    public void ResetBaseFirstAttr()
    {
        BaseSTR = 1;
        BaseAGI = 1;
        BaseINT = 1;
        BaseVIT = 1;
        BaseDEX = 1;
        BaseLUK = 1;
    }

    public SFloat GetAttr(int id)
    {
        if (id <= Attr_LUK) return GetFirstAttr(id);

        if (id <= Attr_GodPow) return GetSecondAttr(id);

        return 0;
    }

    Dictionary<int, float> oldAttrs = null;
    Dictionary<int, float> oldVals = null;
    Dictionary<int, float> newVals = null;
    Dictionary<int, float> deltaVals = null;
    public Dictionary<int, float> GetPreviewAttr(int[] vals)
    {
        if (oldVals == null)
            oldVals = new Dictionary<int, float>();
        else
            oldVals.Clear();

        if (newVals == null)
            newVals = new Dictionary<int, float>();
        else
            newVals.Clear();

        if (deltaVals == null)
            deltaVals = new Dictionary<int, float>();
        else
            deltaVals.Clear();

        if (oldAttrs == null)
            oldAttrs = new Dictionary<int, float>();
        else
            oldAttrs.Clear();

        for (int i = 0; i < vals.Length; ++i)
        {
            int attrId = i + ActorData.Attr_STR;
            oldAttrs.Add(attrId, GetBaseFirstAttr(attrId));
        }

        for(int idx = ActorData.Attr_Life; idx <= ActorData.Attr_CastAcceleration; idx++)
        {           
            oldVals.Add(idx, GetLocalSecondAttr(idx));
        }

        for (int i = 0; i < vals.Length; ++i)
        {
            int attrId = i + ActorData.Attr_STR;
            SetBaseFirstAttr(attrId, vals[i]);
        }
     
        for (int idx = ActorData.Attr_Life; idx <= ActorData.Attr_CastAcceleration; idx++)
        {
            newVals.Add(idx, GetLocalSecondAttr(idx));
        }

        for (int i = 0; i < vals.Length; ++i)
        {
            int attrId = i + ActorData.Attr_STR;
            SetBaseFirstAttr(attrId, oldAttrs[attrId]);
        }

        //for (int idx = ActorData.Attr_Life; idx <= ActorData.Attr_AttackSpeed; idx++)
        //{
        //    GetAttr(idx);
        //}

        for (int idx = ActorData.Attr_Life; idx <= ActorData.Attr_CastAcceleration; idx++)
        {
            float deltaVal = newVals[idx] - oldVals[idx];
            deltaVals.Add(idx, deltaVal);
        }

        return deltaVals;
    }

    public Dictionary<int, float> GetPreviewLvUpLocalAttr(int lv)
    {
        if (deltaVals == null)
            deltaVals = new Dictionary<int, float>();
        else
            deltaVals.Clear();

        int oldLv = Level;
        Level = lv;

        for (int i = Attr_Life; i <= Attr_Ten; ++i)
        {
            deltaVals[i] = GetLocalSecondAttr(i);
        }

        Level = oldLv;

        return deltaVals;
    }
    

    public Dictionary<int, float> GetPreviewLvUpAttr(int lv)
    {
        if (deltaVals == null)
            deltaVals = new Dictionary<int, float>();
        else
            deltaVals.Clear();

        int oldLv = Level;
        Level = lv;

        for (int i = Attr_Life; i <= Attr_Ten; ++i)
        {
            deltaVals[i] = GetSecondAttr(i);
        }

        Level = oldLv;

        return deltaVals;
    }


    protected SFloat CalcSecondAttr(int attrId)
    {
        if (attrId < Attr_Life || attrId > Attr_CastAcceleration) return 0;

        //DebugHelper.LogError("属性id:" + attrId + " baseVal:" + GetBaseSecondAttr(attrId) + " additionalVal:" + GetAdditionalAttr(attrId) +" additionalValPercent:"+ GetAdditionalAttrPercent(attrId + 30));
        return (GetBaseSecondAttr(attrId) + GetAdditionalAttr(attrId)) * (1 + GetAdditionalAttrPercent(attrId + 30));
    }


    private BuffParam[] mBuffListParam = null;
    public void SetBuffs(BuffParam[] buffs)
    {
        mBuffListParam = buffs;
        if (mBuffListParam == null) return;

        if (mTriggerBuffs == null)
            mTriggerBuffs = new List<TriggerBuffData>();
        else
            mTriggerBuffs.Clear();

        for (int idx = 0; idx < mBuffListParam.Length; idx++)
        {
            BuffParam buff = mBuffListParam[idx];
            if (buff.buffId == 0 || buff.ratio == 0) continue;

            TriggerBuffData buffData = new TriggerBuffData(buff.buffId, buff.ratio * 0.01f, buff.cd * 0.01f, (BuffTriggerType)buff.type,(BuffTriggerCasterType)buff.casterType,"");
            mTriggerBuffs.Add(buffData);
        }
    }

    private BuffParam[] mDropBuffListParam = null;
    private List<TriggerBuffData> mDropBuffList = null;
    public List<TriggerBuffData> DropBuffList
    {
        get { return mDropBuffList; }
    }

    public void SetDropBuffs(BuffParam[] buffs)
    {
        mDropBuffListParam = buffs;
        if (mDropBuffListParam == null)
        {
            mDropBuffList = null;
            return;
        }

        if (mDropBuffList == null)
            mDropBuffList = new List<TriggerBuffData>();
        else
            mDropBuffList.Clear();

        for(int idx =0; idx < mDropBuffListParam.Length; idx++)
        {
            BuffParam buff = mDropBuffListParam[idx];
            if (buff.buffId == 0 || buff.ratio == 0) continue;


            //DebugHelper.LogError(buff.buffId+" -------------------- "+ buff.funStr);

            TriggerBuffData buffData = new TriggerBuffData(buff.buffId, buff.ratio * 0.01f, buff.cd * 0.01f, (BuffTriggerType)buff.type, (BuffTriggerCasterType)buff.casterType, buff.extendPara.ToString(), buff.funStr);
            mDropBuffList.Add(buffData);
        }
    }

    //目前 該mark 用在pve中 技能激活
    private GvGMark m_pMark = null;
    public GvGMark PveMark
    {
        get { return m_pMark; }
    }
    public void SetPveMark(GvGMark pMark)
    {
        m_pMark = pMark;
    }

    public void ResetFirstSkill()
    {
        if (mSkillMgr.Skills != null && mSkillMgr.Skills.Length > 0)
        {
            if (mCastSkillData == null)
                mCastSkillData = new CastSkillData();

            mCastSkillData.skillIcon = mSkillMgr.Skills[0].SkillDataInfo.skillIcon;
            mCastSkillData.skillId = mSkillMgr.Skills[0].Id;
            mCastSkillData.cdTime = 0;
            mCastSkillData.actorId = ID;
            mCastSkillData.IsForbidden = true;
            mCastSkillData.IsEnhance = false;
        }
        else if(mSkillMgr.RandomSkills!=null && mSkillMgr.RandomSkills.Count > 0)
        {
            if (mCastSkillData == null)
                mCastSkillData = new CastSkillData();

            BaseSkill skill = mSkillMgr.GetRandomSkill(SkillType.Attack1);

            mCastSkillData.skillIcon = skill.SkillDataInfo.skillIcon;
            mCastSkillData.skillId = skill.Id;
            mCastSkillData.cdTime = 0;
            mCastSkillData.actorId = ID;
            mCastSkillData.IsForbidden = true;
            mCastSkillData.IsEnhance = false;
        }
    }

    public void SetAllAttributes(int[] baseFirstAttrs, float[] additionalAttrs,float[] attrPercentList, Dictionary<int, float> extendAttrPercentDic)
    {
        if(baseFirstAttrs!=null)
        {
            for(int idx = Attr_STR;idx<=Attr_LUK;idx++)
            {
                SetBaseFirstAttr(idx, baseFirstAttrs[idx - 1]);
            }
        }

        if(additionalAttrs!=null)
        {
            for (int idx = 0; idx < additionalAttrs.Length; idx++)
                mAdditionalAttrs[idx] = additionalAttrs[idx];
        }

        if(attrPercentList != null)
        {
            for (int idx = 0; idx < attrPercentList.Length; idx++)
                mAttrPercent[idx] = attrPercentList[idx];
        }

        if(extendAttrPercentDic!=null)
        {
            if (mExtendAttrPercentDic == null)
                mExtendAttrPercentDic = new Dictionary<int, SFloat>();
            else
                mExtendAttrPercentDic.Clear();

            foreach(var p in extendAttrPercentDic)
            {
                mExtendAttrPercentDic.Add(p.Key, p.Value);
            }
        }
    }

    public void SetPet(ActorData pet)
    {
        if (mPetData == pet) return;

        mPetData = pet;
        if (mPetData != null)
            mPetId = mPetData.ID;
        else
            mPetId = 0;

    }
    #region PUBLIC_VIRTUAL_METHODS
    public virtual void SetLevel(int lv)
    {
        mLevel = lv;
    }

    public virtual void Dispose()
    {
        if (bDisposed)
            return;

        /*if (mAvatarData != null)
        {
            mAvatarData.Dispose();
            mAvatarData = null;
        }*/
        
        if(mSkillMgr != null)
        {
            mSkillMgr.Dispose();
            mSkillMgr = null;
        }

        bDisposed = true;
    }
    #endregion

    #region static_public_methods

    public static ActorData CloneActorData(ActorData actorData)
    {
        SkillParam[] usedSkills = null;
        if (actorData.mUsedSkills != null)
        {
            int length = actorData.mUsedSkills.Length;
            usedSkills = new SkillParam[length];
            Array.Copy(actorData.mUsedSkills, usedSkills, length);
        }
        if (actorData is HeroActorData)
        {
            HeroActorData heroActorData = actorData as HeroActorData;
            HeroActorData newHeroActorData = ActorData.CreatePlayerActor(actorData.ID, actorData.BaseId, actorData.Level, usedSkills) as HeroActorData;
            newHeroActorData.IsMainRole = heroActorData.IsMainRole;
            newHeroActorData.StrengthLevel = heroActorData.StrengthLevel;
            
            newHeroActorData.SetProfessionId(heroActorData.ProfessionId);
            newHeroActorData.SetFashionData(heroActorData.FashionData);
            newHeroActorData.CloneAllAttributes(actorData);
            newHeroActorData.PetId = heroActorData.PetId;
            newHeroActorData.HeadFrameId = heroActorData.HeadFrameId;
            return newHeroActorData;
        }
        else if (actorData is FellowActorData)
        {
            FellowActorData fellowActorData = actorData as FellowActorData;
            FellowActorData newFellowActorData = CreateFellowActor(actorData.ID, actorData.BaseId, actorData.Level, usedSkills) as FellowActorData;
            newFellowActorData.IsMainRole = fellowActorData.IsMainRole;
            newFellowActorData.StrengthLevel = fellowActorData.StrengthLevel;
            newFellowActorData.CloneAllAttributes(actorData);
            newFellowActorData.PetId = fellowActorData.PetId;
            return newFellowActorData;
        }
        else if (actorData is PetActorData)
        {
            PetActorData petActorData = actorData as PetActorData;
            PetActorData newPetActorData = CreatePetActor(actorData.ID, actorData.BaseId, actorData.Level, usedSkills) as PetActorData;
            newPetActorData.SetStep(petActorData.Step);
            return newPetActorData;
        }
        else if (actorData is NpcActorData)
        {
            NpcActorData newNpcActorData = CreateNpcPlayerActor(actorData.ID, actorData.BaseId, actorData.Level) as NpcActorData;
            newNpcActorData.IsBoss = actorData.IsBoss;
            newNpcActorData.PositionValue = actorData.PositionValue;
            newNpcActorData.IgnoreLife = actorData.IgnoreLife;
            return newNpcActorData;
        }
        return null;
    }

    public static ActorData CreateActorFromJson(JSONObject json)
    {
        long uid = 0;
        int baseId = 0, level = 0, strengthLevel = 0, jobId = 0;
        long petId = 0;
        bool isMainRole = false, isHero = false, isFellow = false, isBoss = false, isNpc = false,isPet = false;
        bool bIsTransferred = false;
        int pos = 0;
        int advanceLevel = 0;
        int headFrameId = 0;
        bool ignoreLife = false;
        if (json.HasField("Base"))
        {
            JSONObject baseJson = json.GetField("Base");
            uid = baseJson.GetField("id").l;
            baseId = (int)baseJson.GetField("bId").n;
            level = (int)baseJson.GetField("lv").n;
            strengthLevel = (int)baseJson.GetField("strengthLevel").n;
            isMainRole = baseJson.GetField("m").b;
            isHero = baseJson.GetField("h").b;
            isFellow = baseJson.GetField("f").b;
            isBoss = baseJson.GetField("b").b;
            isNpc = baseJson.GetField("n").b;
            isPet = baseJson.GetField("p").b;
            petId = baseJson.GetField("petId").l;
            if (baseJson.HasField("jobId"))
            {
                jobId = (int)baseJson.GetField("jobId").n;
            }
            if(baseJson.HasField("advanceLevel"))
            {
                advanceLevel = (int)baseJson.GetField("advanceLevel").n;
            }
            if(baseJson.HasField("frameId"))
            {
                headFrameId = (int)baseJson.GetField("frameId").n;
            }
            pos = (int)baseJson.GetField("pos").n;
            JSONObject fieldObj = baseJson.GetField("ignoreLife");
            if (fieldObj != null)
            {
                ignoreLife = fieldObj.b;
            }
            if (baseJson.HasField("IsTransferred"))
            {
                bIsTransferred = baseJson.GetField("IsTransferred").b;
            }
        }

        int[] baseFirstAttrs = new int[6];
        float[] additionalAttrs = null;
        float[] sencondAttrs = null;
        float[] attrPercent = null;
        Dictionary<int, float> extendAttrPercentDic = null;
        if (json.HasField("Attrs"))
        {
            JSONObject attrsJson = json.GetField("Attrs");

            if(attrsJson.HasField("baseFirstAttr"))
            {
                JSONObject baseFirstAttrJson = attrsJson.GetField("baseFirstAttr");
                additionalAttrs = new float[baseFirstAttrJson.Count];
                for (int idx = 0; idx < baseFirstAttrJson.Count; idx++)
                {
                    baseFirstAttrs[idx] = (int)baseFirstAttrJson[idx].n;
                }
            }

            if (attrsJson.HasField("serverSecondAttr"))
            {
                JSONObject baseFirstAttrJson = attrsJson.GetField("serverSecondAttr");
                sencondAttrs = new float[baseFirstAttrJson.Count];
                for (int idx = 0; idx < baseFirstAttrJson.Count; idx++)
                {
                    sencondAttrs[idx] = baseFirstAttrJson[idx].f;
                }
            }

            if (attrsJson.HasField("additionalAttr"))
            {
                JSONObject additionalAttrJson = attrsJson.GetField("additionalAttr");
                additionalAttrs = new float[additionalAttrJson.Count];
                for (int idx = 0; idx < additionalAttrJson.Count; idx++)
                {
                    additionalAttrs[idx] = additionalAttrJson[idx].f;
                }
            }

            if (attrsJson.HasField("attrPercent"))
            {
                JSONObject attrPercentJson = attrsJson.GetField("attrPercent");
                attrPercent = new float[attrPercentJson.Count];
                for (int idx = 0; idx < attrPercentJson.Count; idx++)
                {
                    attrPercent[idx] = attrPercentJson[idx].f;
                }
            }

            if (attrsJson.HasField("extendAttr"))
            {
                JSONObject extendAttrJson = attrsJson.GetField("extendAttr");
                extendAttrPercentDic = new Dictionary<int, float>();
                for (int idx = 0; idx < extendAttrJson.Count; idx++)
                {
                    JSONObject temp = extendAttrJson[idx];
                    extendAttrPercentDic.Add((int)temp[0].n, temp[1].f);
                }
            }

        }
        SkillParam[] usedSkills = null;
        if (json.HasField("Skills"))
        {
            JSONObject skillsJson = json.GetField("Skills");
            if (!skillsJson.IsNull)
            {
                usedSkills = new SkillParam[skillsJson.Count];
                for (int idx = 0; idx < skillsJson.Count; idx++)
                {
                    usedSkills[idx] = new SkillParam(skillsJson[idx]);
                }
            }
        }

        BuffParam[] usedBuffs = null;
        if (json.HasField("Buffs"))
        {
            JSONObject buffsJson = json.GetField("Buffs");
            if (!buffsJson.IsNull)
            {
                usedBuffs = new BuffParam[buffsJson.Count];
                for (int idx = 0; idx < buffsJson.Count; idx++)
                {
                    usedBuffs[idx] = new BuffParam(buffsJson[idx]);
                }
            }
        }

        GvGMark pMark = null;
        if (json.HasField("Mark"))
        {
            JSONObject buffsJson = json.GetField("Mark");
            if (null != buffsJson && buffsJson.Count > 0)
            {
                if(null != buffsJson)
                {
                    pMark = new GvGMark(buffsJson[0]);
                }
            }
        }
       
        FashionParam fashionParam;
        if (json.HasField("Fashion"))
        {
            JSONObject fashionJson = json.GetField("Fashion");
            fashionParam = new FashionParam(fashionJson);
        }
        else
        {
            fashionParam = default(FashionParam);
        }

        if (isHero)
        {
            HeroActorData hero = ActorData.CreatePlayerActor(uid, baseId, level, usedSkills) as HeroActorData;            
            hero.IsMainRole = isMainRole;
            hero.StrengthLevel = strengthLevel;

            hero.SetProfessionId(jobId);
            hero.SetFashionData(fashionParam);
            hero.SetAllAttributes(baseFirstAttrs,additionalAttrs, attrPercent, extendAttrPercentDic);
            hero.PetId = petId;
            hero.HeadFrameId = headFrameId;
            hero.SetBuffs(usedBuffs);
            for (int idx = 0; idx < sencondAttrs.Length; idx++)
                hero.mServerAttrs[idx] = sencondAttrs[idx];
            if(null != pMark)
            {
                hero.SetPveMark(pMark);
            }
            return hero;
        }
        else if (isFellow)
        {
            FellowActorData fellow = CreateFellowActor(uid, baseId, level, usedSkills) as FellowActorData;
            fellow.IsMainRole = isMainRole;
            fellow.StrengthLevel = strengthLevel;
            fellow.SetAllAttributes(baseFirstAttrs,additionalAttrs, attrPercent, extendAttrPercentDic);
            fellow.IsTransferred = bIsTransferred;
            fellow.PetId = petId;
            fellow.SetBuffs(usedBuffs);          
            for (int idx = 0; idx < sencondAttrs.Length; idx++)
                fellow.mServerAttrs[idx] = sencondAttrs[idx];
            if (null != pMark)
            {
                fellow.SetPveMark(pMark);
            }
            return fellow;
        }
        else if(isPet)
        {
            PetActorData pet = CreatePetActor(uid, baseId, level, usedSkills) as PetActorData;
            pet.SetStep(advanceLevel);         
            for (int idx = 0; idx < sencondAttrs.Length; idx++)
                pet.mServerAttrs[idx] = sencondAttrs[idx];
            return pet;
        }
        else if (isBoss || isNpc)
        {
            if (BattleMgr.Instance.Battle != null)
            {
                Fighter f = BattleMgr.Instance.Battle.FighterMgr.GetFighterByID(uid, eTeamType.Enemy);
                if (f != null)
                {
                    f.Actor.SetLevel(level);
                    return f.Actor;
                }
            }

            ActorData npc = CreateNpcPlayerActor(uid, baseId, level);            
            npc.IsBoss = isBoss;
            npc.PositionValue = pos;
            npc.IgnoreLife = ignoreLife;
            return npc;
        }

        return null;
    }

    public static ActorData CreateNpcPlayerActor(long uid,int baseId, int level)
    {
        ActorData actor = new NpcActorData(baseId);
        actor.Initialize(baseId, level,null);
        actor.ID = uid;
        return actor;
    }

    public static ActorData CreateNpcPlayerActor(int mapId,int levelId,int pos,int baseId, int level)
    {
        ActorData actor = new NpcActorData(baseId);
        actor.Initialize(baseId, level, null);
        actor.ID = CommonUtil.CalcNpcUniqueId(mapId,levelId,pos,baseId);
        return actor;
    }

    public static ActorData CreateFellowActor(ActorParam actorParam)
    {
        if (actorParam == null) return null;

        if (actorParam.uid == 0 || actorParam.baseId == 0) return null;

        FellowActorData hero = CreateFellowActor(actorParam.uid, actorParam.baseId, actorParam.level, actorParam.skills) as FellowActorData;
        hero.IsMainRole = false;
        hero.StrengthLevel = actorParam.strengthLevel;
        hero.SetBuffs(actorParam.buffs);

        return hero;
    }

    public static ActorData CreateFellowActor(int id)
    {
        return CreateFellowActor(0,id, 1,null);
    }

    public static ActorData CreateFellowActor(long uid, int baseId,int level, SkillParam[] usedSkills)
    {
        ActorData actor = new FellowActorData(baseId);
        actor.Initialize(baseId, level,usedSkills);
        actor.ID = uid > 0 ? uid:baseId;
        return actor;
    }

    public static ActorData CreatePetActor(ActorParam actorParam)
    {
        if (actorParam == null) return null;

        if (actorParam.uid == 0 || actorParam.baseId == 0) return null;

        PetActorData pet = CreatePetActor(actorParam.uid, actorParam.baseId, actorParam.level, actorParam.skills) as PetActorData;
        return pet;
    }

    public static ActorData CreatePetActor(long uid, int baseId, int level, SkillParam[] usedSkills)
    {
        ActorData actor = new PetActorData(baseId);
        actor.Initialize(baseId, level, usedSkills);
        actor.ID = uid > 0 ? uid : baseId;
        return actor;
    }

    public static ActorData CreatePetBossActor(long uid, int baseId, int level)
    {
        ActorData actor = new PetBossActorData(baseId);
        actor.Initialize(baseId, level, null);
        actor.ID = uid > 0 ? uid : baseId;
        return actor;
    }

    public static ActorData CreatePlayerActor(LuaTable tblParam)
    {
        if (tblParam == null) return null;

        ActorParam actorParam = new ActorParam();

        if (tblParam["uid"] != null)
            int.TryParse(tblParam["uid"].ToString(), out actorParam.uid);

        if (tblParam["id"] != null)
            int.TryParse(tblParam["id"].ToString(), out actorParam.baseId);

        if (tblParam["lv"] != null)
            int.TryParse(tblParam["lv"].ToString(), out actorParam.level);

        if (tblParam["jobId"] != null)
            int.TryParse(tblParam["jobId"].ToString(), out actorParam.jobId);

        if (tblParam["mainRole"] != null)
            bool.TryParse(tblParam["mainRole"].ToString(), out actorParam.isMainRole);

        List<SkillParam> skillParams = null;
        if (tblParam["skills"] != null)
        {
            LuaTable skills = (LuaTable)tblParam["skills"];
            skillParams = ParseSkillParam(skills);
            actorParam.skills = skillParams != null ? skillParams.ToArray() : null;
        }

        if (tblParam["buffs"] != null)
        {
            List<BuffParam> buffs = ParseBuffParam((LuaTable)tblParam["buffs"]);
            actorParam.buffs = buffs != null ? buffs.ToArray() : null;
        }
        actorParam.strengthLevel = 7;

        return CreatePlayerActor(actorParam);
    }

    public static ActorData CreatePlayerActor(ActorParam actorParam)
    {
        if (actorParam == null) return null;

        if (actorParam.uid == 0 || actorParam.baseId == 0) return null;

        HeroActorData hero = ActorData.CreatePlayerActor(actorParam.uid, actorParam.baseId, actorParam.level, actorParam.skills) as HeroActorData;
        hero.IsMainRole = actorParam.isMainRole;
        hero.StrengthLevel = actorParam.strengthLevel;
        hero.HeadFrameId = actorParam.headFrameId;

        hero.SetProfessionId(actorParam.jobId);
        hero.SetFashionData(actorParam.fashion);
        hero.SetBuffs(actorParam.buffs);

        return hero;
    }

    public static ActorData CreatePlayerActor(int id)
    {
        return CreatePlayerActor(0, id, 1, null);
    }

    public static ActorData CreatePlayerActor(long uid, int baseId, int level, SkillParam[] usedSkills)
    {
        HeroActorData actor = new HeroActorData(baseId);
        actor.Initialize(baseId, level, usedSkills);
        actor.ID = uid > 0 ? uid : baseId;
        return actor;
    }

    public static List<SkillParam> ParseSkillParam(LuaTable param)
    {
        if (param == null) return null;

        List<SkillParam> skillParams = new List<SkillParam>();
        for (int sdx = 1; sdx <= param.Length; sdx++)
        {
            LuaTable skill = (LuaTable)param[sdx];
            int skillId = 0, skillLv = 0,rate = 100;

            if (skill["skillId"] != null)
                int.TryParse(skill["skillId"].ToString(), out skillId);

            if (skill["lv"] != null)
                int.TryParse(skill["lv"].ToString(), out skillLv);

            if (skill["rate"] != null)
                int.TryParse(skill["rate"].ToString(), out rate);

            if (skillId == 0 || skillLv == 0) continue;

            SkillParam sp = new SkillParam(skillId, skillLv,rate);
            skillParams.Add(sp);
        }

        return skillParams;
    }
    
    public static List<BuffParam> ParseBuffParam(LuaTable param)
    {
        if (param == null) return null;

        List<BuffParam> buffs = new List<BuffParam>();
        for (int idx = 1; idx <= param.Length; idx++)
        {
            LuaTable buff = (LuaTable)param[idx];

            int buffId = 0, ratio = 0, cd = 0;
            int type = 0, casterType = 0;
            if (buff.Length >= 1)
            {
                int.TryParse(buff[1].ToString(), out buffId);
            }

            if (buff.Length >= 2)
            {
                int.TryParse(buff[2].ToString(), out ratio);
            }

            if (buff.Length >= 3)
            {
                int.TryParse(buff[3].ToString(), out cd);
            }

            if (buff.Length >= 4)
            {
                int temp = 0;
                int.TryParse(buff[4].ToString(), out temp);
                type = temp;
            }

            if(buff.Length >= 5)
            {
                int temp = 0;
                int.TryParse(buff[5].ToString(), out temp);
                casterType = temp;
            }

            if (buffId == 0 || ratio == 0) continue;

            BuffParam buffData = new BuffParam(buffId, ratio, cd, type);
            buffs.Add(buffData);
        }
        return buffs;
    }
    #endregion

    #region json_methods
    public virtual JSONObject ToJson()
    {
        JSONObject json = new JSONObject();
        json.AddField("Base", BaseToJson());
        json.AddField("Attrs", AttrToJson());
        json.AddField("Skills", SkillToJson());
        json.AddField("Buffs", BuffToJson());
        json.AddField("Mark", MarkToJson());
        json.AddField("Fashion", FashionToJson());
        return json;
    }

    protected virtual JSONObject BaseToJson()
    {
        JSONObject json = new JSONObject();
        json.AddField("id", ID);
        json.AddField("bId", BaseId);
        json.AddField("lv", Level);
        json.AddField("m", IsMainRole);
        json.AddField("h", IsHero);
        json.AddField("f", IsFellow);
        json.AddField("b", IsBoss);
        json.AddField("n", IsNpc);
        json.AddField("p", IsPet);
        json.AddField("frameId",HeadFrameId);
        json.AddField("strengthLevel", StrengthLevel);
        json.AddField("petId", PetData != null ? PetData.ID : 0);
        json.AddField("pos", PositionValue);
        json.AddField("IsTransferred", IsTransferred);
        if (IgnoreLife) json.AddField("ignoreLife", IgnoreLife);
        return json;
    }

    protected virtual JSONObject AttrToJson()
    {
        JSONObject json = new JSONObject();

        JSONObject baseFirstAttrJson = new JSONObject();
        for(int idx = ActorData.Attr_STR; idx <= ActorData.Attr_LUK;idx++)
        {
            baseFirstAttrJson.Add(GetBaseFirstAttr(idx));
        }
        json.AddField("baseFirstAttr", baseFirstAttrJson);

        if (mServerAttrs != null)
        {
            JSONObject serverSecondAttrJson = new JSONObject();
            for (int idx = 0; idx < mServerAttrs.Length; idx++)
            {
                //Debug.Log("Save idx "+ idx.ToString() +" "+ mServerAttrs[idx].ToString());
                serverSecondAttrJson.Add(mServerAttrs[idx]);
            }
            json.AddField("serverSecondAttr", serverSecondAttrJson);
        }

        if (mAdditionalAttrs != null)
        {
            JSONObject additionalAttrJson = new JSONObject();
            for (int idx = 0; idx < s_AttrNum; idx++)
            {
                additionalAttrJson.Add(mAdditionalAttrs[idx]);
            }
            json.AddField("additionalAttr", additionalAttrJson);
        }

        if (mAttrPercent != null)
        {
            JSONObject attrPercentJson = new JSONObject();
            for (int idx = 0; idx < s_AttrNum; idx++)
            {
                attrPercentJson.Add(mAttrPercent[idx]);
            }
            json.AddField("attrPercent", attrPercentJson);
        }

        if (mExtendAttrPercentDic != null)
        {
            JSONObject extendAttrJson = new JSONObject();
            foreach (var p in mExtendAttrPercentDic)
            {
                JSONObject temp = new JSONObject();
                temp.Add(p.Key);
                temp.Add(p.Value);
                extendAttrJson.Add(temp);
            }
            json.AddField("extendAttr", extendAttrJson);
        }

        return json;
    }

    protected virtual JSONObject SkillToJson()
    {
        JSONObject json = new JSONObject();
        if(SkillMgr!=null)
        {
            if(SkillMgr.Skills != null)
            {
                for (int idx = 0; idx < SkillMgr.Skills.Length; idx++)
                {
                    json.Add(SkillMgr.Skills[idx].ToJson());
                }
            }
            
            if(SkillMgr.RandomSkills != null)
            {
                for(int idx = 0; idx < SkillMgr.RandomSkills.Count;idx++)
                {
                    json.Add(SkillMgr.RandomSkills[idx].ToJson());
                }
            }

            if(SkillMgr.PassiveSkills != null)
            {
                for(int idx =0; idx < SkillMgr.PassiveSkills.Count;idx++)
                {
                    json.Add(SkillMgr.PassiveSkills[idx].ToJson());
                }
            }
        }
        return json;
    }

    protected virtual JSONObject MarkToJson()
    {
        JSONObject json = new JSONObject();
        if (PveMark != null)
        {
            json.Add(PveMark.ToJson());            
        }
        return json;
    }

    protected virtual JSONObject BuffToJson()
    {
        JSONObject json = new JSONObject();
        if (mBuffListParam != null)
        {
            for (int idx = 0; idx < mBuffListParam.Length; idx++)
            {
                json.Add(mBuffListParam[idx].ToJson());
            }
        }
        return json;
    }

    protected virtual JSONObject FashionToJson()
    {
        JSONObject json = new JSONObject();
        return json;
    }
    #endregion
}
