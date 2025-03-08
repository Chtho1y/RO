/*
 * -------------------------------------------------------------------------------
 * FileName : ContentSizeLimit.cs
 * Created : 2019-02-23 16:18
 * Author : wboy
 * Mail : mrtop@126.com
 * Compiler : Visual Studio Code And Unity3d
 * Description : 
 *
 * -------------------------------------------------------------------------------
 */


using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

[AddComponentMenu("Layout/Content Size Limit", 141)]
[RequireComponent(typeof(RectTransform))]
[ExecuteInEditMode]
public class ContentSizeLimit : UIBehaviour, ILayoutSelfController, ILayoutController 
{
	[SerializeField]
	private float m_MaxWidth = -1f;

	[SerializeField]
	private float m_MaxHeight = -1f;

	[NonSerialized]
	private RectTransform m_Rect;

	private DrivenRectTransformTracker m_Tracker;

	public virtual float maxWidth
	{
		get { return m_MaxWidth; }
		set
		{
			if (m_MaxWidth != value)
			{
				m_MaxWidth = value;
				SetDirty();
			}
		}
	}

	public virtual float maxHeight
	{
		get { return m_MaxHeight; }
		set
		{
			if (m_MaxHeight != value)
			{
				m_MaxHeight = value;
				SetDirty();
			}
		}
	}

	private RectTransform rectTransform
	{
		get
		{
			if ((UnityEngine.Object)m_Rect == (UnityEngine.Object)null)
			{
				m_Rect = base.GetComponent<RectTransform>();
			}
			return m_Rect;
		}
	}


	protected override void OnEnable()
	{
		base.OnEnable();
		SetDirty();
	}

	protected override void OnDisable()
	{
		m_Tracker.Clear();
		LayoutRebuilder.MarkLayoutForRebuild(rectTransform);
		base.OnDisable();
	}

	protected override void OnRectTransformDimensionsChange()
	{
		SetDirty();
	}

	public virtual void SetLayoutHorizontal()
	{
		m_Tracker.Clear();
		if (m_MaxWidth > -1)
		{
			m_Tracker.Add(this, rectTransform, DrivenTransformProperties.SizeDeltaX);
			rectTransform.SetSizeWithCurrentAnchors(RectTransform.Axis.Horizontal, Mathf.Min(m_MaxWidth, LayoutUtility.GetPreferredWidth(m_Rect)));
		}
		else
		{
			m_Tracker.Add(this, rectTransform, DrivenTransformProperties.None);
		}
	}

	public virtual void SetLayoutVertical()
	{
		if (m_MaxHeight > -1)
		{
			m_Tracker.Add(this, rectTransform, DrivenTransformProperties.SizeDeltaY);
			rectTransform.SetSizeWithCurrentAnchors(RectTransform.Axis.Vertical, Mathf.Min(m_MaxHeight, LayoutUtility.GetPreferredHeight(m_Rect)));
		}
		else
		{
			m_Tracker.Add(this, rectTransform, DrivenTransformProperties.None);
		}
	}


	protected void SetDirty()
	{
		if (IsActive())
		{
			LayoutRebuilder.MarkLayoutForRebuild(rectTransform);
		}
	}
}
