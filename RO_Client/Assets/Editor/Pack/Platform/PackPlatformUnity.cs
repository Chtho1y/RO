using System;
using System.Collections.Generic;
using UnityEngine;

namespace Pack
{
    [Serializable]
    public partial class PackPlatformUnity : PackPlatformBase
    {
        public string[] defineSymbols = new string[] { "USE_LUA", "NULLSDK", "OPENGM" };
        public string logo1RelativePath = "default.png";
        public string loginRelativePath = "Default";
        public string gameAssetsPath = "Default";
        public bool specialFuncShield = false;
        public List<string> splashScreenRelativeFiles = new List<string>()
        {
            "wenting_splash.png",
        };

        public string obscureKey = string.Empty;
        public uint obscureOffsetMin = 0;
        public int[] obscureOffsetValues;

        /// <summary>
        /// 选服的服务器列表地址
        /// </summary>
        public string sdkVerifyUrl = "https://test-roserverlist-wt.wtgames.cn/";

        /// <summary>
        /// 选服的服务器列表地址
        /// </summary>
        public string serverListUrl = "https://test-roserverlist-wt.wtgames.cn/serverlist";
        /// <summary>
        /// 公告地址
        /// </summary>
        public string notifyUrl = "https://test-noticegmt-wt.wtgames.cn/v3/notice";

        /// <summary>
        /// 特殊信息Url
        /// </summary>
        public string specialInfoUrl = "https://test-noticegmt-wt.wtgames.cn/channel";

        /// <summary>
        /// 专属客服信息Url
        /// </summary>
        public string customerServiceInfoUrl = "https://test-noticegmt-wt.wtgames.cn/vipService";
    }
}