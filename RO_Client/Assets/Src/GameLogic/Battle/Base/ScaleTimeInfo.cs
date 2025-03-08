using UnityEngine;
using System.Collections;

public class ScaleTimeInfo : Singleton<ScaleTimeInfo>
{
    private float scale;
    private float fadeinTime;
    private float continueTime;
    private float fadeoutTime;
    private bool canInterrupt;
    private float currentTime;
    private bool isEnabled;
    private float startTime;

    public bool Enable
    {
        get { return isEnabled; }
    }

    public float CurrentScale
    {
        get
        {
            if (isEnabled)
            {
                if (currentTime < fadeinTime)
                    return (1 + (scale - 1) * currentTime / fadeinTime);
                else if (currentTime <= fadeinTime + continueTime)
                {
                    return scale;
                }
                else if (currentTime < fadeinTime + continueTime + fadeoutTime)
                    return (scale + (1 - scale) * (currentTime - (fadeinTime + continueTime)) / fadeoutTime);
                else
                    return 1;
            }
            else
                return 1;
        }
    }

    public void Start(float scale, float continueTime, float fadeinSpeed, float fadeoutSpeed, bool canInterrupt)
    {
        if (isEnabled && !this.canInterrupt)
            return;
        this.scale = scale;
        this.continueTime = continueTime;
        fadeinTime = fadeinSpeed > 1e-5 ? 1 / fadeinSpeed : 0;
        fadeoutTime = fadeoutSpeed > 1e-5 ? 1 / fadeoutSpeed : 0;
        this.canInterrupt = canInterrupt;
        Time.timeScale = System.Math.Abs(fadeinTime) < Mathf.Epsilon ? scale : 1;
        currentTime = 0f;
        startTime = Time.unscaledTime;
        isEnabled = true;
    }

    public void Update(float deltaTime)
    {
        //if (isEnabled)
        //{
        //    currentTime = Mathf.Max(Time.unscaledTime - startTime, 0);
        //    if (currentTime < fadeinTime + continueTime + fadeoutTime)
        //        Time.timeScale = CurrentScale;
        //    else
        //        Stop();
        //}
    }

    public void Stop()
    {
        Time.timeScale = 1;
        isEnabled = false;
    }
}