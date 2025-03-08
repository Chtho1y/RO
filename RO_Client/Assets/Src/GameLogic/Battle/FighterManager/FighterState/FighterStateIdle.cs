using UnityEngine;
using System.Collections;

public class FighterStateIdle : FighterState
{
	public static FighterState Creator (Fighter fighter)
	{
		return new FighterStateIdle (fighter);
	}

	public FighterStateIdle (Fighter fighter) 
        : base (fighter, FighterStateType.Idle)
	{
		mAnimName = FighterAnimatorHash.StateIdle;
	}

	public override void OnEnter (FighterStateType fromState, object param)
	{
        base.OnEnter(fromState, param);
        if (mFighter.IsVisible && mFighter.Ctrl!=null && mFighter.Ctrl.gameObject.activeInHierarchy && mFighter.Ctrl.Animator.runtimeAnimatorController!=null)
            mFighter.Ctrl.Animator.Play(mAnimName);

		if (!string.IsNullOrEmpty(mFighter.IdleSound))
		{
			MusicMgr.Instance.PlayFightSound(mFighter.IdleSound);
		}
	}

	public override void OnLeave()
	{
		base.OnLeave();
		if (!string.IsNullOrEmpty(mFighter.IdleSound))
		{
			MusicMgr.Instance.RemoveSound(mFighter.IdleSound);
		}
	}

	public override void OnDataChanged ()
	{
		if (!mStateData.IsAlive)
			mStateData.ChangeState(mStateData.IsGround ? FighterStateType.Die : FighterStateType.BeHitDown);
		else if (mStateData.IsVertigo)
			mStateData.ChangeState(mStateData.IsGround ? FighterStateType.Vertigo : FighterStateType.BeHitDown);
		else if (mStateData.IsSleep)
			mStateData.ChangeState(mStateData.IsGround ? FighterStateType.Sleep : FighterStateType.BeHitDown);
		else if (mStateData.IsStark)
			mStateData.ChangeState(FighterStateType.Stark);	
		else if (!mStateData.IsGround)
			mStateData.ChangeState(FighterStateType.Down);
	}

	public override FighterStateType GetTriggerNextState (FighterStateTriggerType triggerType, int checkVal = 0)
	{
		switch (triggerType) {
		    case FighterStateTriggerType.Attack:
			    return FighterStateType.Attack;
		    case FighterStateTriggerType.BeHit:
                return FighterStateType.BeHit;
            case FighterStateTriggerType.NavRun:
                return FighterStateType.NavRun;
		    case FighterStateTriggerType.Run:
			    return FighterStateType.Run;
		    default:
			    return FighterStateType.None;
		}
	}
}
