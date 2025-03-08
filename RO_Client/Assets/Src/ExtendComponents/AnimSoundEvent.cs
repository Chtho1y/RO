using UnityEngine;
using System.Collections;

public class AnimSoundEvent : MonoBehaviour
{
    public void PlaySound(string soundName)
    {
        if (string.IsNullOrEmpty(soundName)) return;

        MusicMgr.Instance.PlayFightSound(soundName);
    }
}
