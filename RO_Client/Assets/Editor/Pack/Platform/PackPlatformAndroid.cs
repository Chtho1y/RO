
using System;
using System.Collections.Generic;
using UnityEditor;

namespace Pack
{
    [Serializable]
    public partial class PackPlatformAndroid : PackPlatformUnity
    {
        public string leBian_MainChId = "68701";
        public string leBian_ClientChId = "wenting_test";
        public string leBian_SECID = "aczir2b2.c";
        public List<string> plugins = new List<string>()
        {
            "common",
        };

        public List<string> sdkBridges = new List<string>()
        {

        };

        public string keystoreName = "wenting.keystore";
        public string keystorePass = "n9P5j2b7blMm";
        public string keyaliasName = "game";
        public string keyaliasPass = "KlYX666Ro";

        public override BuildTarget GetBuildTarget()
        {
            return BuildTarget.Android;
        }

        protected override string GetBuildOutputPath()
        {
            string path = base.GetBuildOutputPath();
            return path + ".apk";
        }
    }
}