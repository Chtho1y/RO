using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.UI;

[System.Serializable]
public class PlayableAssetInteractiveSelection : PlayableAsset
{
    public ExposedReference<Text> selectionText;
    public string textStr;
    public int nextInteractiveSelectionId;

    // Factory method that generates a playable based on this asset
    public override Playable CreatePlayable(PlayableGraph graph, GameObject go)
    {
        PlayableBehaviourInteractiveSelection selectionPlayable = new PlayableBehaviourInteractiveSelection();
        selectionPlayable.Init(selectionText.Resolve(graph.GetResolver()), textStr, nextInteractiveSelectionId);

        return ScriptPlayable<PlayableBehaviourInteractiveSelection>.Create(graph, selectionPlayable, nextInteractiveSelectionId);
    }
}
