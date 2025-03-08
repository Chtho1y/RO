using UnityEngine;

public enum LogicTransformHitType
{
	Cylinder = 0,
	Box = 1,
	Sphere = 2,
}

public struct InterpolateRecord
{
	public float time;
	public Vector3 pos;
}

public struct InterpolateCache
{
	const int cache_size = 5;
	InterpolateRecord[] records;
	int last;

	public void Init (Vector3 pos)
	{
		records = new InterpolateRecord[cache_size];
		for (int i = 0; i < cache_size; i++) {
			records [i].pos = pos;
			records [i].time = 0;
		}
		last = 0;
	}

	public void Reset (Vector3 pos)
	{
		for (int i = 0; i < cache_size; i++) {
			records [i].pos = pos;
			records [i].time = 0;
		}
		last = 0;
	}

	public void Add (Vector3 pos)
	{
		last = (last + 1) % cache_size;
		records [last].time = Time.time;
		records [last].pos = pos;
	}

	public bool Interpolate (float time, out Vector3 pos)
	{
		if (records [last].time <= time + 1e-3f) {			
			pos = records [last].pos;
			return true;
		}
		int idx = (last + cache_size - 1) % cache_size;
		while (idx != last) {
			if (records [idx].time <= time) {				
				pos = Vector3.Lerp (records [idx].pos, records [last].pos, (time - records [idx].time) / (records [last].time - records [idx].time));
				return false;
			}
			idx = (idx + cache_size - 1) % cache_size;
		}
		pos = records [(last + 1) % cache_size].pos;
		return false;
	}
}

public class LogicTransform
{
	const float interpolate_position_delay = 0.066f;

	bool mGoDirty;
	bool mMatrixDirty;
	bool mPositionDirty;
	Matrix4x4 mLocalToWorld;
	Matrix4x4 mWorldToLocal;
	InterpolateCache mPositionCache;

	LogicTransform mParent;
	Vector3 mLocalPosition;
	Vector3 mLocalForward;
	bool mIsSettingFromParent;

	public Vector3 Position { get; protected set; }

	public Vector3 Forward { get; private set; }

	public Vector3 Up { get; private set; }

	public Vector3 Right { get { return Vector3.Cross (Up, Forward); } }

    public Vector3 Back { get { return Quaternion.AngleAxis(180, Vector3.up) * Forward; } }

	public float Scale { get; private set; }

	public int Layer { get; set; }

	public string LayerName { get { return LayerMask.LayerToName (Layer); } set { Layer = LayerMask.NameToLayer (value); } }

	public Vector3 HitSize { get; set; }

	public LogicTransformHitType HitType { get; set; }

	public float HitHeight { get { return HitSize.y; } }

	public float HitRadius { get { return HitSize.x; } }

	public bool KeepHorizontalLook { get; set; }

	public LogicTransform Parent { get { return mParent; } }

	public Vector3 LocalPosition {
		get { return mParent == null ? Position : mLocalPosition; }
		set {
			if (mParent != null) {
				mLocalPosition = value;
				UpdateFromParent ();
			} else
				SetPosition (value);
		}
	}

	public Vector3 LocalForward {
		get { return mParent == null ? Forward : mLocalForward; }
		set {
			if (mParent != null) {
				mLocalForward = value;
				UpdateFromParent ();
			} else
				LookForward (value);
		}
	}

	public LogicTransform ()
	{
		Position = Vector3.zero;
		Forward = Vector3.forward;
		Up = Vector3.up;
		KeepHorizontalLook = true;
		Scale = 1;
		HitSize = new Vector3 (0.5f, 1.8f, 0f);
		HitType = LogicTransformHitType.Cylinder;
		mPositionCache.Init (Position);
		mGoDirty = true;
		mPositionDirty = true;
		UpdateMatrix ();
	}

	public LogicTransform (Vector3 position, Vector3 forward, LogicTransformHitType hitType = LogicTransformHitType.Box, Vector3 hitSize = default(Vector3))
	{
		Position = position;
		Forward = forward;
		Up = Vector3.up;
		KeepHorizontalLook = true;
		Scale = 1;
		HitSize = hitSize;
		HitType = hitType;
		mPositionCache.Init (Position);
		mGoDirty = true;
		mPositionDirty = true;
		UpdateMatrix ();
	}

	public virtual void UpdateTransform (Transform transform)
	{
		if (mPositionDirty) {
			Vector3 pos;
            mPositionDirty = !mPositionCache.Interpolate(Time.time - interpolate_position_delay, out pos);
			transform.position = pos;
		}

		if (mGoDirty) {
			transform.LookAt (transform.position + Forward, Up);
			transform.localScale = Vector3.one * Scale;
			mGoDirty = false;
		}
	}

	public void ForceSync (Transform transform)
	{
		transform.position = Position;
		transform.LookAt (transform.position + Forward, Up);
		transform.localScale = Vector3.one * Scale;
		mPositionCache.Reset (Position);
		mGoDirty = false;
		mPositionDirty = false;
	}

	public virtual void SetPosition (Vector3 position)
	{
		mPositionCache.Add (position);
		mPositionDirty = true;
		mMatrixDirty = true;
		if (mParent != null && !mIsSettingFromParent)
			UpdateLocal ();
	}

    public virtual void SetRotation(Quaternion rot)
    {
        mMatrixDirty = true;
        if (mParent != null && !mIsSettingFromParent)
            UpdateLocal();
    }

	public virtual void LookForward (Vector3 forward, Vector3 up = default(Vector3))
	{
		if (KeepHorizontalLook) {
			forward = forward.SetY (0).normalized;
			if (forward.FEqual (Forward, 1e-3f))
				return;
			Forward = forward.normalized;
			Up = Vector3.up;
		} else {
			if (forward.FEqual (Forward, 1e-3f))
				return;
			Forward = forward.normalized;
			if (up != default(Vector3))
				Up = up.normalized;
			FixUpDir ();
		}
		mGoDirty = true;
		mMatrixDirty = true;
		if (mParent != null && !mIsSettingFromParent)
			UpdateLocal ();
	}

	public virtual void SetScale (float s)
	{
		Scale = s;
		mGoDirty = true;
		mMatrixDirty = true;
	}

	public void LookAt (Vector3 lookAt, Vector3 up = default(Vector3))
	{
		if (lookAt.FEqual (Position, 1e-2f))
			return;
		LookForward ((lookAt - Position).normalized, up);
	}

	public Vector3 TransformPoint (Vector3 v)
	{
		if (mMatrixDirty)
			UpdateMatrix ();
		return mLocalToWorld.MultiplyPoint (v);
	}

	public Vector3 InverseTransformPoint (Vector3 v)
	{
		if (mMatrixDirty)
			UpdateMatrix ();
		return mWorldToLocal.MultiplyPoint (v);
	}

	public Vector3 TransformDirection (Vector3 d)
	{
		if (mMatrixDirty)
			UpdateMatrix ();
		return mLocalToWorld.MultiplyVector (d);
	}

	public Vector3 InverseTransformDirection (Vector3 d)
	{
		if (mMatrixDirty)
			UpdateMatrix ();
		return mWorldToLocal.MultiplyVector (d);
	}

	public bool CheckHitBox (Vector3 pos, Vector3 dir, Vector3 size)
	{
		Vector3 offset = Position - pos;
		if (Mathf.Abs (Vector3.Dot (offset, Up) + 0.5f * HitHeight) > 0.5f * (size.y + HitHeight))
			return false;
		if (Mathf.Abs (Vector3.Dot (offset, dir)) > (0.5f * size.z + HitRadius))
			return false;
		return Mathf.Abs (Vector3.Dot (offset, Vector3.Cross (Up, dir))) <= (0.5f * size.x + HitRadius);
	}

    public bool CheckHitBoxUnscrict(Vector3 linkPos, Vector3 pos, Vector3 dir, Vector3 size)
    {
        Vector3 offset = linkPos - pos;
        if (Mathf.RoundToInt(Mathf.Abs(Vector3.Dot(offset, Up) + 0.5f * HitHeight) * 1e5f) > Mathf.RoundToInt(0.5f * (size.y + HitHeight)) * 1e5f)
            return false;
        if (Mathf.RoundToInt(Mathf.Abs(Vector3.Dot(offset, dir)) * 1e5f) > Mathf.RoundToInt((0.5f * size.z + HitRadius) * 1e5f))
            return false;
        return Mathf.RoundToInt(Mathf.Abs(Vector3.Dot(offset, Vector3.Cross(Up, dir))) * 1e5f) <= Mathf.RoundToInt((0.5f * size.x + HitRadius) * 1e5f);
    }


    public bool CheckHitBoxUnscrict	(Vector3 pos, Vector3 dir, Vector3 size)
	{
		Vector3 offset = Position - pos;
		if (Mathf.RoundToInt (Mathf.Abs (Vector3.Dot (offset, Up) + 0.5f * HitHeight) * 1e5f) > Mathf.RoundToInt (0.5f * (size.y + HitHeight)) * 1e5f)
			return false;
		if (Mathf.RoundToInt (Mathf.Abs (Vector3.Dot (offset, dir)) * 1e5f) > Mathf.RoundToInt((0.5f * size.z + HitRadius) * 1e5f))
			return false;
		return Mathf.RoundToInt (Mathf.Abs (Vector3.Dot (offset, Vector3.Cross (Up, dir))) * 1e5f) <= Mathf.RoundToInt((0.5f * size.x + HitRadius) * 1e5f);
	}

	public bool CheckHitCylinder (Vector3 pos, float radius, float height)
	{
		Vector3 offset = Position - pos;
		if (offset.SetY (0).sqrMagnitude > (radius + HitRadius) * (radius + HitRadius))
			return false;
		return Mathf.Abs (offset.y + 0.5f * HitHeight) <= 0.5f * (height + HitHeight);
	}

	public void SetParent (LogicTransform parent, bool keepWorldTransform = false)
	{
		mParent = parent;
		if (mParent != null) {
			if (keepWorldTransform) {
				UpdateLocal ();
			} else {
				LocalPosition = Vector3.zero;
				LocalForward = Vector3.forward;
			}
		}
	}

	void UpdateLocal ()
	{
		mLocalPosition = mParent.InverseTransformPoint (Position);
		mLocalForward = mParent.InverseTransformDirection (Forward);
	}

	public void UpdateFromParent ()
	{
		mIsSettingFromParent = true;
		SetPosition (mParent.TransformPoint (mLocalPosition));
		LookForward (mParent.TransformDirection (Forward));
		mIsSettingFromParent = false;
	}

	void UpdateMatrix ()
	{
		mLocalToWorld.SetColumn (0, Right * Scale);
		mLocalToWorld.SetColumn (1, Up * Scale);
		mLocalToWorld.SetColumn (2, Forward * Scale);
		mLocalToWorld.SetColumn (3, new Vector4(Position.x, Position.y, Position.z, 1));
		mWorldToLocal = mLocalToWorld.inverse;
		mMatrixDirty = false;
	}

	void FixUpDir ()
	{
		float dot = Mathf.Abs (Vector3.Dot (Forward, Up));
		if (dot > 1 - 1e-4f) {
			if (Forward.FEqual (Vector3.up))
				Up = Vector3.Cross (Forward, Vector3.right);
			else
				Up = Vector3.Cross (Forward, Vector3.Cross (Vector3.up, Forward));
		} else if (dot > Mathf.Epsilon)
			Up = Vector3.Cross (Forward, Vector3.Cross (Up, Forward));
	}
}
