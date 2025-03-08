using UnityEngine;
using System.Collections;
using System.Collections.Generic;

[ExecuteInEditMode]
public class MovePath : MonoBehaviour
{
	public int id;
	public int slices = 10;
	public LinePointInfo[] points = new LinePointInfo[0];
	public float[] approximateLengths;

	Dictionary<LogicTransform, Coroutine> moveCoroutines = new Dictionary<LogicTransform, Coroutine> ();

	public void StartMoveTarget (LogicTransform target, float speed, bool hasStartMove, bool lookAtForward, Vector3 offset)
	{
		if (moveCoroutines.ContainsKey (target)) {
			StopCoroutine (moveCoroutines [target]);
			moveCoroutines.Remove (target);
		}
		moveCoroutines.Add (target, StartCoroutine (DoMoveTarget (target, speed, hasStartMove, lookAtForward, offset)));
	}

	IEnumerator DoMoveTarget (LogicTransform target, float speed, bool hasStartMove, bool lookAtForward, Vector3 offset)
	{
		LinePointInfo[] offsetPoints = GetOffsetPoints (offset.x);
		if (offsetPoints == null)
			yield break;

		int currentSegmentIdx = 0;
		float distanceInCurrentSegment = 0;
		bool moveEnd = false;

		Vector3 startPosition = offsetPoints[0].point;
		if (hasStartMove) {
			if (!target.Position.FEqual (startPosition, 1e-2f)) {
				target.LookAt (startPosition);
				while (!target.Position.FEqual (startPosition, 1e-2f)) {
					yield return 1;
					target.SetPosition (Vector3.MoveTowards (target.Position, startPosition, speed * Time.deltaTime));
				}
			} 
		}
		target.SetPosition (startPosition);

		while (!moveEnd) {
			yield return 1;
			distanceInCurrentSegment += Time.deltaTime * speed;

			while (distanceInCurrentSegment > approximateLengths [currentSegmentIdx]) {
				if (currentSegmentIdx >= approximateLengths.Length - 1) {
					distanceInCurrentSegment = approximateLengths [currentSegmentIdx];
					moveEnd = true;
					break;
				} else {
					distanceInCurrentSegment -= approximateLengths [currentSegmentIdx];
					currentSegmentIdx++;
				}
			}

			int last = approximateLengths.Length;
			int start = currentSegmentIdx;
			int end = currentSegmentIdx + 1;
			int prev = start == 0 ? start : (points [start].smoothOut ? start - 1 : start);
			int next = end == last ? end : (points [end].smoothIn ? end + 1 : end);
			Vector3 targetposition = Interpolate.CatmullRom (offsetPoints [prev].point, offsetPoints [start].point, offsetPoints [end].point,
				offsetPoints [next].point, distanceInCurrentSegment, approximateLengths [currentSegmentIdx]);
			target.SetPosition (targetposition);
			if (lookAtForward) {
				Vector3 dir =  Interpolate.GetDir (offsetPoints [prev].point, offsetPoints [start].point, offsetPoints [end].point,
					offsetPoints [next].point, distanceInCurrentSegment, approximateLengths [currentSegmentIdx]);
				Vector3 right = Vector3.Cross (dir, Vector3.up);
				Vector3 up = Vector3.Cross (right, dir);
				target.LookForward (dir, up);
			}
		}

		moveCoroutines.Remove (target);
	}

	public void StopMoveTarget (LogicTransform target)
	{
		if (moveCoroutines.ContainsKey (target)) {
			StopCoroutine (moveCoroutines [target]);
			moveCoroutines.Remove (target);
		}
	}

	public bool IsTargetMove (LogicTransform target)
	{
		return moveCoroutines.ContainsKey (target);
	}

	public bool HasTargetMove {
		get {
			return moveCoroutines.Count > 0;
		}
	}

//	public Vector3 GetStartPositionWithOffset (Vector3 offset)
//	{
//		if (points.Length > 1) {
//			Vector3 forward = (points [1].point - points [0].point).normalized;
//			Vector3 right = Vector3.Cross (forward, Vector3.up);
//			return points [0].point + right * offset.x;
//		} else
//			return points [0].point;
//	}

	public Vector3 GetEndPositionWithOffset (Vector3 offset)
	{
		if (points == null || points.Length == 0)
			return Vector3.zero;
		if (points.Length == 1)
			return points [0].point;
		else
			return points [points.Length - 1].point + 
				Vector3.Cross ((points [points.Length - 1].point - points [points.Length - 2].point), Vector3.up).SetY (0).normalized * offset.x;
	}

	LinePointInfo[] GetOffsetPoints(float offsetValue)
	{
		if (points == null || points.Length == 0)
			return null;
		
		if (points.Length == 1) {
			LinePointInfo[] result = new LinePointInfo[1];
			result [0] = points [0];
			return result;
		} else {
			LinePointInfo[] result = new LinePointInfo[points.Length];
			points.CopyTo (result, 0);
			for (int i = 0; i < result.Length - 1; i++) {
				int start = i;
				int end = start + 1;
				int prev = start == 0 ? start : start - 1;
				Vector3 forward = (points [end].point - points [prev].point);
				Vector3 right = Vector3.Cross (forward, Vector3.up).SetY (0).normalized;
				result [start].point = points [start].point + right * offsetValue;
			}

			//last point
			result [result.Length - 1].point = points [result.Length - 1].point + Vector3.Cross ((points [result.Length - 1].point - points [result.Length - 2].point), Vector3.up).SetY (0).normalized * offsetValue;
			return result;
		}
	}

	void UpdateApproximateLengths ()
	{
		if (points.Length < 2)
			return;
		
		if (approximateLengths == null || approximateLengths.Length != points.Length - 1)
			approximateLengths = new float[points.Length - 1];

		for (int i = 0; i < approximateLengths.Length; i++)
			approximateLengths [i] = 0;

		IEnumerable<Vector3> sequence = Interpolate.NewCatmullRomByPointInfo (points, slices, false);
		IEnumerator<Vector3> iter = sequence.GetEnumerator ();
		Vector3 prev = Vector3.zero;
		bool hasPrev = false;
		int idx = 0;
		while (iter.MoveNext ()) {
			if (hasPrev) {
				float distance = Vector3.Distance (prev, iter.Current);
				approximateLengths [(idx - 1) / (slices + 1)] += distance;
			}

			prev = iter.Current;
			hasPrev = true;
			idx++;
		}
	}

//	public Vector3 GetEndPositionWithOffset (Vector3 offset)
//	{
//		return points [points.Length - 1].point + offset;
//	}
//
//	bool IsPositionCloseTo (Vector3 v1, Vector3 v2)
//	{
//		return (v1 - v2).sqrMagnitude < 0.001f;
//	}

	#if UNITY_EDITOR
	public Vector3[] mDrawOffsets;

	void OnDrawGizmos ()
	{
		Gizmos.color = Color.red;
		DrawPath (points);
		if (mDrawOffsets != null) {
			Gizmos.color = Color.green;
			for (int i = 0; i < mDrawOffsets.Length; i++)
				DrawPath (GetOffsetPoints(mDrawOffsets [i].x));
		}

		if (points != null)
			for (int i = 0; i < points.Length; i++)
				DrawPoint (points [i].point);
	}

	void DrawPoint (Vector3 pos)
	{
		Gizmos.color = Color.blue;
		Gizmos.DrawLine (pos + Vector3.forward * 0.1f, pos + Vector3.back * 0.1f);
		Gizmos.DrawLine (pos + Vector3.right * 0.1f, pos + Vector3.left * 0.1f);
	}

	void DrawPath (LinePointInfo[] pointInfos)
	{
		if (pointInfos.Length < 2 || approximateLengths == null)
			return;
		
		int currentSegmentIdx = 0;
		float distanceInCurrentSegment = 0;
		int last = approximateLengths.Length;
		int start = currentSegmentIdx;
		int end = currentSegmentIdx + 1;
		int prev = start == 0 ? start : (pointInfos [start].smoothOut ? start - 1 : start);
		int next = end == last ? end : (pointInfos [end].smoothIn ? end + 1 : end);

		Vector3 lastPos = Interpolate.CatmullRom (pointInfos [prev].point, pointInfos [start].point, pointInfos [end].point,
			pointInfos [next].point, distanceInCurrentSegment, approximateLengths [currentSegmentIdx]);
		
//		up = Vector3.Cross (right, forward);
//		lastPos += (right * offset.x + up * offset.y + forward * offset.z);

		bool isEnd = false;
		while (!isEnd) {
			distanceInCurrentSegment += 0.1f;
			while (distanceInCurrentSegment > approximateLengths [currentSegmentIdx]) {
				if (currentSegmentIdx >= approximateLengths.Length - 1) {
					distanceInCurrentSegment = approximateLengths [currentSegmentIdx];
					isEnd = true;
					break;
				} else {
					distanceInCurrentSegment -= approximateLengths [currentSegmentIdx];
					currentSegmentIdx++;
				}
			}
			start = currentSegmentIdx;
			end = currentSegmentIdx + 1;
			prev = start == 0 ? start : (pointInfos [start].smoothOut ? start - 1 : start);
			next = end == last ? end : (pointInfos [end].smoothIn ? end + 1 : end);
			Vector3 nextPos = Interpolate.CatmullRom (pointInfos [prev].point, pointInfos [start].point, pointInfos [end].point,
				pointInfos [next].point, distanceInCurrentSegment, approximateLengths [currentSegmentIdx]);

			Gizmos.DrawLine (lastPos, nextPos);
			lastPos = nextPos;
		}
	}

	void Update ()
	{
		if (points == null)
			points = new LinePointInfo[transform.childCount];
		
		if (points != null) {
			for (int i = 0; i < points.Length; i++) {
				if (points [i].bindTrasform == null)
					points [i].bindTrasform = transform.Find ("point" + i);
				if (points [i].bindTrasform == null) {
					GameObject go = new GameObject ("point" + i);
					go.transform.SetParent (transform);
					go.transform.position = points [i].point;
					points [i].bindTrasform = go.transform;	
				} else {
					points [i].point = points [i].bindTrasform.position;
					if (points [i].bindTrasform.name.CompareTo ("point" + i) != 0)
						points [i].bindTrasform.name = "point" + i;
				}
			}
		}

		UpdateApproximateLengths ();
	}

	#endif

	//#if UNITY_EDITOR
	//
	//    public bool testMove = false;
	//    public Transform testMoveTarget;
	//    public Vector3 testMoveOffset = Vector3.zero;
	//    public float testMoveSpeed = 10f;
	//
	//    int lastPointLength = 0;
	//    int lastChildCount = 0;
	//
	//    void OnDrawGizmos()
	//    {
	//        if (lastChildCount != transform.childCount)
	//            SyncPointsWithChild();
	//        else if (lastPointLength != points.Length)
	//            SyncChildWithPoints();
	//
	//        lastChildCount = transform.childCount;
	//        lastPointLength = points.Length;
	//
	//        if (points.Length < 2)
	//            return;
	//
	//        SyncPointPosition();
	//
	//        approximateLengths = new float[points.Length - 1];
	//
	//        IEnumerable<Vector3> sequence = Interpolate.NewCatmullRomByPointInfo(points, slices, false);
	//        IEnumerator<Vector3> iter = sequence.GetEnumerator();
	//        Vector3 prev = Vector3.zero;
	//        bool hasPrev = false;
	//        int idx = 0;
	//        while (iter.MoveNext())
	//        {
	//            if (idx % (slices + 1) == 0)
	//            {
	//                Gizmos.color = Color.green;
	//                Gizmos.DrawSphere(iter.Current, 0.1f);
	//            }
	//
	//            if (hasPrev)
	//            {
	//                Gizmos.color = Color.red;
	//                Gizmos.DrawLine(prev, iter.Current);
	//                float distance = Vector3.Distance(prev, iter.Current);
	//                //Log.E("idx : {0}", idx);
	//                approximateLengths[(idx - 1) / (slices + 1)] += distance;
	//            }
	//
	//            prev = iter.Current;
	//            hasPrev = true;
	//            idx++;
	//        }
	//
	//        if (testMove)
	//        {
	//            StartMoveTarget(new LogicTransform(testMoveTarget), testMoveSpeed, true, true, testMoveOffset);
	//            testMove = false;
	//        }
	//
	//        if (testMoveTarget != null)
	//        {
	//            Gizmos.color = Color.cyan;
	//            Gizmos.DrawSphere(testMoveTarget.position, 0.2f);
	//            //Gizmos.DrawLine(testMoveTarget.position, testMoveTarget.position + testMoveTarget.forward);
	//        }
	//    }
	//
	//    void SyncChildWithPoints()
	//    {
	//        List<Transform> bindChilds = new List<Transform>();
	//        List<Transform> unbindChilds = new List<Transform>();
	//        for (int i = 0; i < points.Length; i++)
	//        {
	//            if (bindChilds.Contains(points[i].bindTrasform))
	//                points[i].bindTrasform = null;
	//
	//            if (points[i].bindTrasform == null)
	//            {
	//                points[i].bindTrasform = new GameObject().transform;
	//                points[i].bindTrasform.SetParent(transform);
	//                points[i].bindTrasform.localPosition = Vector3.zero;
	//                points[i].bindTrasform.localEulerAngles = Vector3.zero;
	//            }
	//
	//            points[i].bindTrasform.name = "point" + i;
	//            bindChilds.Add(points[i].bindTrasform);
	//        }
	//
	//        for (int i = 0; i < transform.childCount; i++)
	//        {
	//            if (!bindChilds.Contains(transform.GetChild(i)))
	//                unbindChilds.Add(transform.GetChild(i));
	//        }
	//
	//        for (int i = 0; i < unbindChilds.Count; i++)
	//        {
	//            unbindChilds[i].gameObject.DestroyImmediate();
	//        }
	//    }
	//
	//    void SyncPointsWithChild()
	//    {
	//        LinePointInfo[] newpoints = new LinePointInfo[transform.childCount];
	//        for (int i = 0; i < newpoints.Length; i++)
	//        {
	//            if (i < points.Length)
	//                newpoints[i] = points[i];
	//            else
	//                newpoints[i] = new LinePointInfo();
	//            newpoints[i].bindTrasform = transform.GetChild(i);
	//            newpoints[i].bindTrasform.name = "point" + i;
	//        }
	//        points = newpoints;
	//    }
	//
	//    void SyncPointPosition()
	//    {
	//        for (int i = 0; i < points.Length; i++)
	//        {
	//            if (points[i].bindTrasform != null)
	//                points[i].point = points[i].bindTrasform.position;
	//            //points[i].smoothIn = true;
	//            //points[i].smoothOut = true;
	//        }
	//    }
	//
	//#endif
}
