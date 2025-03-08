using UnityEngine;
using System.Collections;

public class ScrollContentMoveLimit : MonoBehaviour
{
    RectTransform rectTrans;
    public Vector2 limit;

    Vector3 pos = Vector3.zero;
    UIImageMoveDiffSpeed[] moveComs;

    // Use this for initialization
    void Start()
    {
        rectTrans = GetComponent<RectTransform>();
        pos = rectTrans.anchoredPosition;

        moveComs = transform.parent.GetComponentsInChildren<UIImageMoveDiffSpeed>();
        foreach(var com in moveComs)
        {
            com.Init();
        }
    }

    // Update is called once per frame
    void Update()
    {
        float x = rectTrans.anchoredPosition.x;

        x = Mathf.Clamp(x, limit.x, limit.y);
        pos.x = x;

        float process = (float)(pos.x - limit.x) / (limit.y - limit.x);

        foreach (var com in moveComs)
        {
            com.UpdatePos(process, limit);
        }

        rectTrans.anchoredPosition = pos;
    }
}
