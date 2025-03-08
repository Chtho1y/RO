//----------------------------------------------
//            NGUI: Next-Gen UI kit
// Copyright © 2011-2014 Tasharen Entertainment
//----------------------------------------------

using UnityEngine;
using UnityEngine.UI;

/// <summary>
/// Makes it possible to animate alpha of the widget or a panel.
/// </summary>

[ExecuteInEditMode]
public class AnimatedAlpha : MonoBehaviour
{
#if !UNITY_3_5
	[Range(0f, 1f)]
#endif
	public float alpha = 1f;

    CanvasGroup mPanel;
    Image mImage;

	void OnEnable ()
	{
        mImage = GetComponent<Image>();
		mPanel = GetComponent<CanvasGroup>();
		LateUpdate();
	}

	void LateUpdate ()
	{
		if (mPanel != null) 
            mPanel.alpha = alpha;
        else if (mImage != null)
        {
            Color col = mImage.color;
            col.a = alpha;
            mImage.color = col;
        }
	}
}
