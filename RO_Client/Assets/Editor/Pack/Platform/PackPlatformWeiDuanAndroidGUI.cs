using System.IO;
using UnityEngine;
using UnityEditor;

namespace Pack
{
    public partial class PackPlatformWeiDuanAndroid
    {
        protected override bool HasPlatformSpecialGUI()
        {
            return true;
        }

        protected override void DrawPlatformSpecialGUI(bool editable, PackPlatformBase sourcePackPlatform)
        {
            base.DrawPlatformSpecialGUI(editable, sourcePackPlatform);
            PackPlatformWeiDuanAndroid sourcePackPlatformAndroid = sourcePackPlatform as PackPlatformWeiDuanAndroid;
            EditorGUILayout.Space();
            PackGUI.DrawSelectFolderField("编译用的项目路径", Application.dataPath + PackConstant.OtherBuildProjectAndroid, sourcePackPlatformAndroid.otherBuildProject, ref otherBuildProject);
            
            EditorGUILayout.Space();
            PackGUI.DrawDelayedTextField("乐变MainChId", sourcePackPlatformAndroid.leBian_MainChId, ref leBian_MainChId, true);
            PackGUI.DrawDelayedTextField("乐变ClientChId", sourcePackPlatformAndroid.leBian_ClientChId, ref leBian_ClientChId, true);
            PackGUI.DrawDelayedTextField("乐变SECID", sourcePackPlatformAndroid.leBian_SECID, ref leBian_SECID, true);
            PackGUI.DrawDelayedTextField("乐变MainChId", sourcePackPlatformAndroid.leBian_LBCloudID, ref leBian_LBCloudID, true);

            EditorGUILayout.Space();
            PackGUI.DrawSelectFileFieldWithFilters("选择KeyStore的文件", Application.dataPath + PackConstant.KeyStorePath, PackConstant.KeyStoreFilters, sourcePackPlatformAndroid.keystoreName, ref keystoreName);
            PackGUI.DrawDelayedTextField("KeystorePass", sourcePackPlatformAndroid.keystorePass, ref keystorePass, false);
            PackGUI.DrawDelayedTextField("KeyaliasName", sourcePackPlatformAndroid.keyaliasName, ref keyaliasName, false);
            PackGUI.DrawDelayedTextField("KeyaliasPass", sourcePackPlatformAndroid.keyaliasPass, ref keyaliasPass, false);
        }
    }
}