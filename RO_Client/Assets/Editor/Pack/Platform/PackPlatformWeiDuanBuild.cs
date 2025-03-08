using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Pack
{
    public abstract partial class PackPlatformWeiDuan
    {
        public override bool CanChangePlatform()
        {
            return false;
        }

        public override bool CanBuildAssetBundles()
        {
            return false;
        }

        public override bool CanBuildApp()
        {
            return false;
        }

        public override bool CanBuildClear()
        {
            return false;
        }
    }
}
