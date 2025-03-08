using UnityEngine;
using System;
using System.Collections;

[System.Serializable]
public struct ActorTranSync
{
    public Vector3 LocalPosition;
    public Vector3 Position;
    public Vector3 Forward;
}

public class FighterSpawnPoint : MonoBehaviour
{
    public Color color = new Color(1, 0, 0);
    public float radius = 0.25f;
    public ActorTranSync TranSync = new ActorTranSync();

    void OnDrawGizmos()
    {
        Gizmos.color = color;
        Gizmos.DrawSphere(transform.position, radius);

#if UNITY_EDITOR
        TranSync.Position = transform.position;
        TranSync.Forward = transform.forward;
        TranSync.LocalPosition = transform.localPosition;
#endif
    }
}
