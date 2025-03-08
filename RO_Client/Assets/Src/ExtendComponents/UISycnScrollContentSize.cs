using UnityEngine;
using System.Collections;

public class UISycnScrollContentSize : MonoBehaviour
{
    public RectTransform content;
    public float maxHeight;

    float height;
    float width;

    private RectTransform rt;
    private RectTransform viewPoint;


    private float parentH = 0;
    // Use this for initialization
    void Start()
    {
        rt = GetComponent<RectTransform>();
        if (content != null && content.parent!=null)
            viewPoint = content.parent.GetComponent<RectTransform>();

        if(viewPoint!=null)
        {
            if(viewPoint.anchorMin == Vector2.zero && viewPoint.anchorMax == Vector2.one)
            {
                parentH = viewPoint.offsetMin.y - viewPoint.offsetMax.y;
            }
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (content == null || rt == null) return;

        float h = content.sizeDelta.y;
        if (height.FEqual(h, 0.1f))
            return;

        height = h + parentH;
        if (height >= maxHeight)
            height = maxHeight;

        Vector2 sizeDelta = rt.sizeDelta;
        sizeDelta.y = height;
        rt.sizeDelta = sizeDelta;
    }
}
