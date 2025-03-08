using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class SkillManager
{
    ActorData mSkillOwner;

    protected BaseSkill[] mNormalSkills;
    protected BaseSkill[] mSkills;
    private List<BaseSkill> mAlternativeSkills;
    private int normalSkillIdx = 0;

    public int NormalSkillIdx
    {
        get { return normalSkillIdx; }
    }

    public List<BaseSkill> AlternativeSkills
    {
        get { return mAlternativeSkills; }
    }

    public SkillManager(ActorData actor)
    {
        mSkillOwner = actor;
    }

    /// <summary>
    /// 英雄技能列表
    /// </summary>
    public BaseSkill[] Skills
    {
        get
        {
            return mSkills;
        }
    }

    public BaseSkill[] NormalSkills
    {
        get { return mNormalSkills; }
    }


    private List<BaseSkill> mRandomSkills = null;

    private BaseSkill mReserveSkill = null;
    public BaseSkill ReserveSkill
    {
        get { return mReserveSkill; }
    }

    public List<BaseSkill> RandomSkills
    {
        get { return mRandomSkills; }
    }

    private List<BaseSkill> mPassiveSkills;
    public List<BaseSkill> PassiveSkills
    {
        get { return mPassiveSkills; }
    }

    public int SkillCnt
    {
        get { return mSkills != null ? mSkills.Length : 0; }
    }

    private int mTotalRandomRate = 0;

    public void InitializeSkill(string[] normalSkillIds, SkillParam[] skillParams)
    {
        if (mSkillOwner == null)
            return;

        mSkills = new BaseSkill[skillParams.Length];

        InitNormalSkills(normalSkillIds);
        for (int idx =0;idx < skillParams.Length && idx < 4;idx++)
        {
            if (skillParams[idx].skillId <= 0)
                continue;
            BaseSkill skill = new BaseSkill(skillParams[idx].skillId, skillParams[idx].skillLv, idx + 1,mSkillOwner.Gender,mSkillOwner.Profession,mSkillOwner.JobStage,mSkillOwner.JobBranch);
            mSkills[idx] = skill;
        }
    }

    public void InitializeSkill(string[] normalSkillIds, string[] autoSkillIds)
    {
        if (mSkillOwner == null)
            return;

        InitNormalSkills(normalSkillIds);

        if (autoSkillIds!=null)
        {
            mSkills = new BaseSkill[autoSkillIds.Length];

            for (int idx =0; idx < autoSkillIds.Length;idx++)
            {
                string skillStr = autoSkillIds[idx];
                int[] temp = StringUtil.split2Int(skillStr, ':');
                int level = 1;
                if (temp.Length > 1)
                    level = temp[1];

                BaseSkill skill = new BaseSkill(temp[0], level, idx+1,mSkillOwner.Gender,mSkillOwner.Profession,mSkillOwner.JobStage,mSkillOwner.JobBranch);
                mSkills[idx] = skill;
            }
        }
    }

    public void InitPassiveSkills(string[] skillIds)
    {
        if (skillIds == null) return;

        if (mPassiveSkills == null)
            mPassiveSkills = new List<BaseSkill>();
        else
            mPassiveSkills.Clear();

        if (skillIds != null)
        {
            for (int idx = 0; idx < skillIds.Length; idx++)
            {
                string skillStr = skillIds[idx];
                int[] temp = StringUtil.split2Int(skillStr, ':');
                int level = 1;
                if (temp.Length > 1)
                    level = temp[1];              
                int skillId = temp[0];
                
                if (HasPassiveSkill(skillId))
                    return;

                BaseSkill skill = new BaseSkill(skillId, level, SkillType.Passive, mSkillOwner.Gender, mSkillOwner.Profession, mSkillOwner.JobStage, mSkillOwner.JobBranch);
                mPassiveSkills.Add(skill);
            }
        }        
    }

    public void InitRandomSkills(SkillParam[] skillParams)
    {
        if (skillParams == null) return;


        if (mRandomSkills == null)
            mRandomSkills = new List<BaseSkill>();
        else
            mRandomSkills.Clear();

        if (mPassiveSkills == null)
            mPassiveSkills = new List<BaseSkill>();
        else
            mPassiveSkills.Clear();

        mTotalRandomRate = 0;
        float factor = 1;
        for(int idx =0; idx < skillParams.Length;idx++)
        {
            BaseSkill skill = new BaseSkill(skillParams[idx].skillId, skillParams[idx].skillLv, SkillType.Attack1, mSkillOwner.Gender, mSkillOwner.Profession, mSkillOwner.JobStage, mSkillOwner.JobBranch);
            if(skill.IsPassiveSkill)
            {
                skill.SkillTypeID = SkillType.Passive;
                mPassiveSkills.Add(skill);
            }
            else
            {
                skill.SkillTypeID = SkillType.Attack1;
                skill.TriggerRate = skillParams[idx].skillRate;
                mTotalRandomRate += skill.TriggerRate;
                factor *= (1 - skill.TriggerRate * 0.01f); 
                mRandomSkills.Add(skill);
            }
        }

        if(factor < 1)
        {
            mTotalRandomRate = (int)(mTotalRandomRate / (1 - factor));
        }

    }

    public void SetReserveSkill(int skillId)
    {
        if(skillId == 0)
        {
            mReserveSkill = null;
        }
        else
        {
            mReserveSkill = new BaseSkill(skillId, 1, SkillType.Attack1, mSkillOwner.Gender, mSkillOwner.Profession, mSkillOwner.JobStage, mSkillOwner.JobBranch);
        }
    }

    public void InitNormalSkills(string[] normalSkillIds)
    {
        if (normalSkillIds != null)
        {
            mNormalSkills = new BaseSkill[normalSkillIds.Length];

            for (int idx = 0; idx < normalSkillIds.Length; idx++)
            {
                string skillStr = normalSkillIds[idx];
                int[] temp = StringUtil.split2Int(skillStr, ':');

                int level = 1;
                if (temp.Length > 1)
                    level = temp[1];

                BaseSkill normalSkill = new BaseSkill(temp[0], level, SkillType.NormalAttack,mSkillOwner.Gender,mSkillOwner.Profession,mSkillOwner.JobStage,mSkillOwner.JobBranch);
                mNormalSkills[idx] = normalSkill;
            }
        }
    }

    public void InitAlternativeSkills(string[] skillIds)
    {
        if (skillIds != null)
        {
            for (int idx = 0; idx < skillIds.Length; idx++)
            {
                string skillStr = skillIds[idx];
                int[] temp = StringUtil.split2Int(skillStr, ':');
                int level = 1;
                if (temp.Length > 1)
                    level = temp[1];
                AddAlternativeSkill(temp[0], level, SkillType.Alternative);
            }
        }
    }

    public void AddAlternativeSkill(int skillId,int level,int skillTypeId)
    {
        if(mAlternativeSkills == null)
        {
            mAlternativeSkills = new List<BaseSkill>();
        }

        if (HasAlternativeSkill(skillId))
            return;

        BaseSkill skill = new BaseSkill(skillId, level,skillTypeId, mSkillOwner.Gender,mSkillOwner.Profession,mSkillOwner.JobStage,mSkillOwner.JobBranch);
        mAlternativeSkills.Add(skill);
    }

    public BaseSkill GetAlternativeSkillById(int skillId)
    {
        if (mAlternativeSkills == null) return null;

        for(int idx =0; idx < mAlternativeSkills.Count;idx++)
        {
            if (mAlternativeSkills[idx].Id == skillId)
                return mAlternativeSkills[idx];
        }

        return null;
    }

    public bool HasPassiveSkill(int skillId)
    {
        if (mPassiveSkills == null) return false;

        for (int idx = 0; idx < mPassiveSkills.Count; idx++)
        {
            if (mPassiveSkills[idx].Id == skillId)
                return true;
        }
        return false;
    }

    public bool HasAlternativeSkill(int skillId)
    {
        if (mAlternativeSkills == null) return false;

        for(int idx =0; idx < mAlternativeSkills.Count;idx++)
        {
            if (mAlternativeSkills[idx].Id == skillId)
                return true;
        }
        return false;
    }

    public bool ChangeSkill(int fromSkillId,int toSkillId)
    {
        BaseSkill newSkill = GetAlternativeSkillById(toSkillId);
        if (newSkill == null) return false;

        if (mNormalSkills != null)
        {
            for(int idx =0; idx < mNormalSkills.Length;idx++)
            {
                if(mNormalSkills[idx].Id == fromSkillId)
                {
                    BaseSkill skill1 = mNormalSkills[idx];
                    mNormalSkills[idx] = newSkill;
                    newSkill.SkillTypeID = skill1.SkillTypeID;
                    skill1.SkillTypeID = SkillType.Alternative;
                    newSkill.SetLevel(skill1.Level);
                    mAlternativeSkills.Remove(newSkill);
                    mAlternativeSkills.Add(skill1);
                    //DebugHelper.LogError("ChangeSkill: " + fromSkillId + " ----" + toSkillId);
                    return true;
                }
            }
        }

        if(mSkills!=null)
        {
            for(int idx =0; idx < mSkills.Length;idx++)
            {
                if (mSkills[idx].Id == fromSkillId)
                {
                    BaseSkill skill1 = mSkills[idx];
                    mSkills[idx] = newSkill;
                    newSkill.SkillTypeID = skill1.SkillTypeID;
                    skill1.SkillTypeID = SkillType.Alternative;
                    newSkill.SetLevel(skill1.Level);
                    mAlternativeSkills.Remove(newSkill);
                    mAlternativeSkills.Add(skill1);
                    //DebugHelper.LogError("ChangeSkill: " + fromSkillId + " ----" + toSkillId);
                    return true;
                }
            }
        }

        return false;
    }

    public bool SetSkillLevels(List<SkillParam> skillParams,bool bIsForceLoad = false)
    {
        if (skillParams == null) return false;

        if (mSkills == null)
            mSkills = new BaseSkill[skillParams.Count];
        if(mSkills.Length< skillParams.Count)
        {
            mSkills = new BaseSkill[skillParams.Count];
        }

        bool needLoadSkillData = false;
        for(int idx = skillParams.Count-1; idx >= 0 ;idx--)
        {
            BaseSkill skill = mSkills[idx];
            if((skill == null || skill.Id != skillParams[idx].skillId) || bIsForceLoad)
            {
                skill = new BaseSkill(skillParams[idx].skillId, skillParams[idx].skillLv, (idx+1),mSkillOwner.Gender,mSkillOwner.Profession,mSkillOwner.JobStage,mSkillOwner.JobBranch);
                mSkills[idx] = skill;
                skill.Load(mSkillOwner.Gender,mSkillOwner.Profession,mSkillOwner.JobStage,mSkillOwner.JobBranch);
                needLoadSkillData = true;
            }
            else
            {
                skill.SetLevel(skillParams[idx].skillLv);
            }
        }

        return needLoadSkillData;
    }

    public void LoadSkills()
    {
        if (mSkills == null) return;

        for(int idx =0; idx < mSkills.Length;idx++)
        {
            mSkills[idx].Load(mSkillOwner.Gender, mSkillOwner.Profession, mSkillOwner.JobStage, mSkillOwner.JobBranch);
        }
    }

    public void LoadNorlSkills()
    {
        if (mNormalSkills == null) return;

        for (int idx = 0; idx < mNormalSkills.Length; idx++)
        {
            mNormalSkills[idx].Load(mSkillOwner.Gender, mSkillOwner.Profession, mSkillOwner.JobStage, mSkillOwner.JobBranch);
        }
    }
    public BaseSkill GetSkill(int SkillSeq)
    {
        if (SkillSeq == 0)
            return GetNormalSkill();

        if (mSkills == null) return null;

        if (SkillSeq > mSkills.Length) return null;

        return mSkills[SkillSeq-1];
    }


    private BaseSkill mCurRandomSkill = null;
    public BaseSkill GetRandomSkill(int SkillSeq)
    {
        if (SkillSeq == 0)
            return GetNormalSkill();

        if (mRandomSkills == null || mRandomSkills.Count == 0) return null;

        if(mCurRandomSkill != null)
        {
            return mCurRandomSkill;
        }
        else
        {
            int random = UnityEngine.Random.Range(0, mTotalRandomRate);

            mCurRandomSkill = null;
            int rate = 0;
            for(int idx =0; idx < mRandomSkills.Count;idx++)
            {
                rate += mRandomSkills[idx].TriggerRate;
                if (random<= rate)
                {
                    mCurRandomSkill = mRandomSkills[idx];
                    break;
                }
            }

            if (mCurRandomSkill == null)
                mCurRandomSkill = mReserveSkill;
            return mCurRandomSkill;
        }
    }

    public BaseSkill GetRandomSkillById(int SkillSeq,int skillId)
    {
        if (SkillSeq == 0)
            return GetNormalSkill(skillId);

        if (mRandomSkills == null) return null;

        for(int idx =0; idx < mRandomSkills.Count;idx++)
        {
            if (mRandomSkills[idx].Id == skillId) return mRandomSkills[idx];
        }

        if (mReserveSkill != null && mReserveSkill.Id == skillId) return mReserveSkill;

        return null;
    }

    public BaseSkill GetSkill(int SkillSeq, int skillId)
    {
        if (SkillSeq == 0)
            return GetNormalSkill(skillId);

        if (mSkills == null) return null;

        if (SkillSeq > mSkills.Length) return null;

        return mSkills[SkillSeq - 1];
    }

    public BaseSkill GetNormalSkill()
    {
        if (mNormalSkills == null)
            return null;

        if (normalSkillIdx >= mNormalSkills.Length)
            normalSkillIdx = 0;

        return mNormalSkills[normalSkillIdx];
    }

    public BaseSkill GetNormalSkill(int skillId)
    {
        if (mNormalSkills == null)
            return null;

        for (int idx = 0; idx < mNormalSkills.Length; idx++)
        {
            if (mNormalSkills[idx].Id == skillId)
            {
                normalSkillIdx = idx;
                return mNormalSkills[idx];
            }
        }
        return null;
    }

    public void AddNormalAttackIndex()
    {
        normalSkillIdx++;
    }

    public void ResetRandomSkill()
    {
        mCurRandomSkill = null;
    }

    public void Dispose()
    {
        CleanSkillData();
    }

    public void CleanSkillData()
    {
        if (mSkills != null)
        {
            for (int idx = 0; idx < mSkills.Length; idx++)
                mSkills[idx] = null;
            mSkills = null;
        }

        mNormalSkills = null;

        if (mRandomSkills != null)
            mRandomSkills.Clear();

        if (mPassiveSkills != null)
            mPassiveSkills.Clear();

        if (mAlternativeSkills != null)
            mAlternativeSkills.Clear();
    }
}
