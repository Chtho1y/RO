using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class LaunchLoadMgr
{
    private Action<bool> m_LaunchCompleteCb;
    private Action m_AssetMapInitCompleteCb;
    private bool m_IsCompleted = false;
    private float m_StartTime = 0f;
    private int m_TimerId = 0;

    public LaunchLoadMgr()
    {
    }

    ~LaunchLoadMgr()
    {
        StopLaunch();
    }

    public void StartLaunch(Action<bool> launchCompleteCb, Action assetMapInitCompleteCb)
    {
        if (m_IsCompleted)
        {
            StopLaunch();
            return;
        }
        m_LaunchCompleteCb = launchCompleteCb;
        m_AssetMapInitCompleteCb = assetMapInitCompleteCb;
        m_StartTime = Time.unscaledTime;
        m_IsCompleted = false;
        LaunchThread.CreateInstance();
        AvatarRTMgr.CreateInstance();
        MusicMgr.Instance.InitMgr();
        UIMgr.Instance.InitMgr();
        //AssetsMgr.Instance.InitMgr();
        //AssetsMgr.Instance.InitDependenciesAsync(OnDependenciesInited);
        //GameObject go = ResourceMgr.Instance.LoadAssetSync<GameObject>(Constants.UIPath, "UILanuch/UILanuch");
        //OnLoadUILanuchCallback(go, null, null);

        AssetsMgr.Instance.InitDependenciesAsync(OnDependenciesInited);
    }

    public void StopLaunch()
    {
        DisposeUILanuch();
        if (m_LaunchCompleteCb != null)
        {
            m_LaunchCompleteCb(m_IsCompleted);
            m_LaunchCompleteCb = null;
        }
        if (LaunchThread.HasInstance())
        {
            LaunchThread.DestroyInstance();
        }
        m_AssetMapInitCompleteCb = null;
    }

    private void OnDependenciesInited(bool success)
    {
        if (success)
        {
            if (m_AssetMapInitCompleteCb != null)
                m_AssetMapInitCompleteCb();
            AssetsMgr.Instance.InitResidentAssetBundleList(OnResidentAssetBundleListCompleted);
        }
        else
            DebugHelper.LogError("[wboy] Init Dependencies Fail ");
    }

    private void OnResidentAssetBundleListCompleted(bool success)
    {
        Debug.Log("加载启动资源!!!");

        if (success)
        {
            ResourceMgr.Instance.LoadAsset<GameObject>(OnLoadUILanuchCallback, Constants.UIPath, "UILanuch/UILanuch");
        }
        else
        {
            DebugHelper.LogError("加载shader文件出错,请check!!!");
        }
    }



    private void OnLoadUILanuchCallback(GameObject sourceGo, string path_, string[] assetNames)
    {
        try
        {
            Debug.Log("加载 LoginShow ---------------> ");
            InitUILanuch(sourceGo);

            m_LoginAnimator.Play("LoginShow", -1);
            m_LoginAnimator.Update(0);
            m_LoginAnimator.enabled = false;
            float deltaTime = Time.unscaledTime - m_StartTime;
            int time = 500 - Mathf.CeilToInt(deltaTime * 1000);
            if (time <= 0) time = 1;
            m_TimerId = TimerManager.Instance.AddTimer(time, 1, StartUILanuchAnim);
        }
        catch (System.Exception e)
        {
            Debug.LogException(e);
        }
    }

    private void StartUILanuchAnim(int timerSequence)
    {
        TimerManager.Instance.RemoveTimer(timerSequence);
        m_TimerId = 0;
        m_LoginAnimator.enabled = true;
        m_LoginAnimator.Play("LoginShow", -1);
        m_LoginAnimator.Update(0);
        m_TimerId = TimerManager.Instance.AddTimer(2000, 1, OnLoadUILanuchAnimCompleted);
    }

    private void OnLoadUILanuchAnimCompleted(int timerSequence)
    {
        Debug.Log("加载配置  OnLoadUILanuchAnimCompleted ---------------> ");
        // if (StarkSDK.API != null)
        // {
        //     var data = new Dictionary<string, object>()
        //     {
        //         {"eventName", "LoadingBegin1" },
        //     };

        //     StarkSDK.API.ReportAnalytics("LoadingBegin1", data);
        // }


        TimerManager.Instance.RemoveTimer(timerSequence);
        m_TimerId = 0;
        m_LoadingRootGo.SetActive(true);
        SetLoadEffectShowState(true);
        SetLoadDes("");
        SetLoadPrecent(0);
        // FairGuard.Init();
        // 加载配置
        EventMgr.AddEventListener<int>(ECoreEventType.EID_ConfigMgrInit, OnConfigMgrInited);
        ConfigMgr.CreateInstance();
    }

    private void OnConfigMgrInited(CoreEvent<int> ce)
    {
        Debug.Log("加载Lua资源 OnConfigMgrInited ---------------> ");

        EventMgr.RemoveEventListener<int>(ECoreEventType.EID_ConfigMgrInit, OnConfigMgrInited);
        SetLoadDes("GameLogin17");
        SetLoadPrecent(10);
        if (m_AppVolLocalizeScript)
            m_AppVolLocalizeScript.OnChangeLang();
        if (m_ResVolLocalizeScript)
            m_ResVolLocalizeScript.OnChangeLang();
        int result = ce.Data;
        if (result == 1)
        {
            EventMgr.AddEventListener<bool, float>(ECoreEventType.EID_LOAD_LUA_OK, OnLoadLuaOk);
            BattleFormulaParamMgr.CreateInstance();
            LuaMgr.Instance.InitMgr();
        }
        else
        {
            DebugHelper.LogError("加载配置文件出错,请check!!!");
        }
    }

    private void OnLoadLuaOk(CoreEvent<bool, float> ce)
    {
        bool result = ce.Data;
        int precent = Mathf.FloorToInt(Mathf.Clamp01(ce.Data1) * 80) + 10;
        SetLoadPrecent(precent);

        // Debug.Log("加载游戏启动模块 ---------------> ");

        if (result)
        {
            EventMgr.RemoveEventListener<bool, float>(ECoreEventType.EID_LOAD_LUA_OK, OnLoadLuaOk);
            SetLoadDes("GameLogin17");
            NetworkMgr.CreateInstance();
            ModelMgr.Instance.InitMgr();
            TowerBattleCfgMgr.CreateInstance();
            ResourceMgr.Instance.ReadResidentResCfg();
            EventMgr.AddEventListener<int>(ECoreEventType.EID_LOADKEY_OK, OnLoadKeyOk);
            SecurityLayer.Instance.Init();
        }
    }

    private void OnLoadKeyOk(CoreEvent<int> ce)
    {
        Debug.Log("加载Security文件 ---------------> ");

        EventMgr.RemoveEventListener<int>(ECoreEventType.EID_LOADKEY_OK, OnLoadKeyOk);
        SetLoadDes("GameLogin17");
        SetLoadPrecent(90);
        int result = ce.Data;
        if (result == 1)
        {
            EventMgr.AddEventListener<int>(ECoreEventType.EID_CameraMgrInited, OnCameraMgrInited);
            CameraMgr.Instance.InitMgr();
        }
        else
        {
            DebugHelper.LogError("加载Security文件出错,请check!!!");
        }
    }

    private void OnCameraMgrInited(CoreEvent<int> ce)
    {
        Debug.Log("Camera 初始化---------------> ");

        EventMgr.RemoveEventListener<int>(ECoreEventType.EID_CameraMgrInited, OnCameraMgrInited);
        SetLoadDes("GameLogin17");
        SetLoadPrecent(95);
        int result = ce.Data;
        if (result == 1)
        {
            ResourceMgr.Instance.LoadAsset<GameObject>(OnLoadClickEffectCallback, Constants.UIEffectPath, "FX_UI_DianJi");
        }
        else
        {
            DebugHelper.LogError("Camera 初始化失败，请check!!!");
        }
    }

    private void OnLoadClickEffectCallback(GameObject sourceGo, string path_, string[] assetNames_)
    {
        Debug.Log("公共资源加载 ---------------> ");

        SetLoadDes("GameLogin17");
        SetLoadPrecent(99);
        GameObject go = GameObject.Instantiate(sourceGo);
        Transform trans = go.transform;
        trans.SetParent(UIMgr.Instance.ClickEffectTrans);
        trans.localPosition = Vector3.zero;
        trans.localRotation = Quaternion.identity;
        trans.localScale = Vector3.one;
        ResourceMgr.Instance.LoadDirAsset<List<GameObject>>(OnLoadUICommonPrefabCallback, Constants.UICommonPath);
    }

    private void OnLoadUICommonPrefabCallback(List<GameObject> objs, string path_, string[] assetNames_)
    {
        Debug.Log("资源加载完成 进入游戏 ---------------> ");

        SetLoadDes("GameLogin17");
        SetLoadPrecent(100);
        m_IsCompleted = true;
        StopLaunch();
    }













    private GameObject m_LanuchGo;
    private GameObject m_LogoGo;
    private GameObject m_LoginRootGo;
    private Animator m_LoginAnimator;
    private GameObject m_LoadingRootGo;
    private Text m_LoadDesTxt;
    private Text m_LoadPrecentTxt;
    private Scrollbar m_LoadScrollBar;
    private GameObject m_LoadEffectGo;
    private TMPro.TextMeshProUGUI m_AppVolTxt;
    private UILocalizeScript m_AppVolLocalizeScript;
    private TMPro.TextMeshProUGUI m_ResVolTxt;
    private UILocalizeScript m_ResVolLocalizeScript;
    private GameObject m_EditionGo;

    private void InitUILanuch(GameObject sourceGo)
    {
        // 这里初始化保持和UIBase一致，方便后续对象池回收并使用
        GameObject pageBody = new GameObject("UILanuch");
        Canvas canvas = pageBody.AddComponent<Canvas>();

        pageBody.AddComponent<GraphicRaycaster>();
        CanvasGroup canvasGroup = pageBody.AddComponent<CanvasGroup>();
        if (canvasGroup != null)
            canvasGroup.interactable = false;

        pageBody.layer = LayerMask.NameToLayer("UI");

        var pageBodyTrans = pageBody.transform;
        pageBodyTrans.SetParent(UIMgr.Instance.UIRootTrans);
        canvas.overrideSorting = true;

        RectTransform rectTrans = pageBody.GetComponent<RectTransform>();
        if (rectTrans != null)
        {
            rectTrans.localPosition = Vector3.zero;
            rectTrans.localScale = Vector3.one;

            rectTrans.anchorMin = new Vector2(0, 0);
            rectTrans.anchorMax = new Vector2(1.0f, 1.0f);
            rectTrans.pivot = new Vector2(0.5f, 0.5f);
            rectTrans.anchoredPosition = Vector2.zero;
            rectTrans.sizeDelta = Vector2.zero;
        }

        GameObject rootRage = GameObject.Instantiate(sourceGo);
        rootRage.name = "Root";
        rootRage.SetActive(true);
        CommonUtil.SetGameObjectLayer(rootRage, "UI");
        rectTrans = rootRage.GetComponent<RectTransform>();
        rectTrans.SetParent(pageBodyTrans, false);
        rectTrans.localScale = Vector3.one;
        rectTrans.anchorMin = new Vector2(0, 0);
        rectTrans.anchorMax = new Vector2(1.0f, 1.0f);
        rectTrans.pivot = new Vector2(0.5f, 0.5f);
        rectTrans.anchoredPosition3D = Vector3.zero;
        rectTrans.sizeDelta = Vector2.zero;

        m_LanuchGo = pageBody;
        Transform rootTrans = rectTrans.Find("LoginAnim");
        m_LoginAnimator = rootTrans.GetComponent<Animator>();
        m_LogoGo = rootTrans.Find("Logo").gameObject;
        m_LoginRootGo = rootTrans.Find("LoginRoot").gameObject;
        Transform loadingRootTrans = rootTrans.Find("LoadingRoot");
        m_LoadingRootGo = loadingRootTrans.gameObject;
        Transform LoadingBarTrans = loadingRootTrans.Find("LoadingBar");
        m_LoadDesTxt = LoadingBarTrans.Find("Text").GetComponent<Text>();
        m_LoadPrecentTxt = LoadingBarTrans.Find("NumberText").GetComponent<Text>();
        Transform scrollBarTrans = LoadingBarTrans.Find("Scrollbar");
        m_LoadScrollBar = scrollBarTrans.GetComponent<Scrollbar>();
        m_LoadEffectGo = scrollBarTrans.Find("Sliding Area/Handle/Particle").gameObject;

        Transform volTrans = rootTrans.Find("Common/AppVol");
        m_AppVolTxt = volTrans.Find("ContentTxt").GetComponent<TMPro.TextMeshProUGUI>();
        m_AppVolLocalizeScript = volTrans.Find("NameTxt").GetComponent<UILocalizeScript>();
        volTrans = rootTrans.Find("Common/ResVol");
        m_ResVolTxt = volTrans.Find("ContentTxt").GetComponent<TMPro.TextMeshProUGUI>();
        m_ResVolLocalizeScript = volTrans.Find("NameTxt").GetComponent<UILocalizeScript>();
        m_EditionGo = rootTrans.Find("Common/EditionTxt").gameObject;

        m_AppVolTxt.text = GameMgr.Instance.GameVersion;
        m_ResVolTxt.text = GameMgr.Instance.ResVersion;

        m_LogoGo.SetActive(true);
        m_LoginRootGo.SetActive(false);
        m_LoadingRootGo.SetActive(false);
#if HEALTH_BULLETIN
        m_EditionGo.SetActive(true);
#else
        m_EditionGo.SetActive(false);
#endif
        SetLoadEffectShowState(false);
        SetLoadDes("");
        SetLoadPrecent(0);
    }

    private void DisposeUILanuch()
    {
        if (m_LanuchGo)
        {
            ResourceMgr.Instance.RecycleUIGO(Constants.UIPath, "UILanuch/UILanuch_body", m_LanuchGo);
            m_LanuchGo = null;
        }
        m_LogoGo = null;
        m_LoginRootGo = null;
        m_LoadingRootGo = null;
        m_EditionGo = null;
        m_LoadDesTxt = null;
        m_LoadPrecentTxt = null;
        m_LoadScrollBar = null;
        m_LoadEffectGo = null;
        m_AppVolTxt = null;
        m_AppVolLocalizeScript = null;
        m_ResVolTxt = null;
        m_ResVolLocalizeScript = null;
    }

    private void SetLoadEffectShowState(bool state)
    {
        m_LoadEffectGo.SetActive(state);
    }

    private void SetLoadDes(string langKey)
    {
        if (m_LoadDesTxt)
        {
            if (string.IsNullOrEmpty(langKey))
                m_LoadDesTxt.text = "";
            else
                m_LoadDesTxt.text = I18N.T(langKey);
        }
    }

    private void SetLoadPrecent(int precent)
    {
        precent = Mathf.Clamp(precent, 0, 100);
        if (m_LoadPrecentTxt)
            m_LoadPrecentTxt.text = precent + "%";
        if (m_LoadScrollBar)
            m_LoadScrollBar.size = precent * 0.01f;
    }

}
