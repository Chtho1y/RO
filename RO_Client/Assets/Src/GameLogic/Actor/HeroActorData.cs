using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class HeroActorData : ActorData
{
    private string mHeadIcon;
    protected RoleBaseData mBaseData;

    protected RoleAttributeData mAttrData;

    protected ProfessionData mProfessionData;

    public RoleBaseData BaseData { get { return mBaseData; } }

    public RoleAttributeData AttrData { get { return mAttrData; } }

    public ProfessionData ProfessionData { get { return mProfessionData; } }

    private int mProfessionId = 0;

    public int ProfessionId
    {
        get { return mProfessionId; }
    }

    private SkillParam[] mUsedSkills = null;

    private Dictionary<BodyPart, string> mPartResList = null;

    private FashionParam mFashionData;

    public Dictionary<BodyPart, string> PartResList
    {
        get { return mPartResList; }
    }

    public FashionParam FashionData
    {
        get { return mFashionData; }
    }

    public override string AnimCtrlName
    {
        get { return mBaseData != null ? mBaseData.BattleCtrlPath : ""; }
    }

    public override string ShowAnimCtrlName
    {
        get { return mBaseData != null ? mBaseData.ShowCtrlPath : ""; }
    }

    public override string ProfessionIcon
    {
        get
        {
            return mProfessionData != null ? mProfessionData.Icon : "";
        }
    }

    public override string HeadIcon
    {
        get { return mBaseData.headId; }
        set { }
    }

    public override string BattleBigIcon
    {
        get { return mBaseData.battleBigIcon; }
    }

    #region OVERRIDE_PROPERTIES
    public override string SkillFrameEventName
    {
        get { return mBaseData.frameEventName; }
    }

    public override int NatureId
    {
        get { return mProfessionData.NatureId; }
    }

    public override SFloat BaseLife
    {
        get
        {
            if (mAttrData == null) return 0;

            SFloat a = BattleFormulaParamMgr.Instance.GetParam(1);
            return mAttrData.GetAttr(Attr_Life) * mProfessionData.HpRate * (1 + VIT * a);
        }
    }

    public override SFloat BaseSp
    {
        get
        {
            if (mAttrData == null) return 0;

            SFloat a = BattleFormulaParamMgr.Instance.GetParam(2);
            return mAttrData.GetAttr(Attr_Sp) * mProfessionData.SpRate * (1 + INT * a);
        }
    }

    public override SFloat BaseAttack
    {
        get
        {
            SFloat attack = mAttrData.GetAttr(Attr_Attack) * mProfessionData.AtkRate;
            if (IsFront)
            {
                SFloat a = BattleFormulaParamMgr.Instance.GetParam(3);
                SFloat b = BattleFormulaParamMgr.Instance.GetParam(4);
                SFloat c = BattleFormulaParamMgr.Instance.GetParam(35);
                attack += a * (STR + c * DEX + c * LUK) + b * Mathf.Pow(Mathf.FloorToInt(STR * 0.1f), 2);
            }
            else
            {
                SFloat a = BattleFormulaParamMgr.Instance.GetParam(5);
                SFloat b = BattleFormulaParamMgr.Instance.GetParam(6);
                SFloat c = BattleFormulaParamMgr.Instance.GetParam(36);
                attack += a * (DEX + c * STR + c * LUK) + b * Mathf.Pow(Mathf.FloorToInt(DEX * 0.1f), 2);
            }
            return attack;
        }
    }

    public override SFloat BaseMagicAttack
    {
        get
        {
            SFloat a = BattleFormulaParamMgr.Instance.GetParam(7), b = BattleFormulaParamMgr.Instance.GetParam(8);
            SFloat magicAttack = mAttrData.GetAttr(Attr_MagicAttack) * mProfessionData.MagicAtkRate;
            magicAttack += INT * a + b * Mathf.Pow(Mathf.FloorToInt(INT * 0.1f), 2);

            return magicAttack;
        }
    }

    public override SFloat BaseDefense
    {
        get
        {
            SFloat a = BattleFormulaParamMgr.Instance.GetParam(9);
            SFloat defense = mAttrData.GetAttr(Attr_Defense) * mProfessionData.DefRate;
            defense = defense + a * VIT;
            return defense;
        }
    }

    public override SFloat BaseMagicDefense
    {
        get
        {
            SFloat a = BattleFormulaParamMgr.Instance.GetParam(10);
            SFloat magicDef = mAttrData.GetAttr(Attr_MagicDefense) * mProfessionData.MagicDefRate;
            magicDef = magicDef + a * INT;
            return magicDef;
        }
    }

    public override SFloat BaseDodge
    {
        get
        {
            SFloat a = BattleFormulaParamMgr.Instance.GetParam(11);
            SFloat dodge = mAttrData.GetAttr(Attr_Dodge) * mProfessionData.DodgeRate + a * AGI;
            return dodge;
        }
    }

    public override SFloat BaseHit
    {
        get
        {
            SFloat a = BattleFormulaParamMgr.Instance.GetParam(12);
            SFloat hit = mAttrData.GetAttr(Attr_Hit) * mProfessionData.HitRate + a * DEX;
            return hit;
        }
    }

    public override SFloat BaseCrit
    {
        get
        {
            SFloat a = BattleFormulaParamMgr.Instance.GetParam(13);
            SFloat crit = mAttrData.GetAttr(Attr_Crit) * mProfessionData.CritRate + a * LUK;

            return crit;
        }
    }

    public override SFloat BaseTen
    {
        get
        {
            SFloat a = BattleFormulaParamMgr.Instance.GetParam(14);
            SFloat ten = mAttrData.GetAttr(Attr_Ten) * mProfessionData.TenacityRate + a * LUK;
            return ten;
        }
    }

    public override SFloat BaseAttackSpeed
    {
        get
        {
            return mProfessionData.AttackSpeed;
        }
    }

    public override SFloat Life
    {
        get
        {
            SFloat ServerData = GetSeverSecondAttr(Attr_Life);
            if (0 <= ServerData)
                return ServerData;
            return LocalLife;
        }
    }

    public override SFloat Sp
    {
        get
        {
            SFloat ServerData = GetSeverSecondAttr(Attr_Sp);
            if (0 <= ServerData)
                return ServerData;
            return LocalSp;
        }
    }

    /// <summary>
	/// 物攻
	/// </summary>
	public override SFloat Attack
    {
        get
        {
            SFloat ServerData = GetSeverSecondAttr(Attr_Attack);
            if (0 <= ServerData)
                return ServerData;
            return LocalAttack;
        }
    }

    public override SFloat MagicAttack
    {
        get
        {
            SFloat ServerData = GetSeverSecondAttr(Attr_MagicAttack);
            if (0 <= ServerData)
                return ServerData;
            return LocalMagicAttack;
        }
    }

    /// <summary>
	/// 物防
	/// </summary>
	public override SFloat Defense
    {
        get
        {
            SFloat ServerData = GetSeverSecondAttr(Attr_Defense);
            if (0 <= ServerData)
                return ServerData;
            return LocalDefense;
        }
    }

    //魔防
    public override SFloat MagicDefense
    {
        get
        {
            SFloat ServerData = GetSeverSecondAttr(Attr_MagicDefense);
            if (0 <= ServerData)
                return ServerData;
            return LocalMagicDefense;
        }
    }

    public override SFloat Hit
    {
        get
        {
            SFloat ServerData = GetSeverSecondAttr(Attr_Hit);
            if (0 <= ServerData)
                return ServerData;
            return LocalHit;
        }
    }

    public override SFloat Crit
    {
        get
        {
            SFloat ServerData = GetSeverSecondAttr(Attr_Crit);
            if (0 <= ServerData)
                return ServerData;
            return LocalCrit;
        }
    }

    public override SFloat Dodge
    {
        get
        {
            SFloat ServerData = GetSeverSecondAttr(Attr_Dodge);
            if (0 <= ServerData)
                return ServerData;
            return LocalDodge;
        }
    }

    public override SFloat Ten
    {
        get
        {
            SFloat ServerData = GetSeverSecondAttr(Attr_Ten);
            if (0 <= ServerData)
                return ServerData;
            return LocalTen;
        }
    }

    public override SFloat LocalAttackSpeed 
    {
        get
        {
            SFloat a = BattleFormulaParamMgr.Instance.GetParam(24);
            SFloat b = BattleFormulaParamMgr.Instance.GetParam(25);
            SFloat attackSpeed = (BaseAttackSpeed + GetAdditionalAttr(Attr_AttackSpeed)) * (1 + GetAdditionalAttrPercent(Attr_AttackSpeed_Percent)) + AGI * a + DEX * b;
            return attackSpeed;
        }
    }

    //攻击速度
    public override SFloat AttackSpeed
    {
        get
        {
            SFloat ServerData = GetSeverSecondAttr(Attr_AttackSpeed);
            if (0 <= ServerData)
                return ServerData;
            return LocalAttackSpeed;
        }
    }

    public override SFloat LocalCastAcceleration
    {
        get
        {
            SFloat a = BattleFormulaParamMgr.Instance.GetParam(28);
            SFloat CastAccelerationSpeed = DEX * a * 1000;//毫秒
            return CastAccelerationSpeed;
        }
    }

    //施法速度
    public override SFloat CastAcceleration
    {
        get
        {
            SFloat ServerData = GetSeverSecondAttr(Attr_CastAcceleration);
            if (0 <= ServerData)
                return ServerData;
            return LocalCastAcceleration;
        }
    }
    //神威值
    public override SFloat GodPower
    {
        get
        {
            SFloat ServerData = GetSeverSecondAttr(Attr_GodPow);
            if (0 <= ServerData)
                return ServerData;
            return LocalGodPower;
        }
    }

    public override bool IsHero
    {
        get { return true; }
    }

    public override int AvatarID
    {
        get
        {
            return mBaseData.avatarId;
        }
    }

    private string mName;
    public override string Name
    {
        get { return mName; }
        set
        {
            mName = value;
        }
    }

    public override string Description
    {
        get { return mBaseData.Desc; }
    }

    public override ProfessionType Profession
    {
        get { return (ProfessionType)mProfessionData.ProfessionType; }
    }

    public override int JobStage
    {
        get { return mProfessionData.Step; }
    }

    public override int JobBranch
    {
        get { return mProfessionData.ProfessionBranch; }
    }

    public override int PositionValue
    {
        get { return mProfessionData.Position; }
    }

    private SInt mBaseSTR = 1;
    public override SInt BaseSTR
    {
        get { return mBaseSTR; }
        set { mBaseSTR = value; }
    }

    private SInt mBaseAGI = 1;
    public override SInt BaseAGI
    {
        get { return mBaseAGI; }
        set { mBaseAGI = value; }
    }

    private SInt mBaseINT = 1;
    public override SInt BaseINT
    {
        get { return mBaseINT; }
        set { mBaseINT = value; }
    }

    private SInt mBaseVIT = 1;
    public override SInt BaseVIT
    {
        get { return mBaseVIT; }
        set { mBaseVIT = value; }
    }

    private SInt mBaseDEX = 1;
    public override SInt BaseDEX
    {
        get { return mBaseDEX; }
        set { mBaseDEX = value; }
    }

    private SInt mBaseLUK = 1;
    public override SInt BaseLUK
    {
        get { return mBaseLUK; }
        set { mBaseLUK = value; }
    }

    public override SInt STR
    {
        get { return mBaseSTR + (int)GetAdditionalAttr(Attr_STR); }
    }

    public override SInt AGI
    {
        get { return mBaseAGI + (int)GetAdditionalAttr(Attr_AGI); }
    }

    public override SInt INT
    {
        get { return mBaseINT + (int)GetAdditionalAttr(Attr_INT); }
    }

    public override SInt VIT
    {
        get { return mBaseVIT + (int)GetAdditionalAttr(Attr_VIT); }
    }

    public override SInt DEX
    {
        get { return mBaseDEX + (int)GetAdditionalAttr(Attr_DEX); }
    }

    public override SInt LUK
    {
        get { return mBaseLUK + (int)GetAdditionalAttr(Attr_LUK); }
    }
    #endregion

    public HeroActorData(int id) : base(id)
    {
        mActorType = ActorType.Hero;
    }

    public override void Dispose()
    {
        if (mAttrData != null)
        {
            mAttrData.Dispose();
            mAttrData = null;
        }

        if (mProfessionData != null)
        {
            mProfessionData.Dispose();
            mProfessionData = null;
        }

        base.Dispose();
    }

    public override void Initialize(int id, int level, SkillParam[] usedSkills)
    {
        base.Initialize(id, level, usedSkills);

        mBaseData = new RoleBaseData(id);
        mAttrData = new RoleAttributeData(mLevel);
        mAvatarData = new AvatarData(AvatarID);
        mUsedSkills = usedSkills;
        Gender = mBaseData.sex;
    }

    public override void SetLevel(int lv)
    {
        if(mLevel != lv)
        {
            mLevel = lv;
            mAttrData = new RoleAttributeData(mLevel);
        }
    }

    public void SetProfessionId(int id,bool needLoadSkill = false)
    {
        if (mProfessionId == id) return;

        mProfessionId = id;
        mProfessionData = new ProfessionData(id);

        if (mSkillMgr == null)
            mSkillMgr = new SkillManager(this);

        if (mUsedSkills != null)
        {
           mSkillMgr.InitializeSkill(mProfessionData.NormalSkillIds, mUsedSkills);
        }
        else
        {
            mSkillMgr.InitializeSkill(mProfessionData.NormalSkillIds, mProfessionData.SkillIds);
        }

        if(mProfessionData.AlternativeSkills != null && mProfessionData.AlternativeSkills.Length > 0)
        {
            mSkillMgr.InitAlternativeSkills(mProfessionData.AlternativeSkills);
        }

        ResetFirstSkill();
        valid = mBaseData.valid && mProfessionData.valid && mAttrData.valid && mAvatarData.valid;
        if(needLoadSkill)
        {
            mSkillMgr.LoadSkills();
            mSkillMgr.LoadNorlSkills();
        }
    }


    public override void RefreshSkills(SkillParam[] usedSkills)
    {
        if (usedSkills != null)
        {
            mUsedSkills = usedSkills;
            mSkillMgr.InitializeSkill(mProfessionData.NormalSkillIds, mUsedSkills);
        }
    }

    public void SetFashionData(FashionParam fashionData)
    {
        mFashionData = fashionData;
        ParseFashionPartRes();
    }

    public BodyPartParam GetBodyPartParam(BodyPart part)
    {
        if (mFashionData.parts == null) return default(BodyPartParam);

        for(int idx = 0; idx < mFashionData.parts.Length;idx++)
        {
            if (mFashionData.parts[idx].part == (int)part) return mFashionData.parts[idx];
        }

        return default(BodyPartParam);
    }

    private void ParseFashionPartRes()
    {
        if (mPartResList == null)
            mPartResList = new Dictionary<BodyPart, string>();
        else
            mPartResList.Clear();

        if (mBaseData == null) return;

        int cfgId = 0;
        if (Gender == (int)Role_Gender.Male)
        {
            cfgId = GlobalConfig.c_man_base_model_path;
        }
        else if (Gender == (int)Role_Gender.Female)
        {
            cfgId = GlobalConfig.c_woman_base_model_path;
        }

        //基础骨骼
        string baseBonePrefab = GlobalConfig.Instance.GetConfigStrValue(cfgId);
        if (!string.IsNullOrEmpty(baseBonePrefab))
            mPartResList.Add(BodyPart.Skeleton, baseBonePrefab);

        //脸部
        string facePrefab = null;
        if (Gender == (int)Role_Gender.Male)
        {
            facePrefab = GlobalConfig.Instance.GetConfigStrValue(GlobalConfig.c_man_face_model_path);
        }
        else
        {
            facePrefab = GlobalConfig.Instance.GetConfigStrValue(GlobalConfig.c_woman_face_model_path);
        }

        if (!string.IsNullOrEmpty(facePrefab))
        {
            mPartResList.Add(BodyPart.Face, facePrefab);
        }

        if (mFashionData.parts != null)
        {
            for(int idx =0; idx < mFashionData.parts.Length;idx++)
            {
                BodyPartParam part = mFashionData.parts[idx];

                //DebugHelper.LogError("part :" + part.part + " prefab:" + part.modelPrefab);
                if (string.IsNullOrEmpty(part.modelPrefab)) continue;

                mPartResList.Add((BodyPart)part.part, part.modelPrefab);
            }
        }
    }


    protected override JSONObject FashionToJson()
    {
        JSONObject json = mFashionData.ToJson();
        return json;
    }

    protected override JSONObject BaseToJson()
    {
        JSONObject json =  base.BaseToJson();
        json.AddField("jobId", mProfessionId);
        return json;
    }
}
