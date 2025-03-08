using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class FellowActorData : ActorData
{
    const int mInitSTR = 1;
    const int mInitAGI = 1;
    const int mInitINT = 1;
    const int mInitLUK = 1;
    const int mInitDEX = 1;
    const int mInitVIT = 1;
    protected FellowBaseData mBaseData;

    public FellowBaseData BaseData { get { return mBaseData; } }

    private int mStep = 0;
    public int Step
    {
        get { return mStep; }
    }

    public override bool IsFellow
    {
        get { return true; }
    }

    public override int AvatarID
    {
        get
        {
            return mBaseData.AvatarId;
        }
    }

    private string mName;
    public override string Name
    {
        get { return mName; }
    }

    public override string Description
    {
        get { return mBaseData.Desc; }
    }

    public override ProfessionType Profession
    {
        get { return (ProfessionType)mBaseData.JobType; }
    }

    public override int JobStage
    {
        get
        {
            return mBaseData.JobStage;
        }
    }

    public override int JobBranch
    {
        get
        {
            return mBaseData.JobBranch;
        }
    }

    public override int PositionValue
    {
        get { return mBaseData.Position; }
    }

    public override int NatureId
    {
        get
        {
            return mBaseData.NatureId;
        }
    }

    public override string SkillFrameEventName { get { return mBaseData.frameEventName; } }

    public override string ProfessionIcon
    {
        get
        {
            return mBaseData != null ? mBaseData.ProfessionIcon : "";
        }
    }

    public override string HeadIcon
    {
        get { return mBaseData.HeadIcon; }
        set { }
    }

    public override string BattleBigIcon
    {
        get { return mBaseData.battleBigIcon; }
    }

    public override string AnimCtrlName
    {
        get { return mBaseData.BattleAnimCtrl; }
    }

    public override string ShowAnimCtrlName
    {
        get { return mBaseData.ShowAnimCtrl; }
    }

    #region OVERRIDE_PROPERTIES

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
        get
        {
            return (SInt)((mBaseSTR + (Level - 1) * mBaseData.STRRate) + GetAdditionalAttr(Attr_STR));
        }
    }

    public override SInt AGI
    {
        get
        {
            return (SInt)((mBaseAGI + (Level - 1) * mBaseData.AGIRate) + GetAdditionalAttr(Attr_AGI));
        }
    }

    public override SInt INT
    {
        get
        {
            return (SInt)((mBaseINT + (Level - 1) * mBaseData.INTRate) + GetAdditionalAttr(Attr_INT));
        }
    }

    public override SInt VIT
    {
        get
        {
            return (SInt)((mBaseVIT + (Level - 1) * mBaseData.VITRate) + GetAdditionalAttr(Attr_VIT));
        }
    }

    public override SInt DEX
    {
        get
        {
            return (SInt)((mBaseDEX + (Level - 1) * mBaseData.DEXRate) + GetAdditionalAttr(Attr_DEX));
        }
    }

    public override SInt LUK
    {
        get
        {
            return (SInt)((mBaseLUK + (Level - 1) * mBaseData.LUCKRate) + GetAdditionalAttr(Attr_LUK));
        }
    }

    public override SFloat BaseLife
    {
        get
        {
            SFloat a = BattleFormulaParamMgr.Instance.GetParam(1);
            SFloat p1 = BattleFormulaParamMgr.Instance.GetParam(31);
            SFloat p2 = BattleFormulaParamMgr.Instance.GetParam(32);
            SFloat baseLife = mBaseData.GetAttr(Attr_Life) + p1 * (mLevel * mLevel - 1) + p2 * (mLevel - 1);
            return baseLife * (1 + VIT * a);
        }
    }

    public override SFloat BaseSp
    {
        get
        {
            SFloat a = BattleFormulaParamMgr.Instance.GetParam(2);
            SFloat p1 = BattleFormulaParamMgr.Instance.GetParam(33);
            SFloat p2 = BattleFormulaParamMgr.Instance.GetParam(34);

            float baseSp = mBaseData.GetAttr(Attr_Sp) + p1 * (mLevel * mLevel - 1) + p2 * (mLevel - 1);
            return baseSp * (1 + INT * a);
        }
    }

    public override SFloat BaseAttack
    {
        get
        {
            SFloat attack = mBaseData.GetAttr(Attr_Attack);
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
            SFloat magicAttack = mBaseData.GetAttr(Attr_MagicAttack);
            magicAttack += INT * a + b * Mathf.Pow(Mathf.FloorToInt(INT * 0.1f), 2);

            return magicAttack;
        }
    }

    public override SFloat BaseDefense
    {
        get
        {
            SFloat a = BattleFormulaParamMgr.Instance.GetParam(9);
            SFloat defense = mBaseData.GetAttr(Attr_Defense);
            defense = defense + a * VIT;
            return defense;
        }
    }

    public override SFloat BaseMagicDefense
    {
        get
        {
            SFloat a = BattleFormulaParamMgr.Instance.GetParam(10);
            SFloat magicDef = mBaseData.GetAttr(Attr_MagicDefense);
            magicDef = magicDef + a * INT;
            return magicDef;
        }
    }

    public override SFloat BaseDodge
    {
        get
        {
            SFloat a = BattleFormulaParamMgr.Instance.GetParam(11);
            SFloat dodge = mBaseData.GetAttr(Attr_Dodge) + a * AGI;
            return dodge;
        }
    }

    public override SFloat BaseHit
    {
        get
        {
            SFloat a = BattleFormulaParamMgr.Instance.GetParam(12);
            SFloat hit = mBaseData.GetAttr(Attr_Hit) + a * DEX;
            return hit;
        }
    }

    public override SFloat BaseCrit
    {
        get
        {
            SFloat a = BattleFormulaParamMgr.Instance.GetParam(13);
            SFloat crit = mBaseData.GetAttr(Attr_Crit) + a * LUK;
            return crit;
        }
    }

    public override SFloat BaseTen
    {
        get
        {
            SFloat a = BattleFormulaParamMgr.Instance.GetParam(14);
            SFloat ten = mBaseData.GetAttr(Attr_Ten) + a * LUK; ;
            return ten;
        }
    }

    public override SFloat BaseAttackSpeed
    {
        get
        {
            return mBaseData.AttackSpeed;
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
    #endregion

    public FellowActorData(int id) : base(id)
    {
        mActorType = ActorType.Fellow;
    }

    public void SetStep(int step)
    {
        if (mStep == step) return;

        mStep = step;
    }

    public override void Initialize(int id, int level, SkillParam[] usedSkills)
    {
        base.Initialize(id, level, usedSkills);

        Gender = (int)Role_Gender.Male;
        mBaseData = new FellowBaseData(id);
        mAvatarData = new AvatarData(AvatarID);
        mName = I18N.T(mBaseData.Name);
        if (mSkillMgr == null)
        {
            mSkillMgr = new SkillManager(this);
        }

        if (usedSkills != null)
        {
            mSkillMgr.InitializeSkill(mBaseData.NormalSkillIds, usedSkills);
        }
        else
        {
            mSkillMgr.InitializeSkill(mBaseData.NormalSkillIds, mBaseData.SkillIds);
        }

        if (mBaseData.AlternativeSkills != null && mBaseData.AlternativeSkills.Length > 0)
        {
            mSkillMgr.InitAlternativeSkills(mBaseData.AlternativeSkills);
        }

        ResetFirstSkill();
        valid = mBaseData.valid && mAvatarData.valid;
    }

    public override void RefreshSkills(SkillParam[] usedSkills)
    {
        if (usedSkills != null)
        {
            mSkillMgr.InitializeSkill(mBaseData.NormalSkillIds, usedSkills);
        }
    }

    public override void Dispose()
    {
        if (mBaseData != null)
        {
            mBaseData.Dispose();
            mBaseData = null;
        }

        base.Dispose();
    }
}
