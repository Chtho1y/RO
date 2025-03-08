using UnityEngine;
using System.Collections;

public class AutoPlaySound : MonoBehaviour {

    public string soundName;

	void OnEnable()
    {
        MusicMgr.Instance.PlayFightSound(soundName);
    }
}
