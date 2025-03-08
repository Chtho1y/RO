using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;

// A behaviour that is attached to a playable
public class ScriptPlayableTrackMatSetParam : PlayableBehaviour
{
    public Material mat;
    public int paramNameId;
    public float tarParamNum;
    public float oriParamNum;

    public void Init(string name)
    {
        paramNameId = Shader.PropertyToID(name);
        oriParamNum = mat.GetFloat(paramNameId);
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
        mat.SetFloat(paramNameId, tarParamNum);
    }

    // Called when the state of the playable is set to Paused
    public override void OnBehaviourPause(Playable playable, FrameData info)
    {
        mat.SetFloat(paramNameId, oriParamNum);
    }

    // Called each frame while the state is set to Play
    public override void PrepareFrame(Playable playable, FrameData info)
    {
        
    }
}
