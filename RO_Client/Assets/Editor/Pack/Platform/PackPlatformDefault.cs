using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

namespace Pack
{
    public class PackPlatformDefault : PackPlatformUnity
    {
        public override BuildTarget GetBuildTarget()
        {
            return EditorUserBuildSettings.activeBuildTarget;
        }
    }
}