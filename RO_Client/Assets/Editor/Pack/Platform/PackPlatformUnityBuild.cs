using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;
using UnityEditor;
using UnityEditor.Build.Reporting;
using UnityEngine;
using SplashScreenLogo = UnityEditor.PlayerSettings.SplashScreenLogo;

namespace Pack
{
    public abstract partial class PackPlatformUnity
    {
        public override void ChangePlatform()
        {
            base.ChangePlatform();
            try
            {
                BuildClear();
                AssetDatabase.Refresh();
                ChangeBuildTarget();
                ChangeLuaConfig();
                ChangeGameAssets();
                ChangeLogin();
                ChangeLogo();
                CheckAppInfo();
                ChangeAppIcon();
                ChangeSplashScreen();
                ChangePlatformSpecial();
                ChangePlayerSettings();
                EditorUtility.ClearProgressBar();
                AssetDatabase.Refresh();
                AssetDatabase.SaveAssets();
            }
            catch (Exception e)
            {
                EditorUtility.ClearProgressBar();
                PackLog.LogException(e);
                throw e;
            }
        }

        public override void BuildAssetBundles()
        {
            base.BuildAssetBundles();
            try
            {
                BuildClear();
                AssetDatabase.Refresh();
                ChangeBuildTarget();
                ChangeLuaConfig();
                ChangeGameAssets();
                ChangeLogin();
                ChangeLogo();
                CheckAppInfo();
                ChangeAppIcon();
                ChangeSplashScreen();
                ChangePlatformSpecial();
                ChangePlayerSettings();
                EditorUtility.ClearProgressBar();
                AssetDatabase.Refresh();
                AssetDatabase.SaveAssets();
                ChangeAssetsObscure();
                AssetBundleMap.BuildAllAssetBundles(resVersionCode);
                if (Application.isBatchMode)
                {
                    PackLog.Log(PackConstant.TAG_ResOutPath + BundleBuilderZ.GetAssetbundlesPath());
                }
                if (Application.isBatchMode)
                {
                    string outPath = GetBuildOutputPath();
                    PackLog.Log(PackConstant.TAG_AppOutPath + outPath);
                }
            }
            catch (Exception e)
            {
                EditorUtility.ClearProgressBar();
                PackLog.LogException(e);
                throw e;
            }
        }

        public override void BuildApp()
        {
            base.BuildApp();
            try
            {
                BuildClear();
                AssetDatabase.Refresh();
                ChangeBuildTarget();
                ChangeLuaConfig();
                ChangeGameAssets();
                ChangeLogin();
                ChangeLogo();
                CheckAppInfo();
                ChangeAppIcon();
                ChangeSplashScreen();
                ChangePlatformSpecial();
                ChangePlayerSettings();
                EditorUtility.ClearProgressBar();
                AssetDatabase.Refresh();
                AssetDatabase.SaveAssets();
                ChangeAssetsObscure();
                // AssetBundleMap.BuildAllAssetBundles(resVersionCode);
                if (Application.isBatchMode)
                {
                    PackLog.Log(PackConstant.TAG_ResOutPath + BundleBuilderZ.GetAssetbundlesPath());
                }
                BuildTarget buildTarget = GetBuildTarget();
                string outPath = GetBuildOutputPath();
                string outDirPath = Path.GetDirectoryName(outPath);
                if (!Directory.Exists(outDirPath))
                {
                    Directory.CreateDirectory(outDirPath);
                }
                if (Application.isBatchMode)
                {
                    BuildOptions buildOptions = BuildOptions.None;
                    buildOptions = ChangeBuildOptionsBefore(BuildOptions.None);
                    var report = BuildPipeline.BuildPlayer(PackConstant.BuildScenes, outPath, buildTarget, buildOptions);
                    if (report != null && report.summary.result == BuildResult.Succeeded)
                    {
                        BuildAppCompleted(buildOptions);
                        PackLog.Log(PackConstant.TAG_AppOutPath + outPath);
                    }
                    else
                    {
                        if (report != null)
                            throw new Exception("Build Fail !!! report : " + report.summary.result + " errorNum : " + report.summary.totalErrors);
                        else
                            throw new Exception("Build Fail !!! report : true");
                    }
                }
                else
                {
                    BuildTargetGroup buildTargetGroup = BuildPipeline.GetBuildTargetGroup(buildTarget);
                    BuildPlayerOptions options = new BuildPlayerOptions();
                    options.options = BuildOptions.ShowBuiltPlayer;
                    options.locationPathName = outPath;
                    EditorUserBuildSettings.SetBuildLocation(buildTarget, outPath);
                    EditorUserBuildSettings.selectedBuildTargetGroup = buildTargetGroup;
                    var methodInfo = typeof(BuildPlayerWindow.DefaultBuildMethods).GetMethod("GetBuildPlayerOptionsInternal",
                        BindingFlags.Static | BindingFlags.NonPublic | BindingFlags.Public | BindingFlags.Instance,
                        null, new Type[] { typeof(bool), typeof(BuildPlayerOptions) }, null);
                    options = (BuildPlayerOptions)methodInfo.Invoke(null, new object[] { false, options });
                    options.target = buildTarget;
                    options.targetGroup = buildTargetGroup;
                    options.scenes = PackConstant.BuildScenes;
                    options.options = ChangeBuildOptionsBefore(options.options);
                    BuildPlayerWindow.DefaultBuildMethods.BuildPlayer(options);
                    BuildAppCompleted(options.options);
                }
            }
            catch (Exception e)
            {
                EditorUtility.ClearProgressBar();
                PackLog.LogException(e);
                throw e;
            }
        }

        protected void ChangeBuildTarget()
        {
            EditorUtility.DisplayProgressBar("切换平台", "开始切换平台", 0);
            BuildTarget buildTarget = GetBuildTarget();
            if (EditorUserBuildSettings.activeBuildTarget == buildTarget) return;
            EditorUserBuildSettings.SwitchActiveBuildTarget(BuildPipeline.GetBuildTargetGroup(buildTarget), buildTarget);
            if (EditorUserBuildSettings.activeBuildTarget != buildTarget)
            {
                throw new Exception("Change Platform is Fail !!!");
            }
            EditorUtility.DisplayProgressBar("切换平台", "完成切换平台", 1);
        }

        protected void ChangeLuaConfig()
        {
            EditorUtility.DisplayProgressBar("Lua配置", "开始更改Lua配置", 0);
            string path = Application.dataPath + PackConstant.LuaPlatformPackPath;
            StringBuilder sb = new StringBuilder();
            sb.AppendLine("local PlatformPack = {");
            sb.AppendFormat("\tURL_KEY = '{0}',", sdkVerifyUrl);
            sb.AppendLine();
            sb.AppendFormat("\tSERVERLIST_URL = '{0}',", serverListUrl);
            sb.AppendLine();
            sb.AppendFormat("\tNOTIFY_URL = '{0}',", notifyUrl);
            sb.AppendLine();
            sb.AppendFormat("\tSPECIAL_INFO_URL = '{0}',", specialInfoUrl);
            sb.AppendLine();
            sb.AppendFormat("\tCUSTOMER_SERVICE_INFO_URL = '{0}',", customerServiceInfoUrl);
            sb.AppendLine();
            if (ArrayUtility.Contains(defineSymbols, "HEALTH_BULLETIN"))
            {
                sb.AppendFormat("\tShowHealthBulletin = true,");
                sb.AppendLine();
            }
            if (specialFuncShield)
            {
                sb.AppendFormat("\tSpecialFuncShield = true,");
                sb.AppendLine();
            }
            sb.Append("}");
            sb.AppendLine();
            sb.AppendLine();
            sb.Append("return PlatformPack");
            string newStr = sb.ToString();
            UTF8Encoding uTF8Encoding = new UTF8Encoding(false);
            if (File.Exists(path))
            {
                string destStr = File.ReadAllText(path, uTF8Encoding);
                if (newStr == destStr)
                    return;
            }
            File.WriteAllText(path, newStr, uTF8Encoding);
            AssetDatabase.ImportAsset(FileUtil.GetProjectRelativePath(path.Replace('\\', '/')), ImportAssetOptions.ForceUpdate);
            EditorUtility.DisplayProgressBar("Lua配置", "完成更改Lua配置", 1);
        }

        protected void ChangeGameAssets()
        {
            EditorUtility.DisplayProgressBar("更改游戏资源", "开始更改游戏资源", 0);
            string srcPath = Application.dataPath + PackConstant.GameAssetsSourcePath + "/" + gameAssetsPath;
            string dstPath = Application.dataPath + PackConstant.GameAssetsDestPath;
            string configPath = Application.dataPath + PackConstant.GameAssetsConfigPath;
            if (File.Exists(configPath))
            {
                UTF8Encoding uTF8Encoding = new UTF8Encoding(false);
                string jsonStr = File.ReadAllText(configPath, uTF8Encoding);
                PackGameAssetsConfig config = JsonUtility.FromJson<PackGameAssetsConfig>(jsonStr);
                foreach(var item in config.fullReplacePaths)
                {
                    string path = Path.GetFullPath(dstPath + item);
                    if (File.Exists(path))
                    {
                        File.Delete(path);
                    }
                    else if (Directory.Exists(path))
                    {
                        DeleteDirectoryAssets(path, true);
                    }
                }
            }
            List<string> changedPaths = new List<string>();
            CopyAndReplaceDirectory(srcPath, dstPath, false, false, changedPaths);
            EditorUtility.DisplayProgressBar("更改游戏资源", "开始更改游戏资源", 0.5f);
            foreach (var item in changedPaths)
            {
                string path = Path.GetFullPath(item);
                path = FileUtil.GetProjectRelativePath(path.Replace('\\', '/'));
                AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceUpdate);
            }
            EditorUtility.DisplayProgressBar("更改游戏资源", "开始更改游戏资源", 1);
        }

        protected void ChangeLogin()
        {
            EditorUtility.DisplayProgressBar("更改Login", "开始更改Login", 0);
            string directoryPath = PackConstant.LoginSourcePath;
            string loginSourcePath = Path.GetFullPath(Application.dataPath + directoryPath + loginRelativePath + PackConstant.Login0SourcePath);
            string loginDestPath = Path.GetFullPath(Application.dataPath + PackConstant.Login0DestPath);
            if (!File.Exists(loginSourcePath))
            {
                throw new Exception("File is not Exist " + loginSourcePath);
            }
            if (!File.Exists(loginDestPath))
            {
                throw new Exception("File is not Exist " + loginDestPath);
            }
            File.Copy(loginSourcePath, loginDestPath, true);
            AssetDatabase.ImportAsset(FileUtil.GetProjectRelativePath(loginDestPath.Replace('\\', '/')), ImportAssetOptions.ForceUpdate);

            EditorUtility.DisplayProgressBar("更改Login", "开始更改Login", 0.3f);

            loginSourcePath = Path.GetFullPath(Application.dataPath + directoryPath + loginRelativePath + PackConstant.Login1SourcePath);
            loginDestPath = Path.GetFullPath(Application.dataPath + PackConstant.Login1DestPath);
            if (!File.Exists(loginSourcePath))
            {
                throw new Exception("File is not Exist " + loginSourcePath);
            }
            if (!File.Exists(loginDestPath))
            {
                throw new Exception("File is not Exist " + loginDestPath);
            }
            File.Copy(loginSourcePath, loginDestPath, true);
            AssetDatabase.ImportAsset(FileUtil.GetProjectRelativePath(loginDestPath.Replace('\\', '/')), ImportAssetOptions.ForceUpdate);

            EditorUtility.DisplayProgressBar("更改Login", "开始更改Login", 0.6f);

            loginSourcePath = Path.GetFullPath(Application.dataPath + directoryPath + loginRelativePath + PackConstant.Login2SourcePath);
            loginDestPath = Path.GetFullPath(Application.dataPath + PackConstant.Login2DestPath);
            if (!File.Exists(loginSourcePath))
            {
                throw new Exception("File is not Exist " + loginSourcePath);
            }
            if (!File.Exists(loginDestPath))
            {
                throw new Exception("File is not Exist " + loginDestPath);
            }
            File.Copy(loginSourcePath, loginDestPath, true);
            AssetDatabase.ImportAsset(FileUtil.GetProjectRelativePath(loginDestPath.Replace('\\', '/')), ImportAssetOptions.ForceUpdate);

            EditorUtility.DisplayProgressBar("更改Login", "完成开始更改Login", 1);
        }

        protected void ChangeLogo()
        {
            EditorUtility.DisplayProgressBar("更改Logo", "开始更改Logo", 0);
            string directoryPath = PackConstant.LogoSourcePath;
            string logoSourcePath = Path.GetFullPath(Application.dataPath + directoryPath + logo1RelativePath);
            string logoDestPath = Path.GetFullPath(Application.dataPath + PackConstant.Logo1DestPath);
            if (!File.Exists(logoSourcePath))
            {
                throw new Exception("File is not Exist " + logoSourcePath);
            }
            if (!File.Exists(logoDestPath))
            {
                throw new Exception("File is not Exist " + logoDestPath);
            }
            File.Copy(logoSourcePath, logoDestPath, true);
            AssetDatabase.ImportAsset(FileUtil.GetProjectRelativePath(logoDestPath.Replace('\\', '/')), ImportAssetOptions.ForceUpdate);

            // logoSourcePath = Path.GetFullPath(Application.dataPath + directoryPath + logo2RelativePath);
            // logoDestPath = Path.GetFullPath(Application.dataPath + PackConstant.Logo2DestPath);
            // if (!File.Exists(logoSourcePath))
            // {
            //     throw new Exception("File is not Exist " + logoSourcePath);
            // }
            // if (!File.Exists(logoDestPath))
            // {
            //     throw new Exception("File is not Exist " + logoDestPath);
            // }
            // File.Copy(logoSourcePath, logoDestPath, true);
            // AssetDatabase.ImportAsset(FileUtil.GetProjectRelativePath(logoDestPath.Replace('\\', '/')), ImportAssetOptions.ForceUpdate);
            EditorUtility.DisplayProgressBar("更改Logo", "完成开始更改Logo", 1);
        }

        protected void CheckAppInfo()
        {
            EditorUtility.DisplayProgressBar("AppInfo设置", "开始更改AppInfo", 0);
            string directoryPath = Application.dataPath + PackConstant.AppInfoSourcePath;
            if (string.IsNullOrEmpty(directoryPath) || !Directory.Exists(directoryPath))
            {
                throw new Exception("AppInfo Source Path is Empty " + directoryPath);
            }
            string srcFileMetaPath = Path.GetFullPath(Application.dataPath + PackConstant.AppInfoSourcePath + PackConstant.AppInfoMetaPath);
            string destFileMetaPath = Path.GetFullPath(Application.dataPath + PackConstant.AppInfoMetaPath);
            if (string.IsNullOrEmpty(srcFileMetaPath) || !File.Exists(srcFileMetaPath))
            {
                throw new Exception("AppInfo.meta Path is not Exist " + srcFileMetaPath);
            }
            string destFolder = Path.GetDirectoryName(destFileMetaPath);
            if (!Directory.Exists(destFolder))
            {
                Directory.CreateDirectory(destFolder);
            }
            File.Copy(srcFileMetaPath, destFileMetaPath, true);
            EditorUtility.DisplayProgressBar("AppInfo设置", "完成更改AppInfo", 1);
        }

        protected void ChangeAppIcon()
        {
            EditorUtility.DisplayProgressBar("AppIcon设置", "开始更改AppIcon", 0);
            string directoryPath = GetAppIconPath();
            PackLog.Log(PackConstant.TAG_ICON_PATH + directoryPath);
            if (string.IsNullOrEmpty(directoryPath) || !Directory.Exists(directoryPath))
            {
                throw new Exception("App Icon Source Path is Empty " + directoryPath);
            }
            string srcFileMetaPath = Path.GetFullPath(Application.dataPath + PackConstant.AppIconSourcePath + PackConstant.AppIconMetaPath);
            string destFileMetaPath = Path.GetFullPath(Application.dataPath + PackConstant.AppIconMetaPath);
            if (string.IsNullOrEmpty(srcFileMetaPath) || !File.Exists(srcFileMetaPath))
            {
                throw new Exception("AppIcon.meta Path is not Exist " + srcFileMetaPath);
            }
            string destFolder = Path.GetDirectoryName(destFileMetaPath);
            if (!Directory.Exists(destFolder))
            {
                Directory.CreateDirectory(destFolder);
            }
            File.Copy(srcFileMetaPath, destFileMetaPath, true);

            string destDirectoryPath = Path.GetFullPath(Application.dataPath + PackConstant.AppIconDestPath);
            if (!Directory.Exists(destDirectoryPath))
            {
                Directory.CreateDirectory(destDirectoryPath);
            }
            string[] files = Directory.GetFiles(directoryPath, "*.*", SearchOption.TopDirectoryOnly);
            foreach (var file in files)
            {
                string fileName = Path.GetFileName(file);
                File.Copy(file, Application.dataPath + PackConstant.AppIconDestPath + fileName, true);
            }
            EditorUtility.DisplayProgressBar("AppIcon设置", "开始更改AppIcon", 0.5f);
            directoryPath = FileUtil.GetProjectRelativePath(Path.GetFullPath(Application.dataPath + PackConstant.AppIconDestPath).Replace('\\', '/'));
            if (directoryPath.EndsWith("/"))
            {
                directoryPath = directoryPath.Substring(0, directoryPath.Length - 1);
            }
            AssetDatabase.ImportAsset(directoryPath, ImportAssetOptions.ImportRecursive | ImportAssetOptions.ForceUpdate);
            directoryPath = directoryPath + "/";
            BuildTarget buildTarget = GetBuildTarget();
            var buildTargetGroup = BuildPipeline.GetBuildTargetGroup(buildTarget);
            PlatformIconKind[] platformIconKinds = PlayerSettings.GetSupportedIconKindsForPlatform(buildTargetGroup);
            foreach (var platformIconKind in platformIconKinds)
            {
                PlatformIcon[] platformIcons = PlayerSettings.GetPlatformIcons(buildTargetGroup, platformIconKind);
                for (int i = 0, iMax = platformIcons.Length; i < iMax; i++)
                {
                    int size = platformIcons[i].width;
                    string path = directoryPath + size + PackConstant.AppIconExtersionName;
                    Texture2D texture2D = AssetDatabase.LoadMainAssetAtPath(path) as Texture2D;
                    if (texture2D)
                    {
                        platformIcons[i].SetTexture(texture2D);
                    }
                    else
                    {
                        PackLog.LogWarning("Not Found " + size + " Icon At Path " + path + ", Please Set It !!!");
                    }
                }
                PlayerSettings.SetPlatformIcons(buildTargetGroup, platformIconKind, platformIcons);
            }
            if (platformIconKinds == null || platformIconKinds.Length <= 0)
            {
                int[] sizes = PlayerSettings.GetIconSizesForTargetGroup(buildTargetGroup);
                Texture2D[] texture2Ds = new Texture2D[sizes.Length];
                for (int i = 0, iMax = sizes.Length; i < iMax; i++)
                {
                    int size = sizes[i];
                    string path = directoryPath + size + PackConstant.AppIconExtersionName;
                    Texture2D texture2D = AssetDatabase.LoadMainAssetAtPath(path) as Texture2D;
                    if (texture2D)
                    {
                        texture2Ds[i] = texture2D;
                    }
                    else
                    {
                        PackLog.LogWarning("Not Found " + size + " Icon At Path " + path + ", Please Set It !!!");
                    }
                }
                PlayerSettings.SetIconsForTargetGroup(buildTargetGroup, texture2Ds);
            }

            EditorUtility.DisplayProgressBar("AppIcon设置", "完成更改AppIcon", 1);
        }

        protected virtual void ChangeSplashScreen()
        {
            EditorUtility.DisplayProgressBar("SplashScreen设置", "开始更改SplashScreen", 0);
            string directoryPath = Application.dataPath + PackConstant.SplashScreenSourcePath;
            if (string.IsNullOrEmpty(directoryPath) || !Directory.Exists(directoryPath))
            {
                throw new Exception("SplashScreen Source Path is Empty " + directoryPath);
            }
            string srcFileMetaPath = Path.GetFullPath(Application.dataPath + PackConstant.SplashScreenSourcePath + PackConstant.SplashScreenMetaPath);
            if (string.IsNullOrEmpty(srcFileMetaPath) || !File.Exists(srcFileMetaPath))
            {
                throw new Exception("SplashScreen.meta Path is not Exist " + srcFileMetaPath);
            }
            string destFileMetaPath = Path.GetFullPath(Application.dataPath + PackConstant.SplashScreenMetaPath);
            string destFolder = Path.GetDirectoryName(destFileMetaPath);
            if (!Directory.Exists(destFolder))
            {
                Directory.CreateDirectory(destFolder);
            }
            File.Copy(srcFileMetaPath, destFileMetaPath, true);
            EditorUtility.DisplayProgressBar("SplashScreen设置", "更改SplashScreen", 0.1f);
            int length = splashScreenRelativeFiles.Count;
            for (int i = 0; i < length; i++)
            {
                string srcFilePath = Path.GetFullPath(Application.dataPath + PackConstant.SplashScreenSourcePath + splashScreenRelativeFiles[i]);
                if (!File.Exists(srcFilePath))
                {
                    throw new Exception("SplashScreen File Path is Empty " + srcFilePath);
                }
                string destFilePath = Path.GetFullPath(Application.dataPath + PackConstant.SplashScreenDestPath + splashScreenRelativeFiles[i]);
                destFolder = Path.GetDirectoryName(destFilePath);
                if (!Directory.Exists(destFolder))
                {
                    Directory.CreateDirectory(destFolder);
                }
                File.Copy(srcFilePath, destFilePath, true);
                srcFileMetaPath = Path.GetFullPath(Application.dataPath + PackConstant.SplashScreenSourcePath + splashScreenRelativeFiles[i] + ".meta");
                if (!File.Exists(srcFilePath))
                {
                    throw new Exception("SplashScreen File Path is Empty " + srcFilePath);
                }
                destFileMetaPath = Path.GetFullPath(Application.dataPath + PackConstant.SplashScreenDestPath + splashScreenRelativeFiles[i] + ".meta");
                destFolder = Path.GetDirectoryName(destFilePath);
                if (!Directory.Exists(destFolder))
                {
                    Directory.CreateDirectory(destFolder);
                }
                File.Copy(srcFileMetaPath, destFileMetaPath, true);
                EditorUtility.DisplayProgressBar("SplashScreen设置", "更改SplashScreen", 0.1f + ((i * 0.7f) / length));
            }
            directoryPath = FileUtil.GetProjectRelativePath(Path.GetFullPath(Application.dataPath + PackConstant.SplashScreenDestPath).Replace('\\', '/'));
            if (directoryPath.EndsWith("/"))
            {
                directoryPath = directoryPath.Substring(0, directoryPath.Length - 1);
            }
            AssetDatabase.ImportAsset(directoryPath, ImportAssetOptions.ImportRecursive | ImportAssetOptions.ForceUpdate);
            directoryPath = directoryPath + "/";
            SplashScreenLogo[] logos = new SplashScreenLogo[length];
            for (int i = 0; i < length; i++)
            {
                string path = directoryPath + splashScreenRelativeFiles[i];
                Sprite sprite = AssetDatabase.LoadAssetAtPath<Sprite>(path);
                logos[i] = SplashScreenLogo.Create(2f, sprite);
                EditorUtility.DisplayProgressBar("SplashScreen设置", "更改SplashScreen", 0.8f + ((i * 0.2f) / length));
            }
            PlayerSettings.SplashScreen.logos = logos;
            PlayerSettings.SplashScreen.show = (length > 0);
            EditorUtility.DisplayProgressBar("SplashScreen设置", "完成更改SplashScreen", 1);
        }

        protected virtual void ChangePlayerSettings()
        {
            PlayerSettings.productName = appName;
            BuildTarget buildTarget = GetBuildTarget();
            var buildTargetGroup = BuildPipeline.GetBuildTargetGroup(buildTarget);
            PlayerSettings.SetApplicationIdentifier(buildTargetGroup, bundleId);
            string defineSymbolStr = string.Join(";", defineSymbols);
            PlayerSettings.SetScriptingDefineSymbolsForGroup(buildTargetGroup, defineSymbolStr);
        }


        protected virtual void ChangeAssetsObscure()
        {
            var bindingFlags = BindingFlags.Instance | BindingFlags.Static | BindingFlags.NonPublic | BindingFlags.Public;
            var fileInfo = typeof(AssetsObscureUtil).GetField("s_ObscureKey", bindingFlags);
            fileInfo.SetValue(null, obscureKey);
            fileInfo = typeof(AssetsObscureUtil).GetField("s_ObscureOffsetMin", bindingFlags);
            fileInfo.SetValue(null, obscureOffsetMin);
            fileInfo = typeof(AssetsObscureUtil).GetField("s_ObscureOffsetValues", bindingFlags);
            fileInfo.SetValue(null, obscureOffsetValues);
        }


        protected virtual void ChangePlatformSpecial()
        {

        }

        protected virtual BuildOptions ChangeBuildOptionsBefore(BuildOptions buildOptions)
        {
            return buildOptions;
        }

        protected virtual void BuildAppCompleted(BuildOptions buildOptions)
        {

        }

        public override void BuildClear()
        {
            BuildTarget buildTarget = GetBuildTarget();
            var buildTargetGroup = BuildPipeline.GetBuildTargetGroup(buildTarget);
            string defineSymbolStr = string.Join(";", PackConstant.NeedFulDefineSymbols);
            PlayerSettings.SetScriptingDefineSymbolsForGroup(buildTargetGroup, defineSymbolStr);
            DeleteDirectoryAssets(Path.GetFullPath(Application.dataPath + PackConstant.AppInfoDestPath), true);
        }

        protected static void DeleteDirectoryAssetFile(string file)
        {
            if (!File.Exists(file)) return;
            File.Delete(file);
            string metaFilePath = file + ".meta";
            if (File.Exists(metaFilePath))
            {
                File.Delete(metaFilePath);
            }
            string folder = Path.GetDirectoryName(file);
            DeleteDirectoryAssets(folder);
        }

        protected static void DeleteDirectoryAssets(string dir, bool forceDelete = false)
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

        protected static void CopyDirectoryAssets(string srcDirPath, string destDirPath)
        {
            string[] sourceFiles = Directory.GetFiles(srcDirPath, "*.*", SearchOption.AllDirectories);
            foreach (var filePath in sourceFiles)
            {
                string fileName = filePath.Replace('\\', '/');
                string destFileName = filePath.Replace(srcDirPath, destDirPath);
                string destFolder = Path.GetDirectoryName(destFileName);
                if (!Directory.Exists(destFolder))
                {
                    Directory.CreateDirectory(destFolder);
                }
                File.Copy(fileName, destFileName, true);
            }
        }

        protected static void CopyUnityAssets(string srcPath, List<string> srcDirs, string destPath, string srcMetaPath, string destMetaPath)
        {
            string srcDirPath = Path.GetFullPath(srcPath);
            if (string.IsNullOrEmpty(srcDirPath) || !Directory.Exists(srcDirPath))
            {
                throw new Exception("App Icon Dest Path is Empty " + srcDirPath);
            }
            string srcFileMetaPath = Path.GetFullPath(srcMetaPath);
            string destFileMetaPath = Path.GetFullPath(destMetaPath);
            if (string.IsNullOrEmpty(srcFileMetaPath) || !File.Exists(srcFileMetaPath))
            {
                throw new Exception("meta Path is not Exist " + srcFileMetaPath);
            }
            string destFolder = Path.GetDirectoryName(destFileMetaPath);
            if (!Directory.Exists(destFolder))
            {
                Directory.CreateDirectory(destFolder);
            }
            File.Copy(srcFileMetaPath, destFileMetaPath, true);
            string destDirPath = Path.GetFullPath(destPath);
            if (!Directory.Exists(destDirPath))
            {
                Directory.CreateDirectory(destDirPath);
            }
            for (int i = 0, iMax = srcDirs.Count; i < iMax; i++)
            {
                CopyDirectoryAssets(srcDirPath + srcDirs[i], destDirPath);
            }
            destDirPath = FileUtil.GetProjectRelativePath(destDirPath.Replace('\\', '/'));
            if (destDirPath.EndsWith("/"))
            {
                destDirPath = destDirPath.Substring(0, destDirPath.Length - 1);
            }
            AssetDatabase.ImportAsset(destDirPath, ImportAssetOptions.ImportRecursive | ImportAssetOptions.ForceUpdate);
        }

        protected static void CopyAndReplaceDirectory(string srcPath, string dstPath, bool ignoreMetaFiles = true, bool delDstInExist = true, List<string> paths = null)
        {
            if (delDstInExist)
            {
                if (Directory.Exists(dstPath))
                {
                    Directory.Delete(dstPath, true);
                }
                if (File.Exists(dstPath))
                {
                    File.Delete(dstPath);
                }
            }
            if (!Directory.Exists(dstPath))
                Directory.CreateDirectory(dstPath);

            foreach (var file in Directory.GetFiles(srcPath))
            {
                bool isMeta = (Path.GetExtension(file) == ".meta");
                
                if (ignoreMetaFiles)
                {
                    if (isMeta) continue;
                }
                string path = Path.Combine(dstPath, Path.GetFileName(file));
                File.Copy(file, path, true);
                if (!isMeta && paths != null)
                {
                    paths.Add(path);
                }
            }
            foreach (var dir in Directory.GetDirectories(srcPath))
            {
                string path = Path.Combine(dstPath, Path.GetFileName(dir));
                if (paths != null)
                {
                    paths.Add(path);
                }
                CopyAndReplaceDirectory(dir, path, ignoreMetaFiles, delDstInExist, paths);
            }
        }
    }
}
