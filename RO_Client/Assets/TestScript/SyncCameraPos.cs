using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SyncCameraPos : MonoBehaviour
{
    public Transform actorTrans;
    public Vector3 offsetPos;

    void LateUpdate()
    {
        if(actorTrans != null)
        {
            this.transform.position = actorTrans.position + offsetPos;
        }
    }
}
