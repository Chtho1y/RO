using UnityEngine;
using System.Collections;
using LuaInterface;
using System.Collections.Generic;
using System.IO;
using System;

public class GameMgr : SingletonMono<GameMgr>
{
    public const string VersionUpdateState = "VersionUpdateState";
    public const string LoginState = "LoginState";
    public const string LoadingState = "LoadingState";
    public const string BattleState = "BattleState";

    private string mAssetLogFileName;
    public string AssetLogFileName
    {
        get { return mAssetLogFileName; }
        private set { mAssetLogFileName = value; }
    }
    public static int RandSeed = 100000;
    public float mGameSpeed = 1.0f;

    private bool mIsSingle = false;
    private string mGameVersion;
    public string GameVersion
    {
        get { return mGameVersion; }
    }

    private string mResVersion;
    public string ResVersion
    {
        get { return mResVersion; }
    }

    public bool IsSingle
    {
        get { return mIsSingle; }
    }

    public float GameSpeed
    {
        get { return mGameSpeed; }
    }

    private LuaFunction OnSceneLoaded2Lua;
    private LuaFunction mPlayStoryLuaFun;

    private static GameMgr instance;
    public static new GameMgr Instance
    {
        get { return instance; }
    }

    private bool mIsStartDungeon = false;
    public bool InStartDungeon
    {
        get { return mIsStartDungeon; }
    }

    private bool mIsEditorMode = false;
    public bool IsEditorMode
    {
        get { return mIsEditorMode; }
    }

    public GameObject CreateMaleRoot
    {
        get { return CreateRoleMgr.Instance.MaleRoot; }
    }

    public GameObject CreateFemaleRoot
    {
        get { return CreateRoleMgr.Instance.FemaleRoot; }
    }

    public GameObject CreateShowRoot
    {
        get { return CreateRoleMgr.Instance.ShowRoot; }
    }

    public eNetType NetStatus
    {
        get { return DeviceInfo.GetNetType(); }
    }

    private MainCharacter mCharacterInfo;
    public MainCharacter CharacterInfo
    {
        get { return mCharacterInfo; }
    }

    public string DeviceId
    {
        get { return DeviceInfo.m_deviceId; }
    }

    public string CurLangKey
    {
        get { return ConfigMgr.CurLangKey; }
        set { ConfigMgr.CurLangKey = value; }
    }

    public bool IsMobileDevice
    {
        get
        {
#if UNITY_EDITOR
            return false;
#elif UNITY_ANDROID || UNITY_IPHONE
            return true;
#else
            return false;
#endif
        }
    }

    public bool IsBadDevice
    {
        get { return DeviceInfo.m_DeviceState == DeviceInfo.eDeviceState.BAD_DEVICE; }
    }

    public bool IsNormalDevice
    {
        get { return DeviceInfo.m_DeviceState == DeviceInfo.eDeviceState.NORMAL_DEVICE; }
    }

    public bool IsGoodDevice
    {
        get { return DeviceInfo.m_DeviceState == DeviceInfo.eDeviceState.GOOD_DEVICE; }
    }

    NPack.MersenneTwister rand = null;

    private SceneType mEnterSceneType = 0;
    private BattleSubMode mbossMode = BattleSubMode.None;

    private bool bInited = false;
    private void Awake()
    {
#if !UNITY_EDITOR
     DebugHelper.LogLevel = LogLevel.Error;   

#endif
        instance = this;
        DontDestroyOnLoad(this.gameObject);

        rand = new NPack.MersenneTwister(int.MaxValue);

    }


    bool bPaused = false;
    float mPausedTime = 0;
    private void OnApplicationFocus(bool focus)
    {
        if (bPaused && focus)
        {
            float pausePassedTime = Time.realtimeSinceStartup - mPausedTime;
            // if (pausePassedTime >= 300)      //切后台5分钟网络重新连接
            // {
            //     NetworkMgr.Instance.Resume();
            // }
        }
    }

    private void OnApplicationPause(bool pause)
    {
        bPaused = pause;
        if (bPaused)
        {
            mPausedTime = Time.realtimeSinceStartup;
            GameSettings.Instance.Save();
        }
    }

    protected override void OnApplicationQuit()
    {
        GameSettings.Instance.Save();
        base.OnApplicationQuit();
    }

    private void Start()
    {
        //mAssetLogFileName = $"{Application.streamingAssetsPath}//Logs//AssetLoadLog{DateTime.Now.Month}-{DateTime.Now.Day}-{DateTime.Now.ToShortTimeString()}.txt";
        mAssetLogFileName = $"{Environment.CurrentDirectory}//Logs//Log{DateTime.Now.Month}-{DateTime.Now.Day}-{DateTime.Now.Hour}-{DateTime.Now.Minute}.txt";
        if (bInited) return;
        SDKMgr.Instance.ReportActivation(SDKMgr.Instance.GetInt64TimeStamp());
        Screen.sleepTimeout = SleepTimeout.NeverSleep;
        QualitySettings.vSyncCount = 0;

        RegisterEvents();
        StartDetector();
        DeviceInfo.GetDeviceState();


        if (DeviceInfo.m_DeviceState <= DeviceInfo.eDeviceState.NORMAL_DEVICE)
        {
            Application.targetFrameRate = 60;
            BattleMgr.c_updateFPS = 15;
        }
        else
        {
            Application.targetFrameRate = 60;
            BattleMgr.c_updateFPS = 30;
        }

        Input.multiTouchEnabled = false;

        //启用日志
        StartLog();

        // TODO: LZ:
        // turn off when publishing
        // AutoStreaming.SetAssetAccessRecording(true);
        // AutoStreaming.MarkRecordBegin("ui-launch");

        //读取Apk设置文件
        //yield return StartCoroutine(ReadVersionFile());
        //InitData();

        //InitBuildConfig();

        //InitData();
        LaunchLoadMgr lanuchLoadMgr = new LaunchLoadMgr();
        lanuchLoadMgr.StartLaunch(OnLanuchLoadCompleted, OnAssetMapInitComplete);

        // 预下载文件
        // PreDownloadManager.Instance.CreateInGamePreDownloadComponent(this.gameObject,"list1");

        //检测非法修改
        AntiCheatMgr.Instance.GetOrCreateAnti(EnAntiCheatType.enSystemTime).Init(AntiCheatCfg.c_fTimeSysteCheckTime);
        AntiCheatMgr.Instance.GetOrCreateAnti(EnAntiCheatType.enScaleTime).Init(AntiCheatCfg.c_fTimeScaleCheckTime);

        bInited = true;
    }

    private void OnLanuchLoadCompleted(bool success)
    {
        EnterLuaLogin(false);
    }

    private void OnAssetMapInitComplete()
    {
        Debug.Log("资源加载完成 OnAssetMapInitComplete");
        CheckVersion();
        InitBugly();
    }

    private void CheckVersion()
    {
        mGameVersion = Application.version;
        int versionCodeInt = Wenting.Lebian.LeBianSDK.instance.GetResVerCode();
        VersionCode versionCode1;
        if (versionCodeInt <= 0)
        {
            versionCode1 = mGameVersion;
        }
        else
        {
            versionCode1 = (VersionCode)(uint)versionCodeInt;
        }
        VersionCode versionCode2 = AssetsMgr.Instance.resVersionCode;
        if (versionCode1 < versionCode2)
        {
            mResVersion = versionCode2.ToString();
        }
        else
        {
            mResVersion = versionCode1.ToString();
        }
    }

    void InitBugly()
    {
#if BUGLY
#if UNITY_IPHONE || UNITY_IOS
        string channel = Wenting.Lebian.LeBianSDK.instance.GetClientChId();
        BuglyAgent.ConfigDefault(channel, mResVersion, string.Empty, 0);
        BuglyAgent.InitWithAppId("3e7f97a53b");    
        BuglyAgent.EnableExceptionHandler();
#elif UNITY_ANDROID
        string channel = Wenting.Lebian.LeBianSDK.instance.GetClientChId();
        BuglyAgent.ConfigDefault(channel, mResVersion, string.Empty, 0);
#if LEBIAN_YUN_CLIENT
        BuglyAgent.InitWithAppId("96a729256a");
#else
        BuglyAgent.InitWithAppId("c7177b1ae7");
#endif
        BuglyAgent.EnableExceptionHandler();
#endif
#endif
    }

    public void StartDetector()
    {
        DataCheatingDetector.StartDetection(OnDataCheatingDetected);
        SpeedHackDetector.StartDetection(OnSpeedHackDetected);
    }

    bool speedHackDetected = false;
    bool dataCheatingDetected = false;
    void OnDataCheatingDetected()
    {
        dataCheatingDetected = true;
        //LocalPlayerInfo.SendCheat(ECheatType.CHEAT_DATA);
        DebugHelper.LogError("Data Cheating Detected!");
    }

    void OnSpeedHackDetected()
    {
        speedHackDetected = true;
        //LocalPlayerInfo.SendCheat(ECheatType.CHEAT_SPEED);

        DebugHelper.LogError("Speed hack Detected!");
    }

    private void Update()
    {
        AntiCheatMgr.Instance.Update();
        ResourceMgr.Instance.Update();
        TimerManager.Instance.Update();
        NetworkMgr.Instance.Update();
        UpdateFPS();
#if UNITY_EDITOR || OPENGM
        if (Input.GetMouseButtonDown(0))
        {
            Rect validRect = SafeRectCheck.Instance.safeArea;
            validRect.width = validRect.height * 0.025f;
            validRect.y = validRect.height + validRect.y - validRect.width;
            validRect.height = validRect.width;
            if (validRect.Contains(Input.mousePosition))
            {
                mouseDown = true;
                dragged = false;
                mouseDownTime = Time.time;
                mouseDownPos = Input.mousePosition;
            }
            else
            {
                clickCount = 0;
            }
        }
        if (mouseDown && !dragged && Vector3.Distance(Input.mousePosition, mouseDownPos) >= 5.0f)
        {
            dragged = true;
        }

        if (Input.GetMouseButtonUp(0))
        {
            if (mouseDown)
            {
                mouseDown = false;
                if (dragged)
                {
                    clickCount = 0;
                }
                else
                {
                    dragged = false;
                    Rect validRect = SafeRectCheck.Instance.safeArea;
                    validRect.width = validRect.height * 0.025f;
                    validRect.y = validRect.height + validRect.y - validRect.width;
                    validRect.height = validRect.width;
                    if (Time.time - mouseDownTime < 2 && validRect.Contains(Input.mousePosition))
                    {
                        clickCount = clickCount + 1;
                        if (clickCount >= 2)
                        {
                            clickCount = 0;
                            var pLuaState = LuaMgr.GetMainState();
                            if (null != pLuaState)
                            {
                                LuaMgr.GetMainState().DoString("local curUIId = ManagerContainer.LuaUIMgr:GetCurUIId()\nManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGM, nil, curUIId)");
                            }
                        }
                    }
                    else
                    {
                        clickCount = 0;
                    }
                }
            }
        }
    }

    // private void OnGUI() {
    //     Rect validRect = SafeRectCheck.Instance.safeArea;
    //     validRect.width = validRect.height * 0.025f;
    //     validRect.y = SafeRectCheck.Instance.screenHeight - validRect.height - validRect.y;
    //     validRect.height = validRect.width;
    //     GUI.DrawTexture(validRect, Texture2D.whiteTexture);
    // }

    private int clickCount = 0;
    private bool mouseDown = false;
    private bool dragged = false;
    private float mouseDownTime = 0f;
    private Vector2 mouseDownPos = Vector2.zero;
#else
    }
#endif

    protected override void Dispose()
    {
        base.Dispose();
    }

    private const float m_FrameUpdateInterval = 0.5f;
    private float m_FrameUpdateTime = 0f;
    private float m_MaxTimeAccumulator = 0;
    private int m_FrameCounter = 0;
    private int m_MaxFrameTime = 0;
    public int maxFrameTime
    {
        get { return m_MaxFrameTime; }
    }
    private void UpdateFPS()
    {
        float deltaTime = Time.deltaTime;
        if (deltaTime > 0)
        {
            m_FrameUpdateTime -= deltaTime;
            m_MaxTimeAccumulator += Time.timeScale / deltaTime;
            m_FrameCounter++;
        }
        if (m_FrameUpdateTime <= 0)
        {
            m_MaxFrameTime = Mathf.RoundToInt(m_MaxTimeAccumulator / m_FrameCounter);
            m_FrameUpdateTime = m_FrameUpdateInterval;
            m_MaxTimeAccumulator = 0;
            m_FrameCounter = 0;
        }
    }

    void EnterLuaLogin(bool relogin)
    {
        if (mCharacterInfo == null)
        {
            mCharacterInfo = new MainCharacter();
        }
        LuaMgr.Instance.EnterLogin(relogin);
    }

    void DisposeCharactorInfo()
    {
        mCharacterInfo.Dispose();
        mCharacterInfo = null;
    }

    void OnLogout(CoreEvent<int> ce)
    {

    }

    public void SetOnSceneLoadedLuaFunc(LuaFunction func)
    {
        OnSceneLoaded2Lua = func;
    }

    public void ReLogin()
    {
        ShutDownBattle(false); // 清空战斗数据 逻辑 (等待loading界面完成 清空战斗实例)       
        DisposeCharactorInfo();
        EnterLuaLogin(true);
    }

    public void ReLoginClearData()
    {
        ClearMainCharacter();
        ActorDataMgr.Instance.Clear();
        DisposeBattle(); // 销毁战斗实例
        BattleMgr.Instance.ClearSkillDirty(); // 销毁待更新技能
        SceneMgr.Instance.LoadMainScene("relogin");
    }

    void ClearMainCharacter()
    {
        if (mCharacterInfo != null)
        {
            mCharacterInfo.Clear();
        }
    }


    public void SetLuaPlayStoryFunc(LuaFunction func)
    {
        mPlayStoryLuaFun = func;
    }

    public void LoadCurrentBattle()
    {
        Debug.LogWarning("GameMgr LoadCurrentBattle ");
        GameStateCtrl.Instance.GotoState(LoadingState);
    }

    public void CloseLoading()
    {
        if (BattleMgr.Instance.Battle == null) return;

        if (BattleMgr.Instance.Battle.IsBossBattle && BattleMgr.Instance.Battle.SubBattleMode == BattleSubMode.NewbieBoss)
        {
            BattleMgr.Instance.StartStoryScript();
        }
    }

    public void SetTeamData(LuaTable teamParam, LuaTable tbIsForce)
    {
        if (mCharacterInfo != null)
        {
            mCharacterInfo.SetTeamActors(teamParam);

            bool bIsForce = false; // 是否强制同步
            if (tbIsForce[1] != null)
            {
                bool.TryParse(tbIsForce[1].ToString(), out bIsForce);
            }
            BattleMgr.Instance.SyncTeams(bIsForce);
        }
    }

    public void RefreshTeamData()
    {
        for (int idx = 0; idx < mCharacterInfo.TeamActors.Count; idx++)
        {
            ActorDataMgr.Instance.RefreshFellowActorData(mCharacterInfo.TeamActors[idx].ID, mCharacterInfo.TeamActors[idx].BaseId);
        }
    }

    public void UpdateTeamSkills(LuaTable skillsParam)
    {
        if (mCharacterInfo != null)
        {
            BattleMgr.Instance.UpdateTeamSkills(skillsParam);
        }
    }

    /// <summary>
    /// 完成角色创建
    /// </summary>
    /// <param name="modelGo"></param>
    public void CreateRoleViewComplete(GameObject modelGo)
    {
        BattleMgr.Instance.OnLoadRoleCompleted(modelGo, false, false);
    }

    /// <summary>
    /// 角色形象更新完成
    /// </summary>
    /// <param name="modelGo"></param>
    public void RefreshRoleViewComplete(GameObject modelGo, bool isNew)
    {
        BattleMgr.Instance.OnLoadRoleCompleted(modelGo, true, isNew);
    }

    /// <summary>
    /// 时装或者其它功能更新了角色形象，战斗内需要自行调用形象更新 参数 是否为转职后的新角色
    /// </summary>
    public void NotifyRefreshRoleView()
    {
        BattleMgr.Instance.NotifyRefreshRoleView();
    }

    public void SetMapLevelId(int mapId, int levelId)
    {
        if (mCharacterInfo == null) return;

        if (mCharacterInfo.CurMapId != mapId)
        {
            mCharacterInfo.CurMapId = mapId;
            mCharacterInfo.CurLevelId = levelId;
        }
        else
        {
            if (mCharacterInfo.CurLevelId != levelId)
            {
                mCharacterInfo.CurLevelId = levelId;
                BattleMgr.Instance.EnterNextBattle();
            }
        }
    }

    public void PreloadCreateRoleScene()
    {
        mEnterSceneType = SceneType.CreateRoleScene;
        CreateRoleMgr.Instance.LoadScene();
    }

    public void GotoLogin()
    {
        Debug.LogWarning("GameMgr GotoLogin ");
        BattleMgr.Instance.ShutDownCurrentBattle();
    }

    //进入公会大厅
    public void PreloadGuildLobby()
    {
        mEnterSceneType = SceneType.GuildLobbyScene;
        BattleMgr.Instance.ShutDownCurrentBattle();
        GuildLobbyMgr.Instance.EnterGuildLobby();
    }

    public void PreloadAllFellows(ActorData[] actors)
    {
        if (actors == null || actors.Length == 0) return;

        for (int idx = 0; idx < actors.Length; idx++)
        {
            var actor = actors[idx];
            if (actor != null)
            {
                BattlePrepareManager.Instance.PrecacheModel(actor.AvatarData.prefab, actor.AType);
                BattlePrepareManager.Instance.PrecacheAnimatorCtrl(actor.ShowAnimCtrlName);
            }
        }
    }

    // 启动预加载
    // Lua LoadingState:StartNormalBattle调用
    public void PreloadBattle(LuaTable teamParam)
    {
        mEnterSceneType = SceneType.NormalBattleScene;
        GuildLobbyMgr.Instance.Clear();

        mCharacterInfo.SetTeamActors(teamParam);
        LogicBattleStartInfo startInfo = new LogicBattleStartInfo(mCharacterInfo.CurMapId, mCharacterInfo.CurLevelId);
        BattleMgr.Instance.ShutDownCurrentBattle();
        BattleMgr.Instance.StartBattle(startInfo);
    }

    public List<ActorData> StartNewbieBossBattle(int sceneId, int roleSex)
    {
        mEnterSceneType = SceneType.BossBattleScene;
        BattleMgr.Instance.ShutDownCurrentBattle();
        return BattleMgr.Instance.StartNewbieBossBattle(sceneId, roleSex);
    }

    public void PreloadViewTeam(ActorData[] teamActors, string sceneName, LuaTable tbl)
    {
        mEnterSceneType = SceneType.TowerBattleScene;
        BattleMgr.Instance.ShutDownCurrentBattle();
        PreviewTeamMgr.Instance.LoadPreviewActorsAndScene(teamActors, sceneName, tbl);
    }

    public void PreloadVersusBattle(BattleSubMode mode,
                                    ActorData[] teamActors,
                                    ActorData[] enemyActors,
                                    string sceneName,
                                    float maxFightingTime,
                                    BattleEndCondition[] endConds,
                                    GvGMark[] OurMarks,
                                    GvGMark[] EnemyMarks,
                                    bool IsPresspoint,
                                    int nPresspoint)
    {
        mEnterSceneType = SceneType.TowerBattleScene;
        BattleMgr.Instance.ShutDownCurrentBattle();
        BattleMgr.Instance.StartVersusBattle(mode, teamActors, enemyActors, sceneName, maxFightingTime, endConds, OurMarks, EnemyMarks, IsPresspoint, nPresspoint);
    }

    public void PreloadBossBattle(ActorData[] actors,
                                  int bossId,
                                  int sceneId,
                                  BattleEndCondition[] endConds)
    {
        mEnterSceneType = SceneType.BossBattleScene;
        BattleMgr.Instance.ShutDownCurrentBattle();
        BattleMgr.Instance.StartBossBattle(actors, bossId, sceneId, endConds);
    }

    public bool PreloadTimeBattle(LuaTable luaTbl,
                                  BattleSubMode mode,
                                  float maxFightingTime,
                                  string sceneName,
                                  string bgmMusic,
                                  ActorData[] ourActors,
                                  ActorData[] enemyActors,
                                  ServerFighterParam[] fighterParams,
                                  BattleEndCondition[] endConds,
                                  ValType[] factors,
                                  int nRestoreSp,
                                  GvGMark[] OurMarks,
                                  GvGMark[] EnemyMarks
                                    )
    {
        mEnterSceneType = SceneType.TimeBattleScene;
        return BattleMgr.Instance.StartTimeBattle(luaTbl, mode, maxFightingTime, sceneName, bgmMusic, ourActors, enemyActors, fighterParams, endConds, factors, nRestoreSp, OurMarks, EnemyMarks);
    }

    public bool ReplayTimeBattle(LuaTable luaTbl, BattleSubMode mode, float maxFightingTime, string sceneName, string bgmMusic, string battleRecordStr)
    {
        mEnterSceneType = SceneType.TimeBattleScene;
        return BattleMgr.Instance.ReplayTimeBattle(luaTbl, mode, maxFightingTime, sceneName, bgmMusic, battleRecordStr);
    }

    public void ForceStopBattle()
    {
        BattleMgr.Instance.ForceStopBattle();
    }

    //关闭清空战斗
    public void ShutDownBattle(bool bIsDispose = true)
    {
        BattleMgr.Instance.ShutDownCurrentBattle(bIsDispose);
    }

    //销毁战斗
    public void DisposeBattle()
    {
        BattleMgr.Instance.DisposeCurrentBattle();
    }

    public void SetGameSpeed(float speed)
    {
        BattleMgr.Instance.SetSpeedUp(speed);
    }

    public void SaveGameSpeed(float speed)
    {
        mGameSpeed = speed;
        BattleMgr.Instance.SetSpeedUp(speed);
    }


    public float GetGameSpeed()
    {
        return BattleMgr.speed_up_rate;
    }

    private void OnLoadComplete(CoreEvent<bool> ce)
    {
#if USE_LUA
        if (OnSceneLoaded2Lua != null)
        {
            OnSceneLoaded2Lua.Call(this, mEnterSceneType, BattleMgr.Instance.Battle != null ? BattleMgr.Instance.Battle.SubBattleMode : BattleSubMode.None);
        }
#else
        EnterBattleState();
#endif
    }

    public int Random(int min, int max)
    {
        return max > min ? rand.Next(min, max) : min;
    }

    public uint CalcPassedTime(long timeStr)
    {
        ulong time = (ulong)timeStr;
        time = TimerManager.Instance.serverTime - time;
        if (time > uint.MaxValue)
        {
            return uint.MaxValue;
        }
        else if (time < 0)
        {
            return 0;
        }
        else
        {
            return (uint)time;
        }
    }

    public void QuitGame(bool isShowView = false)
    {
        //需要打开退出页面
        if (isShowView)
        {
            //如果sdk有就打开
            if (SDKMgr.Instance.CheckHasModul(SDKModulType.EXIT_VIEW))
            {
                SDKMgr.Instance.OpenModul(SDKModulType.EXIT_VIEW);
            }
            else
            {
                if (!SDKMgr.Instance.Exit())
                {
                    KillApplication();
                }
            }
        }
        else
        {
            if (!SDKMgr.Instance.Exit())
            {
                KillApplication();
            }
        }

    }

    private void KillApplication()
    {
        // 游戏需要保存数据的在这里保存
        GameSettings.Instance.Save();
        if (SDKMgr.Instance.Quit()) return;
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#else
        Application.Quit();
#endif
    }

    public void PlayDialog(int dialogueType, int dialogueId = 0)
    {
        if (mPlayStoryLuaFun != null)
            mPlayStoryLuaFun.Call(this, dialogueType, dialogueId);
    }

    public void RequestHttpServer(string url, LuaFunction luaFunc_)
    {
        StartCoroutine(DoRequestHttpServer(url, luaFunc_));
    }

    IEnumerator DoRequestHttpServer(string url, LuaFunction luaFunc_)
    {
        if (string.IsNullOrEmpty(url))
        {
            yield break;
        }

        Debug.Log("DoRequestHttpServer url " + url);

        WWW httpReq = new WWW(url);
        yield return httpReq;

        if (!string.IsNullOrEmpty(httpReq.error))
        {
            DebugHelper.LogError("DoRequestHttpServer failed:{0}", httpReq.error);
            httpReq.Dispose();
            httpReq = null;
            yield break;
        }


        string content = httpReq.text;
        httpReq.Dispose();
        httpReq = null;
        if (luaFunc_ != null)
        {
            luaFunc_.Call(content);
        }
    }

    public void CleanUnusedAssets()
    {
        StartCoroutine(UnloadAssets_Coroutine());
    }

    public void OpenUrl(string url)
    {
        if (string.IsNullOrEmpty(url)) return;

        SDKMgr.Instance.OpenWebview(url);
        //Application.OpenURL(url);
    }

    public void EnableAntiAliasing()
    {
        if (DeviceInfo.m_DeviceState == DeviceInfo.eDeviceState.NORMAL_DEVICE)
        {
            QualitySettings.antiAliasing = 2;
        }
        else if (DeviceInfo.m_DeviceState == DeviceInfo.eDeviceState.GOOD_DEVICE)
        {
            QualitySettings.antiAliasing = 4;
        }
        //DebugHelper.LogError("antiAliasing" + QualitySettings.antiAliasing);
    }

    public void DisableAntiAliasing()
    {
        QualitySettings.antiAliasing = 0;
        //DebugHelper.LogError("antiAliasing" + QualitySettings.antiAliasing);
    }

    IEnumerator UnloadAssets_Coroutine()
    {
        yield return 0;

        yield return Resources.UnloadUnusedAssets();

        System.GC.Collect();
    }

    #region inner_methods
    private void RegisterEvents()
    {
        EventMgr.AddEventListener<int>(ECoreEventType.EID_Logout, OnLogout);
        EventMgr.AddEventListener<bool>(ECoreEventType.EID_LOAD_COMPLETE, OnLoadComplete);

        //EventMgr.AddEventListener<bool,string>(ECoreEventType.EID_SDK_INIT_RESULT, OnSdkInitRet);

        //EventMgr.AddEventListener<bool, UserInfo>(ECoreEventType.EID_SDK_LOGIN_RESULT_NEW, OnSdkLoginRet);
        //EventMgr.AddEventListener<bool, UserInfo>(ECoreEventType.EID_SDK_SWITCH_ACCOUNT_NEW, OnSdkSwitchAccount);
        //EventMgr.AddEventListener<bool>(ECoreEventType.EID_SDK_LOGOUT, OnSdkLogout);
        //EventMgr.AddEventListener<bool>(ECoreEventType.EID_SDK_EXIT, OnSdkExit);
        //EventMgr.AddEventListener<bool>(ECoreEventType.EID_SDK_PAY_SUCCESS, OnSdkPaySuccess);
        EventMgr.AddEventListener<bool>(ECoreEventType.EID_SDK_PAY_CANCEL, OnSdkPayCancel);
        //EventMgr.AddEventListener<bool>(ECoreEventType.EID_SDK_PAY_FAILED, OnSdkPayFailed);
        EventMgr.AddEventListener<bool>(ECoreEventType.EID_SDK_QUESTION_REWARD_RESULT, OnSdkQuestionRewardResult);

        SDKEventUtil.AddListener(SDKCBEnum.EXIT_SUCCESS_CB, OnSdkExit);
        SDKEventUtil.AddListener(SDKCBEnum.INIT_FAILED_CB, OnSdkInitFail);
        SDKEventUtil.AddListener(SDKCBEnum.INIT_SUCCESS_CB, OnSdkInitSuccess);
        SDKEventUtil.AddListener(SDKCBEnum.LOGIN_FAILED_CB, OnSdkLoginFail);
        SDKEventUtil.AddListener(SDKCBEnum.LOGIN_SUCCESS_CB, OnSdkLoginSuccess);
        SDKEventUtil.AddListener(SDKCBEnum.LOGOUT_SUCCESS_CB, OnSdkLogoutSuccess);
        SDKEventUtil.AddListener(SDKCBEnum.PAY_FAILED_CB, OnSdkPayFailed);
        SDKEventUtil.AddListener(SDKCBEnum.PAY_SUCCESS_CB, OnSdkPaySuccess);
        SDKEventUtil.AddListener(SDKCBEnum.SWITCH_FAILED_CB, OnSdkSwitchAccountFailed);
        SDKEventUtil.AddListener(SDKCBEnum.SWITCH_SUCCESS_CB, OnSdkSwitchAccountSuccess);

        SDKEventUtil.AddListener(SDKCBEnum.TT_VIDEO_AD_FINISH, OnSdkVideoAdFinish);
        SDKEventUtil.AddListener(SDKCBEnum.TT_PAGE_AD_FINISH, OnSdkPageAdFinish);
        SDKEventUtil.AddListener(SDKCBEnum.TT_SHARE_FINISH, OnSdkShareFinish);
        SDKEventUtil.AddListener(SDKCBEnum.TT_CREATE_IN_DESKTOP_FINISH, OnSdkCreateInDesktopFinish);
        SDKEventUtil.AddListener(SDKCBEnum.TT_BIND_TICKTOK_FINISH, OnSdkBindTickTockFinish);
        SDKEventUtil.AddListener(SDKCBEnum.TT_GET_SFAE_AREA, OnGetSafeAreaSuccess);
        SDKEventUtil.AddListener(SDKCBEnum.TT_RECORD_FINISG, OnRecordFinish);

        SDKEventUtil.AddListener(SDKCBEnum.CAN_ENTER_SERVER_JUDGE_CB, OnSdkCanEnterServerJudge);
    }

    private void UnRegisterEvents()
    {
        EventMgr.RemoveEventListener<int>(ECoreEventType.EID_Logout, OnLogout);
        EventMgr.RemoveEventListener<bool>(ECoreEventType.EID_LOAD_COMPLETE, OnLoadComplete);

        //EventMgr.RemoveEventListener<bool,string>(ECoreEventType.EID_SDK_INIT_RESULT, OnSdkInitRet);
        //EventMgr.RemoveEventListener<bool, UserInfo>(ECoreEventType.EID_SDK_LOGIN_RESULT_NEW, OnSdkLoginRet);
        //EventMgr.RemoveEventListener<bool, UserInfo>(ECoreEventType.EID_SDK_SWITCH_ACCOUNT_NEW, OnSdkSwitchAccount);
        //EventMgr.RemoveEventListener<bool>(ECoreEventType.EID_SDK_LOGOUT, OnSdkLogout);
        //EventMgr.RemoveEventListener<bool>(ECoreEventType.EID_SDK_EXIT, OnSdkExit);
        //EventMgr.RemoveEventListener<bool>(ECoreEventType.EID_SDK_PAY_SUCCESS, OnSdkPaySuccess);
        EventMgr.RemoveEventListener<bool>(ECoreEventType.EID_SDK_PAY_CANCEL, OnSdkPayCancel);
        EventMgr.RemoveEventListener<bool>(ECoreEventType.EID_SDK_PAY_FAILED, OnSdkPayFailed);
        EventMgr.RemoveEventListener<bool>(ECoreEventType.EID_SDK_QUESTION_REWARD_RESULT, OnSdkQuestionRewardResult);

        SDKEventUtil.RemoveListener(SDKCBEnum.EXIT_SUCCESS_CB, OnSdkExit);
        SDKEventUtil.RemoveListener(SDKCBEnum.INIT_FAILED_CB, OnSdkInitFail);
        SDKEventUtil.RemoveListener(SDKCBEnum.INIT_SUCCESS_CB, OnSdkInitSuccess);
        SDKEventUtil.RemoveListener(SDKCBEnum.LOGIN_FAILED_CB, OnSdkLoginFail);
        SDKEventUtil.RemoveListener(SDKCBEnum.LOGIN_SUCCESS_CB, OnSdkLoginSuccess);
        SDKEventUtil.RemoveListener(SDKCBEnum.LOGOUT_SUCCESS_CB, OnSdkLogoutSuccess);
        SDKEventUtil.RemoveListener(SDKCBEnum.PAY_FAILED_CB, OnSdkPayFailed);
        SDKEventUtil.RemoveListener(SDKCBEnum.PAY_SUCCESS_CB, OnSdkPaySuccess);
        SDKEventUtil.RemoveListener(SDKCBEnum.SWITCH_FAILED_CB, OnSdkSwitchAccountFailed);
        SDKEventUtil.RemoveListener(SDKCBEnum.SWITCH_SUCCESS_CB, OnSdkSwitchAccountSuccess);

        SDKEventUtil.RemoveListener(SDKCBEnum.TT_VIDEO_AD_FINISH, OnSdkVideoAdFinish);
        SDKEventUtil.RemoveListener(SDKCBEnum.TT_PAGE_AD_FINISH, OnSdkPageAdFinish);
        SDKEventUtil.RemoveListener(SDKCBEnum.TT_SHARE_FINISH, OnSdkShareFinish);
        SDKEventUtil.RemoveListener(SDKCBEnum.TT_CREATE_IN_DESKTOP_FINISH, OnSdkCreateInDesktopFinish);
        SDKEventUtil.RemoveListener(SDKCBEnum.TT_BIND_TICKTOK_FINISH, OnSdkBindTickTockFinish);
        SDKEventUtil.RemoveListener(SDKCBEnum.TT_GET_SFAE_AREA, OnGetSafeAreaSuccess);
        SDKEventUtil.RemoveListener(SDKCBEnum.TT_RECORD_FINISG, OnRecordFinish);

        SDKEventUtil.RemoveListener(SDKCBEnum.CAN_ENTER_SERVER_JUDGE_CB, OnSdkCanEnterServerJudge);
    }

    private void StartLog()
    {
        DebugHelper debugHelper = this.gameObject.GetComponent<DebugHelper>();
        if (debugHelper == null)
        {
            this.gameObject.AddComponent<DebugHelper>();
        }

        DebugHelper.enableLog = true;
        DebugHelper.BeginLogs();
    }

    private IEnumerator ReadVersionFile()
    {
        string path = FileSystem.LocalPackagePath;

#if !UNITY_STANDALONE_WIN
#if UNITY_EDITOR    //editor
        path = string.Format("{0}/", Application.dataPath);
#elif UNITY_ANDROID && !UNITY_EDITOR//android release;
             path = FileSystem.LocalPackagePath;
#elif UNITY_IPHONE && !UNITY_EDITOR //ios release;
             path = FileSystem.LocalPackagePath;
#else   //pc release;
             path = Application.dataPath;
#endif
#else
        path = FileSystem.LocalPackagePath;
#endif

        //热更地址从新整合的配置中提取
        string UpdateFilePath = string.Format("{0}appbuildconfig.xml", path);

        WWW www = new WWW(UpdateFilePath);
        DebugHelper.Log("ReadUpdateFile : LocalPackagePath  {0}", UpdateFilePath);
        yield return www;
        if (www.error == null)
        {
            DebugHelper.Log("ReadUpdateFile :  {0}", www.text);

            www.Dispose();
            www = null;
        }
        else
        {
            DebugHelper.LogError("ReadUpdateFile {0} , {1}", www.error, UpdateFilePath);
            www.Dispose();
            www = null;
        }
    }
    #endregion

    #region ACCOUNT_SDK

    //private SDKMgr SdkManager = SDKMgr.Instance;
    private LuaFunction mSdkInitedLuaCB = null;
    private LuaFunction mSdkLoginedLuaCB = null;
    private LuaFunction mSdkLogoutLuaCB = null;
    private LuaFunction mSdkPayLuaCB = null;
    private LuaFunction msdkQuestionLuaCB = null;

    private LuaFunction mSdkVideoAdLuaCB = null;
    private LuaFunction mSdkPageAdLuaCB = null;
    private LuaFunction mSdkShareLuaCB = null;
    private LuaFunction mSdkCreateInDesktopLuaCB = null;
    private LuaFunction mSdkBindTicktokLuaCB = null;
    private LuaFunction mSdkCanEnterServerJudgeCB = null;

    private LuaFunction mSdkGetSafeAreaCB = null;

    private LuaFunction mSDKRecordLuaCB = null;

    public void SdkInitFunc(LuaFunction func)
    {

        mSdkInitedLuaCB = func;
        //mSdkInitedLuaCB.Call(this, true, "");
    }

    public void SdkVideoAdFunc(LuaFunction func)
    {

        mSdkVideoAdLuaCB = func;
    }

    public void SdkPageAdFunc(LuaFunction func)
    {
        mSdkPageAdLuaCB = func;
    }

    public void SdkShareFunc(LuaFunction func)
    {
        mSdkShareLuaCB = func;
    }

    public void SdkBindTickTokFunc(LuaFunction func)
    {
        mSdkBindTicktokLuaCB = func;
    }

    public void SdkCreateInDesktopFunc(LuaFunction func)
    {
        mSdkCreateInDesktopLuaCB = func;
    }

    public void SdkGetSafeAreaFunc(LuaFunction func)
    {
        mSdkGetSafeAreaCB = func;
    }

    public void SdkLoginFunc(LuaFunction func)
    {
        mSdkLoginedLuaCB = func;
    }

    public void SdkRecordFunc(LuaFunction func)
    {
        mSDKRecordLuaCB = func;
    }

    public void SdkLogoutFunc(LuaFunction func)
    {
        mSdkLogoutLuaCB = func;
    }

    public void SdkPayFunc(LuaFunction func)
    {
        mSdkPayLuaCB = func;
    }

    public void SdkQuestionFunc(LuaFunction func)
    {
        msdkQuestionLuaCB = func;
    }

    public void SdkCanEnterServerJudgeFunc(LuaFunction func)
    {
        mSdkCanEnterServerJudgeCB = func;
    }

    public void SdkInit()
    {
        // if(isByteDance){
        //     //ByteDance.Instance.initSdk();
        // }
        SDKMgr.Instance.Init();
    }

    public void SdkLogin()
    {
        SDKMgr.Instance.Login();
    }

    public void SdkPay(int goodsId, string goodsName, string goodsDesc,
                       int count, float amount,
                       string cpOrderId, string extrasParams)
    {
        int decimalVal = 1000;
        int tempVal = Mathf.FloorToInt((amount + 0.0005f) * decimalVal);
        amount = (float)tempVal / decimalVal;

        if (string.IsNullOrEmpty(goodsName))
        {
            goodsName = "初心者";
        }
        SDKMgr.Instance.Pay(goodsId, goodsName, goodsDesc,
                                count, amount,
                                cpOrderId, extrasParams);
    }

    public void SdkLogout()
    {
        SDKMgr.Instance.Logout();
    }

    public void SdkExit()
    {

    }

    public void SdkShowToolbar()
    {
        //int ret = quicksdk.QuickSDK.getInstance().showToolBar(quicksdk.ToolbarPlace.QUICK_SDK_TOOLBAR_MID_LEFT);
        //DebugHelper.LogError("SdkShowToolbar:" + ret);
    }

    public void SdkHideToolBar()
    {
        //SdkManager.SdkHideToolBar();
    }


    private void OnSdkInitFail(object obj)
    {

        if (mSdkInitedLuaCB != null)
        {
            int ret = (int)obj;
            mSdkInitedLuaCB.Call(this, false, ret);
            // mSdkInitedLuaCB.Call(this, false, SDKMgr.Instance.GetSDKName());
        }
    }

    private void OnSdkInitSuccess(object obj)
    {
        if (mSdkInitedLuaCB != null)
        {
            mSdkInitedLuaCB.Call(this, true, SDKMgr.Instance.GetSDKName());
        }
    }


    private void OnSdkLoginFail(object obj)
    {

        if (mSdkLoginedLuaCB != null)
        {
            mSdkLoginedLuaCB.Call(this, false, "", "", false);
            SDKMgr.Instance.ReportRoleEnterFail();
        }
    }

    private void OnSdkLoginSuccess(object obj)
    {
        if (mSdkLoginedLuaCB != null)
        {
            if (obj != null)
            {
                UserInfo userInfo = (UserInfo)obj;
                mSdkLoginedLuaCB.Call(this, true, userInfo.uid, userInfo.token, false);
                SDKMgr.Instance.ReportIdentification(SDKMgr.Instance.GetInt64TimeStamp());
            }
            else
            {
                mSdkLoginedLuaCB.Call(this, true, "", "", false);
            }
        }
    }

    private void OnSdkSwitchAccountFailed(object obj)
    {
        if (mSdkLoginedLuaCB != null)
        {
            UserInfo userInfo = (UserInfo)obj;
            mSdkLoginedLuaCB.Call(this, false, userInfo.uid, userInfo.token, true);
        }
    }

    private void OnSdkSwitchAccountSuccess(object obj)
    {
        if (mSdkLoginedLuaCB != null)
        {
            UserInfo userInfo = (UserInfo)obj;
            mSdkLoginedLuaCB.Call(this, true, userInfo.uid, userInfo.token, true);
        }
    }

    private void OnGetSafeAreaSuccess(object obj)
    {
        return;
        // if (mSdkGetSafeAreaCB != null)
        // {
        //     StarkSDKSpace.SafeArea safeArea = (StarkSDKSpace.SafeArea)obj;
        //     mSdkGetSafeAreaCB.Call(this, safeArea.left, safeArea.right, safeArea.top, safeArea.bottom, safeArea.width, safeArea.height);
        // }
    }

    private void OnRecordFinish(object obj)
    {
        if (mSDKRecordLuaCB != null)
        {
            var data = (LuaCustomData)obj;
            mSDKRecordLuaCB.Call(this, data.type, data.result, data.ext);
        }
    }

    private void OnSdkShareFinish(object obj)
    {
        if (mSdkShareLuaCB != null)
        {
            mSdkShareLuaCB.Call(this, (bool)obj);
        }
    }

    private void OnSdkVideoAdFinish(object obj)
    {
        if (mSdkVideoAdLuaCB != null)
        {
            mSdkVideoAdLuaCB.Call(this, (bool)obj);
        }
    }

    private void OnSdkPageAdFinish(object obj)
    {
        if (mSdkPageAdLuaCB != null)
        {
            mSdkPageAdLuaCB.Call(this, (bool)obj);
        }
    }

    private void OnSdkCreateInDesktopFinish(object obj)
    {
        if (mSdkCreateInDesktopLuaCB != null)
        {
            mSdkCreateInDesktopLuaCB.Call(this, (bool)obj);
        }
    }

    private void OnSdkBindTickTockFinish(object obj)
    {
        if (mSdkBindTicktokLuaCB != null)
        {
            mSdkBindTicktokLuaCB.Call(this, (bool)obj);
        }
    }
    private void OnSdkLogoutSuccess(object obj)
    {
        if (mSdkLogoutLuaCB != null)
        {
            mSdkLogoutLuaCB.Call(this);
        }
    }

    private void OnSdkExit(object obj)
    {
        KillApplication();

    }

    private void OnSdkPaySuccess(object obj)
    {
        if (mSdkPayLuaCB != null)
        {
            mSdkPayLuaCB.Call(this, true);
        }
    }

    private void OnSdkPayCancel(CoreEvent<bool> ce)
    {
        if (mSdkPayLuaCB != null)
        {
            mSdkPayLuaCB.Call(this, false);
        }
    }

    private void OnSdkPayFailed(object obj)
    {
        if (mSdkPayLuaCB != null)
        {
            mSdkPayLuaCB.Call(this, (string)obj);
        }
    }

    private void OnSdkQuestionRewardResult(CoreEvent<bool> ce)
    {
        if (msdkQuestionLuaCB != null)
        {
            msdkQuestionLuaCB.Call(this, true);
        }
    }

    private void OnSdkCanEnterServerJudge(object obj)
    {
        if (mSdkCanEnterServerJudgeCB != null)
        {
            mSdkCanEnterServerJudgeCB.Call(this, "" + obj);
        }
    }

    #endregion
}