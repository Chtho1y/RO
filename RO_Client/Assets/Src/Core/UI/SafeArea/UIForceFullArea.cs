using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIForceFullArea : UIControlArea
{
    protected override void CalcRect(Rect safeArea, ScreenOrientation orientation, int width, int height, out Vector2 min, out Vector2 max)
    {
        min = new Vector2(0, 0);
        max = new Vector2(width, height); 
    }
}
