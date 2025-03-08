using UnityEngine;
using System.Collections;

public class TweenRectTransformPosition : Tweener
{
	public Vector3 from;
	public Vector3 to;

	RectTransform mRectTrans;
	public RectTransform cachedRectTransform { get { if (mRectTrans == null) mRectTrans = GetComponent<RectTransform>(); return mRectTrans; } }


	public Vector3 value
	{
		get
		{
			return cachedRectTransform.anchoredPosition3D;
		}
		set
		{
			cachedRectTransform.anchoredPosition3D = value;
		}
	}

	protected override void OnUpdate(float factor, bool isFinished) { value = from * (1f - factor) + to * factor; }

	static public TweenRectTransformPosition Begin(GameObject go, float duration, Vector3 pos)
	{
		TweenRectTransformPosition comp = Tweener.Begin<TweenRectTransformPosition>(go, duration);
		comp.from = comp.value;
		comp.to = pos;

		if (duration <= 0f)
		{
			comp.Sample(1f, true);
			comp.enabled = false;
		}
		return comp;
	}

	[ContextMenu("Set 'From' to current value")]
	public override void SetStartToCurrentValue() { from = value; }

	[ContextMenu("Set 'To' to current value")]
	public override void SetEndToCurrentValue() { to = value; }

	[ContextMenu("Assume value of 'From'")]
	void SetCurrentValueToStart() { value = from; }

	[ContextMenu("Assume value of 'To'")]
	void SetCurrentValueToEnd() { value = to; }
}
