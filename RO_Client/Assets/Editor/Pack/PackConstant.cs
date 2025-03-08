using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Pack
{
    public static class PackConstant
    {
        public const string TAG_START = "\n[PACK_RUN START]\n";
        public const string TAG_END = "\n[PACK_RUN END]\n";
        public const string TAG_WARING_START = "\n[PACK_RUN WARING START]\n";
        public const string TAG_WARING_END = "\n[PACK_RUN WARING END]\n";
        public const string TAG_ERROR_START = "\n[PACK_RUN ERROR START]\n";
        public const string TAG_ERROR_END = "\n[PACK_RUN ERROR END]\n";
        public const string TAG_EXCEPTION_START = "\n[PACK_RUN EXCEPTION START]\n";
        public const string TAG_EXCEPTION_END = "\n[PACK_RUN EXCEPTION END]\n";

        public const string TAG_ResOutPath = "[ResOutPath]";
        public const string TAG_AppOutPath = "[AppOutPath]";
        public const string TAG_ICON_PATH = "[ICON_PATH]";

        public const string TAG_KEYSTORE_PATH = "[KEYSTORE_PATH]";
        public const string TAG_OTHER_BUILD_PROJECT_PATH = "[OTHER_BUILD_PROJECT_PATH]";
        public const string TAG_ANDROID_JAVA_ROOT = "[ANDROID_JAVA_ROOT]";
        public const string TAG_ANDROID_SDK_ROOT = "[ANDROID_SDK_ROOT]";
        public const string TAG_ANDROID_NDK_ROOT = "[ANDROID_NDK_ROOT]";

        public static readonly string[] NeedFulDefineSymbols = {
            "USE_LUA",
            "VUPLEX_CCU"
        };

        public static readonly string[] AllDefineSymbols = {
            "USE_LUA",
            "VUPLEX_CCU",
            "BUGLY",
            "NULLSDK",
            "OPENGM",
            "FPS_DISABLE",
            "HEALTH_BULLETIN",
            "LEBIAN_YUN_CLIENT",
            "UNITY_INSTANTGAME"
        };

        public static readonly string[] BuildScenes = {
            "Assets/game.unity",
            "Assets/relogin.unity",
        };

        public static readonly string[] PngFilters = new string[] {
            "png",
            "png",
        };

        public static readonly string[] KeyStoreFilters = new string[] {
            "keystore",
            "keystore",
        };

        /*          以下路径都是相对于 Application.dataPath 的路径             */
        public const string BuildAppPath = "/../Build/App";
        public const string BuildSharedResourcePath = "/../Build/BuildDependenceResource";
        public const string CurPackEnvPath = "/../Build/BuildDependenceResource/CurPackEnv.ini";

        public const string PackPlatformConfigPath = "/../Build/BuildDependenceResource/PackConfig.json";

        public const string LuaPlatformPackPath = "/Lua/Core/PlatformPack.lua";

        public const string GameAssetsSourcePath = "/../Build/BuildDependenceResource/GameAssets/";
        public const string GameAssetsDestPath = "/../";
        public const string GameAssetsConfigPath = "/../Build/BuildDependenceResource/GameAssets/Config.json";

        public const string AppInfoSourcePath = "/../Build/BuildDependenceResource/AppInfo/";
        public const string AppInfoDestPath = "/AppInfo/";
        public const string AppInfoMetaPath = "/AppInfo.meta";

        public const string AppIconSourcePath = "/../Build/BuildDependenceResource/AppInfo/AppIcon/";
        public const string AppIconDestPath = "/AppInfo/AppIcons/";
        public const string AppIconMetaPath = "/AppIcons.meta";
        public const string AppIconExtersionName = ".png";

        public const string SplashScreenSourcePath = "/../Build/BuildDependenceResource/AppInfo/SplashScreen/";
        public const string SplashScreenDestPath = "/AppInfo/SplashScreen/";
        public const string SplashScreenMetaPath = "/SplashScreen.meta";

        public const string LoginSourcePath = "/../Build/BuildDependenceResource/Login/";
        public const string Login0SourcePath = "/img_login00.png";
        public const string Login1SourcePath = "/img_login01.png";
        public const string Login2SourcePath = "/img_login02.png";
        public const string Login0DestPath = "/Content/Raw_Art/UI/UILanuch/img_login00.png";
        public const string Login1DestPath = "/Content/Raw_Art/UI/UILanuch/img_login01.png";
        public const string Login2DestPath = "/Content/Icons/NewStory/img_login02.png";

        public const string LogoSourcePath = "/../Build/BuildDependenceResource/Logo/";
        public const string Logo1DestPath = "/Content/Raw_Art/UI/UILanuch/img_logo_01.png";
        public const string Logo2DestPath = "/Content/Raw_Art/UI/UILanuch/img_logo_02.png";

        public const string PluginAndroidSrcPath = "/../Build/BuildDependenceResource/Plugins/Android/";
        public const string PluginAndroidDestMetaPath = "/Plugins/Android.meta";
        public const string PluginAndroidDestPath = "/Plugins/Android/";
        public const string PluginAndroidSrcMetaPath = "/../Build/BuildDependenceResource/Plugins/Android.meta";

        public const string PluginiOSSrcPath = "/../Build/BuildDependenceResource/Plugins/iOS/";
        public const string PluginiOSDestMetaPath = "/Plugins/iOS.meta";
        public const string PluginiOSDestPath = "/Plugins/iOS/";
        public const string PluginiOSSrcMetaPath = "/../Build/BuildDependenceResource/Plugins/iOS.meta";

        public const string SDKBridgeDestPath = "/Plugins/SDKBridge/";
        public const string SDKBridgeDestMetaPath = "/Plugins/SDKBridge.meta";

        public const string SDKBridgeSrcPath = "/../Build/BuildDependenceResource/Plugins/SDKBridge/";
        public const string SDKBridgeSrcMetaPath = "/../Build/BuildDependenceResource/Plugins/SDKBridge.meta";

        public const string KeyStorePath = "/../Build/BuildDependenceResource/Cert/Android/";
    
        public const string OtherBuildProjectAndroid = "/../Build/BuildDependenceResource/OtherBuildProject/Android/";
    }
}