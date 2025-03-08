using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

/// <summary>
/// 不进入UI的绘制队列，但是可以被点击
/// 可以用于扩大点击响应区域
/// </summary>
public class UIRaycastNoDraw : Graphic
{
    protected override void UpdateGeometry()
    {
        // 不填充任何顶点数据
    }
}
