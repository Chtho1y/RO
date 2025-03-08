using UnityEngine;
using System.Collections;

public class BulletMoveProcessor
{
	float bullet_move_speed_perFrame = 10f;
	const float bullet_throw_speed = 10f;
	const float bullet_throw_gravity = 13f;

	Bullet mBullet;

	bool mEnabled = false;
	Vector3 mVelocity = Vector3.zero;
	Vector3 mAcceleration = Vector3.zero;
	bool mToward = false;
	bool mTraceTarget = false;

    //float mLeftAccelerationTime = 0;
    int mLeftAccelerationFrame = 0;

	public BulletMoveProcessor(Bullet bullet,float moveSpeed)
	{
		mBullet = bullet;
        bullet_move_speed_perFrame = moveSpeed;
		InitMoveData ();
	}

    private void InitMoveData()
    {
        BulletMoveType moveType = mBullet.BulletData.moveType;
        mVelocity = mBullet.BulletData.initSpeedVec / Constants.frame_to_time;
        mAcceleration = mBullet.BulletData.accelationSpeedVec / Constants.frame_to_time;
        mLeftAccelerationFrame = (int)(mBullet.BulletData.accelationDuration * Constants.frame_to_time);
        mBullet.LookAt(mBullet.TargetPosition);
        if(mLeftAccelerationFrame <= 0)
        {
            mTraceTarget = true;
        }
        mEnabled = true;
    }

    public void Update(float deltaTime)
	{
		if (!mEnabled)
			return;


        //mBullet.SetPosition (mBullet.Position + mVelocity * deltaTime);
        mBullet.SetPosition(mBullet.Position + mVelocity);
        if (mBullet.Ctrl!=null)
        {
            mBullet.ForceSync(mBullet.Ctrl.transform);
        }
        
        if (mLeftAccelerationFrame > 0)
        {
            mVelocity += mAcceleration;
            mLeftAccelerationFrame--;
            if(mLeftAccelerationFrame <= 0)
            {
                mBullet.LookAt(mBullet.TargetPosition);

                float leftTime = (mBullet.TargetPosition.z - mBullet.Position.z) / mVelocity.z;
                mVelocity.x = (mBullet.TargetPosition.x - mBullet.Position.x) / leftTime;
                mVelocity.y = (mBullet.TargetPosition.y - mBullet.Position.y) / leftTime;
                //mToward = true;
                mTraceTarget = true;
                //DebugHelper.LogError("deltaZ:" + (mBullet.TargetPosition.z - mBullet.Position.z) + " mVelocity.z"+ mVelocity.z + "leftTime:" + leftTime+" mVelocity:" + mVelocity);
            }
        }

        if (mToward)
            mBullet.LookAt(mBullet.TargetPosition);
        if (mTraceTarget && !mBullet.TargetPosition.FEqual(mBullet.Position, 1e-2f))
            mVelocity = (mBullet.TargetPosition - mBullet.Position).normalized * mVelocity.magnitude;
    }

	
	Vector3 GetThrowVelocity(Vector3 startPostion, Vector3 targetPosition)
	{
		Vector3 offset = targetPosition - startPostion;
		Vector3 dirX = offset.SetY (0).normalized;
		float distanceX = offset.SetY (0).magnitude;
		float distanceY = offset.y;
		float flyTime = Mathf.Max(Mathf.Max(distanceX / bullet_throw_speed, Mathf.Sqrt (Mathf.Abs (2 * distanceY) / bullet_throw_gravity)), 1e-2f);
		return Vector3.up * (distanceY / flyTime + 0.5f * bullet_throw_gravity * flyTime) + dirX * bullet_throw_speed;
	}
}

