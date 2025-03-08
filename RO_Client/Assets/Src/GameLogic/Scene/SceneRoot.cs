using UnityEngine;
using System.Collections;

public class SceneRoot : MonoBehaviour
{
    public Bounds mainBound;

    private bool bInitEnd = false;
    public bool InitEnd { get { return bInitEnd; }set { bInitEnd = value; } }

    private Tree mTree;
    public Tree T
    {
        get { return mTree; }
        set { mTree = value; }
    }

#if UNITY_EDITOR
    private void OnDrawGizmos()
    {
        if (bInitEnd)
        {
            mTree.DrawBound();
        }
        else
        {
            Gizmos.DrawWireCube(mainBound.center, mainBound.size);
        }
    }
#endif
}
