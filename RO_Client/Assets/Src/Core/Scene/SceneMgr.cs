using UnityEngine;
using System.Collections;
using UnityEngine.SceneManagement;
using System.Collections.Generic;
using LuaInterface;

public class SceneMgr : Singleton<SceneMgr>
{
    private string mMainSceneName;
    private string mCurActiveSceneName;

    private bool isLoadingScene = false;
    private List<string> mAddtivieScenes = new List<string>();

    private List<string> mLoadingScenes = new List<string>();

    private LuaFunction OnSceneLoadedLua;

    public override void Init()
    {
        SceneManager.sceneLoaded += OnSceneLoaded;
        SceneManager.sceneUnloaded += OnSceneUnloaded;
        SceneManager.activeSceneChanged += OnActiveSceneChanged;
    }

    public override void UnInit()
    {
        SceneManager.sceneLoaded -= OnSceneLoaded;
        SceneManager.sceneUnloaded -= OnSceneUnloaded;
        SceneManager.activeSceneChanged -= OnActiveSceneChanged;

        OnSceneLoadedLua = null;
    }

    public string MainSceneName
    {
        get { return mMainSceneName; }
    }

    public void SetOnSceneLoadedLuaFunc(LuaFunction func)
    {
        OnSceneLoadedLua = func;
    }

    public void LoadMainScene(string mainSceneName)
    {
        if (mMainSceneName == mainSceneName)
        {
            NotifySceneLoaded(mainSceneName);
            return;
        }

        if (SceneManager.sceneCountInBuildSettings > 1)
        {
            mMainSceneName = mainSceneName;
            isLoadingScene = true;
            SceneManager.LoadScene(mainSceneName, LoadSceneMode.Single);
        }
        else
        {
            DebugHelper.LogError("场景数量不对:" + SceneManager.sceneCountInBuildSettings);
        }
    }

    public void AsyncLoadMainScene(string mainSceneName)
    {
        Debug.Log("AsyncLoadMainScene " + mainSceneName);
        ResourceMgr.Instance.UnInit();
        MemoryUtil.ReleaseMemory();

        if (mMainSceneName == mainSceneName)
        {
            NotifySceneLoaded(mainSceneName);
            return;
        }

        if (IsLoadingScene(mainSceneName))
        {
            return;
        }

        // AutoStreaming.MarkRecordBegin(mainSceneName);

        mLoadingScenes.Add(mainSceneName);
        isLoadingScene = true;

#if UNITY_EDITOR
        if (!Constants.AssetbundleMode)
            GameMgr.Instance.StartCoroutine(AssetsMgr.Instance.LoadSceneLocalAssetData(mainSceneName));
        else
            GameMgr.Instance.StartCoroutine(AssetsMgr.Instance.LoadSceneAssetbundle(mainSceneName));
#else
        GameMgr.Instance.StartCoroutine(AssetsMgr.Instance.LoadSceneAssetbundle(mainSceneName));
#endif
    }

    public void AsyncLoadAdditiveScene(string sceneName)
    {
        if (IsLoadAdditiveScene(sceneName))
        {
            NotifySceneLoaded(sceneName);
            return;
        }

        if (IsLoadingScene(sceneName))
        {
            return;
        }

        isLoadingScene = true;
        mLoadingScenes.Add(sceneName);

#if UNITY_EDITOR
        if (!Constants.AssetbundleMode)
            GameMgr.Instance.StartCoroutine(AssetsMgr.Instance.LoadSubSceneLocalAssetData(sceneName));
        else
            GameMgr.Instance.StartCoroutine(AssetsMgr.Instance.LoadSubSceneLocalAssetData(sceneName));
#else
        GameMgr.Instance.StartCoroutine(AssetsMgr.Instance.LoadSubSceneLocalAssetData(sceneName));
#endif
    }

    public void RemoveAdditiveScene(string sceneName)
    {
        if (!IsLoadAdditiveScene(sceneName)) return;

        UnloadScene(sceneName);

        mAddtivieScenes.Remove(sceneName);
    }

    public void RemoveAllAdditiveScene()
    {
        for (int idx = mAddtivieScenes.Count - 1; idx >= 0; idx--)
        {
            UnloadScene(mAddtivieScenes[idx]);
        }
        mAddtivieScenes.Clear();
    }

    public void ActiveScene(string sceneName)
    {
        if (mCurActiveSceneName == sceneName) return;

        Scene curScene = SceneManager.GetActiveScene();
        if (curScene != null)
        {
            SetSceneRootVisible(curScene, false);
        }

        Scene scene = SceneManager.GetSceneByName(sceneName);
        if (scene == null)
        {
            DebugHelper.Log(sceneName + " 未加载");
            return;
        }

        SceneManager.SetActiveScene(scene);

        SetSceneRootVisible(scene, true);
    }

    private bool IsLoadAdditiveScene(string sceneName)
    {
        for (int idx = 0; idx < mAddtivieScenes.Count; idx++)
        {
            if (mAddtivieScenes[idx] == sceneName) return true;
        }
        return false;
    }

    private bool IsLoadingScene(string sceneName)
    {
        return mLoadingScenes.Contains(sceneName);
    }

    private void UnloadScene(string sceneName)
    {
        SceneManager.UnloadSceneAsync(sceneName);
    }

    private void OnSceneLoaded(Scene scene, LoadSceneMode mode = LoadSceneMode.Additive)
    {
        isLoadingScene = false;
        string sceneName = scene.name;
        mLoadingScenes.Remove(sceneName);

        if (mode == LoadSceneMode.Single)
        {
            MemoryUtil.ReleaseMemory();
            mMainSceneName = sceneName;
            EventMgr.DispatchEvent(new CoreEvent<string>(ECoreEventType.EID_Scene_Loaded, sceneName));

            if (OnSceneLoadedLua != null)
            {
                OnSceneLoadedLua.Call(this, 0, sceneName);
            }
        }
        else
        {
            SetSceneRootVisible(scene, false);
            AddAddtiveScene(sceneName);
            EventMgr.DispatchEvent(new CoreEvent<string>(ECoreEventType.EID_SubScene_Loaded, sceneName));

            if (OnSceneLoadedLua != null)
            {
                OnSceneLoadedLua.Call(this, 1, sceneName);
            }
        }
    }

    private void SetSceneRootVisible(Scene scene, bool vis)
    {
        GameObject[] rootGoes = scene.GetRootGameObjects();
        for (int idx = 0; idx < rootGoes.Length; idx++)
        {
            rootGoes[idx].SetActive(vis);
        }
    }

    private void OnSceneUnloaded(Scene scene)
    {
        string unloadSceneName = scene.name;

        EventMgr.DispatchEvent(new CoreEvent<string>(ECoreEventType.EID_Scene_Unloaded, unloadSceneName));
    }

    private void OnActiveSceneChanged(Scene oldScene, Scene newScene)
    {
        mCurActiveSceneName = newScene.name;
    }

    private void NotifySceneLoaded(string sceneName)
    {
        EventMgr.DispatchEvent(new CoreEvent<string>(ECoreEventType.EID_Scene_Loaded, sceneName));
    }

    private void AddAddtiveScene(string sceneName)
    {
        if (!IsLoadAdditiveScene(sceneName))
            mAddtivieScenes.Add(sceneName);
    }
}