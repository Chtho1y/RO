using UnityEngine;
using System.Collections;

public class DelayShow : MonoBehaviour
{
    public float delayTime = 1.0f;

    public Transform[] Targets;

    float leftTime = 0;
    bool bShowed = false;
    // Use this for initialization
    void Start()
    {
        if(delayTime > 0)
        {
            if (Targets == null || Targets.Length == 0) return;

            for (int idx = 0; idx < Targets.Length; idx++)
            {
                if(Targets[idx] != null)
                {
                    Targets[idx].gameObject.SetActive(false);
                }
            }
        }
    }

    private void OnEnable()
    {
        bShowed = false;
        leftTime = delayTime;
    }

    private void OnDisable()
    {
        if (delayTime > 0)
        {
            if (Targets == null || Targets.Length == 0) return;

            for (int idx = 0; idx < Targets.Length; idx++)
            {
                if (Targets[idx] != null)
                {
                    Targets[idx].gameObject.SetActive(false);
                } 
            }
        }
    }

    private void Update()
    {
        if(!bShowed)
        {
            leftTime -= Time.unscaledDeltaTime;
            if (leftTime <= 0)
            {
                DelayFunc();
            }
        }
    }

    void DelayFunc()
    {
        if (Targets == null || Targets.Length == 0) return;

        for(int idx =0; idx < Targets.Length;idx++)
        {
            if (Targets[idx] != null)
            {
                Targets[idx].gameObject.SetActive(true);
            }    
        }
        bShowed = true;
    }
}
