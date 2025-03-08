using UnityEngine;
using System;

public class SkillMoveProcessor
{
	readonly Fighter mFighter;
    float mAcceleration;
    float mInitSpeed;
	float mSpeed;
	FixVector3 mTargetPosition;
	bool mMoveEnd = true;
    FixVector3 SelfStartPos;
    FixVector3 SelfForward;
    Fix64 fStartSpeed;
    Fix64 fAcceleration;
    int mTotalFrame = 0;
    int mFrame = 0;
    public Fix64 PositionHeight { get { return (Fix64)mFighter.Position.y; } }
    public BattleField Field { get { return mFighter.CurrentBattleField; } }
    public bool IsGround { get { return Field == null || PositionHeight <= (Fix64)mFighter.CurrentBattleField.FloorY; } }

    public bool IsMoving
    {
        get { return !mMoveEnd; }
    }

    public bool IsMovingUp
    {
        get { return mTargetPosition.y - (Fix64)mFighter.Position.y > Fix64.Zero; }
    }

	public SkillMoveProcessor (Fighter fighter)
	{
		mFighter = fighter;
	}

	public void Start (Fix64 initSpeed,Fix64 acceleration, FixVector3 destPos)
	{
		Stop ();
        SelfStartPos = new FixVector3(mFighter.Position);
        mTargetPosition = destPos;
        SelfForward = mTargetPosition - SelfStartPos;
        SelfForward.Normalize();
        fStartSpeed = initSpeed;
        fAcceleration = acceleration;
        mMoveEnd = false;
        //Debug.Log("Start destPos" + destPos.ToString());

        Fix64 dist = FixVector3.Distance(destPos, SelfStartPos);

        Fix64 time = Fix64.Zero;
        if (Fix64.Abs(acceleration) > 0)
        {
            Fix64 fvalue = (Fix64)2 * acceleration * dist + initSpeed * initSpeed;
            if (fvalue > Fix64.Zero)
            {
                Fix64 vt = Fix64.Sqrt(fvalue);
                time = Fix64.Abs(vt - initSpeed) / acceleration;
            }
            else
            {
                Fix64 timeV = initSpeed / Fix64.Abs(acceleration);
                time = time < timeV ? time : timeV;
            }
        }
        else
        {
            if(initSpeed > 0)
                time = dist / initSpeed;
            else
                time = Fix64.Zero;
        }
        mTotalFrame = (int)(time * (Fix64)Constants.frame_to_time) + 2;

        //if (mFighter.IsBoss)
        //    DebugHelper.LogError(mFighter.Name+"------------SkillMoveProcessor:"+ initSpeed+ " acceleration:"+ acceleration+ " destPos:"+ destPos.ToString()+" curPos:"+mFighter.Position.ToString()+" duration:"+mTime);
    }

	public void Stop ()
	{
		mMoveEnd = true;
        mFrame = 0;
        //if (mFighter.IsBoss)
        //    DebugHelper.LogError("------------Stop:");
    }

	public void Update (float deltaTime)
	{
		if (!mMoveEnd)
        {
            mFrame++;
            //帧数差值  
            Fix64 fLerpTime = (Fix64)mFrame * (Fix64)0.03f;    
            Fix64 fDis = fStartSpeed * fLerpTime + (Fix64)0.5f * fAcceleration * fLerpTime * fLerpTime;
            FixVector3 pos = SelfStartPos + SelfForward * fDis;
            //Debug.Log("fAcceleration" + fAcceleration.ToString() + "dist =" + fDis.ToString() + "mFrame =" + (mFrame/ mTotalFrame).ToString() + "pos"+ pos.ToString());
            FixVector3 v3Forward = mTargetPosition - pos;
            v3Forward.Normalize();
            if (FixVector3.Dot(SelfForward, v3Forward) <= Fix64.Zero)
            {
                mFighter.SyncPosition(mTargetPosition.ToVector3());
                Stop();
                return;
            }
            //mFighter.SyncPosition(pos.ToVector3());
            mFighter.Ctrl.MoveTo(pos);
            if (mFrame >= mTotalFrame)
            {
                mFighter.SyncPosition(pos.ToVector3());
                Stop();               
                return;
            }
        }
	}
    
}

