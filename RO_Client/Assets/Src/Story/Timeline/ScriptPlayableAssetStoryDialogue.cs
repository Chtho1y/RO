using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.UI;

public enum StoryLocation
{
    Left,
    Right,
}
[System.Serializable]
public class ScriptPlayableAssetStoryDialogue : PlayableAsset, IPlayableAssetDeal
{
    public int dlgId;
    public int startTime;
    public int endTime;

    public Text talkText;
    public Toggle toggleBtn;

    public StoryMgr mgr;

    bool isPlayed = false;
    bool isEnd = false;

    // Factory method that generates a playable based on this asset
    public override Playable CreatePlayable(PlayableGraph graph, GameObject go)
    {
        ScriptPlayableTrackStoryDialogue talkPlayable = new ScriptPlayableTrackStoryDialogue();
        talkPlayable.Init(talkText, toggleBtn, dlgId, mgr);

        return ScriptPlayable<ScriptPlayableTrackStoryDialogue>.Create(graph, talkPlayable);
    }

    public void DealWithSimpleMode(int time)
    {
        if (dlgId == 0)
            return;

        if (time >= startTime && time < endTime)
        {
            if (!isPlayed)
            {
                StoryMgr.Instance.PlayDialogueText(dlgId);
                isPlayed = true;
            }
        }
        else if (time >= endTime)
        {
            if (!isEnd)
            {
                isEnd = true;
                StoryMgr.Instance.DialogueEndPauseStatus();
            }
        }
    }
}
