using System;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using FitMode = UnityEngine.UI.ContentSizeFitter.FitMode;

[AddComponentMenu("Layout/Sync Layout Group Limit", 149)]
[RequireComponent(typeof(RectTransform))]
[ExecuteInEditMode]
public class SyncLayoutGroupLimit : LayoutElement, ILayoutSelfController
{
    [SerializeField] protected RectTransform m_SyncTargetRect;
    [SerializeField] protected FitMode m_HorizontalFit = FitMode.Unconstrained;
    [SerializeField] protected FitMode m_VerticalFit = FitMode.Unconstrained;

    [SerializeField]
	private float m_MaxWidth = -1f;
	[SerializeField]
	private float m_MaxHeight = -1f;
    
    [System.NonSerialized] private RectTransform m_Rect;
    private DrivenRectTransformTracker m_Tracker;
    private Vector2 m_TotalPreferredSize = Vector2.zero;

    public RectTransform SyncTarget
    { 
        get { return m_SyncTargetRect; }
        set
        {
            if (m_SyncTargetRect == value) return;
            m_SyncTargetRect = value;
            SetDirty();
        }
    }

    /// <summary>
    /// The fit mode to use to determine the width.
    /// </summary>
    public FitMode horizontalFit { get { return m_HorizontalFit; } set { if (SetPropertyUtility.SetStruct(ref m_HorizontalFit, value)) SetDirty(); } }

    /// <summary>
    /// The fit mode to use to determine the height.
    /// </summary>
    public FitMode verticalFit { get { return m_VerticalFit; } set { if (SetPropertyUtility.SetStruct(ref m_VerticalFit, value)) SetDirty(); } }

    public float maxWidth { get { return m_MaxWidth; } set { if (SetPropertyUtility.SetStruct(ref m_MaxWidth, value)) SetDirty(); } }
    public float maxHeight { get { return m_MaxHeight; } set { if (SetPropertyUtility.SetStruct(ref m_MaxHeight, value)) SetDirty(); } }

    public override float preferredWidth
    {
        get { return m_TotalPreferredSize[0]; }
    }

    public override float preferredHeight
    {
        get { return m_TotalPreferredSize[1]; }
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

    protected void CalcAlongAxis(int axis)
    {
        FitMode fitting = (axis == 0 ? horizontalFit : verticalFit);
        if (fitting == FitMode.Unconstrained)
        {
            m_TotalPreferredSize[axis] = -1;
            return;
        }
        float max = (axis == 0 ? maxWidth : maxHeight);
        // Set size to min or preferred size
        if (fitting == FitMode.MinSize)
        {
            float minSize;
            if (max > -1)
                minSize = Mathf.Min(max, LayoutUtility.GetMinSize(m_SyncTargetRect, axis));
            else
                minSize = LayoutUtility.GetMinSize(m_SyncTargetRect, axis);
            m_TotalPreferredSize[axis] = minSize;
        }
        else
        {
            float maxSize;
            if (max > -1)
                maxSize = Mathf.Min(max, LayoutUtility.GetPreferredSize(m_SyncTargetRect, axis));
            else
                maxSize = LayoutUtility.GetPreferredSize(m_SyncTargetRect, axis);
            m_TotalPreferredSize[axis] = maxSize;
        }
    }

    private void HandleSelfFittingAlongAxis(int axis)
    {
        FitMode fitting = (axis == 0 ? horizontalFit : verticalFit);
        if (fitting == FitMode.Unconstrained)
        {
            // Keep a reference to the tracked transform, but don't control its properties:
            m_Tracker.Add(this, rectTransform, DrivenTransformProperties.None);
            return;
        }

        m_Tracker.Add(this, rectTransform, (axis == 0 ? DrivenTransformProperties.SizeDeltaX : DrivenTransformProperties.SizeDeltaY));
        rectTransform.SetSizeWithCurrentAnchors((RectTransform.Axis)axis, m_TotalPreferredSize[axis]);
    }

    public override void CalculateLayoutInputHorizontal()
    {
        CalcAlongAxis(0);
    }

    public override void CalculateLayoutInputVertical()
    {
        CalcAlongAxis(1);
    }

    public virtual void SetLayoutHorizontal()
    {
        m_Tracker.Clear();
        HandleSelfFittingAlongAxis(0);
    }

    public virtual void SetLayoutVertical()
    {
        HandleSelfFittingAlongAxis(1);
    }
}