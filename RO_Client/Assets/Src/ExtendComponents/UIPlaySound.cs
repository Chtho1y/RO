using UnityEngine;
using System.Collections;

public class UIPlaySound : MonoBehaviour
{
    public const string CommonClickSound = "UI_Click";

    public enum Trigger
    {
        OnClick,
        Custom,
        OnEnable,
        OnDisable,
    }

    public Trigger trigger = Trigger.OnClick;
    public string soundName = "";
    public float delayPlayTime = 0;


    private bool CanPlay
    {
        get
        {
            if (!enabled) return false;
            return true;
        }
    }

    private Coroutine mCor = null;
    void OnEnable()
    {
        if (trigger == Trigger.OnEnable)
            PlaySound();
    }

    void OnDisable()
    {
        if (trigger == Trigger.OnDisable)
            PlaySound();
    }

    void OnDestroy()
    {
        if (mCor != null)
        {
            StopCoroutine(mCor);
            mCor = null;
        }
    }

    public void OnClick()
    {
        PlaySound();
    }

    void PlaySound()
    {
        if (mCor != null)
        {
            StopCoroutine(mCor);
            mCor = null;
        }


        if (delayPlayTime <= 0)
        {
            PlayUISound();
        }
        else
        {
            mCor = StartCoroutine(DelayPlaySound());
        }
    }

    IEnumerator DelayPlaySound()
    {
        yield return new WaitForSeconds(delayPlayTime);

        PlayUISound();
    }

    void PlayUISound()
    {
        if (!string.IsNullOrEmpty(soundName))
        {
            MusicMgr.Instance.PlayUISound(soundName, false);
        }
        else
        {
            if(trigger == Trigger.OnClick)
                MusicMgr.Instance.PlayUISound(CommonClickSound, false);
        }
    }
}
