//模拟凸多边形
//UGUI最小的单元是一个矩形  所以顶点数必须是4的倍数
//矩形模拟三角形最多组成凸多边形
using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using System.Collections.Generic;
public class CUIPolygon : Graphic 
{
    public Transform[] curTrnas;
    Vector3[] vertexs = null;

    protected override void Start()
    {
        this.transform.localPosition = Vector3.zero;
        base.Start();
    }


    public void InitVertexsCount(int num)
    {
        vertexs = new Vector3[6];
    }

    public void RefreshPolygonVertexs()
    {
        for (int i = 0; i < curTrnas.Length; ++i)
        {
            vertexs[i] = curTrnas[i].localPosition;
        }
        SetAllDirty();
    }

    protected override void OnPopulateMesh(VertexHelper vh)
    {
        if (vertexs == null || vertexs.Length < 3) return;

        int starsCount = vertexs.Length;
        Color32 color32 = this.color;

        vh.Clear();
        vh.AddVert(new Vector3(0, 0), color32, new Vector2(0f, 0f)); // 0  
        for(int idx = 0; idx < starsCount; idx++)
        {
            vh.AddVert(vertexs[idx], color32, new Vector2(0f, 0f)); // 1 
        }

        for (int idx =0; idx < starsCount; idx++)
        {
            int index2 = (idx + 2) > starsCount ? (idx + 2 - starsCount) : (idx + 2);
            vh.AddTriangle(0, idx+1, index2);
        }
    }
}
