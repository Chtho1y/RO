using UnityEngine;
using System.Collections;

public class FighterStateDown : FighterState
{
	public static FighterState Creator (Fighter fighter)
	{
		return new FighterStateDown (fighter);
	}

	public FighterStateDown (Fighter fighter) 
        : base (fighter, FighterStateType.Down)
	{

	}

	public override void OnEnter (FighterStateType fromState, object param)
	{
        base.OnEnter(fromState, param);
    }

	public override void Update (float deltaTime)
	{
		//mFighter.PassiveMove.Update (deltaTime);
	}

	public override void OnDataChanged ()
	{
		if (!mStateData.IsAlive)
			mStateData.ChangeState(FighterStateType.BeHitDown);
		else if (mStateData.IsVertigo)
			mStateData.ChangeState(FighterStateType.Vertigo);
		else if (mStateData.IsSleep)
			mStateData.ChangeState(FighterStateType.Sleep);
		else if (mStateData.IsStark)
			mStateData.ChangeState(FighterStateType.Stark);
		else if (mStateData.IsGround)
			mStateData.ChangeState(FighterStateType.Idle);
	}

	public override FighterStateType GetTriggerNextState (FighterStateTriggerType triggerType, int checkVal = 0)
	{
		switch (triggerType) {
		    case FighterStateTriggerType.BeHit:
                return FighterStateType.BeHit;
            case FighterStateTriggerType.NavRun:
                return FighterStateType.NavRun;
			case FighterStateTriggerType.Attack:
				return mFighter.CurrentBattleField.IsPlayingRecorder ? FighterStateType.Attack : FighterStateType.None;
			default:
			    return FighterStateType.None;
		}
	}
}
