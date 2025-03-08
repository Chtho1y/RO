using UnityEngine;
using System.Collections;

public class FighterStateComing : FighterState
{
    public static FighterState Creator(Fighter fighter)
    {
        return new FighterStateComing(fighter);
    }

    public FighterStateComing(Fighter fighter)
        :base(fighter,FighterStateType.Coming)
    {
        mAnimName = FighterAnimatorHash.StateComing;
    }

    int nOverFrame = 0;
    public override void OnEnter(FighterStateType fromState, object param)
    {
        base.OnEnter(fromState, param);
        nOverFrame = ChangeFrame(mFighter.ComingTime);       
        m_nFrame = 0;
    }

    public override void Update(float deltaTime)
    {
        m_nFrame += 1;
        if(m_nFrame >= nOverFrame)
        {
            mStateData.ChangeState(FighterStateType.Idle);
        }
    }

    public override void OnDataChanged()
    {

    }

    public override FighterStateType GetTriggerNextState(FighterStateTriggerType triggerType, int checkVal = 0)
    {
        return FighterStateType.None;
    }
}
