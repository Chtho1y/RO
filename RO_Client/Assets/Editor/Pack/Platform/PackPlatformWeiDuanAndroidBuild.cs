using System;
using System.Collections.Generic;
using System.Reflection;
using UnityEngine;

namespace Pack
{
    public partial class PackPlatformWeiDuanAndroid 
    {
        public override void ChangePlatform()
        {
            base.ChangePlatform();
            BuildApp();
        }

        public override void BuildAssetBundles()
        {
            base.BuildAssetBundles();
            BuildApp();
        }

        public override void BuildApp()
        {
            base.BuildApp();
            try
            {
                Action<string, Type> findPath = (tag, type) =>
                {
                    var methodInfo = type.GetMethod("GetInstance", BindingFlags.Instance | BindingFlags.NonPublic | BindingFlags.Public | BindingFlags.Static);
                    if (methodInfo != null)
                    {
                        var root = methodInfo.Invoke(null, null);
                        if (root != null)
                        {
                            methodInfo = type.GetMethod("ReadDirectoryPreference", BindingFlags.Instance | BindingFlags.NonPublic | BindingFlags.Public);
                            if (methodInfo != null)
                            {
                                string path = (string)methodInfo.Invoke(root, null);
                                if (string.IsNullOrEmpty(path))
                                {
                                    methodInfo = type.GetMethod("GetDefaultDirectory", BindingFlags.Instance | BindingFlags.NonPublic | BindingFlags.Public);
                                    if (methodInfo != null)
                                    {
                                        path = (string)methodInfo.Invoke(root, null);
                                    }
                                }
                                PackLog.Log(tag + path);
                            }
                        }
                    }
                };
                var assemblies = AppDomain.CurrentDomain.GetAssemblies();
                foreach (var a in assemblies)
                {
                    if (a.GetName().Name == "UnityEditor.Android.Extensions")
                    {
                        foreach (var type in a.GetTypes())
                        {
                            if (type.FullName == "UnityEditor.Android.AndroidJavaRoot")
                            {
                                findPath(PackConstant.TAG_ANDROID_JAVA_ROOT, type);
                            }
                            else if (type.FullName == "UnityEditor.Android.AndroidSDKRoot")
                            {
                                findPath(PackConstant.TAG_ANDROID_SDK_ROOT, type);
                            }
                            else if (type.FullName == "UnityEditor.Android.AndroidNDKRoot")
                            {
                                findPath(PackConstant.TAG_ANDROID_NDK_ROOT, type);
                            }
                        }
                    }
                }
                PackLog.Log(PackConstant.TAG_ICON_PATH + GetAppIconPath());
                PackLog.Log(PackConstant.TAG_AppOutPath + GetBuildOutputPath());
                PackLog.Log(PackConstant.TAG_KEYSTORE_PATH + Application.dataPath + PackConstant.KeyStorePath + keystoreName);
                PackLog.Log(PackConstant.TAG_OTHER_BUILD_PROJECT_PATH + Application.dataPath + PackConstant.OtherBuildProjectAndroid + otherBuildProject);
            }
            catch (Exception e)
            {
                PackLog.LogException(e);
                throw e;
            }
        }
    }
}