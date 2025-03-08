using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SlideHorizontalLayoutGroup : SlideHorizontalOrVerticalLayoutGroup
{
    protected SlideHorizontalLayoutGroup()
    {}

    /// <summary>
    /// Called by the layout system. Also see ILayoutElement
    /// </summary>
    public override void CalculateLayoutInputHorizontal()
    {
        base.CalculateLayoutInputHorizontal();
        CalcAlongAxis(0, false);
    }

    /// <summary>
    /// Called by the layout system. Also see ILayoutElement
    /// </summary>
    public override void CalculateLayoutInputVertical()
    {
        CalcAlongAxis(1, false);
    }

    /// <summary>
    /// Called by the layout system. Also see ILayoutElement
    /// </summary>
    public override void SetLayoutHorizontal()
    {
        SetChildrenAlongAxis(0, false);
    }

    /// <summary>
    /// Called by the layout system. Also see ILayoutElement
    /// </summary>
    public override void SetLayoutVertical()
    {
        SetChildrenAlongAxis(1, false);
    }
}
