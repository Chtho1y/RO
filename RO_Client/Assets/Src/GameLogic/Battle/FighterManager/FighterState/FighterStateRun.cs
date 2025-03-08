using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public struct FighterStateRunParam
{
    public Fighter chaseTarget;
    public Vector3 runDest;
    public float stopDist;

	public FighterStateRunParam (Fighter target, Vector3 dest, float stopDist)
	{
        chaseTarget = target;
        runDest = dest;
        this.stopDist = stopDist;
    }
}

public class FighterStateRun : FighterState
{
	public static FighterState Creator (Fighter fighter)
	{
		return new FighterStateRun (fighter);
	}

	public FighterStateRun (Fighter fighter) 
        : base (fighter, FighterStateType.Run)
	{
		mAnimName = FighterAnimatorHash.StateRun;
	}

	FighterStateRunParam mParam;
    Vector3 mMoveDestPos = Vector3.zero;
    FixVector3 mLastDestPos;
    bool bChaseTarget = false;
    Fighter mChaseFighter = null;
    float mStopDist = 0;
    Fix64 mMoveSpeedPerFrame = Fix64.Zero;

    Fix64 mMoveToOverFrame = Fix64.Zero;
    int nFrame = 0;
    public override void OnEnter (FighterStateType fromState, object param)
	{
        base.OnEnter(fromState, param);
        mParam = (FighterStateRunParam)param;
        if(mFighter.Ctrl!=null)
        {
            MoveTo(mParam.runDest, mParam.chaseTarget != null, mParam.chaseTarget,mParam.stopDist);
            #region DebugLog
            /*
            if (mFighter.Id == 4)
            {
                string info = string.Format("Frame = {0},From pos ={1}, Move pos={2},mMoveSpeedPerFrame={3}", 
                    mFighter.Battle.FrameCount.ToString(), 
                    mFighter.Position.ToString(),
                    mMoveDestPos.ToString(),
                    mMoveSpeedPerFrame.ToString());
               
                Debug.Log("Start MoveTo-------" + info);
            }
            */
            #endregion
        }
        else
        {
            mFighter.SyncPosition(mParam.runDest);
        }
    }

    public override void Update (float deltaTime)
	{
        //进入播放会有播放动画失败情况 此处保护
        if (!CheckAnimState())
            PlayAnimState();
        UpdateCurrentPos();
    }

    private void UpdateCurrentPos()
    {
        CheckDestPos();
        FixVector3 Pos = new FixVector3(mLastDestPos);
        FixVector3 MovePos = new FixVector3(mMoveDestPos);
        FixVector3 Forward = MovePos - Pos;
        Forward.Normalize();
        FixVector3 EndPos = Pos + Forward * mMoveSpeedPerFrame;       
        FixVector3 EndForward = (MovePos - EndPos);
        EndForward.Normalize();
        Fix64 fDot = FixVector3.Dot(Forward, EndForward);
        
        if (fDot <= Fix64.Zero)
        {
            EndPos = MovePos;
            mFighter.Ctrl.EndMoveTo();
            mChaseFighter = null;
            mFighter.SyncPosition(MovePos.ToVector3());
            mFighter.StateData.ChangeState(mFighter.StateData.GetIdleNext());
            return;
        }
        #region DebugLog
        //if (mFighter.Id == 10003)
        //{
        //    string info = string.Format("Frame = {0},From pos ={1}, Move pos={2},mMoveSpeedPerFrame={3}",
        //        mFighter.Battle.FrameCount.ToString(),
        //        Pos.ToString(),
        //        EndPos.ToString(),
        //        mMoveSpeedPerFrame.ToString());

        //    Debug.Log("UpdateCurrentPos111 MoveTo-------" + info);
        //}       
        #endregion
        mLastDestPos = EndPos;
        mFighter.Ctrl.MoveTo(EndPos);//表现帧 差值一帧
        if (Pos == EndPos)
        {          
            mChaseFighter = null;
            mFighter.SyncPosition(MovePos.ToVector3());
            mFighter.StateData.ChangeState(mFighter.StateData.GetIdleNext());
        }
    }

    private void MoveTo(Vector3 destPos, bool chaseTarget, Fighter chaseFighter, float stopDist)
    {
        bChaseTarget = chaseTarget;
        mMoveDestPos = destPos;
        mLastDestPos = new FixVector3(mFighter.Position);
        mChaseFighter = chaseFighter;
        mStopDist = stopDist;
        mMoveSpeedPerFrame = (Fix64)mFighter.MoveSpeed / (Fix64)Constants.frame_to_time;

        CheckDestPos();

        mFighter.LookAt(mMoveDestPos);
    }

    private void CheckDestPos()
    {
        FixVector3 dest = new FixVector3(mMoveDestPos);
        if (bChaseTarget)
        {
            if (mChaseFighter == null || !mChaseFighter.IsAlive)
            {
                mChaseFighter = null;
                mFighter.StateData.ChangeState(mFighter.StateData.GetIdleNext());
                return;
            }

            FixVector3 tPos = new FixVector3(mChaseFighter.Position);
            FixVector3 selfPos = new FixVector3(mFighter.Position);
            tPos.y = (Fix64)mFighter.CurrentBattleField.FloorY;
            selfPos.y = (Fix64)mFighter.CurrentBattleField.FloorY;

            FixVector3 dir = (tPos - selfPos);
            dir.Normalize();
            Fix64 dist = FixVector3.Distance(tPos, selfPos);
            dist = dist - (Fix64)mStopDist;
            dist = dist < Fix64.Zero ? Fix64.Zero : dist;
            dest = selfPos + dist * dir;
            #region DebugLog
            //if (mFighter.Id == 10003)
            //{
            //    string info = string.Format("Frame = {0},mFighter pos ={1}, mChaseFighter pos={2},dir = {3},mStopDist = {4},dist = {5},dest = {6}",
            //        mFighter.Battle.FrameCount.ToString(),
            //        selfPos.ToString(),
            //        tPos.ToString(),
            //        dir.ToString(),
            //        ((Fix64)mStopDist).ToString(),
            //        dist.ToString(),
            //        dest.ToString());

            //    Debug.Log("CheckDestPos MoveTo-------" + info);
            //}
            #endregion
        }
        dest.y = (Fix64)mFighter.CurrentBattleField.FloorY;
        mMoveDestPos = dest.ToVector3();
    }


    public override void OnLeave()
    {
        mFighter.SyncPosition(mMoveDestPos);
        mFighter.Ctrl.HideRunSmoke();
        mFighter.SpeedRatio = 1;
        base.OnLeave();
    }

    public override void OnDataChanged ()
	{
        if (!mStateData.IsAlive)
            mStateData.ChangeState(FighterStateType.Die);
        else if (mStateData.IsVertigo)
            mStateData.ChangeState(FighterStateType.Vertigo);
        else if (mStateData.IsSleep)
            mStateData.ChangeState(FighterStateType.Sleep);
        else if (mStateData.IsStark)
            mStateData.ChangeState(FighterStateType.Stark);
        else
            mStateData.ChangeState(mStateData.GetIdleNext());

    }

	public override FighterStateType GetTriggerNextState (FighterStateTriggerType triggerType, int checkVal = 0)
	{
		switch (triggerType)
        {
		    case FighterStateTriggerType.BeHit:
			    if (checkVal > 0)
				    return FighterStateType.BeHit;
			    else
				    return FighterStateType.None;
            case FighterStateTriggerType.Attack:
                if(mFighter.CurrentBattleField.IsPlayingRecorder)
                {
                    return FighterStateType.Attack;
                }
                else
                {
                    return FighterStateType.None;
                }
            default:
			    return FighterStateType.None;               
		}
	}
}
