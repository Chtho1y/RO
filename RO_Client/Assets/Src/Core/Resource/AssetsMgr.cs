using System.Text;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.SceneManagement;
using UnityEngine.Video;
using UnityEngine.Networking;
using Object = UnityEngine.Object;
public enum ELoadType : int
{
    OTHER = 0,
    UI = 1,
    ACTOR = 2,
    FX = 3,
    AssetBundle = 4,
}

public delegate void AssetCallback<T>(T callback);

public delegate void AssetCallbackWithParams<T>(T callback, long seqId, string assetPath, params string[] assetName);

class Bundle
{
    AssetBundle mAsset;
    public AssetBundle Asset
    {
        get { return mAsset; }
    }
    float mLastUsedTime;
    public float LastUsedTime
    {
        get { return mLastUsedTime; }
        set
        {
            mLastUsedTime = value;
            Priority = 0;
        }
    }
    public string mBundleName = string.Empty;
    public string BundleName
    {
        get { return mBundleName; }
    }

    public int mPriority = 0;
    public int Priority
    {
        get { return mPriority; }
        set
        {
            mPriority = value;
            mLastUsedTime = Time.realtimeSinceStartup;
        }
    }
    public Bundle(AssetBundle bundle, string bundleName)
    {
        mBundleName = bundleName;
        mAsset = bundle;
        mPriority = 0;
        mLastUsedTime = Time.realtimeSinceStartup;
    }

    public void Unload()
    {
        if (mAsset != null)
        {
            mAsset.Unload(false);
            mAsset = null;
        }
    }
}

public class LoadAssetsTask
{
    bool hasReturnParam = false;
    public bool HasReturnParam
    {
        get { return hasReturnParam; }
    }

    Delegate mCallback;
    public Delegate Callback
    {
        get { return mCallback; }
    }

    string mAssetPath;
    public string AssetPath
    {
        get { return mAssetPath; }
    }

    string[] mAssetName;
    public string[] AssetName
    {
        get { return mAssetName; }
    }

    long mLoadingSeqId = 0;
    public long LoadingSeqId
    {
        get { return mLoadingSeqId; }
    }

    public LoadAssetsTask(long seqId, string assetPath, string[] assetName, Delegate callback, bool returnParam_)
    {
        mLoadingSeqId = seqId;
        mAssetPath = assetPath;
        mAssetName = assetName;
        mCallback = callback;
        hasReturnParam = returnParam_;
    }

    public void Invoke<T>(T goes)
    {
        if (hasReturnParam)
        {
            Callback.DynamicInvoke(goes, mLoadingSeqId, mAssetPath, mAssetName);
        }
        else
        {
            Callback.DynamicInvoke(goes);
        }
    }
}

public class LoadTask
{
    string mBundleName;
    public string BundleName
    {
        get { return mBundleName; }
    }

    List<LoadAssetsTask> mAssetsTask = new List<LoadAssetsTask>();
    public List<LoadAssetsTask> AssetsTask
    {
        get { return mAssetsTask; }
    }

    public int AssetsTaskCnt
    {
        get { return mAssetsTask.Count; }
    }

    Type mDelegateType;
    public Type DelegateType
    {
        get { return mDelegateType; }
    }

    ELoadType mLoadType;
    public ELoadType LoadType
    {
        get { return mLoadType; }
    }

    float mLoadStartTime;
    public float LoadStartTime
    {
        get { return mLoadStartTime; }
        set
        {
            mLoadStartTime = value;
        }
    }

    private AssetBundle mBundle = null;
    public AssetBundle Bundle
    {
        get { return mBundle; }
        set { mBundle = value; }
    }

    private bool isDone = false;
    public bool IsDone
    {
        get { return isDone; }
        set { isDone = value; }
    }

    //依赖的ab包是否加载完成
    private bool isDependencyDone = true;
    public bool IsDependencyDone
    {
        get { return isDependencyDone; }
        set { isDependencyDone = value; }
    }

    //需要加载ab包是否有依赖包
    private bool isDependency = false;
    public bool IsDependency
    {
        get { return isDependency; }
        set { isDependency = value; }
    }

    public LoadTask(string bundleName)
    {
        mBundleName = bundleName;
        // mBundleName = bundleName.ToLower();
        // if (!mBundleName.Contains(".unity3d"))
        // {
        //     mBundleName = mBundleName + ".unity3d";
        // }
        mLoadType = ELoadType.AssetBundle;
        //DebugHelper.LogError("bundleName:" + bundleName);
    }

    public LoadTask(long seqId, string bundleName, string assetPath, string[] assetName, Delegate callback, bool callbackWithParam, Type type, ELoadType loadType = ELoadType.OTHER)
    {
        mBundleName = bundleName;
        // mBundleName = bundleName.ToLower();
        // if (!mBundleName.Contains(".unity3d"))
        // {
        //     mBundleName = mBundleName + ".unity3d";
        // }
        mAssetsTask.Add(new LoadAssetsTask(seqId, assetPath, assetName, callback, callbackWithParam));
        mDelegateType = type;
        mLoadType = loadType;
        //DebugHelper.LogError("bundleName:" + bundleName);
    }

    public void ChangeTask(long seqId, string bundleName, string assetPath, string[] assetName, Delegate callback, bool callbackWithParam, Type type, ELoadType loadType = ELoadType.OTHER)
    {
        if (mLoadType == ELoadType.AssetBundle) return;

        mAssetsTask.Add(new LoadAssetsTask(seqId, assetPath, assetName, callback, callbackWithParam));
        mDelegateType = type;
        mLoadType = loadType;
    }

    public LoadAssetsTask FindTask(long seqId)
    {
        for (int idx = 0; idx < mAssetsTask.Count; idx++)
        {
            LoadAssetsTask task = mAssetsTask[idx];
            if (task.LoadingSeqId == seqId)
            {
                return task;
            }
        }
        return null;
    }

    public void RemoveTask(long seqId)
    {
        LoadAssetsTask task = FindTask(seqId);
        if (task != null)
        {
            mAssetsTask.Remove(task);
        }
    }

    public bool IsExist(long seqId)
    {
        for (int idx = 0; idx < mAssetsTask.Count; idx++)
        {
            LoadAssetsTask task = mAssetsTask[idx];
            if (task.LoadingSeqId == seqId)
            {
                return true;
            }
        }
        return false;
    }
}

public class LoadAssetbundleTask
{
    private LoadTask mLoader = null;
    private AssetBundleCreateRequest mAsync = null;
    private bool mbIsDone = false;
    private bool mbNotified = false;

    public LoadTask Loader
    {
        get { return mLoader; }
    }

    public bool IsDone
    {
        get { return mbIsDone; }
    }

    public LoadAssetbundleTask(LoadTask info)
    {
        mLoader = info;
    }

    public void Update()
    {
        if (mAsync == null && mLoader.IsDependencyDone)
        {
            mAsync = AssetsMgr.Instance.CreatePackageLoader(mLoader.BundleName);
            if (mAsync == null && !mbNotified)
            {
                Ending(null);
                mbNotified = true;
            }
            else if (mAsync != null && mAsync.isDone)
            {
                if (!mbNotified)
                {
                    Ending(null);
                    mbNotified = true;
                }
            }
        }
        else if (mAsync != null && mAsync.isDone)
        {
            if (!mbNotified)
            {
                Ending(mAsync.assetBundle);
                mbNotified = true;
            }
        }
    }

    public void Dispose()
    {
        mLoader = null;
    }

    void Ending(AssetBundle bundle)
    {
        mLoader.Bundle = bundle;
        mbIsDone = true;
        AssetsMgr.Instance.NotifyAssetbundleLoaded(mLoader, this);
    }
}

public class AssetsMgr : SingletonMono<AssetsMgr>
{
    private List<string> mResidentAssetBundleList = new List<string>();

    private Dictionary<string, string> mAssetsMappingDict = new Dictionary<string, string>();
    private Dictionary<string, Bundle> mBundlesLoaded = new Dictionary<string, Bundle>();
    private Dictionary<string, LoadTask> mBundlesLoading = new Dictionary<string, LoadTask>();

    private Dictionary<string, LoadTask> mCurLoadingBundleDic = new Dictionary<string, LoadTask>();
    private List<LoadTask> mLoadTasks = new List<LoadTask>();
    private Queue<LoadTask> mLoadFinshedTask = new Queue<LoadTask>();
    private List<string> expired = new List<string>();
    private List<LoadAssetbundleTask> mAssetbundleLoadTasks = new List<LoadAssetbundleTask>();

    private static readonly int GCRepeatRate = 7;//主城重复清理gc时间间隔.
    private static readonly int GCReleaseRate = 2;//切换场景gc时间间隔.
    private static readonly int MaxLoadingCoroutineCount = 10;
    private int mLoadingCoroutineCount = 0;
    private AssetBundleManifest assetBundleManifest = null;

    private const string c_ResVersionCodeKey = "resversioncode";
    private VersionCode m_ResVersionCode = VersionCode.zeroVersionCode;

    public VersionCode resVersionCode
    {
        get { return m_ResVersionCode; }
    }

    public override void InitMgr()
    {
        base.InitMgr();
#if UNITY_EDITOR
        if (Constants.AssetbundleMode)
        {
            if (null == assetBundleManifest)
            {
                GetAssetBundleManifest("assetbundle", ref assetBundleManifest);
            }
            //StartCoroutine(GetAssetsMapping());
            GetAssetsMappingSync();
        }
#else
        if (null == assetBundleManifest)
        {
            GetAssetBundleManifest("assetbundle", ref assetBundleManifest);
            //StartCoroutine(GetAssetsMapping());
            GetAssetsMappingSync();
        }
#endif
    }

    private void GetAssetsMappingSync()
    {
        string path = string.Format("{0}assetsmapping.bytes", FileSystem.LocalDocumentPath);
        if (!FileSystem.Exists(path))
        {
            path = string.Format("{0}assetsmapping.bytes", FileSystem.LocalPackagePath);
        }
        if (!path.Contains("file://"))
        {
            path = "file://" + path;
        }
        try
        {
            WWW www = new WWW(path);
            while (!www.isDone) { }
            if (string.IsNullOrEmpty(www.error))
            {
                string data = www.text;
                string[] ContentLines = www.text.Split(new string[] { "\r\n" }, StringSplitOptions.RemoveEmptyEntries);
                for (int idx = 0; idx < ContentLines.Length; idx++)
                {
                    string content = ContentLines[idx];
                    string[] temp = content.Split(',');
                    mAssetsMappingDict.Add(temp[0].ToLower(), temp[1]);
                }
                if (mAssetsMappingDict.ContainsKey(c_ResVersionCodeKey))
                {
                    m_ResVersionCode = mAssetsMappingDict[c_ResVersionCodeKey];
                    mAssetsMappingDict.Remove(c_ResVersionCodeKey);
                }
                AssetsObscureUtil.InitAssetsObscureConfig(ref mAssetsMappingDict);
            }
            else
            {
                DebugHelper.LogError("Load AssetsMapping Fail:" + www.error + "  filePath:" + path);
            }
        }
        catch (Exception e)
        {
            DebugHelper.LogError("Load AssetsMapping Fail:" + e.ToString() + "  filePath:" + path);
        }
    }

    public void InitDependenciesAsync(Action<bool> completeCB)
    {
#if UNITY_EDITOR
        if (!Constants.AssetbundleMode)
        {
            if (completeCB != null) completeCB(true);
            return;
        }
#endif
        StartCoroutine(AsyncInitDependencies(completeCB));
    }

    private IEnumerator AsyncInitDependencies(Action<bool> completeCB)
    {
        string path = null;
        if (null == assetBundleManifest)
        {
            path = string.Format("{0}assetsmapping.bytes", FileSystem.LocalDocumentPath);
            if (!FileSystem.Exists(path))
            {
                path = string.Format("{0}assetsmapping.bytes", FileSystem.LocalPackagePath);
            }
            if (!path.Contains("file://"))
            {
                path = "file://" + path;
            }
            WWW www = new WWW(path);
            yield return www;
            if (string.IsNullOrEmpty(www.error))
            {
                byte[] bytes = www.bytes;
                byte value;
                int length = bytes.Length;
                for (int i = 0, iMax = Mathf.FloorToInt(length * 0.5f); i < iMax; i += 2)
                {
                    value = bytes[i];
                    bytes[i] = bytes[length - i - 1];
                    bytes[length - i - 1] = value;
                }
                UTF8Encoding encoding = new UTF8Encoding(false);
                string data = encoding.GetString(bytes);
                string[] ContentLines = data.Split(new string[] { "\r\n" }, StringSplitOptions.RemoveEmptyEntries);
                for (int idx = 0; idx < ContentLines.Length; idx++)
                {
                    string content = ContentLines[idx];
                    string[] temp = content.Split(',');
                    mAssetsMappingDict.Add(temp[0].ToLower(), temp[1]);
                }
                if (mAssetsMappingDict.ContainsKey(c_ResVersionCodeKey))
                {
                    m_ResVersionCode = mAssetsMappingDict[c_ResVersionCodeKey];
                    mAssetsMappingDict.Remove(c_ResVersionCodeKey);
                }
                AssetsObscureUtil.InitAssetsObscureConfig(ref mAssetsMappingDict);
            }
            else
            {
                DebugHelper.LogError("Load AssetsMapping Fail:" + www.error + "  filePath:" + path);
            }

            string assetbundleName = AssetsObscureUtil.GetABFileName("assetbundle");
            ulong offset = AssetsObscureUtil.GetABOffset(assetbundleName);
            path = string.Format("{0}{1}", FileSystem.LocalDocumentPath, assetbundleName);
            path = string.Format("{0}{1}", FileSystem.LocalPackagePath, assetbundleName);
#if !UNITY_INSTANTGAME
            if (!FileSystem.Exists(path))
            {
                path = string.Format("{0}{1}", FileSystem.LocalPackagePath, assetbundleName);
            }
#endif
            var assetBundleCreateRequest = AssetBundle.LoadFromFileAsync(path, 0, offset);
            yield return assetBundleCreateRequest;
            var assetBundleRequest = assetBundleCreateRequest.assetBundle.LoadAssetAsync("AssetBundleManifest");
            yield return assetBundleRequest;
            assetBundleManifest = (AssetBundleManifest)assetBundleRequest.asset;
            if (completeCB != null) completeCB(true);
        }
    }

    public void InitResidentAssetBundleList(Action<bool> completeCB)
    {
#if UNITY_EDITOR
        if (!Constants.AssetbundleMode)
        {
            if (completeCB != null) completeCB(true);
            return;
        }
#endif
        StartCoroutine(AsyncInitResidentAssetBundleList(completeCB));
    }

    private IEnumerator AsyncInitResidentAssetBundleList(Action<bool> completeCB)
    {
        string shaderName = AssetsObscureUtil.GetABFileName("shader.unity3d");
        ulong offset = AssetsObscureUtil.GetABOffset(shaderName);
        mResidentAssetBundleList.Clear();
        mResidentAssetBundleList.Add(shaderName);

        //test
        string test_fontName = AssetsObscureUtil.GetABFileName("font.unity3d");
        string test_path = string.Format("{0}{1}", FileSystem.LocalPackagePath, test_fontName);
        Debug.Log("====load font path====" + test_path);
        AssetBundleCreateRequest test_shaderABCreateRequest = AssetBundle.LoadFromFileAsync(test_path, 0, offset);
        yield return test_shaderABCreateRequest;
        ///////////
        ///
        string path = string.Format("{0}{1}", FileSystem.LocalDocumentPath, shaderName);
#if !UNITY_INSTANTGAME
        if (!FileSystem.Exists(path))
        {
            path = string.Format("{0}{1}", FileSystem.LocalPackagePath, shaderName);
        }
#endif
        AssetBundleCreateRequest shaderABCreateRequest = AssetBundle.LoadFromFileAsync(path, 0, offset);
        yield return shaderABCreateRequest;

        AssetBundle shaderAB = shaderABCreateRequest.assetBundle;
        if (shaderAB != null)
        {
            Bundle bundle = new Bundle(shaderAB, shaderName);
            mBundlesLoaded.Add(shaderName, bundle);
        }
        Shader.WarmupAllShaders();
        if (completeCB != null) completeCB(true);
    }

    public void AddResidentAsset(string assetName)
    {
        mResidentAssetBundleList.Add(assetName);
    }

    private string GetABName(string assetName, Type type)
    {
        string abName = null;
        if (!FileUtils.HasExtension(assetName))
        {
            assetName += GetFileTypeExtention(type);
        }
        mAssetsMappingDict.TryGetValue(assetName.ToLower(), out abName);
        return abName;
    }

    private string GetFileTypeExtention(Type type)
    {
        string ext = "";
        if (type.Equals(typeof(List<GameObject>)) || type.Equals(typeof(GameObject)))
        {
            ext = ".prefab";
        }
        else if (type.Equals(typeof(List<TextAsset>)))
        {
            ext = ".bytes";
        }
        else if (type.Equals(typeof(List<AudioClip>)) || type.Equals(typeof(AudioClip)))
        {
            ext = ".ogg";
        }
        else if (type.Equals(typeof(List<VideoClip>)) || type.Equals(typeof(VideoClip)))
        {
            ext = ".mp4";
        }
        else if (type.Equals(typeof(List<Texture2D>)) || type.Equals(typeof(Texture2D)))
        {
            ext = ".png";
        }
        else if (type.Equals(typeof(List<PlayableAsset>)) || type.Equals(typeof(PlayableAsset)))
        {
            ext = ".playable";
        }
        else if (type.Equals(typeof(List<Material>)) || type.Equals(typeof(Material)))
        {
            ext = ".mat";
        }
        else if (type.Equals(typeof(List<Sprite>)) || type.Equals(typeof(Sprite)))
        {
            ext = ".png";
        }
        else if (type.Equals(typeof(List<RuntimeAnimatorController>)) || type.Equals(typeof(RuntimeAnimatorController)))
        {
            ext = ".controller";
        }
        return ext;
    }

    protected override void Dispose()
    {
        if (mBundlesLoaded != null)
        {
            foreach (var item in mBundlesLoaded)
            {
                if (item.Value != null)
                    item.Value.Unload();
            }
            mBundlesLoaded.Clear();
        }
        mBundlesLoading = null;
        mBundlesLoaded = null;
        if (mLoadTasks != null)
            mLoadTasks.Clear();
        if (expired != null)
            expired.Clear();
        StopAllCoroutines();
        base.Dispose();
    }

    void GetAssetBundleManifest(string fileName, ref AssetBundleManifest maniFest)
    {
        if (null == assetBundleManifest)
        {
            string path = string.Format("{0}{1}", FileSystem.LocalDocumentPath, fileName);
            AssetBundle ab = null;
            if (FileSystem.Exists(path))
            {
                ab = AssetBundle.LoadFromFile(path);
            }
            else
            {
                path = string.Format("{0}{1}", FileSystem.LocalPackagePath, fileName);

                ab = AssetBundle.LoadFromFile(path);
            }

            //DebugHelper.Log(path);
            if (null != ab)
                maniFest = (AssetBundleManifest)ab.LoadAsset("AssetBundleManifest");
        }
    }

    IEnumerator GetAssetsMapping()
    {
        string path = string.Format("{0}assetsmapping.bytes", FileSystem.LocalDocumentPath);
        if (!FileSystem.Exists(path))
        {
            path = string.Format("{0}assetsmapping.bytes", FileSystem.LocalPackagePath);
        }

        if (!path.Contains("file://"))
        {
            path = "file://" + path;
        }



        WWW www = new WWW(path);
        yield return www;

        if (string.IsNullOrEmpty(www.error))
        {
            //DebugHelper.LogError("GetAssetsMapping-------------");
            string[] ContentLines = www.text.Split(new string[] { "\r\n" }, StringSplitOptions.RemoveEmptyEntries);
            //Debug.LogError(www.text);
            for (int idx = 0; idx < ContentLines.Length; idx++)
            {
                string content = ContentLines[idx];
                string[] temp = content.Split(',');
                mAssetsMappingDict.Add(temp[0].ToLower(), temp[1]);
            }
        }
        else
        {
            DebugHelper.LogError("Load AssetsMapping Fail:" + www.error + "  filePath:" + path);
        }
    }

    public IEnumerator LoadSubSceneLocalAssetData(string levelName)
    {
        AsyncOperation ao = SceneManager.LoadSceneAsync(levelName, LoadSceneMode.Additive);
        yield return ao;
        if (!ao.isDone)
        {
            DebugHelper.LogError("Load Scene " + levelName + " Failed");
        }
        ao = null;
    }

    public IEnumerator LoadSubSceneFromAssetBundle(string levelName)
    {
        if (!mBundlesLoaded.ContainsKey(levelName))
        {
            AssetBundleCreateRequest abRequest = null;
            string sceneABName = AssetsObscureUtil.GetABFileName(levelName.ToLower() + ".unity3d");
            ulong offset = AssetsObscureUtil.GetABOffset(sceneABName);

            //加载场景依赖包
            string[] deps = assetBundleManifest.GetAllDependencies(sceneABName);
            if (deps.Length > 0)
            {
                for (int idx = 0; idx < deps.Length; idx++)
                {
                    string depABName = deps[idx];
                    if (mBundlesLoaded.ContainsKey(depABName)) continue;
                    if (mCurLoadingBundleDic.ContainsKey(depABName))
                    {
                        continue;
                    }

                    string path = string.Format("{0}{1}", FileSystem.LocalDocumentPath, depABName);
                    ulong depOffset = AssetsObscureUtil.GetABOffset(depABName);
#if !UNITY_INSTANTGAME
                    if (!FileSystem.Exists(path))
                    {
                        path = string.Format("{0}{1}", FileSystem.LocalPackagePath, depABName);
                    }
#endif
                    abRequest = AssetBundle.LoadFromFileAsync(path, 0, depOffset);
                    syncReqDict.Add(depABName, abRequest);
                    mCurLoadingBundleDic.Add(depABName, new LoadTask(depABName));
                }

                foreach (var p in syncReqDict)
                {
                    AssetBundleCreateRequest req = p.Value;
                    yield return req;

                    Bundle depBundle = new Bundle(req.assetBundle, p.Key);
                    mBundlesLoaded.Add(p.Key, depBundle);
                    mCurLoadingBundleDic.Remove(p.Key);
                }

                syncReqDict.Clear();
            }

            //加载场景ab
            string sceneABPath = FileSystem.LocalDocumentPath + sceneABName;
#if !UNITY_INSTANTGAME
            if (!FileSystem.Exists(sceneABPath))
            {
                sceneABPath = FileSystem.LocalPackagePath + sceneABName;
            }
#endif
            abRequest = AssetBundle.LoadFromFileAsync(sceneABPath, 0, offset);
            yield return abRequest;
            Bundle bundle = new Bundle(abRequest.assetBundle, levelName);
            mBundlesLoaded.Add(levelName, bundle);
        }
        else
        {
            DebugHelper.Log("[LoadSceneAssetbundle].mBundlesLoaded.ContainsKey {0}", levelName);
            mBundlesLoaded[levelName].LastUsedTime = Time.realtimeSinceStartup;
        }

        yield return 1;

        AsyncOperation ao = SceneManager.LoadSceneAsync(levelName, LoadSceneMode.Additive);
        yield return ao;
        ao = null;
    }

    public IEnumerator LoadSceneLocalAssetData(string levelName)
    {
        AsyncOperation ao = SceneManager.LoadSceneAsync(levelName, LoadSceneMode.Single);
        yield return ao;
        if (!ao.isDone)
        {
            DebugHelper.LogError("Load Scene " + levelName + " Failed");
        }
        ao = null;
    }

    IEnumerator DownloadProgress(AsyncOperation operation)
    {
        while (!operation.isDone)
        {
            float curMount = operation.progress;
            PreDownProcessManager.Instance.fWebReqProcess = curMount;
            Debug.Log("====load scene process====" + curMount);
            yield return null;
        }
    }

    Dictionary<string, AssetBundleCreateRequest> syncReqDict = new Dictionary<string, AssetBundleCreateRequest>();
    public IEnumerator LoadSceneAssetbundle(string levelName)
    {
        if (!mBundlesLoaded.ContainsKey(levelName))
        {
            // AsyncOperation process_oper = AutoStreaming.PredownloadAssetsAsync(levelName, 0);
            // if (process_oper != null)
            // {
            //     yield return StartCoroutine(DownloadProgress(process_oper));
            // }

            AssetBundleCreateRequest abRequest = null;
            string sceneABName = AssetsObscureUtil.GetABFileName(levelName.ToLower() + ".unity3d");
            ulong offset = AssetsObscureUtil.GetABOffset(sceneABName);

            //加载场景依赖包
            string[] deps = assetBundleManifest.GetAllDependencies(sceneABName);
            if (deps.Length > 0)
            {
                for (int idx = 0; idx < deps.Length; idx++)
                {
                    string depABName = deps[idx];
                    if (mBundlesLoaded.ContainsKey(depABName)) continue;
                    if (mCurLoadingBundleDic.ContainsKey(depABName))
                    {
                        continue;
                    }

                    string path = FileSystem.LocalDocumentPath + depABName;
                    ulong depOffset = AssetsObscureUtil.GetABOffset(depABName);
#if !UNITY_INSTANTGAME
                    if (!FileSystem.Exists(path))
                    {
                        path = FileSystem.LocalPackagePath + depABName;
                    }
#endif
                    abRequest = AssetBundle.LoadFromFileAsync(path, 0, depOffset);
                    syncReqDict.Add(depABName, abRequest);
                    mCurLoadingBundleDic.Add(depABName, new LoadTask(depABName));
                }

                foreach (var p in syncReqDict)
                {
                    AssetBundleCreateRequest req = p.Value;
                    yield return req;

                    Bundle depBundle = new Bundle(req.assetBundle, p.Key);
                    mBundlesLoaded.Add(p.Key, depBundle);
                    mCurLoadingBundleDic.Remove(p.Key);
                }

                syncReqDict.Clear();
            }

            //加载场景ab
            string sceneABPath = FileSystem.LocalDocumentPath + sceneABName;
#if !UNITY_INSTANTGAME
            if (!FileSystem.Exists(sceneABPath))
            {
                sceneABPath = FileSystem.LocalPackagePath + sceneABName;
            }
#endif
            abRequest = AssetBundle.LoadFromFileAsync(sceneABPath, 0, offset);
            yield return abRequest;
            Bundle bundle = new Bundle(abRequest.assetBundle, levelName);
            mBundlesLoaded.Add(levelName, bundle);
        }
        else
        {
            DebugHelper.Log("[LoadSceneAssetbundle].mBundlesLoaded.ContainsKey {0}", levelName);
            mBundlesLoaded[levelName].LastUsedTime = Time.realtimeSinceStartup;
        }

        yield return 1;

        AsyncOperation ao = SceneManager.LoadSceneAsync(levelName, LoadSceneMode.Single);
        yield return ao;
        ao = null;
    }

    public Shader FindShader(string shaderName, string shaderPath)
    {
        string shaderABName = AssetsObscureUtil.GetABFileName("shader.unity3d");
#if UNITY_EDITOR
        if (!Constants.AssetbundleMode) //editor mode LocalModeOrAssetbundleMode; Local;
        {
            return Shader.Find(shaderName);
        }
        else //TestMode with local assetBundle mode;
        {
            if (!mBundlesLoaded.ContainsKey(shaderABName))
                return null;

            AssetBundle bundle = mBundlesLoaded[shaderABName].Asset;
            if(bundle!=null)
            {
                Shader shader = bundle.LoadAsset<Shader>(shaderPath + ".shader");
                return shader;
            }
            return null;
        }
#else
        if (!mBundlesLoaded.ContainsKey(shaderABName))
            return null;

        AssetBundle bundle = mBundlesLoaded[shaderABName].Asset;
        if (bundle != null)
        {
            Shader shader = bundle.LoadAsset<Shader>(shaderPath + ".shader");
            return shader;
        }
        return null;
#endif
    }

    public GameObject GetAssetFromResource(string assetName)
    {
        GameObject asset = Resources.Load<GameObject>(assetName);
        return asset;
    }

    public T GetAssetFromResources<T>(string assetName) where T : UnityEngine.Object
    {
        T asset = Resources.Load<T>(assetName);
        return asset;
    }

    public int GetAsset<T>(AssetCallbackWithParams<T> callback, ELoadType type, long seqId, string pathName, params string[] assetName)
    {
#if UNITY_EDITOR
        if (!Application.isPlaying)//editor mode Not Playing;
        {
            StartCoroutine(LoadFromLocalAssetData<T>(callback, seqId, pathName, assetName));
            return 1;
        }
        else if (!Constants.AssetbundleMode) //editor mode LocalModeOrAssetbundleMode; Local;
        {
            StartCoroutine(LoadFromLocalAssetData<T>(callback, seqId, pathName, assetName));
            return 1;
        }
        else //TestMode with local assetBundle mode;
        {
            return LoadFromAssetbundle<T>(callback, type, seqId, pathName, assetName);
        }
#else
        return LoadFromAssetbundle<T>(callback, type, seqId, pathName, assetName);
#endif
    }

    public void CancelLoadAsset(long seqId)
    {
        foreach (var p in mBundlesLoading)
        {
            LoadTask task = p.Value;
            if (task != null && task.IsExist(seqId))
            {
                task.RemoveTask(seqId);
                if (task.AssetsTaskCnt == 0)
                {
                    mBundlesLoading.Remove(task.BundleName);
                    mLoadTasks.Remove(task);
                }
                return;
            }
        }
    }

    IEnumerator LoadFromLocalAssetData<T>(AssetCallbackWithParams<T> callback, long seqId, string pathName, params string[] assetName)
    {
#if UNITY_EDITOR
        if (typeof(T).Equals(typeof(AssetBundle)))
        {
            DebugHelper.LogError("LoadFromLocalAssetData 不能加载类型是AssetBundle的资源");
            yield break;
        }

        if (typeof(T).Equals(typeof(List<GameObject>)))
        {
            List<GameObject> gos = new List<GameObject>();
            if (assetName.Length <= 0)
            {
                List<string> files = FileSystem.getAllFilesPath(pathName);
                for (int i = 0; i < files.Count; ++i)
                {
                    if (files[i] != "")
                    {
                        GameObject g = UnityEditor.AssetDatabase.LoadAssetAtPath<GameObject>(files[i]);
                        gos.Add(g);
                    }
                }
            }
            else
            {
                string path = "";
                for (int i = 0; i < assetName.Length; ++i)
                {
                    if (!string.IsNullOrEmpty(assetName[i]))
                    {
                        if (!string.IsNullOrEmpty(pathName))
                        {
                            path = string.Format("{0}/{1}.prefab", pathName, assetName[i]);
                        }
                        else
                        {
                            path = string.Format("{0}.prefab", assetName[i]);
                        }

                        GameObject g = UnityEditor.AssetDatabase.LoadAssetAtPath<GameObject>(path);
                        gos.Add(g);
                    }
                }
            }

            if(Application.isPlaying)
                yield return new WaitForEndOfFrame();
            callback.DynamicInvoke(gos, seqId, pathName, assetName);
        }
        else if (typeof(T).Equals(typeof(List<Texture2D>)))
        {
            List<Texture2D> gos = new List<Texture2D>();
            string path = "";
            for (int i = 0; i < assetName.Length; ++i)
            {
                if (!string.IsNullOrEmpty(assetName[i]))
                {
                    if(!string.IsNullOrEmpty(pathName))
                    {
                        path = string.Format("{0}/{1}.png", pathName, assetName[i]);
                    }
                    else
                    {
                        path = string.Format("{0}.png", assetName[i]);
                    }
                    
                    Texture2D g = UnityEditor.AssetDatabase.LoadAssetAtPath<Texture2D>(path);
                    gos.Add(g);
                }
            }

            if (Application.isPlaying)
                yield return new WaitForEndOfFrame();
            callback.DynamicInvoke(gos, seqId, pathName, assetName);
        }
        else if (typeof(T).Equals(typeof(List<Sprite>)))
        {
            List<Sprite> gos = new List<Sprite>();
            string path = "";
            for (int i = 0; i < assetName.Length; ++i)
            {
                if (!string.IsNullOrEmpty(assetName[i]))
                {
                    if (!string.IsNullOrEmpty(pathName))
                    {
                        path = string.Format("{0}/{1}.png", pathName, assetName[i]);
                    }
                    else
                    {
                        path = string.Format("{0}.png", assetName[i]);
                    }

                    Sprite sp = UnityEditor.AssetDatabase.LoadAssetAtPath<Sprite>(path);
                    gos.Add(sp);
                }
            }

            if (Application.isPlaying)
                yield return new WaitForEndOfFrame();
            callback.DynamicInvoke(gos, seqId, pathName, assetName);
        }
        else if (typeof(T).Equals(typeof(List<TextAsset>)))
        {
            List<TextAsset> gos = new List<TextAsset>();
            if (assetName.Length <= 0)
            {
                List<string> files = FileSystem.getAllFilesPath(pathName);
                for (int i = 0; i < files.Count; ++i)
                {
                    if (files[i] != "")
                    {
                        TextAsset g = UnityEditor.AssetDatabase.LoadAssetAtPath<TextAsset>(files[i]);
                        gos.Add(g);
                    }
                }
            }
            else
            {
                if (assetName[0] != "")
                {
                    string path = "";
                    for (int i = 0; i < assetName.Length; ++i)
                    {
                        if (assetName[i] != "")
                        {
                            if(!string.IsNullOrEmpty(pathName))
                                path = string.Format("{0}/{1}", pathName, assetName[i]);
                            else
                                path = string.Format("{0}", assetName[i]);

                            TextAsset g = UnityEditor.AssetDatabase.LoadAssetAtPath<TextAsset>(path);
                            if (g != null)
                                gos.Add(g);
                        }
                    }
                }
            }
            if (Application.isPlaying)
                yield return new WaitForEndOfFrame();
            callback.DynamicInvoke(gos, seqId, pathName, assetName);
        }
        else if (typeof(T).Equals(typeof(List<PlayableAsset>)))
        {
            List<PlayableAsset> gos = new List<PlayableAsset>();
            string path = "";
            if (assetName.Length > 0)
            {
                for (int i = 0; i < assetName.Length; ++i)
                {
                    if (assetName[i] != "")
                    {
                        if(!string.IsNullOrEmpty(pathName))
                            path = string.Format("{0}/{1}.playable", pathName, assetName[i]);
                        else
                            path = string.Format("{0}.playable", assetName[i]);
                        PlayableAsset g = UnityEditor.AssetDatabase.LoadAssetAtPath<PlayableAsset>(path);
                        gos.Add(g);
                    }
                }
            }
            else
            {
                string[] paths = Directory.GetFiles(pathName);
                foreach (string subPath in Directory.GetFiles(pathName))
                {
                    path = subPath.Replace('\\', '/');
                    string ext = Path.GetExtension(path);
                    if ((ext != ".meta") && (ext != ".unity"))
                    {
                        PlayableAsset g = UnityEditor.AssetDatabase.LoadAssetAtPath<PlayableAsset>(path);
                        gos.Add(g);
                    }
                }
            }
            if (Application.isPlaying)
                yield return new WaitForEndOfFrame();
            callback.DynamicInvoke(gos, seqId, pathName, assetName);
        }
        else if (typeof(T).Equals(typeof(List<RuntimeAnimatorController>)))
        {
            if (assetName == null || assetName.Length == 0)
            {
                DebugHelper.LogError("error  assetName == null ");
                callback.DynamicInvoke(null, seqId, pathName, assetName);
                yield break;
            }

            List<RuntimeAnimatorController> racs = new List<RuntimeAnimatorController>();
            string path = "";
            for (int i = 0; i < assetName.Length; ++i)
            {
                if (!string.IsNullOrEmpty(assetName[i]))
                {
                    if (!string.IsNullOrEmpty(pathName))
                    {
                        path = string.Format("{0}/{1}.controller", pathName, assetName[i]);
                    }
                    else
                    {
                        path = string.Format("{0}.controller", assetName[i]);
                    }
                    
                    RuntimeAnimatorController rac = UnityEditor.AssetDatabase.LoadAssetAtPath<RuntimeAnimatorController>(path);
                    racs.Add(rac);
                }
            }
            if (Application.isPlaying)
                yield return new WaitForEndOfFrame();
            callback.DynamicInvoke(racs, seqId, pathName, assetName);
        }
        else if (typeof(T).Equals(typeof(List<AudioClip>)))
        {
            List<AudioClip> gos = new List<AudioClip>();
            for (int i = 0; i < assetName.Length; ++i)
            {
                if (!string.IsNullOrEmpty(assetName[i]))
                {
                    string path = string.Format("{0}.ogg", pathName);
                    if (!path.Contains(assetName[i]))
                    {
                        if (!string.IsNullOrEmpty(pathName))
                            path = string.Format("{0}/{1}.ogg", pathName, assetName[i]);
                        else
                            path = string.Format("{0}.ogg", assetName[i]);
                    }

                    AudioClip ac = UnityEditor.AssetDatabase.LoadAssetAtPath<AudioClip>(path);
                    gos.Add(ac);
                }
            }

            if (Application.isPlaying)
                yield return new WaitForEndOfFrame();
            callback.DynamicInvoke(gos, seqId, pathName, assetName);
        }
        else if (typeof(T).IsSubclassOf(typeof(ScriptableObject)))
        {
            string path = pathName;
            if (!path.Contains(assetName[0])) { 
                if(!string.IsNullOrEmpty(pathName))
                    path = string.Format("{0}/{1}", pathName, assetName[0]);
                else
                    path = string.Format("{0}", assetName[0]);
            }

            ScriptableObject so = UnityEditor.AssetDatabase.LoadAssetAtPath<ScriptableObject>(path);

            if (Application.isPlaying)
                yield return new WaitForEndOfFrame();
            callback.DynamicInvoke(so, pathName, assetName);
        }
        else if (typeof(T).Equals(typeof(GameObject)))//访问单个资源
        {
            if (assetName.Length > 0 && !string.IsNullOrEmpty(assetName[0]))
            {
                string path = string.Format("{0}.prefab", pathName);
                if (!File.Exists(path)) { 
                    if(!string.IsNullOrEmpty(pathName))
                        path = string.Format("{0}/{1}.prefab", pathName, assetName[0]);
                    else
                        path = string.Format("{0}.prefab", assetName[0]);
                }

                GameObject g = UnityEditor.AssetDatabase.LoadAssetAtPath<GameObject>(path);

                if (Application.isPlaying)
                    yield return new WaitForEndOfFrame();
                callback.DynamicInvoke(g, seqId, pathName, assetName);
            }
        }
        else if (typeof(T).Equals(typeof(AudioClip)))//访问单个资源
        {
            if (assetName.Length > 0 && !string.IsNullOrEmpty(assetName[0]))
            {
                string path = string.Format("{0}.ogg", pathName);
                if (!path.Contains(assetName[0])) { 
                    if(!string.IsNullOrEmpty(pathName))
                        path = string.Format("{0}/{1}.ogg", pathName, assetName[0]);
                    else
                        path = string.Format("{0}.ogg", assetName[0]);
                }

                AudioClip ac = UnityEditor.AssetDatabase.LoadAssetAtPath<AudioClip>(path);

                if (Application.isPlaying)
                    yield return new WaitForEndOfFrame();
                callback.DynamicInvoke(ac, seqId, pathName, assetName);
            }
        }
        else if (typeof(T).Equals(typeof(VideoClip)))//访问单个资源
        {
            if (assetName.Length > 0 && !string.IsNullOrEmpty(assetName[0]))
            {
                string path = string.Format("{0}.mp4", pathName);
                if (!path.Contains(assetName[0])) { 
                    if(!string.IsNullOrEmpty(pathName))
                        path = string.Format("{0}/{1}.mp4", pathName, assetName[0]);
                    else
                        path = string.Format("{0}.mp4", assetName[0]);
                }


                VideoClip vc = UnityEditor.AssetDatabase.LoadAssetAtPath<VideoClip>(path);

                if (Application.isPlaying)
                    yield return new WaitForEndOfFrame();
                callback.DynamicInvoke(vc, seqId, pathName, assetName);
            }
        }
        else if (typeof(T).Equals(typeof(Texture2D)))//访问单个资源
        {
            string path = string.Format("{0}.png", pathName);
            if (!pathName.Contains(assetName[0])) { 
                if(!string.IsNullOrEmpty(pathName))
                    path = string.Format("{0}/{1}.png", pathName, assetName[0]);
                else
                    path = string.Format("{0}.png", assetName[0]);
            }

            Texture2D ac = UnityEditor.AssetDatabase.LoadAssetAtPath<Texture2D>(path);

            if (Application.isPlaying)
                yield return new WaitForEndOfFrame();
            callback.DynamicInvoke(ac, seqId, pathName, assetName);
        }
        else if (typeof(T).Equals(typeof(Sprite)))//访问单个资源
        {
            string path = string.Format("{0}.png", pathName);
            if (!pathName.Contains(assetName[0])) { 
                if(!string.IsNullOrEmpty(pathName))
                    path = string.Format("{0}/{1}.png", pathName, assetName[0]);
                else
                    path = string.Format("{0}.png", assetName[0]);
            }

            Sprite sp = UnityEditor.AssetDatabase.LoadAssetAtPath<Sprite>(path);

            if (Application.isPlaying)
                yield return new WaitForEndOfFrame();
            callback.DynamicInvoke(sp, seqId, pathName, assetName);
        }
        else if (typeof(T).Equals(typeof(Material)))//访问单个资源
        {
            string path = string.Format("{0}.mat", pathName);
            if (!pathName.Contains(assetName[0])) { 
                if(!string.IsNullOrEmpty(pathName))
                    path = string.Format("{0}/{1}.mat", pathName, assetName[0]);
                else
                    path = string.Format("{0}.mat", assetName[0]);
            }

            Material mat = UnityEditor.AssetDatabase.LoadAssetAtPath<Material>(path);

            if (Application.isPlaying)
                yield return new WaitForEndOfFrame();
            callback.DynamicInvoke(mat, seqId, pathName, assetName);
        }
        else if (typeof(T).Equals(typeof(RuntimeAnimatorController)))//访问单个资源
        {
            string path = string.Format("{0}.controller", pathName);
            if (!pathName.Contains(assetName[0])) { 
                if(!string.IsNullOrEmpty(pathName))
                    path = string.Format("{0}/{1}.controller", pathName, assetName[0]);
                else
                    path = string.Format("{0}.controller", assetName[0]);
            }

            RuntimeAnimatorController rac = UnityEditor.AssetDatabase.LoadAssetAtPath<RuntimeAnimatorController>(path);

            if (Application.isPlaying)
                yield return new WaitForEndOfFrame();
            callback.DynamicInvoke(rac, seqId, pathName, assetName);
        }
        else
        {
            //DebugHelper.LogError("LoadFromLocalAssetData type is Error: "+ pathName);
        }
#else
        yield break;
#endif
    }

    public T LoadAssetSync<T>(string pathName, string assetName) where T : UnityEngine.Object
    {
        T asset = null;
#if UNITY_EDITOR
        if (!Constants.AssetbundleMode)
        {
            if (!string.IsNullOrEmpty(assetName))
            {
                string path;
                if (FileUtils.HasExtension(assetName))
                {
                    path = string.Format("{0}/{1}", pathName, assetName);
                }
                else
                {
                    string ext = GetFileTypeExtention(typeof(T));
                    path = string.Format("{0}/{1}{2}", pathName, assetName, ext);
                }

                asset = UnityEditor.AssetDatabase.LoadAssetAtPath<T>(path);
            }
            return asset;
        }
#endif
        if (!string.IsNullOrEmpty(assetName))
        {
            string abName = GetABName(pathName + "/" + assetName, typeof(T));
            ulong offset = AssetsObscureUtil.GetABOffset(abName);
            if (!string.IsNullOrEmpty(abName))
            {
                string abPath = string.Format("{0}{1} ", FileSystem.LocalDocumentPath, abName);
                if (!FileSystem.Exists(abPath))
                {
                    abPath = string.Format("{0}{1}", FileSystem.LocalPackagePath, abName);
                }

                AssetBundle ab = null;
                if (mBundlesLoaded.ContainsKey(abName))
                {
                    Bundle bundle = mBundlesLoaded[abName];
                    ab = bundle.Asset;
                }
                else
                {
                    string[] deps = assetBundleManifest.GetAllDependencies(abName);
                    if (deps != null)
                    {
                        for (int i = 0; i < deps.Length; ++i)
                        {
                            string depabName = deps[i];
                            if (mBundlesLoaded.ContainsKey(depabName))
                                continue;
                            string depabPath = string.Format("{0}{1} ", FileSystem.LocalDocumentPath, depabName);
                            ulong depOffset = AssetsObscureUtil.GetABOffset(depabName);
                            if (!FileSystem.Exists(depabPath))
                            {
                                depabPath = string.Format("{0}{1}", FileSystem.LocalPackagePath, depabName);
                            }
                            Debug.Log("********LoadAssetSync<T>: {0}" + assetName);
                            AssetBundle depab = AssetBundle.LoadFromFile(depabPath, 0, depOffset);
                            Bundle depabBundle = new Bundle(depab, depabName);
                            mBundlesLoaded.Add(depabName, depabBundle);
                        }
                    }
                    Debug.Log("----------LoadAssetSync<T>: {0}" + assetName);
                    ab = AssetBundle.LoadFromFile(abPath, 0, offset);
                    Bundle abBundle = new Bundle(ab, abName);
                    mBundlesLoaded.Add(abName, abBundle);
                }
                if (!FileUtils.HasExtension(assetName))
                {
                    assetName += GetFileTypeExtention(typeof(T));
                }
                if (!string.IsNullOrEmpty(pathName))
                    assetName = pathName + "/" + assetName;
                asset = ab.LoadAsset<T>(assetName);
            }
            else
            {
                DebugHelper.LogError(assetName + " 资源没有放入ab包");
            }
        }
        return asset;
    }

    public Object[] LoadABSync(string pathName, params string[] assetName)
    {
        Object[] objs = null;
#if UNITY_EDITOR
        if (!Constants.AssetbundleMode)
        {

            objs = new Object[assetName.Length];
            for (int i = 0; i < assetName.Length; ++i)
            {
                if (!string.IsNullOrEmpty(assetName[i]))
                {
                    string path = string.Format("{0}/{1}.prefab", pathName, assetName[i]);
                    Object g = UnityEditor.AssetDatabase.LoadAssetAtPath<Object>(path);
                    objs[i] = g;
                }
            }
            return objs;
        }
#endif
        string abName = pathName.Replace("Assets/Content/", "");
        abName = abName.Replace("/", "");
        abName = abName.ToLower() + ".unity3d";

        abName = AssetsObscureUtil.GetABFileName(abName);
        ulong offset = AssetsObscureUtil.GetABOffset(abName);

        string abPath = string.Format("{0}{1} ", FileSystem.LocalDocumentPath, abName);

        if (!FileSystem.Exists(abPath))
        {
            abPath = string.Format("{0}{1}", FileSystem.LocalPackagePath, abName);
        }

        AssetBundle ab = null;
        if (mBundlesLoaded.ContainsKey(abName))
        {
            Bundle bundle = mBundlesLoaded[abName];
            ab = bundle.Asset;
        }
        else
        {
            string[] deps = assetBundleManifest.GetAllDependencies(abName);
            if (deps != null)
            {
                for (int i = 0; i < deps.Length; ++i)
                {
                    string depabName = deps[i];
                    if (mBundlesLoaded.ContainsKey(depabName))
                        continue;
                    string depabPath = string.Format("{0}{1} ", FileSystem.LocalDocumentPath, depabName);
                    ulong depOffset = AssetsObscureUtil.GetABOffset(depabName);
                    if (!FileSystem.Exists(depabPath))
                    {
                        depabPath = string.Format("{0}{1}", FileSystem.LocalPackagePath, depabName);
                    }
                    AssetBundle depab = AssetBundle.LoadFromFile(depabPath, 0, depOffset);
                    Bundle depabBundle = new Bundle(depab, depabName);
                    mBundlesLoaded.Add(depabName, depabBundle);
                }
            }
            ab = AssetBundle.LoadFromFile(abPath, 0, offset);
            Bundle abBundle = new Bundle(ab, abName);
            mBundlesLoaded.Add(abName, abBundle);
        }

        if (assetName == null || assetName.Length == 0)
        {
            objs = ab.LoadAllAssets();
        }
        else
        {
            objs = new Object[assetName.Length];
            for (int i = 0; i < assetName.Length; i++)
            {
                objs[i] = ab.LoadAsset(assetName[i]);
            }
        }
        return objs;
    }

    Dictionary<string, List<string>> tempDic = new Dictionary<string, List<string>>();
    int LoadFromAssetbundle<T>(AssetCallbackWithParams<T> callback, ELoadType loadType, long seqId, string pathName, params string[] assetName)
    {
        string abName = null;
        if (assetName == null || assetName.Length == 0)
        {
            abName = pathName.Replace("Assets/Content/", "");
            abName = abName.Replace("/", "").ToLower();
            if (!abName.Contains(".unity3d"))
            {
                abName = abName + ".unity3d";
            }
            abName = AssetsObscureUtil.GetABFileName(abName);
            AddLoadTask<T>(seqId, abName, pathName, callback, loadType, assetName);
            return 1;
        }
        else
        {
            tempDic.Clear();

            for (int idx = 0; idx < assetName.Length; idx++)
            {
                string fullPath = assetName[idx];
                if (!string.IsNullOrEmpty(pathName))
                {
                    fullPath = pathName + "/" + assetName[idx];
                }

                string tempAB = GetABName(fullPath, typeof(T));
                if (!string.IsNullOrEmpty(tempAB))
                {
                    List<string> assetList = null;
                    if (!tempDic.TryGetValue(tempAB, out assetList))
                    {
                        assetList = new List<string>();
                        tempDic.Add(tempAB, assetList);
                    }
                    assetList.Add(assetName[idx]);
                }
                else
                {
                    DebugHelper.LogError(string.Format("{0} 没有打入ab包中", fullPath));
                }
            }

            if (tempDic.Count > 0)
            {
                foreach (var p in tempDic)
                {
                    AddLoadTask<T>(seqId, p.Key, pathName, callback, loadType, p.Value.ToArray());
                }
            }
            return tempDic.Count;
        }
    }

    void AddLoadTask<T>(long seqId, string abName, string pathName, AssetCallbackWithParams<T> callback, ELoadType loadType, params string[] assetName)
    {
        LoadTask task = new LoadTask(seqId, abName, pathName, assetName, callback as Delegate, true, typeof(T), loadType);
        if (!mBundlesLoaded.ContainsKey(task.BundleName))
        {
            if (mCurLoadingBundleDic.ContainsKey(task.BundleName))
            {
                LoadTask task1 = mCurLoadingBundleDic[task.BundleName];
                task1.ChangeTask(seqId, abName, pathName, assetName, callback as Delegate, true, typeof(T), loadType);
            }
            else
            {
                if (mBundlesLoading.ContainsKey(task.BundleName))
                {
                    mBundlesLoading[task.BundleName].AssetsTask.AddRange(task.AssetsTask);
                    return;
                }
                else
                {
                    if (mCurLoadingBundleDic.ContainsKey(task.BundleName))
                    {
                        DebugHelper.LogError("mCurLoadingBundleDic 包函数了:" + task.BundleName);
                    }

                    mBundlesLoading.Add(task.BundleName, task);
                }
                mLoadTasks.Add(task);
            }
        }
        else
        {
            if (mBundlesLoaded.ContainsKey(task.BundleName))
            {
                mBundlesLoaded[task.BundleName].Priority = 0;
            }

            string[] deps = assetBundleManifest.GetAllDependencies(task.BundleName);
            if (deps.Length > 0)
            {
                string depName = string.Empty;
                for (int i = 0; i < deps.Length; ++i)
                {
                    depName = deps[i];
                    if (mBundlesLoaded.ContainsKey(depName))
                    {
                        mBundlesLoaded[depName].Priority = 0;
                    }
                }
            }

            mLoadFinshedTask.Enqueue(task);
        }
    }

    void Update()
    {
        while (mLoadFinshedTask.Count > 0)
        {
            LoadTask task = mLoadFinshedTask.Dequeue();
            if (mBundlesLoaded.ContainsKey(task.BundleName))
            {
                AsyncLoad(task);
            }
        }

        while (mLoadingCoroutineCount < MaxLoadingCoroutineCount && mLoadTasks.Count > 0)
        {
            LoadTask task = mLoadTasks[0];
            task.LoadStartTime = Time.realtimeSinceStartup;
            LoadAssetTask(task);
            mLoadTasks.RemoveAt(0);
        }

        for (int i = 0; i < mAssetbundleLoadTasks.Count; ++i)
        {
            mAssetbundleLoadTasks[i].Update();
        }
    }

    #region inner_methods
    public AssetBundleCreateRequest CreatePackageLoader(string bundleName)
    {
        AssetBundleCreateRequest abRequest = null;
        try
        {
            string path = string.Format("{0}{1}", FileSystem.LocalDocumentPath, bundleName);
            ulong offset = AssetsObscureUtil.GetABOffset(bundleName);
#if !UNITY_INSTANTGAME
            if (!FileSystem.Exists(path))
            {
                path = string.Format("{0}{1}", FileSystem.LocalPackagePath, bundleName);
            }
#endif
            abRequest = AssetBundle.LoadFromFileAsync(path, 0, offset);
        }
        catch (Exception e)
        {
            DebugHelper.LogError("Load AB: " + e.ToString());
            return null;
        }
        return abRequest;

    }

    List<string> temp = new List<string>();
    public void NotifyAssetbundleLoaded(LoadTask task, LoadAssetbundleTask abTask)
    {
        //DebugHelper.LogError("[bhy] loadingAb Finish: " + task.BundleName + " IsDependencyDone:"+task.IsDependency);
#if PROFILE
        UnityEngine.Profiling.Profiler.BeginSample("Loaded" + task.BundleName);
#endif

        mAssetbundleLoadTasks.Remove(abTask);

        if (mCurLoadingBundleDic.ContainsKey(task.BundleName))
        {
            mCurLoadingBundleDic.Remove(task.BundleName);
        }

        mBundlesLoaded.Add(task.BundleName, new Bundle(task.Bundle, task.BundleName));

        for (int i = 0; i < mAssetbundleLoadTasks.Count; ++i)
        {
            if (!mAssetbundleLoadTasks[i].Loader.IsDependencyDone)
            {
                CheckDependencyOnAssetbundleLoaded(mAssetbundleLoadTasks[i].Loader);
            }
        }


        if (task.LoadType != ELoadType.AssetBundle && task.IsDependencyDone)
        {
            LoadAssetTaskFinish(task);
        }
        else if (task.LoadType == ELoadType.AssetBundle && task.IsDependencyDone)
        {
            if (mBundlesLoading.ContainsKey(task.BundleName))
            {
                LoadTask loadingTask = mBundlesLoading[task.BundleName];
                if (loadingTask.IsDependencyDone)
                {
                    loadingTask.Bundle = task.Bundle;
                    LoadAssetTaskFinish(loadingTask);
                }
            }
        }

        temp.Clear();
        foreach (var p in mBundlesLoading)
        {
            if (p.Value.IsDependency)
            {
                if (CheckDependencyPackageInfo(p.Value))
                {
                    temp.Add(p.Key);
                }
            }
        }

        for (int idx = 0; idx < temp.Count; idx++)
        {
            mBundlesLoading.Remove(temp[idx]);
        }

#if PROFILE
        UnityEngine.Profiling.Profiler.EndSample();
#endif
    }

    void LoadAssetTask(LoadTask task)
    {
        mLoadingCoroutineCount++;
        if (CheckDependencyPackageInfo(task))
        {
            mBundlesLoading.Remove(task.BundleName);
        }
    }

    void LoadAssetTaskFinish(LoadTask task)
    {
        mLoadingCoroutineCount--;
        mLoadFinshedTask.Enqueue(task);
        mBundlesLoading.Remove(task.BundleName);
    }

    bool CheckDependencyPackageInfo(LoadTask task)
    {
        string bundleName = task.BundleName;
        string[] deps = assetBundleManifest.GetAllDependencies(bundleName);
        if (deps == null || deps.Length == 0)
        {
            task.IsDependency = false;
            task.IsDependencyDone = true;
        }
        else
        {
            task.IsDependency = true;
            task.IsDependencyDone = true;

            for (int i = 0; i < deps.Length; ++i)
            {
                string depPackage = deps[i];
                if (mBundlesLoaded.ContainsKey(depPackage))
                    continue;
                task.IsDependencyDone = false;
                NotifyLoadAssetbundle(depPackage);
            }
        }

        if (task.IsDependencyDone)
        {
            if (mBundlesLoaded.ContainsKey(task.BundleName))
            {
                mLoadingCoroutineCount--;
                mLoadFinshedTask.Enqueue(task);
                return true;
            }
            else
            {
                NotifyLoadAssetbundle(task.BundleName, task);
            }
        }
        return false;
    }

    void NotifyLoadAssetbundle(string bundleName, LoadTask task = null)
    {
        if (mBundlesLoaded.ContainsKey(bundleName) || mCurLoadingBundleDic.ContainsKey(bundleName))
        {
            return;
        }

        LoadTask t = task;
        if (t == null)
        {
            t = new LoadTask(bundleName);
        }

        mCurLoadingBundleDic.Add(bundleName, t);
        mAssetbundleLoadTasks.Add(new LoadAssetbundleTask(t));
    }

    void CheckDependencyOnAssetbundleLoaded(LoadTask task)
    {
        string bundleName = task.BundleName;
        string[] deps = assetBundleManifest.GetAllDependencies(bundleName);
        if (deps == null || deps.Length == 0)
        {
            task.IsDependency = false;
            task.IsDependencyDone = true;
        }
        else
        {
            task.IsDependencyDone = true;

            for (int i = 0; i < deps.Length; ++i)
            {
                string depPackage = deps[i];
                if (mBundlesLoaded.ContainsKey(depPackage))
                    continue;
                task.IsDependencyDone = false;

                NotifyLoadAssetbundle(depPackage);
            }
        }
    }

    void AsyncLoad(LoadTask task)
    {
        Bundle bundle = mBundlesLoaded[task.BundleName];
        if (bundle == null)
        {
            DebugHelper.LogWarning("[AssetsMgr].DoCallBack Bundle not exists for name [{0}]", task.BundleName);
            return;
        }

        try
        {
            if (task.DelegateType.Equals(typeof(List<GameObject>)))
            {
                for (int j = 0; j < task.AssetsTask.Count; ++j)
                {
                    LoadAssetsTask lat = task.AssetsTask[j];
                    StartCoroutine(AsyncMultiAssetFromAB<GameObject>(task.BundleName, bundle.Asset, lat));
                }
            }
            else if (task.DelegateType.Equals(typeof(List<TextAsset>)))
            {
                for (int j = 0; j < task.AssetsTask.Count; j++)
                {
                    LoadAssetsTask lat = task.AssetsTask[j];
                    StartCoroutine(AsyncMultiAssetFromAB<TextAsset>(task.BundleName, bundle.Asset, lat));
                }
            }
            else if (task.DelegateType.Equals(typeof(List<AudioClip>)))
            {
                for (int j = 0; j < task.AssetsTask.Count; j++)
                {
                    LoadAssetsTask lat = task.AssetsTask[j];
                    StartCoroutine(AsyncMultiAssetFromAB<AudioClip>(task.BundleName, bundle.Asset, lat));
                }
            }
            else if (task.DelegateType.Equals(typeof(List<Texture2D>)))
            {
                for (int j = 0; j < task.AssetsTask.Count; j++)
                {
                    LoadAssetsTask lat = task.AssetsTask[j];
                    StartCoroutine(AsyncMultiAssetFromAB<Texture2D>(task.BundleName, bundle.Asset, lat));
                }
            }
            else if (task.DelegateType.Equals(typeof(List<Sprite>)))
            {
                for (int j = 0; j < task.AssetsTask.Count; j++)
                {
                    LoadAssetsTask lat = task.AssetsTask[j];
                    StartCoroutine(AsyncMultiAssetFromAB<Sprite>(task.BundleName, bundle.Asset, lat));
                }
            }
            else if (task.DelegateType.Equals(typeof(List<PlayableAsset>)))
            {
                for (int j = 0; j < task.AssetsTask.Count; j++)
                {
                    LoadAssetsTask lat = task.AssetsTask[j];
                    StartCoroutine(AsyncMultiAssetFromAB<PlayableAsset>(task.BundleName, bundle.Asset, lat));
                }
            }
            else if (task.DelegateType.Equals(typeof(List<RuntimeAnimatorController>)))
            {
                for (int j = 0; j < task.AssetsTask.Count; j++)
                {
                    LoadAssetsTask lat = task.AssetsTask[j];
                    StartCoroutine(AsyncMultiAssetFromAB<RuntimeAnimatorController>(task.BundleName, bundle.Asset, lat));
                }
            }
            else if (task.DelegateType.Equals(typeof(Texture2D)))
            {
                for (int j = 0; j < task.AssetsTask.Count; j++)
                {
                    LoadAssetsTask lat = task.AssetsTask[j];
                    StartCoroutine(AsyncSingleAssetFromAB<Texture2D>(task.BundleName, bundle.Asset, lat));
                }
            }
            else if (task.DelegateType.Equals(typeof(GameObject)))
            {
                for (int j = 0; j < task.AssetsTask.Count; j++)
                {
                    LoadAssetsTask lat = task.AssetsTask[j];
                    StartCoroutine(AsyncSingleAssetFromAB<GameObject>(task.BundleName, bundle.Asset, lat));
                }
            }
            else if (task.DelegateType.Equals(typeof(AudioClip)))
            {
                for (int j = 0; j < task.AssetsTask.Count; j++)
                {
                    LoadAssetsTask lat = task.AssetsTask[j];
                    StartCoroutine(AsyncSingleAssetFromAB<AudioClip>(task.BundleName, bundle.Asset, lat));
                }
            }
            else if (task.DelegateType.Equals(typeof(PlayableAsset)))
            {
                for (int j = 0; j < task.AssetsTask.Count; j++)
                {
                    LoadAssetsTask lat = task.AssetsTask[j];
                    StartCoroutine(AsyncSingleAssetFromAB<PlayableAsset>(task.BundleName, bundle.Asset, lat));
                }
            }
            else if (task.DelegateType.Equals(typeof(Material)))
            {
                for (int j = 0; j < task.AssetsTask.Count; j++)
                {
                    LoadAssetsTask lat = task.AssetsTask[j];
                    StartCoroutine(AsyncSingleAssetFromAB<Material>(task.BundleName, bundle.Asset, lat));
                }
            }
            else if (task.DelegateType.Equals(typeof(Sprite)))
            {
                for (int j = 0; j < task.AssetsTask.Count; j++)
                {
                    LoadAssetsTask lat = task.AssetsTask[j];
                    StartCoroutine(AsyncSingleAssetFromAB<Sprite>(task.BundleName, bundle.Asset, lat));
                }
            }
            else if (task.DelegateType.Equals(typeof(RuntimeAnimatorController)))
            {
                for (int j = 0; j < task.AssetsTask.Count; j++)
                {
                    LoadAssetsTask lat = task.AssetsTask[j];
                    StartCoroutine(AsyncSingleAssetFromAB<RuntimeAnimatorController>(task.BundleName, bundle.Asset, lat));
                }
            }
            else
            {
                DebugHelper.LogError("[DoCallBack].cant support  type {0}", task.DelegateType);
            }
        }
        catch (Exception e)
        {
            DebugHelper.LogException(e);
        }
        finally
        {

        }
    }

    IEnumerator AsyncMultiAssetFromAB<T>(string assetBunleName, AssetBundle bundle, LoadAssetsTask assetsTask) where T : UnityEngine.Object
    {
        if (bundle == null)
            yield break;

        List<T> gos = new List<T>();

        if (assetsTask.AssetName.Length > 0)
        {
            HashSet<string> dic = new HashSet<string>();

            for (int idx = 0; idx < assetsTask.AssetName.Length; idx++)
            {
                string assetName = assetsTask.AssetName[idx].Trim();
                if (string.IsNullOrEmpty(assetName)) continue;

                if (!FileUtils.HasExtension(assetName))
                {
                    assetName += GetFileTypeExtention(typeof(T));
                }

                if (dic.Contains(assetName)) continue;

                string assetFilePath = assetName;
                if (!string.IsNullOrEmpty(assetsTask.AssetPath))
                    assetFilePath = assetsTask.AssetPath + "/" + assetName;

                AssetBundleRequest req = bundle.LoadAssetAsync<T>(assetFilePath);
                dic.Add(assetName);
                yield return req;
                T g = req.asset as T;
                if (g == null)
                {
                    DebugHelper.LogError("AsyncMultiAssetFromAB has null object: " + assetName);
                }
                gos.Add(g);
            }
        }
        else
        {
            AssetBundleRequest req = bundle.LoadAllAssetsAsync<T>();
            yield return req;
            var allAssets = req.allAssets;
            for (int idx = 0, idxMax = allAssets.Length; idx < idxMax; idx++)
            {
                gos.Add(allAssets[idx] as T);
            }
        }

        assetsTask.Invoke(gos);
    }

    IEnumerator AsyncSingleAssetFromAB<T>(string assetBunleName, AssetBundle bundle, LoadAssetsTask assetsTask) where T : UnityEngine.Object
    {
        if (bundle == null)
            yield break;

        if (assetsTask.AssetName.Length > 0 && !string.IsNullOrEmpty(assetsTask.AssetName[0]))
        {
            string name = "";
            if (!string.IsNullOrEmpty(assetsTask.AssetPath))
                name = assetsTask.AssetPath + "/" + assetsTask.AssetName[0] + GetFileTypeExtention(typeof(T));
            else
                name = assetsTask.AssetName[0] + GetFileTypeExtention(typeof(T));

            AssetBundleRequest req = bundle.LoadAssetAsync<T>(name);

            yield return req;

            T g = req.asset as T;

            if (g == null)
            {
                DebugHelper.LogError("AsyncMultiAssetFromAB has null object: " + name);
            }

            assetsTask.Invoke(g);
        }
    }
    #endregion
}
