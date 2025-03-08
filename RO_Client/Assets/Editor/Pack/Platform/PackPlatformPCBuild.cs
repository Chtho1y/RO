using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEditor;

namespace Pack
{
    public partial class PackPlatformPC
    {
        protected override void ChangePlayerSettings()
        {
            base.ChangePlayerSettings();
            PlayerSettings.bundleVersion = gameVersionCode.ToString();
            PlayerSettings.defaultScreenWidth = 480;
            PlayerSettings.defaultScreenHeight = 800;
            PlayerSettings.displayResolutionDialog = ResolutionDialogSetting.Disabled;
        }

        public override BuildTarget GetBuildTarget()
        {
            return BuildTarget.StandaloneWindows64;
        }

        protected override string GetBuildOutputPath()
        {
            string path = base.GetBuildOutputPath();
            return path + "/Game.exe";
        }

        protected override void BuildAppCompleted(BuildOptions buildOptions)
        {
            base.BuildAppCompleted(buildOptions);
            string outPath = GetBuildOutputPath();
            string dirPath = Path.GetDirectoryName(outPath);
            string name = Path.GetFileNameWithoutExtension(outPath);
            string destPath = dirPath + "/" + name + "_Data/Plugins/VuplexWebViewChromium";
            string srcPath = Application.dataPath + "/Plugins/VuplexWebViewChromium";
            CopyAndReplaceDirectory(srcPath, destPath);
        }
    }
}