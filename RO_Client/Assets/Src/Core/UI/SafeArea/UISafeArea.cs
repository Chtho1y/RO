using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class UISafeArea : UIControlArea
{
    [SerializeField]
    private bool m_LeftSafe = false;
    [SerializeField]
    private bool m_RightSafe = false;
    [SerializeField]
    private bool m_UpSafe = false;
    [SerializeField]
    private bool m_BottomSafe = false;

    public Transform[] autoHideTrans;

    protected override void CalcRect(Rect safeArea, ScreenOrientation orientation, int width, int height, out Vector2 min, out Vector2 max)
    {
        // 换算成u3d的屏幕坐标(左下角)
        float minX, minY, maxX, maxY;
        bool leftSafe, rightSafe, upSafe, bottomSafe;
        if (orientation == ScreenOrientation.PortraitUpsideDown)
        {
            leftSafe = m_RightSafe;
            rightSafe = m_LeftSafe;
            upSafe = m_BottomSafe;
            bottomSafe = m_UpSafe;
        }
        else if (orientation == ScreenOrientation.LandscapeLeft)
        {
            leftSafe = m_UpSafe;
            rightSafe = m_BottomSafe;
            upSafe = m_RightSafe;
            bottomSafe = m_LeftSafe;
        }
        else if (orientation == ScreenOrientation.LandscapeRight)
        {
            leftSafe = m_BottomSafe;
            rightSafe = m_UpSafe;
            upSafe = m_LeftSafe;
            bottomSafe = m_RightSafe;
        }
        else
        {
            leftSafe = m_LeftSafe;
            rightSafe = m_RightSafe;
            upSafe = m_UpSafe;
            bottomSafe = m_BottomSafe;
        }

        minX = (leftSafe ? safeArea.x : 0);
        minY = (bottomSafe ? safeArea.y : 0);
        maxX = (rightSafe ? (safeArea.x + safeArea.width) : width);
        maxY = (upSafe ? (safeArea.y + safeArea.height) : height);

        min = new Vector2(minX, minY);
        max = new Vector2(maxX, maxY);

        float deltaH = maxY - minY;

        if (autoHideTrans != null)
        {
            for (int idx = 0; idx < autoHideTrans.Length; idx++)
            {
                if (autoHideTrans[idx] != null)
                    autoHideTrans[idx].gameObject.SetActive(deltaH < Screen.height);
            }
        }
    }
}
