//----------------------------------------------
//            NGUI: Next-Gen UI kit
// Copyright © 2011-2014 Tasharen Entertainment
//----------------------------------------------

using UnityEngine;
using UnityEngine.UI;

/// <summary>
/// Tween the object's alpha.
/// </summary>

public class TweenAlpha : Tweener
{
#if UNITY_3_5
	public float from = 1f;
	public float to = 1f;
#else
	[Range(0f, 1f)] public float from = 1f;
	[Range(0f, 1f)] public float to = 1f;
#endif

    CanvasGroup mPanel;
    Image mImage;

    protected override void Start()
    {
        mPanel = GetComponent<CanvasGroup>();
        mImage = GetComponent<Image>();

        base.Start();
    }

    void OnEnable()
    {
        mPanel = GetComponent<CanvasGroup>();
        mImage = GetComponent<Image>();
    }

	/// <summary>
	/// Tween's current value.
	/// </summary>

    public float value 
    { 
        get 
        {
            if (mPanel != null) return mPanel.alpha;
            else if (mImage != null) return mImage.color.a;
            return 0f;
        } 
        set 
        { 
            if(mPanel != null) mPanel.alpha = value; 
            else if(mImage != null)
            {
                Color col = mImage.color;
                col.a = value;
                mImage.color = col;
            }
        } 
    }

	/// <summary>
	/// Tween the value.
	/// </summary>

	protected override void OnUpdate (float factor, bool isFinished) { value = Mathf.Lerp(from, to, factor); }

	/// <summary>
	/// Start the tweening operation.
	/// </summary>

	static public TweenAlpha Begin (GameObject go, float duration, float alpha)
	{
		TweenAlpha comp = Tweener.Begin<TweenAlpha>(go, duration);
		comp.from = comp.value;
		comp.to = alpha;

		if (duration <= 0f)
		{
			comp.Sample(1f, true);
			comp.enabled = false;
		}
		return comp;
	}

	public override void SetStartToCurrentValue () { from = value; }
	public override void SetEndToCurrentValue () { to = value; }
}
