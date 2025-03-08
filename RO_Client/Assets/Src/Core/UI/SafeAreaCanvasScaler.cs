using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SafeAreaCanvasScaler : CanvasScaler
{
    public void ImmediatelyUpdate()
    {
        Handle();
    }
}
