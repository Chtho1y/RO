using UnityEngine;
using UnityEditor;

public class MoveProcessor
{
    readonly Transform mCasterTrans;
    float mTime;
    float mAcceleration;
    float mInitSpeed;
    float mSpeed;
    float mCurrentTime;
    Vector3 mTargetPosition;
    bool mMoveEnd = true;

    public bool IsMoving
    {
        get { return !mMoveEnd; }
    }

    public bool IsMovingUp
    {
        get { return mTargetPosition.y - mCasterTrans.position.y > 0; }
    }

    public MoveProcessor(Transform caster)
    {
        mCasterTrans = caster;
    }

    public void Start(float initSpeed, float acceleration, Vector3 destPos)
    {
        Stop();

        mTargetPosition = destPos;

        mAcceleration = acceleration;
        mInitSpeed = initSpeed;
        mMoveEnd = false;
        float dist = Vector3.Distance(destPos, mCasterTrans.position);
        if (Mathf.Abs(acceleration) > 0)
        {
            float temp = initSpeed / Mathf.Abs(acceleration);
            mTime = Mathf.Sqrt(dist + temp * temp) - temp;
        }
        else
        {
            mTime = dist / initSpeed;
        }

        Debug.LogError("击退时间:" + mTime+" dist:"+dist);
    }

    public void Stop()
    {
        mCurrentTime = 0f;
        mMoveEnd = true;
    }

    public void Update(float deltaTime)
    {
        if (!mMoveEnd)
        {
            mSpeed = mInitSpeed + mCurrentTime * mAcceleration;

            Vector3 pos = Vector3.MoveTowards(mCasterTrans.position, mTargetPosition, mSpeed * deltaTime);
            mCasterTrans.position = pos;
            mCurrentTime += deltaTime;
            if (mCurrentTime >= mTime || (mCasterTrans.position.FEqual(mTargetPosition)))
            {
                Stop();
                return;
            }
        }
    }
}