using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[ExecuteAlways]
public abstract class SlideHorizontalOrVerticalLayoutGroup : LayoutGroup
{
    [SerializeField] protected float m_Spacing = 0;
    
    /// <summary>
    /// The spacing to use between layout elements in the layout group.
    /// </summary>
    public float spacing { get { return m_Spacing; } set { SetProperty(ref m_Spacing, value); } }

    [SerializeField] protected bool m_ChildForceExpandWidth = true;

    /// <summary>
    /// Whether to force the children to expand to fill additional available horizontal space.
    /// </summary>
    public bool childForceExpandWidth { get { return m_ChildForceExpandWidth; } set { SetProperty(ref m_ChildForceExpandWidth, value); } }

    [SerializeField] protected bool m_ChildForceExpandHeight = true;

    /// <summary>
    /// Whether to force the children to expand to fill additional available vertical space.
    /// </summary>
    public bool childForceExpandHeight { get { return m_ChildForceExpandHeight; } set { SetProperty(ref m_ChildForceExpandHeight, value); } }

    [SerializeField] protected bool m_ChildControlWidth = true;

    /// <summary>
    /// Returns true if the Layout Group controls the widths of its children. Returns false if children control their own widths.
    /// </summary>
    /// <remarks>
    /// If set to false, the layout group will only affect the positions of the children while leaving the widths untouched. The widths of the children can be set via the respective RectTransforms in this case.
    ///
    /// If set to true, the widths of the children are automatically driven by the layout group according to their respective minimum, preferred, and flexible widths.This is useful if the widths of the children should change depending on how much space is available.In this case the width of each child cannot be set manually in the RectTransform, but the minimum, preferred and flexible width for each child can be controlled by adding a LayoutElement component to it.
    /// </remarks>
    public bool childControlWidth { get { return m_ChildControlWidth; } set { SetProperty(ref m_ChildControlWidth, value); } }

    [SerializeField] protected bool m_ChildControlHeight = true;

    /// <summary>
    /// Returns true if the Layout Group controls the heights of its children. Returns false if children control their own heights.
    /// </summary>
    /// <remarks>
    /// If set to false, the layout group will only affect the positions of the children while leaving the heights untouched. The heights of the children can be set via the respective RectTransforms in this case.
    ///
    /// If set to true, the heights of the children are automatically driven by the layout group according to their respective minimum, preferred, and flexible heights.This is useful if the heights of the children should change depending on how much space is available.In this case the height of each child cannot be set manually in the RectTransform, but the minimum, preferred and flexible height for each child can be controlled by adding a LayoutElement component to it.
    /// </remarks>
    public bool childControlHeight { get { return m_ChildControlHeight; } set { SetProperty(ref m_ChildControlHeight, value); } }
    
    [SerializeField] protected bool m_SnapEnable = false;
    public bool snapEnable { get { return m_SnapEnable; } set { SetProperty(ref m_SnapEnable, value); } }

    [SerializeField] protected bool m_InverseChildPosEnable = false;
    /// <summary>
    /// 当碰到界面太紧凑，需要SiblingIndex越大的在队列的最前面，就可以使用它
    /// </summary>
    public bool inverseChildPosEnable { get { return m_InverseChildPosEnable; } set { SetProperty(ref m_InverseChildPosEnable, value); } }

    [SerializeField] protected bool m_InvisibleVaild = false;
    /// <summary>
    /// 是否不可见对象加入排列计算中
    /// </summary>
    public bool invisibleVaild { get { return m_InvisibleVaild; } set { SetProperty(ref m_InvisibleVaild, value); } }

    private Dictionary<Transform, Vector3> m_SlideTargetPosDic = new Dictionary<Transform, Vector3>();
    public Dictionary<Transform, Vector3> slideTargePosDic
    {
        get { return m_SlideTargetPosDic; }
    }

    private const float kLerp = .5f;
    private const float kSnap = .5f;

    public override void CalculateLayoutInputHorizontal()
    {
        m_SlideTargetPosDic.Clear();
        if (m_InvisibleVaild)
        {
            rectChildren.Clear();
            List<Component> toIgnoreList = new List<Component>();
            for (int i = 0; i < rectTransform.childCount; i++)
            {
                var rect = rectTransform.GetChild(i) as RectTransform;
                if (rect == null)
                    continue;

                rect.GetComponents(typeof(ILayoutIgnorer), toIgnoreList);

                if (toIgnoreList.Count == 0)
                {
                    rectChildren.Add(rect);
                    continue;
                }

                for (int j = 0; j < toIgnoreList.Count; j++)
                {
                    var ignorer = (ILayoutIgnorer)toIgnoreList[j];
                    if (!ignorer.ignoreLayout)
                    {
                        rectChildren.Add(rect);
                        break;
                    }
                }
            }
            m_Tracker.Clear();
        }
        else
        {
            base.CalculateLayoutInputHorizontal();
        }
    }

    /// <summary>
    /// Calculate the layout element properties for this layout element along the given axis.
    /// </summary>
    /// <param name="axis">The axis to calculate for. 0 is horizontal and 1 is vertical.</param>
    /// <param name="isVertical">Is this group a vertical group?</param>
    protected void CalcAlongAxis(int axis, bool isVertical)
    {
        float combinedPadding = (axis == 0 ? padding.horizontal : padding.vertical);
        bool controlSize = (axis == 0 ? m_ChildControlWidth : m_ChildControlHeight);
        bool childForceExpandSize = (axis == 0 ? childForceExpandWidth : childForceExpandHeight);
        float totalMin = combinedPadding;
        float totalPreferred = combinedPadding;
        float totalFlexible = 0;

        bool alongOtherAxis = (isVertical ^ (axis == 1));
        for (int i = 0; i < rectChildren.Count; i++)
        {
            RectTransform child = rectChildren[i];
            float min, preferred, flexible;
            GetChildSizes(child, axis, controlSize, childForceExpandSize, out min, out preferred, out flexible);

            if (alongOtherAxis)
            {
                totalMin = Mathf.Max(min + combinedPadding, totalMin);
                totalPreferred = Mathf.Max(preferred + combinedPadding, totalPreferred);
                totalFlexible = Mathf.Max(flexible, totalFlexible);
            }
            else
            {
                totalMin += min + spacing;
                totalPreferred += preferred + spacing;

                // Increment flexible size with element's flexible size.
                totalFlexible += flexible;
            }
        }

        if (!alongOtherAxis && rectChildren.Count > 0)
        {
            totalMin -= spacing;
            totalPreferred -= spacing;
        }
        totalPreferred = Mathf.Max(totalMin, totalPreferred);
        SetLayoutInputForAxis(totalMin, totalPreferred, totalFlexible, axis);
    }

    /// <summary>
    /// Set the positions and sizes of the child layout elements for the given axis.
    /// </summary>
    /// <param name="axis">The axis to handle. 0 is horizontal and 1 is vertical.</param>
    /// <param name="isVertical">Is this group a vertical group?</param>
    protected void SetChildrenAlongAxis(int axis, bool isVertical)
    {
        bool needRefresh = false;
        float size = rectTransform.rect.size[axis];
        bool controlSize = (axis == 0 ? m_ChildControlWidth : m_ChildControlHeight);
        bool childForceExpandSize = (axis == 0 ? childForceExpandWidth : childForceExpandHeight);
        float alignmentOnAxis = GetAlignmentOnAxis(axis);

        bool alongOtherAxis = (isVertical ^ (axis == 1));
        if (alongOtherAxis)
        {
            float innerSize = size - (axis == 0 ? padding.horizontal : padding.vertical);
            if (m_InverseChildPosEnable)
            {
                for (int i = rectChildren.Count - 1; i >= 0 ; i--)
                {
                    RectTransform child = rectChildren[i];
                    float min, preferred, flexible;
                    GetChildSizes(child, axis, controlSize, childForceExpandSize, out min, out preferred, out flexible);

                    float requiredSpace = Mathf.Clamp(innerSize, min, flexible > 0 ? size : preferred);
                    float startOffset = GetStartOffset(axis, requiredSpace);
                    if (controlSize)
                    {
                        float offset = GetStartOffsetSnap(child, axis, startOffset, requiredSpace, ref needRefresh);
                        SetChildAlongAxis(child, axis, offset, requiredSpace);
                    }
                    else
                    {
                        float offsetInCell = (requiredSpace - child.sizeDelta[axis]) * alignmentOnAxis;
                        float offset = GetStartOffsetSnap(child, axis, startOffset + offsetInCell, child.sizeDelta[axis], ref needRefresh);
                        SetChildAlongAxis(child, axis, offset);
                    }
                }
            }
            else
            {
                for (int i = 0; i < rectChildren.Count; i++)
                {
                    RectTransform child = rectChildren[i];
                    float min, preferred, flexible;
                    GetChildSizes(child, axis, controlSize, childForceExpandSize, out min, out preferred, out flexible);

                    float requiredSpace = Mathf.Clamp(innerSize, min, flexible > 0 ? size : preferred);
                    float startOffset = GetStartOffset(axis, requiredSpace);
                    if (controlSize)
                    {
                        float offset = GetStartOffsetSnap(child, axis, startOffset, requiredSpace, ref needRefresh);
                        SetChildAlongAxis(child, axis, offset, requiredSpace);
                    }
                    else
                    {
                        float offsetInCell = (requiredSpace - child.sizeDelta[axis]) * alignmentOnAxis;
                        float offset = GetStartOffsetSnap(child, axis, startOffset + offsetInCell, child.sizeDelta[axis], ref needRefresh);
                        SetChildAlongAxis(child, axis, offset);
                    }
                }
            }
        }
        else
        {
            float pos = (axis == 0 ? padding.left : padding.top);
            if (GetTotalFlexibleSize(axis) == 0 && GetTotalPreferredSize(axis) < size)
                pos = GetStartOffset(axis, GetTotalPreferredSize(axis) - (axis == 0 ? padding.horizontal : padding.vertical));

            float minMaxLerp = 0;
            if (GetTotalMinSize(axis) != GetTotalPreferredSize(axis))
                minMaxLerp = Mathf.Clamp01((size - GetTotalMinSize(axis)) / (GetTotalPreferredSize(axis) - GetTotalMinSize(axis)));

            float itemFlexibleMultiplier = 0;
            if (size > GetTotalPreferredSize(axis))
            {
                if (GetTotalFlexibleSize(axis) > 0)
                    itemFlexibleMultiplier = (size - GetTotalPreferredSize(axis)) / GetTotalFlexibleSize(axis);
            }
            if (m_InverseChildPosEnable)
            {
                for (int i = rectChildren.Count - 1; i >= 0 ; i--)
                {
                    RectTransform child = rectChildren[i];
                    float min, preferred, flexible;
                    GetChildSizes(child, axis, controlSize, childForceExpandSize, out min, out preferred, out flexible);

                    float childSize = Mathf.Lerp(min, preferred, minMaxLerp);
                    childSize += flexible * itemFlexibleMultiplier;
                    if (controlSize)
                    {
                        float offset = GetStartOffsetSnap(child, axis, pos, childSize, ref needRefresh);
                        SetChildAlongAxis(child, axis, offset, childSize);
                    }
                    else
                    {
                        float offsetInCell = (childSize - child.sizeDelta[axis]) * alignmentOnAxis;
                        float offset = GetStartOffsetSnap(child, axis, pos + offsetInCell, child.sizeDelta[axis], ref needRefresh);
                        SetChildAlongAxis(child, axis, offset);
                    }
                    pos += childSize + spacing;
                }
            }
            else
            {
                for (int i = 0; i < rectChildren.Count; i++)
                {
                    RectTransform child = rectChildren[i];
                    float min, preferred, flexible;
                    GetChildSizes(child, axis, controlSize, childForceExpandSize, out min, out preferred, out flexible);

                    float childSize = Mathf.Lerp(min, preferred, minMaxLerp);
                    childSize += flexible * itemFlexibleMultiplier;
                    if (controlSize)
                    {
                        float offset = GetStartOffsetSnap(child, axis, pos, childSize, ref needRefresh);
                        SetChildAlongAxis(child, axis, offset, childSize);
                    }
                    else
                    {
                        float offsetInCell = (childSize - child.sizeDelta[axis]) * alignmentOnAxis;
                        float offset = GetStartOffsetSnap(child, axis, pos + offsetInCell, child.sizeDelta[axis], ref needRefresh);
                        SetChildAlongAxis(child, axis, offset);
                    }
                    pos += childSize + spacing;
                }
            }
        }

        if (needRefresh)
        {
            SetDirty();
        }
    }

    private void GetChildSizes(RectTransform child, int axis, bool controlSize, bool childForceExpand,
        out float min, out float preferred, out float flexible)
    {
        if (!controlSize)
        {
            min = child.sizeDelta[axis];
            preferred = min;
            flexible = 0;
        }
        else
        {
            min = LayoutUtility.GetMinSize(child, axis);
            preferred = LayoutUtility.GetPreferredSize(child, axis);
            flexible = LayoutUtility.GetFlexibleSize(child, axis);
        }

        if (childForceExpand)
            flexible = Mathf.Max(flexible, 1);
    }

    protected float GetStartOffsetSnap(RectTransform rectTransform, int axis, float targetPos, float size, ref bool needRefresh)
    {
        if (Application.isPlaying)
        {
            if (m_SnapEnable)
            {
                Vector2 pivot = rectTransform.pivot;
                Vector2 anchoredPosition = rectTransform.anchoredPosition;
                float curPos = (axis != 0) ? -(anchoredPosition[axis] + size * (1 - pivot[axis])) : (anchoredPosition[axis] - size * (1 - pivot[axis]));
                if (Mathf.Abs(curPos - targetPos) > kSnap)
                {
                    needRefresh = true;

                    if (!m_SlideTargetPosDic.ContainsKey(rectTransform))
                    {
                        m_SlideTargetPosDic.Add(rectTransform, anchoredPosition);
                    }
                    Vector3 pos = m_SlideTargetPosDic[rectTransform];
                    pos[axis] = (axis != 0) ? -targetPos - size * (1 - pivot[axis]) : targetPos + size * pivot[axis];
                    m_SlideTargetPosDic[rectTransform] = pos;

                    return Mathf.Lerp(curPos, targetPos, kLerp);
                }
                return targetPos;
            }
        }
        return targetPos;
    }

#if UNITY_EDITOR
    protected override void Reset()
    {

        base.Reset();

        // For new added components we want these to be set to false,
        // so that the user's sizes won't be overwritten before they
        // have a chance to turn these settings off.
        // However, for existing components that were added before this
        // feature was introduced, we want it to be on be default for
        // backwardds compatibility.
        // Hence their default value is on, but we set to off in reset.
        m_ChildControlWidth = false;
        m_ChildControlHeight = false;
    }

#endif
}
