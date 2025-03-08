using UnityEngine;
using System.Collections;

public class AudioAttach : MonoBehaviour
{
    public static bool ProxyMode = false;

    public string clipName;
    public string clipPackageName;
    public bool repeat = false;
    public float delayTime = 0f;
    public float minInterval = 0f;
    public float maxInterval = 0f;
    public int countLimit = 0;

    /// <summary>
    /// 是否Awake时就播放
    /// </summary>
    public bool playOnAwake = false;

    /// <summary>
    /// 脚本删除之后声音继续播放
    /// </summary>
    public bool continuePlayAfterDestroy = false;

    float timeFromEnable = 0f;
    float nextInterval = 0f;
    int playCount = 0;

    /// <summary>
    /// 请求播放的声音序列号
    /// </summary>
    private ulong mClipOrder = 0;

    void Awake()
    {
        if (string.IsNullOrEmpty(clipName))
        {
            enabled = false;
            return;
        }
        clipName = clipName.Trim();
        clipPackageName = clipPackageName.Trim();
        if (playOnAwake)
        {
            CheckSound();
        }
    }

    void OnEnable()
    {
        timeFromEnable = 0f;
        timeFromEnable = 0f;
        nextInterval = 0f;
        playCount = 0;
    }

    void OnDisable()
    {
        ReleaseSound();
    }

    bool MultiPlay
    {
        get
        {
            return maxInterval > 0f || minInterval > 0f;
        }
    }

    // Update is called once per frame
    void Update()
    {
        CheckSound();
    }

    void CheckSound()
    {
        if (string.IsNullOrEmpty(clipName))
            return;

        if (timeFromEnable < delayTime)
        {
            timeFromEnable += Time.unscaledDeltaTime;
            return;
        }

        if (!MultiPlay)
        {
            if (playCount > 0)
                return;
        }
        else
        {
            if (countLimit > 0 && playCount >= countLimit)
                return;
        }

        if (nextInterval <= 0f)
        {
            PlaySound();
            playCount++;

            if (minInterval < maxInterval)
                nextInterval = Random.Range(minInterval, maxInterval);
            else if (minInterval > 0)
                nextInterval = minInterval;
        }
        else
            nextInterval -= Time.unscaledDeltaTime;
    }

    void PlaySound()
    {
        mClipOrder = AudioProxy.Instance.Add(clipName, clipPackageName, repeat && !MultiPlay);
    }

    void OnDestroy()
    {
        ReleaseSound();
    }

    void ReleaseSound()
    {
        if (!continuePlayAfterDestroy)
        {
            AudioProxy.Instance.Cancel(clipName);
        }
    }
}
