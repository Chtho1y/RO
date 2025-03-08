using UnityEngine;
using System.Collections;

public class RepeatBattleSoundInfo
{
    public string soundName;
    public float interval;
    public float continueTime;
    public float TimevalFromFirstPlay
    {
        get;
        set;
    }

    public float TimevalFromLastPlay
    {
        get;
        set;
    }

    public bool HasPlayed
    {
        get;
        set;
    }

    public RepeatBattleSoundInfo(string name, float continueTime, float interval)
    {
        this.soundName = name;
        this.continueTime = continueTime;
        this.interval = interval;
        HasPlayed = false;
        TimevalFromFirstPlay = 0f;
        TimevalFromLastPlay = 0f;
    }
}