using UnityEngine;
using System.Collections.Generic;

public class FighterSkillStateData
{
    float mNormalAttackCd;            //普通cd时间
    float mSkillCd;                   //技能cd时间  

    int mSkillTotalFrame = 0;
    bool mIsPlaying;
    bool mIsNormalEnd;
    int mNextSkillIdex = 0;

    Fighter mFighter;	
	BulletManager mBulletMgr;

	BaseSkill mSkill;
    List<BattleBuff> mBuffList;
	SkillData mSkillInfo;
	
	SkillMoveProcessor mSkillMoveProcessor;
	SkillHitRange mSkillHitRange;
    FighterStatistics mStatistics;
    SkillActionFrameEvent mFixHurtWordPositionEvt;

    List<int> mTriggeredEffects;
    List<Fighter> mPredictHitFighters;
    List<Fighter> mTempHitFighters;


    public FighterStatistics Statistics { get { return mStatistics; } }


    public FighterSkillStateData (Fighter fighter)
	{
		mFighter = fighter;
		mTriggeredEffects = new List<int> ();
		mSkillMoveProcessor = new SkillMoveProcessor (fighter);
		mSkillHitRange = new SkillHitRange ();
		mBulletMgr = new BulletManager ();
    }

	public BulletManager BulletMgr { get { return mBulletMgr; } }

    public BaseSkill Skill { get { return mSkill; } }

    public SkillHitRange HitRange { get { return mSkillHitRange; } }

    public Fighter CurrentHitFighter { get; private set; }

    public Fighter TargetFighter { get; set; }

    public SkillMoveProcessor MoveProcessor { get { return mSkillMoveProcessor; } }

    public float NormalAttackCd { get { return mNormalAttackCd; } }

	public bool IsNormalEnd { get { return mIsNormalEnd; } }

    public bool IsDisposed { get; private set; }

	public float GetCd (int skillTypeId)
	{
        if(skillTypeId > SkillType.NormalAttack)
        {
            return mSkillCd;
        }
        else
        {
            return mNormalAttackCd;
        }
    }

    public void ResetNormalAttackCd()
    {
        mNormalAttackCd = mFighter.AttackCD;
    }

	public void OnFightingStart ()
	{
        if (mFighter.Battle.BattleStatistics != null)
        {
            if((mFighter.IsPlayer || mFighter.IsBoss || mFighter.IsPet) && !mFighter.IsCloned)
                mStatistics = mFighter.Battle.BattleStatistics.GetFighterStatistics(mFighter);
        }

        mNormalAttackCd = 0;
        BaseSkill firstSkill =  mFighter.GetSkill(SkillType.Attack1);
        if (firstSkill != null)
        {
            mSkillCd = firstSkill.SkillDataInfo.cd;
            mFighter.Ctrl.OnFightingStart(firstSkill);
        } 
        else
        {
             mSkillCd = 0;
        }
    }

	public void ClearAllCd ()
	{
		mNormalAttackCd = 0;
        mSkillCd = 0;
    }

	public void ClearCd (int skillType)
	{
		if (skillType > 0)
			mSkillCd = 0;
		if (skillType == SkillType.NormalAttack)
			mNormalAttackCd = 0;
	}

    public void Dispose ()
	{
		if (IsDisposed)
			return;

        mNextSkillIdex = 0;
		IsDisposed = true;
		mBulletMgr.Clear ();
		mFighter = null;
		mSkill = null;
        mSkillInfo = null;
		mTriggeredEffects = null;
		mPredictHitFighters = null;
		mTempHitFighters = null;
		mSkillMoveProcessor = null;
		mSkillHitRange = null;
        mStatistics = null;
        //DebugHelper.LogError(mFighter.Name + " Dispose");
    }

    public void Clear()
    {
        if (mBulletMgr != null)
            mBulletMgr.Clear();

        mSkillMoveProcessor.Stop();
        mNextSkillIdex = 0;
        mFighter.Actor.ResetFirstSkill();
        ClearAllCd();
    }

	public void OnEnter (BaseSkill skill)
	{
		if (mIsPlaying)
			return;

        mSkill = skill;
		mSkillInfo = skill.SkillDataInfo;
		mIsPlaying = true;

        float totalTime = mSkillInfo.fixedSingTime * (1 - mFighter.FixedSingDecreasePercent) + (Mathf.Max(mSkillInfo.variableSingTime - mFighter.DEX * BattleFormulaParamMgr.Instance.GetParam(28), 0)) * (1 - mFighter.VariableSingDecreasePercent);
        if(totalTime < mSkillInfo.fixedSingTime)
        {
            totalTime = mSkillInfo.fixedSingTime;
        }

        mSkill.SingTotalTime = totalTime;

        float skillTotalTime = mSkill.Duration;
        if (!mSkill.IsSingSkill)
            skillTotalTime = mSkill.Duration * Mathf.Max(1 - mFighter.AttrAttackSpeedPercent, 0.3f) * Mathf.Max(1 - mFighter.SkillAttackSpeedPercent, 0.3f);
            

        mSkillTotalFrame = (int)(skillTotalTime * Constants.frame_to_time);
        //if (!skill.IsNormalAttack) {
        //    mSkillCd = skill.SkillDataInfo.cd + skillTotalTime;
        //}

        mIsNormalEnd = false;
		
        mPredictHitFighters = null;
		mFixHurtWordPositionEvt = null;

        if (mFighter.Ctrl != null)
			mFighter.Ctrl.OnEnterSkill(mSkill);

        if(mSkill!=null)
        {
            for (int idx = 0; idx < mSkill.BuffList.Count; idx++)
            {
                mFighter.CastBuff(mSkill, mSkill.BuffList[idx]);
            }
        }

        if(mStatistics != null)
            mStatistics.OnEnterSkill(mFighter, skill.SkillTypeID, skill.SkillDataInfo.skillIcon,skill.Id,skill.Level);

        if (!mFighter.Battle.IsPlayRecord && mFighter.Battle.Recorder != null)
        {
            mFighter.Battle.Recorder.RecordFighterSkill(mFighter, mSkill.SkillTypeID, mSkill.Id);
        }

        if(!mSkill.IsNormalAttack)
        {
            EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_FIGHTER_DO_SKILL, mFighter));
        }
        if (BattleMgr.Instance.Battle.CanPrintLog)
            DebugHelper.LogError(string.Format("<color=#00ff00>{0} castskill= {1}  skillName={2}   mSkillCd={3}， stateFrame={4}</color>", mFighter.Id, mSkill.Id, mSkill.SkillName, mSkillCd, mFighter.CurrentBattleField.CurrentStateFrame));
    }

	public void Update (float deltaTime)
	{
		if (IsDisposed)
			return;

		mNormalAttackCd -= Constants.s_internaltime;
        mSkillCd -= Constants.s_internaltime;

        mBulletMgr.Update (deltaTime);
		if (mIsPlaying)
        {
			mSkillMoveProcessor.Update (deltaTime);
			UpdateFrame (deltaTime);
        }
	}

	public void OnLeave ()
	{
		if (!mIsPlaying)
			return;
		for (int i = 0; i < mTriggeredEffects.Count; i++)
			EffectManager.Instance.RemoveEffectByInstanceID (mTriggeredEffects [i]);

        if (!mSkill.IsNormalAttack)
        {
            BaseSkill nextSkill = mFighter.GetSkill(mFighter.AI.NextSelectAttack);
            if(nextSkill != null)
            {
                mSkillCd = nextSkill.SkillDataInfo.cd;
            }
            else
            {
                mSkillCd = 0;
            }
        }

        mTriggeredEffects.Clear ();
		mPredictHitFighters = null;
		if (mFighter.Ctrl != null)
			mFighter.Ctrl.OnLeaveSkill (mSkill);

        if(mFighter.AI!=null)
            mNextSkillIdex = mFighter.AI.NextSelectAttack;
        mFighter.EndSkill();
        mIsPlaying = false;
		mSkill = null;
		mSkillInfo = null;
		TargetFighter = null;
		mFixHurtWordPositionEvt = null;
        //DebugHelper.LogError(mFighter.Name + " OnLeave");
    }

    public void EndSkill()
    {
        if(mSkillMoveProcessor.IsMoving && mSkillMoveProcessor.IsMovingUp)
        {
            FixVector3 pos = new FixVector3(mFighter.Position);
            pos.y = (Fix64)mFighter.CurrentBattleField.FloorY;
            mSkillMoveProcessor.Start(Fix64.Zero, (Fix64)Constants.gravity, pos);            
        }

        if (!mIsNormalEnd)
        {
            mIsNormalEnd = true;
        }
    }

    void UpdateFrame(float deltaTime)
    {
        if (mFighter.CurrentBattleField.Result != FightingResult.None && !mIsNormalEnd)
        {
            mIsNormalEnd = true;
        }

        //if (skillTotalTime > 0)
        //{
        //    skillTotalTime -= deltaTime;
        //    if (skillTotalTime <= 0)
        //    {
        //        mIsNormalEnd = true;
        //    }
        //}

        //if(mSkill.SkillName == "冰箭术!!")
        //{
        //    Debug.Log(mSkillTotalFrame.ToString());
        //}

        if(mSkillTotalFrame > 0)
        {
            mSkillTotalFrame--;
            if(mSkillTotalFrame<=0)
            {
                mIsNormalEnd = true;
            }
        }
    }

 //   bool CheckTargetSelectable (Fighter target)
	//{
	//	return target.IsSpawned && !target.IsDisposed && target.IsAlive
	//	&& (mSkill.IsPassiveSkill || target.IsFighting)
	//	&& (SkillSelectHelper.IsSkillCanTargetSelf (mSkill) || target != mFighter);
	//}
}
