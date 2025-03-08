using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using UnityEngine;
using UnityEditor;


namespace Pack
{
    public partial class PackWindow : EditorWindow
    {
        [MenuItem("AssetBundle/打包工具")]
        public static PackWindow OpenPackWindow()
        {
            var window = EditorWindow.GetWindow<PackWindow>(true, "App工具", true);
            window.minSize = new Vector2(800, 500);
            Rect position = window.position;
            float x = Mathf.Clamp(position.x, 32, Screen.currentResolution.width - 32);
            if (!Mathf.Approximately(position.x, x))
                position.x = Mathf.Clamp((Screen.currentResolution.width - position.width) * 0.5f, 32, Screen.currentResolution.width - 32);
            float y = Mathf.Clamp(position.y, 32, Screen.currentResolution.height - 32);
            if (!Mathf.Approximately(position.y, y))
                position.y = Mathf.Clamp((Screen.currentResolution.height - position.height) * 0.5f, 32, Screen.currentResolution.height - 32);
            window.position = position;
            return window;
        }

        private const string SELECT_PLAT_SAVE_KEY = "SELECT_PLAT_SAVE_KEY";

        public enum PackToolFlags
        {
            Build = 1 << 0,
            ChangeVersion = 1 << 1,
        }

        private Dictionary<string, PackPlatformBase> m_PackPlatformMap;
        private string[] m_PackPlatformNames;
        private string[] m_PackPlatformUniqueIds;

        private PackToolFlags m_PackToolFlags = PackToolFlags.Build;


        private void OnEnable()
        {
            ResetDefaultPackPlatforms();
        }

        private void OnLostFocus()
        {
            var methodInfo = typeof(EditorGUI).GetMethod("EndEditingActiveTextField", BindingFlags.Static | BindingFlags.NonPublic | BindingFlags.Public);
            methodInfo.Invoke(null, null);
        }

        private void OnDisable()
        {
            OnLostFocus();
        }

        private void OnGUI()
        {
            EditorGUILayout.BeginVertical();
            EditorGUILayout.BeginHorizontal(PackGUI.styles.toolbar);
            if (GUILayout.Toggle((m_PackToolFlags == PackToolFlags.Build), "打包", PackGUI.styles.toolbarButton))
            {
                if (m_PackToolFlags != PackToolFlags.Build)
                {
                    if (!SavePlatformSingleChange() && !SavePlatformVersionCodeChange())
                    {
                        ClearPlatformSingleChange();
                        ClearSavePlatformVersionCodeChange();
                        m_PackToolFlags = PackToolFlags.Build;
                        m_ScrollPosition = Vector2.zero;
                    }
                }
            }
            if (GUILayout.Toggle((m_PackToolFlags == PackToolFlags.ChangeVersion), "快速修改版本号", PackGUI.styles.toolbarButton))
            {
                if (m_PackToolFlags != PackToolFlags.ChangeVersion)
                {
                    if (!SavePlatformSingleChange() && !SavePlatformVersionCodeChange())
                    {
                        ClearPlatformSingleChange();
                        ClearSavePlatformVersionCodeChange();
                        m_PackToolFlags = PackToolFlags.ChangeVersion;
                        m_ScrollPosition = Vector2.zero;
                    }
                }
            }
            GUILayout.FlexibleSpace();
            if (GUILayout.Button("刷新当前配置", PackGUI.styles.toolbarButton))
            {
                if (!SavePlatformSingleChange() && !SavePlatformVersionCodeChange())
                {
                    ClearPlatformSingleChange();
                    ClearSavePlatformVersionCodeChange();
                    ResetDefaultPackPlatforms();
                }
            }
            if (GUILayout.Button("打开配置文件", PackGUI.styles.toolbarButton))
            {
                EditorUtility.OpenWithDefaultApp(Path.GetFullPath(Application.dataPath + PackConstant.PackPlatformConfigPath));
            }
            EditorGUILayout.EndHorizontal();
            EditorGUILayout.Space();
            if (m_PackToolFlags == PackToolFlags.Build)
            {
                DrawPackGUI();
            }
            else if (m_PackToolFlags == PackToolFlags.ChangeVersion)
            {
                DrawChangeVersionGUI();
            }

            EditorGUILayout.EndVertical();
        }


        private void ResetDefaultPackPlatforms()
        {
            m_PackPlatformNames = null;
            m_PackPlatformMap = null;
            m_PackPlatformUniqueIds = null;
            m_SelectPackPlatformNameIdx = -1;
            try
            {
                PackPlatforms packPlatforms = PackRun.GetConfigs(true);
                if (packPlatforms == null) return;
                List<string> packPlatformNameLs = new List<string>();
                List<string> packPlatformUniqueIdLs = new List<string>();
                m_PackPlatformMap = new Dictionary<string, PackPlatformBase>();
                if (packPlatforms != null && packPlatforms.packPlatforms != null)
                {
                    PackPlatformBase[] packPlatformBases = packPlatforms.packPlatforms;
                    Array.Sort(packPlatformBases,(x, y) =>
                    {
                        return StringComparer.InvariantCulture.Compare(x.channelUniqueId, y.channelUniqueId);
                    });
                    for (int i = 0, iMax = packPlatformBases.Length; i < iMax; i++)
                    {
                        PackPlatformBase packPlatform = (PackPlatformBase)packPlatformBases[i].Clone();
                        string channelUniqueName = packPlatform.GetChannelUniqueName();
                        string channelUniqueId = packPlatform.channelUniqueId;
                        packPlatformNameLs.Add(channelUniqueName);
                        packPlatformUniqueIdLs.Add(channelUniqueId);
                        if (m_PackPlatformMap.ContainsKey(channelUniqueId))
                        {
                            throw new Exception("存在相同的打包数据, 请检测文件内容" + PackConstant.PackPlatformConfigPath);
                        }
                        else
                        {
                            m_PackPlatformMap.Add(channelUniqueId, packPlatform);
                        }
                    }
                }
                m_PackPlatformNames = packPlatformNameLs.ToArray();
                m_PackPlatformUniqueIds = packPlatformUniqueIdLs.ToArray();
                string selectChannelUniqueId = EditorPrefs.GetString(SELECT_PLAT_SAVE_KEY);
                m_SelectPackPlatformNameIdx = ArrayUtility.FindIndex(m_PackPlatformUniqueIds, (x) => x == selectChannelUniqueId);
            }
            catch (Exception e)
            {
                Debug.LogException(e);
                m_PackPlatformNames = null;
                m_PackPlatformMap = null;
                m_PackPlatformUniqueIds = null;
            }
        }

        private void SavePackPlatforms()
        {
            if (m_PackPlatformUniqueIds == null || m_PackPlatformMap == null) return;
            List<PackPlatformBase> packPlatformLs = new List<PackPlatformBase>();
            for (int i = 0, iMax = m_PackPlatformUniqueIds.Length; i < iMax; i++)
            {
                if (m_PackPlatformMap.ContainsKey(m_PackPlatformUniqueIds[i]))
                {
                    packPlatformLs.Add(m_PackPlatformMap[m_PackPlatformUniqueIds[i]]);
                }
            }
            packPlatformLs.Sort((x, y) =>
            {
                return StringComparer.InvariantCulture.Compare(x.channelUniqueId, y.channelUniqueId);
            });
            PackPlatforms packPlatforms = new PackPlatforms();
            packPlatforms.packPlatforms = packPlatformLs.ToArray();
            PackRun.SaveConfigs(packPlatforms);
        }
    }
}