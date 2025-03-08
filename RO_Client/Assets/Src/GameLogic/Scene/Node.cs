using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class Node : INode
{
    public Bounds bound { get; set; }

    private int id;
    private int depth;
    private Tree belongTree;
    private Node[] childList;
    private List<SceneObjData> objList;

    public List<SceneObjData> ObjList
    {
        get { return objList; }
    }

    public Node(Bounds bound, int depth, Tree belongTree)
    {
        this.id = Tree.nodeInstanceId++;
        this.belongTree = belongTree;
        this.bound = bound;
        this.depth = depth;
        objList = new List<SceneObjData>();
    }

    public void InsertObj(SceneObjData obj)
    {
        if (!obj.mbIsUsed)
            return;
        Node node = null;
        bool bChild = false;

        if (depth < belongTree.maxDepth && childList == null)
        {
            //如果还没到叶子节点，可以拥有儿子且儿子未创建，则创建儿子
            CerateChild();
        }
        if (childList != null)
        {
            for (int i = 0; i < childList.Length; ++i)
            {
                Node item = childList[i];
                if (item == null)
                {
                    break;
                }
                if (item.bound.Contains(obj.Center))
                {
                    if (node != null)
                    {
                        bChild = false;
                        break;
                    }
                    node = item;
                    bChild = true;
                }
            }
        }

        if (bChild)
        {
            //只有一个儿子可以包含该物体，则该物体
            node.InsertObj(obj);
        }
        else
        {
            objList.Add(obj);
        }
    }

    public void TriggerMove(Camera camera, BaseBattleScene scene)
    {
        for (int i = 0; i < objList.Count; ++i)
        {
            scene.SetSceneOjbVis(objList[i]);
        }

        //刷新子节点
        if (childList != null)
        {
            for (int i = 0; i < childList.Length; ++i)
            {
                if (childList[i].bound.CheckBoundIsInCamera(camera))
                {
                    childList[i].TriggerMove(camera,scene);
                }
                else
                {
                    childList[i].HideSceneObj();
                }
            }
        }
    }

    public void HideSceneObj()
    {
        for (int i = 0; i < objList.Count; ++i)
        {
            CommonUtil.SetGameObjectLayer(objList[i].gameObject, BattleCamera.hideLayer);
        }

        if (childList != null)
        {
            for (int i = 0; i < childList.Length; ++i)
            {
                childList[i].HideSceneObj();
            }
        }
    }

    private void CerateChild()
    {
        childList = new Node[belongTree.maxChildCount];
        int index = 0;
        for (int i = -1; i <= 1; i += 2)
        {
            for (int j = -1; j <= 1; j += 2)
            {
                Vector3 centerOffset = new Vector3(bound.size.x / 4 * i, 0, bound.size.z / 4 * j);
                Vector3 cSize = new Vector3(bound.size.x / 2, bound.size.y, bound.size.z / 2);
                Bounds cBound = new Bounds(bound.center + centerOffset, cSize);
                childList[index++] = new Node(cBound, depth + 1, belongTree);
            }
        }
    }

    public void DrawBound()
    {
        //if(this.depth == 0)
        //{
        //    Gizmos.color = Color.red;
        //}else if(this.depth == 1)
        //{
        //    Gizmos.color = Color.green;
        //}else if(this.depth == 2)
        //{
        //    Gizmos.color = Color.blue;
        //}
        //Gizmos.DrawWireCube(bound.center, bound.size - Vector3.one * 0.1f);

        if (childList != null)
        {
            for (int i = 0; i < childList.Length; ++i)
            {
                childList[i].DrawBound();
            }
        }

    }
}
