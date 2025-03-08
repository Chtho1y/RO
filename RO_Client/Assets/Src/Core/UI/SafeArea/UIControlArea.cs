using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

[RequireComponent(typeof(RectTransform))]
[DisallowMultipleComponent]
public abstract class UIControlArea : UIBehaviour
{
    protected Canvas m_Canvas;
    protected RectTransform m_RectTransform;
    protected RectTransform m_ParentRectTransform;
    protected UIControlArea[] m_ParentUICAs;

    private int m_InitFrameCount = -1;
    private bool m_Inited = false;
    private Vector3 m_InitWorldPos = Vector3.zero;
    private Vector2 m_InitAnchoredPos = Vector2.zero;
    

    public Canvas canvas
	{
		get
		{
			if (this.m_Canvas == null)
			{
				this.CacheCanvas();
			}
			return this.m_Canvas;
		}
	}

    public RectTransform rectTransform
	{
		get
		{
			if (object.ReferenceEquals(this.m_RectTransform, null))
			{
				this.m_RectTransform = base.GetComponent<RectTransform>();
			}
			return this.m_RectTransform;
		}
	}

    public RectTransform parentRectTransform
	{
		get
		{
			if (object.ReferenceEquals(this.m_ParentRectTransform, null))
			{
                var parent = rectTransform.parent;
                if (parent)
                {
                    this.m_ParentRectTransform = parent as RectTransform;
                }
			}
			return this.m_ParentRectTransform;
		}
	}

    public UIControlArea[] parentUICAs
    {
        get
		{
			if (object.ReferenceEquals(m_ParentUICAs, null))
			{
                // 这种做法逻辑上效率有点低，后续有空的时候在看看怎么优化
                m_ParentUICAs = GetComponentsInParent<UIControlArea>();
			}
			return m_ParentUICAs;
		}
    }

    protected override void Awake()
    {
        base.Awake();
        m_Inited = false;
    }

    protected override void OnEnable()
    {
        base.OnEnable();
        RefreshInitWorldPos();
        StartCoroutine(DelayOneFrameRefreshAdapt());
        SafeRectCheck safeRectCheck = SafeRectCheck.Instance;
        if (safeRectCheck)
        {
            safeRectCheck.onChanged.AddListener(OnSafeRectChanged);
        }
    }

    protected override void OnDisable()
    {
        SafeRectCheck safeRectCheck = SafeRectCheck.Instance;
        if (safeRectCheck)
        {
            safeRectCheck.onChanged.RemoveListener(OnSafeRectChanged);
        }
        StopCoroutine(DelayOneFrameRefreshAdapt());
        LayoutRebuilder.MarkLayoutForRebuild(rectTransform);
        base.OnDisable();
    }

    protected override void OnBeforeTransformParentChanged()
    {
        base.OnBeforeTransformParentChanged();
        LayoutRebuilder.MarkLayoutForRebuild(rectTransform);
    }

    protected override void OnTransformParentChanged()
    {
        m_Canvas = null;
        m_ParentRectTransform = null;
        m_ParentUICAs = null;
        // if (!IsActive()) return;
        RefreshInitWorldPos();
    }

    protected override void OnRectTransformDimensionsChange()
    {
        // if (!IsActive()) return;
        RefreshInitWorldPos();
    }

    protected override void OnCanvasHierarchyChanged()
    {
        m_Canvas = null;
        // if (!IsActive()) return;
        RefreshInitWorldPos();
    }

    private void CacheCanvas()
	{
		List<Canvas> list = new List<Canvas>();
		base.gameObject.GetComponentsInParent(false, list);
		if (list.Count > 0)
		{
			int num = 0;
			while (num < list.Count)
			{
				if (!list[num].isActiveAndEnabled)
				{
					num++;
					continue;
				}
				m_Canvas = list[num];
				break;
			}
		}
		else
		{
			m_Canvas = null;
		}
	}

    protected virtual void OnSafeRectChanged()
    {
        RefreshAdapt();
    }

    public virtual void RefreshAdapt()
    {
        SafeRectCheck safeRectCheck = SafeRectCheck.Instance;
        if (!safeRectCheck) return;
        CalcAdapt(safeRectCheck.safeArea, safeRectCheck.orientation, safeRectCheck.screenWidth, safeRectCheck.screenHeight);
    }

    protected abstract void CalcRect(Rect safeArea, ScreenOrientation orientation, int width, int height, out Vector2 min, out Vector2 max);

    private void CalcAdapt(Rect safeArea, ScreenOrientation orientation, int width, int height)
    {
        if (!canvas || canvas.renderMode == RenderMode.WorldSpace) return;
        RectTransform parent = parentRectTransform;
        if (!parent) return;
#if !UNITY_2018_4_OR_NEWER
        // safeArea 为左上角坐标 
        safeArea.y = height - safeArea.y - safeArea.height;
#endif
        Vector2 min, max;
        CalcRect(safeArea, orientation, width, height, out min, out max);
        SetArea(parent, min, max, width, height);
    }


    private void SetArea(RectTransform parent, Vector2 min, Vector2 max, int width, int height)
    {
        Vector2 minLocal, maxLocal;
        Camera camera = (canvas.renderMode == RenderMode.ScreenSpaceOverlay ? null : canvas.worldCamera);
        if (!RectTransformUtility.ScreenPointToLocalPointInRectangle(parent, min, camera, out minLocal))
        {
            return;
        }

        if (!RectTransformUtility.ScreenPointToLocalPointInRectangle(parent, max, camera, out maxLocal))
        {
            return;
        }
        m_Inited = true;

        Rect rect = parent.rect;
        Vector2 size = rect.size;
        Vector2 position = rect.position;
        Vector2 anchorMin = rectTransform.anchorMin;
        Vector2 anchorMax = rectTransform.anchorMax;
        Vector2 pivot = rectTransform.pivot;

        Vector2 offsetMin = minLocal - Vector2.Scale(size, anchorMin);
        Vector2 offsetMax = maxLocal - Vector2.Scale(size, anchorMax);

        Vector2 sizeDelta = offsetMax - offsetMin;
        offsetMin = offsetMin - position;
        Vector2 anchoredPosition = offsetMin + Vector2.Scale(sizeDelta, pivot);

        Vector2 offset = parent.InverseTransformVector(m_InitWorldPos - rectTransform.position);

        anchoredPosition = anchoredPosition - offset + (m_InitAnchoredPos - rectTransform.anchoredPosition);
        foreach(var parentUICA in parentUICAs)
        {
            if (parentUICA == this) continue;
            // 需要过滤掉父对象中的适配偏移
            anchoredPosition += parentUICA.GetAnchoredPositionOffset();
        }

        rectTransform.anchoredPosition = anchoredPosition;
        rectTransform.sizeDelta = sizeDelta;
    }

    private void RefreshInitWorldPos()
    {
        if (m_Inited) return;
        int curFrameCount = Time.frameCount;
        if (m_InitFrameCount == -1)
        {
            m_InitFrameCount = curFrameCount;
        }
        else if (m_InitFrameCount != curFrameCount)
        {
            return;
        }
        m_InitWorldPos = rectTransform.position;
        m_InitAnchoredPos = rectTransform.anchoredPosition;
    }

    private IEnumerator DelayOneFrameRefreshAdapt()
    {
        yield return null;
        // 在初始界面打开时，需要保持缩放一致，否则计算目标坐标时无法确定准确
        while (!canvas || canvas.transform.lossyScale != rectTransform.lossyScale)
        {
            yield return null;
        }
        RefreshAdapt();
    }

    private Vector2 GetAnchoredPositionOffset()
    {
        return (m_InitAnchoredPos - rectTransform.anchoredPosition);
    }
}
