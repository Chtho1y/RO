using UnityEngine;
using System.Collections;

public class FighterStateDownIdle : FighterState
{
	const float state_end_time = 0.5f;

	public static FighterState Creator (Fighter fighter)
	{
		return new FighterStateDownIdle (fighter);
	}

	public FighterStateDownIdle (Fighter fighter) 
        : base (fighter, FighterStateType.DownIdle)
	{
	}

    int nOverFrame = 0;
    public override void OnEnter (FighterStateType fromState, object param)
	{
        base.OnEnter(fromState, param);
        nOverFrame = ChangeFrame(state_end_time);
        m_nFrame = 0;
    }

	public override void Update (float deltaTime)
	{
        m_nFrame += 1;
		if (m_nFrame == nOverFrame)
		{
			if(mStateData.IsAlive)
				mStateData.ChangeState(mStateData.GetIdleNext());
			else
				mStateData.ChangeState(FighterStateType.Die);
		}
			
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
			    if (checkVal > 0)
				    return FighterStateType.BeHit;
			    else
				    return FighterStateType.None;
            case FighterStateTriggerType.NavRun:
                return FighterStateType.NavRun;
			case FighterStateTriggerType.Attack:
				return mFighter.CurrentBattleField.IsPlayingRecorder ? FighterStateType.Attack : FighterStateType.None;
			default:
			    return FighterStateType.None;
		}
	}
}
