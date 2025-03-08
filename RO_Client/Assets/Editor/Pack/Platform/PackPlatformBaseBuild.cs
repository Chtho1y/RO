using System.IO;
using UnityEditor;
using UnityEngine;

namespace Pack
{
    public abstract partial class PackPlatformBase
    {
        public abstract BuildTarget GetBuildTarget();

        protected virtual string GetBuildOutputPath()
        {
            string path = Application.dataPath + PackConstant.BuildAppPath + "/" + GetBuildTarget() + "/" + GetPackFileName();
            path = Path.GetFullPath(path).Replace('\\', '/');
            return path;
        }

        protected virtual string GetAppIconPath()
        {
            string directoryPath = Application.dataPath + PackConstant.AppIconSourcePath + iconRelativePath;
            return directoryPath;
        }

        public virtual bool CanChangePlatform()
        {
            return true;
        }

        public virtual void ChangePlatform()
        {
        }

        public virtual bool CanBuildAssetBundles()
        {
            return true;
        }

        public virtual void BuildAssetBundles()
        {
        }

        public virtual bool CanBuildApp()
        {
            return true;
        }

        public virtual void BuildApp()
        {
        }

        public virtual bool CanBuildClear()
        {
            return true;
        }

        public virtual void BuildClear()
        {

        }
    }
}