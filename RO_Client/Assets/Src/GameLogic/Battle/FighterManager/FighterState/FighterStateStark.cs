using UnityEngine;
using System.Collections;

public class FighterStateStark : FighterState
{
	public static FighterState Creator (Fighter fighter)
	{
		return new FighterStateStark (fighter);
	}

	public FighterStateStark (Fighter fighter) 
        : base (fighter, FighterStateType.Stark)
	{
	}

	public override void OnEnter (FighterStateType fromState, object param)
	{
        base.OnEnter(fromState, param);
        if (mFighter.Ctrl != null)
			mFighter.Ctrl.PauseAnim ();
	}

	public override void Update (float deltaTime)
	{

		//mFighter.PassiveMove.Update (deltaTime);
	}

	public override void OnDataChanged ()
	{
		if (!mStateData.IsAlive)
			mStateData.ChangeState(mStateData.IsGround ? FighterStateType.Die : FighterStateType.BeHitDown);
		else if (mStateData.IsVertigo)
			mStateData.ChangeState(FighterStateType.Vertigo);
		else if (mStateData.IsSleep)
			mStateData.ChangeState(FighterStateType.Sleep);
		else if (!mStateData.IsGround)
			mStateData.ChangeState(FighterStateType.Down);
		else if (!mFighter.IsNavRun)
			mStateData.ChangeState(FighterStateType.Idle);
    }

	public override void OnLeave ()
	{
		base.OnLeave ();
		if (mFighter.Ctrl != null)
			mFighter.Ctrl.ResumeAnim ();
	}

	public override FighterStateType GetTriggerNextState (FighterStateTriggerType triggerType, int checkVal = 0)
	{
		switch(triggerType)
		{
			case FighterStateTriggerType.Attack:
				return mFighter.CurrentBattleField.IsPlayingRecorder ? FighterStateType.Attack : FighterStateType.None;
			default:
				return FighterStateType.None;
		}
	}
}
