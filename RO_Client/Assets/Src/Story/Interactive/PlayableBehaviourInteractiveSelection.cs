using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.UI;

// A behaviour that is attached to a playable
public class PlayableBehaviourInteractiveSelection : PlayableBehaviour
{
    public Text btnText;
    public string textStr;
    public int nextInteractiveSelectionId;

    public void Init(Text btnText, string textStr, int nextInteractiveSelectionId)
    {
        this.btnText = btnText;
        this.textStr = textStr;
        this.nextInteractiveSelectionId = nextInteractiveSelectionId;
    }

    // Called when the owning graph starts playing
    public override void OnGraphStart(Playable playable)
    {
        
    }

    // Called when the owning graph stops playing
    public override void OnGraphStop(Playable playable)
    {
        
    }

    // Called when the state of the playable is set to Play
    public override void OnBehaviourPlay(Playable playable, FrameData info)
    {
        btnText.text = textStr;
    }

    // Called when the state of the playable is set to Paused
    public override void OnBehaviourPause(Playable playable, FrameData info)
    {
        
    }

    // Called each frame while the state is set to Play
    public override void PrepareFrame(Playable playable, FrameData info)
    {
        
    }
}
