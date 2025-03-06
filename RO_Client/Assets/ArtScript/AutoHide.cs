using UnityEngine;
using System.Collections;

public class AutoHide : MonoBehaviour
{

    public float delayTime = 1;

    float leftTime = 0;

    // Use this for initialization
    void Start()
    {
        leftTime = delayTime;
    }


    private void OnEnable()
    {
        leftTime = delayTime;
    }

    // Update is called once per frame
    void Update()
    {
        leftTime -= Time.unscaledDeltaTime;
        if(leftTime<=0)
        {
            this.gameObject.SetActive(false);
        }
    }
}
