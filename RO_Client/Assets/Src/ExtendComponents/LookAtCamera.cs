using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LookAtCamera : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Camera.main == null) return;

        this.transform.rotation = GetLookRotation();
    }

    Quaternion GetLookRotation()
    {
        Vector3 lookDir = transform.position - Camera.main.transform.position;
        return Quaternion.LookRotation(lookDir, Camera.main.transform.up);
    }
}
