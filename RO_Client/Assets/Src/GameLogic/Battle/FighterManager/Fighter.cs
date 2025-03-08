using UnityEngine;
using System.Collections.Generic;

public struct stBuffParam
{
    public int teamSide;
    public long actorId;
    public bool isBoss;
    public string buffIcon;
    public int pointNum;

    public stBuffParam(eTeamType teamSide,long id, bool boss, string icon, int num)
    {
        this.teamSide = (int)teamSide;
        this.actorId = id;
        this.isBoss = boss;
        this.buffIcon = icon;
        this.pointNum = num;
    }
}

public struct PlayerActorBattleAttr
{
    public SFloat STR;
    public SFloat AGI;
    public SFloat INT;
    public SFloat VIT;
    public SFloat DEX;
    public SFloat LUK;

    public SFloat life;
    public SFloat sp;
    public SFloat minAttack;
    public SFloat attack;
    public SFloat minMagicAttack;
    public SFloat magic_attack;
    public SFloat defense;
    public SFloat magic_defense;
    public SFloat crit;
    public SFloat dodge;
    public SFloat hit;
    public SFloat ten;
    public SFloat attackSpeed;
    public SFloat GodPower;                  //真实伤害

    public SFloat defPercent;
    public SFloat magicDefPercent;

    public SFloat penetration;           //忽视物防
    public SFloat magic_penetration;     //忽视魔防

    public SFloat physicDamagePercent;   //物伤百分比
    public SFloat magicDamagePercent;    //魔法伤害百分比
    public SFloat antiPhysicDamPercent;  //抗物伤百分比
    public SFloat antiMagicDamPercent;   //抗魔防伤害百分比

    public SFloat critDamagePercent;     //暴击伤害百分比

    public SFloat physicDamageReflectPercent;    //物理伤害反射百分比
    public SFloat magicDamageReflectPercent;     //魔法伤害反射百分比
    public SFloat fixedSingTimePercent;          //固定吟唱时间修改百分比
    public SFloat variableSingTimePercent;       //可变吟唱时间修改百分比

    public SFloat[] natureDamagePercent;
    public SFloat[] antiNatureDamagePercent;
    public List<TriggerBuffData> triggerBuffs;
    public CastSkillData castSkillData;

    public void Init(ActorData actor, SFloat lifeRatio, int atkFactor, int magicAtkFactor, int hpFactor, int spFactor)
    {
        STR = actor.STR;
        AGI = actor.AGI;
        INT = actor.INT;
        VIT = actor.VIT;
        DEX = actor.DEX;
        LUK = actor.LUK;

        life = actor.Life * lifeRatio * (1 + hpFactor * 0.01f);
        //Debug.LogFormat(" Life Actor Id ={0} Final Hp = {1}  Svr HP = {2}", actor.ID.ToString(), actor.Life.ToString(),
        //    actor.GetSeverSecondAttr(ActorData.Attr_Life));
        sp = actor.Sp * (1 + spFactor * 0.01f);
        minAttack = actor.MinAttack * (1 + atkFactor * 0.01f);
        attack = actor.Attack * (1 + atkFactor * 0.01f);
        minMagicAttack = actor.MinMagicAttack * (1 + magicAtkFactor * 0.01f);
        magic_attack = actor.MagicAttack * (1 + magicAtkFactor * 0.01f);

        if (life < 0) life = 0;
        if (sp < 0) sp = 0;
        if (minAttack < 0) minAttack = 0;
        if (attack < 0) attack = 0;
        if (minMagicAttack < 0) minMagicAttack = 0;
        if (magic_attack < 0) magic_attack = 0;

        defense = actor.Defense;
        magic_defense = actor.MagicDefense;
        crit = actor.Crit;
        critDamagePercent = actor.CritDamagePercent;
        dodge = actor.Dodge;
        hit = actor.Hit;
        ten = actor.Ten;
        attackSpeed = actor.AttackSpeed;

        penetration = actor.Penetration;
        magic_penetration = actor.MagicPenetration;

        defPercent = actor.DefPercent;
        magicDefPercent = actor.MagicDefPercent;

        GodPower = actor.GodPower;  //GetAdditionalAttr(ActorData.Attr_GodPow);

        physicDamagePercent = actor.GetAdditionalAttrPercent(ActorData.Attr_PhysicDamage_Percent);
        magicDamagePercent = actor.GetAdditionalAttrPercent(ActorData.Attr_MagicDamage_Percent);
        antiPhysicDamPercent = actor.GetAdditionalAttrPercent(ActorData.Attr_Anti_PhysicDamage_Percent);
        antiMagicDamPercent = actor.GetAdditionalAttrPercent(ActorData.Attr_Anti_MagicDamage_Percent);

        physicDamageReflectPercent = actor.GetAdditionalAttrPercent(ActorData.Attr_PhysicDamageReflect_Percent);
        magicDamageReflectPercent = actor.GetAdditionalAttrPercent(ActorData.Attr_MagicDamageReflect_Percent);
        fixedSingTimePercent = actor.GetAdditionalAttrPercent(ActorData.Attr_FixedSingTime_Percent);
        variableSingTimePercent = actor.GetAdditionalAttrPercent(ActorData.Attr_VariableSingTime_Percent);
        castSkillData = actor.CastSkillParam;

        natureDamagePercent = new SFloat[(int)Nature_Type.Max - 1];
        antiNatureDamagePercent = new SFloat[(int)Nature_Type.Max - 1];
        for (int idx = (int)Nature_Type.None; idx < (int)Nature_Type.Max; idx++)
        {
            natureDamagePercent[idx - 1] = actor.GetAdditionalAttrPercent(70 + idx);
            antiNatureDamagePercent[idx - 1] = actor.GetAdditionalAttrPercent(80 + idx);
        }

        if (triggerBuffs == null)
            triggerBuffs = new List<TriggerBuffData>();
        else
            triggerBuffs.Clear();

        if (actor.TriggerBuffs != null)
        {
            triggerBuffs.AddRange(actor.TriggerBuffs);
        }

        if (actor.DropBuffList != null)
        {
            triggerBuffs.AddRange(actor.DropBuffList);
        }

        for (int idx = 0; idx < triggerBuffs.Count; idx++)
        {
            triggerBuffs[idx].ResetData();
        }

        //DebugLog(actor);
    }

    public void DebugLog(ActorData pActor)
    {
        string strLog = string.Format("名字 = {0} \n", pActor.Name);
        strLog += string.Format("STR 力量 = {0} \n", STR.ToString());
        strLog += string.Format("AGI 敏捷 = {0} \n", AGI.ToString());
        strLog += string.Format("INT 智力 = {0} \n", INT.ToString());
        strLog += string.Format("VIT 体质 = {0} \n", VIT.ToString());
        strLog += string.Format("DEX 灵巧 = {0} \n", DEX.ToString());
        strLog += string.Format("LUK 幸运 = {0} \n", LUK.ToString());

        strLog += string.Format("life 生命 = {0} \n", life.ToString());
        strLog += string.Format("sp 蓝量 = {0} \n", sp.ToString());
        strLog += string.Format("minAttack 最小物攻 = {0} \n", minAttack.ToString());
        strLog += string.Format("attack 物攻 = {0} \n", attack.ToString());
        strLog += string.Format("minMagicAttack 最少魔攻 = {0} \n", minMagicAttack.ToString());
        strLog += string.Format("magic_attack 魔攻 = {0} \n", magic_attack.ToString());

        strLog += string.Format("defense 物防 = {0} \n", defense.ToString());
        strLog += string.Format("magic_defense 魔防 = {0} \n", magic_defense.ToString());
        strLog += string.Format("crit 暴击 = {0} \n", crit.ToString());
        strLog += string.Format("critDamagePercent 暴击伤害百分比 = {0} \n", critDamagePercent.ToString());
        strLog += string.Format("dodge 闪避 = {0} \n", dodge.ToString());
        strLog += string.Format("hit 命中 = {0} \n", hit.ToString());
        strLog += string.Format("Ten 韧性 = {0} \n", ten.ToString());
        strLog += string.Format("AttackSpeed 攻击速度 = {0} \n", attackSpeed.ToString());

        strLog += string.Format("penetration 忽视物防 = {0} \n", penetration.ToString());
        strLog += string.Format("magic_penetration 忽视魔防 = {0} \n", magic_penetration.ToString());
        strLog += string.Format("defPercent 物防百分比 = {0} \n", defPercent.ToString());
        strLog += string.Format("magicDefPercent 魔防百分比 = {0} \n", magicDefPercent.ToString());
        strLog += string.Format("GodPower 神威值 = {0} \n", GodPower.ToString());
        strLog += string.Format("physicDamagePercent 物伤加成/减免百分比 = {0} \n", physicDamagePercent.ToString());
        strLog += string.Format("magicDamagePercent 魔伤加成/魔免百分比 = {0} \n", magicDamagePercent.ToString());
        strLog += string.Format("antiPhysicDamPercent 物抗伤加成 = {0} \n", antiPhysicDamPercent.ToString());
        strLog += string.Format("antiMagicDamPercent 魔抗伤加成 = {0} \n", antiMagicDamPercent.ToString());

        strLog += string.Format("physicDamageReflectPercent 物理伤害反射百分比 = {0} \n", physicDamageReflectPercent.ToString());
        strLog += string.Format("magicDamageReflectPercent 魔法伤害反射百分比 = {0} \n", magicDamageReflectPercent.ToString());
        strLog += string.Format("fixedSingTimePercent 固定吟唱时间修改百分比 = {0} \n", fixedSingTimePercent.ToString());
        strLog += string.Format("variableSingTimePercent 可变吟唱时间修改百分比 = {0} \n", variableSingTimePercent.ToString());

        for (int idx = (int)Nature_Type.None; idx < (int)Nature_Type.Max; idx++)
        {
            string strInfo = "无";
            switch (idx)
            {
                case (int)Nature_Type.Nature_Water:
                    strInfo = "水";
                    break;
                case (int)Nature_Type.Nature_Ground:
                    strInfo = "地";
                    break;
                case (int)Nature_Type.Nature_Fire:
                    strInfo = "火";
                    break;
                case (int)Nature_Type.Nature_Wind:
                    strInfo = "风";
                    break;
                case (int)Nature_Type.Nature_Saint:
                    strInfo = "圣";
                    break;
                case (int)Nature_Type.Nature_Dark:
                    strInfo = "暗";
                    break;
                case (int)Nature_Type.Nature_Read:
                    strInfo = "念";
                    break;
            }
            strLog += string.Format("{0} = {1} --- {2} \n", strInfo, natureDamagePercent[idx - 1].ToString(), antiNatureDamagePercent[idx - 1]);
        }

        for (int i = ActorData.Attr_Life; i <= ActorData.Attr_CastAcceleration; i++)
        {
            strLog += string.Format("Server AtrrKey = {0} ,Value = {1}\n", i.ToString(), pActor.GetSeverSecondAttr(i).ToString());
        }

        Debug.Log(strLog);
    }
}

public class Fighter : LogicTransform
{
    static ulong AutoIncreaseInstanceID;

    public static void ResetInstanceID()
    {
        AutoIncreaseInstanceID = 0;
    }

    public static string BuildFighterGoName(int id, eTeamType side, bool isSummon,bool isPet)
    {
        string prefix = "fighter_";
        if (isPet)
            prefix = "pet_";
        else if (isSummon)
            prefix = "summon_";
        return prefix + (side == eTeamType.Friend ? "l_" : "r_") + id;
    }

    public static Fighter CreateFighter(FighterManager fighterMgr, ActorData actor, eTeamType side, Fighter summonOwner = null)
    {
        Fighter fighter = new Fighter(fighterMgr);
        fighter.InitGo(BuildFighterGoName(actor.BaseId, side, summonOwner != null,actor.IsPet));
        fighter.Initialize(actor, side, summonOwner);
        fighter.Prepare();
        return fighter;
    }

    Fighter(FighterManager mgr)
    {
        InstanceId = ++AutoIncreaseInstanceID;
        mFighterMgr = mgr;
        MoveSpeed = GlobalConfig.Instance.GetConfigIntValue(GlobalConfig.c_walkspeed_configid);
        mFunPointBuffs = new Dictionary<int, int>();
    }

    #region fields

    FighterManager mFighterMgr;

    FighterAi mAi;

    PassiveMove mPassiveMove;

    FighterStateData mStateData;

    FighterBuffManager mBuffMgr;

    FighterBuffFunctionMgr mFuncMgr;

    FighterGoCtrl mCtrl;

    PlayerActorBattleAttr mActorBattleAttr;

    //Fighter2DBloodBar mBloodBarHud;

    FighterHPBar mHpBarHud;

    SkillName2D mSkillNameHud;

    RageEffect2D mRageEffectHud;

    Dictionary<int,int> mFunPointBuffs = null;

    Dictionary<int, int> mSkillBuffPoints = new Dictionary<int, int>();

    #endregion    //fields

    #region property

    public ulong InstanceId { get; private set; }

    public FighterManager FighterMgr { get { return mFighterMgr; } }

    public BaseBattle Battle { get { return mFighterMgr.Battle; } }

    public ActorData Actor { get; private set; }

    public FighterStateData StateData { get { return mStateData; } }

    public BaseSkill CurrentSkill { get { return mStateData.CurrentSkill; } }

    public FighterAi AI { get { return mAi; } }

    public BattleField CurrentBattleField { get; private set; }

    public long Id { get { return Actor.ID; } }

    public string Name { get { return Actor.Name; } }

    public eTeamType TeamSide { get; private set; }

    public bool IsTeamMember { get { return TeamSide == eTeamType.Friend; } }

    public Position_Type PositionType { get { return Actor.PositionRule; } }

    public int PositionValue { get { return Actor.PositionValue; } }

    public ProfessionType ProfType { get { return Actor.Profession; } }

    public int JobStage
    {
        get { return Actor.JobStage; }
    }

    public int JobBranch
    {
        get { return Actor.JobBranch; }
    }

    public int Level { get { return Actor.Level; } }

    public Fighter SelectTarget { get; set; }

    public Fighter HitTarget { get; set; }

    public float MoveSpeed { get; set; }        //移动速度

    public int NatureId { get { return Actor.NatureId; } }

    public int Gender { get { return Actor.Gender; } }

    private int mBornEffectId = 0;
    public int BornEffectId 
    { 
        get { return mBornEffectId; }
        set { mBornEffectId = value; }
    }

    public Vector3 EulerAngle
    {
        get { return Ctrl != null ? Ctrl.transform.rotation.eulerAngles : Vector3.zero; }
    }

    public int NegativeBuffCnt
    {
        get
        {
            return mFuncMgr != null ? mFuncMgr.NegativeFunCnt : 0;
        }
    }

    private bool bIgnoreLife = false;
    public bool IgnoreLife
    {
        get { return bIgnoreLife; }
        set { bIgnoreLife = value; }
    }

    public int SeatId { get; set; }

    //当前携带的宠物ID
    private long mUsedPetId = 0;
    public long UsedPetId
    {
        get { return mUsedPetId; }
        set { mUsedPetId = value; }
    }

    //宠物主人ID
    private long mOwnerId = 0;
    public long OwnerId
    {
        get { return mOwnerId; }
        set { mOwnerId = value; }
    }

    public CastSkillData CastSkill
    {
        get
        {
            return mActorBattleAttr.castSkillData;
        }
    }

    public string IdleSound { get { return Actor.IdleSound; } }

    public string RunSound { get { return Actor.RunSound; } }

    public string DieSound { get { return Actor.DieSound; } }

    public string HitSound { get { return Actor.HitSound; } }

    public int RageCloneBossId
    {
        get;private set;
    }

    public Fighter RageCloneBoss
    {
        get; set;
    }

    public FighterStatistics Statistics
    {
        get
        {
            if (mStateData != null && mStateData.SkillStateData != null)
            {
                return mStateData.SkillStateData.Statistics;
            }
            return null;
        }
    }

    private List<TriggerBuffData> mTriggerBuffs;

    private int mTotalTakeDamage = 0;
    public int TotalTakeDamage
    {
        get { return mTotalTakeDamage; }
    }
    #endregion

    #region battle_attr
    public SInt MaxLife { get; set; }

    public SInt MaxSp { get; private set; }

    public SInt Life {
        get
        {
            return mStateData.Life; 
        }
        set {
            mStateData.Life = Mathf.Min(value, MaxLife);
            EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_Fighter_HP_Lower, this));
        }
    }

    public SFloat Sp {
        get
        {
            return mActorBattleAttr.sp;
        }
        set
        {
            mActorBattleAttr.sp = Mathf.Min(value, MaxSp);
            if (mActorBattleAttr.sp < 0)
                mActorBattleAttr.sp = 0;
        }
    }

    public SFloat DEX {
        get {
            return mActorBattleAttr.DEX;
        }
    }

    public SFloat STR
    {
        get
        {
            SFloat str = mActorBattleAttr.STR;
            //DebugHelper.LogWarning("************fighter:"+this.Name+" STR:" + str + " fixed value:"+ GetBuffFunctionValue(Buff_Function_Type.STR_Change_Value));
            return str;
        }
    }

    public SFloat INT
    {
        get
        {
            return mActorBattleAttr.INT;
        }
    }

    public SFloat AGI
    {
        get
        {
            return mActorBattleAttr.AGI;
        }
    }

    public SFloat LUK
    {
        get
        {
            return mActorBattleAttr.LUK;
        }
    }

    public SFloat VIT
    {
        get
        {
            return mActorBattleAttr.VIT;
        }
    }

    public SFloat GodPower
    {
        get { return mActorBattleAttr.GodPower; }
    }

    public SFloat Attack
    {
        get
        {
            SFloat attack = mActorBattleAttr.attack;
            if (IsNpc)
            {
                float detlaAttack = mActorBattleAttr.attack - mActorBattleAttr.minAttack;
                attack = mActorBattleAttr.minAttack + Battle.RandomValue(true) * detlaAttack;
                //attack = Battle.RandomValue(mActorBattleAttr.minAttack, mActorBattleAttr.attack, true);
            }

            SFloat AllBuffPercentValue = GetBuffPercentValue(Buff_Function_Type.Attack_Change_Percent);
            AllBuffPercentValue += GetBuffPercentValue(Buff_Function_Type.Attack_Change_ByTargetCostHpPercent);
            AllBuffPercentValue += GetBuffPercentValue(Buff_Function_Type.Attack_Change_BySourceCostHpPercent);
            AllBuffPercentValue += GetBuffPercentValue(Buff_Function_Type.Attack_Change_ByTargetCurHpPercent);
            AllBuffPercentValue += GetBuffPercentValue(Buff_Function_Type.Attack_Change_BySourceCurHpPercent);

            SFloat AllBuffFunctionValue = GetBuffFunctionValue(Buff_Function_Type.Attack_Change_Value);
            AllBuffFunctionValue += GetBuffFunctionValue(Buff_Function_Type.Attack_Change_ByTargetAttr);
            AllBuffFunctionValue += GetBuffFunctionValue(Buff_Function_Type.Attack_Change_BySourceAttr);

            attack = attack * Mathf.Max(1 + AllBuffPercentValue, 0.01f);   //持续
            attack = Mathf.Max(attack + AllBuffFunctionValue, 1);
            return attack;
        }
    }

    public SFloat MagicAttack
    {
        get
        {
            SFloat magicAttack = mActorBattleAttr.magic_attack;
            if (IsNpc)
            {
                float detlaAttack = mActorBattleAttr.magic_attack - mActorBattleAttr.minMagicAttack;
                magicAttack = mActorBattleAttr.minAttack + Battle.RandomValue(true) * detlaAttack;
                //magicAttack = Battle.RandomValue(mActorBattleAttr.minMagicAttack, mActorBattleAttr.magic_attack, true);
            }

            SFloat AllBuffPercentValue = GetBuffPercentValue(Buff_Function_Type.MagicAttack_Change_Percent);
            AllBuffPercentValue += GetBuffPercentValue(Buff_Function_Type.MagicAttack_Change_ByTargetCostHpPercent);
            AllBuffPercentValue += GetBuffPercentValue(Buff_Function_Type.MagicAttack_Change_BySourceCostHpPercent);
            AllBuffPercentValue += GetBuffPercentValue(Buff_Function_Type.MagicAttack_Change_ByTargetCurHpPercent);
            AllBuffPercentValue += GetBuffPercentValue(Buff_Function_Type.MagicAttack_Change_BySourceCurHpPercent);


            SFloat AllBuffFunctionValue = GetBuffFunctionValue(Buff_Function_Type.MagicAttack_Change_Value);
            AllBuffFunctionValue += GetBuffFunctionValue(Buff_Function_Type.MagicAttack_Change_ByTargetAttr);
            AllBuffFunctionValue += GetBuffFunctionValue(Buff_Function_Type.MagicAttack_Change_BySourceAttr);

            magicAttack = magicAttack * Mathf.Max(1 + AllBuffPercentValue, 0.01f);
            magicAttack = Mathf.Max(magicAttack + AllBuffFunctionValue, 1);
            return magicAttack;
        }
    }

    public SFloat Defense
    {
        get
        {
            SFloat AllBuffPercentValue = GetBuffPercentValue(Buff_Function_Type.Phyx_Defense_Change_Percent);

            SFloat AllBuffFunctionValue = GetBuffFunctionValue(Buff_Function_Type.Phyx_Defense_Change_Value);
            AllBuffFunctionValue += GetBuffFunctionValue(Buff_Function_Type.AttackDefense_Change_ByTargetAttr);
            AllBuffFunctionValue += GetBuffFunctionValue(Buff_Function_Type.AttackDefense_Change_BySourceAttr);

            SFloat def = mActorBattleAttr.defense * Mathf.Max(1 + AllBuffPercentValue, 0.01f) + AllBuffFunctionValue;
            return Mathf.Max(def, 0.01f);
        }
    }

    public SFloat MagicDefense
    {
        get
        {
            SFloat AllBuffPercentValue = GetBuffPercentValue(Buff_Function_Type.Magic_Defense_Change_Percent);

            SFloat AllBuffFunctionValue = GetBuffFunctionValue(Buff_Function_Type.Magic_Defense_Change_Value);
            AllBuffFunctionValue += GetBuffFunctionValue(Buff_Function_Type.MagicDefense_Change_ByTargetAttr);
            AllBuffFunctionValue += GetBuffFunctionValue(Buff_Function_Type.MagicDefense_Change_BySourceAttr);

            SFloat def = mActorBattleAttr.magic_defense * Mathf.Max(1 + AllBuffPercentValue, 0.01f) + AllBuffFunctionValue;
            return Mathf.Max(def, 0.01f);
        }
    }

    public SFloat DefPercent { get { return mActorBattleAttr.defPercent; } }

    public SFloat MagicDefPercent { get { return mActorBattleAttr.magicDefPercent; } }

    public SFloat IgnoreDefense
    {
        get
        {
            return mActorBattleAttr.penetration + GetBuffFunctionValue(Buff_Function_Type.IgnorePhysicDefense_Change_Value);
        }
    }

    public SFloat IgnoreMagicDefense
    {
        get
        {
            return mActorBattleAttr.magic_penetration + GetBuffFunctionValue(Buff_Function_Type.IgnoreMagicDefense_Change_Value);
        }
    }

    public SFloat Crit
    {
        get
        {
            SFloat crit = mActorBattleAttr.crit * (1 + GetBuffPercentValue(Buff_Function_Type.Crit_Change_Percent)) + GetBuffFunctionValue(Buff_Function_Type.Crit_Change_Value);
            return crit;
        }
    }

    public SFloat CritDamagePercent
    {
        get
        {
            return mActorBattleAttr.critDamagePercent + GetBuffFunctionValue(Buff_Function_Type.CritDamagePercent_Change_Value);
        }
    }

    public SFloat PhysicDamagePercent
    {
        get
        {
            return mActorBattleAttr.physicDamagePercent + GetBuffFunctionValue(Buff_Function_Type.PhysicDamagePercent_Change_Value);
        }
    }

    public SFloat MagicDamagePercent
    {
        get
        {
            return mActorBattleAttr.magicDamagePercent + GetBuffFunctionValue(Buff_Function_Type.MagicDamagePercent_Change_Value);
        }
    }

    public SFloat AntiPhysicDamPercent
    {
        get
        {
            return mActorBattleAttr.antiPhysicDamPercent + GetBuffFunctionValue(Buff_Function_Type.AntiPhysicDamagePercent_Change_Value);
        }
    }

    public SFloat AntiMagicDamPercent
    {
        get
        {
            return mActorBattleAttr.antiMagicDamPercent + GetBuffFunctionValue(Buff_Function_Type.AntiMagicDamagePercent_Change_Value);
        }
    }

    public SFloat PhysicDamageReflectPercent
    {
        get
        {
            return mActorBattleAttr.physicDamageReflectPercent + GetBuffFunctionValue(Buff_Function_Type.PhysicDamageReflectPercent_Change_Value);
        }
    }

    public SFloat MagicDamageReflectPercent
    {
        get
        {
            return mActorBattleAttr.magicDamageReflectPercent + GetBuffFunctionValue(Buff_Function_Type.MagicDamageReflectPercent_Change_Value);
        }
    }

    public SFloat FixedSingTimePercent { get { return mActorBattleAttr.fixedSingTimePercent; } }

    public SFloat VariableSingTimePercent { get { return mActorBattleAttr.variableSingTimePercent; } }

    public SFloat Hit
    {
        get
        {
            return mActorBattleAttr.hit * (1 + GetBuffPercentValue(Buff_Function_Type.Hit_Change_Percent)) + GetBuffFunctionValue(Buff_Function_Type.Hit_Change_Value);
        }
    }

    public SFloat Dodge
    {
        get
        {
            return mActorBattleAttr.dodge * (1 + GetBuffPercentValue(Buff_Function_Type.Dodge_Change_Percent)) + GetBuffFunctionValue(Buff_Function_Type.Dodge_Change_Value);
        }
    }

    //韧性
    public SFloat Ten
    {
        get
        {
            return mActorBattleAttr.ten * (1 + GetBuffPercentValue(Buff_Function_Type.Ten_Change_Percent)) + GetBuffFunctionValue(Buff_Function_Type.Ten_Change_Value);
        }
    }

    public SFloat PerfectDodgeRate
    {
        get
        {
            SFloat a = BattleFormulaParamMgr.Instance.GetParam(15);
            SFloat ratio = Mathf.Floor(LUK * a + 1) * 0.01f;
            return ratio;
        }
    }

    public SFloat AttackCD
    {
        get
        {
            SFloat a = BattleFormulaParamMgr.Instance.GetParam(26);
            SFloat b = BattleFormulaParamMgr.Instance.GetParam(27);

            SFloat attackCd = mActorBattleAttr.attackSpeed * (1 + GetBuffPercentValue(Buff_Function_Type.AttackCD_Change_Percent)) + GetBuffFunctionValue(Buff_Function_Type.AttackCD_Change_Value);
            attackCd = (Mathf.Max(a - attackCd, 0)) * b;
            return attackCd;
        }
    }

    public SFloat FixedSingDecreasePercent { get { return 0; } }

    public SFloat VariableSingDecreasePercent { get { return 0; } }

    //属性提升攻速百分比
    public SFloat AttrAttackSpeedPercent
    {
        get
        {
            SFloat a = BattleFormulaParamMgr.Instance.GetParam(29);
            SFloat b = BattleFormulaParamMgr.Instance.GetParam(30);

            SFloat attackSpeedPercent = (AGI * a + DEX * b) * 0.01f;
            return attackSpeedPercent;
        }
    }

    //技能提升攻速百分比
    public SFloat SkillAttackSpeedPercent
    {
        get
        {
            return GetBuffPercentValue(Buff_Function_Type.AttackSpeed_Change_Percent);
        }
    }
    #endregion

    private bool bAIEnabled = true;
    public bool IsAiEnabled
    {
        get { return bAIEnabled; }
        set { bAIEnabled = value; }
    }

    #region
    public Fighter SummonOwner { get; private set; }

    public BaseSkill[] Skills { get { return Actor.SkillMgr.Skills; } }

    public BaseSkill[] NormalSkills { get { return Actor.SkillMgr.NormalSkills; } }

    public List<BaseSkill> RandomSkills { get { return Actor.SkillMgr.RandomSkills; } }

    public List<BaseSkill> PassiveSkills { get{ return Actor.SkillMgr.PassiveSkills; } }

    public int SkillCnt { get { return Actor.SkillMgr.SkillCnt; } }

    public GameObject Go { get; private set; }

    public FighterGoCtrl Ctrl { get { return mCtrl; } }

    public PassiveMove PassiveMove { get { return mPassiveMove; } }

    public FighterBuffManager BuffMgr
    {
        get
        {
            if (mBuffMgr == null)
                mBuffMgr = mStateData.BuffMgr;
            return mBuffMgr;
        }
    }

    public FighterBuffFunctionMgr FuncMgr
    {
        get
        {
            if (mFuncMgr == null)
                mFuncMgr = mStateData.FuncMgr;
            return mFuncMgr;
        }
    }

    public PlayerActorBattleAttr ActorBattleAttr { get { return mActorBattleAttr; } }

    public float DyingTime { get { return CurrentStateId == FighterStateType.Die ? mStateData.DyingTime : 0; } }

    public float TimeFromLastHit { get { return mStateData.TimeFromLastBeHit; } }

    public bool IsSummoned { get { return SummonOwner != null; } }

    public bool IsSpawned { get; private set; }

    public bool IsDisposed { get; private set; }

    public bool IsDestroy { get; private set; }

    public bool IsFront { get { return Actor.PositionRule == Position_Type.Position_Front; } }

    public bool IsMiddle { get { return Actor.PositionRule == Position_Type.Position_Middle; } }

    public bool IsBack { get { return Actor.PositionRule == Position_Type.Position_Back; } }

    public bool IsAlive { get { return mStateData.IsAlive; } }

    public bool AIEnable {
        get { return mAi != null && mAi.Enabled; }
        set {
            if (AIEnable != value) {
                if (value) {
                    if (mAi == null)
                        mAi = new FighterAi(this);
                    mAi.Enabled = true;
                } else {
                    if (mAi != null)
                        mAi.Enabled = false;
                }
            }
        }
    }

    public float FloorY { get { return CurrentBattleField != null ? CurrentBattleField.FloorY : Position.y; } }

    public bool IsFighting { get; private set; }

    public bool IsVisible {
        get { return Ctrl != null && Ctrl.IsVisible; }
        set {
            if (Ctrl != null)
                Ctrl.IsVisible = value;
        }
    }

    public bool IsUndead { get { return mStateData.IsUnead; } set { mStateData.IsUnead = value; } }

    public bool IsIdle { get { return CurrentStateId == FighterStateType.Idle; } }

    public bool IsComing { get { return CurrentStateId == FighterStateType.Coming; } }

    public bool IsNavRun { get { return CurrentStateId == FighterStateType.NavRun; } }

    public bool IsRun { get { return CurrentStateId == FighterStateType.Run; } }

    public bool IsBoss { get { return Actor != null && Actor.IsBoss; } }

    public bool IsNpc { get { return Actor.IsNpc; } }

    public bool IsHero { get { return Actor.IsHero; } }

    public bool IsPetHero { get { return null != Actor as PetBossActorData; } }

    public bool IsFellow { get { return Actor.IsFellow; } }

    public bool IsSword { get { return Actor.Profession == ProfessionType.Pro_Type_Sword; } }

    public bool IsMagic { get { return Actor.Profession == ProfessionType.Pro_Type_Magic; } }

    public bool IsPriest { get { return Actor.Profession == ProfessionType.Pro_Type_Priest; } }

    public bool IsHunter { get { return Actor.Profession == ProfessionType.Pro_Type_Hunter; } }

    public bool IsThief { get { return Actor.Profession == ProfessionType.Pro_Type_Thief; } }

    public bool IsGround { get { return mStateData.IsGround; } }

    public float ModelSize { get { return Actor.AvatarData.modelSize; } }

    public bool IsMainRole { get { return Actor.IsMainRole; } }

    public bool IsPlayer { get { return IsHero || IsFellow; } }

    public bool IsPet { get { return Actor.IsPet; } }

    private bool bIsCloned = false;
    public bool IsCloned 
    {
        get { return bIsCloned; }
        set { bIsCloned = value; }
    }


    public bool InSkillSinged
    {
        get { return mStateData != null && mStateData.IsSing; }
    }

    public bool IsTargetable {
        get {
            if (!IsSpawned || IsDisposed)
                return false;
            if (IsAlive)
                return true;
            if (DyingTime > 2)
                return false;
            return true;
        }
    }

    public FighterStateType CurrentStateId { get { return mStateData.StateId; } }


    private Vector3 mDestPosition = Vector3.zero;
    public Vector3 DestPosition { get { return mDestPosition; } }

    private float mSpeedRatio = 1;
    public float SpeedRatio {
        get { return mSpeedRatio; }
        set { mSpeedRatio = value; }
    }

    private float mNormalAttackCdRatio = 1.0f;
    public float NormalAttackCdRatio { get { return mNormalAttackCdRatio; } }

    private int mReadyPosOrder = 1;
    public int ReadyPosOrder
    {
        get { return mReadyPosOrder; }
        set { mReadyPosOrder = value; }
    }


    //记录传送之前的位置
    private Vector3 mPreTransferPos = Vector3.zero;
    public Vector3 PreTransferPos
    {
        get { return mPreTransferPos; }
        set { mPreTransferPos = value; }
    }

    public float ComingTime
    {
        get;private set;
    }
    #endregion //property

    #region public_methods

    public void ForceIdle()
    {
        mStateData.ChangeState(FighterStateType.Idle);
    }

    public void ForceComing(float comingTime)
    {
        ComingTime = comingTime;
        mStateData.ChangeState(FighterStateType.Coming);
    }

    public void ForceGround()
    {
        if (CurrentBattleField != null)
            SetPosition(Position.SetY(CurrentBattleField.FloorY));
    }

    public void ForceBreak()
    {
        if (!IsAlive) return;

        mStateData.ChangeState(FighterStateType.Break);

        ShowSkillBreak();
    }

    public bool AutoChaseTo(Fighter target,float stopDist)
    {
        if (target == null) return false;

        if (!Battle.IsPlayRecord && Battle.Recorder != null)
        {
            Battle.Recorder.RecordFighterMove(this, target, stopDist);
        }

        return ChaseTo(target, stopDist); 
    }

    public bool ChaseTo(Fighter target,float stopDist)
    {
        return mStateData.ProcessTrigger(FighterStateTriggerType.Run, new FighterStateRunParam(target,target.Position, stopDist));
    }

    public bool AutoMoveTo(Vector3 pos,bool force=false)
    {
        mDestPosition = pos;

        if (Ctrl != null)
        {
            Ctrl.SetStopDistance(0);
        }

        if (mStateData.StateId == FighterStateType.NavRun) {
            mStateData.State.OnDataChanged();
            RunToWithNav(mDestPosition);
            return true;
        }

        if(!force)
        {
            return mStateData.ProcessTrigger(FighterStateTriggerType.NavRun, new FighterStateRunParam(null, pos, 0));
        }
        else
        {
            mStateData.ChangeState(FighterStateType.NavRun, new FighterStateRunParam(null, pos, 0));
            return true;
        }
    }

    public void RunToWithNav(Vector3 pos)
    {
        LookAt(pos);
        if (Ctrl != null)
        {
            Ctrl.RunToWithNav(pos);
        }
    }

    public void OnEnterField(BattleField field)
    {
        CurrentBattleField = field;
        SyncActorData();
    }

    public void OnLeaveField(BattleField field)
    {
        if (CurrentBattleField != field)
            return;

        OnFightingEnd();
        mStateData.Clear();
        AIEnable = false;
        IsFighting = false;
        mTotalTakeDamage = 0;
        if (IsAlive && !IsDisposed)
            ForceIdle();
        CurrentBattleField = null;
        mRecordJson = null;
    }

    //开始战斗
    public void OnFightingStart()
    {
        if (!IsAlive || IsDisposed)
        {
            DebugHelper.LogError(this.Name);
            return;
        }

        ForceIdle();
        AIEnable = bAIEnabled;
        IsFighting = true;
        mTotalTakeDamage = 0;

        if (!Battle.IsPlayRecord && Battle.Recorder != null)
            Battle.Recorder.RecordFighterStartFighting(this);

        //if(mBloodBarHud!=null)
        //    mBloodBarHud.Fight();

        if (mHpBarHud != null)
            mHpBarHud.Fight();

        if (mSkillNameHud != null)
            mSkillNameHud.Fight();

        if (mRageEffectHud != null)
        {
            mRageEffectHud.Fight();
        }

        if(mStateData.SkillStateData != null) 
        { 
            mStateData.SkillStateData.OnFightingStart();
        } 

        if (Ctrl != null)
            Ctrl.EnableNavAgent(false);

        EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_FIGHTER_ENTERCOMBAT, this));
        RefreshLife();
        RefreshSp();
    }

    public void CheckPassiveSkill()
    {
        if (!Battle.IsPlayRecord)
        {
            if (PassiveSkills != null)
            {
                for (int i = 0; i < PassiveSkills.Count; i++)
                {
                    BaseSkill passiveSkill = PassiveSkills[i];
                    if (passiveSkill != null)
                    {
                        if (passiveSkill.BuffList != null)
                        {
                            for (int idx = 0; idx < passiveSkill.BuffList.Count; idx++)
                            {
                                CastBuff(passiveSkill, passiveSkill.BuffList[idx]);
                            }
                        }

                        if (Battle.Recorder != null)
                        {
                            Battle.Recorder.RecordFighterPassiveSkill(this, passiveSkill.Id);
                        }
                    }
                }
            }
        }
        else
        {
            Battle.Recorder.ProcessFrameRecord(BattleRecorder.RecordType.FighterPassiveSkill, this);
        }
    }

    public void DoPassiveSkill(int skillId)
    {
        BaseSkill passiveSkill = GetPassiveSkill(skillId);
        if(passiveSkill != null)
        {
            if (passiveSkill.BuffList != null)
            {
                for (int idx = 0; idx < passiveSkill.BuffList.Count; idx++)
                {
                    CastBuff(passiveSkill, passiveSkill.BuffList[idx]);
                }
            }
        }
        if (BattleMgr.Instance.Battle.CanPrintLog)
            DebugHelper.LogError("------fighter:" + this.Id + " PassiveSkill: " + skillId);
    }

    public BaseSkill GetPassiveSkill(int skillId)
    {
        if (PassiveSkills == null) return null;

        for (int idx = 0; idx < PassiveSkills.Count; idx++)
        {
            if (PassiveSkills[idx].Id == skillId)
                return PassiveSkills[idx];
        }

        return null;
    }

    //战斗结束
    public void OnFightingEnd()
    {
        if (IsDisposed)
            return;

        if(StateData.IsRageStatus)
        {
            SetRageStatus(false);
        }

        mTotalTakeDamage = 0;
        AIEnable = false;
        IsFighting = false;
        //mBloodBarHud.Deactive();

        if (mHpBarHud != null)
            mHpBarHud.Deactive();

        if (mSkillNameHud != null)
            mSkillNameHud.Deactive();

        if (mRageEffectHud != null)
        {
            mRageEffectHud.Deactive();
        }
        if (AI!=null)
            AI.Reset();

        if (BuffMgr != null)
            BuffMgr.OnFightingEnd();

        if(FuncMgr!=null)
        {
            FuncMgr.OnFightingEnd();
        }

        if (Ctrl != null)
            Ctrl.EnableNavAgent(true);
    }

    //进入狂暴状态
    public void OnEnterRage()
    {
        if (!IsAlive) return;

        BuffData buffData = BattlePrepareManager.Instance.PopBuffData(Actor.RageId);
        CastBuff(null,buffData);
    }

    public SFloat GetAttrByType(int attrType)
    {
        switch(attrType)
        {
            case ActorData.Attr_Life:
                return Life;
            case ActorData.Attr_Sp:
                return Sp;
            case ActorData.Attr_Attack:
                return Attack;
            case ActorData.Attr_MagicAttack:
                return MagicAttack;
            case ActorData.Attr_Defense:
                return Defense;
            case ActorData.Attr_MagicDefense:
                return MagicDefense;
            case ActorData.Attr_AttackSpeed:
                return AttackCD;
            case ActorData.Attr_Hit:
                return Hit;
            case ActorData.Attr_Dodge:
                return Dodge;
            case ActorData.Attr_Crit:
                return Crit;
            case ActorData.Attr_Ten:
                return Ten;
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
            case ActorData.Attr_MaxHp:
                return MaxLife;
            case ActorData.Attr_MaxSp:
                return MaxSp;
            case ActorData.Attr_GodPow:
                return GodPower;
        }
        return 0;
    }
    //多项属性和
    public SFloat GetAttrByType(int[] attrTypes)
    {
        if(null == attrTypes)
            return 0;
        SFloat value = 0;
        for(int i=0;i<attrTypes.Length;i++)
        {
            value += GetAttrByType(attrTypes[i]);
        }
        return value;
    }

    public bool HaveBuffFunction(Buff_Function_Type buff_function)
    {
        if (IsDisposed)
            return false;
        return FuncMgr.HaveBuffFunction(buff_function);
    }

    public bool IsSuckDamage(Damage_Type DmgType, out SFloat SuckPrecent, out int nMaxSuck)
    {
        bool IsSuckDamage = false;
        SuckPrecent = 0;
        nMaxSuck = 0;
        if (DmgType == Damage_Type.Attack_Type_Magic)
        {
            IsSuckDamage = FuncMgr.GetSuckDamage(Buff_Function_Type.Hurt_MagicAttack_SuckDamage, out SuckPrecent, out nMaxSuck);
        }
        else if(DmgType == Damage_Type.Attack_Type_Physic)
        {
            IsSuckDamage = FuncMgr.GetSuckDamage(Buff_Function_Type.Hurt_Attack_SuckDamage, out SuckPrecent, out nMaxSuck);
        }             
        return IsSuckDamage;
    }

    public bool HaveBuffType(int typeid)
    {
        if (IsDisposed)
            return false;
        return FuncMgr.HaveBuffType((BattleBuffType)typeid);
    }

    public void RemoveFunctionByFunType(Buff_Function_Type funType)
    {
        if (IsDisposed)
            return;

        FuncMgr.RemoveFunctionByFunType(funType);
    }

    public SFloat GetBuffFunctionValue(Buff_Function_Type buff_function)
    {
        if (IsDisposed)
            return 0;

        return FuncMgr.GetBuffValue(buff_function) + GetMarkFunVal(buff_function);
    }

    public SFloat GetBuffPercentValue(Buff_Function_Type buff_function)
    {
        if (IsDisposed)
            return 0;

        return FuncMgr.GetBuffValue(buff_function) * 0.01f + GetMarkFunPercent(buff_function);
    }

    public SFloat GetMarkFunVal(Buff_Function_Type type)
    {
        if (IsDisposed)
            return 0;

        return mStateData.MMarkMgr.GetFunValue(type);
    }

    public SFloat GetMarkFunPercent(Buff_Function_Type type)
    {
        if (IsDisposed)
            return 0;

        return mStateData.MMarkMgr.GetFunPercent(type);
    }

    public void Dispose()
    {
        if (IsDisposed)
            return;

        ClearSkillBuffPoints();

        ClearTriggerBuff();

        SeatId = 0;

        mNormalAttackCdRatio = 1.0f;

        IsDisposed = true;

        IsVisible = false;

        IsSpawned = false;

        mUsedPetId = 0;

        mOwnerId = 0;

        bIsCloned = false;

        if (CurrentBattleField != null)
            CurrentBattleField.RemoveFighter(this);

        //mBloodBarHud.Dispose();

        if (mHpBarHud != null)
            mHpBarHud.Dispose();

        if (mSkillNameHud != null)
            mSkillNameHud.Dispose();

        if (mRageEffectHud != null)
        {
            mRageEffectHud.Dispose();
        }

        mStateData.Clear();

        if (Ctrl != null)
            Ctrl.OnDisposed();
        CurrentBattleField = null;

        SelectTarget = null;

        HitTarget = null;
    }

    public void Destroy()
    {
        if (IsDestroy)
            return;

        ClearSkillBuffPoints();

        ClearTriggerBuff();

        SeatId = 0;

        IsDisposed = true;

        IsDestroy = true;

        IsVisible = false;

        IsSpawned = false;

        bIsCloned = false;

        mUsedPetId = 0;

        mOwnerId = 0;

        mAi = null;

        mPassiveMove = null;

        SelectTarget = null;

        HitTarget = null;

        if(mHpBarHud!=null)
        {
            mHpBarHud.Destroy();
            mHpBarHud = null;
        }


        if (mSkillNameHud != null)
        {
            mSkillNameHud.Destroy();
            mSkillNameHud = null;
        }

        if (mRageEffectHud != null)
        {
            mRageEffectHud.Destroy();
            mRageEffectHud = null;
        }

        if (CurrentBattleField != null)
            CurrentBattleField.RemoveFighter(this);
        CurrentBattleField = null;


        mStateData.Dispose();
        FighterState.UnregistCacheFighterState(this);

        if (Ctrl != null) {
            Ctrl.Destroy();
            mCtrl = null;
        }
        if(null != Go)
            Go.Destroy();
        Go = null;
    }

    //自动跑到战斗位置
    public bool AutoRunToFieldFightPosition(Vector3 diff)
    {
        if (CurrentBattleField == null)
            return false;

        if (!IsIdle)
            return false;

        if (IsFighting && !CanMove())
            return false;

        return false;
    }

    public bool CanMove()
    {
        if (HaveBuffFunction(Buff_Function_Type.Frozen) || HaveBuffFunction(Buff_Function_Type.Stiff))
            return false;

        return true;
    }

    public BattleBuff CastBuff(BaseSkill skill,int buffId)
    {
        return CastBuff(skill, buffId, skill!=null?skill.Level:1);
    }

    public BattleBuff CastBuff(BaseSkill skill, BuffData buffData)
    {
        if (CurrentBattleField == null) return null;  //不在战场的人释放buff是不合理的

        if (buffData == null) return null;

        return BuffMgr.AddBuff(skill, buffData);
    }

    public BattleBuff CastBuff(BaseSkill skill, int buffId,int skillLv)
    {
        if (CurrentBattleField == null) return null;        //不在战场的人释放buff是不合理的

        BuffData buffData = BattlePrepareManager.Instance.PopBuffData(buffId);
        if (buffData == null)
        {
            DebugHelper.LogError("buffId:" + buffId + " 配置不存在");
            return null;
        }

        buffData.SetLevel(skillLv);

        return CastBuff(skill, buffData);
    }

    public BaseSkill GetSkill(int seqId)
    {
        if(IsPet || IsPetHero)
        {
            return Actor.SkillMgr.GetRandomSkill(seqId);
        }
        else
        {
            return Actor.SkillMgr.GetSkill(seqId);
        }
    }

    public BaseSkill GetSkill(int seqId, int skillId)
    {
        if(IsPet || IsPetHero)
        {
            return Actor.SkillMgr.GetRandomSkillById(seqId,skillId);
        }
        else
        {
            return Actor.SkillMgr.GetSkill(seqId, skillId);
        }
    }

    public void FixedUpdate(float deltaTime)
    {
        if (!IsSpawned || IsDisposed || Actor.IsDisposed)
            return;

        if (CurrentBattleField == null)
            return;

        if (!IsFighting && CurrentBattleField.IsFightingState)
        {
            OnFightingStart();
        }

        mStateData.Update(deltaTime, CurrentBattleField.IsFightingState);
        
        if(mPassiveMove!=null)
            mPassiveMove.Update(deltaTime);

        //if (mBloodBarHud!=null)
        //    mBloodBarHud.LateUpdate(deltaTime);

        if (mHpBarHud != null)
            mHpBarHud.LateUpdate(deltaTime);

        if (mSkillNameHud != null)
            mSkillNameHud.LateUpdate(deltaTime);

        if (mRageEffectHud != null)
        {
            mRageEffectHud.LateUpdate();
        }
    }

    public void Spawn(Vector3 position, Vector3 forward, Quaternion rot, bool enterBattleField = true)
    {
        if (IsSpawned) {
            SetPosition(position);
            LookForward(forward);
            ForceSync(Ctrl.transform);
            return;
        }

        if (Ctrl != null && !Ctrl.IsLoaded)
        {
            Ctrl.Load();
        }

        IsSpawned = true;
        IsDisposed = false;

        //if(mBloodBarHud!=null)
        //    mBloodBarHud.Prepare();

        if (mHpBarHud != null)
            mHpBarHud.Prepare();

        if (mSkillNameHud != null)
            mSkillNameHud.Prepare();

        if (mRageEffectHud != null)
        {
            mRageEffectHud.Prepare();
        }

        FighterMgr.OnFighterSpawned(this);

        SetPosition(position);
        LookForward(forward);

        if (Ctrl != null) 
        {
            Ctrl.OnSpawned();
        }

        if (enterBattleField && Battle != null && Battle.CurBattleField != null)
            Battle.CurBattleField.AddFighter(this);


        ForceSync(Ctrl.transform);

        InitFighterBattleAttr();
        ForceIdle();

        SetRotation(rot);
        if (!Battle.IsPlayRecord && Battle.Recorder != null)
            Battle.Recorder.RecordFighterSpawn(this);
    }

    public override void SetPosition(Vector3 position)
    {
        float floorY = 0.1f;
        if (CurrentBattleField != null)
        {
            if (position.y < CurrentBattleField.FloorY)
                position.y = CurrentBattleField.FloorY;
            floorY = CurrentBattleField.FloorY;
        }
        else//没有战斗的情况
        {
            floorY = position.y;
        }

        Position = position;
        mStateData.IsGround = position.y.FEqual(floorY,0.5f);
    }

    public void SyncPosition(Vector3 position)
    {
        SetPosition(position);
        if (Ctrl != null) { 
            ForceSync(Ctrl.transform);
            Ctrl.SetShadowVisible(mStateData.IsGround);
        }
    }


    public override void SetRotation(Quaternion rot)
    {
        base.SetRotation(rot);
        if (Ctrl != null)
            Ctrl.OnRotationChanged(rot);
    }

    public override void LookForward(Vector3 forward, Vector3 up = default(Vector3))
    {
        base.LookForward(forward, up);
        if (Ctrl != null)
            Ctrl.OnForwardChanged();
    }

    public void OnGoDestroy()
    {
        Go = null;
        mCtrl = null;
    }

    public void OnKillEnemy(Fighter fighter)
    {
        if (fighter != null && fighter.TeamSide != TeamSide)
            AddRage(0);
    }

    public void ProcessSelfKill()
    {
        BuffMgr.Clear();
        IsUndead = false;
        Life = 0;
    }

    public bool DoBeHit(int hitMoveType,Fix64 initSpeed, Fix64 acceleration, FixVector3 movePos, Fix64 stiffTime)
    {
        return mStateData.ProcessTrigger(FighterStateTriggerType.BeHit, new FighterStateBeHitParam(hitMoveType, initSpeed, acceleration,movePos,stiffTime), hitMoveType);
    }

    public bool CanDoTriggerAction(FighterStateTriggerType triggerType)
    {
        return mStateData.State != null && mStateData.State.GetTriggerNextState(triggerType) != FighterStateType.None;
    }

    public void ResetNormalSkillCd()
    {
        mStateData.SkillStateData.ResetNormalAttackCd();
    }

    public bool CheckDoSkill(int skillType, out BaseSkill skill)
    {
        return CanDoSkill(skillType, out skill) && mStateData.ProcessTrigger(FighterStateTriggerType.Attack, new FighterStateAttackParam(skillType,skill), skillType);
    }

    public bool ForceDoSkill(int skillType, int skillId)
    {
        BaseSkill skill = GetSkill(skillType, skillId);
        if (skill == null) return false;

        //if (BattleMgr.Instance.Battle.IsPlayRecord)
        //    DebugHelper.LogError(string.Format("<color=#0000ff>{0} castskill= {1} skillType={2}, stateFrame={3}, state={4}</color>", this.Name, skillId, skillType, CurrentBattleField.CurrentStateFrame, mStateData.StateId));

        return mStateData.ProcessTrigger(FighterStateTriggerType.Attack, new FighterStateAttackParam(skillType, skill), skillType);
    }

    public void Relive(float lifePercent)
    {
        ResetLife();
        if (Ctrl != null)
            Ctrl.OnRelive();

        if (CurrentBattleField != null)
            CurrentBattleField.OnFighterRelive(this);

        FighterMgr.OnFighterRelive(this);
    }

    public void ResetLife()
    {
        Life = Mathf.RoundToInt(MaxLife);
        Sp = Mathf.RoundToInt(MaxSp);

        //mBloodBarHud.OnActorRevive();

        if (mSkillNameHud != null)
            mSkillNameHud.OnActorRevive();
        if (mRageEffectHud != null)
        {
            mRageEffectHud.OnActorRevive();
        }
    }

    public void OnDie()
    {
        if (Ctrl != null)
            Ctrl.OnDie();
        if (CurrentBattleField != null)
            CurrentBattleField.OnFighterDie(this);

        //if(mBloodBarHud!=null)
        //    mBloodBarHud.OnActorDead();

        if (mHpBarHud != null)
            mHpBarHud.OnActorDead();

        if (mSkillNameHud != null)
            mSkillNameHud.OnActorDead();

        if (mRageEffectHud != null)
        {
            mRageEffectHud.OnActorDead();
        }

        FighterMgr.OnFighterDie(this);
    }

    BaseSkill mSkill = null;
    public bool CanDoSkill(int skillType,out BaseSkill skill)
    {
        skill = null;
        if (Actor.IsDisposed)
            return false;

        if(mStateData.SkillStateData == null)
        {
            DebugHelper.LogError(this.Name + " CAST SKILL");
            return false;
        }

        mSkill = GetSkill(skillType);
        if (mSkill == null) return false;

        if (!PreCheckCanDoSkill(mSkill))
        {
            //DebugHelper.LogWarning(this.Name + "PreCheckCanDoSkill 不能执行");
            return false;
        }

        if (mStateData.SkillStateData.GetCd(skillType) > 0)
        {
            //DebugHelper.LogWarning(this.Name + "CD 未到");
            return false;
        }

        if (Sp < mSkill.SkillDataInfo.spCost) {
           // DebugHelper.LogWarning(this.Name + "不能执行");
            return false;
        }

        ReSelectTarget(mSkill);
        if (mStateData.SkillStateData.TargetFighter == null)
        {
            //DebugHelper.LogWarning(this.Name+"目标不存在");
            return false;
        }

        Vector3 targetP = mStateData.SkillStateData.TargetFighter.Position;
        targetP.y = 0;

        Vector3 tempP = this.Position;
        tempP.y = 0;

        float dist = Vector3.Distance(targetP, tempP);
        float stopDist = mSkill.GetSkillDist((int)ProfType) + this.ModelSize + mStateData.SkillStateData.TargetFighter.ModelSize;
        //DebugHelper.LogError(Name + " "+ dist +" skillDist:"+ stopDist + " target:"+ mStateData.SkillStateData.TargetFighter.Name);
        if ((dist - stopDist) > 0.1f)
        {
            if(!FuncMgr.HaveForbidMoveFunc())
            {
                Vector3 dir = (targetP - tempP).normalized;
                AutoChaseTo(mStateData.SkillStateData.TargetFighter, stopDist);
            }
            return false;
        }

        skill = mSkill;
        return true;
    }

    public void ProcessTriggerSkillBuff(Fighter caster, BaseSkill skill, BuffTriggerType type)
    {
        if (skill == null) return;

        if (this != caster) return;

        SkillTriggerBuffInfo buffInfo = skill.GetTriggerBuffByType(type);
        if (buffInfo.buffId > 0 && buffInfo.ratio > 0)
        {
            float randomV = Battle.RandomValue(true);
            if (randomV <= buffInfo.ratio)
            {
                CastBuff(null, buffInfo.buffId,skill.Level);
            }
        }
    }

    public void ProcessTriggerBuff(Fighter caster,BuffTriggerType type)
    {
        if (mTriggerBuffs == null) return;

        int curFrame = Battle.CurBattleField.CurrentStateFrame;
        for (int idx = 0; idx < mTriggerBuffs.Count; idx++)
        {
            TriggerBuffData buffData = mTriggerBuffs[idx];
            if (buffData.TriggerType != type)
                continue;
            if (!CheckPassiveBuffCaster(buffData, caster))
                continue;
            if (BuffTriggerType.Trigger_FixedTime == type)//固定间隔触发 不需要CD
            {
                buffData.DoUpdateTrigger(this, curFrame);
                continue;
            }
            if ((buffData.TriggerType == BuffTriggerType.Trigger_Begin_Fighting || buffData.CanTrigger(curFrame)) &&
                buffData.CanCheckCondition(caster))
            {                
                buffData.DoTrigger(this,curFrame);
                if (BattleMgr.Instance.Battle.CanPrintLog)
                {
                    DebugHelper.LogError(string.Format("{0} trigger passivebuff {1} caster：{2}, frame:{3}",
                        this.Name,
                        buffData.BuffId,
                        caster.Name,
                        CurrentBattleField.CurrentStateFrame));
                }
            }           
        }
    }

    public void AddTriggerBuffData(TriggerBuffData data)
    {
        if (mTriggerBuffs == null)
            mTriggerBuffs = new List<TriggerBuffData>();

        mTriggerBuffs.Add(data);
    }

    public void RemoveTriggerBuffData(int buffId)
    {
        if (mTriggerBuffs == null) return;

        for(int idx = mTriggerBuffs.Count -1; idx >= 0; idx--)
        {
            if(mTriggerBuffs[idx].BuffId == buffId)
            {
                mTriggerBuffs.RemoveAt(idx);
            }
        }
    }

    private bool CheckPassiveBuffCaster(TriggerBuffData data,Fighter caster)
    {
        if (caster == null) return false;

        if(data.CasterType == BuffTriggerCasterType.self)
        {
            return this == caster;
        }else if(data.CasterType == BuffTriggerCasterType.target)
        {
            return this.SelectTarget == caster;
        }else if(data.CasterType == BuffTriggerCasterType.friends)
        {
            return this.TeamSide == caster.TeamSide;
        }else if(data.CasterType == BuffTriggerCasterType.enemies)
        {
            return this.TeamSide != caster.TeamSide;
        }else if(data.CasterType == BuffTriggerCasterType.host)
        {
            return this.IsPet && this.TeamSide == caster.TeamSide && this.OwnerId == caster.Id;
        }
        return false;
    }

    //-------------------------------------------------

    public void ProcessBeHit(SkillHitFighterInfo hitInfo, int seq,int lastDamage)
    {
        if (hitInfo.Target != this)
            return;

        bool kill = ProcessDamage(hitInfo);
        if (kill)
        {
            Battle.Output(OutputType.Dead, this);
        }
        EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_Fighter_BeHit, this));

        if (hitInfo.Damage > 0)
        {
            if (HaveBuffFunction(Buff_Function_Type.Sleep))
                RemoveFunctionByFunType(Buff_Function_Type.Sleep);

            if (hitInfo.HitBreakCheckFlag)
            {
                FixVector3 hitMoveDestPos = FixVector3.Zero;
                //if (!hitInfo.HitflyCheckFlag)
                //    hitMoveDestPos.y = Fix64.Zero;

                Fix64 acceleration = Fix64.Zero;
                FixVector3 v3SelfPos = new FixVector3(this.Position);
                FixVector3 v3TargetPos = new FixVector3(hitInfo.Caster.Position);
                
                if (hitInfo.AttackInfo.hitMoveType > 0)
                {
                    if (hitInfo.AttackInfo.hitMoveType == (int)FighterMoveType.Beat_Back)
                    {
                        FixVector3 dir = v3SelfPos - v3TargetPos;
                        dir.Normalize();
                        dir.y = Fix64.Zero;
                        hitMoveDestPos = dir * (Fix64)hitInfo.AttackInfo.hitMoveDist + v3SelfPos;
                        hitMoveDestPos.y = (Fix64)CurrentBattleField.FloorY;
                        acceleration = (Fix64)hitInfo.AttackInfo.hitMoveAcceleration;
                    }
                    else if (hitInfo.AttackInfo.hitMoveType == (int)FighterMoveType.Beat_Fly)
                    {
                        FixVector3 dir = FixVector3.Up;
                        hitMoveDestPos = dir * (Fix64)hitInfo.AttackInfo.hitMoveDist + v3SelfPos;
                        acceleration = (Fix64)hitInfo.AttackInfo.hitMoveAcceleration;
                    }
                }
                DoBeHit(hitInfo.AttackInfo.hitMoveType, (Fix64)hitInfo.AttackInfo.hitMoveInitSpeed, acceleration, hitMoveDestPos, (Fix64)hitInfo.AttackInfo.stiffTime);
            }
        }

        if (Ctrl != null)
            Ctrl.OnBeHit(hitInfo, seq);

        if(Statistics!=null)
            Statistics.StatBeHitInfo(hitInfo);

        if (kill && hitInfo.Caster != null && !hitInfo.Caster.IsDisposed)
        { 
            hitInfo.Caster.OnKillEnemy(this);
            if(hitInfo.AttackInfo.skill!=null)
            {
                EventMgr.DispatchEvent<Fighter, BaseSkill>(new CoreEvent<Fighter, BaseSkill>(ECoreEventType.EID_Fighter_Kill, hitInfo.Caster, hitInfo.AttackInfo.skill));
            }
        }

        if (hitInfo.Damage > 0)
        {
            mTotalTakeDamage += Mathf.RoundToInt(hitInfo.Damage);
            UIEventParamFighterHurt hurtParam = new UIEventParamFighterHurt(hitInfo.Caster, this,
                Mathf.RoundToInt(hitInfo.Damage),
                hitInfo.IsCrit,
                hitInfo.AttackInfo.skill!=null ? hitInfo.AttackInfo.skill.SkillTypeID : 0,
                hitInfo.AttackInfo.multiHitCount,
                hitInfo.AttackInfo.multiHitIntervalTime,
                seq,
                hitInfo.AttackInfo.skill!=null ? hitInfo.AttackInfo.skill.Id:0,
                hitInfo.BuffId,lastDamage);

            EventMgr.DispatchEvent<UIEventParamFighterHurt>(new CoreEvent<UIEventParamFighterHurt>(ECoreEventType.EID_FIGHTER_HURT, hurtParam));
            if(hitInfo.IsCrit)
            {
                EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_Fighter_Damage_FromCrit, this));
            }
        }
    }

    public void ProcessReflectDamage(SFloat damage,string skillName,Fighter caster)
    {
        if (!IsAlive || damage == 0)
            return;

        if (StateData.IsInvincible)//无敌
            return;

        SInt lifeBefore = Life;
        bool isAliveBefore = IsAlive;
        SInt oldDamage = Mathf.CeilToInt(damage);

        if (caster.Statistics != null)
            caster.Statistics.StatReflectInfo(caster, oldDamage);

        if (Statistics != null)
            Statistics.StatReflectHurtInfo(this, oldDamage);

        damage = FuncMgr.DamageOnShield(oldDamage);
        if (!IgnoreLife)
        {
            Life -= (int)damage;
        }

        if (damage > 0) 
        { 
            Battle.Output(OutputType.Damage, caster, this, skillName, (int)damage);
            if (HaveBuffFunction(Buff_Function_Type.Sleep))
                RemoveFunctionByFunType(Buff_Function_Type.Sleep);

            mTotalTakeDamage += Mathf.RoundToInt(damage);
        }

        bool kill = isAliveBefore && !IsAlive;
        if (kill)
        {
            Battle.Output(OutputType.Dead, this);
            if(caster != null && !caster.IsDisposed)
            {
                caster.OnKillEnemy(this);
            }
        }

        UIEventParamFighterHurt hurtParam = new UIEventParamFighterHurt(caster, this, Mathf.RoundToInt(damage), false, 0, 1, 1, 1, 0, 0, 0);
        EventMgr.DispatchEvent<UIEventParamFighterHurt>(new CoreEvent<UIEventParamFighterHurt>(ECoreEventType.EID_FIGHTER_HURT, hurtParam));
        EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_Fighter_BeHit, this));

        if (BattleMgr.Instance.Battle.CanPrintLog)
        {
            DebugHelper.LogError(string.Format("{0} 对 {1} 的反伤伤害值是{2}", caster.Name, this.Name, (int)damage));
        }
    }

    //吸收伤害
    public void ProcessSuckDamage(SFloat damage, string skillName, Fighter caster)
    {
        if (null == StateData)
            return;
        if (!IsAlive || damage == 0)
            return;
              
        if (damage > 0)
        {
            Life += (int)damage;
            RefreshLife();            
            EventMgr.DispatchEvent<object[]>(new CoreEvent<object[]>(ECoreEventType.EID_FIGHTER_HEAL, new object[] { this, (int)damage }));
        }
    }

    public void ProcessStiff(bool stiff)
    {
        if (Ctrl != null)
            Ctrl.ProcessStiff(stiff);
    }

    public void ProcessVertigo(bool grey)
    {
        if (Ctrl != null)
            Ctrl.ProcessVertigo(grey);
    }

    public void ProcessSlow(bool bSlow)
    {
        if (Ctrl != null)
            Ctrl.ProcesssSpecularColor(bSlow,new Color(31.0f/255, 128.0f/255, 245.0f/255));
    }

    public void AddRage(int val)
    {
        //if (IsCaptain)
        //	Rage += val;
        //else {
        //	Fighter captain = TeamSide == 0 ? FighterMgr.LeftCaptain : FighterMgr.RightCaptain;
        //	if (captain != null && captain.IsSpawned && !captain.IsDisposed && captain.IsAlive)
        //		captain.Rage += val;
        //}
    }

    public void ReSelectTarget(BaseSkill skill)
    {
        mStateData.SkillStateData.TargetFighter = TrySelect(skill);
    }

    public void EndSkill(bool breakFlag= false)
    {
        if(breakFlag && mStateData.CurrentSkill!=null)
        {
            if(Statistics!=null)
                Statistics.OnBreakSkill(this, mStateData.CurrentSkill.SkillTypeID);
            //TriggerBuffByType(mStateData.CurrentSkill, SkillTriggerBuffType.Skill_Interrtupted_Trigger);

            EventMgr.DispatchEvent<Fighter, BaseSkill>(new CoreEvent<Fighter, BaseSkill>(ECoreEventType.EID_Fighter_Skill_Broken, this, mStateData.CurrentSkill));
        }

        ShowSkillBreak();
        mStateData.EndSkill();
    }

    public bool ChangeSkill(int fromSkill,int toSkill)
    {
        return Actor.SkillMgr.ChangeSkill(fromSkill, toSkill);
    }

    Fighter TrySelect(BaseSkill skill)
    {
        float dis = 100000;
        Fighter fighter = null;
        List<Fighter> fighters = CurrentBattleField.Fighters;
        for(int idx =0; idx < fighters.Count;idx++)
        {
            Fighter f = fighters[idx];
            if (f == null || f.TeamSide == TeamSide || f.IsDisposed || !f.IsAlive) continue;

            if (skill.BuffList.Count > 0 &&
                (skill.BuffList[0].filterRule.actorType != FilterActorType.Actor_Type_All && 
                skill.BuffList[0].filterRule.actorType != FilterActorType.Actor_Type_Pet) &&
                f.IsPet)
                continue;

            float dist = Vector3.Distance(this.Position, f.Position) - (ModelSize + f.ModelSize);
            if(dist < dis)
            {
                dis = dist;
                fighter = f;
            }
        }
        return fighter;
    }
#endregion

    void Initialize(ActorData actor, eTeamType side, Fighter summonOwner)
    {
        FighterState.RegistCacheFighterState(this);
        mPassiveMove = new PassiveMove(this);
        mStateData = new FighterStateData(this);
        IsDisposed = false;
        IsSpawned = false;

        Actor = actor;
        Actor.FighterInstanceId = InstanceId;
        TeamSide = side;
        SummonOwner = summonOwner;
        mBornEffectId = Actor.BornEffectId;

        SyncActorData();      

        //mDelayBeHitInfo = new TimeDelayManager<SkillHitFighterInfo>(ProcessDelayBeHit);

        if (IsBoss)
        {
            if (mRageEffectHud == null)
            {
                mRageEffectHud = new RageEffect2D();
                mRageEffectHud.Born(this);
            }
        }

        if (Actor.ShowHpBar)
        {
            if (mHpBarHud == null)
            {
                mHpBarHud = new FighterHPBar();
                mHpBarHud.Born(this);
            }
        }

        if (!Constants.isOffline)
        {
            if (mSkillNameHud == null)
            {
                mSkillNameHud = new SkillName2D();
                mSkillNameHud.Born(this);
            }
        }
    }

    public void ResetActor(ActorData actor)
    {
        Actor = actor;
        SyncActorData();
    }

    private JSONObject mRecordJson = null;
    public JSONObject RecordJson
    {
        get { return mRecordJson; }
    }

    public void SyncActorData()
    {        
        mRecordJson = Actor.ToJson();

        int atkFactor = 0, magicAtkFactor = 0, hpFactor = 0, spFactor = 0;
        BattleMgr.Instance.Battle.GetBattleFactors(out magicAtkFactor, out atkFactor, out hpFactor, out spFactor);
        if (TeamSide == eTeamType.Enemy)
        {
            spFactor = 0;
        }
        else
        {
            atkFactor = 0;
            magicAtkFactor = 0;
            hpFactor = 0;
        }

        mActorBattleAttr.Init(Actor,BattleMgr.Instance.Battle.FighterLifeRatio, atkFactor, magicAtkFactor, hpFactor, spFactor);
        MaxLife = Mathf.RoundToInt(mActorBattleAttr.life);
        MaxSp = Mathf.RoundToInt(mActorBattleAttr.sp);
        mTriggerBuffs = mActorBattleAttr.triggerBuffs;
        InitFighterBattleAttr();

        if (-1 != BattleMgr.Instance.Battle.BattleBeginMarkId)
            AddMark(BattleMgr.Instance.Battle.BattleBeginMarkId, 1);

        if (!Actor.HasPet)
        {
            UsedPetId = 0;
        }
        InitScale();
    }

    public void InitScale()
    {
        if (IsPet)
        {
            float fScale = Actor.GetScale();
            SetScale(fScale);
            ForceSync(Ctrl.transform);
        }
    }

    public SFloat GetNatureDamagePercent(int natureId)
    {
        if (natureId < (int)Nature_Type.None || natureId >= (int)Nature_Type.Max) return 0;

        return mActorBattleAttr.natureDamagePercent[natureId - 1] + GetBuffFunctionValue(Buff_Function_Type.Nature_None_Change_Value + natureId - 1);
    }

    public SFloat GetAntiNatureDamagePercent(int natureId)
    {
        if (natureId < (int)Nature_Type.None || natureId >= (int)Nature_Type.Max) return 0;

        return mActorBattleAttr.antiNatureDamagePercent[natureId - 1] + GetBuffFunctionValue(Buff_Function_Type.AntiNature_None_Change_Value + natureId - 1);
    }

    void InitFighterBattleAttr()
    {
        Life = MaxLife;
        Sp = MaxSp;
        IgnoreLife = Actor.IgnoreLife;
    }

    void InitGo(string name)
    {
        Go = new GameObject();
        Go.transform.SetParent(Battle != null? BattleMgr.Instance.transform: null);
        Go.transform.localPosition = Vector3.zero;
        Go.transform.localEulerAngles = Vector3.zero;
        Go.transform.localScale = Vector3.one;

        Layer = LayerMask.NameToLayer(BattleCamera.FighterLayerName);

        mCtrl = Go.AddComponent<FighterGoCtrl>();
        mCtrl.Fighter = this;

        ForceSync(Go.transform);
        Go.name = name;
    }

    bool ProcessDamage(SkillHitFighterInfo hitInfo)
    {
        if (!IsAlive)
            return false;

        SInt lifeBefore = Life;
        bool isAliveBefore = IsAlive;

        if (hitInfo.Damage > 0)
        {
            SInt oldDamage = Mathf.CeilToInt(hitInfo.Damage);
            hitInfo.Damage = FuncMgr.DamageOnShield(oldDamage);
            if(!IgnoreLife)
            {
                Life -= (int)hitInfo.Damage;
            }
            hitInfo.Absorb = oldDamage - hitInfo.Damage;
        }

        string skillName = null;
        if(hitInfo.Skill!=null && !hitInfo.Skill.IsNormalAttack)
        {
            skillName = hitInfo.Skill.SkillName;
        }
        if(hitInfo.Damage > 0)
            Battle.Output(OutputType.Damage, hitInfo.Caster, hitInfo.Target, skillName, (int)hitInfo.Damage);

        if (BattleMgr.Instance.Battle.CanPrintLog)
        {
            DebugHelper.LogError(string.Format("<color=#ffff00>{0} pos = {5} frame={6} skillName={4} Absorb = {1}-----Damage = {2} ---- Life = {3}</color>", this.Id, hitInfo.Absorb, hitInfo.Damage, Life, hitInfo.Skill != null ? hitInfo.Skill.SkillName : "", PositionValue, CurrentBattleField.CurrentStateFrame));
        }

        return isAliveBefore && !IsAlive;
    }

    void Prepare()
    {
        if(Skills!=null)
        {
            foreach (var skill in Skills)
            {
                if (skill != null && skill.IsEnabled)
                    skill.Prepare(this);
            }
        }
      
        if(NormalSkills!=null)
        {
            foreach (var skill in NormalSkills)
            {
                if (skill != null && skill.IsEnabled)
                    skill.Prepare(this);
            }
        }

        if(RandomSkills!=null)
        {
            for(int idx =0; idx < RandomSkills.Count;idx++)
            {
                if (RandomSkills[idx] != null && RandomSkills[idx].IsEnabled)
                    RandomSkills[idx].Prepare(this);
            }
        }

        if(PassiveSkills!=null)
        {
            for(int idx =0; idx < PassiveSkills.Count;idx++)
            {
                PassiveSkills[idx].Prepare(this);
            }
        }

        if (Actor.RageId > 0)
        {
            var buffData = BattlePrepareManager.Instance.PrecacheBuff(Actor.RageId,Gender,ProfType,JobStage,JobBranch);
            if(buffData!=null)
                this.RageCloneBossId = buffData.cloneBossId;
        }

        if(Actor.TriggerBuffs != null)
        {
            for(int idx =0; idx < Actor.TriggerBuffs.Count;idx++)
            {
                BattlePrepareManager.Instance.PrecacheBuff(Actor.TriggerBuffs[idx].BuffId,Gender,ProfType,JobStage,JobBranch);
            }
        }

        if(Actor.DropBuffList != null)
        {
            for(int idx =0; idx < Actor.DropBuffList.Count;idx++)
            {
                BuffData buffData =  BattlePrepareManager.Instance.PrecacheBuff(Actor.DropBuffList[idx].BuffId, Gender, ProfType, JobStage, JobBranch);
                buffData.SetFunData(Actor.DropBuffList[idx].FunParamStr);
            }
        }

        if(Actor.SkillMgr.AlternativeSkills!=null)
        {
            for(int idx =0; idx < Actor.SkillMgr.AlternativeSkills.Count;idx++)
            {
                Actor.SkillMgr.AlternativeSkills[idx].Prepare(this);
            }
        }
    }

    bool PreCheckCanDoSkill(BaseSkill skill)
    {
        if (skill == null || !skill.IsEnabled)
        {
            //DebugHelper.LogError("技能不可用，不能执行");
            return false;
        }

        if (!IsFighting || !IsAlive)
        {
            //DebugHelper.LogError("PreCheckCanDoSkill:"+ IsFighting+" isalive:"+IsAlive);
            return false;
        }

        if (mStateData.IsStark)
        {
            //DebugHelper.Log("stark state!!!");
            return false;
        }

        return true;
    }

    public Vector3 GetSkillNamePos()
    {
        Vector3 pos = Vector3.zero;
        //if (mBloodBarHud != null)
        //{ 
        //    pos = mBloodBarHud.BloodPos;
        //    if (mBloodBarHud.BloodIsVisible)
        //        pos.y += mBloodBarHud.BloodHeight;
        //}

        return pos;
    }

    int lastAddFrame = 0;
    public void AddFunctionPoint(int pointBuffId,int pointVal,int buffLevel)
    {
        if (lastAddFrame == Time.frameCount) return;

        int maxPoint = BattleFormulaParamMgr.Instance.GetFunPoint(pointBuffId);
        if (mFunPointBuffs.ContainsKey(pointBuffId))
        {
            mFunPointBuffs[pointBuffId] = mFunPointBuffs[pointBuffId] + pointVal;
            BattleBuff buff = BuffMgr.GetBuff(pointBuffId);
            if(buff == null)
            {
                CastBuff(null, pointBuffId, buffLevel);
            }
            else
            {
                BuffData buffData = BattlePrepareManager.Instance.PopBuffData(pointBuffId);
                buff.AddTotalFrame(buffData.totalFrame);
                //buff.AddTotalTime(buffData.totalTime);
            }
        }
        else
        {
            BuffData buffData = BattlePrepareManager.Instance.PopBuffData(pointBuffId);

            mFunPointBuffs.Add(pointBuffId, pointVal);
            CastBuff(null, pointBuffId, buffLevel);
        }
        if (mFunPointBuffs[pointBuffId] > maxPoint)
        {
            mFunPointBuffs[pointBuffId] = maxPoint;
        }

        lastAddFrame = Time.frameCount;

        ShowPointBuffIcon(pointBuffId);
        //DebugHelper.LogError(this.Name + " pointbuffid:" + pointBuffId + " point:" + mFunPointBuffs[pointBuffId]);
    }

    int lastDetuctFrame = 0;
    public void DetuctFunctionPoint(int pointBuffId, int pointVal)
    {
        if (lastDetuctFrame == Time.frameCount) return;

        if(mFunPointBuffs.ContainsKey(pointBuffId))
        {
            mFunPointBuffs[pointBuffId] = mFunPointBuffs[pointBuffId] - pointVal;
            ShowPointBuffIcon(pointBuffId);
        }

        if(mFunPointBuffs[pointBuffId] <= 0)
        {
            RemovePointBuffIcon(pointBuffId);

            mFunPointBuffs.Remove(pointBuffId);
            BattleBuff buff =  BuffMgr.GetBuff(pointBuffId);
            if(buff!=null)
            {
                buff.Stop();
            }
        }

        lastDetuctFrame = Time.frameCount;
    }

    public void RemoveFunctionPoint(int pointBuffId)
    {
        if (mFunPointBuffs.ContainsKey(pointBuffId))
        {
            RemovePointBuffIcon(pointBuffId);
            mFunPointBuffs.Remove(pointBuffId);
        }
    }

    public void ShowPointBuffIcon(int pointBuffId)
    {
        int maxPoint = BattleFormulaParamMgr.Instance.GetFunPoint(pointBuffId);
        if (maxPoint <= 1) return;

        BuffData buffData = BattlePrepareManager.Instance.PopBuffData(pointBuffId);
        if (buffData != null)
            ShowBuffIcon(buffData.icon, mFunPointBuffs[pointBuffId]);
    }

    public void RemovePointBuffIcon(int pointBuffId)
    {
        BuffData buffData = BattlePrepareManager.Instance.PopBuffData(pointBuffId);
        if (buffData != null)
            RemoveBuffIcon(buffData.icon);
    }

    public int GetFunctionPoint(int pointBuffId)
    {
        if (mFunPointBuffs.ContainsKey(pointBuffId))
            return mFunPointBuffs[pointBuffId];

        return 0;
    }

    public void ShowSkillName(string skillName)
    {
        if (string.IsNullOrEmpty(skillName)) return;

        if (mSkillNameHud != null)
            mSkillNameHud.OnShowSkillName(skillName);
    }

    public void ShowBuffIcon(string icon,int num)
    {
        if(IsBoss || IsPlayer)
        {
            stBuffParam buff = new stBuffParam(this.TeamSide,this.Id,IsBoss, icon, num);
            EventMgr.DispatchEvent<stBuffParam>(new CoreEvent<stBuffParam>(ECoreEventType.EID_SHOW_BUFF_ICON, buff));
        }
    }

    public void RemoveBuffIcon(string icon)
    {
        if (IsBoss || IsPlayer)
        {
            stBuffParam buff = new stBuffParam(this.TeamSide,this.Id, IsBoss, icon, 0);
            EventMgr.DispatchEvent<stBuffParam>(new CoreEvent<stBuffParam>(ECoreEventType.EID_REMOVE_BUFF_ICON, buff));
        }
    }

    public void RefreshLife()
    {
        //if (mBloodBarHud != null)
        //    mBloodBarHud.OnLifeChanged(this.Life,this.MaxLife);

        if (mHpBarHud != null)
            mHpBarHud.OnLifeChanged(this.Life, this.MaxLife);

        EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_FIGHTER_LIFE_CHANGED, this));
    }

    public void RefreshSp()
    {
        //if (mBloodBarHud != null)
        //    mBloodBarHud.OnSpChanged(this.Sp,this.MaxSp);

        EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_FIGHTER_ENERGY_CHAGNED, this));
    }

    int mSingEffectInstanceId = 0;
    public void BeginSing(string animName, int effectId)
    {
        if(StateData!=null)
            StateData.BeginSing(animName);

        if (mSkillNameHud != null)
            mSkillNameHud.OnBeginSing((StateData.SingTotalFrame / Constants.frame_to_time));

        if (effectId > 0 && mSingEffectInstanceId == 0)
        {
            mSingEffectInstanceId = EffectManager.Instance.PlayEffect(effectId, this, this);
        }
    }


    public void RefreshSingProgress(float totalTime, float leftTime)
    {
        if (mSkillNameHud != null)
            mSkillNameHud.OnUpdateSing(totalTime, leftTime);
    }

    public void EndSing()
    {
        if (mSkillNameHud != null)
            mSkillNameHud.OnEndSing();

        if (mSingEffectInstanceId > 0)
        {
            EffectManager.Instance.RemoveEffectByInstanceID(mSingEffectInstanceId);
            mSingEffectInstanceId = 0;
        } 
    }

    public void ShowCasting(float time,bool vis)
    {
        if (mSkillNameHud != null)
            mSkillNameHud.OnCasting(time, vis);
    }

    public void ShowSkillBreak()
    {
        if (mSkillNameHud != null)
            mSkillNameHud.OnSkillBreak();
    }

    public void SetRageStatus(bool inRage)
    {
        if (StateData != null)
            StateData.IsRageStatus = inRage;

        //if (mRageEffectHud != null)//取消狂暴飘字
        //    mRageEffectHud.OnShowRage(inRage);

        EventMgr.DispatchEvent<bool>(new CoreEvent<bool>(ECoreEventType.EID_BOSS_IN_RAGE, inRage));
    }


    public void CheckSkillEnhance(BaseSkill skill,bool preview = false)
    {
        if (skill == null) return;

        skill.IsEnhance = false;
        SkillData skillData = skill.SkillDataInfo;
        if(skillData.pointBuffId > 0 && skillData.buffPointType != BuffPointType.None)
        {
            int buffId = skillData.pointBuffId;
            if(skillData.buffPointType == BuffPointType.AddPoint)
            {
                if(!preview)
                {
                    if (skillData.pointBuffParams != null && skillData.pointBuffParams.Length > 0)
                    {
                        int point = skillData.pointBuffParams[0];

                        if (mSkillBuffPoints.ContainsKey(buffId))
                        {
                            mSkillBuffPoints[buffId] = mSkillBuffPoints[buffId] + point;
                        }
                        else
                        {
                            mSkillBuffPoints.Add(buffId, point);
                        }
                    }
                }
          
            }else if(skillData.buffPointType == BuffPointType.OwnPoint)
            {
                skill.IsEnhance = HasSkillBuffPoint(buffId);
            }else if(skillData.buffPointType == BuffPointType.DetectPoint)
            {
                int point = 0;
                mSkillBuffPoints.TryGetValue(buffId, out point);

                if (skillData.pointBuffParams != null && skillData.pointBuffParams.Length > 0 && point > 0)
                {
                    for (int idx = skillData.pointBuffParams.Length - 1; idx >= 0; idx--)
                    {
                        if (skillData.pointBuffParams[idx] <= point)
                        {
                            if(!preview)
                            {
                                if (mSkillBuffPoints.ContainsKey(buffId))
                                {
                                    mSkillBuffPoints[buffId] = mSkillBuffPoints[buffId] - skillData.pointBuffParams[idx];
                                }
                            }                         
                            skill.IsEnhance = true;
                            break;
                        }
                    }
                }
            }
        }
    }

    public bool HasSkillBuffPoint(int buffId)
    {
        int point = 0;
        mSkillBuffPoints.TryGetValue(buffId, out point);

        return point > 0;
    }

    public void ClearSkillBuffPoints()
    {
        mSkillBuffPoints.Clear();
    }

    public void ClearTriggerBuff()
    {
        if(mTriggerBuffs != null)
        {
            mTriggerBuffs.Clear();
            mTriggerBuffs = null;
        }
    }

    public void SyncPetPosition(Vector3 petPos,bool syncNavAgent = false,bool enableNavAgent = true)
    {
        if (UsedPetId > 0)
        {
            Fighter pet = FighterMgr.GetFighterByID(UsedPetId, TeamSide);
            if (pet != null)
            {
                if (syncNavAgent)
                {
                    pet.Ctrl.EnableNavAgent(enableNavAgent);
                }
                
                pet.SyncPosition(petPos);
            }
        }
    }

    public void SyncPetMoveDestPos(Vector3 petPos, bool syncNavAgent = false, bool enableNavAgent = true)
    {
        if (UsedPetId > 0)
        {
            Fighter pet = FighterMgr.GetFighterByID(UsedPetId,TeamSide);
            if (pet != null && null != pet.Actor)
            {
                if (syncNavAgent)
                {
                    pet.Ctrl.EnableNavAgent(enableNavAgent);
                }

                pet.AutoMoveTo(petPos);
            }
        }
    }

    public void AddPveMark()
    {
        if (null == Actor.PveMark)
            return;
        //Debug.Log("Add Mark!!!!!!!!!!!!!");
        AddMark(Actor.PveMark.m_nMarkid, Actor.PveMark.m_nMarkNum);
    }

    public void AddMark(int markId,int layer)
    {
        if (mStateData.MMarkMgr == null) return;

        if (!IsAlive || IsDisposed || IsDestroy) return;

        mStateData.MMarkMgr.AddMark(markId, layer);
    }

    public void DecMark(int markId,int layer)
    {
        if (mStateData.MMarkMgr == null) return;

        if (!IsAlive || IsDisposed || IsDestroy) return;

        mStateData.MMarkMgr.ClearMark(markId, layer);
    }

    public bool HasMarkNLayer(int markId,int layer)
    {
        if (mStateData.MMarkMgr == null) return false;

        if (!IsAlive || IsDisposed || IsDestroy) return false;

        return mStateData.MMarkMgr.HasNLayerMark(markId, layer);
    }
}
