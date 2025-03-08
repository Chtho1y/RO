using LuaInterface;
using System;
using System.IO;
using System.Text;
using UnityEngine;
using System.Collections.Generic;

public class LuaMgr : SingletonMono<LuaMgr>
{
    private Dictionary<string, byte[]> LuaDic = new Dictionary<string, byte[]>();
    private Dictionary<string, byte[]> luaPbDic = new Dictionary<string, byte[]>();
    private int LoadCount = 0;
    private int LuaDirCount = 3;
    public LuaState luaState = null;
    protected LuaLooper loop = null;
    protected LuaTable luaMainTable = null;

    LuaLauncher luaLauncher = null;
    string LuaMainPath = "Lua/Core";
    bool bDisposed = false;
    string luaRootPath = string.Empty;

    public override void InitMgr()
    {
        base.InitMgr();
        LoadLuaFiles();
    }

    public void Clear()
    {
        Dispose();
    }

    protected override void Dispose()
    {
        if (bDisposed) return;
        if (luaLauncher)
        {
            luaLauncher.StopAsync();
        }
        Destroy();
        LoadCount = 0;
        LuaDic.Clear();
        luaPbDic.Clear();
        bDisposed = true;
        base.Dispose();
    }

    void LoadLuaFiles()
    {
#if UNITY_EDITOR
        if (!Constants.AssetbundleMode)
        {
            LuaDirCount = 1;
            ResourceMgr.Instance.LoadLuaAsset(OnLoadPbCallback, Constants.LuaPbDir);
        }
        else if (Constants.AssetbundleMode)
#endif
        {
            ResourceMgr.Instance.LoadLuaAsset(OnCallBack, Constants.ABLuaDir);
            ResourceMgr.Instance.LoadLuaAsset(OnCallBack, Constants.ABLuaLogicDir);
            ResourceMgr.Instance.LoadLuaAsset(OnLoadPbCallback, Constants.ABLuaPbDir);
        }
    }

    private void OnCallBack(List<TextAsset> objs, string dir, string[] assetNames)
    {
        if (objs == null || objs.Count <= 0)
        {
            DebugHelper.Log("No LuaMgr AssetBundle");
            return;
        }
        for (int i = 0; i < objs.Count; ++i)
        {
            TextAsset tx = objs[i];

            if (tx != null && LuaDic.ContainsKey(tx.name))
            {
                //DebugHelper.LogError(string.Format("LuaDic.ContainsKey {0}", tx.name));
                LuaDic.Remove(tx.name);
            }

            LuaDic.Add(tx.name, tx.bytes);
        }
        LoadCount++;
        if (LoadCount == LuaDirCount)
        {
            OnLoadFinished();
        }
    }

    private void OnLoadPbCallback(List<TextAsset> objs, string dir, string[] assetNames)
    {
        if (objs == null || objs.Count <= 0)
        {
            DebugHelper.Log("No LuaMgr AssetBundle");
            return;
        }
        for (int i = 0; i < objs.Count; ++i)
        {
            TextAsset tx = objs[i];

            if (tx != null && tx.name.Contains(".lua"))
            {
                continue;
            }

            if (tx != null && luaPbDic.ContainsKey(tx.name))
            {
                //DebugHelper.LogError(string.Format("LuaDic.ContainsKey {0}", tx.name));
                luaPbDic.Remove(tx.name);
            }

            if (tx != null)
                luaPbDic.Add(tx.name, tx.bytes);
        }
        LoadCount++;
        if (LoadCount == LuaDirCount)
        {
            OnLoadFinished();
        }
    }

    void OnLoadFinished()
    {
        if (Application.isEditor)
        {
            luaRootPath = Application.dataPath;
        }
        else if (Application.platform == RuntimePlatform.WindowsPlayer ||
                 Application.platform == RuntimePlatform.OSXPlayer)
        {
            luaRootPath = Application.streamingAssetsPath;
        }
        luaLauncher = this.GetOrAddComponent<LuaLauncher>();
    }

    public void CallMain()
    {
        CallLuaFunc("Start");
    }

    public void StartMain()
    {
        luaState = LuaClient.Instance.luaState;
        AddLuaSearchPath(LuaMainPath);
        luaMainTable = luaState.DoFile<LuaTable>("LuaMain.lua");
        CallLuaFunc("Init");
    }

    public void StartMainPrecent(float precent)
    {
        luaLauncher.StartMainPrecent(precent);
        //EventMgr.DispatchEvent<bool, float>(new CoreEvent<bool, float>(ECoreEventType.EID_LOAD_LUA_OK, false, precent));
    }

    public void StartMainComplete()
    {
        luaLauncher.StartMainComplete();
        //EventMgr.DispatchEvent<bool, float>(new CoreEvent<bool, float>(ECoreEventType.EID_LOAD_LUA_OK, true, 1));
    }

    public void EnterLogin(bool relogin)
    {
        if (luaMainTable != null)
        {
            LuaFunction tableFunc = luaMainTable.GetLuaFunction("EnterLogin");
            tableFunc.Call(luaMainTable, relogin);
            tableFunc.Dispose();
            tableFunc = null;
        }
    }

    public void LuaGC()
    {
        DebugHelper.Log("LuaGC");
        luaState.LuaGC(LuaGCOptions.LUA_GCCOLLECT);
    }

    void CallLuaFunc(string funcName)
    {
        if (luaMainTable != null)
        {
            //DebugHelper.LogError("funcName:" + funcName);
            //luaMainTable.Call(funcName);
            LuaFunction tableFunc = luaMainTable.GetLuaFunction(funcName);
            tableFunc.Call(luaMainTable);
            tableFunc.Dispose();
            tableFunc = null;
        }
    }


    public void Destroy()
    {
        if (luaMainTable != null)
        {
            CallLuaFunc("Destroy");

            luaMainTable = null;
        }
    }

    public static LuaState GetMainState()
    {
        return Instance.luaState;
    }

    public LuaLooper GetLooper()
    {
        return loop;
    }

    public List<LuaByteBuffer> GetPbFiles()
    {
        if (luaPbDic == null) return null;

        List<LuaByteBuffer> pbFiles = new List<LuaByteBuffer>();
        foreach (var p in luaPbDic)
        {
            //string content = p.Value;
            //byte[] data = Encoding.Default.GetBytes(content);
            byte[] data = p.Value;

            LuaByteBuffer luaByte = new LuaByteBuffer(data);
            pbFiles.Add(luaByte);
        }
        return pbFiles;
    }

    public void AddLuaSearchPath(string path)
    {
        if (!Path.IsPathRooted(path))
        {
            if (!string.IsNullOrEmpty(luaRootPath))
            {
                luaState.AddSearchPath(luaRootPath + "/" + path);
            }
        }
        else
        {
            Debug.LogError("2==== " + path);
            luaState.AddSearchPath(path);
        }
    }

    public byte[] GetLuaTextAsset(string name)
    {
        if (LuaDic.ContainsKey(name))
        {
            return LuaDic[name];
        }
        else
        {
            DebugHelper.LogError("Not Found LuaTextAssetName: {0}", name);
            return null;
        }
    }
}