using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public static class PocHelper
{

    public static void SetLayer(Transform t, int layer)
    {
        t.gameObject.layer = layer;
        for (int i = 0; i < t.childCount; i++)
        {
            SetLayer(t.GetChild(i), layer);
        }
    }

    public static void SetObjectCameraMirror(Transform t, bool mirror, int resolutionWidth = 0)
    {
        Camera[] cameras = t.GetComponentsInChildren<Camera>(true);
        for (int i = 0; i < cameras.Length; i++)
        {
            CameraImageMirror cim = cameras[i].gameObject.GetComponent<CameraImageMirror>();
            if (cim == null)
                cim = cameras[i].gameObject.AddComponent<CameraImageMirror>();
            cim.enabled = mirror;
            if (mirror)
                PostEffectHelper.renderTextureWidth = resolutionWidth;
        }
    }

    public static void PlaySound(AudioClip clip, bool repeat = false)
    {

    }

    public static void StopSound(AudioClip clip)
    {

    }

    public static void PlayGoAnim(GameObject go, string animOrStateName)
    {
        go.SetActive(true);

        Animation anim = go.GetComponent<Animation>();
        if (anim != null)
        {
            anim.enabled = true;
            if (string.IsNullOrEmpty(animOrStateName))
            {
                if (anim.playAutomatically)
                {
                    go.SetActive(false);
                    go.SetActive(true);
                }
                else
                    anim.Play();
            }
            else
                anim.Play(animOrStateName);
        }
        else
        {
            Animator animator = go.GetComponent<Animator>();
            if (animator != null)
            {
                animator.enabled = true;
                if (!string.IsNullOrEmpty(animOrStateName))
                    animator.Play(animOrStateName);
            }
        }
    }

    public static void StopGoAnim(GameObject go)
    {
        go.SetActive(true);

        Animation anim = go.GetComponent<Animation>();
        if (anim != null && anim.isPlaying)
            anim.Stop();
        else
        {
            Animator animator = go.GetComponent<Animator>();
            if (animator != null && animator.enabled)
                animator.StopPlayback();
        }
    }

    public static GameObject CreateTransformHolder(GameObject go)
    {
        if (go == null)
            return null;
        GameObject holder = new GameObject("Holder_" + go.name);
        holder.transform.SetParent(go.transform.parent);
        holder.transform.localPosition = Vector3.zero;
        holder.transform.localEulerAngles = Vector3.zero;
        holder.transform.localScale = Vector3.one;
        holder.SetActive(go.activeInHierarchy);
        go.transform.SetParent(holder.transform);
        go.SetActive(true);
        return holder;
    }

    public static Transform CreateTransformHolder(Transform t)
    {
        if (t == null)
            return null;
        return CreateTransformHolder(t.gameObject).transform;
    }

    public static bool IsPlayingAnim(Animator[] animators, bool ignoreRepeatMotion = true)
    {
        if (animators == null || animators.Length == 0)
            return false;

        for(int idx =0; idx < animators.Length;idx++)
        {
            Animator anim = animators[idx];
            if (anim.enabled)
            {
                if (anim.IsInTransition(0))
                    return true;

                AnimatorStateInfo stateInfo = anim.GetCurrentAnimatorStateInfo(0);
                if (ignoreRepeatMotion)
                {
                    if (stateInfo.length > 0 && stateInfo.normalizedTime < 1)
                        return true;
                }
                else
                {
                    if (stateInfo.length > 0 && (stateInfo.normalizedTime < 1 || stateInfo.loop))
                        return true;
                }
            }
        }
        return false;
    }

    public static bool IsPlayingAnim(GameObject go, bool ignoreRepeatMotion = true)
    {
        Animator[] animators = go.GetComponentsInChildren<Animator>();
        for (int i = 0; i < animators.Length; i++)
        {
            if (animators[i].enabled)
            {
                if (animators[i].IsInTransition(0))
                    return true;

                AnimatorStateInfo stateInfo = animators[i].GetCurrentAnimatorStateInfo(0);
                if (ignoreRepeatMotion)
                {
                    if (stateInfo.length > 0 && stateInfo.normalizedTime < 1)
                        return true;
                }
                else
                {
                    if (stateInfo.length > 0 && (stateInfo.normalizedTime < 1 || stateInfo.loop))
                        return true;
                }
            }
        }
        return false;
    }

    public static bool IsInRange(this Vector3 v, Vector3 min, Vector3 max, float compareDeviation)
    {
        return v.x >= min.x - compareDeviation && v.x <= max.x + compareDeviation
            && v.y >= min.y - compareDeviation && v.y <= max.y + compareDeviation
            && v.z >= min.z - compareDeviation && v.z <= max.z + compareDeviation;
    }

	public static bool IsInRange(this Vector3 v, Vector3 min, Vector3 max)
	{
		return v.x >= min.x && v.x <= max.x
			&& v.y >= min.y && v.y <= max.y
			&& v.z >= min.z && v.z <= max.z;
	}

    public static Vector3 ClampPosition(this Vector3 v, Vector3 min, Vector3 max)
    {
        return new Vector3(Mathf.Clamp(v.x, min.x, max.x), Mathf.Clamp(v.y, min.y, max.y), Mathf.Clamp(v.z, min.z, max.z));
    }

	public static Vector3 RandomPosition(Vector3 min, Vector3 max)
	{
		return new Vector3 (Random.Range (min.x, max.x), Random.Range (min.y, max.y), Random.Range (min.z, max.z));
	}

    public static bool DirEqual(this Vector3 v1, Vector3 v2, float compareDeviation = 1e-3f)
    {
        if (Mathf.Abs(v1.x) < Mathf.Abs(v1.y))
        {
            if (Mathf.Abs(v1.y) < Mathf.Abs(v1.z))
            {
                //max z
                if (v1.z.FEqual(0, compareDeviation))
                    return v2.FEqual(Vector3.zero, compareDeviation);
                else
                    return v2.z * v1.z > 0 && v2.FEqual(v1 * (v2.z / v1.z), compareDeviation);
            }
            else
            {
                //max y
                if (v1.y.FEqual(0, compareDeviation))
                    return v2.FEqual(Vector3.zero, compareDeviation);
                else
                    return v2.y * v1.y > 0 && v2.FEqual(v1 * (v2.y / v1.y), compareDeviation);
            }
        }
        else if (Mathf.Abs(v1.x) < Mathf.Abs(v1.z))
        {
            //max z
            if (v1.z.FEqual(0, compareDeviation))
                return v2.FEqual(Vector3.zero, compareDeviation);
            else
                return v2.z * v1.z > 0 && v2.FEqual(v1 * (v2.z / v1.z), compareDeviation);
        }
        else
        {
            //max x
            if (v1.x.FEqual(0, compareDeviation))
                return v2.FEqual(Vector3.zero, compareDeviation);
            else
                return v2.x * v1.x > 0 && v2.FEqual(v1 * (v2.x / v1.x), compareDeviation);
        }
        
    }

    //两直线最短距离，要求d1,d2为标准化向量
    public static float MinSqrDistanceOfLine(Vector3 p1, Vector3 d1, Vector3 p2, Vector3 d2, out float resultT1, out float resultT2)
    {
        Vector3 c = Vector3.Cross(d1, d2);
        float sqrMagnitude = Vector3.SqrMagnitude(c);
        if (sqrMagnitude < 1e-5f)
        {
            //平行/重合
            resultT1 = 0;
            resultT2 = Vector3.Dot(p1 - p2, d2);
            return Vector3.SqrMagnitude(p1 - (p2 + resultT2 * d2));
        }
        else
        {
            resultT1 = Vector3.Dot(Vector3.Cross((p2 - p1), d2), c) / sqrMagnitude;
            resultT2 = Vector3.Dot(Vector3.Cross((p2 - p1), d1), c) / sqrMagnitude;
            return Vector3.SqrMagnitude((p1 + resultT1 * d1) - (p2 + resultT2 * d2));
        }
    }

    public static float SqrDistanceToLine(this Vector3 p, Vector3 p0, Vector3 d, out float t)
    {
        t = Vector3.Dot(p - p0, d);
        return Vector3.SqrMagnitude(p - (p0 + t * d));
    }

    public static bool RayHitCheckCylinder(Ray r, Vector3 p, float radius, float height)
    {
        float sqrRadius = radius * radius;
        float t1, t2;
        float minSqrDistance = MinSqrDistanceOfLine(r.origin, r.direction, p, Vector3.up, out t1, out t2);
        if (minSqrDistance >= sqrRadius)
            return false;
        if (t1 < 0)
        {
            minSqrDistance = r.origin.SqrDistanceToLine(p, Vector3.up, out t2);
            if (minSqrDistance >= sqrRadius)
                return false;
            if (t2 <= 0 || t2 >= height)
                minSqrDistance = Mathf.Min(Vector3.SqrMagnitude(p - r.origin), Vector3.SqrMagnitude(p + Vector3.up * height - r.origin));
            return minSqrDistance < sqrRadius;
        }
        else
        {
            if (t2 <= 0 || t2 >= height)
                minSqrDistance = Mathf.Min(
                    p.SqrDistanceToLine(r.origin, r.direction, out t1),
                    (p + Vector3.up * height).SqrDistanceToLine(r.origin, r.direction, out t1)
                    );
            return minSqrDistance < sqrRadius;
        }
    }

    public static Transform SearchFirstInChildrenByName(this Transform t, string name)
    {
        if (t.name == name)
            return t;

        for (int i = 0; i < t.childCount; i++)
        {
            Transform found = SearchFirstInChildrenByName(t.GetChild(i), name);
            if (found != null)
                return found;
        }

        return null;
    }

    public static void AttachChild(this Transform t, Transform child, string path = null, bool isFullPath = true)
    {
        if (string.IsNullOrEmpty(path))
            child.SetParent(t);
        else
        {
            if (isFullPath)
            {
                Transform attachParent = t.Find(path);
                if (attachParent != null)
                    child.SetParent(attachParent);
            }
            else
            {
                Transform attachParent = t.SearchFirstInChildrenByName(path);
                if (attachParent != null)
                    child.SetParent(attachParent);
            }
        }
    }

    public delegate bool CheckObjectCallback<T>(T element);
    public delegate void DoObjectCallback<T>(T element);
    public delegate T2 ConvertObjectCallback<T1, T2>(T1 element);
    public static int CheckElementCount<T>(this T[] srcArray, CheckObjectCallback<T> cb)
    {
        int cnt = 0;
        for (int i = 0; i < srcArray.Length; i++)
        {
            if (cb(srcArray[i]))
                cnt++;
        }
        return cnt;
    }

    public static bool CheckAll<T>(this T[] srcArray, CheckObjectCallback<T> cb)
    {
        for (int i = 0; i < srcArray.Length; i++)
        {
            if (!cb(srcArray[i]))
                return false;
        }
        return true;
    }

    public static int CheckElementCount<T>(this System.Collections.Generic.List<T> srcList, CheckObjectCallback<T> cb)
    {
        int cnt = 0;
        for (int i = 0; i < srcList.Count; i++)
        {
            if (cb(srcList[i]))
                cnt++;
        }
        return cnt;
    }

    public static bool CheckAll<T>(this System.Collections.Generic.List<T> srcList, CheckObjectCallback<T> cb)
    {
        for (int i = 0; i < srcList.Count; i++)
        {
            if (!cb(srcList[i]))
                return false;
        }
        return true;
    }

    public static System.Collections.Generic.List<T> SelectFromArray<T>(this T[] srcArray, CheckObjectCallback<T> cb)
    {
        System.Collections.Generic.List<T> resultList = new System.Collections.Generic.List<T>();
        for (int i = 0; i < srcArray.Length; i++)
        {
            if (cb(srcArray[i]))
                resultList.Add(srcArray[i]);
        }

        return resultList;
    }

    public static void DoForAll<T>(this T[] srcArray, DoObjectCallback<T> cb)
    {
        for (int i = 0; i < srcArray.Length; i++)
            cb(srcArray[i]);
    }

    public static System.Collections.Generic.List<T> SelectFromList<T>(this System.Collections.Generic.List<T> srcList, CheckObjectCallback<T> cb)
    {
        System.Collections.Generic.List<T> resultList = new System.Collections.Generic.List<T>();
        for (int i = 0; i < srcList.Count; i++)
        {
            if (cb(srcList[i]))
                resultList.Add(srcList[i]);
        }

        return resultList;
    }

    public static void DoForAll<T>(this System.Collections.Generic.List<T> srcList, DoObjectCallback<T> cb)
    {
        for (int i = 0; i < srcList.Count; i++)
            cb(srcList[i]);
    }

    public static T FindFirst<T>(this T[] srcArray, CheckObjectCallback<T> cb)
    {
        for (int i = 0; i < srcArray.Length; i++)
        {
            if (cb(srcArray[i]))
                return srcArray[i];
        }
        return default(T);
    }

    public static int IndexOf<T>(this T[] srcArray, CheckObjectCallback<T> cb)
    {
        for (int i = 0; i < srcArray.Length; i++)
        {
            if (cb(srcArray[i]))
                return i;
        }
        return -1;
    }

    public static T FindFirst<T>(this System.Collections.Generic.List<T> srcList, CheckObjectCallback<T> cb)
    {
        for (int i = 0; i < srcList.Count; i++)
        {
            if (cb(srcList[i]))
                return srcList[i];
        }
        return default(T);
    }

    public static T2[] ConvertArray<T1, T2>(this T1[] srcArray, ConvertObjectCallback<T1, T2> cb)
    {
        T2[] result = new T2[srcArray.Length];
        for (int i = 0; i < srcArray.Length; i++)
            result[i] = cb(srcArray[i]);
        return result;
    }

    public static void RemoveComponentsInChildren<T>(this Transform t) where T : Component
    {
        for (int i = 0; i < t.childCount; i++)
            RemoveComponentsInChildren<T>(t.GetChild(i));

        while (t.GetComponent<T>() != null)
        {
            T com = t.GetComponent<T>();
            GameObject.DestroyImmediate(com);
        }
    }

    public static int MiddleSearch<T>(this System.Collections.Generic.List<T> list, int idx, CheckObjectCallback<T> cb)
    {
        if (idx < list.Count && idx >= 0)
        {
            if (cb(list[idx]))
                return idx;
        }

        int offset = 1;
        while (idx + offset < list.Count || idx - offset >= 0)
        {
            if (idx + offset >= 0 && idx + offset < list.Count && cb(list[idx + offset]))
                return idx + offset;
            if (idx - offset >= 0 && idx - offset < list.Count && cb(list[idx - offset]))
                return idx - offset;
            offset++;
        }

        return -1;
    }

    public static void ResetAnimationToStart(Animation anim)
    {
        if (anim != null && anim.clip != null)
        {
            string name = anim.clip.name;
            anim[name].speed = -1;
            anim.Play(name);
        }
    }

    public static void ReplayResetAnimation(Animation anim)
    {
        if (anim != null && anim.clip != null)
        {
            string name = anim.clip.name;
            anim[name].speed = 1;
            anim.Play(name);
        }
    }

	public static string FormatDescription(string desc, float seconds, float[] values, float rate = 1f, int secondPrecision = 0, int percentPrecision = 1, int valuePrecision = 0)
	{
		string result = desc;

		if (result.Contains("%t"))
			result = result.Replace("%t", seconds.ToString("F" + secondPrecision.ToString()));

		if (result.Contains("%r"))
			result = result.Replace("%r", (rate * 100).ToString("F" + percentPrecision.ToString()));

		int idx = 0;
		while (idx < values.Length)
		{
			float value = values[idx];

			char c = (char)('a' + idx);
			if (result.Contains("%" + c))
				result = result.Replace("%" + c, (value * 0.01f).ToString("F" + percentPrecision.ToString()));

			char C = (char)('A' + idx);
			if (result.Contains("%" + C))
				result = result.Replace("%" + C, value.ToString("F" + valuePrecision.ToString()));

			idx++;
		}

		result = result.Replace("%%", "%");

		return result; 
	}

	public static string FormatUpgradeDescription(string desc, float seconds, float[] values, float rate, float deltaSeconds, float[] deltaValues, float deltaRate, int secondPrecision = 0, int percentPrecision = 1, int valuePrecision = 0)
	{
		string result = desc;

		if (result.Contains ("%t")) {
			if (deltaSeconds < 1e-4f)
				result = result.Replace ("%t", seconds.ToString ("F" + secondPrecision.ToString ()));
			else
				result = result.Replace ("%t", seconds.ToString ("F" + secondPrecision.ToString ()) 
					+ string.Format ("(+{0})", deltaSeconds.ToString ("F" + secondPrecision.ToString ())));
		}

		if (result.Contains ("%r")) {
			if (deltaRate < 1e-4f)	
				result = result.Replace ("%r", (rate * 100).ToString ("F" + percentPrecision.ToString ()));
			else
				result = result.Replace ("%r", (rate * 100).ToString ("F" + percentPrecision.ToString ()) 
					+ string.Format ("(+{0})", (deltaRate * 100).ToString ("F" + percentPrecision.ToString ())));
		}

		int idx = 0;
		while (idx < values.Length)
		{
			float value = values[idx];
			float addValue = deltaValues[idx];

			char c = (char)('a' + idx);
			if (result.Contains ("%" + c)) {
				if (addValue < 1e-4f)
					result = result.Replace ("%" + c, (value * 0.01f).ToString ("F" + percentPrecision.ToString ()));
				else
					result = result.Replace ("%" + c, (value * 0.01f).ToString ("F" + percentPrecision.ToString ())
						+ string.Format ("(+{0}%)", (addValue * 0.01f).ToString ("F" + percentPrecision.ToString ())));
			}

			char C = (char)('A' + idx);
			if (result.Contains ("%" + C)) {
				if (addValue < 1e-4f)
					result = result.Replace ("%" + C, value.ToString ("F" + valuePrecision.ToString ()));
				else
					result = result.Replace ("%" + C, value.ToString ("F" + valuePrecision.ToString ())
						+ string.Format ("(+{0})", addValue.ToString ("F" + valuePrecision.ToString ())));
			}

			idx++;
		}

		result = result.Replace("%%", "%");

		return result; 
	}

    public static string FormatDescription(string desc, float seconds, float[] values, float[] nextValues, float rate = 1f, int secondPrecision = 0, int percentPrecision = 1, int valuePrecision = 0)
    {
        string result = desc;

        if (result.Contains("%t"))
            result = result.Replace("%t", seconds.ToString("F" + secondPrecision.ToString()));

        if (result.Contains("%r"))
            result = result.Replace("%r", (rate * 100).ToString("F" + percentPrecision.ToString()));

        int idx = 0;
        while (idx < values.Length)
        {
            float value = values[idx];
            float nextValue = nextValues[idx];

            char c = (char)('a' + idx);
            if (result.Contains("%" + c))
                result = result.Replace("%" + c, (value * 0.01f).ToString("F" + percentPrecision.ToString()));
            if (result.Contains("%(" + c + "+1)"))
                result = result.Replace("%(" + c + "+1)", (nextValue * 0.01f).ToString("F" + percentPrecision.ToString()));

            char C = (char)('A' + idx);
            if (result.Contains("%" + C))
                result = result.Replace("%" + C, value.ToString("F" + valuePrecision.ToString()));
            if (result.Contains("%(" + C + "+1)"))
                result = result.Replace("%(" + C + "+1)", nextValue.ToString("F" + valuePrecision.ToString()));

            idx++;
        }

        result = result.Replace("%%", "%");

        return result; 
    }

    public static Vector3 ConvertCfgVector3(object obj)
    {
        try
        {
            float[] values = ((List<object>)obj).ConvertAll(a => 
            {
                if (a.GetType() == typeof(System.Single))
                    return (float)a;
                else if (a.GetType() == typeof(System.Int32))
                    return (float)(System.Int32)a;
                else return (float)a;
            }).ToArray();
            return new Vector3(values[0], values[1], values[2]);
        }
        catch
        {
            //Log.E("ConvertCfgVector3:{0}", obj.ToString());
            return Vector3.zero;
        }
    }

    public static Vector2 ConvertCfgVector2(object obj)
    {
        try
        {
            float[] values = ((List<object>)obj).ConvertAll(a =>
            {
                if (a.GetType() == typeof(System.Single))
                    return (float)a;
                else if (a.GetType() == typeof(System.Int32))
                    return (float)(System.Int32)a;
                else return (float)a;
            }).ToArray();
            return new Vector2(values[0], values[1]);
        }
        catch
        {
            //Log.E("ConvertCfgVector2:{0}", obj.ToString());
            return Vector2.zero;
        }
    }

	#if UNITY_EDITOR
	public static void DrawDirCubeGizmos(Vector3 pos, Vector3 size, Vector3 forward, Vector3 up)
	{
		Vector3 right = Vector3.Cross (forward, up);
		Vector3 halfSize = 0.5f * size;
		Vector3 v1 = pos - halfSize.x * right - halfSize.y * up - halfSize.z * forward;
		Vector3 v2 = v1 + size.x * right;
		Vector3 v3 = v2 + size.z * forward;
		Vector3 v4 = v1 + size.z * forward;
		Vector3 v5 = v1 + size.y * up;
		Vector3 v6 = v2 + size.y * up;
		Vector3 v7 = v3 + size.y * up;
		Vector3 v8 = v4 + size.y * up;
		Gizmos.DrawLine (v1, v2);
		Gizmos.DrawLine (v2, v3);
		Gizmos.DrawLine (v3, v4);
		Gizmos.DrawLine (v4, v1);
		Gizmos.DrawLine (v5, v6);
		Gizmos.DrawLine (v6, v7);
		Gizmos.DrawLine (v7, v8);
		Gizmos.DrawLine (v8, v5);
		Gizmos.DrawLine (v1, v5);
		Gizmos.DrawLine (v2, v6);
		Gizmos.DrawLine (v3, v7);
		Gizmos.DrawLine (v4, v8);
	}
	#endif
}
