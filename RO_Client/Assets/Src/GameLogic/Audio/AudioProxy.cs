using UnityEngine;
using System.Collections;
using System.Collections.Generic;


public class AudioItem
{
    /// <summary>
    /// 请求播放的序号
    /// </summary>
    private ulong mReqOrder;
    /// <summary>
    /// 请求播放的声音名字
    /// </summary>
    public string clipName;
    /// <summary>
    /// 请求播放的声音所在的报名
    /// </summary>
    public string clipPackageName;
    public bool repeat;

    public ulong ReqOrder
    {
        get {
            return mReqOrder;
        }
    }

    public AudioItem(string clipName, string packageName, bool repeat)
    {
        mReqOrder = AudioProxy.s_AudioAttackOrder++;
        this.clipName = clipName;
        this.clipPackageName = packageName;
        this.repeat = repeat;
    }
}

public class AudioProxy
{

    public static ulong s_AudioAttackOrder = 1;

    static AudioProxy instance;

    public static AudioProxy Instance
    {
        get
        {
            if (instance == null)
                instance = new AudioProxy();
            return instance;
        }
    }

    AudioProxy() { }

    public List<AudioItem> audioClips = new List<AudioItem>(20);
    public List<string> cancelClips = new List<string>(20);

    public ulong Add(string clipName, string clipPackageName, bool repeat)
    {
        AudioItem item = new AudioItem(clipName, clipPackageName, repeat);
        audioClips.Add(item);
        return item.ReqOrder;
    }

    public void Cancel(string clipName)
    {
        cancelClips.Add(clipName);
    }
}
