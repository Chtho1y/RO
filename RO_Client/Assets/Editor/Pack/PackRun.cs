using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEditor;
using UnityEngine;

namespace Pack
{
    public static class PackRun
    {
        private static PackPlatforms s_Configs = null;

        public static PackPlatforms GetConfigs(bool forceRefresh = false)
        {
            if (s_Configs == null || forceRefresh)
            {
                s_Configs = null;
                try
                {
                    string path = Path.GetFullPath(Application.dataPath + PackConstant.PackPlatformConfigPath);
                    if (File.Exists(path))
                    {
                        UTF8Encoding uTF8Encoding = new UTF8Encoding(false);
                        string configStr = File.ReadAllText(path, uTF8Encoding);
                        s_Configs = JsonUtility.FromJson<PackPlatforms>(configStr);
                    }
                }
                catch (Exception e)
                {
                    s_Configs = null;
                    Debug.LogException(e);
                }
            }
            return s_Configs;
        }

        public static void SaveConfigs(PackPlatforms packPlatforms)
        {
            if (packPlatforms == null) return;
            try
            {
                string path = Path.GetFullPath(Application.dataPath + PackConstant.PackPlatformConfigPath);
                if (!File.Exists(path))
                {
                    if (!Directory.Exists(Path.GetDirectoryName(path)))
                    {
                        Directory.CreateDirectory(Path.GetDirectoryName(path));
                    }
                    var fs = File.Create(path);
                    fs.Dispose();
                }
                s_Configs = packPlatforms;
                string configStr = JsonUtility.ToJson(packPlatforms, true);
                UTF8Encoding uTF8Encoding = new UTF8Encoding(false);
                File.WriteAllText(path, configStr, uTF8Encoding);
            }
            catch (Exception e)
            {
                Debug.LogException(e);
            }
        }

        public static void ChangePlatform(string channelUniqueId)
        {
            PackPlatforms packPlatforms = GetConfigs(true);
            foreach (PackPlatformBase packPlatformBase in packPlatforms.packPlatforms)
            {
                if (channelUniqueId == packPlatformBase.channelUniqueId)
                {
                    ChangePlatform(packPlatformBase);
                    return;
                }
            }
            throw new PackException("目标打包平台是错误的");
        }

        public static void ChangePlatform(PackPlatformBase packPlatformBase)
        {
            if (packPlatformBase == null)
            {
                throw new PackException("目标打包平台是错误的");
            }
            if (!packPlatformBase.CanChangePlatform())
            {
                packPlatformBase.ChangePlatform();
                return;
            }
            if (EditorApplication.isCompiling)
            {
                throw new PackException("编辑器正在编译脚本文件，不能开始切换平台");
            }
            ClearCurEnv();
            RecordCurEnv(packPlatformBase);
            packPlatformBase.ChangePlatform();
        }

        public static void BuildAB(string channelUniqueId)
        {
            PackPlatforms packPlatforms = GetConfigs(true);
            foreach (PackPlatformBase packPlatformBase in packPlatforms.packPlatforms)
            {
                if (channelUniqueId == packPlatformBase.channelUniqueId)
                {
                    BuildAB(packPlatformBase);
                    return;
                }
            }
            throw new PackException("目标打包平台是错误的");
        }

        public static void BuildAB(PackPlatformBase packPlatformBase)
        {
            if (packPlatformBase == null)
            {
                throw new PackException("目标打包平台是错误的");
            }
            if (!packPlatformBase.CanBuildAssetBundles())
            {
                packPlatformBase.BuildAssetBundles();
                return;
            }
            if (EditorApplication.isCompiling)
            {
                throw new PackException("编辑器正在编译脚本文件，不能开始编译AB");
            }
            ClearCurEnv();
            RecordCurEnv(packPlatformBase);
            packPlatformBase.BuildAssetBundles();
        }

        public static void BuildApp(string channelUniqueId)
        {
            PackPlatforms packPlatforms = GetConfigs(true);
            foreach (PackPlatformBase packPlatformBase in packPlatforms.packPlatforms)
            {
                if (channelUniqueId == packPlatformBase.channelUniqueId)
                {
                    BuildApp(packPlatformBase);
                    return;
                }
            }
            throw new PackException("目标打包平台是错误的");
        }

        public static void BuildApp(PackPlatformBase packPlatformBase)
        {
            if (packPlatformBase == null)
            {
                throw new PackException("目标打包平台是错误的");
            }
            if (!packPlatformBase.CanBuildApp())
            {
                packPlatformBase.BuildApp();
                return;
            }
            if (EditorApplication.isCompiling)
            {
                throw new PackException("编辑器正在编译脚本文件，不能开始编译App");
            }
            ClearCurEnv();
            RecordCurEnv(packPlatformBase);
            packPlatformBase.BuildApp();
        }

        public static string GetCurChannelUniqueId()
        {
            if (packToolsSettings != null)
            {
                return packToolsSettings.channelUniqueId;
            }
            return "";
        }

        public static void ClearBuildAndResetDefault()
        {
            if (EditorApplication.isCompiling)
            {
                throw new PackException("编辑器正在编译脚本文件，不能开始编译App");
            }
            ClearCurEnv();
            new PackPlatformDefault().ChangePlatform();
        }

        private static void ClearCurEnv()
        {
            PackPlatforms packPlatforms = GetConfigs();
            string channelUniqueId = string.Empty;
            string buildTargetStr = string.Empty;
            if (packToolsSettings != null)
            {
                channelUniqueId = packToolsSettings.channelUniqueId;
                buildTargetStr = packToolsSettings.buildClassName;
            }
            PackPlatformBase curPackPlatformBase = null;
            if (!string.IsNullOrEmpty(channelUniqueId))
            {
                curPackPlatformBase = packPlatforms.packPlatforms.FindFirst((x) => x.channelUniqueId == channelUniqueId);
            }
            if (curPackPlatformBase != null)
            {
                curPackPlatformBase.BuildClear();
            }
            else
            {
                curPackPlatformBase = packPlatforms.packPlatforms.FindFirst((x) => x.GetType().FullName == buildTargetStr);
                if (curPackPlatformBase != null)
                {
                    curPackPlatformBase.BuildClear();
                }
            }
            RecordCurEnv(null);
        }

        private static void RecordCurEnv(PackPlatformBase packPlatformBase)
        {
            if (packPlatformBase == null)
            {
                if (packToolsSettings != null)
                {
                    packToolsSettings.channelUniqueId = string.Empty;
                    packToolsSettings.buildClassName = string.Empty;
                }
            }
            else
            {
                if (packToolsSettings != null)
                {
                    packToolsSettings.channelUniqueId = packPlatformBase.channelUniqueId;
                    packToolsSettings.buildClassName = packPlatformBase.GetType().FullName;
                }
            }
            SavePackToolsSettings();
        }

        private static void CommandLineBuildApp()
        {
            if (EditorApplication.isCompiling)
            {
                throw new PackException("编辑器正在编译脚本文件，不能开始执行命令行");
            }
            Dictionary<string, string> args = GetValidCommandLineArgs(Environment.GetCommandLineArgs());
            if (args.Count <= 0)
            {
                throw new PackException("参数为空，无法打包");
            }
            if (args.ContainsKey("-h"))
            {
                string content = GetCanPackPlatformStr();
                throw new PackException(content);
            }
            if (args.ContainsKey("-buildAB"))
            {
                if (string.IsNullOrEmpty(args["-buildAB"]))
                    throw new PackException("目标平台不能为空，请使用-h来查看可编译平台");
                else
                {
                    BuildAB(args["-buildAB"]);
                    return;
                }
            }
            if (args.ContainsKey("-buildApp"))
            {
                if (string.IsNullOrEmpty(args["-buildApp"]))
                    throw new PackException("目标平台不能为空，请使用-h来查看可编译平台");
                else
                {
                    BuildApp(args["-buildApp"]);
                    return;
                }
            }
            throw new PackException("无可执行的命令");
        }

        private static void CommandLineLog(string message)
        {
            Debug.Log(PackConstant.TAG_START + message + PackConstant.TAG_END);
        }

        private static List<string> s_ValidCommandLineArgNames = new List<string>() {
            "-h",
            "-buildAB",
            "-buildApp",
            "-androidEnv"
        };

        private static Dictionary<string, string> GetValidCommandLineArgs(string[] args)
        {
            Dictionary<string, string> maps = new Dictionary<string, string>();
            for (int i = 0, iMax = args.Length; i < iMax; i++)
            {
                if (s_ValidCommandLineArgNames.Contains(args[i]))
                {
                    if (i + 1 >= iMax)
                        maps.Add(args[i], string.Empty);
                    else
                        maps.Add(args[i], args[i + 1]);
                    i++;
                }
            }
            return maps;
        }

        private static string GetCanPackPlatformStr()
        {
            PackPlatforms packPlatforms = GetConfigs(true);
            if (packPlatforms == null || packPlatforms.packPlatforms == null ||
                packPlatforms.packPlatforms.Length <= 0)
            {
                return "无可打包的平台，请检查";
            }
            StringBuilder sb = new StringBuilder();
            sb.Append("ID");
            sb.Append("\t\t\t\t");
            sb.Append("Name");
            sb.Append("\n");
            for (int i = 0, iMax = packPlatforms.packPlatforms.Length; i < iMax; i++)
            {
                PackPlatformBase packPlatformBase = packPlatforms.packPlatforms[i];
                sb.Append(packPlatformBase.channelUniqueId);
                sb.Append("\t\t\t");
                sb.Append(packPlatformBase.GetChannelUniqueName());
                sb.Append("\n");
            }
            string content = sb.ToString();
            if (string.IsNullOrEmpty(content))
            {
                return "无可打包的平台，请检查";
            }
            return content;
        }

        private static void BuildPlayerHandler(BuildPlayerOptions options)
        {
            PackWindow.OpenPackWindow();
            EditorUtility.DisplayDialog("提示", "请使用打包工具来打包", "好的");
        }

        private static void OnQuitting()
        {
            SavePackToolsSettings();
        }

        [InitializeOnLoadMethod]
        private static void RegisterBuildPlayerHandler()
        {
            // TODO: UNITY
            //      allow Build button in Build Settings window
            // BuildPlayerWindow.RegisterBuildPlayerHandler(BuildPlayerHandler);
            EditorApplication.quitting += OnQuitting;
        }


        private static PackToolsSettings s_PackToolsSettings = null;
        public static PackToolsSettings packToolsSettings
        {
            get
            {
                if (s_PackToolsSettings == null)
                {
                    if (File.Exists(Application.dataPath + PackConstant.CurPackEnvPath))
                    {
                        string content = File.ReadAllText(Application.dataPath + PackConstant.CurPackEnvPath);
                        s_PackToolsSettings = JsonUtility.FromJson<PackToolsSettings>(content);
                    }
                    if (s_PackToolsSettings == null)
                        s_PackToolsSettings = new PackToolsSettings();
                }
                return s_PackToolsSettings;
            }
        }

        public static void SavePackToolsSettings()
        {
            if (packToolsSettings != null && packToolsSettings.IsDirty())
            {
                File.WriteAllText(Application.dataPath + PackConstant.CurPackEnvPath, JsonUtility.ToJson(packToolsSettings));
            }
        }

        [Serializable]
        public class PackToolsSettings : ISerializationCallbackReceiver
        {
            [SerializeField]
            private string m_ChannelUniqueId = "";
            [SerializeField]
            private string m_BuildClassName = "";

            public string channelUniqueId
            {
                get; set;
            }
            public string buildClassName
            {
                get; set;
            }

            public PackToolsSettings()
            {
                OnAfterDeserialize();
            }

            public bool IsDirty()
            {
                if (m_ChannelUniqueId != channelUniqueId)
                    return true;
                if (m_BuildClassName != buildClassName)
                    return true;

                return false;
            }

            public void OnAfterDeserialize()
            {
                channelUniqueId = m_ChannelUniqueId;
                buildClassName = m_BuildClassName;
            }

            public void OnBeforeSerialize()
            {
                m_ChannelUniqueId = channelUniqueId;
                m_BuildClassName = buildClassName;
            }
        }
    }
}