using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.UI;

[System.Serializable]
public class ScriptPlayableAssetAudio : PlayableAsset, IPlayableAssetDeal
{
    public string audioName;
    public string audioPath;
    public float startTime;
    public float endTime;

    public StoryMgr mgr;

    bool isPlayed = false;

    // Factory method that generates a playable based on this asset
    public override Playable CreatePlayable(PlayableGraph graph, GameObject go)
    {
        ScriptPlayableTrackAudio audioPlayable = new ScriptPlayableTrackAudio();
        audioPlayable.Init(audioName, mgr);

        return ScriptPlayable<ScriptPlayableTrackAudio>.Create(graph, audioPlayable);
    }

    public void DealWithSimpleMode(int time)
    {
        if (string.IsNullOrEmpty(audioName) || string.IsNullOrEmpty(audioPath))
            return;

        if (time >= startTime && time < endTime)
        {
            if (!isPlayed)
            {
                MusicMgr.Instance.PlaySound(audioPath, audioName);
                isPlayed = true;
            }
        }
    }
}
