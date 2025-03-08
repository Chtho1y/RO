using UnityEngine;
using System.Collections;

public class FigterStateNavRun : FighterState
{
    public static FighterState Creator(Fighter fighter)
    {
        return new FigterStateNavRun(fighter);
    }

    public FigterStateNavRun(Fighter fighter)
        : base(fighter, FighterStateType.NavRun)
    {
        mAnimName = FighterAnimatorHash.StateWalk;
    }

    public override void OnEnter(FighterStateType fromState, object param)
    {
        //DebugHelper.LogError("------FigterStateNavRun----:"+mFighter.DestPosition);
        mFighter.RunToWithNav(mFighter.DestPosition);
        if(!string.IsNullOrEmpty(mFighter.RunSound))
        {
            MusicMgr.Instance.PlayFightSound(mFighter.RunSound,true);
        }
    }

    public override void Update(float deltaTime)
    {
        //DebugHelper.LogError("name:" + mFighter.Name+" pos:"+mFighter.Position.ToString()+" destPos:"+mFighter.DestPosition.ToString());
        if (mFighter.Position.x.FEqual(mFighter.DestPosition.x, 0.5f) && mFighter.Position.z.FEqual(mFighter.DestPosition.z, 0.5f) && mFighter.Position.y.FEqual(mFighter.DestPosition.y, 0.5f))
        {
            mFighter.SetPosition(mFighter.DestPosition);
            mFighter.LookAt(mFighter.DestPosition);
            mStateData.ChangeState(mStateData.GetIdleNext());
        }else
        {
            if(!mFighter.Ctrl.NavAgentEnabled && !BattleMgr.Instance.IsLoadingBattleAssets)
            {
                mFighter.Ctrl.EnableNavAgent(true);
            }
        }
    }

    public override void OnLeave()
    {
        base.OnLeave();
        mFighter.Ctrl.EnableNavAgent(false);
        EventMgr.DispatchEvent<int>(new CoreEvent<int>(ECoreEventType.EID_Fighter_Move_End, mFighter.Actor.BaseId));

        if (!string.IsNullOrEmpty(mFighter.RunSound))
        {
            MusicMgr.Instance.RemoveSound(mFighter.RunSound);
        }
    }

    public override void OnDataChanged()
    {
        if (!mStateData.IsAlive)
            mStateData.ChangeState(FighterStateType.Die);
        else if (mStateData.IsVertigo)
            mStateData.ChangeState(FighterStateType.Vertigo);
        else if (mStateData.IsSleep)
            mStateData.ChangeState(FighterStateType.Sleep);
        else if (mStateData.IsStark)
            mStateData.ChangeState(FighterStateType.Stark);
    }

    public override FighterStateType GetTriggerNextState(FighterStateTriggerType triggerType, int checkVal = 0)
    {
        switch (triggerType)
        {
            case FighterStateTriggerType.BeHit:
                if (checkVal > 0)
                    return FighterStateType.BeHit;
                else
                    return FighterStateType.None;
            case FighterStateTriggerType.Run:
                return FighterStateType.Run;
            case FighterStateTriggerType.NavRun:
                return FighterStateType.NavRun;
            default:
                return FighterStateType.None;
        }
    }
}
