using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class TestMesh : MonoBehaviour
{
    MeshRenderer mr;


#if UNITY_EDITOR
    private void OnDrawGizmos()
    {
        if(mr == null)
            mr = GetComponent<MeshRenderer>();

        if(mr!=null)
            Gizmos.DrawWireCube(mr.bounds.center, mr.bounds.size);
    }
#endif
}
