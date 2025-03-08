using UnityEngine;
using System.Collections;

public class SoundManager : IManager
{
    protected override void addEventListener()
    {
    }
    protected override void removeEventListener()
    {

    }

    public SoundManager()
    {
    }
    public override void Update()
    {

    }
    public override void FixedUpdate()
    {

    }
    public override void Dispose()
    {
        removeEventListener();
    }
}
