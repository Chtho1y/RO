using UnityEngine;
using System.Collections;

public class PassiveMove
{
	Fighter mFighter;
    int mMoveType = 0;
    Fix64 mAcceleration;
    Fix64 mVelocity = Fix64.Zero;
    Fix64 mInitVelocity = Fix64.Zero;
    FixVector3 mDestPos = FixVector3.Zero;
    Fix64 mMoveTime = Fix64.Zero;      //浮空时长
    Fix64 mCurrentTime = Fix64.Zero;
    bool mMoveEnd = true;
    int mFrame = 0;
    int mTotalFrame = 0;

    FixVector3 SelfStartPos;
    FixVector3 SelfForward;
    Fix64 fStartSpeed;
    Fix64 fAcceleration;
    FixVector3 mTargetPosition;
    public PassiveMove (Fighter fighter)
	{
		mFighter = fighter;
	}

	public BattleField Field{ get { return mFighter.CurrentBattleField; } }

	public bool IsGround { get { return Field == null || PositionHeight <= (Fix64)mFighter.CurrentBattleField.FloorY; } }

	public Fix64 PositionHeight { get { return (Fix64)mFighter.Position.y; } }

	public Fix64 MoveTime { get { return mMoveTime; } }

    public void BeHitToMove(int moveType,Fix64 initSpeed, Fix64 acceleration,FixVector3 destPos)
    {
        Stop();

        mMoveType = moveType;
        SelfStartPos = new FixVector3(mFighter.Position);
        mTargetPosition = destPos;
        SelfForward = mTargetPosition - SelfStartPos;
        SelfForward.Normalize();
        fStartSpeed = initSpeed;
        fAcceleration = acceleration;
        mMoveEnd = false;
        //Debug.Log("Start destPos" + destPos.ToString());

        Fix64 dist = FixVector3.Distance(destPos, SelfStartPos);
        if (Fix64.Abs(acceleration) > 0)
        {
            Fix64 fvalue = (Fix64)2 * acceleration * dist + initSpeed * initSpeed;
            if(fvalue > Fix64.Zero)
            {
                Fix64 vt = Fix64.Sqrt(fvalue);
                mMoveTime = Fix64.Abs(vt - initSpeed) / acceleration;
            }
            else
            {
                Fix64 timeV = initSpeed / Fix64.Abs(acceleration);
                mMoveTime = mMoveTime < timeV ? mMoveTime : timeV;
            }
        }
        else
        {
            if (initSpeed > 0)
                mMoveTime = dist / initSpeed;
            else
                mMoveTime = Fix64.Zero;
        }
        mMoveEnd = false;
        mFrame = 0;
        mTotalFrame = (int)(mMoveTime * (Fix64)Constants.frame_to_time) + 2;

        //string strinfo = string.Format("Start Hit PassiveMove FieldFrame = {0},stateFrame = {1}, mTotalFrame= {2},mMoveTime = {3},dist = {4},mAcceleration = {5},mDestPos = {6}",
        //            Field.BattleFrame.ToString(), Field.CurrentStateFrame.ToString(), mTotalFrame.ToString(), mMoveTime.ToString(), dist.ToString(), mAcceleration.ToString(), mDestPos.ToString());
        //Debug.Log(strinfo);
        //DebugHelper.LogError(mFighter.Name+"----BeHitToMove :" + mMoveType + " movetime:" + mMoveTime + " acc:" + mAcceleration + " dist:" + dist + " initSpeed:" + initSpeed + " destPos:" + destPos.ToString() + " pos:" + mFighter.Position + " mLastHeight:" + mLastHeight);
    }

	public void Update (float deltaTime)
	{
        if (!mMoveEnd)
        {
            mFrame += 1;
            //帧数差值
            //帧数差值  
            Fix64 fLerpTime = (Fix64)mFrame * (Fix64)0.03f;
            Fix64 fDis = fStartSpeed * fLerpTime + (Fix64)0.5f * fAcceleration * fLerpTime * fLerpTime;
            FixVector3 pos = SelfStartPos + SelfForward * fDis;

            FixVector3 v3Forward = mTargetPosition - pos;
            v3Forward.Normalize();
            if (FixVector3.Dot(SelfForward, v3Forward) <= Fix64.Zero)
            {
                mFighter.SyncPosition(mTargetPosition.ToVector3());
                Stop();
                if (!IsGround)
                {
                    DownToGround();
                }
                return;
            }

            mFighter.Ctrl.MoveTo(pos);
           // Debug.Log("fAcceleration" + fAcceleration.ToString() + "dist =" + fDis.ToString() + "mFrame =" + (mFrame / mTotalFrame).ToString() + "pos" + pos.ToString());
            if (mFrame >= mTotalFrame)
            {
                mFighter.SyncPosition(pos.ToVector3());
                Stop();
                if (!IsGround)
                {
                    DownToGround();
                }
                return;
            }
        }
    }

    void DownToGround()
    {
        //Debug.Log("Start Down!!!!");
        FixVector3 pos = new FixVector3( mFighter.Position);
        pos.y = (Fix64)mFighter.CurrentBattleField.FloorY;

        BeHitToMove((int)FighterMoveType.Beat_Down, Fix64.Zero, (Fix64)Constants.gravity, pos);
        mFighter.StateData.SetStarkTime(mMoveTime);
    }

    void Stop()
    {
        //Debug.Log("End PassiveMove!!");
        mCurrentTime = Fix64.Zero;
        mMoveEnd = true;
        mFighter.StateData.SetStarkTime((Fix64)Constants.s_starkStopTime);
    }
}
