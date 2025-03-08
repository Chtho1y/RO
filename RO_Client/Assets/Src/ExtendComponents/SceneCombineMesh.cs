using UnityEngine;
using System.Collections.Generic;

public class SceneCombineMesh : MonoBehaviour
{
    MeshRenderer mSMR = null;
    MeshFilter mMeshFilter = null;

    void Awake()
    {
        mSMR = GetComponent<MeshRenderer>();
        if (mSMR != null)
            Object.Destroy(mSMR);

        if (mMeshFilter != null)
            Object.Destroy(mMeshFilter);

        CombineToMesh();
    }


    public void CombineToMesh()
    {
        List<CombineInstance> combineInstances = new List<CombineInstance>();
        MeshRenderer[] smrList = GetComponentsInChildren<MeshRenderer>();

        Material mat = null;
        for (int idx = 0; idx < smrList.Length; idx++)
        {
            MeshRenderer smr = smrList[idx];
            if (mat == null)
                mat = smr.material;

            MeshFilter mf = smr.GetComponent<MeshFilter>();
            CombineInstance ci = new CombineInstance();
            ci.mesh = mf.sharedMesh;
            ci.transform = mf.transform.localToWorldMatrix;
            combineInstances.Add(ci);
            
            Object.Destroy(smr.gameObject);
        }

        mSMR = gameObject.AddComponent<MeshRenderer>();
        mMeshFilter = gameObject.AddComponent<MeshFilter>();

        mMeshFilter.sharedMesh = new Mesh();
        mMeshFilter.sharedMesh.CombineMeshes(combineInstances.ToArray(), true);
        mSMR.materials = new Material[] { mat };
    }
}
