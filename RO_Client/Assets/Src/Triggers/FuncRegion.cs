using UnityEngine;
using System;
using System.Collections;

public abstract class FuncRegion : MonoBehaviour
{
    [HideInInspector, NonSerialized]
    public bool isStartup = false;

    public virtual void UpdateLogic(float delta) { }
    public virtual void Startup() { isStartup = true; }
    public virtual void Stop() { isStartup = false; }
}
