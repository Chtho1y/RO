using UnityEngine;
using System.Collections;

public class FighterStateResurrection : FighterState
{
	public static FighterState Creator (Fighter fighter)
	{
		return new FighterStateResurrection (fighter);
	}

	public FighterStateResurrection (Fighter fighter) 
        : base (fighter, FighterStateType.Revive)
	{
		mAnimName = FighterAnimatorHash.StateResurrection;
	}

	public override void OnEnter (FighterStateType fromState, object param)
	{
        base.OnEnter(fromState, param);
    }

	public override void Update (float deltaTime)
	{

	}

	public override void OnDataChanged ()
	{
		if (mStateData.IsVertigo)
			mStateData.ChangeState(FighterStateType.Vertigo);
		else if (mStateData.IsSleep)
			mStateData.ChangeState(FighterStateType.Sleep);
		else if (mStateData.IsStark)
			mStateData.ChangeState (FighterStateType.Stark);
		else
			mStateData.ChangeState(mStateData.GetIdleNext());
	}

	public override FighterStateType GetTriggerNextState (FighterStateTriggerType triggerType, int checkVal = 0)
	{
		switch (triggerType) {

		    case FighterStateTriggerType.BeHit:
			    if (checkVal > 0)
				    return FighterStateType.BeHit;
			    else
				    return FighterStateType.None;
            case FighterStateTriggerType.NavRun:
                return FighterStateType.NavRun;
            case FighterStateTriggerType.Run:
                return FighterStateType.Run;
			case FighterStateTriggerType.Attack:
				return mFighter.CurrentBattleField.IsPlayingRecorder ? FighterStateType.Attack : FighterStateType.None;
			default:
			    return FighterStateType.None;
		}
	}
}
