using System;
using UnityEngine;
using UnityEditor;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Security.Cryptography;

/// <summary>
/// 构建ab包
/// </summary>
public class AssetBundleMap : EditorWindow
{
    /// <summary>
    /// shader都打入这个包
    /// </summary>
    private const string ShaderAbName = "shader.unity3d";

    /// <summary>
    /// 材质球都打入这个包
    /// </summary>
    private const string MatAbName = "mat.unity3d";


    /// <summary>
    /// 临时ab生成目录
    /// </summary>
    private static readonly string TempAssetBundlePath = Application.dataPath + "/../assetbundle";

    private static readonly string TempAssetBundleBakPath = Application.dataPath + "/../assetbundleBak";

    private static readonly string DefaultBakDirPath = "Default";

    private static readonly string ManifestFileExtension = ".manifest";

    /// <summary>
    /// 使用lz4压缩
    /// </summary>
    private static readonly BuildAssetBundleOptions BuildOptions = BuildAssetBundleOptions.DeterministicAssetBundle |
                                                                   BuildAssetBundleOptions.ChunkBasedCompression;


    /// <summary>
    /// 构建全部资源
    /// </summary>
    [MenuItem("AssetBundle/Build Map/Build All AssetBundles")]
    public static void BuildAllAssetBundles(VersionCode resVersionCode)
    {
        Debug.Log("<color=green>================ BuildAllAssetBundles Start================</color>");

        AssetDatabase.Refresh();
        copyBakAssetsToAssetBundle();

        AssetBundleUtil.CleanUnusedAB();
        var buildMap = getAllBuildMap(true);

        var abm = BuildPipeline.BuildAssetBundles(TempAssetBundlePath, buildMap, BuildOptions,
            EditorUserBuildSettings.activeBuildTarget);

        if (abm != null)
        {
            AssetBundleUtil.GetAllAssetsNameInAssetBundle(abm, resVersionCode);
            copyAssetBundleToBakAssets();
            copyBakAssetsToStreamingAssets();
            Debug.Log("<color=green>================ BuildAllAssetBundles Success================</color>");
        }
        else
        {
            Debug.Log("<color=green>================ BuildAllAssetBundles Fail================</color>");
            throw new Pack.PackException("BuildAssetBundles 失败");
        }
    }

    /// <summary>
    /// 只打包lua相关的
    /// 在只修改了lua代码，但是未修改资源的情况下使用
    /// </summary>
    [MenuItem("AssetBundle/Build Map/Build Lua AssetBundles")]
    public static void BuildLuaAssetBundlesMI()
    {
        VersionCode resVersionCode = VersionCode.zeroVersionCode;
        BuildLuaAssetBundles(resVersionCode);
    }

    public static void BuildLuaAssetBundles(VersionCode resVersionCode)
    {
        AssetDatabase.Refresh();
        copyBakAssetsToAssetBundle();

        AssetBundleUtil.CleanUnusedAB();
        var buildMap = getLuaBuildMap(true);

        var abm = BuildPipeline.BuildAssetBundles(TempAssetBundlePath, buildMap, BuildOptions,
            EditorUserBuildSettings.activeBuildTarget);

        if (abm == null)
        {
            throw new Pack.PackException("BuildAssetBundles 失败");
        }

        AssetBundleUtil.GetAllAssetsNameInAssetBundle(abm, resVersionCode);
        copyAssetBundleToBakAssets();
        copyBakAssetsToStreamingAssets();
    }

    private static void copyBakAssetsToAssetBundle()
    {
        if (Directory.Exists(TempAssetBundlePath))
        {
            Directory.Delete(TempAssetBundlePath, true);
        }
        Directory.CreateDirectory(TempAssetBundlePath);
        string path = AssetsObscureUtil.GetUniqueValue();
        string dirPath;
        BuildTarget buildTarget = EditorUserBuildSettings.activeBuildTarget;
        if (!s_AssetbundleSavePaths.ContainsKey(buildTarget))
        {
            return;
        }
        if (string.IsNullOrEmpty(path))
        {
            dirPath = TempAssetBundleBakPath + s_AssetbundleSavePaths[buildTarget] + DefaultBakDirPath;
        }
        else
        {
            dirPath = TempAssetBundleBakPath + s_AssetbundleSavePaths[buildTarget] + path;
        }

        if (!Directory.Exists(dirPath))
        {
            return;
        }

        foreach (string file in Directory.GetFiles(dirPath))
        {
            string fileName = Path.GetFileName(file);
            if (fileName == "assetbundle" || Path.GetExtension(file) == ".manifest")
            {
                string des = Path.Combine(TempAssetBundlePath, fileName);
                File.Copy(file, des, true);
            }
        }
    }

    private static void copyAssetBundleToBakAssets()
    {
        string path = AssetsObscureUtil.GetUniqueValue();
        string dirPath;
        BuildTarget buildTarget = EditorUserBuildSettings.activeBuildTarget;
        if (!s_AssetbundleSavePaths.ContainsKey(buildTarget))
        {
            return;
        }
        if (string.IsNullOrEmpty(path))
        {
            dirPath = TempAssetBundleBakPath + s_AssetbundleSavePaths[buildTarget] + DefaultBakDirPath;
        }
        else
        {
            dirPath = TempAssetBundleBakPath + s_AssetbundleSavePaths[buildTarget] + path;
        }

        if (!Directory.Exists(dirPath))
        {
            Directory.CreateDirectory(dirPath);
        }

        foreach (string file in Directory.GetFiles(TempAssetBundlePath))
        {
            string fileName = Path.GetFileName(file);
            string des = Path.Combine(dirPath, fileName);
            File.Copy(file, des, true);
        }
    }


    /// <summary>
    /// 拷贝打包好的资源到目标目录
    /// </summary>
    private static void copyBakAssetsToStreamingAssets()
    {
        string path = string.Empty;
        if (Directory.Exists(Application.streamingAssetsPath))
        {
            foreach (var item in s_AssetbundleSavePaths)
            {
                path = Application.streamingAssetsPath + item.Value;
                DeleteDirectoryAssets(path, true);
            }
        }

        BuildTarget buildTarget = EditorUserBuildSettings.activeBuildTarget;
        if (!s_AssetbundleSavePaths.ContainsKey(buildTarget))
        {
            return;
        }

        string assetBundlePath = Application.streamingAssetsPath + s_AssetbundleSavePaths[buildTarget];

        if (!Directory.Exists(assetBundlePath))
        {
            Directory.CreateDirectory(assetBundlePath);
        }

        path = AssetsObscureUtil.GetUniqueValue();
        string dirPath;
        if (string.IsNullOrEmpty(path))
        {
            dirPath = TempAssetBundleBakPath + s_AssetbundleSavePaths[buildTarget] + DefaultBakDirPath;
        }
        else
        {
            dirPath = TempAssetBundleBakPath + s_AssetbundleSavePaths[buildTarget] + path;
        }

        #if UNITY_INSTANTGAME
        string assetBundleCCDPath = Application.dataPath + "/../CustomCloudAssets/CloudAB" ;
        if (Directory.Exists(assetBundleCCDPath))
        {
            Directory.Delete(assetBundleCCDPath, true);
        }
        Directory.CreateDirectory(assetBundleCCDPath);
        #endif
        // 拷贝临时打包目录中的ab资源到对应的目录下
        foreach (string file in Directory.GetFiles(dirPath))
        {
            if (Path.GetExtension(file) != ".manifest")
            {
                string fileName = Path.GetFileName(file);
                if (fileName == "assetbundle")
                {
                    fileName = AssetsObscureUtil.GetABFileName(fileName);
                }
                else if (fileName == "assetsmapping.bytes")
                {
                    EncryptAssetsmapping(file, Path.Combine(assetBundlePath, fileName));
                    continue;
                }
                #if UNITY_INSTANTGAME
                string des = Path.Combine(assetBundleCCDPath, fileName);
                #else
                string des = Path.Combine(assetBundlePath, fileName);
                #endif
                File.Copy(file, des, true);
                WriteMeaninglessDataToFile(des);
            }
        }

        AssetDatabase.Refresh();
    }

    private static Dictionary<BuildTarget, string> s_AssetbundleSavePaths = new Dictionary<BuildTarget, string>()
    {
        {BuildTarget.iOS, "/ios/"},
        {BuildTarget.Android, "/AssetsAndroid/"},
        {BuildTarget.StandaloneWindows64, "/AssetsPC/"},
    };

    private static void EncryptAssetsmapping(string destPath, string filePath)
    {
        byte[] bytes = File.ReadAllBytes(destPath);
        byte value;
        int length = bytes.Length;
        for (int i = 0, iMax = Mathf.FloorToInt(length * 0.5f); i < iMax; i += 2)
        {
            value = bytes[i];
            bytes[i] = bytes[length - i - 1];
            bytes[length - i - 1] = value;
        }
        using (var fs = File.Open(filePath, FileMode.OpenOrCreate, FileAccess.ReadWrite))
        {
            fs.Write(bytes, 0, length);
        }
    }

    /// <summary>
    /// 这个函数不能适配所有文件大小，理论上来说需要文件小于 (int.MaxValue / 2) byte
    /// </summary>
    /// <param name="filePath"></param>
    private static void WriteMeaninglessDataToFile(string filePath)
    {
        if (!AssetsObscureUtil.IsObscure()) return;
        string fileName = Path.GetFileNameWithoutExtension(filePath);
        ulong offset = AssetsObscureUtil.GetABOffset(fileName);
        if (offset <= 0) return;
        uint offsetMain = (uint)AssetsObscureUtil.GetObscureOffsetMin();
        if (offset <= offsetMain) return;
        byte[] bytes = File.ReadAllBytes(filePath);
        int length = bytes.Length;
        if (length <= 0) return;
        byte[] offsetBytes = new byte[offset];
        Array.Copy(bytes, offsetBytes, offsetMain);
        byte[] md5Bytes;
        using(var md5 = new MD5CryptoServiceProvider())
        {
            UTF8Encoding encoding = new UTF8Encoding(false);
            md5Bytes = md5.ComputeHash(bytes);
        }
        uint md5Length = (uint)md5Bytes.Length;
        int idx = 0;
        for (ulong i = offsetMain + 1,
            iMax = (offset - offsetMain);
            i < iMax; i++)
        {
            idx = idx + md5Bytes[i % md5Length];
            if (idx >= length - 1)
            {
                idx = idx - length + 1;
            }
            offsetBytes[i] = bytes[idx];
        }

        using (FileStream fs = File.Open(filePath, FileMode.Open, FileAccess.ReadWrite))
        {
            fs.Write(offsetBytes, 0, (int)offset);
            fs.Write(bytes, 0, length);
        }
    }

    private struct AssetMap
    {
        /// <summary>
        /// key => ab name
        /// value => asset names
        /// </summary>
        public Dictionary<string, HashSet<string>> Maps;

        /// <summary>
        /// 记录重复的情况
        /// </summary>
        public HashSet<string> AllAssets;
    }

    /// <summary>
    /// 构建全部资源
    /// </summary>
    /// <param name="showProcessBar"></param>
    /// <returns></returns>
    private static AssetBundleBuild[] getAllBuildMap(bool showProcessBar)
    {
        if (showProcessBar)
            EditorUtility.DisplayProgressBar("Generate Bundle Build Map", "Start...", 0.1f);

        AssetMap maps = new AssetMap();
        maps.Maps = new Dictionary<string, HashSet<string>>(1024);
        maps.AllAssets = new HashSet<string>();

        // 增加公共shader
        addBuildAssetsCommon(maps, ShaderAbName, Constants.ShaderDir, "*.shader");
        addBuildAssetsCommon(maps, ShaderAbName, Constants.ShaderDir, "*.shadervariants");

        // font
        if (showProcessBar)
            EditorUtility.DisplayProgressBar("Generate Bundle Build Map", "Font...", 0.2f);

        addBuildAssetsFonts(maps);

        addBuildAssetsCommon(maps, "commonmat.unity3d", Constants.CommonMaterialDir, "*.mat");

        // config
        if (showProcessBar)
            EditorUtility.DisplayProgressBar("Generate Bundle Build Map", "Config...", 0.3f);

        addBuildAssetsCommon(maps, "config.unity3d", Constants.CsvConfig, "*.csv");
        addBuildAssetsCommon(maps, "xml.unity3d", Constants.XmlConfig, "*.xml");

        if (showProcessBar)
            EditorUtility.DisplayProgressBar("Generate Bundle Build Map", "UI...", 0.35f);
        addBuildAssetsUI(maps);

        if (showProcessBar)
            EditorUtility.DisplayProgressBar("Generate Bundle Build Map", "Effect...", 0.37f);
        addBuildAssetsEffect(maps);

        // audio
        if (showProcessBar)
            EditorUtility.DisplayProgressBar("Generate Bundle Build Map", "Audio...", 0.4f);

        addBuildAssetsBGM(maps);
        addBuildAssetsCommon(maps, "UI_Audio.unity3d", Constants.UIAudioPath, "*.ogg");
        addBuildAssetsCommon(maps, "Fight_Audio.unity3d", Constants.FightAudioPath, "*.ogg");

        if (showProcessBar)
            EditorUtility.DisplayProgressBar("Generate Bundle Build Map", "Icons...", 0.5f);

        addBuildAssetsIcons(maps);

        if (showProcessBar)
            EditorUtility.DisplayProgressBar("Generate Bundle Build Map", "Camera...", 0.6f);
        addBuildAssetsCamera(maps);

        if (showProcessBar)
            EditorUtility.DisplayProgressBar("Generate Bundle Build Map", "Animator...", 0.65f);
        addBuildAssetsAnimator(maps);

        if (showProcessBar)
            EditorUtility.DisplayProgressBar("Generate Bundle Build Map", "Actor...", 0.7f);
        addBuildAssetsActor(maps);

        if (showProcessBar)
            EditorUtility.DisplayProgressBar("Generate Bundle Build Map", "Scene...", 0.85f);
        addBuildAssetsScene(maps);

        if (showProcessBar)
            EditorUtility.DisplayProgressBar("Generate Bundle Build Map", "Lua...", 0.9f);

        addBuildAssetsLua(maps);

        List<AssetBundleBuild> bm = new List<AssetBundleBuild>(maps.Maps.Count);
        foreach (var items in maps.Maps)
        {
            AssetBundleBuild bundle = new AssetBundleBuild();
            bundle.assetBundleName = AssetsObscureUtil.GetABFileName(items.Key);
            bundle.assetNames = items.Value.ToArray();

            if (bundle.assetNames.Length == 0)
            {
                Debug.LogWarning(items.Key + " empty assetNames");
                continue;
            }

            bm.Add(bundle);
        }

        if (showProcessBar)
        {
            EditorUtility.DisplayProgressBar("Generate Bundle Build Map", "Finish...", 1f);
            EditorUtility.ClearProgressBar();
        }

        return bm.ToArray();
    }

    /// <summary>
    /// 只构建lua相关的资源
    /// </summary>
    /// <param name="showProcessBar"></param>
    /// <returns></returns>
    private static AssetBundleBuild[] getLuaBuildMap(bool showProcessBar)
    {
        if (showProcessBar)
            EditorUtility.DisplayProgressBar("Generate Bundle Build Map", "Start...", 0.1f);

        AssetMap maps = new AssetMap();
        maps.Maps = new Dictionary<string, HashSet<string>>();
        maps.AllAssets = new HashSet<string>();

        if (showProcessBar)
            EditorUtility.DisplayProgressBar("Generate Bundle Build Map", "Lua...", 0.9f);

        addBuildAssetsLua(maps);

        List<AssetBundleBuild> bm = new List<AssetBundleBuild>(maps.Maps.Count);
        foreach (var items in maps.Maps)
        {
            AssetBundleBuild bundle = new AssetBundleBuild();
            bundle.assetBundleName = items.Key;
            bundle.assetNames = items.Value.ToArray();

            if (bundle.assetNames.Length == 0)
            {
                Debug.LogWarning(items.Key + " empty assetNames");
                continue;
            }

            bm.Add(bundle);
        }

        if (showProcessBar)
        {
            EditorUtility.DisplayProgressBar("Generate Bundle Build Map", "Finish...", 1f);
            EditorUtility.ClearProgressBar();
        }
        bm.Sort(assetBundleBuildSort);
        return bm.ToArray();
    }

    private static AssetBundleBuildSort s_AssetBundleBuildSort = null;
    private static AssetBundleBuildSort assetBundleBuildSort
    {
        get
        {
            if (s_AssetBundleBuildSort == null)
            {
                s_AssetBundleBuildSort = new AssetBundleBuildSort();
            }
            return s_AssetBundleBuildSort;
        }
    }
    private class AssetBundleBuildSort : IComparer<AssetBundleBuild>
    {
        public int Compare(AssetBundleBuild x, AssetBundleBuild y)
        {
            return string.Compare(x.assetBundleName, y.assetBundleName);
        }
    }

    #region 处理各个模块的assetbundle

    private static void addBuildAssetsCommon(AssetMap maps, string abName, string dir,
        string filter)
    {
        string[] fileList = FileUtils.TraverseAllFiles(dir, filter);

        for (int idx = 0; idx < fileList.Length; idx++)
        {
            string fullPath = fileList[idx];
            string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);

            if (relativePath.EndsWith(".meta")) continue;
            addData(maps, abName, relativePath);
        }
    }

    private static void addData(AssetMap maps, string assetBundleName, string assetName)
    {
        // 重复资源不能加入；按照资源初始化顺序写入
        if (maps.AllAssets.Contains(assetName))
        {
            return;
        }

        maps.AllAssets.Add(assetName);
        if (!maps.Maps.ContainsKey(assetBundleName))
        {
            maps.Maps[assetBundleName] = new HashSet<string>();
        }

        maps.Maps[assetBundleName].Add(assetName);
    }


    private static void addBuildAssetsFonts(AssetMap maps)
    {
        string[] fileList = FileUtils.TraverseFiles(Constants.FontDir, "*.*");
        for (int idx = 0; idx < fileList.Length; idx++)
        {
            string fullPath = fileList[idx];
            string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);

            if (relativePath.Contains(".meta")) continue;

            addData(maps, "font.unity3d", relativePath);
        }

        string[] dirList = Directory.GetDirectories(Constants.FontDir);
        for (int idx = 0; idx < dirList.Length; idx++)
        {
            string fullPath = dirList[idx];
            string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);

            string abName = relativePath.Replace("Assets/", "").Replace("/", "_") + ".unity3d";
            string[] files = FileUtils.TraverseFiles(relativePath, "*.*");
            for (int jdx = 0; jdx < files.Length; jdx++)
            {
                string filePathName = files[jdx];
                if (filePathName.Contains(".meta")) continue;

                string fileRelativePath = FileUtils.ExtractAssetRelativePath(filePathName);
                addData(maps, abName, fileRelativePath);
            }
        }
    }

    private static void addBuildAssetsBGM(AssetMap maps)
    {
        string[] files = FileUtils.TraverseAllFiles(Constants.BGMAudioPath, "*.ogg");
        for (int idx = 0; idx < files.Length; idx++)
        {
            string fullPath = files[idx];
            string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);
            string abName = FileUtils.RemoveExtension(FileUtils.ExtractPureName(relativePath)) + ".unity3d";

            addData(maps, abName, relativePath);
        }
    }

    private static void addBuildAssetsIcons(AssetMap maps)
    {
        string[] allAbNames = AssetDatabase.GetAllAssetBundleNames();
        string[] dirs = Directory.GetDirectories(Constants.IconDir, "*", SearchOption.AllDirectories);
        for (int idx = 0; idx < dirs.Length; idx++)
        {
            string dirName = dirs[idx];
            string abName = FileUtils.ExtractPureName(dirName) + "_icons.unity3d";
            if (allAbNames.Contains(abName))
            {
                AssetDatabase.RemoveAssetBundleName(abName, true);
            }

            string[] files = FileUtils.TraverseAllFiles(dirName, "*.png");
            for (int jdx = 0; jdx < files.Length; jdx++)
            {
                string fullPath = files[jdx];
                string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);

                addData(maps, abName, relativePath);

                string[] dependencyAssets = AssetDatabase.GetDependencies(relativePath);
                for (int kdx = 0; kdx < dependencyAssets.Length; kdx++)
                {
                    string dependencyAssetName = dependencyAssets[kdx];
                    string fileType = dependencyAssetName.Substring(dependencyAssetName.LastIndexOf('.') + 1);
                    fileType = fileType.ToLower();
                    if (fileType == "shader")
                    {
                        addData(maps, ShaderAbName, dependencyAssetName);
                    }
                    #if false
                    else if (fileType == "mat")
                    {
                        addData(maps, MatAbName, dependencyAssetName);
                    }
                    #endif
                    else if (fileType != "cs" && fileType != "spriteatlas")
                    {
                        addData(maps, abName, dependencyAssetName);
                    }
                }
            }
        }
    }

    private static void addBuildAssetsAnimator(AssetMap maps)
    {
        string[] dirs = Directory.GetDirectories(Constants.AnimatorPath, "*", SearchOption.AllDirectories);
        for (int i = 0; i < dirs.Length; i++)
        {
            string dirName = dirs[i];

            string[] files = FileUtils.TraverseAllFiles(dirName, "*.controller");
            for (int idx = 0; idx < files.Length; idx++)
            {
                string fullPath = files[idx];
                string fileName = FileUtils.ExtractPureName(fullPath);
                string[] tempList = fileName.Split('_');
                string abName = tempList[0] + "_animator.unity3d";

                string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);

                addData(maps, abName, relativePath);

                string[] dependencyAssets = AssetDatabase.GetDependencies(relativePath);
                for (int jdx = 0; jdx < dependencyAssets.Length; jdx++)
                {
                    string dependencyAssetName = dependencyAssets[jdx];
                    string fileType = dependencyAssetName.Substring(dependencyAssetName.LastIndexOf('.') + 1);
                    fileType = fileType.ToLower();

                    if (fileType == "shader")
                    {
                        addData(maps, ShaderAbName, dependencyAssetName);
                    }
                    #if false
                    else if (fileType == "mat")
                    {
                        addData(maps, MatAbName, dependencyAssetName);
                    }
                    #endif
                    else if (fileType != "cs" && fileType != "spriteatlas")
                    {
                        addData(maps, abName, dependencyAssetName);
                    }
                }
            }
        }
    }

    private static void addBuildAssetsActor(AssetMap maps)
    {
        string[] dirs = Directory.GetDirectories(Constants.ModelPath, "*", SearchOption.AllDirectories);
        for (int i = 0; i < dirs.Length; i++)
        {
            string dirName = dirs[i];

            string abName = FileUtils.ExtractPureName(dirName) + ".unity3d";
            string textureABName = FileUtils.ExtractPureName(dirName) + "_texture.unity3d";
            string fbxABName = FileUtils.ExtractPureName(dirName) + "_model.unity3d";

            string[] files = FileUtils.TraverseAllFiles(dirName, "*.prefab");
            for (int idx = 0; idx < files.Length; idx++)
            {
                string fullPath = files[idx];
                string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);

                addData(maps, abName, relativePath);

                string[] dependencyAssets = AssetDatabase.GetDependencies(relativePath);
                for (int jdx = 0; jdx < dependencyAssets.Length; jdx++)
                {
                    string dependencyAssetName = dependencyAssets[jdx];
                    string fileType = dependencyAssetName.Substring(dependencyAssetName.LastIndexOf('.') + 1);
                    fileType = fileType.ToLower();
                    if (fileType == "shader")
                    {
                        addData(maps, ShaderAbName, dependencyAssetName);
                    }
                    #if false
                    else if (fileType == "mat")
                    {
                        addData(maps, MatAbName, dependencyAssetName);
                    }
                    #endif
                    else if (fileType == "jpg" || fileType == "png" || fileType == "tga" || fileType == "tif" ||
                             fileType == "psd")
                    {
                        addData(maps, textureABName, dependencyAssetName);
                    }
                    else if (fileType == "fbx")
                    {
                        addData(maps, fbxABName, dependencyAssetName);
                    }
                    else if (fileType != "cs" && fileType != "spriteatlas")
                    {
                        addData(maps, abName, dependencyAssetName);
                    }
                }
            }
        }
    }

    private static void addBuildAssetsCamera(AssetMap maps)
    {
        string[] files = FileUtils.TraverseAllFiles("Assets/Content/Prefabs/Camera", "*.prefab");
        for (int idx = 0; idx < files.Length; idx++)
        {
            string fullPath = files[idx];
            string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);

            string abName = "prefab_camera.unity3d";

            addData(maps, abName, relativePath);

            string[] dependencyAssets = AssetDatabase.GetDependencies(relativePath);
            for (int jdx = 0; jdx < dependencyAssets.Length; jdx++)
            {
                string dependencyAssetName = dependencyAssets[jdx];
                string fileType = dependencyAssetName.Substring(dependencyAssetName.LastIndexOf('.') + 1);
                fileType = fileType.ToLower();
                if (fileType == "shader")
                {
                    addData(maps, ShaderAbName, dependencyAssetName);
                }
                #if false
                else if (fileType == "mat")
                {
                    addData(maps, MatAbName, dependencyAssetName);
                }
                #endif
                else if (fileType != "cs" && fileType != "spriteatlas")
                {
                    addData(maps, abName, dependencyAssetName);
                }
            }
        }
    }

    private static void addBuildAssetsEffect(AssetMap maps)
    {
        string effectTextureABName = "effect_texture.unity3d";
        string effectAnimABName = "effect_dep.unity3d";
        string abName = "effect.unity3d";


        string[] dirs = Directory.GetDirectories(Constants.EffectPath, "*", SearchOption.AllDirectories);
        for (int idx = 0; idx < dirs.Length; idx++)
        {
            string dirName = dirs[idx];
            string[] fileList = FileUtils.TraverseAllFiles(dirName, "*.prefab");

            for (int jdx = 0; jdx < fileList.Length; jdx++)
            {
                string fullPath = fileList[jdx];
                string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);

                addData(maps, abName, relativePath);

                string[] dependencyAssets = AssetDatabase.GetDependencies(relativePath);
                for (int kdx = 0; kdx < dependencyAssets.Length; kdx++)
                {
                    string dependencyAssetName = dependencyAssets[kdx];
                    string fileType = dependencyAssetName.Substring(dependencyAssetName.LastIndexOf('.') + 1);
                    fileType = fileType.ToLower();
                    if (fileType == "shader")
                    {
                        addData(maps, ShaderAbName, dependencyAssetName);
                    }
                    #if false
                    else if (fileType == "mat")
                    {
                        addData(maps, MatAbName, dependencyAssetName);
                    }
                    #endif
                    else if (fileType == "jpg" || fileType == "png" || fileType == "tga" || fileType == "tif" ||
                             fileType == "psd")
                    {
                        addData(maps, effectTextureABName, dependencyAssetName);
                    }
                    else if (fileType != "cs" && fileType != "spriteatlas")
                    {
                        addData(maps, effectAnimABName, dependencyAssetName);
                    }
                }
            }
        }
    }

    private static void addBuildAssetsUI(AssetMap maps)
    {
        addBuildAssets3DUIPrefab(maps);
        addBuildAssetsUIPrefab(maps);
    }

    private static void addBuildAssets3DUIPrefab(AssetMap maps)
    {
        string[] allAbNames = AssetDatabase.GetAllAssetBundleNames();

        string[] dirs = Directory.GetDirectories(Constants.UI3DPath, "*", SearchOption.AllDirectories);
        for (int idx = 0; idx < dirs.Length; idx++)
        {
            string dirName = dirs[idx];

            string abName = FileUtils.ExtractPureName(dirName) + "_3duiprefab.unity3d";
            string textureABName = FileUtils.ExtractPureName(dirName) + "_3duiprefab_texture.unity3d";
            if (allAbNames.Contains(abName))
            {
                AssetDatabase.RemoveAssetBundleName(abName, true);
            }

            string[] files = FileUtils.TraverseAllFiles(dirName, "*.prefab");
            for (int jdx = 0; jdx < files.Length; jdx++)
            {
                string fullPath = files[jdx];
                string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);

                addData(maps, abName, relativePath);

                string[] dependencyAssets = AssetDatabase.GetDependencies(relativePath);
                for (int kdx = 0; kdx < dependencyAssets.Length; kdx++)
                {
                    string dependencyAssetName = dependencyAssets[kdx];
                    string fileType = dependencyAssetName.Substring(dependencyAssetName.LastIndexOf('.') + 1);
                    fileType = fileType.ToLower();
                    if (fileType == "shader")
                    {
                        addData(maps, ShaderAbName, dependencyAssetName);
                    }
                    #if false
                    else if (fileType == "mat")
                    {
                        addData(maps, MatAbName, dependencyAssetName);
                    }
                    #endif
                    else if (fileType == "jpg" || fileType == "png" || fileType == "tga" || fileType == "tif" ||
                             fileType == "psd")
                    {
                        addData(maps, textureABName, dependencyAssetName);
                    }
                    else if (fileType != "cs" && fileType != "spriteatlas")
                    {
                        addData(maps, abName, dependencyAssetName);
                    }
                }
            }
        }
    }

    private static void addBuildAssetsUIPrefab(AssetMap maps)
    {
        string[] allAbNames = AssetDatabase.GetAllAssetBundleNames();

        string[] dirs = Directory.GetDirectories(Constants.UIPath, "*", SearchOption.AllDirectories);
        for (int idx = 0; idx < dirs.Length; idx++)
        {
            string dirName = dirs[idx];
            string dirRelativeName = FileUtils.ExtractAssetRelativePath(dirName);
            string abName = "";
            if (dirRelativeName == Constants.UICommonPath)
            {
                abName = "prefabsuicommon.unity3d";
            }
            else
            {
                abName = FileUtils.ExtractPureName(dirName) + "_uiprefab.unity3d";
            }

            if (allAbNames.Contains(abName))
            {
                AssetDatabase.RemoveAssetBundleName(abName, true);
            }

            string[] files = FileUtils.TraverseAllFiles(dirName, "*.prefab");
            for (int jdx = 0; jdx < files.Length; jdx++)
            {
                string fullPath = files[jdx];
                string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);

                addData(maps, abName, relativePath);

                string rootParent;
                FileUtils.ExtractParent(relativePath, out rootParent);

                string[] dependencyAssets = AssetDatabase.GetDependencies(relativePath);
                for (int kdx = 0; kdx < dependencyAssets.Length; kdx++)
                {
                    string dependencyAssetName = dependencyAssets[kdx];
                    string fileType = dependencyAssetName.Substring(dependencyAssetName.LastIndexOf('.') + 1);
                    fileType = fileType.ToLower();
                    if (fileType == "shader")
                    {
                        addData(maps, ShaderAbName, dependencyAssetName);
                    }
                    #if false
                    else if (fileType == "mat")
                    {
                        addData(maps, MatAbName, dependencyAssetName);
                    }
                    #endif
                    else if (fileType == "jpg" || fileType == "png" || fileType == "tga" || fileType == "tif" ||
                             fileType == "psd")
                    {
                        string parent;
                        FileUtils.ExtractParent(dependencyAssetName, out parent);
                        parent = FileUtils.ExtractPureName(parent);
                        string uiTextureABName = "UITexture_" + parent + ".unity3d";

                        addData(maps, uiTextureABName, dependencyAssetName);
                    }
                    else if (fileType == "prefab")
                    {
                        string parent;
                        FileUtils.ExtractParent(dependencyAssetName, out parent);
                        if (parent.StartsWith(Constants.UIPath))
                        {
                            if (rootParent == parent)
                            {
                                addData(maps, abName, dependencyAssetName);
                            }
                        }
                        else
                        {
                            addData(maps, abName, dependencyAssetName);
                        }
                    }
                    else if (fileType != "cs" && fileType != "spriteatlas")
                    {
                        addData(maps, abName, dependencyAssetName);
                    }
                }
            }
        }
    }

    private static void addBuildAssetsScene(AssetMap maps)
    {
        string[] fileList = Directory.GetFiles(Constants.ScenePath, "*.unity", SearchOption.AllDirectories);
        for (int idx = 0; idx < fileList.Length; idx++)
        {
            string fullPath = fileList[idx];
            if (fullPath.Contains("UIScene") || fullPath.Contains("meta") || fullPath.Contains("SceneCG") ||
                fullPath.Replace('\\', '/').Contains("Scene/Other") || fullPath.Contains("WasteAsset") ||
                fullPath.Contains("Building"))
                continue;

            if (fullPath.Contains("game.unity") || fullPath.Contains("Loading.unity"))
            {
                continue;
            }

            string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);
            string abName = FileUtils.RemoveExtension(FileUtils.ExtractPureName(relativePath)) + ".unity3d";

            addData(maps, abName, relativePath);

            string scenePrefabABName =
                FileUtils.RemoveExtension(FileUtils.ExtractPureName(relativePath)) + "_prefab.unity3d";
            string sceneTextureABName =
                FileUtils.RemoveExtension(FileUtils.ExtractPureName(relativePath)) + "_texture.unity3d";
            string sceneOtherABName =
                FileUtils.RemoveExtension(FileUtils.ExtractPureName(relativePath)) + "_other.unity3d";
            string lightmapABName = FileUtils.RemoveExtension(FileUtils.ExtractPureName(relativePath)) + "_lm.unity3d";

            string[] dependencyAssets = AssetDatabase.GetDependencies(relativePath);
            for (int kdx = 0; kdx < dependencyAssets.Length; kdx++)
            {
                string dependencyAssetName = dependencyAssets[kdx];
                if (dependencyAssetName.Contains("Lightmap-") ||
                    dependencyAssetName.Contains("LightingData") ||
                    dependencyAssetName.Contains("ReflectionProbe"))
                {
                    addData(maps, lightmapABName, dependencyAssetName);
                }
                else if (dependencyAssetName.Contains("PostProcessing") && !dependencyAssetName.Contains(".cs"))
                {
                    if (dependencyAssetName.Contains(".shader"))
                    {
                        addData(maps, ShaderAbName, dependencyAssetName);
                    }
                    else
                    {
                        addData(maps, "PostProcessing.unity3d", dependencyAssetName);
                    }
                }
                else
                {
                    string fileType = dependencyAssetName.Substring(dependencyAssetName.LastIndexOf('.') + 1);
                    fileType = fileType.ToLower();
                    if (fileType == "shader")
                    {
                        addData(maps, ShaderAbName, dependencyAssetName);
                    }
                    // Unity:
                    //      Do not collect all materials into one AssetBundle, otherwise the dependencies will explode and the streaming experience will be terrible.
                    #if false
                    else if (fileType == "mat")
                    {
                        addData(maps, MatAbName, dependencyAssetName);
                    }
                    #endif
                    else if (fileType == "prefab")
                    {
                        if (dependencyAssetName.Contains("Scenes/Scene_common"))
                        {
                            string sCommonAb = "scene_common_prefab.unity3d";
                            addData(maps, sCommonAb, dependencyAssetName);
                        }
                        else
                        {
                            addData(maps, scenePrefabABName, dependencyAssetName);
                        }
                    }
                    else if (fileType == "png" || fileType == "tga" || fileType == "jpg" || fileType == "tif" ||
                             fileType == "psd")
                    {
                        if (dependencyAssetName.Contains("Scenes/Scene_common"))
                        {
                            string sCommonAb = "scene_common_texture.unity3d";
                            addData(maps, sCommonAb, dependencyAssetName);
                        }
                        else
                        {
                            addData(maps, sceneTextureABName, dependencyAssetName);
                        }
                    }
                    else if (fileType != "cs" && fileType != "spriteatlas")
                    {
                        if (dependencyAssetName.Contains("Scenes/Scene_common"))
                        {
                            string sCommonAb = "scene_common_other.unity3d";
                            addData(maps, sCommonAb, dependencyAssetName);
                        }
                        else
                        {
                            addData(maps, sceneOtherABName, dependencyAssetName);
                        }
                    }
                }
            }
        }
    }

    #endregion

    #region 处理lua文件

    private static void addBuildAssetsLua(AssetMap maps)
    {
        CopyLuaAssets(Constants.LuaDir, Constants.ABLuaDir);
        CopyLuaAssets(Constants.LuaLogicDir, Constants.ABLuaLogicDir, true);
        CopyPbAssets(Constants.LuaPbDir, Constants.ABLuaPbDir);
        CopyLuaAssets(Constants.PubSec, Constants.ABPubsec);
        AssetDatabase.Refresh();

        ProcessConfigAndLua(maps);
    }

    private static void CopyPbAssets(string sourceDir, string destDir)
    {
        // Delete old
        DirectoryInfo dstDI = new DirectoryInfo(destDir);
        foreach (FileInfo dstFI in dstDI.GetFiles())
            dstFI.Delete();

        DirectoryInfo srcDI = new DirectoryInfo(sourceDir);
        foreach (FileInfo srcFI in srcDI.GetFiles())
        {
            srcFI.CopyTo(Path.Combine(destDir, srcFI.Name));
        }
    }

    private static void CopyLuaAssets(string sourceDir, string destDir, bool optimize = false)
    {
        string path = Application.dataPath;
        path = path.Replace("Assets", "");
        string sourceAbsDir = Path.Combine(path, sourceDir);
        string destAbsDir = Path.Combine(path, destDir);
        HashSet<string> sourceFiles = getAllFilesPathEX(sourceAbsDir);
        HashSet<string> destFiles = getAllFilesPathEX(destAbsDir);
        // 删除不再需要的文件
        foreach (var destFile in destFiles)
        {
            string sourceFile = destFile.Replace(destAbsDir, sourceAbsDir);
            string fileName = Path.GetExtension(sourceFile);
            if (fileName.ToLower() == ".txt")
            {
                string ext = Path.GetExtension(fileName);
                if (s_ValidExtMap.Contains(ext))
                {
                    sourceFile = sourceFile.Remove(sourceFile.Length - 4);
                }
            }
            if (!sourceFiles.Contains(sourceFile))
            {
                File.Delete(destFile);
                string metaFilePath = destFile + ".meta";
                if (File.Exists(metaFilePath))
                {
                    File.Delete(metaFilePath);
                }
                string folder = Path.GetDirectoryName(destFile);
                DeleteDirectoryAssets(folder);
            }
        }
        // 替换新文件
        foreach (var filePath in sourceFiles)
        {
            string destFilePath = filePath.Replace(sourceAbsDir, destAbsDir);
            string destFolder = Path.GetDirectoryName(destFilePath);
            if (!Directory.Exists(destFolder))
            {
                Directory.CreateDirectory(destFolder);
            }
            destFilePath = destFilePath + ".txt";
            if (!File.Exists(destFilePath))
            {
                File.Copy(filePath, destFilePath, true);
                if (optimize && destFilePath.Contains("_Generate"))
                {
                    string[] lines = FileSystem.ReadFileLines(destFilePath);
                    List<string> contents = new List<string>(lines);
                    for (var i = contents.Count - 1; i >= 0; --i)
                    {
                        if (contents[i].StartsWith("---@") || contents[i].Equals(""))
                        {
                            contents.RemoveAt(i);
                        }
                    }
                    File.WriteAllLines(destFilePath, contents.ToArray());
                }
            }
            else
            {
                if (optimize && destFilePath.Contains("_Generate"))
                {
                    string[] lines1 = FileSystem.ReadFileLines(filePath);
                    List<string> contents = new List<string>(lines1);
                    for (var i = contents.Count - 1; i >= 0; --i)
                    {
                        if (contents[i].StartsWith("---@") || contents[i].Equals(""))
                        {
                            contents.RemoveAt(i);
                        }
                    }
                    lines1 = contents.ToArray();
                    string[] lines2 = FileSystem.ReadFileLines(destFilePath);
                    bool diff = (lines1.Length != lines2.Length);
                    if (!diff)
                    {
                        for (var i = lines1.Length - 1; i >= 0; i--)
                        {
                            if (lines1[i] != lines2[i])
                            {
                                diff = true;
                                continue;
                            }
                        }
                    }
                    if (diff)
                        File.WriteAllLines(destFilePath, lines1);
                }
                else
                {
                    string content1 = File.ReadAllText(filePath);
                    string content2 = File.ReadAllText(destFilePath);
                    if (content1 != content2)
                    {
                        File.Copy(filePath, destFilePath, true);
                    }
                }
            }
        }
    }

    private static void DeleteDirectoryAssets(string dir, bool forceDelete = false)
    {
        if (!Directory.Exists(dir)) return;
        var ls = Directory.GetFileSystemEntries(dir);
        if (forceDelete || ls == null || ls.Length <= 0)
        {
            Directory.Delete(dir, true);
            if (dir.EndsWith("/") || dir.EndsWith("\\"))
            {
                dir = dir.Substring(0, dir.Length - 1);
            }
            string metaFilePath = dir + ".meta";
            if (File.Exists(metaFilePath))
            {
                File.Delete(metaFilePath);
            }
            string folder = Path.GetDirectoryName(dir);
            DeleteDirectoryAssets(folder);
        }
    }

    private static void CopyLuaAsset(string dir)
    {
        string path = Application.dataPath;
        path = Path.Combine(path.Replace("Assets", ""), dir);
        List<string> files = FileSystem.getAllFilesPathEX(path);

        foreach (string fileName in files)
        {
            string destName = fileName.Insert(fileName.IndexOf("Assets/") + 7, "Content/");
            string destFolder = Path.GetDirectoryName(destName);
            if (!Directory.Exists(destFolder))
            {
                Directory.CreateDirectory(destFolder);
            }

            File.Copy(fileName, destName + ".txt", true);

            if (dir.CompareTo(Constants.LuaLogicDir) == 0 && destName.Contains("_Generate"))
            {
                string[] lines = FileSystem.ReadFileLines(destName + ".txt");
                List<string> contents = new List<string>(lines);
                for (var i = contents.Count - 1; i >= 0; --i)
                {
                    if (contents[i].StartsWith("---@") || contents[i].Equals(""))
                    {
                        contents.RemoveAt(i);
                    }
                }

                File.WriteAllLines(destName + ".txt", contents.ToArray());
            }
        }
    }

    static void ProcessConfigAndLua(AssetMap maps)
    {
        string luaABName = Constants.LuaDir.Replace("Assets", "").Replace("Content", "").Replace("/", "").ToLower();
        string luaLogicABName = Constants.LuaLogicDir.Replace("Assets", "").Replace("Content", "").Replace("/", "")
            .ToLower();
        string luaPbABName = Constants.LuaPbDir.Replace("Assets", "").Replace("Content", "").Replace("/", "").ToLower();
        string pubSecABName = Constants.PubSec.Replace("Assets", "").Replace("Content", "").Replace("/", "").ToLower();


        string[] allAbNames = AssetDatabase.GetAllAssetBundleNames();
        if (allAbNames.Contains(luaABName))
            AssetDatabase.RemoveAssetBundleName(luaABName, true);
        if (allAbNames.Contains(luaLogicABName))
            AssetDatabase.RemoveAssetBundleName(luaLogicABName, true);
        if (allAbNames.Contains(luaPbABName))
            AssetDatabase.RemoveAssetBundleName(luaPbABName, true);
        if (allAbNames.Contains(pubSecABName))
            AssetDatabase.RemoveAssetBundleName(pubSecABName, true);


        ProcessConfigAndLua(maps, Constants.ABLuaPbDir, luaPbABName);
        ProcessConfigAndLua(maps, Constants.ABLuaDir, luaABName);
        ProcessConfigAndLua(maps, Constants.ABLuaLogicDir, luaLogicABName);
        ProcessConfigAndLua(maps, Constants.ABPubsec, pubSecABName);
    }

    static void ProcessConfigAndLua(AssetMap maps, string dir, string abName)
    {
        List<string> fileList = FileSystem.getAllFilesPathEX(dir);
        for (int idx = 0; idx < fileList.Count; idx++)
        {
            string fullPath = fileList[idx];
            string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);

            if (relativePath.Contains("/Pb/") && dir != Constants.ABLuaPbDir) continue;

            addData(maps, abName + ".unity3d", relativePath);
        }
    }

    #endregion

    private static HashSet<string> s_ValidExtMap = new HashSet<string>()
    {
        ".prefab", ".txt", ".xml", ".txt", ".lua", ".csv", ".ogg", ".wav", ".ttf", ".bytes", ".pb",
    };

    private static HashSet<string> getAllFilesPathEX(string path, string searchPattern = "*.*", SearchOption searchOption = SearchOption.AllDirectories)
    {
        HashSet<string> all = new HashSet<string>();
        if (!Directory.Exists(path))
        {
            return all;
        }
        string[] allFiles = Directory.GetFiles(path, searchPattern, searchOption);
        for (int j = 0; j < allFiles.Length; ++j)
        {
            string fileName = allFiles[j];
            string ext = Path.GetExtension(fileName);
            if (string.IsNullOrEmpty(ext)) continue;
            ext = ext.ToLower();
            if (s_ValidExtMap.Contains(ext))
            {
                all.Add(fileName.Replace('\\', '/'));
            }
        }
        return all;
    }
}