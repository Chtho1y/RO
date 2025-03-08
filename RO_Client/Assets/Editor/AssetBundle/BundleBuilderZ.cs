using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
using System.Security.Cryptography;
using System.Text;

public class BundleBuilderZ : EditorWindow
{
    class MD5
    {
        public string Md5;
        public long Length;

        public MD5(string m, long length)
        {
            Md5 = m;
            Length = length;
        }
    }

    protected static BuildTarget target = BuildTarget.Android;
    static string StreamingAssetsPath = "Assets/StreamingAssets";
    static Dictionary<string, MD5> DicFileMD5 = null;

    public static void MD5Creator()
    {
        DicFileMD5 = new Dictionary<string, MD5>();
        string[] files = Directory.GetFiles(FileSystem.PackagePath(), "*", SearchOption.AllDirectories);
        MD5CryptoServiceProvider md5Generator = new MD5CryptoServiceProvider();
        int i = 0;
        StringBuilder sb = new StringBuilder(1024);
        foreach (string filePath in files)
        {
            if (filePath.Contains(".svn") || filePath.Contains(".meta") || filePath.Contains("DS_Store"))
                continue;
            EditorUtility.DisplayProgressBar(string.Format("生成MD5码-{0}", Path.GetFileName(filePath)), Path.GetFileName(filePath), (float)(++i) / files.Length);
            FileStream file = new FileStream(filePath, FileMode.Open, FileAccess.Read, FileShare.Read);
            byte[] hash = md5Generator.ComputeHash(file);
            sb.Clear();
            for (int j = 0; j < hash.Length; ++j)
            {
                sb.Append(hash[j].ToString("X2"));
            }
            string strMD5 = sb.ToString().ToLower();

            string key = Path.GetFileName(filePath);

            if (!DicFileMD5.ContainsKey(key))
                DicFileMD5.Add(key, new MD5(strMD5, file.Length));
            else
                Debug.LogWarning("<Two File has the same name> name = " + filePath);
            file.Close();
            file.Dispose();
        }
        EditorUtility.ClearProgressBar();

        string savePath = string.Format("{0}mainfest.csv", FileSystem.PackagePath());
        // 删除前一版的old数据
        if (File.Exists(savePath))
        {
            System.IO.File.Delete(savePath);
        }

        sb.Clear();
        sb.Append("FileName,MD5,Length\r\n");
        sb.Append("FileName,MD5,Length\r\n");
        sb.Append("string,string,long\r\n");
        foreach (KeyValuePair<string, MD5> pair in DicFileMD5)
        {
            sb.Append(pair.Key);
            sb.Append(",");
            sb.Append(pair.Value.Md5);
            sb.Append(",");
            sb.Append(pair.Value.Length);
            sb.Append("\r\n");
        }

        FileStream fs = new FileStream(savePath, FileMode.OpenOrCreate);
        if (fs == null)
            return;
        UTF8Encoding encoding = new UTF8Encoding(true, false);
        StreamWriter textWriter = new StreamWriter(fs, encoding);
        if (textWriter == null)
            return;
        textWriter.Write(sb.ToString());
        textWriter.Flush();
        textWriter.Close();
        DicFileMD5.Clear();
        Debug.Log("<color=red>================ MD5Creator Complete ================</color>");
    }

    #region BundleBuidlerDeleteAssetsData;
    static void BundleBuidlerDeleteAssetsData()
    {
        Caching.ClearCache();

        if (Directory.Exists(StreamingAssetsPath))
        {
            string srcPath = GetAssetbundlesPath();

            string path = Application.streamingAssetsPath + srcPath.Replace(Path.GetDirectoryName(Application.dataPath), "");
            if (Directory.Exists(path))
            {
                Directory.Delete(path, true);
            }
            //Log.E("DeleteAndCreateDir.Delete (path); {0}", StreamingAssetsPath);
        }
        AssetDatabase.Refresh();
        DebugHelper.Log("<color=red>================ DeleteStreamingAssets Complete ================</color>");
    }
    #endregion BundleBuidlerDeleteAssetsData 

    #region BundleBuidlerCopyToStreamingAssets;
    public static void BundleBuidlerCopyToStreamingAssets()
    {

        Caching.ClearCache();
        BundleBuidlerDeleteAssetsData();
        string path = Application.dataPath;
        string srcPath = GetAssetbundlesPath();

        path = Application.streamingAssetsPath + srcPath.Replace(Path.GetDirectoryName(Application.dataPath), "");
        DeleteAndCreateDir(path);
        CopyFolder(srcPath, path);

        DebugHelper.Log("<color=red>================ CopyToStreamingAssets Complete ================</color>");
        AssetDatabase.Refresh();
    }
    #endregion BundleBuidlerCopyToStreamingAssets


    public static void BuildApp(bool debug = false)
    {
        Debug.Log("Build App 1111 ");

        target = EditorUserBuildSettings.activeBuildTarget;// BuildTarget.Android;
        BuildOptions buildOption = BuildOptions.None;
        System.DateTime time = System.DateTime.Now;
        string DateTime = time.Month.ToString("D2") + time.Day.ToString("D2") +
                "_" + time.Hour.ToString("D2") + time.Minute.ToString("D2");
        PlayerSettings.applicationIdentifier = AssetBundleConstant.PgName;

        if (EditorUserBuildSettings.development)
        {
            buildOption |= BuildOptions.Development;
            buildOption |= BuildOptions.AllowDebugging;
            buildOption |= BuildOptions.ConnectWithProfiler;
        }
        else
        {
            buildOption |= BuildOptions.None;
        }
        string locationPathName;

        if (BuildTarget.iOS == target)
        {
            locationPathName = Application.dataPath;
            locationPathName = locationPathName.Replace("Assets", "/Xcode");
        }
        else if (BuildTarget.Android == target)
        {
            string apkName = AssetBundleConstant.ApkName;
            if (!debug)
            {
                ChangeAndroidVersionCode();
            }
            else
            {
                apkName = apkName + "_debug";
            }
            locationPathName = Application.dataPath;
            locationPathName = locationPathName.Replace("Assets", "/BatunityApk/");
            Debug.Log("Build App ->>>>>>>>>>>> " + locationPathName);
            EditorUserBuildSettings.androidBuildSubtarget = MobileTextureSubtarget.ETC2;
            PlayerSettings.Android.keystoreName = Application.dataPath.Replace("Assets", "/Cert/wenting.keystore");
            PlayerSettings.Android.keystorePass = "n9P5j2b7blMm";
            PlayerSettings.Android.keyaliasName = "game";
            PlayerSettings.Android.keyaliasPass = "KlYX666Ro";
            locationPathName += apkName + ".apk";
        }
        else
        {
            target = BuildTarget.StandaloneWindows64;
            locationPathName = Application.dataPath;
            locationPathName = locationPathName.Replace("Assets", "/RO");
            locationPathName += DateTime + "/" + DateTime + ".exe";
            PlayerSettings.SetArchitecture(BuildTargetGroup.Standalone, 0);
        }

        var buildResult = BuildPipeline.BuildPlayer(ms_scenes, locationPathName, target, buildOption);
    }

    private static void ChangeAndroidVersionCode()
    {
        int oldVersionCode = PlayerSettings.Android.bundleVersionCode;
        oldVersionCode = oldVersionCode % 100;
        oldVersionCode += 1;
        int bigVersionCode = 0;
        var bigVersionStrs = AssetBundleConstant.GameVersion.Split('.');
        if (bigVersionStrs.Length >= 1)
        {
            bigVersionCode += (int.Parse(bigVersionStrs[0]) * 1000000);
        }
        if (bigVersionStrs.Length >= 2)
        {
            bigVersionCode += (int.Parse(bigVersionStrs[1]) * 10000);
        }
        if (bigVersionStrs.Length >= 3)
        {
            bigVersionCode += (int.Parse(bigVersionStrs[2]) * 100);
        }
        PlayerSettings.Android.bundleVersionCode = (bigVersionCode + oldVersionCode);
        PlayerSettings.bundleVersion = AssetBundleConstant.GameVersion + oldVersionCode;
    }

    private static string[] ms_scenes =
    {
        "Assets/game.unity",
        "Assets/relogin.unity",
    };

    #region CommonMethod;

    static void DeleteAndCreateDir(string targetPath)
    {
        if (Directory.Exists(targetPath))
        {
            Directory.Delete(targetPath, true);
            DebugHelper.LogWarning("DeleteAndCreateDir.Delete (path); {0}", targetPath);
        }
        if (!Directory.Exists(targetPath))
            Directory.CreateDirectory(targetPath);
    }

    static void DeleteFile(string targetPath)
    {
        if (File.Exists(targetPath))
        {
            File.Delete(targetPath);
        }
    }

    private static void CopyFolder(string from, string to)
    {
        string[] dirs = Directory.GetDirectories(from);
        FileSystem.CreateDirIfNotExist(to);
        foreach (string sub in dirs)
        {
            string path = to + Path.GetFileName(sub);
            if (!Directory.Exists(path))
                Directory.CreateDirectory(to + Path.GetFileName(sub));
            CopyFolder(sub + "\\", path + "\\");
        }
        string[] files = Directory.GetFiles(from);

        foreach (string file in files)
            File.Copy(file, to + Path.GetFileName(file), true);
    }


    public static string GetAssetbundlesPath()
    {
        string path = Application.dataPath;

        path = Path.GetDirectoryName(path);

        BuildTarget buildTarget = EditorUserBuildSettings.activeBuildTarget;
        if (buildTarget == BuildTarget.iOS)
        {
            path = path + "/ios/";
        }
        else if (buildTarget == BuildTarget.Android)
        {
            path = path + "/AssetsAndroid/";
        }
        else
        {
            path = path + "/AssetsPC/";
        }
        return path;
    }

    public static string GetWwisePath()
    {
        string path = Application.dataPath;

        path = Path.GetDirectoryName(path);

        BuildTarget buildTarget = EditorUserBuildSettings.activeBuildTarget;
        if (buildTarget == BuildTarget.iOS)
        {
            path = path + "/client_WwiseProject/GeneratedSoundBanks/Windows/";
        }
        else if (buildTarget == BuildTarget.Android)
        {
            path = path + "/client_WwiseProject/GeneratedSoundBanks/Windows/";
        }
        else
        {
            path = path + "/client_WwiseProject/GeneratedSoundBanks/Windows/";
        }
        return path;
    }
    #endregion CommonMethod;

    [MenuItem("RO_Tool/Scene/EnableScene All")]
    public static void EnableScene()
    {
        SetScenes(true);
    }

    [MenuItem("RO_Tool/Scene/DisableScene All")]
    public static void DisableScene()
    {
        SetScenes(false);
    }

    static void SetScenes(bool enable)
    {
        EditorBuildSettingsScene[] scenes = EditorBuildSettings.scenes;
        foreach (EditorBuildSettingsScene scene in scenes)
        {
            if (scene.path.Contains("game") || scene.path.Contains("Loading") || scene.path.Contains("relogin"))
                continue;
            scene.enabled = enable;
        }
        EditorBuildSettings.scenes = scenes;
        AssetDatabase.Refresh();
    }

    [MenuItem("[ 快捷启动 ]/[ Run Game ]", false, 1)]
    static void RunGame()
    {
        Time.timeScale = 1.0f;
        UnityEditor.SceneManagement.EditorSceneManager.OpenScene(@"Assets/game.unity");
        EditorApplication.isPlaying = true;
    }

    [MenuItem("RO_Tool/生成公私钥")]
    public static void GenKey()
    {
        string publicKey, privateKey, privateKeyPk8;
        RsaKeyHelper.GenKey(out publicKey, out privateKey, out privateKeyPk8);

        Debug.LogError(string.Format("{0}\n\n\n{1}", publicKey, privateKeyPk8));
    }
}
