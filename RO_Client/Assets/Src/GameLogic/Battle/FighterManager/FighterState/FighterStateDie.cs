using UnityEngine;
using System.Collections;

public class FighterStateDie : FighterState
{
	public static FighterState Creator (Fighter fighter)
	{
		return new FighterStateDie (fighter);
	}

	public FighterStateDie (Fighter fighter) 
        : base (fighter, FighterStateType.Die)
	{
		mAnimName = FighterAnimatorHash.StateDie;
	}

    int nOverFrame = 0;
    public override void OnEnter (FighterStateType fromState, object param)
	{
        base.OnEnter(fromState, param);
        EffectManager.Instance.RemoveEffectByOwnerFighter(mFighter);
		mStateData.DyingTime = 2.0f;
		if(!string.IsNullOrEmpty(mFighter.DieSound))
		{
			MusicMgr.Instance.PlayFightSound(mFighter.DieSound);
		}
        nOverFrame = ChangeFrame(mStateData.DyingTime);
        m_nFrame = 0;
	}

	public override void Update (float deltaTime)
	{
        m_nFrame += 1;        
		if(mFighter.IsSummoned && m_nFrame == nOverFrame)
		{
			mFighter.Dispose();
		}
	}


	public override void OnLeave()
	{
		base.OnLeave();
		if (!string.IsNullOrEmpty(mFighter.DieSound))
		{
			MusicMgr.Instance.RemoveSound(mFighter.DieSound);
		}
	}

	public override void OnDataChanged ()
	{
		if (mStateData.IsAlive && (mFighter.IsPlayer || mFighter.IsPet)) {
            mStateData.ChangeState (FighterStateType.Revive);
        }
    }

	public override FighterStateType GetTriggerNextState (FighterStateTriggerType triggerType, int checkVal = 0)
	{
        return FighterStateType.None;
    }
}
