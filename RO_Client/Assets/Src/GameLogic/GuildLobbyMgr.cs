using UnityEngine;
using System.Collections;
using LuaInterface;
using UnityEngine.SceneManagement;

public class GuildLobbyMgr : Singleton<GuildLobbyMgr>
{
    private LuaTable mLuaGuildLobbyMgr = null;

    private bool bLoaded = false;
    private bool mHasStartLoad = false;

    [HideInInspector]
    public LuaTable LuaGuildLobbyMgr
    {
        set { mLuaGuildLobbyMgr = value; }
        get { return mLuaGuildLobbyMgr; }
    }

    public override void Init()
    {
        base.Init();
        RegisterEvents();
    }

    public override void UnInit()
    {
        base.UnInit();
        UnregisterEvents();
    }

    public void Clear()
    {
        mHasStartLoad = false;
        bLoaded = false;
    }

    public void Dispose()
    {
        Clear();
    }

    private void RegisterEvents()
    {
    }

    private void UnregisterEvents()
    {

    }

    public void EnterGuildLobby()
    {
        if (mHasStartLoad) return;

        mHasStartLoad = true;
        LoadScene();
    }

    private void LoadScene()
    {
        EventMgr.AddEventListener<string>(ECoreEventType.EID_Scene_Loaded, OnSceneLoaded);
        EventMgr.DispatchEvent<bool>(new CoreEvent<bool>(ECoreEventType.EID_LOAD_BEGIN, true));
        SceneMgr.Instance.AsyncLoadMainScene("scene_prontera_02");
        
    }

    private void OnSceneLoaded(CoreEvent<string> sceneName)
    {
        EventMgr.RemoveEventListener<string>(ECoreEventType.EID_Scene_Loaded, OnSceneLoaded);
        bLoaded = true;
        mHasStartLoad = false;
        EventMgr.DispatchEvent<bool>(new CoreEvent<bool>(ECoreEventType.EID_LOAD_COMPLETE, true));
    }
}
