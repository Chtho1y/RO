using UnityEngine;
using System.Collections;

[AddComponentMenu("Trigger/Trigger_Dialogue")]
public class AreaEventTriggerDialogue : AreaEventTrigger
{
    [FriendlyName("剧情对话组ID")]
    public int DialogueGroupId;
    [FriendlyName("离开时剧情对话组ID")]
    public int DialogueGroupIdLeaving;

    protected override void BuildTriggerWrapper()
    {
        PresetActWrapper = new TriggerActionWrapper(EGlobalTriggerAct.TriggerDialogue);
        PresetActWrapper.EnterUniqueId = DialogueGroupId;
        PresetActWrapper.Init(ID);
    }
}
