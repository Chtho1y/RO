using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Pack
{
    [Serializable]
    public class PackPlatforms : ISerializationCallbackReceiver
    {
        [SerializeField]
        private PackPlatformAndroid[] androids;
        [SerializeField]
        private PackPlatformWeiDuanAndroid[] weiDuanAndroids;
        [SerializeField]
        private PackPlatformiOS[] iOSs;
        [SerializeField]
        private PackPlatformPC[] pCs;

        [NonSerialized]
        public PackPlatformBase[] packPlatforms;

        public void OnBeforeSerialize()
        {
            if (packPlatforms == null)
            {
                androids = null;
                iOSs = null;
                pCs = null;
                return;
            }
            List<PackPlatformAndroid> androidLs = new List<PackPlatformAndroid>();
            List<PackPlatformWeiDuanAndroid> weiDuanAndroidLs = new List<PackPlatformWeiDuanAndroid>();
            List<PackPlatformiOS> iOSLs = new List<PackPlatformiOS>();
            List<PackPlatformPC> pCLs = new List<PackPlatformPC>();
            for (int i = 0, iMax = packPlatforms.Length; i < iMax; i++)
            {
                PackPlatformBase packPlatformBase = packPlatforms[i];
                if (packPlatformBase is PackPlatformAndroid)
                {
                    androidLs.Add(packPlatformBase as PackPlatformAndroid);
                }
                else if (packPlatformBase is PackPlatformWeiDuanAndroid)
                {
                    weiDuanAndroidLs.Add(packPlatformBase as PackPlatformWeiDuanAndroid);
                }
                else if (packPlatformBase is PackPlatformiOS)
                {
                    iOSLs.Add(packPlatformBase as PackPlatformiOS);
                }
                else if (packPlatformBase is PackPlatformPC)
                {
                    pCLs.Add(packPlatformBase as PackPlatformPC);
                }
                else
                {
                    Debug.LogErrorFormat("Not Support Type : {0} At Serialize", packPlatformBase.GetType().FullName);
                }
            }
            androids = androidLs.ToArray();
            weiDuanAndroids = weiDuanAndroidLs.ToArray();
            iOSs = iOSLs.ToArray();
            pCs = pCLs.ToArray();
        }

        public void OnAfterDeserialize()
        {
            List<PackPlatformBase> packPlatformLs = new List<PackPlatformBase>();
            FormatPackPlatforms(ref packPlatformLs, androids);
            FormatPackPlatforms(ref packPlatformLs, weiDuanAndroids);
            FormatPackPlatforms(ref packPlatformLs, iOSs);
            FormatPackPlatforms(ref packPlatformLs, pCs);
            packPlatforms = packPlatformLs.ToArray();
        }

        private void FormatPackPlatforms(ref List<PackPlatformBase> packPlatformLs, PackPlatformBase[] arr)
        {
            if (arr == null) return;
            if (packPlatformLs == null) packPlatformLs = new List<PackPlatformBase>();
            for (int i = 0, iMax = arr.Length; i < iMax; i++)
            {
                packPlatformLs.Add(arr[i]);
            }
        }
    }
}