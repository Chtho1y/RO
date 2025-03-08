using LuaInterface;
using System;
using System.Collections.Generic;
using UnityEngine;

public class ModelMgr : SingletonMono<ModelMgr>
{
    private GameObject modelRoot;
    public GameObject ModelRoot
    {
        get { return modelRoot; }
    }

    private LuaTable luaTable; 
    private Action<LuaTable, List<GameObject>, object[]> OnLoadedCompleted;
    private object[] param;

    public override void InitMgr()
    {
        modelRoot = GameObject.Find("ModelRoot");
        if (modelRoot == null)
        {
            modelRoot = new GameObject("ModelRoot");
        }

        DontDestroyOnLoad(modelRoot);
    }

    public void CreateModel(int[] ids, LuaTable table, Action<LuaTable, List<GameObject>, object[]> cb, params object[] param)
    {
        string assetPath = Constants.ModelPath;
        string[] assetNames = new string[ids.Length];
        for (int i = 0; i < ids.Length; ++i)
        {
            string name = ConfigMgr.Instance.getValue(ids[i], "AvatarPrefab", "AvatarCfg");
            assetNames[i] = name;
        }

        luaTable = table;
        OnLoadedCompleted = cb;
        this.param = param;

        ResourceMgr.Instance.LoadAsset<List<GameObject>>(OnLoadModelCompleted, assetPath, assetNames);
    }

    void OnLoadModelCompleted(List<GameObject> prefabs, string assetPath, params string[] assetName)
    {
        List<GameObject> list = new List<GameObject>();
        for (int i = 0; i < assetName.Length; ++i)
        {
            GameObject go = GameObject.Instantiate(prefabs[i]);
            go.transform.SetParent(modelRoot.transform);
            go.transform.localPosition = Vector3.zero;

            list.Add(go);
        }

        if (OnLoadedCompleted != null)
        {
            if (luaTable != null)
                OnLoadedCompleted(luaTable, list, param);

            OnLoadedCompleted = null;
        }
        luaTable = null;
        param = null;
    }
    
}