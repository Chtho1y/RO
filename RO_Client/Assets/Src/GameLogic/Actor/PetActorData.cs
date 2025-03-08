using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class PetActorData : ActorData
{
    private int mStep = 0;
    public int Step
    {
        get { return mStep; }
    }

    protected PetBaseData mBaseData;
    public PetBaseData BaseData { get { return mBaseData; } }

    protected PetAdvanceData mPetAdvanceData;
    protected int[] mAdvanceMaxLevels = null;


    #region OVERRIDE_FIELDS
    protected string mName;
    public override string Name
    {
        get { return mName; }
    }

    public override string HeadIcon
    {
        get { return mBaseData.headIcon; }
        set { }
    }

    public override int PositionValue
    {
        get { return mBaseData.position; }
    }

    public override string AnimCtrlName
    {
        get { return mBaseData.battleCtrl; }
    }

    public override string ShowAnimCtrlName
    {
        get { return mBaseData.showCtrl; }
    }

    public override int NatureId
    {
        get { return mBaseData.natureId; }
    }

    public override int AvatarID
    {
        get
        {
            return mBaseData.avatarId;
        }
    }

    public override ProfessionType Profession 
    { 
        get 
        { 
            return (ProfessionType)mBaseData.profession;
        } 
    }

    public override bool IsPet
    {
        get { return true; }
    }

    public override SFloat LocalLife
    {
        get
        {
            SFloat addHpRate = 0;
            int addHp = 0;
            CalcAdvanceData(Attr_Life, mBaseData.hpRate, out addHpRate, out addHp);
            SFloat hp = mBaseData.life * (1 + addHpRate) + addHp;
            return (hp + GetAdditionalAttr(Attr_Life)) * (1 + GetAdditionalAttrPercent(Attr_Life + 30));
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

    public override SFloat LocalSp
    {
        get
        {           
            SFloat addSpRate = 0;
            int addSp = 0;
            CalcAdvanceData(Attr_Sp, mBaseData.spRate, out addSpRate, out addSp);
            SFloat sp = mBaseData.sp * (1 + addSpRate) + addSp;
            return (sp + GetAdditionalAttr(Attr_Sp)) * (1 + GetAdditionalAttrPercent(Attr_Sp + 30));
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

    public override SFloat LocalAttack
    {
        get
        {           
            SFloat addAtkRate = 0;
            int addAtk = 0;
            CalcAdvanceData(Attr_Attack, mBaseData.atkRate, out addAtkRate, out addAtk);
            SFloat attack = mBaseData.attack * (1 + addAtkRate) + addAtk;
            return (attack + GetAdditionalAttr(Attr_Attack)) * (1 + GetAdditionalAttrPercent(Attr_Attack + 30));
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

    public override SFloat LocalMagicAttack
    {
        get
        {            
            SFloat addMagicAtkRate = 0;
            int addMagicAtk = 0;
            CalcAdvanceData(Attr_MagicAttack, mBaseData.matkRate, out addMagicAtkRate, out addMagicAtk);
            SFloat magicAttack = mBaseData.magicAttack * (1 + addMagicAtkRate) + addMagicAtk;
            return (magicAttack + GetAdditionalAttr(Attr_MagicAttack)) * (1 + GetAdditionalAttrPercent(Attr_MagicAttack + 30));
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

    public override SFloat LocalDefense
    {
        get
        {           
            SFloat addDefRate = 0;
            int addDef = 0;
            CalcAdvanceData(Attr_Defense, mBaseData.defRate, out addDefRate, out addDef);
            SFloat def = mBaseData.defense * (1 + addDefRate) + addDef;
            return (def + GetAdditionalAttr(Attr_Defense)) * (1 + GetAdditionalAttrPercent(Attr_Defense + 30));
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

    public override SFloat LocalMagicDefense
    {
        get
        {           
            SFloat addMagicDefRate = 0;
            int addMagicDef = 0;
            CalcAdvanceData(Attr_MagicDefense, mBaseData.mdefRate, out addMagicDefRate, out addMagicDef);
            SFloat magicDef = mBaseData.magicDefense * (1 + addMagicDefRate) + addMagicDef;
            return (magicDef + GetAdditionalAttr(Attr_MagicDefense)) * (1 + GetAdditionalAttrPercent(Attr_MagicDefense + 30));
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

    public override SFloat LocalCrit
    {
        get
        {            
            SFloat addCritRate = 0;
            int addCrit = 0;
            CalcAdvanceData(Attr_Crit, mBaseData.critRate, out addCritRate, out addCrit);
            SFloat crit = mBaseData.crit * (1 + addCritRate) + addCrit;
            return (crit + GetAdditionalAttr(Attr_Crit)) * (1 + GetAdditionalAttrPercent(Attr_Crit + 30));
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

    public override SFloat LocalDodge
    {
        get
        {           
            SFloat addDodgeRate = 0;
            int addDodge = 0;
            CalcAdvanceData(Attr_Dodge, mBaseData.dodgeRate, out addDodgeRate, out addDodge);
            SFloat dodge = mBaseData.dodge * (1 + addDodgeRate) + addDodge;
            return (dodge + GetAdditionalAttr(Attr_Dodge)) * (1 + GetAdditionalAttrPercent(Attr_Dodge + 30));
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

    public override SFloat LocalAttackSpeed
    {
        get { return mBaseData.attackSpeed; }
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

    public override SFloat CritDamagePercent
    {
        get { return 0; }
    }

    public override SFloat LocalHit
    {
        get
        {           
            SFloat addHitRate = 0;
            int addHit = 0;
            CalcAdvanceData(Attr_Hit, mBaseData.hitRate, out addHitRate, out addHit);
            SFloat hit = mBaseData.hit * (1 + addHitRate) + addHit;
            return (hit + GetAdditionalAttr(Attr_Hit)) * (1 + GetAdditionalAttrPercent(Attr_Hit + 30));
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

    public override SFloat LocalTen
    {
        get
        {           
            SFloat addTenRate = 0;
            int addTen = 0;
            CalcAdvanceData(Attr_Ten, mBaseData.tenRate, out addTenRate, out addTen);
            SFloat ten = mBaseData.ten * (1 + addTenRate) + addTen;
            return (ten + GetAdditionalAttr(Attr_Ten)) * (1 + GetAdditionalAttrPercent(Attr_Ten + 30));
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
    #endregion


    public PetActorData(int id):base(id)
    {
        mActorType = ActorType.Pet;
    }

    public override void Initialize(int id, int level, SkillParam[] usedSkills)
    {
        base.Initialize(id, level, usedSkills);
        Gender = (int)Role_Gender.Male;
        mBaseData = new PetBaseData(id);
        mPetAdvanceData = new PetAdvanceData(id);
        mAvatarData = new AvatarData(AvatarID);
        mName = I18N.T(mBaseData.petName);
        mAdvanceMaxLevels = StringUtil.split2Int(GlobalConfig.Instance.GetConfigStrValue(208),';');

        if (mSkillMgr == null)
        {
            mSkillMgr = new SkillManager(this);
        }

        mSkillMgr.InitNormalSkills(mBaseData.normalSkillIds);
        if (usedSkills != null)
        {
            mSkillMgr.InitRandomSkills(usedSkills);
        }
        else
        {
            mSkillMgr.InitRandomSkills(mBaseData.testSkills.ToArray());
        }

        mSkillMgr.SetReserveSkill(mBaseData.emptySkillId);

        ResetFirstSkill();
        valid = mBaseData.valid && mAvatarData.valid;
    }

    public override void RefreshSkills(SkillParam[] usedSkills)
    {
        SetUsedSkill(usedSkills);
        if (usedSkills != null)
        {
            mSkillMgr.InitRandomSkills(usedSkills);
        }
    }

    public void SetStep(int step)
    {
        if (mStep == step) return;

        mStep = step;

        /*ResetAdditionalAttrPercent();
        for(int attrId = ActorData.Attr_STR_Percent; attrId <= ActorData.Attr_VariableSingTime_Percent; attrId++)
        {
            SFloat val =  CalcAdditionalAttrPercent(attrId);
            SetAdditionalAttrPercent(attrId, val);
        }*/
    }

    private SFloat CalcAdditionalAttrPercent(int attrId)
    {
        SFloat addTotalAttr = 0;
        for (int idx = mStep; idx >= 1; idx--)
        {
            List<ValType> valList;
            List<ValType> valRateList;
            mPetAdvanceData.advanceData.TryGetValue(idx, out valList);
            mPetAdvanceData.advanceRateData.TryGetValue(idx, out valRateList);

            int addVal = TryGetVal(attrId, valList);
            addTotalAttr += addVal * 0.0001f;
        }
        return addTotalAttr;
    }

    protected override JSONObject BaseToJson()
    {
        JSONObject json = base.BaseToJson();
        json.AddField("advanceLevel", mStep);
        return json;
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

    private void CalcAdvanceData(int attrId,SFloat baseRate,out SFloat addTotalRate, out int addTotalAttr)
    {
        addTotalRate = 0;
        addTotalAttr = 0;
        for(int idx = mStep;idx>=1;idx--)
        {
            List<ValType> valList;
            List<ValType> valRateList;
            mPetAdvanceData.advanceData.TryGetValue(idx, out valList);
            mPetAdvanceData.advanceRateData.TryGetValue(idx, out valRateList);

            int addVal = TryGetVal(attrId, valList);
            int addRate = TryGetVal(attrId, valRateList);

            if(idx == mStep)
            {
                addTotalRate += ((mLevel - mAdvanceMaxLevels[idx-1]) * addRate)/10000.0f;
            }
            else
            {
                addTotalRate += ((mAdvanceMaxLevels[idx] - mAdvanceMaxLevels[idx - 1]) * addRate) / 10000.0f;
            }
           // addTotalAttr +=addVal;
        }

        if (mStep > 0)
        {
            addTotalRate += (mAdvanceMaxLevels[0] - 1) * baseRate;
        }
        else
        {
            addTotalRate += (mLevel - 1) * baseRate;
        }
    }

    private int TryGetVal(int attrId, List<ValType> list)
    {
        if (list == null) return 0;

        for(int idx =0; idx < list.Count;idx++)
        {
            if(list[idx].id == attrId)
            {
                return list[idx].val;
            }
        }
        return 0;
    }
}
