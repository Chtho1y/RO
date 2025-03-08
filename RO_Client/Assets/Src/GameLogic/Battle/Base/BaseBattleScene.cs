using UnityEngine;
using System.Collections;
using UnityEngine.SceneManagement;

public class BaseBattleScene
{
    protected BaseBattle mBattle;
    protected string mSceneName;
    protected Scene mScene;
    protected bool mHasStartLoad = false;     //是否已经开始加载
    protected bool bLoaded = false;

    public GameObject CameraContainer { get; private set; }

    public GameObject ComingCamera { get; private set; }

    public GameObject StoryCameraGo { get; private set; }

    public Transform CameraTrans { get; private set; }

    public bool IsDisposed { get; private set; }

    public bool IsLoading { get { return mHasStartLoad && !bLoaded; } }

    public bool IsLoaded { get { return mHasStartLoad && bLoaded; } }

    public BaseBattleScene(BaseBattle battle,string sceneName)
    {
        mBattle = battle;
        mSceneName = sceneName;
        IsDisposed = false;
    }

    public void StartLoad()
    {
        if (string.IsNullOrEmpty(mSceneName))
            return;

        mHasStartLoad = true;
        bLoaded = false;
        LoadScene();
        EventMgr.DispatchEvent<bool>(new CoreEvent<bool>(ECoreEventType.EID_LOAD_BEGIN, true));
    }

    void LoadScene(bool isReload = false)
    {
        //开始加载游戏场景
        EventMgr.AddEventListener<string>(ECoreEventType.EID_Scene_Loaded, SceneLoaded);

        SceneMgr.Instance.AsyncLoadMainScene(mSceneName);
    }

    void SceneLoaded(CoreEvent<string> sceneName)
    {
        EventMgr.RemoveEventListener<string>(ECoreEventType.EID_Scene_Loaded, SceneLoaded);

        bLoaded = true;
        mScene = SceneManager.GetSceneByName(mSceneName);
        if (mScene.isLoaded)
        {
            GameObject[] rootObjs = mScene.GetRootGameObjects();

            CameraContainer = rootObjs.FindFirst(a => a.name.CompareTo(Constants.go_name_camera_target) == 0);
            if (CameraContainer != null)
            {
                Camera cam = CameraContainer.GetComponentInChildren<Camera>();
                if (cam != null)
                {
                    if(cam.cullingMask == 0)
                    {
                        cam.cullingMask = BattleCamera.Instance.CullingMask;
                    }
                    CameraTrans = cam.transform;
                }
            }

            GameObject designGo = rootObjs.FindFirst(a => a.name.CompareTo(Constants.design_go) == 0);
            if (designGo)
            {
                GlobalTrigger globalTrigger = designGo.GetComponent<GlobalTrigger>();
                if (globalTrigger)
                {
                    mBattle.globalTrigger = globalTrigger;
                }
            }

            ComingCamera = GameObject.Find(Constants.coming_camera_target);
            OnSceneLoaded();
        }
    }

    public virtual void OnSceneLoaded()
    {

    }

    public virtual void SetSceneOjbVis(SceneObjData obj)
    {

    }

    public virtual void Dispose()
    {
        if (IsDisposed)
            return;

        mBattle = null;
        CameraContainer = null;
        IsDisposed = true;
        mHasStartLoad = false;
        bLoaded = false;
    }
}
