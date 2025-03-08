using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEditor;
#if UNITY_IOS
using UnityEditor.iOS.Xcode;
#endif


namespace Pack
{
    public partial class PackPlatformiOS
    {
        protected override string GetBuildOutputPath()
        {
            // iOS 的XCode项目路径最好不能有中文，否则易出错
            string path = Application.dataPath + PackConstant.BuildAppPath + "/" + GetBuildTarget() + "/" + channelUniqueId;
            path = Path.GetFullPath(path).Replace('\\', '/');
            return path + "/XCodeProj";
        }

        public override void BuildClear()
        {
            base.BuildClear();
            DeleteDirectoryAssets(Path.GetFullPath(Application.dataPath + PackConstant.PluginiOSDestPath), true);
            DeleteDirectoryAssets(Path.GetFullPath(Application.dataPath + PackConstant.SDKBridgeDestPath), true);
        }

        protected override void ChangePlayerSettings()
        {
            base.ChangePlayerSettings();
            PlayerSettings.bundleVersion = gameVersionCode.ToString(true);
            PlayerSettings.iOS.buildNumber = gameVersionCode;
        }

        protected override void ChangePlatformSpecial()
        {
            base.ChangePlatformSpecial();
            EditorUtility.DisplayProgressBar("平台特殊设置", "开始平台特殊设置", 0);
            if (plugins != null && plugins.Count > 0)
            {
                CopyUnityAssets(Application.dataPath + PackConstant.PluginiOSSrcPath
                                , plugins
                                , Application.dataPath + PackConstant.PluginiOSDestPath
                                , Application.dataPath + PackConstant.PluginiOSSrcMetaPath
                                , Application.dataPath + PackConstant.PluginiOSDestMetaPath);
            }
            EditorUtility.DisplayProgressBar("平台特殊设置", "平台特殊设置", 0.5f);
            if (sdkBridges != null && sdkBridges.Count > 0)
            {
                CopyUnityAssets(Application.dataPath + PackConstant.SDKBridgeSrcPath
                                    , sdkBridges
                                    , Application.dataPath + PackConstant.SDKBridgeDestPath
                                    , Application.dataPath + PackConstant.SDKBridgeSrcMetaPath
                                    , Application.dataPath + PackConstant.SDKBridgeDestMetaPath);
            }
            EditorUtility.DisplayProgressBar("平台特殊设置", "完成平台特殊设置", 1);
        }

        protected override BuildOptions ChangeBuildOptionsBefore(BuildOptions buildOptions)
        {
            buildOptions = base.ChangeBuildOptionsBefore(buildOptions);
            return buildOptions;
        }

        protected override void BuildAppCompleted(BuildOptions buildOptions)
        {
            base.BuildAppCompleted(buildOptions);
            string outPath = GetBuildOutputPath();
            // iOS 的XCode项目路径最好不能有中文，否则易出错
            // 所以设置一个txt文件来标注项目名字
            string dirPath = Path.GetDirectoryName(outPath);
            if (!Directory.Exists(dirPath))
            {
                Directory.CreateDirectory(dirPath);
            }

            string[] files = Directory.GetFiles(dirPath, ".txt");
            bool exist = false;
            string packFileName = GetPackFileName();
            foreach (string file in files)
            {
                if (Path.GetFileNameWithoutExtension(file) == packFileName)
                {
                    exist = true;
                }
                else
                {
                    File.Delete(file);
                }
            }
            if (!exist)
            {
                File.Create(Path.Combine(dirPath, packFileName + ".txt"));
            }

            // 为了过审核，需要删除OpenUrl
            File.Copy(Application.dataPath + PackConstant.BuildSharedResourcePath + "/Plugins/Special/iOS/libiPhone-lib.a", Path.Combine(outPath, "Libraries/libiPhone-lib.a"), true);
            ChangeXCodeProject(buildOptions);
        }

        protected void ChangeXCodeProject(BuildOptions buildOptions)
        {
#if UNITY_IOS
            EditorUtility.DisplayProgressBar("修改XCodeProject", "开始修改XCodeProject", 0);
            string outPath = GetBuildOutputPath();
            PBXProject pbxProject = new PBXProject();
            string pbxprojPath = PBXProject.GetPBXProjectPath(outPath);
            pbxProject.ReadFromFile(pbxprojPath);
            string targetGuid = pbxProject.TargetGuidByName("Unity-iPhone");
            pbxProject.SetBuildProperty(targetGuid, "ENABLE_BITCODE", "NO");
            pbxProject.AddBuildProperty(targetGuid, "OTHER_LDFLAGS", "-ObjC");
            if (plugins.Contains("Bugly"))
            {
                pbxProject.AddFrameworkToProject(targetGuid, "libz.dylib", false);
                pbxProject.AddFrameworkToProject(targetGuid, "libc++.dylib", false);
            }
            if (plugins.Contains("Lebian"))
            {
                if ((buildOptions & BuildOptions.AcceptExternalModificationsToPlayer) == 0)
                {
                    pbxProject.AddShellScriptBuildPhase(targetGuid, "LB Script", "/bin/sh", "echo $(date \"+%Y%m%d%H%M%S\")$(tr -dc \"a-z\" < /dev/urandom | head -c 2) > $TARGET_BUILD_DIR/$PRODUCT_NAME.app/LBTimestamp");
                }
            }
            pbxProject.WriteToFile(pbxprojPath);
            EditorUtility.DisplayProgressBar("修改XCodeProject", "修改project.pbxproj完成", 0.25f);

            string plistPath = Path.Combine(outPath, "Info.plist");
            PlistDocument plistDocument = new PlistDocument();
            plistDocument.ReadFromFile(plistPath);
            if (plugins.Contains("Lebian"))
            {
                int appId;
                if (!ExpressionEvaluator.Evaluate(leBian_MainChId, out appId))
                {
                    appId = 0;
                }
                plistDocument.root.SetInteger("LEBIAN_APPID", appId);
                plistDocument.root.SetString("LEBIAN_SECID", leBian_SECID);
                plistDocument.root.SetString("LEBIAN_META", leBian_ClientChId);
                plistDocument.root.SetInteger("LEBIAN_VERCODE", (int)(uint)resVersionCode);
            }

            if (!string.IsNullOrEmpty(plugins.Find((x)=>x.StartsWith("YOUYI"))))
            {
                plistDocument.root.SetString("YouYi_GameId", "1023");
                plistDocument.root.SetString("YouYi_AppKey", "3db62ef3789f3752a4a6d1b7ffc6f922");
                plistDocument.root.SetString("YouYi_VestId", "");
                plistDocument.root.SetString("NSUserTrackingUsageDescription", "获取设备信息用以精准推送您喜欢的内容");
            }
            plistDocument.WriteToFile(plistPath);
            EditorUtility.DisplayProgressBar("修改XCodeProject", "修改info.list完成", 0.5f);

            if ((buildOptions & BuildOptions.AcceptExternalModificationsToPlayer) == 0)
            {
                string deviceSettingsMMPath = Path.Combine(outPath, "Classes/Unity/DeviceSettings.mm");
                ObjCScript script = new ObjCScript(deviceSettingsMMPath);
                script.AddImport("WentingSDK.h");
                script.ReplaceInLine("_VendorID = AllocCString([[UIDevice currentDevice].identifierForVendor UUIDString]);",
                                        "_VendorID = AllocCString([WentingSDK GetUUID]);");
                script.Save();

                if (plugins.Contains("Lebian"))
                {
                    string unityAppControllerMMPath = Path.Combine(outPath, "Classes/UnityAppController.mm");
                    script = new ObjCScript(unityAppControllerMMPath);
                    script.AddImport("LBSDK/LBInit.h", true);
                    int idx = script.FindLine("::printf(\"-> applicationDidFinishLaunching()\\n\");");
                    script.InsertLine(idx, idx + 1);
                    script.InsertLine(idx, idx + 2, "// 请务必在方法的最前面调用该接口，否则很容易出问题");
                    script.InsertLine(idx, idx + 3, "if ([[LBInit sharedInstance] LBSDKShouldInitWithLaunchOptions:launchOptions]) {");
                    script.InsertLine(idx, idx + 4, "\treturn YES;");
                    script.InsertLine(idx, idx + 5, "}");
                    script.InsertLine(idx, idx + 6);
                    script.Save();
                }

                if (plugins.Contains("WentingLicense"))
                {
                    string unityAppControllerMMPath = Path.Combine(outPath, "Classes/UnityAppController.mm");
                    script = new ObjCScript(unityAppControllerMMPath);
                    script.AddImport("WentingLicense.h", false);
                    int idx = script.FindLine("::printf(\"-> applicationDidFinishLaunching()\\n\");");
                    script.InsertLine(idx, idx + 1);
                    script.InsertLine(idx, idx + 2, "if ([[WentingLicense sharedInstance] CheckAgreeWithLaunchOptions:launchOptions]) {");
                    script.InsertLine(idx, idx + 3, "\treturn YES;");
                    script.InsertLine(idx, idx + 4, "}");
                    script.InsertLine(idx, idx + 5);
                    script.Save();
                }

                if (!string.IsNullOrEmpty(plugins.Find((x)=>x.StartsWith("YOUYI"))))
                {
                    string unityAppControllerMMPath = Path.Combine(outPath, "Classes/UnityAppController.mm");
                    script = new ObjCScript(unityAppControllerMMPath);
                    script.AddImport("YWBeginSDK.h", false);
                    int idx = script.FindLine("::printf(\"-> applicationWillEnterForeground()\\n\");");
                    script.InsertLine(idx, idx + 1);
                    script.InsertLine(idx, idx + 2, "[[YWBeginSDK standardDeafaults] ywInterfaceApplicationWillEnterForeground];");
                    script.InsertLine(idx, idx + 3);
                    script.Save();
                }
            }

            EditorUtility.DisplayProgressBar("修改XCodeProject", "完成修改XCodeProject", 1);
            EditorUtility.ClearProgressBar();
#endif
        }


        protected class ObjCScript
        {
            private string m_FilePath;
            private List<string> m_Lines;
            private int importIdx = -1;
            private int includeIdx = -1;

            public ObjCScript(string filePath)
            {
                m_FilePath = filePath;
                if (!File.Exists(filePath))
                {
                    PackLog.LogError(filePath + " is not Exist");
                    return;
                }
                m_Lines = new List<string>(File.ReadAllLines(filePath));
                for (int i = 0, iMax = m_Lines.Count; i < iMax; i++)
                {
                    string line = m_Lines[i].Trim();
                    if (line.StartsWith("#import "))
                    {
                        importIdx = i;
                    }

                    if (line.StartsWith("#include "))
                    {
                        includeIdx = i;
                    }
                }
            }

            public void AddImport(string name, bool isframework = false)
            {
                if (m_Lines == null)
                {
                    PackLog.LogError(m_FilePath + " is not Valid Objc Script");
                    return;
                }
                int idx = -1;
                if (importIdx >= 0 && importIdx < m_Lines.Count)
                {
                    idx = importIdx;
                }
                if (idx == -1)
                {
                    if (includeIdx >= 0 && includeIdx < m_Lines.Count)
                    {
                        idx = includeIdx;
                    }
                }
                if (idx == -1)
                {
                    PackLog.LogError(m_FilePath + " is not Valid Objc Script");
                    return;
                }
                if (isframework)
                {
                    idx = idx + 1;
                    m_Lines.Insert(idx, "#import <" + name + ">");
                }
                else
                {
                    idx = idx + 1;
                    m_Lines.Insert(idx, "#import \"" + name + "\"");
                }
            }

            public int FindLine(string str)
            {
                if (m_Lines == null)
                {
                    PackLog.LogError(m_FilePath + " is not Valid Objc Script");
                    return -1;
                }
                return m_Lines.FindIndex((x) => x.Contains(str));
            }

            public void InsertLine(int alginIdx, int insertIdx, string str = "")
            {
                if (m_Lines == null)
                {
                    PackLog.LogError(m_FilePath + " is not Valid Objc Script");
                    return;
                }
                if (alginIdx < 0 || alginIdx >= m_Lines.Count)
                {
                    PackLog.LogError(" alginIdx is not Valid Value " + alginIdx);
                    return;
                }
                if (insertIdx < 0 || insertIdx >= m_Lines.Count)
                {
                    PackLog.LogError(" insertIdx is not Valid Value " + insertIdx);
                    return;
                }
                if (string.IsNullOrEmpty(str))
                {
                    m_Lines.Insert(insertIdx, "");
                    return;
                }
                string line = m_Lines[alginIdx];
                int len1 = line.Length;
                int len2 = len1 - line.TrimStart().Length;
                string startStr = line.Substring(0, len2);
                m_Lines.Insert(insertIdx, startStr + str);
                return;
            }

            public void ReplaceInLine(string oldStr, string newStr)
            {
                if (m_Lines == null)
                {
                    PackLog.LogError(m_FilePath + " is not Valid Objc Script");
                    return;
                }
                for (int i = 0, iMax = m_Lines.Count; i < iMax; i++)
                {
                    string line = m_Lines[i];
                    if (line.Contains(oldStr))
                    {
                        m_Lines[i] = line.Replace(oldStr, newStr);
                    }
                }
            }

            public void Save()
            {
                if (m_Lines == null) return;
                File.WriteAllLines(m_FilePath, m_Lines);
            }

            public override string ToString()
            {
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                for (int i = 0, iMax = m_Lines.Count; i < iMax; i++)
                {
                    sb.AppendLine(m_Lines[i]);
                }
                return sb.ToString();
            }
        }
    }
}