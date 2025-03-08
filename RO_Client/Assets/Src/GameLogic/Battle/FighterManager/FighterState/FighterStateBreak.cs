using UnityEngine;
using System.Collections;

public class FighterStateBreak : FighterState
{
    public static FighterState Creator(Fighter fighter)
    {
        return new FighterStateBreak(fighter);
    }

    public FighterStateBreak(Fighter fighter)
        : base(fighter, FighterStateType.Break)
    {
    }

    public override void OnEnter(FighterStateType fromState, object param)
    {
        base.OnEnter(fromState, param);
        mAnimName = FighterAnimatorHash.StateBreak;
    }

    public override void Update(float deltaTime)
    {
    }

    public override void OnDataChanged()
    {
        if (!mStateData.IsAlive)
            mStateData.ChangeState(mStateData.IsGround ? FighterStateType.Die : FighterStateType.BeHitDown);
        else if (mStateData.IsVertigo)
            mStateData.ChangeState(mStateData.IsGround ? FighterStateType.Vertigo : FighterStateType.BeHitDown);
        else if (mStateData.IsSleep)
            mStateData.ChangeState(mStateData.IsGround ? FighterStateType.Sleep : FighterStateType.BeHitDown);
        else if (mStateData.IsStark)
            mStateData.ChangeState(mStateData.IsGround ? FighterStateType.Stark : FighterStateType.BeHitDown);
        else
            mStateData.ChangeState(mStateData.GetIdleNext());
    }

    public override void OnLeave()
    {
        base.OnLeave();
    }

    public override FighterStateType GetTriggerNextState(FighterStateTriggerType triggerType, int checkVal = 0)
    {
        switch (triggerType)
        {
            case FighterStateTriggerType.BeHit:
                return FighterStateType.BeHit;
            case FighterStateTriggerType.Attack:
                return mFighter.CurrentBattleField.IsPlayingRecorder ? FighterStateType.Attack : FighterStateType.None;
            default:
                return FighterStateType.None;
        }
    }
}
