using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.UI;

// A behaviour that is attached to a playable
public class PlayableBehaviourInteractiveBubble : PlayableBehaviour
{
    public Transform bubblePoint;
    public Text talkText;

    public string talkStr;

    public void Init(Text talkText, Transform bubblePoint, string talkStr)
    {
        this.talkText = talkText;
        this.bubblePoint = bubblePoint;
        this.talkStr = talkStr;
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
        Vector3 pos1 = Camera.main.WorldToScreenPoint(bubblePoint.position);
        talkText.transform.parent.localPosition = Camera.main.ScreenToWorldPoint(pos1);

        //talkText.transform.parent.localPosition = CommonUtil.ConvertPosToUIPos(bubblePoint.position);
        talkText.text = talkStr;
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
