using UnityEngine;
using System;

public class FighterStateData
{
	Fighter mFighter;
	SInt mLife;
    SInt mMana;
    SInt mRage;
    Fix64 mStarkTime;
	float mVertigoTime;
	float mDyingTime;
	float mStiffTime;
	float mAnimTime;
	bool mIsGround = true;
	float mLastBeHitTime;
	bool mIsUnead;
	bool mIsAlive;
	int mStateFrame;
    float mAnimSpeed = 1.0f;
	FighterState mState;
	FighterSkillStateData mSkillStateData;
	FighterBuffManager mBuffMgr;
    FighterBuffFunctionMgr mFuncMgr;
    MarkMgr mMarkMgr;

	bool mIgnoreStateDataChange;

	public FighterStateData (Fighter fighter)
	{
		mFighter = fighter;
		mSkillStateData = new FighterSkillStateData (fighter);
		mBuffMgr = new FighterBuffManager (fighter);
        mFuncMgr = new FighterBuffFunctionMgr(fighter);
        mMarkMgr = new MarkMgr(fighter);
        
	}

	public bool IsDisposed { get; private set; }

	public FighterState State { get { return mState; } }

	public FighterStateType StateId { get { return mState != null ? mState.State : FighterStateType.None; } }

	public FighterSkillStateData SkillStateData { get { return mSkillStateData; } }

	public FighterBuffManager BuffMgr { get { return mBuffMgr; } }

    public FighterBuffFunctionMgr FuncMgr { get { return mFuncMgr; } }

    public MarkMgr MMarkMgr { get { return mMarkMgr; } }
     
	public BaseSkill CurrentSkill { get { return mSkillStateData.Skill; } }

	public bool IsStateDirty { get; private set; }

    public bool IsFixLife { get; set; }

    public bool IsFixMana { get; set; }

    public float AnimSpeed { get { return mAnimSpeed; } }

    public SInt Life {
		get { return mLife; }
		set {
			if (IsFixLife)
				return;
			
			SInt v = Mathf.Max (value, 0);
			if (mLife != v) {
				mLife = v;
                if (mFighter != null && mFighter.Ctrl != null)
                    mFighter.RefreshLife();
				IsAlive = mLife > 0 || mIsUnead;

                //主人死亡时，宠物一并死亡
                if (!IsAlive && mFighter !=null&& mFighter.UsedPetId > 0)
                {
                    Fighter pet = mFighter.FighterMgr.GetFighterByID(mFighter.UsedPetId, mFighter.TeamSide);
                    if (pet != null)
                        pet.Life = 0;
                }
            }
		}
	}

    public SInt Mana
    {
        get { return mMana; }
        set
        {

            if (IsFixMana)
                return;

            SInt v = Mathf.Max(value, 0);
            if (mMana != v)
            {
                mMana = v;
                if (mFighter.Ctrl != null)
                    mFighter.Ctrl.OnManaChanged();
            }
        }
    }

    public SInt Rage
    {
        get { return mRage; }
        set
        {
            if (IsFixRage)
                return;

            SInt v = Mathf.Max(value, 0);
            if (mRage != v)
            {
                mRage = v;
                if (mFighter.Ctrl != null)
                    mFighter.Ctrl.OnRageChanged();
            }
        }
    }

	public bool IsUnead {
		get { return mIsUnead; } 
		set {
			if (mIsUnead != value) {
				mIsUnead = value;
				IsAlive = mLife > 0 || mIsUnead;
			}
		}
	}

	public bool IsAlive {
		get { return mIsAlive; } 
		private set { 
			if (mIsAlive != value) {
				mIsAlive = value;            
                if (mState != null && !mIgnoreStateDataChange)
					mState.OnDataChanged ();
				else
					IsStateDirty = true;
				if (!mIsAlive)
					OnDie ();
			}
		}
	}

    public bool IsFixRage { get; set; }

	public bool IsGround {
		get { return mIsGround; }
		set {
			if (mIsGround != value) {
				mIsGround = value;
				if (mState != null && !mIgnoreStateDataChange)
					mState.OnDataChanged ();
				else
					IsStateDirty = true;
			}
		}
	}

    //免疫状态
    public bool IsImmunity { get; set; }

    //无敌状态
    public bool IsInvincible { get; set; }

    private bool mIsVertigo = false;
    //眩晕状态
    public bool IsVertigo
    {
        get { return mIsVertigo; }
        set
        {
            if(mIsVertigo != value)
            {
                mIsVertigo = value;
                if (mState != null && !mIgnoreStateDataChange)
                    mState.OnDataChanged();
                else
                    IsStateDirty = true;
                if(mIsVertigo)
                {
                    EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_Fighter_Vertigo, mFighter));
                }
            }
        }
    }

    //沉默状态
    public bool IsSilence { get; set; }

    //遗忘状态
    public bool IsForget { get; set; }

    //混乱状态
    public bool IsConfused { get; set; }

    //狂暴状态
    public bool IsRageStatus { get; set; }

    //恐惧状态
    public bool IsFear { get; set; }
    
    //冰冻状态
    public bool IsFrozen { get; set; }

    //睡眠状态
    private bool mIsSleep = false;
    public bool IsSleep {
        get { return mIsSleep; }
        set
        {
            if (mIsSleep != value)
            {
                mIsSleep = value;
                if (mState != null && !mIgnoreStateDataChange)
                    mState.OnDataChanged();
                else
                    IsStateDirty = true;
                if (mIsSleep)
                {
                    EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_Fighter_Sleep, mFighter));
                }
            }
        }
    }

    //石化状态
    public bool IsStiff { get; set; }
    
    //诅咒状态
    public bool IsCurse { get; set; }

    //中毒状态
    public bool IsPoison { get; set; }

    //禁止普攻
    public bool IsForbidNormalSkill { get; set; }

    //嘲讽状态
    public bool IsSneer  { get; set; }

    //僵持状态
	public bool IsStark { get { return mStarkTime > 0; } }

    private bool mIsSing = false;
    //private float mSingTime = 0;  // 吟唱时长
    private int mSingTotalFrame = 0;    //吟唱总帧数
    private int mSingCurFrame = 0;

    //public float SingTime
    //{
    //    get { return mSingTime; }
    //}

    public int SingTotalFrame
    {
        get { return mSingTotalFrame; }
    }

    public bool IsSing { get { return mIsSing; } }

	public float DyingTime {
		get { return mDyingTime; }
		set {
			if (Math.Abs (mDyingTime - value) > Mathf.Epsilon) {
				mDyingTime = value;
				if (mState != null && !mIgnoreStateDataChange)
					mState.OnDataChanged ();
				else
					IsStateDirty = true;
			}
		}
	}

	public float TimeFromLastBeHit { get { return Time.time - mLastBeHitTime; } }

	public FighterStateType GetIdleNext ()
	{
		if (IsStark)
			return FighterStateType.Stark;
		else if (!IsAlive)
			return IsGround ? FighterStateType.Die : FighterStateType.BeHitDown;
		else if (IsVertigo)
			return IsGround ? FighterStateType.Vertigo : FighterStateType.BeHitDown;
		else if (!IsGround)
			return FighterStateType.Down;
		else
			return FighterStateType.Idle;
	}

	public void ValidateDirtyState ()
	{
		if (State != null && IsStateDirty) {
			State.OnDataChanged ();
			IsStateDirty = false;
		}
	}

	public void Update (float deltaTime, bool fighting)
	{
		if (IsDisposed)
			return;

        mStateFrame++;

        if(fighting)
            UpdateSing(deltaTime);

        UpdateStateAnim(deltaTime);

        ValidateDirtyState();

        if (mStarkTime > Fix64.Zero)
        {
            mStarkTime -= (Fix64)0.03f;
            State.OnDataChanged();
        }

        if (mStateFrame > 0 && mState != null)
            mState.Update(deltaTime);

        if (mSkillStateData != null && fighting)
            mSkillStateData.Update(deltaTime);

        if (mBuffMgr != null && fighting)
            mBuffMgr.Update(deltaTime);

        if (mFuncMgr != null && fighting)
            mFuncMgr.Update(deltaTime);

        if (mMarkMgr != null && fighting)
            mMarkMgr.Update(deltaTime);
    }

    public void EndSkill()
    {
        if (mIsSing)
        {
            EndSing();
        }

        if (mSkillStateData != null)
            mSkillStateData.EndSkill();
    }

	public void UpdateStateAnim (float deltaTime)
	{
		if (mState != null)
			mState.CheckAnimState ();
		mAnimTime += deltaTime;
	}

    public void PlayAnim(string animName)
    {
        if (mState != null)
        {
            mState.ForcePlayAnim(animName);
        }
    }

    public void SetAnimSpeed(float animSpeed)
    {
        //if(mAnimSpeed != animSpeed)
        {
            mAnimSpeed = animSpeed;
            if (mState != null)
            {
                mState.SetAnimatorSpeed(mAnimSpeed);
            }
        }
    }

	public void ChangeState (FighterStateType state, object param = null)
	{
		if (StateId == state && (mState == null || !mState.Reentrant))
			return;
		FighterStateType oldStateType = StateId;
		mIgnoreStateDataChange = true;
		if (mState != null)
			mState.OnLeave ();

        //if (mFighter.IsHero)
        //    DebugHelper.LogError("----fighter:" + mFighter.Name + " state:" + state);
        mState = FighterState.Create (mFighter, state);
		if (mState != null) {
			mState.OnEnter (oldStateType, param);
			mState.PlayAnimState ();
			mStateFrame = 0;
			mAnimTime = 0;
			mState.Update (0);
		}
		mIgnoreStateDataChange = false;
	}


	public bool ProcessTrigger (FighterStateTriggerType triggerType, object param = null, int checkVal = 0)
	{
		if (mState == null)
			return false;
		FighterStateType nextState = mState.GetTriggerNextState (triggerType, checkVal);
		if (nextState == FighterStateType.None)
			return false;
		if (triggerType == FighterStateTriggerType.BeHit)
			mLastBeHitTime = Time.time;
		ChangeState (nextState, param);
		return true;
	}

    //开始吟唱
    public void BeginSing(string animName)
    {
        if (CurrentSkill == null)
        {
            return;
        }
        //mSingTime = CurrentSkill.SingTotalTime;
        mSingTotalFrame = (int)(CurrentSkill.SingTotalTime * Constants.frame_to_time);
        mSingCurFrame = mSingTotalFrame;
        mIsSing = true;
        PlayAnim(animName);
    }

    public void EndSing()
    {
        mFighter.EndSing();
        mIsSing = false;
        //mSingTime = 0;
        mSingTotalFrame = 0;
        mSingCurFrame = 0;
    }

    void UpdateSing(float deltaTime)
    {
        //if (mIsSing)
        //{
        //    mSingTime -= deltaTime;
        //    mFighter.RefreshSingProgress(CurrentSkill.SingTotalTime,mSingTime);
        //    if (mSingTime <= 0)
        //    {
        //        EndSing();
        //    }
        //}

        if (mIsSing)
        {
            mSingCurFrame--;
            mFighter.RefreshSingProgress(mSingTotalFrame, mSingCurFrame);
            if (mSingCurFrame <= 0)
            {
                EndSing();
            }
        }
    }

    public void Dispose ()
	{
		if (IsDisposed)
			return;
		IsDisposed = true;
		mBuffMgr.Dispose ();
		mBuffMgr = null;
        mFuncMgr.Dispose();
        mFuncMgr = null;
        mMarkMgr.Dispose();
        mMarkMgr = null;
		mSkillStateData.Dispose ();
		mSkillStateData = null;
		mFighter = null;
	}

    public void Clear()
    {
        if(mBuffMgr!=null)
            mBuffMgr.Clear();

        if(mFuncMgr!=null)
            mFuncMgr.Clear();

        if (mMarkMgr != null)
            mMarkMgr.Clear();

        if (mSkillStateData != null)
            mSkillStateData.Clear();

        mFighter.ClearSkillBuffPoints();

        mFighter.ClearTriggerBuff();

        mStarkTime = Fix64.Zero;
    }

	void OnDie ()
	{
        if (mIsSing)
        {
            EndSing();
        }
        mBuffMgr.Clear();
        mFuncMgr.Clear();
        mMarkMgr.Clear();
        mFighter.OnDie ();
	}

    public void SetStarkTime(Fix64 starkTime)
    {
        mStarkTime = starkTime;
        if(mStarkTime <= Fix64.Zero)
            State.OnDataChanged();
    }
}
