using UnityEngine;
using System.Collections;

public class Shake : MonoBehaviour {

    public delegate void OnShakeStopCallback(Shake shake);

    public Vector3 positionShake;
    public Vector3 angleShake;
    public float cycleTime = 0.2f;
    public int cycleCount = 6;
    public bool fixShake = false;
    public bool unscaleTime = false;
    public bool bothDir = true;
    public float fCycleCount = 0;
    public bool autoDisable = false;
    public OnShakeStopCallback onShakeStopCb = null;

    float currentTime;
    int curCycle;
    Vector3 curPositonShake;
    Vector3 curAngleShake;
    float curFovShake;
    Vector3 startPosition;
    Vector3 startAngles;
    Transform myTransform;

    void OnEnable()
    {
        Init(transform);
    }

    void OnDisable()
    {
        if (onShakeStopCb != null)
            onShakeStopCb(this);
        else
        {
            myTransform.localPosition = startPosition;
            myTransform.localEulerAngles = startAngles;
        }
    }
	
	// Update is called once per frame
	void Update () {

        float deltaTime = unscaleTime ? Time.unscaledDeltaTime : Time.deltaTime;
        UpdateFrame(deltaTime);
    }


    public void Init(Transform trans)
    {
        currentTime = 0f;
        curCycle = 0;
        curPositonShake = positionShake;
        curAngleShake = angleShake;
        myTransform = trans;
        startPosition = myTransform.localPosition;
        startAngles = myTransform.localEulerAngles;
        if (fCycleCount > 0)
            cycleCount = Mathf.RoundToInt(fCycleCount);
    }

    public void UpdateFrame(float deltaTime)
    {
#if UNITY_EDITOR
        if (fCycleCount > 0)
            cycleCount = Mathf.RoundToInt(fCycleCount);
#endif

        if (curCycle >= cycleCount)
        {
            if (autoDisable)
                enabled = false;
            return;
        }

        currentTime += deltaTime;
        while (currentTime >= cycleTime)
        {
            currentTime -= cycleTime;
            curCycle++;
            if (curCycle >= cycleCount)
            {
                myTransform.localPosition = startPosition;
                myTransform.localEulerAngles = startAngles;
                return;
            }

            if (!fixShake)
            {
                if (positionShake != Vector3.zero)
                    curPositonShake = (cycleCount - curCycle) * positionShake / cycleCount;
                if (angleShake != Vector3.zero)
                    curAngleShake = (cycleCount - curCycle) * angleShake / cycleCount;
            }
        }

        if (curCycle < cycleCount)
        {
            float offsetScale = Mathf.Sin((bothDir ? 2 : 1) * Mathf.PI * currentTime / cycleTime);
            if (positionShake != Vector3.zero)
                myTransform.localPosition = startPosition + curPositonShake * offsetScale;
            if (angleShake != Vector3.zero)
                myTransform.localEulerAngles = startAngles + curAngleShake * offsetScale;
        }
    }

    public void Restart()
    {
        if (enabled)
        {
            currentTime = 0f;
            curCycle = 0;
            curPositonShake = positionShake;
            curAngleShake = angleShake;
            myTransform.localPosition = startPosition;
            myTransform.localEulerAngles = startAngles;
            if (fCycleCount > 0)
                cycleCount = Mathf.RoundToInt(fCycleCount);
        }
        else
            enabled = true;
    }
}
