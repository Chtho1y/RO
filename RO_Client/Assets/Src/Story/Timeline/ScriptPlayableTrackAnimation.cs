using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.UI;

// A behaviour that is attached to a playable
public class ScriptPlayableTrackAnimation : PlayableBehaviour
{
    public StoryMgr mgr;

    public int masterId;
    public StoryLocation location = StoryLocation.Left;
    public float startTime;
    public float endTime;
    public string animationName;

    bool isPlayed = false;

    public void Init(int masterId, StoryLocation location, string animationName, StoryMgr mgr)
    {
        this.mgr = mgr;
        this.masterId = masterId;
        this.location = location;
        this.animationName = animationName;
    }
    // Called when the owning graph starts playing
    public override void OnGraphStart(Playable playable)
    {
    }

    // Called when the owning graph stops playing
    public override void OnGraphStop(Playable playable)
    {
        //Debug.Log("OnGraphStop");
    }

    // Called when the state of the playable is set to Play
    public override void OnBehaviourPlay(Playable playable, FrameData info)
    {
        isPlayed = true;
        if (mgr)
        {

        }
        else
        {

        }
    }

    public override void OnBehaviourPause(Playable playable, FrameData info)
    {
        //Debug.Log("pause");
        if (isPlayed)
        {

        }
    }
}
