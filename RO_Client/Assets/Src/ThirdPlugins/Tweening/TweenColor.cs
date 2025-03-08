//----------------------------------------------
//            NGUI: Next-Gen UI kit
// Copyright © 2011-2014 Tasharen Entertainment
//----------------------------------------------

using UnityEngine;
using UnityEngine.UI;

/// <summary>
/// Tween the object's color.
/// </summary>

public class TweenColor : Tweener
{
	public Color from = Color.white;
	public Color to = Color.white;

	bool mCached = false;
    Image mImage;
    Text mText;
	Material mMat;
	Light mLight;

	void Cache ()
	{
		mCached = true;
        mImage = GetComponent<Image>();
        mText = GetComponent<Text>();
		Renderer ren = GetComponent<Renderer>();
		if (ren != null) mMat = ren.material;
		mLight = GetComponent<Light>();
	}

	[System.Obsolete("Use 'value' instead")]
	public Color color { get { return this.value; } set { this.value = value; } }

	/// <summary>
	/// Tween's current value.
	/// </summary>

	public Color value
	{
		get
		{
			if (!mCached) Cache();
            if (mImage != null) return mImage.color;
            else if (mText != null) return mText.color;
			else if (mLight != null) return mLight.color;
			else if (mMat != null) return mMat.color;
			return Color.black;
		}
		set
		{
			if (!mCached) Cache();
            if (mImage != null) mImage.color = value;
            else if (mText != null) mText.color = value;
            else if (mMat != null) mMat.color = value;
			else if (mLight != null)
			{
				mLight.color = value;
				mLight.enabled = (value.r + value.g + value.b) > 0.01f;
			}
		}
	}

	/// <summary>
	/// Tween the value.
	/// </summary>

	protected override void OnUpdate (float factor, bool isFinished) { value = Color.Lerp(from, to, factor); }

	/// <summary>
	/// Start the tweening operation.
	/// </summary>

	static public TweenColor Begin (GameObject go, float duration, Color color)
	{
#if UNITY_EDITOR
		if (!Application.isPlaying) return null;
#endif
		TweenColor comp = Tweener.Begin<TweenColor>(go, duration);
		comp.from = comp.value;
		comp.to = color;

		if (duration <= 0f)
		{
			comp.Sample(1f, true);
			comp.enabled = false;
		}
		return comp;
	}

	[ContextMenu("Set 'From' to current value")]
	public override void SetStartToCurrentValue () { from = value; }

	[ContextMenu("Set 'To' to current value")]
	public override void SetEndToCurrentValue () { to = value; }

	[ContextMenu("Assume value of 'From'")]
	void SetCurrentValueToStart () { value = from; }

	[ContextMenu("Assume value of 'To'")]
	void SetCurrentValueToEnd () { value = to; }
}
