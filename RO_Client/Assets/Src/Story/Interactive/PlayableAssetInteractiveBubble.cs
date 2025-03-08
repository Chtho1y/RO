using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.UI;

[System.Serializable]
public class PlayableAssetInteractiveBubble : PlayableAsset
{
    public ExposedReference<Transform> bubblePoint;
    public ExposedReference<Text> talkText;
    public string talkStr;

    // Factory method that generates a playable based on this asset
    public override Playable CreatePlayable(PlayableGraph graph, GameObject go)
    {
        PlayableBehaviourInteractiveBubble interactivePlayable = new PlayableBehaviourInteractiveBubble();
        interactivePlayable.Init(talkText.Resolve(graph.GetResolver()), bubblePoint.Resolve(graph.GetResolver()), talkStr);
        return ScriptPlayable<PlayableBehaviourInteractiveBubble>.Create(graph, interactivePlayable);
    }
}
