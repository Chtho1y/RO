using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class ProfessionData
{
    #region properties
    private int mID;
    private string mName;
    private string mDesc;
    private int mPosition;
    private int mProfessionType;
    private int mProfessionBranch;
    private int mStep;
    private int mMaxProfessionLv;
    private int mLastProfessionId;
    private bool mIsReincarnation;
    private int mUpgradeBaseLv;
    private int mUpgradeJobLv;
    private SInt mHpRate;
    private SInt mSpRate;
    private SInt mAtkRate;
    private SInt mMagicAtkRate;
    private SInt mDefRate;
    private SInt mMagicDefRate;
    private SInt mHitRate;
    private SInt mDodgeRate;
    private SInt mCritRate;
    private SInt mTenacityRate;
    private SInt mAttackSpeed;
    private string[] mNormalSkillIds;
    private string[] mSkillIds;
    private string[] mAlternativeSkills;
    private int mWeaponType;
    private int mNatureId;
    private string mIcon;
    #endregion

    #region fileds
    public int ID { get { return mID; } }
    public string Name { get { return mName; } }
    public string Desc { get { return mDesc; } }
    public int Position { get { return mPosition; } set { mPosition = value; } }
    public int ProfessionType { get { return mProfessionType; } }
    public int ProfessionBranch { get { return mProfessionBranch; } }
    public int Step { get { return mStep; } }
    public int MaxProfessionLv { get { return mMaxProfessionLv; } }
    public int LastProfessionId { get { return mLastProfessionId; } }
    public bool IsReincarnation { get { return mIsReincarnation; } }
    public int UpgradeBaseLv { get { return mUpgradeBaseLv; } }
    public int UpgradeJobLv { get { return mUpgradeJobLv; } }

    public SFloat HpRate { get { return mHpRate * 0.0001f; } }
    public SFloat SpRate { get { return mSpRate * 0.0001f; } }
    public SFloat AtkRate { get { return mAtkRate * 0.0001f; } }
    public SFloat MagicAtkRate { get { return mMagicAtkRate * 0.0001f; } }
    public SFloat DefRate { get { return mDefRate * 0.0001f; } }
    public SFloat MagicDefRate { get { return mMagicDefRate * 0.0001f; } }
    public SFloat HitRate { get { return mHitRate * 0.0001f; } }
    public SFloat DodgeRate { get { return mDodgeRate * 0.0001f; } }
    public SFloat CritRate { get { return mCritRate * 0.0001f; } }
    public SFloat TenacityRate { get { return mTenacityRate * 0.0001f; } }
    public SFloat AttackSpeed { get { return mAttackSpeed; } }
    public int WeaponType { get { return mWeaponType; } }

    public string[] NormalSkillIds { get { return mNormalSkillIds; } }

    public string[] SkillIds { get { return mSkillIds; } }

    public string[] AlternativeSkills { get { return mAlternativeSkills; } }

    public int NatureId { get { return mNatureId; } }
    public string Icon
    {
        get { return mIcon; }
    }

    private bool isValid = false;
    public bool valid
    {
        get { return isValid; }
    }
    #endregion

    public ProfessionData(int id)
    {
        //DebugHelper.Log("profession Id:" + id);
        Dictionary<string, string> dic = ConfigMgr.Instance.getLine(id, Config.JobCfgName);
        if(dic!=null)
        {
            this.mID = id;
            this.mName = dic["JobName"];
            this.mDesc = dic["Desc"];
            this.mIcon = dic["JobIcon"];
            int.TryParse(dic["Position"], out this.mPosition);
            int.TryParse(dic["JobType"], out this.mProfessionType);
            int.TryParse(dic["JobBranch"], out this.mProfessionBranch);
            int.TryParse(dic["JobStage"], out this.mStep);
            int.TryParse(dic["MaxJobLv"], out this.mMaxProfessionLv);
            int.TryParse(dic["BeforeJobId"], out this.mLastProfessionId);

            int temp = 0;
            int.TryParse(dic["Again"], out temp);
            this.mIsReincarnation = temp > 0;

            int.TryParse(dic["UpBaseLV"], out this.mUpgradeBaseLv);
            int.TryParse(dic["UpJobLv"], out this.mUpgradeJobLv);

            int.TryParse(dic["HpRate"], out temp);
            this.mHpRate = temp;

            int.TryParse(dic["SpRate"], out temp);
            this.mSpRate = temp;

            int.TryParse(dic["AtkRate"], out temp);
            this.mAtkRate = temp;

            int.TryParse(dic["MatkRate"], out temp);
            this.mMagicAtkRate = temp;

            int.TryParse(dic["DefRate"], out temp);
            this.mDefRate = temp;

            int.TryParse(dic["MdefRate"], out temp);
            this.mMagicDefRate = temp;

            int.TryParse(dic["HitRate"], out temp);
            this.mHitRate = temp;

            int.TryParse(dic["DodgeRate"], out temp);
            this.mDodgeRate = temp;

            int.TryParse(dic["CritRate"], out temp);
            this.mCritRate = temp;

            int.TryParse(dic["TenRate"], out temp);
            this.mTenacityRate = temp;

            int.TryParse(dic["Aspd"], out temp);
            this.mAttackSpeed = temp;
            // int.TryParse(dic["ArmsType"], out this.mWeaponType);

            if (dic.ContainsKey("NormalSkillIds"))
            {
                mNormalSkillIds = StringUtil.split(dic["NormalSkillIds"], ';');
            }

            if(dic.ContainsKey("SkillIds"))
            {
                mSkillIds = StringUtil.split(dic["SkillIds"], ';');
            }

            if(dic.ContainsKey("AlternativeSkills"))
            {
                mAlternativeSkills = StringUtil.split(dic["AlternativeSkills"], ';');
            }

            if(dic.ContainsKey("NatureId"))
            {
                int.TryParse(dic["NatureId"], out mNatureId);
            }
            isValid = true;
        }
    }

    public void Dispose()
    {
        isValid = false;
        mNormalSkillIds = null;
        mSkillIds = null;
    }
}
