using UnityEngine;
using System.Collections;

public class DontDestory : MonoBehaviour
{
    // Awake is called once per frame
    void Awake()
    {
        DontDestroyOnLoad(this.gameObject);
    }
}