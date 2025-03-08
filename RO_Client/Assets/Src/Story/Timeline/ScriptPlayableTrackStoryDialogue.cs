using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.UI;

// A behaviour that is attached to a playable
public class ScriptPlayableTrackStoryDialogue : PlayableBehaviour
{
    public StoryMgr mgr;

    public Text talkText;
    public Toggle toggleBtn;

    public int dlgId;

    private PlayableDirector director;

    bool isPlayed = false;

    public void Init(Text talkText, Toggle toggleBtn, int dlgId, StoryMgr mgr)
    {
        this.mgr = mgr;

        this.talkText = talkText;
        this.toggleBtn = toggleBtn;
        this.dlgId = dlgId;
    }
    // Called when the owning graph starts playing
    public override void OnGraphStart(Playable playable)
    {
        //Debug.Log("OnGraphStart");
        director = GameObject.FindObjectOfType<PlayableDirector>();
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
        //talkText.text = talkStr;
    }

    public override void OnBehaviourPause(Playable playable, FrameData info)
    {
        //Debug.Log("pause");
        if (isPlayed && !toggleBtn.isOn)
        {
            //Debug.Log("pause11111111111111111111111111111111111111111111111111111");
            director.Pause();
        }
    }
}
