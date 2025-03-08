using UnityEngine;
using System.Collections;

public class BulletEventMoveProcessor
{
    private Transform mBullet;

    private Vector3 mVelocity = Vector3.zero;
    private Vector3 mAcceleration = Vector3.zero;
    private Vector3 mDestPos = Vector3.zero;
   
    private float bullet_move_speed = 10f;
    private float mLeftAccelerationTime = 0;

    private bool mTraceTarget = false;
    private bool mEnabled = false;

    public BulletEventMoveProcessor(Transform bullet, BulletMoveType moveType, float moveSpeed,Vector3 initVelocity,Vector3 acceleration,Vector3 destPos,float accelerationTime)
    {
        mBullet = bullet;
        bullet_move_speed = moveSpeed;
        mVelocity = initVelocity;
        mAcceleration = acceleration;
        mLeftAccelerationTime = accelerationTime;
        mDestPos = destPos;

        mBullet.LookAt(mDestPos);
        if (mLeftAccelerationTime <= 0)
        {
            mTraceTarget = true;
        }
        mEnabled = false;
    }

    public void Start()
    {
        mEnabled = true;
    }

    public void Stop()
    {
        mBullet = null;
        mEnabled = false;
    }

    public void Update(float deltaTime)
    {
        if (!mEnabled)
            return;

        Vector3 curPos = mBullet.position + mVelocity * deltaTime;
        mBullet.position = curPos;

        if (mLeftAccelerationTime > 0)
        {
            mVelocity += mAcceleration * deltaTime;
            mLeftAccelerationTime -= deltaTime;
            if (mLeftAccelerationTime <= 0)
            {
                mBullet.LookAt(mDestPos);

                float leftTime = (mDestPos.z - curPos.z) / mVelocity.z;
                mVelocity.x = (mDestPos.x - curPos.x) / leftTime;
                mVelocity.y = (mDestPos.y - curPos.y) / leftTime;
                mTraceTarget = true;
            }
        }

        if (mTraceTarget && !mDestPos.FEqual(mBullet.position, 1e-2f))
            mVelocity = (mDestPos - mBullet.position).normalized * mVelocity.magnitude;
    }
}
