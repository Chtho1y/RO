using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Tree : INode
{
    public static int nodeInstanceId = 1;

    public Bounds bound { get; set; }
    private Node root;
    public int maxDepth { get; }
    public int maxChildCount { get; }

    public List<SceneObjData> ObjList { get { return root.ObjList; } }

    public Tree(Bounds bound)
    {
        this.bound = bound;
        this.maxDepth = 2;
        this.maxChildCount = 4;
        root = new Node(bound, 0, this);
    }

    public void InsertObj(SceneObjData obj)
    {
        root.InsertObj(obj);
    }

    public void TriggerMove(Camera camera,BaseBattleScene scene)
    {
        root.TriggerMove(camera,scene);
    }

    public void DrawBound()
    {
        root.DrawBound();
    }
}
