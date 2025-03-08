using System.Collections.Generic;
using System;
using System.IO;
using System.Reflection;
using System.Text;
using UnityEngine;
using UnityEditor;

namespace Pack
{
    [Serializable]
    public partial class PackPlatformBase : IEquatable<PackPlatformBase>, ICloneable
    {
        public string channelName = "文庭";
        public string appName = "仙境归来";
        public string distributeName = "无SDK版本";
        public string channelUniqueId = "0";
        public string bundleId = "com.wt.no.sdk.test";
        public VersionCode gameVersionCode = VersionCode.zeroVersionCode;
        public VersionCode resVersionCode = VersionCode.zeroVersionCode;
        public string iconRelativePath = "Default";

        public string GetChannelUniqueName()
        {
            if (string.IsNullOrEmpty(distributeName))
                return GetBuildTarget() + "/" + channelName + "/" + appName;
            else
                return GetBuildTarget() + "/" + channelName + "/" + appName + "(" + distributeName + ")";
        }

        protected string GetPackFileName()
        {
            string packFileName;
            if (string.IsNullOrEmpty(distributeName))
                packFileName = channelName + "_" + appName;
            else
                packFileName = channelName + "_" + appName + "(" + distributeName + ")";
            packFileName = packFileName.Replace("\\", "_");
            packFileName = packFileName.Replace("/", "_");
            return packFileName;
        }

        public virtual bool Equals(PackPlatformBase packPlatform)
        {
            if (packPlatform == null)
                return false;
            if (GetType() != packPlatform.GetType())
                return false;
            // 由于是编辑环境，暂时这么处理，效率并不高
            string contentStr1 = JsonUtility.ToJson(this);
            string contentStr2 = JsonUtility.ToJson(packPlatform);
            return (contentStr1 == contentStr2);
        }

        public virtual object Clone()
        {
            // 由于是编辑环境，暂时这么处理，效率并不高
            string contentStr = JsonUtility.ToJson(this);
            return JsonUtility.FromJson(contentStr, GetType());
        }

    }
}