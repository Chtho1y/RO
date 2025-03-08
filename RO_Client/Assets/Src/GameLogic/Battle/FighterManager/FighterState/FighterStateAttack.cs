using UnityEngine;
using System.Collections;

public struct FighterStateAttackParam
{
	public int attackInt;
	public BaseSkill skill;

	public FighterStateAttackParam(int idx, BaseSkill skill)
	{
		this.attackInt = idx;
		this.skill = skill;
	}
}

public class FighterStateAttack : FighterState
{
	public static FighterState Creator (Fighter fighter)
	{
		return new FighterStateAttack (fighter);
	}

	public FighterStateAttack (Fighter fighter) 
        : base (fighter, FighterStateType.Attack, true)
	{
	}

	public FighterStateAttackParam mAttackParam;

	public override void OnEnter (FighterStateType fromState, object param)
	{
       
        mAttackParam = (FighterStateAttackParam)param;
		if (mAttackParam.attackInt > 0)
			mFighter.ShowSkillName(mAttackParam.skill.SkillName);

		if (mAttackParam.skill != null)
        {
            mAnimName = mAttackParam.skill.IsSingSkill ? mAttackParam.skill.SkillSingAnimName : mAttackParam.skill.SkillAnimName;
            mStateData.SkillStateData.OnEnter (mAttackParam.skill);
        }
        base.OnEnter(fromState, param);
    }

	public override void Update (float deltaTime)
	{
		if (mAttackParam.skill != null)
        {
            if (mStateData.SkillStateData.IsNormalEnd)
            {
                mStateData.ChangeState(mStateData.GetIdleNext());
            }
        }
        else { 
			mStateData.ChangeState (mStateData.GetIdleNext ());
        }
    }

	public override void OnLeave ()
	{
        base.OnLeave();
        if (mAttackParam.skill != null) {
			mStateData.SkillStateData.OnLeave ();
			mAttackParam.skill = null;
		}

        if(mFighter.Ctrl.Animator != null)
            mFighter.Ctrl.Animator.speed = 1.0f;
	}

	public override void OnDataChanged ()
	{
		if (mAttackParam.attackInt == 5)
			return;

		if (!mStateData.IsAlive)
			mStateData.ChangeState(mStateData.IsGround ? FighterStateType.Die : FighterStateType.BeHitDown);
		else if(mStateData.IsVertigo)
			mStateData.ChangeState(mStateData.IsGround ? FighterStateType.Vertigo : FighterStateType.BeHitDown);
		else if(mStateData.IsSleep)
			mStateData.ChangeState(mStateData.IsGround ? FighterStateType.Sleep : FighterStateType.BeHitDown);
		else if(mStateData.IsStark)
			mStateData.ChangeState (FighterStateType.Stark); 
    }

	public override FighterStateType GetTriggerNextState (FighterStateTriggerType triggerType, int checkVal = 0)
	{
		switch (triggerType) {
		    case FighterStateTriggerType.BeHit:
			    return checkVal > 0? FighterStateType.BeHit:FighterStateType.None;
			case FighterStateTriggerType.Attack:
				return mFighter.CurrentBattleField.IsPlayingRecorder ? FighterStateType.Attack : FighterStateType.None;
			default:
			    return FighterStateType.None;
		}
	}
}
