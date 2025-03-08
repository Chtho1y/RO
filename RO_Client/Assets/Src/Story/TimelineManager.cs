using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

public struct PlayableBindingStruct
{
    public string name;
    public PlayableBinding binding;
}

public struct PlayableClipStruct
{
    public string name;
    public PlayableAsset clip;
}

public class TimelineManager:SingletonMono<TimelineManager>
{
    public PlayableAsset curTimeline;

    private PlayableDirector m_playableDirector;

    public PlayableDirector MPlayableDirector
    {
        get { return m_playableDirector; }
    }

    private Dictionary<string, PlayableAsset> curSceneTimelineDic;
    private Dictionary<string, Dictionary<string, PlayableBinding>> bindingDic;
    private Dictionary<string, Dictionary<string, Dictionary<string, PlayableAsset>>> clipDic;

    private void Start()
    {
        InitMgr();
        //AddTimeline(curTimeline);
    }

    public override void InitMgr()
    {
        m_playableDirector = transform.GetOrAddComponent<PlayableDirector>();

        curSceneTimelineDic = new Dictionary<string, PlayableAsset>();
        bindingDic = new Dictionary<string, Dictionary<string, PlayableBinding>>();
        clipDic = new Dictionary<string, Dictionary<string, Dictionary<string, PlayableAsset>>>();
    }

    public void AddTimeline(PlayableAsset timeline)
    {
        if (m_playableDirector == null)
        {
            m_playableDirector = transform.GetOrAddComponent<PlayableDirector>();
        }

        if (curSceneTimelineDic == null)
        {
            curSceneTimelineDic = new Dictionary<string, PlayableAsset>();
        }

        if (bindingDic == null)
        {
            bindingDic = new Dictionary<string, Dictionary<string, PlayableBinding>>();
        }

        if (clipDic == null)
        {
            clipDic = new Dictionary<string, Dictionary<string, Dictionary<string, PlayableAsset>>>();
        }

        if (!curSceneTimelineDic.ContainsKey(timeline.name))
            curSceneTimelineDic.Add(timeline.name, timeline);

        if (!bindingDic.ContainsKey(timeline.name))
            bindingDic.Add(timeline.name, new Dictionary<string, PlayableBinding>());

        if (!clipDic.ContainsKey(timeline.name))
            clipDic.Add(timeline.name, new Dictionary<string, Dictionary<string, PlayableAsset>>());

        curTimeline = timeline;

        AssembleTimeline();
    }

    void AssembleTimeline()
    {
        m_playableDirector.playableAsset = curTimeline;

        Dictionary<string, PlayableBinding> bindings = bindingDic[curTimeline.name];
        Dictionary<string, Dictionary<string, PlayableAsset>> clips = clipDic[curTimeline.name];
        foreach (var o in curTimeline.outputs)
        {
            string trackName = o.streamName;
            if (!bindings.ContainsKey(trackName))
                bindings.Add(trackName, o);

            var trackAsset = o.sourceObject as TrackAsset;
            var clipList = trackAsset.GetClips();
            foreach (var c in clipList)
            {
                if (!clips.ContainsKey(trackName))
                {
                    clips[trackName] = new Dictionary<string, PlayableAsset>();
                }
                var map = clips[trackName];
                if (!map.ContainsKey(c.displayName))
                {
                    map.Add(c.displayName, c.asset as PlayableAsset);
                }
            }
        }
    }

    /// <summary>
    /// 设置轨道绑定的对象
    /// </summary>
    /// <param name="trackName">轨道名称</param>
    /// <param name="o">需要绑定的对象</param>
    public void SetBinding(string trackName, UnityEngine.Object o)
    {
        PlayableBinding binding = default(PlayableBinding);
        Dictionary<string, PlayableBinding> bindings = bindingDic[curTimeline.name];
        if (bindings.TryGetValue(trackName, out binding))
        {
            m_playableDirector.SetGenericBinding(binding.sourceObject, o);
        }
    }
    /// <summary>
    /// 根据指定的轨道名称，获取对应轨道绑定的对象
    /// </summary>
    /// <param name="trackName">轨道名称</param>
    /// <returns>返回绑定</returns>
    public UnityEngine.Object GetBinding(string trackName)
    {
        PlayableBinding binding = default(PlayableBinding);
        Dictionary<string, PlayableBinding> bindings = bindingDic[curTimeline.name];
        if (bindings.TryGetValue(trackName, out binding))
        {
            return m_playableDirector.GetGenericBinding(binding.sourceObject);
        }
        return null;
    }
    /// <summary>
    /// 根据指定的轨道名称，获取对象的轨道
    /// </summary>
    /// <param name="trackName">轨道名称</param>
    /// <returns>返回对应的轨道</returns>
    public PlayableBinding GetTrack(string trackName)
    {
        PlayableBinding ret = default(PlayableBinding);
        Dictionary<string, PlayableBinding> bindings = bindingDic[curTimeline.name];
        if (bindings.TryGetValue(trackName, out ret))
        {
            return ret;
        }
        return ret;
    }
    /// <summary>
    /// 根据指定的轨道名称、剪辑名称，获取对象的轨道上的剪辑
    /// </summary>
    /// <typeparam name="T">返回剪辑对象(PlayableAsset)</typeparam>
    /// <param name="trackName">轨道名称</param>
    /// <param name="clipName">剪辑名称</param>
    /// <returns>返回对应的剪辑</returns>
    public T GetClip<T>(string trackName, string clipName) where T : PlayableAsset
    {
        Dictionary<string, PlayableAsset> track = null;
        Dictionary<string, Dictionary<string, PlayableAsset>> clips = clipDic[curTimeline.name];
        if (clips.TryGetValue(trackName, out track))
        {
            PlayableAsset ret = null;
            if (track.TryGetValue(clipName, out ret))
            {
                return ret as T;
            }
            else
            {
                Debug.LogError($"GetClip trackName: {trackName} not found clipName: {clipName}");
            }
        }
        else
        {
            Debug.LogError($"GetClip not found trackName: {trackName}");
        }
        return null;
    }

    /// <summary>
    /// 播放
    /// </summary>
    public void Play()
    {
        m_playableDirector.Play();
    }
    /// <summary>
    /// 暂停
    /// </summary>
    public void Pause()
    {
        m_playableDirector.Pause();
    }
    /// <summary>
    /// 恢复
    /// </summary>
    public void Resume()
    {
        m_playableDirector.Resume();
    }
    /// <summary>
    /// 停止
    /// </summary>
    public void Stop()
    { 
        m_playableDirector.Stop();
    }
}