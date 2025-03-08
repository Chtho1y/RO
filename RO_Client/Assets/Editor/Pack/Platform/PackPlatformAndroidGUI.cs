using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEditor;
using UnityEditorInternal;

namespace Pack
{
    public partial class PackPlatformAndroid
    {

        private List<string> m_NeedFulplugins = new List<string>()
        {
            "common",
        };

        private DirectoryReorderableList m_PluginReorderableList;

        private List<string> m_NeedFulSDKBridges = new List<string>()
        {
        };
        private DirectoryReorderableList m_SdkBridgeReorderableList;


        protected override bool HasPlatformSpecialGUI()
        {
            return true;
        }

        protected override void DrawPlatformSpecialGUI(bool editable, PackPlatformBase sourcePackPlatform)
        {
            base.DrawPlatformSpecialGUI(editable, sourcePackPlatform);
            PackPlatformAndroid sourcePackPlatformAndroid = sourcePackPlatform as PackPlatformAndroid;
            EditorGUILayout.Space();
            if (ArrayUtility.Contains(defineSymbols, "BUGLY"))
            {
                if (!m_NeedFulplugins.Contains("Bugly"))
                {
                    m_NeedFulplugins.Add("Bugly");
                }
                if (!m_NeedFulSDKBridges.Contains("Bugly"))
                {
                    m_NeedFulSDKBridges.Add("Bugly");
                }
            }

            for (int i = 0, iMax = m_NeedFulplugins.Count; i < iMax; i++)
            {
                if (i >= plugins.Count)
                {
                    plugins.Add(m_NeedFulplugins[i]);
                }
                else if (plugins[i] != m_NeedFulplugins[i])
                {
                    plugins.Remove(m_NeedFulplugins[i]);
                    plugins.Insert(0, m_NeedFulplugins[i]);
                }
            }
            for (int i = plugins.Count - 1; i >= 0; i--)
            {
                if (!Directory.Exists(Path.GetFullPath(Application.dataPath + PackConstant.PluginAndroidSrcPath + plugins[i])))
                {
                    plugins.RemoveAt(i);
                }
            }
            if (m_PluginReorderableList == null)
            {
                m_PluginReorderableList = new DirectoryReorderableList(plugins, sourcePackPlatformAndroid.plugins, m_NeedFulplugins, Application.dataPath + PackConstant.PluginAndroidSrcPath);
            }
            else
            {
                m_PluginReorderableList.SetParams(plugins, sourcePackPlatformAndroid.plugins, m_NeedFulplugins, Application.dataPath + PackConstant.PluginAndroidSrcPath);
            }
            float height = m_PluginReorderableList.GetHeight();
            Rect totalPosition = EditorGUILayout.GetControlRect(true, height, PackGUI.styles.label);
            Rect labelPosition = new Rect(totalPosition.x + PackGUI.indent, totalPosition.y, EditorGUIUtility.labelWidth - PackGUI.indent, PackGUI.kSingleLineHeight);
            int id = GUIUtility.GetControlID(PackGUI.s_DelayedTextFieldHash, FocusType.Keyboard, labelPosition);
            EditorGUI.HandlePrefixLabel(totalPosition, labelPosition, EditorGUIUtility.TrTextContent("Android目录替换", PackConstant.PluginAndroidDestPath), id, PackGUI.styles.label);
            Rect fieldPosition = new Rect(totalPosition.x + PackGUI.indent + EditorGUIUtility.labelWidth, totalPosition.y, totalPosition.width - PackGUI.indent - EditorGUIUtility.labelWidth - 100, height);
            Rect resetPosition = new Rect(totalPosition.x + totalPosition.width - 90, totalPosition.y, 80, PackGUI.kSingleLineHeight);
            m_PluginReorderableList.DoList(fieldPosition);
            if (!ArrayUtility.ArrayEquals(sourcePackPlatformAndroid.plugins.ToArray(), plugins.ToArray()))
            {
                if (GUI.Button(resetPosition, EditorGUIUtility.TrTextContent("重置默认", string.Join(";", sourcePackPlatformAndroid.plugins)), PackGUI.styles.miniButton))
                {
                    plugins.Clear();
                    plugins.AddRange(sourcePackPlatformAndroid.plugins);
                }
            }

            for (int i = 0, iMax = m_NeedFulSDKBridges.Count; i < iMax; i++)
            {
                if (i >= sdkBridges.Count)
                {
                    sdkBridges.Add(m_NeedFulSDKBridges[i]);
                }
                else if (sdkBridges[i] != m_NeedFulSDKBridges[i])
                {
                    sdkBridges.Remove(m_NeedFulSDKBridges[i]);
                    sdkBridges.Insert(0, m_NeedFulSDKBridges[i]);
                }
            }
            for (int i = sdkBridges.Count - 1; i >= 0; i--)
            {
                if (!Directory.Exists(Path.GetFullPath(Application.dataPath + PackConstant.SDKBridgeSrcPath + sdkBridges[i])))
                {
                    sdkBridges.RemoveAt(i);
                }
            }
            if (m_SdkBridgeReorderableList == null)
            {
                m_SdkBridgeReorderableList = new DirectoryReorderableList(sdkBridges, sourcePackPlatformAndroid.sdkBridges, m_NeedFulSDKBridges, Application.dataPath + PackConstant.SDKBridgeSrcPath);
            }
            else
            {
                m_SdkBridgeReorderableList.SetParams(sdkBridges, sourcePackPlatformAndroid.sdkBridges, m_NeedFulSDKBridges, Application.dataPath + PackConstant.SDKBridgeSrcPath);
            }
            height = m_SdkBridgeReorderableList.GetHeight();
            totalPosition = EditorGUILayout.GetControlRect(true, height, PackGUI.styles.label);
            labelPosition = new Rect(totalPosition.x + PackGUI.indent, totalPosition.y, EditorGUIUtility.labelWidth - PackGUI.indent, PackGUI.kSingleLineHeight);
            id = GUIUtility.GetControlID(PackGUI.s_DelayedTextFieldHash, FocusType.Keyboard, labelPosition);
            EditorGUI.HandlePrefixLabel(totalPosition, labelPosition, EditorGUIUtility.TrTextContent("SDKBridge目录替换", PackConstant.SDKBridgeDestPath), id, PackGUI.styles.label);
            fieldPosition = new Rect(totalPosition.x + PackGUI.indent + EditorGUIUtility.labelWidth, totalPosition.y, totalPosition.width - PackGUI.indent - EditorGUIUtility.labelWidth - 100, height);
            resetPosition = new Rect(totalPosition.x + totalPosition.width - 90, totalPosition.y, 80, PackGUI.kSingleLineHeight);
            m_SdkBridgeReorderableList.DoList(fieldPosition);
            if (!ArrayUtility.ArrayEquals(sourcePackPlatformAndroid.sdkBridges.ToArray(), sdkBridges.ToArray()))
            {
                if (GUI.Button(resetPosition, EditorGUIUtility.TrTextContent("重置默认", string.Join(";", sourcePackPlatformAndroid.sdkBridges)), PackGUI.styles.miniButton))
                {
                    sdkBridges.Clear();
                    sdkBridges.AddRange(sourcePackPlatformAndroid.sdkBridges);
                }
            }

            if (plugins.Contains("Lebian"))
            {
                EditorGUILayout.Space();
                PackGUI.DrawDelayedTextField("乐变MainChId", sourcePackPlatformAndroid.leBian_MainChId, ref leBian_MainChId, true);
                PackGUI.DrawDelayedTextField("乐变ClientChId", sourcePackPlatformAndroid.leBian_ClientChId, ref leBian_ClientChId, true);
                PackGUI.DrawDelayedTextField("乐变SECID", sourcePackPlatformAndroid.leBian_SECID, ref leBian_SECID, true);
            }

            EditorGUILayout.Space();
            PackGUI.DrawSelectFileFieldWithFilters("选择KeyStore的文件", Application.dataPath + PackConstant.KeyStorePath, PackConstant.KeyStoreFilters, sourcePackPlatformAndroid.keystoreName, ref keystoreName);
            PackGUI.DrawDelayedTextField("KeystorePass", sourcePackPlatformAndroid.keystorePass, ref keystorePass, false);
            PackGUI.DrawDelayedTextField("KeyaliasName", sourcePackPlatformAndroid.keyaliasName, ref keyaliasName, false);
            PackGUI.DrawDelayedTextField("KeyaliasPass", sourcePackPlatformAndroid.keyaliasPass, ref keyaliasPass, false);
        }
    }
}