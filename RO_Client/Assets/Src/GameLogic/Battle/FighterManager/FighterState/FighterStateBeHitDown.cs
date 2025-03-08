using UnityEngine;
using System.Collections;

public class FighterStateBeHitDown : FighterState
{
	const float state_end_time = 0.5f;

	public static FighterState Creator (Fighter fighter)
	{
		return new FighterStateBeHitDown (fighter);
	}

	public FighterStateBeHitDown (Fighter fighter) 
        : base (fighter, FighterStateType.BeHitDown)
	{
        mAnimName = FighterAnimatorHash.StateBeHitDown;
    }

	public override void OnEnter (FighterStateType fromState, object param)
	{
        base.OnEnter(fromState, param);
    }

	public override void Update (float deltaTime)
	{
        if (!mStateData.IsAlive)
            mStateData.ChangeState(FighterStateType.Die);
    }

	public override void OnDataChanged ()
	{
		if (mStateData.IsStark)
			mStateData.ChangeState (FighterStateType.Stark);
	}

	public override FighterStateType GetTriggerNextState (FighterStateTriggerType triggerType, int checkVal = 0)
	{
		switch (triggerType) {
		    case FighterStateTriggerType.BeHit:
			    return FighterStateType.BeHit;
            case FighterStateTriggerType.NavRun:
                return FighterStateType.NavRun;
		    default:
			    return FighterStateType.None;
		}
	}
}
