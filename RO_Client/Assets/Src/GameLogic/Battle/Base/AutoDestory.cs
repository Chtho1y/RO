using System;
using System.Collections.Generic;
using UnityEngine;
public class AutoDestory : MonoBehaviour
{
    public float lifeTime = 1.5f;
    
    void Start()
    {
        Invoke("DestorySelf", lifeTime);
    }

    void DestorySelf()
    {
        gameObject.Destroy();
    }
}
