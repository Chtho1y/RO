using UnityEngine;
using System.Collections;

public enum SceneObjStatus
{
    Old,//这次刷新没有加载
    New,//这次刷新加载
}

public class SceneObjData : MonoBehaviour
{
    public bool mbIsUsed = true;//是否啓用 特效暫時獲取不到bounds 先啓用關閉

    private Bounds mBounds;

    public Vector3 Center
    {
        get { return mBounds.center; }
    }


    private SceneObjStatus mStatus;
    public SceneObjStatus Status
    {
        get { return mStatus; }
        set { mStatus = value; }
    }

    private void Awake()
    {
        MeshRenderer render = GetComponent<MeshRenderer>();
        if (render != null)
        {
            mBounds = render.bounds;
        }
    }


#if UNITY_EDITOR
    MeshRenderer mr = null;
    private void OnDrawGizmos()
    {
       if(mr == null)
        {
            mr = GetComponent<MeshRenderer>();
        }

       if(mr)
        {
            Gizmos.DrawWireCube(mr.bounds.center, mr.bounds.size);
        }
    }
#endif
}
