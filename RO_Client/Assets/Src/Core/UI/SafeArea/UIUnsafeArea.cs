using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using Edge = UnityEngine.RectTransform.Edge;

public class UIUnsafeArea : UIControlArea
{
    [SerializeField]
    private Edge m_UnsafeEdge = Edge.Top;
    [SerializeField]
    private bool m_SafeSide1 = false;
    [SerializeField]
    private bool m_SafeSide2 = false;

    protected override void CalcRect(Rect safeArea, ScreenOrientation orientation, int width, int height, out Vector2 min, out Vector2 max)
    {
        // 换算成u3d的屏幕坐标(左下角)
        float minX, minY, maxX, maxY;

        if (m_UnsafeEdge == Edge.Bottom)
        {
            minX = (m_SafeSide2 ? safeArea.x : 0);
            minY = 0;
            maxX = (m_SafeSide1 ? (safeArea.x + safeArea.width) : width);
            maxY = safeArea.y;
        }
        else if (m_UnsafeEdge == Edge.Left)
        {
            minX = 0;
            minY = (m_SafeSide1 ? safeArea.y : 0);
            maxX = safeArea.x;
            maxY = (m_SafeSide2 ? (safeArea.y + safeArea.height) : height);
        }
        else if (m_UnsafeEdge == Edge.Right)
        {
            minX = (safeArea.x + safeArea.width);
            minY = (m_SafeSide2 ? safeArea.y : 0);
            maxX = width;
            maxY = (m_SafeSide1 ? (safeArea.y + safeArea.height) : height);
        }
        else
        {
            minX = (m_SafeSide1 ? safeArea.x : 0);
            minY = safeArea.y + safeArea.height;
            maxX = (m_SafeSide2 ? (safeArea.x + safeArea.width) : width);
            maxY = height;
        }

        min = new Vector2(minX, minY);
        max = new Vector2(maxX, maxY);
    }
}
