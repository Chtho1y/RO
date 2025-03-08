using UnityEngine;
using System.Collections;

public class GameSettings : Singleton<GameSettings>
{
    public const int GraphicLevelLow = 0;
    public const int GraphicLevelMiddle = 1;
    public const int GraphicLevelHigh = 2;

    public const int ScreenType4_3 = 1;
    public const int ScreenType16_9 = 2;
    public const int ScreenTypeOther = 3;

    bool mbSettingChanged = false;
    bool mbLoaded = false;
    /// <summary>
    /// Graphic Quality Level, 2 is the best graphic quality.
    /// </summary>
    int mGraphicLevel = -1; //0 -- Low, 1 good, 2 the best.

    bool mbMusicMute = false;
    bool mbSoundMute = false;
    int mMusicVolume = 60;  //60%, ~= 0.6f
    int mSoundVolume = 60;

    public bool MusicMute
    {
        get { return mbMusicMute; }

        set
        {
            if (mbMusicMute != value)
            {

                mbMusicMute = value;
                mbSettingChanged = true;
            }
        }
    }

    public bool SoundMute
    {
        get { return mbSoundMute; }

        set
        {
            if (mbSoundMute != value)
            {
                mbSoundMute = value;
                mbSettingChanged = true;
            }
        }
    }

    public float MusicVolume
    {
        get { return mMusicVolume / 100f; }

        set
        {
            if (mMusicVolume != (int)(value * 100))
            {
                mMusicVolume = (int)(value * 100);
                mbSettingChanged = true;
            }
        }
    }

    public float SoundVolume
    {
        get { return mSoundVolume / 100f; }
        set
        {
            if (mSoundVolume != (int)(value * 100))
            {
                mSoundVolume = (int)(value * 100);
                mbSettingChanged = true;
            }
        }
    }

    /// <summary>
    /// Graphic Quality Level, 0 is the Low graphic quality, 2 is the best graphic quality.
    /// </summary>
    public int GraphicLevel
    {
        get { return mGraphicLevel; }

        set
        {
            if (mGraphicLevel != value && IsGraphicLevelValid(value))
            {
                mGraphicLevel = value;
                mbSettingChanged = true;

                if (mGraphicLevel == GraphicLevelLow)
                {
                    QualitySettings.SetQualityLevel(2, true);
                }
                else if (mGraphicLevel == GraphicLevelMiddle)
                {
                    QualitySettings.SetQualityLevel(3, true);
                }
                else if (mGraphicLevel == GraphicLevelHigh)
                {
                    QualitySettings.SetQualityLevel(4, true);
                }
                //DebugHelper.LogError("mGraphicLevel:"+ mGraphicLevel);
            }
        }
    }

    public override void Init()
    {
        base.Init();
        Load();
    }

    public void Load()
    {
        if (!mbLoaded)
        {
            int mute = PlayerPrefs.GetInt("musicMute", 0);
            mbMusicMute = mute == 1;

            mute = PlayerPrefs.GetInt("soundMute", 0);
            mbSoundMute = mute == 1;

            mMusicVolume = PlayerPrefs.GetInt("musicVolume", 60);
            mSoundVolume = PlayerPrefs.GetInt("soundVolume", 60);

            if (!PlayerPrefs.HasKey("graphicLevel"))
            {
                GraphicLevel = ((int)DeviceInfo.m_DeviceState - 1);
            }
            else
            {
                mute = PlayerPrefs.GetInt("graphicLevel", 0);
                GraphicLevel = mute;
            }

            mbLoaded = true;
            mbSettingChanged = false;
        }
    }

    public void Save()
    {
        if (mbSettingChanged)
        {

            try
            {
                PlayerPrefs.SetInt("musicMute", mbMusicMute ? 1 : 0);
                PlayerPrefs.SetInt("soundMute", mbSoundMute ? 1 : 0);
                PlayerPrefs.SetInt("musicVolume", mMusicVolume);
                PlayerPrefs.SetInt("soundVolume", mSoundVolume);
                PlayerPrefs.SetInt("graphicLevel", mGraphicLevel);
            }
            catch (System.Exception e)
            {
                DebugHelper.LogError("GameSettings: {0}", e.Message);
            }

            mbSettingChanged = false;
        }
    }

    bool IsGraphicLevelValid(int level)
    {
        if (SystemInfo.deviceType == DeviceType.Handheld)
        {

#if UNITY_IPHONE
			UnityEngine.iOS.DeviceGeneration iosGen = UnityEngine.iOS.Device.generation;
			if(level >= 2)
			{
				if (iosGen < UnityEngine.iOS.DeviceGeneration.iPhone6)
				{
					return false;
				}

			}
			else if(level == 1)
			{
				if (iosGen < UnityEngine.iOS.DeviceGeneration.iPhone5)
				{
					return false;
				}
			}
#elif UNITY_ANDROID
            /*if (DeviceInfo.m_DeviceState == DeviceInfo.eDeviceState.GOOD_DEVICE)
                return true;
            else if(DeviceInfo.m_DeviceState == DeviceInfo.eDeviceState.NORMAL_DEVICE)
            {
                return level < GraphicLevelHigh;
            }else
            {
                return level < GraphicLevelMiddle;
            }*/
#endif
        }
        return true;
    }
}
