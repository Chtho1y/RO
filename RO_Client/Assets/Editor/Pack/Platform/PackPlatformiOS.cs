using System;
using System.Collections.Generic;
using UnityEditor;

namespace Pack
{
    [Serializable]
    public partial class PackPlatformiOS : PackPlatformUnity
    {
        public string leBian_MainChId = "69031";
        public string leBian_ClientChId = "wenting_test";
        public string leBian_SECID = "tx75web0.c";

        public List<string> plugins = new List<string>()
        {
            "common",
        };

        public List<string> sdkBridges = new List<string>()
        {

        };

        public override BuildTarget GetBuildTarget()
        {
            return BuildTarget.iOS;
        }
    }
}