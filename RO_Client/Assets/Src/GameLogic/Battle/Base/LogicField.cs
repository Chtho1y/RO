using UnityEngine;

public class LogicField
{
	public Vector3 Position { get; private set;}
	public Vector3 Forward { get; private set;}
	public Vector3 Up { get; private set;}
	public Vector3 Right { get; private set;}
	public Vector3 Size {get; private set;}

    Vector3 mLocalMin;
    Vector3 mLocalMax;
	Matrix4x4 mLocalToWorld;
	Matrix4x4 mWorldToLocal;

    public LogicField(Vector3 pos, Vector3 size, Vector3 forward)
	{
		Position = pos;
		Size = size;
		Forward = forward.SetY (0).normalized;
		Up = Vector3.up;
		Right = Vector3.Cross (Up, Forward);

		mLocalMin = -0.5f * Size;
		mLocalMax = 0.5f * Size;
		mLocalToWorld.SetColumn (0, Right);
		mLocalToWorld.SetColumn (1, Up);
		mLocalToWorld.SetColumn (2, Forward);
		mLocalToWorld.SetColumn (3, new Vector4(Position.x, Position.y, Position.z, 1));	
		mWorldToLocal = mLocalToWorld.inverse;
	}
    
    public bool IsInField(Vector3 pos)
    {
		Vector3 v = InverseTransformPoint(pos);
		return v.IsInRange (mLocalMin, mLocalMax);
    }

    public Vector3 FixMove(Vector3 from, Vector3 to)
    {
		Vector3 vfrom = InverseTransformPoint (from);
		if (!vfrom.IsInRange (mLocalMin, mLocalMax))
			return to;
		
        Vector3 vto = InverseTransformPoint(to);
		if (vto.IsInRange(mLocalMin, mLocalMax))
			return to;
        
		return TransformPoint(LocalCrossPosition(vfrom, vto));
    }

	public Vector3 ProjectGround(Vector3 pos)
	{
		return TransformPoint (InverseTransformPoint (pos).SetY (mLocalMin.y));
	}
		    
    public Vector3 Closest(Vector3 pos)
    {
        Vector3 v = InverseTransformPoint(pos);
		v = Vector3.Min(v, mLocalMax);
		v = Vector3.Max(v, mLocalMin);
        return TransformPoint(v);
    }

    public float PositionHeight(Vector3 pos)
    {
		return InverseTransformPoint(pos).y - mLocalMin.y;
    }

	public Vector3 TransformPoint(Vector3 v)
	{
		return mLocalToWorld.MultiplyPoint(v);
	}

	public Vector3 InverseTransformPoint(Vector3 v)
	{
		return mWorldToLocal.MultiplyPoint(v);
	}

	public Vector3 TransformDirection(Vector3 d)
	{
		return mLocalToWorld.MultiplyVector(d);
	}

	public Vector3 InverseTransformDirection(Vector3 d)
	{
		return mWorldToLocal.MultiplyVector(d);
	}

	Vector3 LocalCrossPosition(Vector3 localInside, Vector3 localOutside)
	{
		float tx = 1f, ty = 1f, tz = 1f;
		const float diff = 1e-3f;
		if (localOutside.x < mLocalMin.x - diff)
			tx = (mLocalMin.x - localInside.x) / (localOutside.x - localInside.x);
		else if (localOutside.x > mLocalMax.x + diff)
			tx = (mLocalMax.x - localInside.x) / (localOutside.x - localInside.x);

		if (localOutside.y < mLocalMin.y - diff)
			ty = (mLocalMin.y - localInside.y) / (localOutside.y - localInside.y);
		else if (localOutside.y > mLocalMax.y + diff)
			ty = (mLocalMax.y - localInside.y) / (localOutside.y - localInside.y);

		if (localOutside.z < mLocalMin.z - diff)
			tz = (mLocalMin.z - localInside.z) / (localOutside.z - localInside.z);
		else if (localOutside.z > mLocalMax.z + diff)
			tz = (mLocalMax.z - localInside.z) / (localOutside.z - localInside.z);

		float t = Mathf.Min(tx, ty, tz);
		if (t >= 1 - 1e-3f)
			return localOutside.ClampPosition(mLocalMin, mLocalMax);
		else
			return Vector3.Lerp(localInside, localOutside, t);
	}
}
