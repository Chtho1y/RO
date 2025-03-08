using UnityEngine;
using System.Collections;

public class MoveFromToWithTransform : MonoBehaviour {

    public Transform from;
    public Transform to;
    public float speed = 4f;
    public bool lookAt = false;
    public Vector3 offset = Vector3.zero;
    public bool autoDestroy = true;

    void OnEnable()
    {
        if (from != null)
            transform.position = from.TransformPoint(offset);
        if (lookAt && to != null)
            transform.LookAt(to);
    }

    void Update()
    {
        if (to != null)
        {
            Vector3 targetPosition = to.TransformPoint(offset);
            transform.position = Vector3.MoveTowards(transform.position, targetPosition, Time.deltaTime * speed);
            if (autoDestroy && transform.position.FEqual(targetPosition, 1e-2f))
            {
                gameObject.Destroy();
                return;
            }
            else if (lookAt)
                transform.LookAt(to);
        }            
    }
}
