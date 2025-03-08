using UnityEngine;
using System.Collections;

public class PetBossActorData : PetActorData
{
    public PetBossActorData(int id):base(id)
    {
        mActorType = ActorType.Hero;
    }

    public override bool IsHero { get { return true; } }
    public override bool IsPet { get { return false; } }
    public override bool IsFellow { get { return false; } }
    public override float GetScale()
    {
        return mAvatarData.scale; 
    }

    public override void Initialize(int id, int level, SkillParam[] usedSkills)
    {
        Gender = (int)Role_Gender.Male;
        mBaseData = new PetBossBaseData(id);
        //mPetAdvanceData = new PetAdvanceData(id);
        mAvatarData = new AvatarData(AvatarID);
        mName = I18N.T(mBaseData.petName);
        mAdvanceMaxLevels = StringUtil.split2Int(GlobalConfig.Instance.GetConfigStrValue(208), ';');

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
}
