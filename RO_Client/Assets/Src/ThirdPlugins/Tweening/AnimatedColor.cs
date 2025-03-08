//----------------------------------------------
//            NGUI: Next-Gen UI kit
// Copyright © 2011-2014 Tasharen Entertainment
//----------------------------------------------

using UnityEngine;
using UnityEngine.UI;

/// <summary>
/// Makes it possible to animate a color of the widget.
/// </summary>

[ExecuteInEditMode]
[RequireComponent(typeof(Image))]
public class AnimatedColor : MonoBehaviour
{
	public Color color = Color.white;

    Image mImage;

    void OnEnable() { mImage = GetComponent<Image>(); LateUpdate(); }
    void LateUpdate() { mImage.color = color; }
}
