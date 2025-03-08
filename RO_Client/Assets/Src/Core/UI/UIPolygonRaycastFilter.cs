using System;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;

[RequireComponent(typeof(Graphic))]
public class UIPolygonRaycastFilter : UIBehaviour, ICanvasRaycastFilter
{
    [SerializeField] private Vector2[] m_Points;

    [NonSerialized] private RectTransform m_RectTransform;

    public Vector2[] points
    {
        get { return m_Points; }
        set
        {
            if (m_Points != value)
            {
                m_Points = value;
            }
        }
    }

    /// <summary>
    /// The RectTransform component used by the Graphic. Cached for speed.
    /// </summary>
    public RectTransform rectTransform
    {
        get
        {
            // The RectTransform is a required component that must not be destroyed. Based on this assumption, a
            // null-reference check is sufficient.
            if (ReferenceEquals(m_RectTransform, null))
            {
                m_RectTransform = GetComponent<RectTransform>();
            }
            return m_RectTransform;
        }
    }

    public virtual bool IsRaycastLocationValid(Vector2 screenPoint, Camera eventCamera)
    {
        if (m_Points != null)
        {
            var rectTrans = rectTransform;
            Vector2 localPos;
            if (!RectTransformUtility.ScreenPointToLocalPointInRectangle(rectTrans, screenPoint, eventCamera, out localPos))
                return false;
            int iMax = m_Points.Length;
            if (iMax > 0 )
            {
                // ray-crossing算法 
                int crossNum = 0;
                for (int i = 0; i < iMax; i++)
                {
                    var point1 = m_Points[i];
                    var point2 = m_Points[(i + 1) % iMax];
                    // 如果目标点低于这个线段，跳过
                    if (localPos.y < point1.y && localPos.y < point2.y) continue;
                    // 如果目标点高于这个线段，跳过
                    if (localPos.y > point1.y && localPos.y > point2.y) continue;
                    // 只考虑点击点右侧方向，点击点水平线与线段相交，且交点x > 点击点x
                    var x = (localPos.y - point1.y) * (point2.x - point1.x) / (point2.y - point1.y) + point1.x;
                    if (x > localPos.x)
                    {
                        crossNum++;
                    }
                }
                // 奇数交点就在里面，偶数交点就在外面
                return (crossNum & 1) == 1;
            }
            else
            {
                return true;
            }
        }
        else
        {
            return true;
        }
    }
}
