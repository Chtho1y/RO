using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.UI;

[System.Serializable]
public class ScriptPlayableAssetActivation : PlayableAsset, IPlayableAssetDeal
{
    public int masterId;
    public StoryLocation location = StoryLocation.Left;
    public GameObject master;
    public float startTime;
    public float endTime;

    public StoryMgr mgr;

    bool isPlayed = false;
    bool isEnd = false;

    // Factory method that generates a playable based on this asset
    public override Playable CreatePlayable(PlayableGraph graph, GameObject go)
    {
        ScriptPlayableTrackActivation activationPlayable = new ScriptPlayableTrackActivation();
        activationPlayable.Init(masterId, location, mgr);

        return ScriptPlayable<ScriptPlayableTrackActivation>.Create(graph, activationPlayable);
    }

    public void DealWithSimpleMode(int time)
    {
        if (master == null)
            return;

        if (time >= startTime && time < endTime)
        {
            if (!isPlayed)
            {
                isPlayed = true;
                StoryMgr.Instance.DisplaySrotyCM(master.transform, (StoryCMType)(location + 1));
            }
        }
        else if (time >= endTime)
        {
            if (!isEnd)
            {
                isEnd = true;
                StoryMgr.Instance.ResetSrotyCM(master.transform, (StoryCMType)(location + 1), StoryMgr.Instance.DefaultLayerName);
            }
        }
    }
}
