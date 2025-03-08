using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MusicMgr : SingletonMono<MusicMgr> {
    public static string music_battle_default = "";
    public static string music_main_city = "";
    public static string music_battle = "";

    private AudioListener m_currentListener = null;
    private GameObject mBgMusic = null;
    private GameObject mSound = null;

    private HashSet<string> mNoClearSoundNameSet = new HashSet<string> ();
    /// <summary>
    /// 跳场景不清除的声音
    /// </summary>
    private List<AudioSource> mNoClearSoundList = new List<AudioSource> ();
    private List<AudioSource> mSoundList = new List<AudioSource> ();

    private Dictionary<string, AudioSource> mMusicList = new Dictionary<string, AudioSource> ();

    private Dictionary<string, AudioClip> mAudioClipList = new Dictionary<string, AudioClip> ();
    private Dictionary<string, AudioClip> mMusicClipList = new Dictionary<string, AudioClip> ();

    private Dictionary<string, bool> mLoadingAudioLoopInfo = new Dictionary<string, bool> ();

    HashSet<string> mLatestPlaySoundSet = new HashSet<string> ();
    Dictionary<string,bool> mLoadingFightSounds = new Dictionary<string, bool> ();

    private float mSoundVolume = 1f;
    private float mMusicVolume = 0.6f;
    private float m_UpdateCD = 0f;

    private bool mIsPlaySoundEffect = true;
    private bool mIsPlayBgMusic = true;
    private bool mInternalMuteMusic = true;

    private string mCurrentMusicName = "";
    private string mPreviousMusicName = "";

    private bool mLoading = false;

    public AudioListener Listener {
        get {
            return m_currentListener;
        }
    }

    public bool MuteMusic {
        get { return !mIsPlayBgMusic; }
        set {
            value = !value;
            if (mIsPlayBgMusic != value) {
                mIsPlayBgMusic = value;
                ExcuteMuteMusic();
                GameSettings.Instance.MusicMute = !value;
            }
        }
    }

    public bool InternalMuteMusic {
        get { return mInternalMuteMusic; }
        set {
            if (mInternalMuteMusic == value) return;
            mInternalMuteMusic = value;
            ExcuteMuteMusic();
        }
    }

    private void ExcuteMuteMusic()
    {
        Dictionary<string, AudioSource>.Enumerator iter = mMusicList.GetEnumerator ();
        while (iter.MoveNext ()) {
            iter.Current.Value.mute = (MuteMusic || InternalMuteMusic);
        }
        iter.Dispose ();
    }

    public bool MuteSound {
        get { return !mIsPlaySoundEffect; }
        set {
            value = !value;
            if (mIsPlaySoundEffect != value) {
                mIsPlaySoundEffect = value;

                List<AudioSource>.Enumerator iter = mSoundList.GetEnumerator ();
                while (iter.MoveNext ()) {
                    iter.Current.mute = (!mIsPlaySoundEffect);
                }
                iter.Dispose ();

                iter = mNoClearSoundList.GetEnumerator ();
                while (iter.MoveNext ()) {
                    iter.Current.mute = (!mIsPlaySoundEffect);
                }
                iter.Dispose ();

                GameSettings.Instance.SoundMute = !value;
            }
        }
    }

    public float SoundVolume {
        get {
            return mSoundVolume;
        }
        set {
            if (mSoundVolume != value) {
                mSoundVolume = Mathf.Clamp01 (value); // Mathf.Max(Mathf.Min(value, 1.0f), 0);
                List<AudioSource>.Enumerator iter = mSoundList.GetEnumerator ();
                while (iter.MoveNext ()) {
                    iter.Current.volume = mSoundVolume;
                    iter.Current.mute = mSoundVolume < 0.01f;
                }

                iter = mNoClearSoundList.GetEnumerator ();
                while (iter.MoveNext ()) {
                    iter.Current.volume = mSoundVolume;
                    iter.Current.mute = mSoundVolume < 0.01f;
                }

                GameSettings.Instance.SoundVolume = mSoundVolume;
            }
        }
    }

    public float MusicVolume {
        get {
            return mMusicVolume;
        }
        set {
            if (mMusicVolume != value) {
                mMusicVolume = Mathf.Clamp01 (value); // Mathf.Max(Mathf.Min(value, 1.0f), 0);
                Dictionary<string, AudioSource>.Enumerator iter = mMusicList.GetEnumerator ();
                while (iter.MoveNext ()) {
                    iter.Current.Value.volume = mMusicVolume;
                    iter.Current.Value.mute = mMusicVolume < 0.01f;
                }

                GameSettings.Instance.MusicVolume = mMusicVolume;
            }
        }
    }

    public string CurrentMusicName {
        get { return mCurrentMusicName; }
    }

    public override void InitMgr () {
        base.InitMgr ();
        Init ();
    }

    protected override void Dispose () {
        base.Dispose ();
        Clean ();
        SaveSetting ();
    }

    void Init () {
        GameObject bg_music = new GameObject ();
        bg_music.name = "MusicMgr_BgMusic";
        bg_music.transform.SetParent (this.transform);
        mBgMusic = bg_music;

        GameObject sound = new GameObject ();
        sound.name = "MusicMgr_Sound";
        sound.transform.SetParent (this.transform);
        mSound = sound;

        AudioListener listener = UnityEngineUtils.GetComponent<AudioListener> (this, true);
        if (listener != null)
            m_currentListener = listener;

        AudioListener.volume = 1.0f;

        AudioAttach.ProxyMode = true;

        mIsPlayBgMusic = !GameSettings.Instance.MusicMute;
        mIsPlaySoundEffect = !GameSettings.Instance.SoundMute;
        mSoundVolume = GameSettings.Instance.SoundVolume;
        mMusicVolume = GameSettings.Instance.MusicVolume;
    }

    public long PreloadFightSound (string[] sounds) {
        //数据不存在，直接返回
        if (sounds == null || sounds.Length == 0)
            return 0;

        List<string> needLoadAssets = new List<string> ();
        for (int i = 0; i < sounds.Length; ++i) {
            if (string.IsNullOrEmpty (sounds[i]))
                continue;

            if (mAudioClipList.ContainsKey (sounds[i]))
                continue;

            if (mLoadingFightSounds.ContainsKey (sounds[i]))
                continue;

            if (sounds[i] == "none")
                continue;

            mLoadingFightSounds.Add (sounds[i],false);
            needLoadAssets.Add (sounds[i]);
        }

        if (needLoadAssets.Count > 0) {
            return ResourceMgr.Instance.LoadAsset<List<AudioClip>> (OnSoundPreLoaded, Constants.FightAudioPath, needLoadAssets.ToArray ());
        }

        return 0;

    }

    public void PreloadUISound (string[] resAssets) {
        List<string> needLoadAssets = new List<string> ();
        for (int i = 0; i < resAssets.Length; ++i) {
            if (mAudioClipList.ContainsKey (resAssets[i])) continue;

            needLoadAssets.Add (resAssets[i]);
        }

        if (needLoadAssets.Count > 0) {
            ResourceMgr.Instance.LoadAsset<List<AudioClip>> (OnSoundPreLoaded, Constants.UIAudioPath, needLoadAssets.ToArray ());
        }
    }

    public void PlayFightSound (string soundName, bool repeat = false) {
        PlaySound (Constants.FightAudioPath, soundName, repeat);
    }

    public void PlayUISound (string name, bool removeall) {
        PlayUISound (name, removeall, false);
    }

    public void PlayUISound (string name, bool removeall, bool noclear) {
        if (string.IsNullOrEmpty (name)) return;

        if (noclear && !mNoClearSoundNameSet.Contains (name))
            mNoClearSoundNameSet.Add (name);

        AudioClip clip = null;
        if (mAudioClipList.TryGetValue (name, out clip)) {
            PlaySound (clip, removeall, false, noclear);
            return;
        }

        //! should check ui-sound...
        ResourceMgr.Instance.LoadAsset<AudioClip> (OnSoundLoaded, Constants.UIAudioPath, name);
    }

    public void PlaySound (string path, string audioName,bool repeat = false) {
        if (string.IsNullOrEmpty (audioName) || string.Compare (audioName, "none", true) == 0)
            return;

        if (mLatestPlaySoundSet.Contains (audioName))
            return;

        mLatestPlaySoundSet.Add (audioName);

        AudioClip clip = null;
        if (mAudioClipList.TryGetValue (audioName, out clip)) {
            PlaySound (clip, false, repeat);
            return;
        }

        if (mLoadingFightSounds.ContainsKey (audioName))
            return;

        mLoadingFightSounds.Add (audioName, repeat);
        ResourceMgr.Instance.LoadAsset<AudioClip> (OnSoundLoaded, path, audioName);
    }

    public void PlayBGMusic (string bgmName) {
        PlayBGMusicWithLoop (bgmName, true);
    }

    //同时只能有一个背景音乐播放
    Coroutine mCurrMusicPlayer = null;
    private bool mbFadeInning = false;

    //
    public void PlayBGMusicWithLoop (string resName, bool isLoop) {
        if (mBgMusic == null || string.IsNullOrEmpty (resName) || resName.ToLower () == "none") return;

        //! Already Playing...
        if (mMusicList.ContainsKey (resName)) return;

        mPreviousMusicName = mCurrentMusicName;
        mCurrentMusicName = resName;

        AudioClip clip = null;
        if (mMusicClipList.TryGetValue (resName, out clip)) {
            if (mCurrMusicPlayer != null) {
                StopCoroutine (mCurrMusicPlayer);
                mCurrMusicPlayer = null;
            }
            mCurrMusicPlayer = StartCoroutine (PlayMusicCallBack (clip, isLoop));
            return;
        }

        if (!mLoadingAudioLoopInfo.ContainsKey (resName)) {
            mLoadingAudioLoopInfo.Add (resName, isLoop);
            ResourceMgr.Instance.LoadAsset<AudioClip> (OnMusicLoaded, Constants.BGMAudioPath, resName);
        }
    }

    private IEnumerator PlayMusicCallBack (AudioClip clip, bool isLoop = true) {
        if (clip != null) {
            AudioSource audioSrc = null;

            Coroutine stopCor = null;
            Dictionary<string, AudioSource>.Enumerator iter = mMusicList.GetEnumerator ();
            while (iter.MoveNext ()) {
                audioSrc = iter.Current.Value;
                stopCor = StartCoroutine (StopMusic (audioSrc, true, 0.5f));
            }

            iter.Dispose ();

            mMusicList.Clear ();

            yield return stopCor;
            stopCor = null;
            yield return 1; //wait for one frame...

            audioSrc = mBgMusic.GetComponent<AudioSource> ();
            while (audioSrc != null) {
                yield return 1;

                audioSrc = mBgMusic.GetComponent<AudioSource> ();
            }

            audioSrc = mBgMusic.AddComponent<AudioSource> ();

            if (audioSrc != null) {
                audioSrc.playOnAwake = false;
                audioSrc.clip = clip;
                audioSrc.loop = isLoop;
                audioSrc.volume = mMusicVolume;
                audioSrc.mute = MuteMusic;
                StartCoroutine (FadeInPlay (1.2f, audioSrc));
            }

            mMusicList.Add (clip.name, audioSrc);
        }

        yield return 1;

        mCurrMusicPlayer = null;
    }

    IEnumerator StopMusic (AudioSource arc, bool isFadeOut, float fFadeOutTime) {
        if (arc != null) {
            yield return StartCoroutine (FadeOutDelete (fFadeOutTime, arc));

            //删除上一个播放的背景音乐
            if (mPreviousMusicName != "") {
                AudioClip clip;
                if (mMusicClipList.TryGetValue (mPreviousMusicName, out clip)) {
                    if (clip != null)
                        clip.UnloadAudioData ();
                    mMusicClipList.Remove (mPreviousMusicName);
                }
            }
        }
    }

    IEnumerator FadeOutDelete (float fTime, AudioSource arc) {
        TweenVolume tween = TweenVolume.Begin (mBgMusic, fTime, 0f);

        //! wait TweenVoLume to end.
        if (tween) {
            while (tween.enabled)
                yield return 1;
        }

        if (arc != null) {
            arc.Stop ();

            if (tween) {
                tween.Destroy ();
                yield return 1;
            }

            arc.Destroy ();
        }
    }

    IEnumerator FadeInPlay (float fTime, AudioSource arc) {
        if (arc != null) {
            arc.volume = 0.01f;
            arc.Play ();
            mbFadeInning = true;
            TweenVolume tv = TweenVolume.Begin (mBgMusic, fTime, mMusicVolume);
            //! wait TweenVoLume to end.
            if (tv) {
                while (tv.enabled)
                    yield return 1;
            }
            mbFadeInning = false;
        }
    }

    public void PlaySound (AudioClip clip, bool removeall = false, bool repeat = false, bool noclear = false) {
        if (clip != null) {
            if (removeall) {
                RemoveAllSound ();
            }

            AudioSource audioSrc = mSound.AddComponent<AudioSource> ();
            audioSrc.playOnAwake = false;
            audioSrc.clip = clip;
            audioSrc.loop = repeat;
            audioSrc.volume = mSoundVolume;
            audioSrc.mute = MuteSound;
            audioSrc.rolloffMode = AudioRolloffMode.Linear;
            audioSrc.Play ();
            if (noclear)
                mNoClearSoundList.Add (audioSrc);
            else
                mSoundList.Add (audioSrc);
        }
    }

    public void RemoveAllSound () {
        for (int i = mSoundList.Count - 1; i >= 0; --i) {
            AudioSource Aus = mSoundList[i];
            if (Aus != null) {
                Aus.Destroy ();
            }
        }
        mSoundList.Clear ();
    }

    public void Update () {
        if (m_UpdateCD + 1f < Time.realtimeSinceStartup) {
            m_UpdateCD = Time.realtimeSinceStartup;

            for (int i = mSoundList.Count - 1; i >= 0; --i) {
                if (mSoundList[i] == null || !mSoundList[i].isPlaying) {
                    mAudioClipList.Remove (mSoundList[i].name);
                    mSoundList[i].Destroy ();
                    mSoundList.RemoveAt (i);
                }
            }

            for (int i = mNoClearSoundList.Count - 1; i >= 0; --i) {
                AudioSource asource = mNoClearSoundList[i];
                if (asource == null || !asource.isPlaying) {
                    if (asource != null) {
                        mAudioClipList.Remove (asource.name);
                        asource.Destroy ();
                    }
                    mNoClearSoundList.RemoveAt (i);
                }
            }
        }
    }

    void FixedUpdate () {
        mLatestPlaySoundSet.Clear ();
    }

    public void RemoveSound (string name) {
        for (int idx = 0; idx < mSoundList.Count; idx++) {
            AudioSource a = mSoundList[idx];
            if (a.clip.name == name) {
                mSoundList.Remove (a);
                a.Destroy ();
                return;
            }
        }

        for (int idx = 0; idx < mNoClearSoundList.Count; idx++) {
            AudioSource a = mNoClearSoundList[idx];
            if (a.clip.name == name) {
                mNoClearSoundList.Remove (a);
                a.Destroy ();
                return;
            }
        }
    }

    public void SaveSetting () {
        GameSettings.Instance.Save ();
    }

    public void Clean () {
        if (mAudioClipList != null)
            mAudioClipList.Clear ();

        if (mMusicClipList != null)
            mMusicClipList.Clear ();
    }

    public void StopAllMusic () {
        if (mBgMusic != null) {
            TweenVolume twv = mBgMusic.GetComponent<TweenVolume> ();
            if (twv) Destroy (twv);
        }

        AudioSource audioSrc = null;

        Dictionary<string, AudioSource>.Enumerator iter = mMusicList.GetEnumerator ();
        while (iter.MoveNext ()) {
            audioSrc = iter.Current.Value;
            audioSrc.volume = 0f;
            StartCoroutine (StopMusic (audioSrc, false, 0.0f));
        }
        iter.Dispose ();
        mMusicList.Clear ();
    }

    /// <summary>
    //跳转场景时清理声音
    /// </summary>

    public void CleanBeforeChangeScene () {
        CleanFightSound ();

        CleanBGMusic ();
    }

    Stack<string> removeDict = new Stack<string> ();

    public void CleanFightSound () {
        AudioProxy.Instance.audioClips.Clear ();
        AudioProxy.Instance.cancelClips.Clear ();

        //删除战斗和UI声音
        for (int idx = 0; idx < mSoundList.Count; idx++) {
            GameObject.DestroyObject (mSoundList[idx]);
        }
        mSoundList.Clear ();

        foreach (var audioCP in mAudioClipList) {
            AudioClip clip = audioCP.Value;
            if (CanClear (clip)) {
                clip.UnloadAudioData ();
                removeDict.Push (audioCP.Key);
            }
        }

        while (removeDict.Count > 0) {
            mAudioClipList.Remove (removeDict.Pop ());
        }
    }

    /// <summary>
    /// 清理背景音乐
    /// </summary>

    public void CleanBGMusic () {
        AudioClip curClip = null;
        foreach (var musicCP in mMusicClipList) {
            AudioClip clip = musicCP.Value;
            if (clip != null)
                clip.UnloadAudioData();
        }
        mMusicClipList.Clear ();
    }

    bool CanClear (AudioClip clip) {
        if (mNoClearSoundList != null && mNoClearSoundList.Count > 0) {
            for (int idx = 0; idx < mNoClearSoundList.Count; idx++) {
                if (mNoClearSoundList[idx].clip == clip)
                    return false;
            }
        }

        return true;
    }

    AudioSource PlayUISound (AudioClip clip, float volume, bool isLoop) {
        if (clip != null) {
            AudioSource[] audioList = mSound.GetComponents<AudioSource> ();
            for (int i = 0; i < audioList.Length; ++i) {
                AudioSource src = audioList[i];
                if (!src.isPlaying) {
                    src.Stop ();
                    src.Destroy ();
                }
            }

            AudioSource audioSrc = mSound.AddComponent<AudioSource> ();
            if (audioSrc != null) {
                audioSrc.outputAudioMixerGroup = null;
                audioSrc.playOnAwake = false;
                audioSrc.clip = clip;
                audioSrc.loop = isLoop;
                audioSrc.rolloffMode = AudioRolloffMode.Linear;
                audioSrc.volume = volume * mSoundVolume;
                audioSrc.mute = MuteSound;
                audioSrc.Play ();
            }

            return audioSrc;
        }

        return null;
    }

    void StopUISound (AudioClip clip) {
        AudioSource[] audioList = mSound.GetComponents<AudioSource> ();
        for (int i = 0; i < audioList.Length; ++i) {
            AudioSource src = audioList[i];
            if (src != null && src.clip == clip) {
                src.Stop ();
                src.Destroy ();
            }
        }
    }

    void OnSoundPreLoaded (List<AudioClip> audioClips, string assetPath, params string[] assetNames) {
        mLoading = false;

        if (audioClips == null) return;

        for (int i = 0; i < audioClips.Count; ++i) {
            if (audioClips[i] == null)
                continue;

            string clipName = assetNames[i];
            audioClips[i].name = clipName;
            if (!mAudioClipList.ContainsKey (clipName))
                mAudioClipList.Add (clipName, audioClips[i]);

            if (mLoadingFightSounds.ContainsKey (clipName))
                mLoadingFightSounds.Remove (clipName);
        }
    }

    void OnSoundLoaded (AudioClip audioClip, string assetPath, params string[] assetName) {
        if (audioClip == null) return;

        string clipName = assetName[0];
        if (!mAudioClipList.ContainsKey (clipName)) {
            bool repeat = false;
            mLoadingFightSounds.TryGetValue(clipName, out repeat);
            bool noClear = mNoClearSoundNameSet.Contains (clipName);

            audioClip.name = clipName;
            mAudioClipList.Add (clipName, audioClip);
            PlaySound (audioClip, false, repeat, noClear);
        }

        if (mLoadingFightSounds.ContainsKey (clipName))
            mLoadingFightSounds.Remove (clipName);
    }

    void OnMusicLoaded (AudioClip audioClip, string assetPath, params string[] assetName) {
        if (audioClip != null) {
            string audioName = audioClip.name;
            if (!mMusicClipList.ContainsKey (audioName)) {
                mMusicClipList.Add (audioName, audioClip);
            } else {
                DebugHelper.LogWarning ("The audio {0} is existing", audioName);
            }

            if (mLoadingAudioLoopInfo.ContainsKey (audioName)) {
                bool isLoop = mLoadingAudioLoopInfo[audioName];
                mLoadingAudioLoopInfo.Remove (audioName);

                if (mCurrMusicPlayer != null) {
                    StopCoroutine (mCurrMusicPlayer);
                    mCurrMusicPlayer = null;
                }
                mCurrMusicPlayer = StartCoroutine (PlayMusicCallBack (audioClip, isLoop));
            } else {
                if (mCurrMusicPlayer != null) {
                    StopCoroutine (mCurrMusicPlayer);
                    mCurrMusicPlayer = null;
                }
                mCurrMusicPlayer = StartCoroutine (PlayMusicCallBack (audioClip));
            }
        }
    }
}