using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;

public class NpcActorData : ActorData
{
    protected NpcBaseData mNpcBaseData = null;

    public NpcActorData(int id) : base(id)
    {
        mActorType = ActorType.Monster;
    }

    public override NpcBaseData NpcData
    {
        get
        {
            return mNpcBaseData;
        }
    }

    public override string SkillFrameEventName
    {
        get { return mNpcBaseData.frameEventName; }
    }

    public override int BornEffectId
    {
        get { return mNpcBaseData.bornEffectId; }
    }

    public override bool IsNpc
    {
        get { return true; }
    }

    public override bool ShowHpBar
    {
        get { return mNpcBaseData.showHpBar; }
    }

    private SFloat life = 0;

    public override SFloat LocalLife
    {
        get
        {
            life = NpcData.life * (1 + (mLevel - 1) * mNpcBaseData.hpRate);
            return life;
        }
    }

    public override SFloat Life
    {
        get
        {            
            return LocalLife;
        }   
    }

    private SFloat sp = 0;
    public override SFloat LocalSp
    {
        get { return NpcData.sp * (1 + (mLevel - 1) * mNpcBaseData.spRate); }
    }
    public override SFloat Sp
    {
        get { return LocalSp; }
    }

    public override SFloat MinAttack
    {
        get { return NpcData.minAttack * (1 +(mLevel -1) * mNpcBaseData.atkRate); }
    }

    public override SFloat LocalAttack
    {
        get
        {
            return NpcData.attack * (1 + (mLevel - 1) * mNpcBaseData.atkRate);
        }
    }
    public override SFloat Attack
    {
        get
        {
            return LocalAttack;
        }
    }

    public override SFloat MinMagicAttack
    {
        get { return NpcData.minMagicAttack * (1 + (mLevel - 1) * mNpcBaseData.matkRate); }
    }

    public override SFloat LocalMagicAttack
    {
        get { return NpcData.magicAttack * (1 + (mLevel - 1) * mNpcBaseData.matkRate); }
    }
    public override SFloat MagicAttack
    {
        get { return LocalMagicAttack; }
    }

    public override SFloat LocalDefense
    {
        get
        {
            return NpcData.defense * (1 + (mLevel - 1) * mNpcBaseData.defRate);
        }
    }
    public override SFloat Defense
    {
        get
        {
            return LocalDefense;
        }
    }

    public override SFloat LocalMagicDefense
    {
        get
        {
            return NpcData.magicDefense * (1 + (mLevel - 1) * mNpcBaseData.mdefRate);
        }
    }
    public override SFloat MagicDefense
    {
        get
        {
            return LocalMagicDefense;
        }
    }

    public override SFloat LocalCrit
    {
        get
        {
            return NpcData.crit * (1 + (mLevel - 1) * mNpcBaseData.critRate);
        }
    }
    public override SFloat Crit
    {
        get
        {
            return LocalCrit;
        }
    }

    public override SFloat LocalDodge
    {
        get
        {
            return NpcData.dodge * (1 + (mLevel - 1) * mNpcBaseData.dodgeRate);
        }
    }
    public override SFloat Dodge
    {
        get
        {
            return LocalDodge;
        }
    }
    public override SFloat LocalAttackSpeed
    {
        get { return NpcData.attackSpeed; }
    }
    public override SFloat AttackSpeed
    {
        get { return LocalAttackSpeed; }
    }

    public override SFloat CritDamagePercent
    {
        get { return 0; }
    }

    public override SFloat LocalHit
    {
        get { return NpcData.hit * (1 + (mLevel - 1) * mNpcBaseData.hitRate); }
    }
    public override SFloat Hit
    {
        get { return LocalHit; }
    }

    public override SFloat LocalGodPower
    {
        get { return NpcData.GodPower * (1 + (mLevel - 1) * mNpcBaseData.GodPowerRate); }
    }

    //神威值
    public override SFloat GodPower
    {
        get { return LocalGodPower; }
    }

    public override SFloat LocalTen
    {
        get { return NpcData.ten * (1 + (mLevel - 1) * mNpcBaseData.tenRate); }
    }
    public override SFloat Ten
    {
        get { return LocalTen; }
    }

    public override int AvatarID
    {
        get
        {
            return mNpcBaseData.avatarId;
        }
    }

    public override int NatureId
    {
        get { return mNpcBaseData.natureId; }
    }

    private string mName;
    public override string Name
    {
        get { return mName; }
    }

    public override string Description
    {
        get { return ""; }
    }

    public override string HeadIcon 
    {
        get { return mNpcBaseData.headIcon; }
    }

    public override ProfessionType Profession
    {
        get { return (ProfessionType)mNpcBaseData.professionType; }
    }

    private int position;
    public override int PositionValue
    {
        get { return position; }
        set { position = value; }
    }

    private bool mIgnoreLife = false;
    public override bool IgnoreLife
    {
        get { return mIgnoreLife; }
        set { mIgnoreLife = value; }
    }

    public override void Dispose()
    {
        if (mNpcBaseData != null)
        {
            mNpcBaseData.Dispose();
            mNpcBaseData = null;
        }

        base.Dispose();
    }

    public override void Initialize(int id, int level, SkillParam[] usedSkills)
    {
        base.Initialize(id, level, usedSkills);

        Gender = (int)Role_Gender.Male;
        mNpcBaseData = new NpcBaseData(id);
        mAvatarData = new AvatarData(AvatarID);
        mName = I18N.T(mNpcBaseData.npcName);
        if (mSkillMgr == null)
        {
            mSkillMgr = new SkillManager(this);
            mSkillMgr.InitializeSkill(mNpcBaseData.normalSkillIds,mNpcBaseData.skillIds);
            mSkillMgr.InitAlternativeSkills(mNpcBaseData.alternativeSkills);
            mSkillMgr.InitPassiveSkills(mNpcBaseData.PassiveSkills);           
        }
        
        position = mNpcBaseData.position;
        valid = mNpcBaseData.valid && mAvatarData.valid;
        ResetFirstSkill();
    }

    public override void SetLevel(int lv)
    {
        base.SetLevel(lv);
    }
}
