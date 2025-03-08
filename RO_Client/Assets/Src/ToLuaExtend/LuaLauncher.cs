using UnityEngine;
using System;
using System.Threading;
using LuaInterface;

public class LuaLauncher : LuaClient
{
    private volatile float precent;

    new void Awake()
    {
        base.Awake();
    }

    public override void Destroy()
    {
        StopAsync();
        base.Destroy();
    }

    protected override LuaFileUtils InitLoader()
    {
        return new LuaResLoader();
    }

    protected override void OnLoadFinished()
    {
        luaState.Start();
        StartMain();
    }

    protected override void CallMain()
    {
        StartLooper();
        LuaMgr.Instance.CallMain();
    }

    protected override void StartMain()
    {
        if (LaunchThread.HasInstance())
        {
            LaunchThread.Instance.Start(LaunchThread.AsyncLaunchState.LuaInit, LuaMgr.Instance.StartMain, CallMain, UpdateTimer);
        }
    }

    private void UpdateTimer()
    {
        EventMgr.DispatchEvent<bool, float>(new CoreEvent<bool, float>(ECoreEventType.EID_LOAD_LUA_OK, false, precent));
    }
    public void StartMainPrecent(float precent)
    {
        this.precent = precent;
    }

    public void StartMainComplete()
    {
        EventMgr.DispatchEvent<bool, float>(new CoreEvent<bool, float>(ECoreEventType.EID_LOAD_LUA_OK, true, 1));
    }

    public void StopAsync()
    {
        if (LaunchThread.HasInstance())
        {
            LaunchThread.Instance.Stop(LaunchThread.AsyncLaunchState.LuaInit);
        }
    }
}
