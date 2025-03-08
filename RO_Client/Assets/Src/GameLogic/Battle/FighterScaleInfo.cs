using UnityEngine;
using System.Collections;

public class FighterScaleInfo : MonoBehaviour {

    public float scaleValue;
    public float fadeInTime;
    public float continueTime;
    public float fadeOutTime;
    public bool unscaleTimeMode = true;

    float currentTime;
    bool hasSet;

    void Awake()
    {
        enabled = false;
    }

    void OnEnable()
    {
        transform.localScale = Vector3.one;
        currentTime = 0f;
        hasSet = false;
    }

    void OnDisable()
    {
        transform.localScale = Vector3.one;
    }

    void Update()
    {
        if (currentTime < fadeInTime)
            transform.localScale = Vector3.one * (1 + (scaleValue - 1) * currentTime / fadeInTime);
        else if (currentTime <= fadeInTime + continueTime)
        {
            if (!hasSet)
            {
                transform.localScale = Vector3.one * scaleValue;
                hasSet = true;
            }                
        }
        else if (currentTime <= fadeInTime + continueTime + fadeOutTime)
            transform.localScale = Vector3.one * (scaleValue + (1 - scaleValue) * (currentTime - (fadeInTime + continueTime)) / fadeOutTime);
        else
        {
            enabled = false;
            return;
        }

        currentTime += unscaleTimeMode ? Time.unscaledDeltaTime : Time.deltaTime;
    }
}
