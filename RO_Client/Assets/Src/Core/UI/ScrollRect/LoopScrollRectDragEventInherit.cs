using UnityEngine;
using UnityEngine.UI;

public class LoopScrollRectDragEventInherit:MonoBehaviour
{
    public ScrollRect sr;

    public ScrollRect GetInheritScrollRect()
    {
        return sr;
    }
}