using UnityEngine;
using System.Collections;

public abstract class IManager
{
    protected abstract void addEventListener();
    protected abstract void removeEventListener();
    public abstract void Update();

    public abstract void FixedUpdate();

    public abstract void Dispose();
}
