using UnityEngine;
using System.IO;
using System.Collections.Generic;
using UnityEngine.Playables;
using UnityEngine.Video;
using LuaInterface;

public delegate void ResourceLoadCallback<T>(T o, string assetPath, params string[] assetNames);

public delegate void ResourceLoadCallbackWithSeqId<T>(T o, long seqId,string assetPath,object[] userdatas, params string[] assetNames);

public class ResourceInfo
{
    private string path;
    private string name;
    private Object asset;
    private float lastUsedTime;

    public string Path
    {
        get { return path; }
    }

    public string Name
    {
        get { return name; }
    }

    public Object Asset
    {
        get { return asset; }
    }

    public float LastUsedTime
    {
        get { return lastUsedTime; }
        set
        {
            lastUsedTime = value;
        }
    }

    public ResourceInfo(string path_, string name_, Object asset_)
    {
        path = path_;
        name = name_;
        asset = asset_;
        lastUsedTime = Time.time;
    }

    public Object Reuse()
    {
        lastUsedTime = Time.time;
        return asset;
    }

    public void Dispose()
    {
        asset = null;
    }
}

public class LoadingResourceInfo
{
    System.Type delegateType;
    public System.Type DelegateType
    {
        get { return delegateType; }
    }

    System.Delegate callback;
    public System.Delegate Callback
    {
        get { return callback; }
    }

    string assetPath;
    public string AssetPath
    {
        get { return assetPath; }
    }

    string assetName;
    public string AssetName
    {
        get { return assetName; }
    }

    string[] assetNames;
    public string[] AssetNames
    {
        get { return assetNames; }
    }

    long mSeqId = 0;
    public long SeqId
    {
        get { return mSeqId; }
    }

    bool mReturnSeqId = false;
    public bool ReturnSeqId
    {
        get { return mReturnSeqId; }
    }

    int mLoadNum = 0;
    public int LoadCBNum
    {
        get { return mLoadNum; }
        set { mLoadNum = value; }
    }

    public object[] userDatas;

    public LoadingResourceInfo(long seqId, string path_, System.Delegate callback_, System.Type delegateType_, bool returnSeq,params string[] assetNames_)
    {
        mSeqId = seqId;
        assetPath = path_;
        callback = callback_;
        assetNames = assetNames_;
        delegateType = delegateType_;
        mReturnSeqId = returnSeq;
    }

    public void Dispose()
    {
        callback = null;
        assetNames = null;
    }
}

public class ResourceMgr : Singleton<ResourceMgr>
{
    long loadingSeqId = 0;

    //对象池
   Dictionary<string, Dictionary<string, GameObjectPool<GameObject>> > assetsPool = new Dictionary<string, Dictionary<string, GameObjectPool<GameObject>>>();

    //已加载的资源列表
    List<ResourceInfo> loadedResources = new List<ResourceInfo>();

    //正在加载的资源
    List<LoadingResourceInfo> loadingResources = new List<LoadingResourceInfo>();

    const float check_internal = 60;

    const float cache_Time = 300;

    float lastCheckTime = 0;

    [NoToLua]
    public override void Init()
    {
        lastCheckTime = Time.time;
    }

    [NoToLua]
    public override void UnInit()
    {
        ClearAllResource();
    }

    private GameObject mPoolGo = null;
    public Transform PoolNode
    {
        get
        {

            if (mPoolGo == null)
            {
                mPoolGo = new GameObject("PoolRoot");
                if (GameMgr.Instance != null) { 
                    mPoolGo.transform.SetParent(GameMgr.Instance.transform);
                }
                mPoolGo.SetActive(false);
            }

            return mPoolGo.transform;
        }
    }
    #region outer_methods
    //已经在的资源个数
    [NoToLua]
    public int LoadedResourceCnt
    {
        get { return loadedResources.Count; }
    }

    //正在加载的资源个数
    [NoToLua]
    public int LoadingResourceCnt
    {
        get { return loadingResources.Count; }
    }

    [NoToLua]
    public GameObject GetGOFromResources(string assetName)
    {
        GameObject prefab = LoadObjFromResources<GameObject>(assetName);
        if (prefab == null) return null;
        //DebugHelper.LogError("AssetName " + assetName);
        return GameObject.Instantiate(prefab);
    }

    [NoToLua]
    public T LoadObjFromResources<T>(string assetName) where T : UnityEngine.Object
    {
        return AssetsMgr.Instance.GetAssetFromResources<T>(assetName);
    }

    [NoToLua]
    public void LoadLuaAsset(ResourceLoadCallback<List<TextAsset>> cb, string pathName)
    {
        loadingSeqId++;
        LoadingResourceInfo lri = new LoadingResourceInfo(loadingSeqId, pathName, cb as System.Delegate, typeof(List<TextAsset>), false, null);
        loadingResources.Add(lri);

        lri.LoadCBNum =  AssetsMgr.Instance.GetAsset<List<TextAsset>>(OnLoadDirAssetallback, ELoadType.OTHER, loadingSeqId, pathName);
    }

    [NoToLua]
    public void LoadDirAsset<T>(ResourceLoadCallback<T> cb, string pathName, ELoadType type = ELoadType.OTHER)
    {
        if (string.IsNullOrEmpty(pathName)) return;

        if (ExistAssetPath(pathName))
        {
            FinishResourceLoad(cb, typeof(T), pathName, null,false,0,null);
            return;
        }

        loadingSeqId++;
        LoadingResourceInfo lri = new LoadingResourceInfo(loadingSeqId, pathName, cb as System.Delegate, typeof(T), false,null);
        loadingResources.Add(lri);

        lri.LoadCBNum = AssetsMgr.Instance.GetAsset<T>(OnLoadDirAssetallback, type, loadingSeqId, pathName);
    }

    #region methods_for_lua
    public long LoadAssetSprite(string pathName, ELoadType type, ResourceLoadCallbackWithSeqId<Sprite> cb, params string[] assetNames)
    {
        return LoadAsset(cb, pathName, type, null,assetNames);
    }

    public long LoadAssetSprites(string pathName, ELoadType type, ResourceLoadCallbackWithSeqId<List<Sprite>> cb, params string[] assetNames)
    {
        return LoadAsset(cb, pathName, type, null, assetNames);
    }

    public long LoadAssetSpriteWithUserData(string pathName, ELoadType type,object[] userDatas, ResourceLoadCallbackWithSeqId<Sprite> cb, params string[] assetNames)
    {
        return LoadAsset(cb, pathName, type, userDatas,assetNames);
    }

    public long LoadAssetGameObject(string pathName, ELoadType type, ResourceLoadCallbackWithSeqId<GameObject> cb, params string[] assetNames)
    {
        return LoadAsset(cb, pathName, type, null,assetNames);
    }

    public long LoadAssetGameObjectWithUserData(string pathName, ELoadType type, object[] userDatas, ResourceLoadCallbackWithSeqId<GameObject> cb, params string[] assetNames)
    {
        return LoadAsset(cb, pathName, type,userDatas ,assetNames);
    }

    public long LoadAssetGameObjects(string pathName, ELoadType type, ResourceLoadCallbackWithSeqId<List<GameObject>> cb, params string[] assetNames)
    {
        return LoadAsset(cb, pathName, type,null, assetNames);
    }

    public long LoadAssetGameObjectsWithUserData(string pathName, ELoadType type, object[] userDatas, ResourceLoadCallbackWithSeqId<List<GameObject>> cb, params string[] assetNames)
    {
        return LoadAsset(cb, pathName, type, userDatas, assetNames);
    }

    public long LoadAssetRuntimeAnimatorControllers(string pathName, ELoadType type, ResourceLoadCallbackWithSeqId<List<RuntimeAnimatorController>> cb, params string[] assetNames)
    {
        return LoadAsset(cb, pathName, type,null, assetNames);
    }

    public long LoadAssetRuntimeAnimatorControllersWithUserData(string pathName, ELoadType type, object[] userDatas, ResourceLoadCallbackWithSeqId<List<RuntimeAnimatorController>> cb, params string[] assetNames)
    {
        return LoadAsset(cb, pathName, type, userDatas,assetNames);
    }

    public long LoadAssetMaterial(string pathName, ELoadType type, ResourceLoadCallbackWithSeqId<Material> cb, params string[] assetNames)
    {
        return LoadAsset(cb, pathName, type, null,assetNames);
    }

    public long LoadAssetMaterialWithUserData(string pathName, ELoadType type, object[] userDatas, ResourceLoadCallbackWithSeqId<Material> cb, params string[] assetNames)
    {
        return LoadAsset(cb, pathName, type, userDatas, assetNames);
    }

    public long LoadAssetTexture(string pathName, ELoadType type, ResourceLoadCallbackWithSeqId<Texture2D> cb, params string[] assetNames)
    {
        return LoadAsset(cb, pathName, type, null, assetNames);
    }

    public long LoadAssetTextureWithUserData(string pathName, ELoadType type, object[] userDatas, ResourceLoadCallbackWithSeqId<Texture2D> cb, params string[] assetNames)
    {
        return LoadAsset(cb, pathName, type, userDatas, assetNames);
    }

    public long LoadAsset<T>(ResourceLoadCallbackWithSeqId<T> cb, string pathName, ELoadType type, object[] userDatas, params string[] assetNames)
    {
        return Inner_LoadAsset(cb, pathName, assetNames, type, userDatas);
    }

    public Sprite FindSpriteByPathAndName(string pathName, string assetName)
    {
        return FindAssetByPathAndName<Sprite>(pathName, assetName);
    }

    #endregion

    public long LoadAsset<T>(ResourceLoadCallback<T> cb, string pathName, ELoadType type, params string[] assetNames)
    {
        return Inner_LoadAsset(cb, pathName, assetNames, type);
    }

    public long LoadAsset<T>(ResourceLoadCallback<T> cb, string pathName, params string[] assetNames)
    {
        return Inner_LoadAsset(cb, pathName, assetNames, ELoadType.OTHER);
    }

    public Object[] LoadABSync(string pathName, params string[] assetNames)
    {
        return AssetsMgr.Instance.LoadABSync(pathName, assetNames);
    }

    public T LoadAssetSync<T>(string assetPath, string assetName) where T : UnityEngine.Object
    {
        T ret = null;
        Object obj = FindAssetByPathAndName(assetPath, assetName);
        if (obj == null)
        {
            ret = AssetsMgr.Instance.LoadAssetSync<T>(assetPath, assetName);
            ResourceInfo ri = new ResourceInfo(assetPath, assetName, ret);
            loadedResources.Add(ri);
        }
        else
        {
            ret = obj as T;
        }

        return ret;
    }

    /// <summary>
    /// 从对象池中获取对象
    /// </summary>
    /// <param name="assetsPath"></param>
    /// <param name="assetsName"></param>
    /// <param name="action"></param>
    public long GetGOFromPool(string assetsPath, string assetsName, System.Action<GameObject> action = null)
    {
        if (action == null || string.IsNullOrEmpty(assetsName)) return 0;

        if(!string.IsNullOrEmpty(assetsPath))
        {
            Dictionary<string, GameObjectPool<GameObject>> mDirGoPool;
            if (assetsPool.TryGetValue(assetsPath, out mDirGoPool))
            {
                GameObjectPool<GameObject> curPool = null;
                mDirGoPool.TryGetValue(assetsName, out curPool);
                if (curPool == null)
                {
                    curPool = new GameObjectPool<GameObject>();
                    mDirGoPool.Add(assetsName, curPool);
                }
                GameObject go = curPool.Spawn();
                if (go != null)
                {
                    action(go);
                    return 0;
                }
            }
        }

        ResourceLoadCallback<GameObject> callBack = (prefab, path_, assetName_) =>
        {
            if (null == prefab)
            {
                if (action != null)
                    action(null);
                return;
            }


            if (action != null)
            {
                GameObject goInst = GameObject.Instantiate(prefab);
                goInst.transform.localPosition = Vector3.zero;
                goInst.transform.localScale = Vector3.one;
                goInst.name = assetsName;
                action(goInst);
            }
        };
        return LoadAsset<GameObject>(callBack, assetsPath, assetsName);
    }

    
    public long GetGoesFromPool(string assetsPath,string[] assetsNames, ResourceLoadCallback<List<GameObject>> cb)
    {
        if (cb == null || string.IsNullOrEmpty(assetsPath) || assetsNames == null || assetsNames.Length == 0) return 0;

        Dictionary<string, GameObjectPool<GameObject>> mDirGoPool;
        if (assetsPool.TryGetValue(assetsPath, out mDirGoPool))
        {
            List<GameObject> goList = new List<GameObject>();
            int cnt = 0;
            GameObjectPool<GameObject> curPool = null;
            for(int idx =0; idx < assetsNames.Length;idx++)
            {
                mDirGoPool.TryGetValue(assetsNames[idx], out curPool);
                if (curPool == null)
                {
                    curPool = new GameObjectPool<GameObject>();
                    mDirGoPool.Add(assetsNames[idx], curPool);
                }
                GameObject go = curPool.Spawn();
                if (go != null)
                {
                    goList.Add(go);
                }
                else
                {
                    cnt = idx;
                    break;
                }
            }
            if(goList.Count == assetsNames.Length)
            {
                cb(goList, assetsPath, assetsNames);
                return 0;
            }
            else
            {
                for(int idx =0; idx <cnt;idx++)
                {
                    RecycleGO(assetsPath, assetsNames[idx],goList[idx]);
                }
                goList.Clear();
                goList = null;
            }
        }

        ResourceLoadCallback<List<GameObject>> callBack = (prefabs, path_, assetName_) =>
        {
            if (null == prefabs)
            {
                if (cb != null)
                    cb(null, path_, assetName_);
                return;
            }


            if (cb != null)
            {
                List<GameObject> goInstList = new List<GameObject>();
                for(int idx =0;idx < prefabs.Count;idx++)
                {
                    GameObject goInst = GameObject.Instantiate(prefabs[idx]);
                    goInst.transform.localPosition = Vector3.zero;
                    goInst.transform.localScale = Vector3.one;
                    goInst.name = assetName_[idx];
                    goInstList.Add(goInst);
                }
                cb(goInstList, path_, assetName_);
            }
        };
        return LoadAsset<List<GameObject>>(callBack, assetsPath, assetsNames);
    }

    public GameObject GetGoFromPool(string assetPath, string assetName)
    {
        if (string.IsNullOrEmpty(assetName))
            return null;

        GameObject go = null;
        if (!string.IsNullOrEmpty(assetPath))
        {
            Dictionary<string, GameObjectPool<GameObject>> mDirGoPool;
            if (assetsPool.TryGetValue(assetPath, out mDirGoPool))
            {
                GameObjectPool<GameObject> curPool = null;
                mDirGoPool.TryGetValue(assetName, out curPool);
                if (curPool == null)
                {
                    curPool = new GameObjectPool<GameObject>();
                    mDirGoPool.Add(assetName, curPool);
                }
                go = curPool.Spawn();
                if (go != null)
                {
                    return go;
                }
            }
        }
        
       
        GameObject prefab = (GameObject)FindAssetByPathAndName(assetPath, assetName);
        if(prefab == null)
        {
            prefab = ResourceMgr.Instance.LoadAssetSync<GameObject>(assetPath, assetName);
        }
        if(prefab != null)
        {
            go = GameObject.Instantiate(prefab);
        }
        return go;
    }

    public GameObject GetUIGoFromPool(string assetPath, string assetName)
    {
        if (string.IsNullOrEmpty(assetName))
            return null;

        if (!string.IsNullOrEmpty(assetPath))
        {
            Dictionary<string, GameObjectPool<GameObject>> mDirGoPool;
            if (assetsPool.TryGetValue(assetPath, out mDirGoPool))
            {
                GameObjectPool<GameObject> curPool = null;
                mDirGoPool.TryGetValue(assetName, out curPool);
                if (curPool == null)
                {
                    curPool = new GameObjectPool<GameObject>();
                    mDirGoPool.Add(assetName, curPool);
                }
                GameObject go = curPool.Spawn();
                if (go != null)
                {
                    return go;
                }
            }
        }
        return null;
    }

    public void SetGoPoolMaxCacheNum(string assetPath, string assetName,int num)
    {
        if (string.IsNullOrEmpty(assetPath) || string.IsNullOrEmpty(assetName)) return;
        
        Dictionary<string, GameObjectPool<GameObject>> mDirGoPool;
        if(assetsPool.TryGetValue(assetPath,out mDirGoPool))
        {
            GameObjectPool<GameObject> curPool = null;
            mDirGoPool.TryGetValue(assetName, out curPool);
            if (curPool == null)
            {
                curPool = new GameObjectPool<GameObject>();
                mDirGoPool.Add(assetName, curPool);
            }
            curPool.SetMaxCacheNum(num);
        }
        else
        {
            mDirGoPool = new Dictionary<string, GameObjectPool<GameObject>>();
            GameObjectPool<GameObject> curPool = new GameObjectPool<GameObject>();
            curPool.SetMaxCacheNum(num);
            mDirGoPool.Add(assetName, curPool);
            assetsPool.Add(assetPath, mDirGoPool);
        }
    }

    public Object GetAsset(string assetPath,string assetName)
    {
        if(string.IsNullOrEmpty(assetName))
        {
            return null;
        }
        return FindAssetByPathAndName(assetPath, assetName);
    }

    public void RecycleUIGO(string assetPath, string assetName, GameObject go)
    {
        if (go == null) return;

        if (string.IsNullOrEmpty(assetName) || string.IsNullOrEmpty(assetPath))
        {
            GameObject.Destroy(go);
            go = null;
            return;
        }

        Dictionary<string, GameObjectPool<GameObject>> mDirGoPool = null;
        if (assetsPool.TryGetValue(assetPath, out mDirGoPool))
        {
            GameObjectPool<GameObject> curPool = null;
            if (mDirGoPool.TryGetValue(assetName, out curPool))
            {
                go.transform.SetParent(UIMgr.Instance.UIRootTrans);
                //CommonUtil.SetGameObjectLayer(go, "Hide");
                go.SetActive(false);
                curPool.Recycle(go);
                return;
            }
            else
            {
                curPool = new GameObjectPool<GameObject>();
                mDirGoPool.Add(assetName, curPool);
                go.transform.SetParent(UIMgr.Instance.UIRootTrans);
                //CommonUtil.SetGameObjectLayer(go, "Hide");
                go.SetActive(false);
                curPool.Recycle(go);
            }
        }
        else
        {
            mDirGoPool = new Dictionary<string, GameObjectPool<GameObject>>();
            GameObjectPool<GameObject> curPool = new GameObjectPool<GameObject>();
            mDirGoPool.Add(assetName, curPool);
            assetsPool.Add(assetPath, mDirGoPool);

            go.transform.SetParent(UIMgr.Instance.UIRootTrans);
            //CommonUtil.SetGameObjectLayer(go, "Hide");
            go.SetActive(false);
            curPool.Recycle(go);
        }
    }

    public void RecycleGO(string assetPath,string assetName, GameObject go)
    {
        if (go == null) return;

        if (string.IsNullOrEmpty(assetName) || string.IsNullOrEmpty(assetPath))
        {
            GameObject.Destroy(go);
            go = null;
            return;
        }

        Dictionary<string, GameObjectPool<GameObject>> mDirGoPool = null;
        if(assetsPool.TryGetValue(assetPath, out mDirGoPool))
        {
            GameObjectPool<GameObject> curPool = null;
            if (mDirGoPool.TryGetValue(assetName, out curPool))
            {
                go.transform.SetParent(PoolNode);
                curPool.Recycle(go);
                return;
            }
            else
            {
                curPool = new GameObjectPool<GameObject>();
                mDirGoPool.Add(assetName, curPool);
                go.transform.SetParent(PoolNode);
                curPool.Recycle(go);
            }
        }
        else
        {
            mDirGoPool = new Dictionary<string, GameObjectPool<GameObject>>();
            GameObjectPool<GameObject> curPool = new GameObjectPool<GameObject>();
            mDirGoPool.Add(assetName, curPool);
            assetsPool.Add(assetPath, mDirGoPool);

            go.transform.SetParent(PoolNode);
            curPool.Recycle(go);
        }
    }

    public void UnloadAssetBySeqId(long seqId)
    {
        RemoveLoadingCb(seqId);
    }

    [NoToLua]
    public void CleanGOPool()
    {
        foreach (var p in assetsPool)
        {
            Dictionary<string, GameObjectPool<GameObject>> poolDic = p.Value;
            foreach(var list in poolDic)
            {
                GameObjectPool<GameObject> goPool = list.Value;
                goPool.Dispose();
            }
        }
        assetsPool.Clear();
    }

    public Shader FindShader(string shaderName,string shaderPath)
    {
        return AssetsMgr.Instance.FindShader(shaderName, shaderPath);
    }
    #endregion

    [NoToLua]
    public void Update()
    {
        //if (LoadedResourceCnt == 0) return;

        //float curTime = Time.time;
        //if (curTime - lastCheckTime >= check_internal)
        //{
        //    ClearLongTimeUnusedResource(curTime);
        //    lastCheckTime = curTime;
        //}
    }


    #region inner_methods
    void RemoveLoadingCb(long seqId)
    {
        LoadingResourceInfo lri = FindLoadingResourceInfoBySeqId(seqId);
        if (lri != null)
        {
            AssetsMgr.Instance.CancelLoadAsset(seqId);
            lri.Dispose();
            loadingResources.Remove(lri);
        }
    }

    LoadingResourceInfo FindLoadingResourceInfoBySeqId(long seqId)
    {
        for (int idx = 0; idx < loadingResources.Count; idx++)
        {
            LoadingResourceInfo lri = loadingResources[idx];
            if (lri.SeqId == seqId) return lri;
        }

        return null;
    }

    public bool HasAsset(string path,string assetName)
    {
        if (string.IsNullOrEmpty(assetName)) return false;

        Object obj = FindAssetByPathAndName(path, assetName);
        return obj != null;
    }

    bool ExistAssets(string path, string[] assetNames)
    {
        if (assetNames == null || assetNames.Length == 0) return false;

        bool find = false;

        for (int idx = 0; idx < assetNames.Length; idx++)
        {
            Object obj = FindAssetByPathAndName(path, assetNames[idx]);
            if (obj == null) return false;
            find = true;
        }

        return find;
    }

    bool ExistAssetPath(string path)
    {
        for (int idx = 0; idx < loadedResources.Count; idx++)
        {
            ResourceInfo ri = loadedResources[idx];
            if (ri.Path == path)
            {
                return true;
            }
        }
        return false;
    }

    Object FindAssetByPathAndName(string pathName, string assetName)
    {
        for (int idx = 0; idx < loadedResources.Count; idx++)
        {
            ResourceInfo ri = loadedResources[idx];
            if (ri.Path == pathName && ri.Name == assetName)
            {
                return ri.Asset;
            }
        }
        return null;
    }

    T FindAssetByPathAndName<T>(string pathName, string assetName) where T : Object
    {
        for (int idx = 0; idx < loadedResources.Count; idx++)
        {
            ResourceInfo ri = loadedResources[idx];
            if (ri.Path == pathName && ri.Name == assetName)
            {
                T ret = ri.Reuse() as T;
                return ret;
            }
        }
        return null;
    }

    long Inner_LoadAsset<T>(ResourceLoadCallbackWithSeqId<T> cb, string pathName, string[] assetNames, ELoadType type, object[] userDatas)
    {
        if (string.IsNullOrEmpty(pathName) && (assetNames == null || assetNames.Length == 0)) return 0;

        for (int idx = 0; idx < assetNames.Length; idx++)
        {
            if (assetNames[idx] == "Null" || string.IsNullOrEmpty(assetNames[idx]))
            {
                DebugHelper.LogError("加载的资源存在Null，请检查配置");
                return 0;
            }
        }

        if (assetNames == null || assetNames.Length == 0)
        {
            if (cb != null)
                cb.DynamicInvoke(null, 0, pathName, userDatas, assetNames);
            return 0;
        }

        if (ExistAssets(pathName, assetNames))
        {
            FinishResourceLoad(cb, typeof(T), pathName, assetNames,true,0, userDatas);
            return 0;
        }

        loadingSeqId++;
        LoadingResourceInfo lri = new LoadingResourceInfo(loadingSeqId, pathName, cb as System.Delegate, typeof(T), true,assetNames);
        lri.userDatas = userDatas;
        loadingResources.Add(lri);

        lri.LoadCBNum =  AssetsMgr.Instance.GetAsset<T>(OnLoadAssetallback, type, loadingSeqId, pathName, assetNames);
        if (lri.LoadCBNum == 0)
        {
            if (cb != null)
                cb.DynamicInvoke(null, loadingSeqId,pathName, userDatas, assetNames);
            RemoveLoadingCb(loadingSeqId);
        }
        return loadingSeqId;
    }

    private long Inner_LoadAsset<T>(ResourceLoadCallback<T> cb, string pathName, string[] assetNames, ELoadType type)
    {
        if (string.IsNullOrEmpty(pathName) && (assetNames == null || assetNames.Length == 0)) return 0;

        for (int idx = 0; idx < assetNames.Length; idx++)
        {
            if (assetNames[idx] == "Null" || string.IsNullOrEmpty(assetNames[idx]))
            {
                DebugHelper.LogError("加载的资源存在Null，请检查配置");
                return 0;
            }
        }

        if (assetNames == null || assetNames.Length == 0)
        {
            if (cb != null)
                cb.DynamicInvoke(null, pathName, assetNames);
            return 0;
        }
        
        if (ExistAssets(pathName, assetNames))
        {
            FinishResourceLoad(cb, typeof(T), pathName, assetNames,false,0,null);
            return 0;
        }

        loadingSeqId++;
        LoadingResourceInfo lri = new LoadingResourceInfo(loadingSeqId, pathName, cb as System.Delegate, typeof(T), false,assetNames);
        loadingResources.Add(lri);

        lri.LoadCBNum = AssetsMgr.Instance.GetAsset<T>(OnLoadAssetallback, type, loadingSeqId, pathName, assetNames);
        if (lri.LoadCBNum == 0)
        {
            if (cb != null)
                cb.DynamicInvoke(null, pathName, assetNames);
            RemoveLoadingCb(loadingSeqId);
        }
        return loadingSeqId;
    }


    void OnLoadDirAssetallback<T>(T result, long seqId, string assetPath, params string[] assetNames)
    {
        LoadingResourceInfo lri = FindLoadingResourceInfoBySeqId(seqId);
        if (lri != null)
        {
            System.Delegate cb = lri.Callback;
            if(cb!=null)
                cb.DynamicInvoke(result, assetPath, assetNames);

            RemoveLoadingCb(seqId);
        }
        else
        {
            DebugHelper.Log("Load " + seqId + " Failed LoadingCnt:" + LoadingResourceCnt);
        }
    }

    void OnLoadAssetallback<T>(T result, long seqId, string assetPath, params string[] assetNames)
    {
        var t = typeof(T);
        if (t.Equals(typeof(List<GameObject>)))
        {
            List<GameObject> objList = result as List<GameObject>;
            if (assetNames.Length > 0)
            {
                for (int idx = 0; idx < assetNames.Length; idx++)
                {
                    ResourceInfo ri = new ResourceInfo(assetPath, assetNames[idx], objList[idx]);
                    loadedResources.Add(ri);
                }
            }
            else
            {
                for (int idx = 0; idx < objList.Count; idx++)
                {
                    string objName = objList[idx] != null ? objList[idx].name : null;
                    ResourceInfo ri = new ResourceInfo(assetPath, objName, objList[idx]);
                    loadedResources.Add(ri);
                }
            }
        }
        else if (t.Equals(typeof(List<Texture2D>)))
        {
            List<Texture2D> objList = result as List<Texture2D>;
            if (assetNames.Length > 0)
            {
                for (int idx = 0; idx < assetNames.Length; idx++)
                {
                    ResourceInfo ri = new ResourceInfo(assetPath, assetNames[idx], objList[idx]);
                    loadedResources.Add(ri);
                }
            }
            else
            {
                for (int idx = 0; idx < objList.Count; idx++)
                {
                    ResourceInfo ri = new ResourceInfo(assetPath, null, objList[idx]);
                    loadedResources.Add(ri);
                }
            }
        }
        else if (t.Equals(typeof(List<Sprite>)))
        {
            List<Sprite> objList = result as List<Sprite>;
            if (assetNames.Length > 0)
            {
                for (int idx = 0; idx < assetNames.Length; idx++)
                {
                    ResourceInfo ri = new ResourceInfo(assetPath, assetNames[idx], objList[idx]);
                    loadedResources.Add(ri);
                }
            }
            else
            {
                for (int idx = 0; idx < objList.Count; idx++)
                {
                    ResourceInfo ri = new ResourceInfo(assetPath, null, objList[idx]);
                    loadedResources.Add(ri);
                }
            }
        }
        else if (t.Equals(typeof(List<TextAsset>)))
        {
            List<TextAsset> objList = result as List<TextAsset>;
            if (assetNames.Length > 0)
            {
                for (int idx = 0; idx < assetNames.Length; idx++)
                {
                    ResourceInfo ri = new ResourceInfo(assetPath, assetNames[idx], objList[idx]);
                    loadedResources.Add(ri);
                }
            }
            else
            {
                for (int idx = 0; idx < objList.Count; idx++)
                {
                    ResourceInfo ri = new ResourceInfo(assetPath, null, objList[idx]);
                    loadedResources.Add(ri);
                }
            }

        }
        else if (t.Equals(typeof(List<PlayableAsset>)))
        {
            List<PlayableAsset> objList = result as List<PlayableAsset>;
            if (assetNames.Length > 0)
            {
                for (int idx = 0; idx < assetNames.Length; idx++)
                {
                    ResourceInfo ri = new ResourceInfo(assetPath, assetNames[idx], objList[idx]);
                    loadedResources.Add(ri);
                }
            }
            else
            {
                for (int idx = 0; idx < objList.Count; idx++)
                {
                    ResourceInfo ri = new ResourceInfo(assetPath, null, objList[idx]);
                    loadedResources.Add(ri);
                }
            }
        }
        else if (t.Equals(typeof(List<AudioClip>)))
        {
            List<AudioClip> objList = result as List<AudioClip>;
            if (assetNames.Length > 0)
            {
                for (int idx = 0; idx < assetNames.Length; idx++)
                {
                    ResourceInfo ri = new ResourceInfo(assetPath, assetNames[idx], objList[idx]);
                    loadedResources.Add(ri);
                }
            }
            else
            {
                for (int idx = 0; idx < objList.Count; idx++)
                {
                    ResourceInfo ri = new ResourceInfo(assetPath, null, objList[idx]);
                    loadedResources.Add(ri);
                }
            }

        }
        else if (t.Equals(typeof(List<VideoClip>)))
        {
            List<VideoClip> objList = result as List<VideoClip>;
            if (assetNames.Length > 0)
            {
                for (int idx = 0; idx < assetNames.Length; idx++)
                {
                    ResourceInfo ri = new ResourceInfo(assetPath, assetNames[idx], objList[idx]);
                    loadedResources.Add(ri);
                }
            }
            else
            {
                for (int idx = 0; idx < objList.Count; idx++)
                {
                    ResourceInfo ri = new ResourceInfo(assetPath, null, objList[idx]);
                    loadedResources.Add(ri);
                }
            }
        }
        else if (t.Equals(typeof(List<AnimationClip>)))
        {
            List<AnimationClip> objList = result as List<AnimationClip>;
            if (assetNames.Length > 0)
            {
                for (int idx = 0; idx < assetNames.Length; idx++)
                {
                    ResourceInfo ri = new ResourceInfo(assetPath, assetNames[idx], objList[idx]);
                    loadedResources.Add(ri);
                }
            }
            else
            {
                for (int idx = 0; idx < objList.Count; idx++)
                {
                    ResourceInfo ri = new ResourceInfo(assetPath, null, objList[idx]);
                    loadedResources.Add(ri);
                }
            }
        }
        else if (t.Equals(typeof(List<RuntimeAnimatorController>)))
        {
            List<RuntimeAnimatorController> objList = result as List<RuntimeAnimatorController>;
            if (assetNames.Length > 0)
            {
                for (int idx = 0; idx < assetNames.Length; idx++)
                {
                    ResourceInfo ri = new ResourceInfo(assetPath, assetNames[idx], objList[idx]);
                    loadedResources.Add(ri);
                }
            }
            else
            {
                for (int idx = 0; idx < objList.Count; idx++)
                {
                    ResourceInfo ri = new ResourceInfo(assetPath, null, objList[idx]);
                    loadedResources.Add(ri);
                }
            }
        }
        else if (t.Equals(typeof(ScriptableObject)) ||
              t.Equals(typeof(GameObject)) ||
              t.Equals(typeof(AudioClip)) ||
              t.Equals(typeof(VideoClip)) ||
              t.Equals(typeof(Texture2D)) ||
              t.Equals(typeof(Sprite)) ||
              t.Equals(typeof(Material)) ||
              t.Equals(typeof(AnimationClip)) ||
              t.Equals(typeof(RuntimeAnimatorController)))
        {
            Object obj = result as Object;
            ResourceInfo ri = new ResourceInfo(assetPath, assetNames[0], obj);
            loadedResources.Add(ri);
        }

        LoadingResourceInfo lri = FindLoadingResourceInfoBySeqId(seqId);
        if (lri != null)
        {
            lri.LoadCBNum = lri.LoadCBNum - 1;
            if(lri.LoadCBNum <= 0)
            {
                System.Delegate cb = lri.Callback;
                FinishResourceLoad(cb, lri.DelegateType, lri.AssetPath, lri.AssetNames, lri.ReturnSeqId, lri.SeqId,lri.userDatas);
                RemoveLoadingCb(seqId);
            }
        }
        else
        {
            DebugHelper.Log("Load " + seqId + " Failed LoadingCnt:" + LoadingResourceCnt);
        }
    }

    void FinishResourceLoad(System.Delegate cb, System.Type delegateType, string pathName, string[] assetNames,bool returnSeq,long seqId,object[] userdatas)
    {
        if (cb == null) return;

        if (delegateType.Equals(typeof(List<GameObject>)))
        {
            FinishLoad<GameObject>(cb, pathName, assetNames, false, returnSeq,seqId, userdatas);
        }
        else if (delegateType.Equals(typeof(List<Texture2D>)))
        {
            FinishLoad<Texture2D>(cb, pathName, assetNames, false, returnSeq, seqId, userdatas);
        }
        else if (delegateType.Equals(typeof(List<Sprite>)))
        {
            FinishLoad<Sprite>(cb, pathName, assetNames, false, returnSeq, seqId, userdatas);
        }
        else if (delegateType.Equals(typeof(List<TextAsset>)))
        {
            FinishLoad<TextAsset>(cb, pathName, assetNames, false, returnSeq, seqId, userdatas);
        }
        else if (delegateType.Equals(typeof(List<PlayableAsset>)))
        {
            FinishLoad<PlayableAsset>(cb, pathName, assetNames, false, returnSeq, seqId, userdatas);
        }
        else if (delegateType.Equals(typeof(List<AudioClip>)))
        {
            FinishLoad<AudioClip>(cb, pathName, assetNames, false, returnSeq, seqId, userdatas);
        }
        else if (delegateType.Equals(typeof(List<VideoClip>)))
        {
            FinishLoad<VideoClip>(cb, pathName, assetNames, false, returnSeq, seqId, userdatas);
        }
        else if (delegateType.Equals(typeof(List<AnimationClip>)))
        {
            FinishLoad<AnimationClip>(cb, pathName, assetNames, false, returnSeq, seqId, userdatas);
        }
        else if (delegateType.Equals(typeof(List<RuntimeAnimatorController>)))
        {
            FinishLoad<RuntimeAnimatorController>(cb, pathName, assetNames, false, returnSeq, seqId, userdatas);
        }
        else if (delegateType.Equals(typeof(GameObject)))
        {
            FinishLoad<GameObject>(cb, pathName, assetNames, true, returnSeq, seqId, userdatas);
        }
        else if (delegateType.Equals(typeof(Texture2D)))
        {
            FinishLoad<Texture2D>(cb, pathName, assetNames, true, returnSeq, seqId, userdatas);
        }
        else if (delegateType.Equals(typeof(Sprite)))
        {
            FinishLoad<Sprite>(cb, pathName, assetNames, true, returnSeq, seqId, userdatas);
        }
        else if (delegateType.Equals(typeof(TextAsset)))
        {
            FinishLoad<TextAsset>(cb, pathName, assetNames, true, returnSeq, seqId, userdatas);
        }
        else if (delegateType.Equals(typeof(PlayableAsset)))
        {
            FinishLoad<PlayableAsset>(cb, pathName, assetNames, true, returnSeq, seqId, userdatas);
        }
        else if (delegateType.Equals(typeof(AudioClip)))
        {
            FinishLoad<AudioClip>(cb, pathName, assetNames, true, returnSeq, seqId, userdatas);
        }
        else if (delegateType.Equals(typeof(VideoClip)))
        {
            FinishLoad<VideoClip>(cb, pathName, assetNames, true, returnSeq, seqId, userdatas);
        }
        else if (delegateType.Equals(typeof(AnimationClip)))
        {
            FinishLoad<AnimationClip>(cb, pathName, assetNames, true, returnSeq, seqId, userdatas);
        }
        else if (delegateType.Equals(typeof(Sprite)))
        {
            FinishLoad<Sprite>(cb, pathName, assetNames, true, returnSeq, seqId, userdatas);
        }
        else if (delegateType.Equals(typeof(Material)))
        {
            FinishLoad<Material>(cb, pathName, assetNames, true, returnSeq, seqId, userdatas);
        }
        else if (delegateType.Equals(typeof(RuntimeAnimatorController)))
        {
            FinishLoad<RuntimeAnimatorController>(cb, pathName, assetNames, true, returnSeq, seqId, userdatas);
        }
    }

    void FinishLoad<T>(System.Delegate cb, string pathName, string[] assetNames, bool single, bool returnSeq, long seqId, object[] userdatas) where T : Object
    {
        if (single)
        {
            T go = FindAssetByPathAndName<T>(pathName, assetNames[0]);
            try
            {
                if (returnSeq)
                {
                    cb.DynamicInvoke(go, seqId, pathName, userdatas,assetNames);
                }
                else
                {
                    
                    cb.DynamicInvoke(go, pathName, assetNames);
                }
            }
            catch(System.Exception e)
            {
                DebugHelper.LogError(e.StackTrace);
            }
         
        }
        else
        {
            List<T> assetList = new List<T>();
            if (assetNames != null && assetNames.Length > 0)
            {
                for (int idx = 0; idx < assetNames.Length; idx++)
                {
                    assetList.Add(FindAssetByPathAndName<T>(pathName, assetNames[idx]));
                }
            }
            else
            {
                for (int idx = 0; idx < loadedResources.Count; idx++)
                {
                    ResourceInfo ri = loadedResources[idx];
                    if (ri.Path == pathName)
                    {
                        T asset = ri.Reuse() as T;
                        assetList.Add(asset);
                    }
                }
            }

            if(returnSeq)
            {
                cb.DynamicInvoke(assetList,seqId, pathName, userdatas, assetNames);
            }
            else
            {
                cb.DynamicInvoke(assetList, pathName, assetNames);
            }
        }
        ClearNullResource();
    }

    void ClearNullResource()
    {
        for (int idx = loadedResources.Count - 1; idx >= 0; idx--)
        {
            ResourceInfo ri = loadedResources[idx];
            if (ri.Asset == null)
            {
                loadedResources.RemoveAt(idx);
            }
        }
    }

    public void RemoveLoadedResource(string path,string assetName)
    {
        for (int idx = loadedResources.Count-1; idx >= 0; idx--)
        {
            var ri = loadedResources[idx];
            if(ri.Path == path && ri.Name == assetName)
            {
                ri.Dispose();
                loadedResources.RemoveAt(idx);
            }
        }
    }

    List<string> mResidentDirList = new List<string>();
    List<string> mResidentResList = new List<string>();

    public void ReadResidentResCfg()
    {
        mResidentDirList.Clear();
        mResidentResList.Clear();
        Dictionary<string, Dictionary<string, string>> tab =  ConfigMgr.Instance.getTable(Config.ResidentResCfg);
        if (tab == null) return;

        foreach(var p in tab)
        {
            var key = p.Key;
            var dic = p.Value;


            int kVal = 0;
            if (int.TryParse(key, out kVal))
            {
                string resName = dic["name"];
                int type = 0;
                if (dic.ContainsKey("type"))
                {
                    int.TryParse(dic["type"], out type);
                }

                if (!string.IsNullOrEmpty(resName) && type > 0)
                {
                    if (type == 1)
                    {
                        if (!mResidentDirList.Contains(resName))
                            mResidentDirList.Add(resName);
                    }
                    else if (type == 2)
                    {
                        if (!mResidentResList.Contains(resName))
                        {
                            mResidentResList.Add(resName);
                        }
                    }
                }
            }   
        }
    }

    public bool IsResidentRes(string assetPath,string assetName)
    {
        string path = assetPath + "/" + assetName;
        return IsResidentRes(path);
    }

    public bool IsResidentRes(string assetFullPath)
    {
        for (int idx = 0; idx < mResidentResList.Count; idx++)
        {
            if (mResidentResList[idx] == assetFullPath) return true;
        }

        string pathDir;
        FileUtils.ExtractParent(assetFullPath, out pathDir);
        if (!string.IsNullOrEmpty(pathDir))
        {
            for (int idx = 0; idx < mResidentDirList.Count; idx++)
            {
                if (mResidentDirList[idx] == pathDir) return true;
            }
        }

        return false;
    }

    public void ClearAllResource()
    {
        for(int idx = loadedResources.Count -1; idx>=0; idx--)
        {
            ResourceInfo ri = loadedResources[idx];
            if (IsResidentRes(ri.Path, ri.Name))
            {
                continue;
            }

            ri.Dispose();
            loadedResources.RemoveAt(idx);
        }

        CleanGOPool();
    }

    void ClearLongTimeUnusedResource(float curTime)
    {
        for (int idx = loadedResources.Count - 1; idx >= 0; idx--)
        {
            ResourceInfo ri = loadedResources[idx];
            float passedTime = curTime - ri.LastUsedTime;
            if (passedTime >= cache_Time && !IsResidentRes(ri.Path,ri.Name) && HasGoInPool(ri.Path,ri.Name))
            {
                ri.Dispose();
                loadedResources.RemoveAt(idx);
            }
        }
    }

    bool HasGoInPool(string assetPath,string assetName)
    {
        if (string.IsNullOrEmpty(assetPath)) return false;
        
        if (assetsPool == null) return false;

        Dictionary<string, GameObjectPool<GameObject>> mDirGoPool;
        if (assetsPool.TryGetValue(assetPath, out mDirGoPool))
        {
            GameObjectPool<GameObject> curPool = null;
            mDirGoPool.TryGetValue(assetName, out curPool);
            if (curPool != null && curPool.Count > 0)
            {
                return true;
            }
        }
        return false;
    }
    #endregion

}