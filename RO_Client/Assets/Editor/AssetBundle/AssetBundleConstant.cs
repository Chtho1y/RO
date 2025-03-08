using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class AssetBundleConstant
{
    public const string copyRight = "Copyright © 2016 - 2018 . Mokun . Storm Studio All Rights Reserved";
    public const string GameVersion = "0.1.1.";
    public const string GameId = "111111";
    public const string PlatfromId = "1";
    public const string AppName = "Ro";
    public const string ApkName = "Ro";

#if UNITY_IPHONE || UNITY_IOS
    public const string PgName = "com.wenting.ro.tap";
#else
    public const string PgName = "com.toutiao.kaililong.xjgl03";
#endif

    public static bool IsDebug = false;

}
