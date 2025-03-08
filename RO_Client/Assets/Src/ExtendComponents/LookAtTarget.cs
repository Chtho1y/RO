using UnityEngine;
using System.Collections;

public class LookAtTarget : MonoBehaviour
{
    public Transform target;


    // Use this for initialization
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        if (target == null) return;

        

        this.transform.rotation = GetLookRotation();
    }

    Quaternion GetLookRotation()
    {
        Vector3 lookDir = target.position - transform.position;
        return Quaternion.LookRotation(lookDir, Vector3.up);
    }
}
