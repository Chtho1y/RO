using UnityEngine;
using System.Collections;

public struct FighterStateBeHitParam
{
	public int hitMoveType;
    public Fix64 moveInitSpeed;
    public Fix64 moveAcceleration;
    public FixVector3 hitMovePos;
	public Fix64 stiffTime;

	public FighterStateBeHitParam (int moveType, Fix64 initSpeed, Fix64 acceleration, FixVector3 movePos, Fix64 stifftime)
	{
		hitMoveType = moveType;
        moveInitSpeed = initSpeed;
        moveAcceleration = acceleration;
		hitMovePos = movePos;
        this.stiffTime = stifftime;
    }
}

public class FighterStateBeHit : FighterState
{
	public static FighterState Creator (Fighter fighter)
	{
		return new FighterStateBeHit (fighter);
	}

	public FighterStateBeHit (Fighter fighter) 
        : base (fighter, FighterStateType.BeHit, true)
	{
		mAnimName = FighterAnimatorHash.StateBeHit1;
	}

	FighterStateBeHitParam mParam;
	public override void OnEnter (FighterStateType fromState, object param)
	{
        base.OnEnter(fromState, param);
        mParam = (FighterStateBeHitParam)param;
        if(mParam.hitMoveType > 0)
        {
			//DebugHelper.LogError(" ----fighter:" + mFighter.Name + " hitMoveType:" + mParam.hitMoveType + " initSpeed:" + mParam.moveInitSpeed + " acceleration:" + mParam.moveAcceleration + " movePos:" + mParam.hitMovePos);
			mFighter.PassiveMove.BeHitToMove(mParam.hitMoveType, mParam.moveInitSpeed, mParam.moveAcceleration, mParam.hitMovePos);
            mStateData.SetStarkTime(mFighter.PassiveMove.MoveTime);
        }

		if(!string.IsNullOrEmpty(mFighter.HitSound))
		{
			MusicMgr.Instance.PlayFightSound(mFighter.HitSound);
		}
    }

	public override void Update (float deltaTime)
	{
        //if(mParam.hitMoveType > 0)
        //{
        //    mFighter.PassiveMove.Update(deltaTime);
        //}
	}

	public override void OnLeave()
	{
		base.OnLeave();
		if (!string.IsNullOrEmpty(mFighter.HitSound))
		{
			MusicMgr.Instance.RemoveSound(mFighter.HitSound);
		}
	}

	public override void OnDataChanged ()
	{
		if (!mStateData.IsAlive)
			mStateData.ChangeState(mStateData.IsGround ? FighterStateType.Die : FighterStateType.BeHitDown);
		else if (mStateData.IsVertigo)
			mStateData.ChangeState(FighterStateType.Vertigo);
		else if (mStateData.IsSleep)
			mStateData.ChangeState(FighterStateType.Sleep);
		else if (mStateData.IsStark)
			mStateData.ChangeState(FighterStateType.Stark);
		else if (!mStateData.IsStiff)
			mStateData.ChangeState(mStateData.GetIdleNext());
	}

	public override FighterStateType GetTriggerNextState (FighterStateTriggerType triggerType, int checkVal = 0)
	{
		switch (triggerType)
        {
		    case FighterStateTriggerType.Attack:
				    return FighterStateType.Attack;
		    case FighterStateTriggerType.BeHit:
			    return FighterStateType.BeHit;
            case FighterStateTriggerType.Run:
                return FighterStateType.Run;
            case FighterStateTriggerType.NavRun:
                return FighterStateType.NavRun;
		    default:
			    return FighterStateType.None;
		}
	}
}
