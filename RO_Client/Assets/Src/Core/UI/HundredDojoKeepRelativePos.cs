using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

[ExecuteInEditMode]
public class HundredDojoKeepRelativePos : UIBehaviour
{
    public RectTransform target;
    public RectTransform align;
    public RectTransform.Axis axis = RectTransform.Axis.Horizontal;

    protected override void OnEnable()
    {
        base.OnEnable();
        KeepPos();
    }

    protected override void OnRectTransformDimensionsChange()
    {
        base.OnRectTransformDimensionsChange();
        if (!IsActive()) return;
        KeepPos();
    }

    protected override void OnTransformParentChanged()
    {
        base.OnTransformParentChanged();
        if (!IsActive()) return;
        KeepPos();
    }

    private void KeepPos()
    {
        if (!target || !align)
        {
            enabled = false;
            return;
        }
        int offset = (int)axis;
        Vector3 pos = target.localPosition;
        Rect rect = align.rect;
        Vector3 pos1 = align.TransformPoint(rect.center);
        Transform parent = target.parent;
        if (parent)
        {
            pos1 = parent.InverseTransformPoint(pos1);
        }
        pos[offset] = pos1[offset];
        target.localPosition = pos;
    }
}
