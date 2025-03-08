using UnityEngine;
using System.Collections;

public class FighterStateVertigo : FighterState
{
	public static FighterState Creator (Fighter fighter)
	{
		return new FighterStateVertigo (fighter);
	}

	public FighterStateVertigo (Fighter fighter) 
        : base (fighter, FighterStateType.Vertigo)
	{
		mAnimName = FighterAnimatorHash.StateVertigo;
	}

	public override void OnEnter (FighterStateType fromState, object param)
	{
        base.OnEnter(fromState, param);
        mFighter.ProcessVertigo(true);
    }

	public override void Update (float deltaTime)
	{
	}

    public override void OnLeave()
    {
        mFighter.ProcessVertigo(false);
        base.OnLeave();
    }

    public override void OnDataChanged ()
	{
		if (!mStateData.IsAlive)
			mStateData.ChangeState(mStateData.IsGround ? FighterStateType.Die : FighterStateType.BeHitDown);
		else if (mStateData.IsSleep)
			mStateData.ChangeState(FighterStateType.Sleep);
		else if (mStateData.IsStark)
			mStateData.ChangeState(FighterStateType.Stark);
		else
			mStateData.ChangeState(mStateData.GetIdleNext());
	}

	public override FighterStateType GetTriggerNextState (FighterStateTriggerType triggerType, int checkVal = 0)
	{
		switch (triggerType) {
            case FighterStateTriggerType.BeHit:
                return checkVal > 0 ? FighterStateType.BeHit : FighterStateType.None;
			case FighterStateTriggerType.Attack:
				return mFighter.CurrentBattleField.IsPlayingRecorder ? FighterStateType.Attack : FighterStateType.None;
			default:
			    return FighterStateType.None;
		}
	}
}
