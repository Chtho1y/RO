using System;
using System.IO;
using System.Text;
using UnityEngine;
using UnityEditor;

namespace Pack
{
    public partial class PackPlatformAndroid
    {
        public override void BuildClear()
        {
            base.BuildClear();
            DeleteDirectoryAssets(Path.GetFullPath(Application.dataPath + PackConstant.PluginAndroidDestPath), true);
            DeleteDirectoryAssets(Path.GetFullPath(Application.dataPath + PackConstant.SDKBridgeDestPath), true);
        }

        protected override void ChangePlayerSettings()
        {
            base.ChangePlayerSettings();
            PlayerSettings.bundleVersion = gameVersionCode;
            PlayerSettings.Android.bundleVersionCode = (int)(uint)gameVersionCode;
            EditorUserBuildSettings.androidBuildSubtarget = MobileTextureSubtarget.ETC2;
            PlayerSettings.Android.keystoreName = Application.dataPath + PackConstant.KeyStorePath + keystoreName;
            PlayerSettings.Android.keystorePass = keystorePass;
            PlayerSettings.Android.keyaliasName = keyaliasName;
            PlayerSettings.Android.keyaliasPass = keyaliasPass;
        }

        protected override void ChangePlatformSpecial()
        {
            base.ChangePlatformSpecial();
            EditorUtility.DisplayProgressBar("平台特殊设置", "开始平台特殊设置", 0);
            if (plugins != null && plugins.Count > 0)
            {
                CopyUnityAssets(Application.dataPath + PackConstant.PluginAndroidSrcPath
                                , plugins
                                , Application.dataPath + PackConstant.PluginAndroidDestPath
                                , Application.dataPath + PackConstant.PluginAndroidSrcMetaPath
                                , Application.dataPath + PackConstant.PluginAndroidDestMetaPath);

                if (!string.IsNullOrEmpty(plugins.Find((x)=>x.StartsWith("Lebian"))))
                {
                    string lebianCustPath = Path.GetFullPath(Application.dataPath + PackConstant.PluginAndroidDestPath + "lebian/lebian_cust.gradle");
                    if (!File.Exists(lebianCustPath))
                    {
                        throw new Exception("找不到乐变自定义文件" + lebianCustPath);
                    }
                    string content = File.ReadAllText(lebianCustPath);
                    content = content.Replace("${MainChId}", leBian_MainChId);
                    content = content.Replace("${ClientChId}", leBian_ClientChId);
                    content = content.Replace("${LEBIAN_SECID}", leBian_SECID);
                    content = content.Replace("${LEBIAN_VERCODE}", ((uint)resVersionCode).ToString());
                    File.WriteAllText(lebianCustPath, content);
                }
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
    }
}