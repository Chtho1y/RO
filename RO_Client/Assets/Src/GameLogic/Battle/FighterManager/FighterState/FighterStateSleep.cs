using UnityEngine;
using System.Collections;

public class FighterStateSleep : FighterState
{
    public static FighterState Creator(Fighter fighter)
    {
        return new FighterStateSleep(fighter);
    }


    public FighterStateSleep(Fighter fighter)
        :base(fighter,FighterStateType.Sleep)
    {
        mAnimName = FighterAnimatorHash.StateSleep;
    }

    public override void OnEnter(FighterStateType fromState, object param)
    {
        base.OnEnter(fromState, param);
    }

    public override void Update(float deltaTime)
    {
        base.Update(deltaTime);
    }

    public override void OnLeave()
    {
        base.OnLeave();
    }

    public override void OnDataChanged()
    {
        if (!mStateData.IsAlive)
            mStateData.ChangeState(mStateData.IsGround ? FighterStateType.Die : FighterStateType.BeHitDown);
        else if (mStateData.IsVertigo)
            mStateData.ChangeState(FighterStateType.Vertigo);
        else if(mStateData.IsStark)
            mStateData.ChangeState(FighterStateType.Stark);
        else
            mStateData.ChangeState(mStateData.GetIdleNext());
    }

    public override FighterStateType GetTriggerNextState(FighterStateTriggerType triggerType, int checkVal = 0)
    {
        switch (triggerType)
        {
            case FighterStateTriggerType.BeHit:
                return checkVal > 0 ? FighterStateType.BeHit : FighterStateType.None;
            case FighterStateTriggerType.Attack:
                return mFighter.CurrentBattleField.IsPlayingRecorder ? FighterStateType.Attack : FighterStateType.None;
            default:
                return FighterStateType.None;
        }
    }
}
