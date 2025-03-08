using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.UI;

[System.Serializable]
public class ScriptPlayableAssetAnimation : PlayableAsset, IPlayableAssetDeal
{
    public int masterId;
    public StoryLocation location = StoryLocation.Left;
    public Animator animator;
    public float startTime;
    public float endTime;
    public string animationName;

    public StoryMgr mgr;

    bool isPlayed = false;

    // Factory method that generates a playable based on this asset
    public override Playable CreatePlayable(PlayableGraph graph, GameObject go)
    {
        ScriptPlayableTrackAnimation animationPlayable = new ScriptPlayableTrackAnimation();
        animationPlayable.Init(masterId, location, animationName, mgr);

        return ScriptPlayable<ScriptPlayableTrackAnimation>.Create(graph, animationPlayable);
    }

    public void DealWithSimpleMode(int time)
    {
        if (animator == null)
            return;

        if (time >= startTime && time < endTime)
        {
            if (!isPlayed)
            {
                animator.Play(animationName);
                isPlayed = true;
            }      
        }
    }
}
