using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;

[System.Serializable]
public class ScriptPlayableAssetMatSetParam : PlayableAsset
{
    public ExposedReference<Material> mat;
    public string paramName;
    public float paramNum;

    // Factory method that generates a playable based on this asset
    public override Playable CreatePlayable(PlayableGraph graph, GameObject go)
    {
        ScriptPlayableTrackMatSetParam matPlayable = new ScriptPlayableTrackMatSetParam();
        matPlayable.mat = mat.Resolve(graph.GetResolver());
        matPlayable.tarParamNum = paramNum;

        matPlayable.Init(paramName);
        return Playable.Create(graph);
    }
}
