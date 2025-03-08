using UnityEngine;
using System.Collections;

public class UIImageMoveDiffSpeed : MonoBehaviour
{
    public int percent = 5;

    float lastPosX;
    Vector3 oriPos;
    Vector3 deltaVec = Vector3.zero;
    Vector2 borderLimit;

    RectTransform rectTrans;
    private void Start()
    {
        
    }

    public void Init()
    {
        rectTrans = GetComponent<RectTransform>();
        oriPos = rectTrans.anchoredPosition;
    }

    public void UpdatePos(float process, Vector2 limit)
    {
        borderLimit = limit * percent * 0.01f;

        deltaVec.x = Mathf.Lerp(borderLimit.x, borderLimit.y, process);

        transform.localPosition = oriPos + deltaVec;
    }
}
