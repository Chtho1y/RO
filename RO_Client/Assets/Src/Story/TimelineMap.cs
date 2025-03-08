using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[System.Serializable]
public struct PlayableBindingDic
{
    public string trackName;
    public string typeName;
    public string objInfo;
}

[System.Serializable]
public struct PlayableClipDic
{
    public string trackName;
    public List<string> clipNames;
    public List<string> objInfos;
}

public class TimelineMap : MonoBehaviour
{
    public PlayableDirector director;
    public PlayableAsset asset;

    public List<PlayableBindingDic> bindingDic;

    public List<PlayableClipDic> clipDic;

    public void Start()
    {
        SaveMap();
    }

    PlayableClipDic ClipsContainsKey(string name)
    {
        foreach(var c in clipDic)
        {
            if (c.trackName.CompareTo(name) == 0)
            {
                return c;
            }
        }
        return default(PlayableClipDic);
    }

    public void SaveMap()
    {
        if (director == null)
        {
            Debug.Log("please import director object !!!");
            return;
        }

        if (asset == null)
        {
            Debug.Log("please import timeline object !!!");
            return;
        }

        bindingDic = new List<PlayableBindingDic>();
        clipDic = new List<PlayableClipDic>();

        foreach (var o in asset.outputs) // 每一个binding，其实就是trackasset和需要动画的模型之间的链接关系
        {
            var trackName = o.streamName;

            PlayableBindingDic binding = new PlayableBindingDic();
            binding.trackName = trackName;
            Object obj = director.GetGenericBinding(o.sourceObject);
            if (obj != null)
            {
                binding.typeName = obj.GetType().FullName;
                binding.objInfo = obj.name;
                if (!string.IsNullOrEmpty(binding.objInfo))
                    bindingDic.Add(binding);
            }

            var trackAsset = o.sourceObject as TrackAsset;
            var clipList = trackAsset.GetClips();
            foreach (var c in clipList)
            {
                /*if (!c.displayName.Contains("Script"))
                {
                    continue;
                }*/

                PlayableClipDic clip = ClipsContainsKey(trackName);
                if (string.IsNullOrEmpty(clip.trackName))
                {
                    clip.trackName = trackName;
                    clip.clipNames = new List<string>();
                    clip.objInfos = new List<string>();
                }
                if (!clip.clipNames.Contains(c.displayName))
                {
                    clip.clipNames.Add(c.displayName);

                    Object asset = c.asset;
                    clip.objInfos.Add(asset.name);
                }

                if (!clipDic.Contains(clip))
                    clipDic.Add(clip);
            }
        }
    }

    public void Output()
    {
        foreach(var binding in bindingDic)
        {
            Debug.Log(binding.trackName);
            //Debug.Log(binding.bingdingObj);
        }
    }
}
