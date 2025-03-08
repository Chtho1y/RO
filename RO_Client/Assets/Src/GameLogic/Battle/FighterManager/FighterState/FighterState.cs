using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public enum FighterStateType
{
	None = 0,
	Idle,
    Coming,     //出场
	Attack,
	BeHit,
	Die,
	Down,
	DownIdle,
	BeHitDown,
	Revive,
	Vertigo,
	Stark,
    NavRun,
	Run,
	Jump,
	Victory,
    Break,
	Sleep,
}

public enum FighterStateTriggerType
{
	Attack,
	BeHit,
    NavRun,
	Run,
	Jump,
}
	
delegate FighterState FighterStateCreator (Fighter fighter);

public abstract class FighterState
{
	static Dictionary<FighterStateType, FighterStateCreator> creators;
	static Dictionary<Fighter, Dictionary<FighterStateType, FighterState>> cached_fighter_states;

	public static void RegistCacheFighterState (Fighter fighter)
	{
		if (cached_fighter_states == null)
			cached_fighter_states = new Dictionary<Fighter, Dictionary<FighterStateType, FighterState>> ();
		cached_fighter_states.Add (fighter, new Dictionary<FighterStateType, FighterState> ());
	}

	public static void UnregistCacheFighterState (Fighter fighter)
	{
		if (cached_fighter_states != null && cached_fighter_states.ContainsKey (fighter))
			cached_fighter_states.Remove (fighter);
	}

	public static FighterState Create (Fighter fighter, FighterStateType state)
	{
        if (fighter == null) return null;

		if (creators == null)
			RegisterCreators ();

		bool useCache = cached_fighter_states != null && cached_fighter_states.ContainsKey (fighter);
		if (useCache && cached_fighter_states [fighter].ContainsKey (state))
			return cached_fighter_states [fighter] [state];
		
		if (creators.ContainsKey (state)) {
			FighterState resultState = creators [state] (fighter);
			if (useCache)
				cached_fighter_states [fighter].Add (state, resultState);
			return resultState;
		}
			
		return null;
	}

	static void RegisterCreators ()
	{
		creators = new Dictionary<FighterStateType, FighterStateCreator> ();
		creators.Add (FighterStateType.Idle, FighterStateIdle.Creator);
        creators.Add(FighterStateType.Coming, FighterStateComing.Creator);
		creators.Add (FighterStateType.Attack, FighterStateAttack.Creator);
		creators.Add (FighterStateType.BeHit, FighterStateBeHit.Creator);
		creators.Add (FighterStateType.Die, FighterStateDie.Creator);
		creators.Add (FighterStateType.Down, FighterStateDown.Creator);
		creators.Add (FighterStateType.DownIdle, FighterStateDownIdle.Creator);
		creators.Add (FighterStateType.BeHitDown, FighterStateBeHitDown.Creator);
		creators.Add (FighterStateType.Revive, FighterStateResurrection.Creator);
		creators.Add (FighterStateType.Vertigo, FighterStateVertigo.Creator);
		creators.Add (FighterStateType.Stark, FighterStateStark.Creator);
        creators.Add (FighterStateType.NavRun, FigterStateNavRun.Creator);
		creators.Add (FighterStateType.Run, FighterStateRun.Creator);
        creators.Add (FighterStateType.Break, FighterStateBreak.Creator);
		creators.Add (FighterStateType.Sleep, FighterStateSleep.Creator);
	}

	protected FighterStateType mState;
	protected Fighter mFighter;
	protected FighterStateData mStateData;
	protected string mAnimName;
    protected int m_nFrame = 0;

	protected FighterState (Fighter fighter, FighterStateType state, bool reentrant = false)
	{
		mFighter = fighter;
		mState = state;
		Reentrant = reentrant;
		mStateData = fighter.StateData;
		mAnimName = FighterAnimatorHash.StateIdle;
        m_nFrame = 0;
    }

	public FighterStateType State { get { return mState; } }

	public bool Reentrant { get; private set; }

	public bool IsAnimValid { get { return mFighter.Ctrl.Animator != null; } }

    public virtual void OnEnter(FighterStateType fromState, object param)
    {
        //string strinfo;
        //if (mFighter.Id == 4)
        //{
        //    if (mState == FighterStateType.Run)
        //    {
        //        strinfo = string.Format("Frame = {0},FightId = {1},State = {2}-----Enter",
        //       mFighter.Battle.FrameCount.ToString(),
        //       mFighter.Id.ToString(),
        //       mState.ToString()
        //       );

        //        //FighterStateAttack pAttack = this as FighterStateAttack;
        //        //string strskillinfo = string.Format("-------skillName ={0}",
        //        //pAttack.mAttackParam.skill.SkillName
        //        //);
        //        //strinfo += strskillinfo;
        //        Debug.Log(strinfo);
        //    }
        //}
    }

	public virtual void OnLeave ()
	{
        //string strinfo;
        //if (mFighter.Id == 4)
        //{
        //    if (mState == FighterStateType.Run)
        //    {
        //        strinfo = string.Format("Frame = {0},FightId = {1},State = {2}-----Leave",
        //        mFighter.Battle.FrameCount.ToString(),
        //        mFighter.Id.ToString(),
        //        mState.ToString()
        //        );
        //        Debug.Log(strinfo);
        //    }   
        //}
    }

	public virtual void Update (float deltaTime)
	{
	}

    public void SetAnimatorSpeed(float speed)
    {
        if(mFighter.Ctrl.Animator != null)
		{
			mFighter.Ctrl.Animator.SetFloat("moveSpeed", speed);
		}
    }

    public void ForcePlayAnim(string animName)
    {
        mAnimName = animName;
        PlayAnimState();
    }

	public void PlayAnimState ()
	{
        if (string.IsNullOrEmpty(mAnimName)) return;

		if (mAnimName == FighterAnimatorHash.StateIdle)
			return;

        if (mFighter.Ctrl.Animator == null)
            return;

        if (mFighter.Ctrl.Animator.gameObject.activeInHierarchy) {
            mFighter.Ctrl.Animator.SetFloat("moveSpeed", 1);
            mFighter.Ctrl.Animator.Play(mAnimName);
        }
    }

	public bool CheckAnimState ()
	{
		if (mAnimName == FighterAnimatorHash.StateIdle)
			return false;

        if (mFighter.Ctrl.Animator == null)
            return false;

        if (mFighter.Ctrl.Animator.runtimeAnimatorController!= null && mFighter.Ctrl.Animator.GetCurrentAnimatorStateInfo (0).IsName(mAnimName))
        {
			return true;
		} else
			return false;
	}

    protected int ChangeFrame(float fTime)
    {
        float fComingFrame = fTime / 30f;
        int nAddFrame = fComingFrame - (int)fComingFrame > 0.0f ? 1 : 0;
        int nOverFrame = (int)fComingFrame + nAddFrame;
        return nOverFrame;
    }

	public abstract void OnDataChanged ();

	public abstract FighterStateType GetTriggerNextState (FighterStateTriggerType triggerType, int checkVal = 0);
}
