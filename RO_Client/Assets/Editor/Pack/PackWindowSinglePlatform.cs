using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

namespace Pack
{
    public partial class PackWindow
    {
        private GUIContent[] contents = new GUIContent[]
        {
            new GUIContent("Android"),
            new GUIContent("iOS"),
            new GUIContent("StandaloneWindows64"),
            new GUIContent("WeiDuanAndroid"),
        };
        
        private Type[] types = new Type[]
        {
            typeof(PackPlatformAndroid),
            typeof(PackPlatformiOS),
            typeof(PackPlatformPC),
            typeof(PackPlatformWeiDuanAndroid),
        };

        private string[] channelIds = new string[]
        {
            "10000000",
            "20000000",
            "1",
            "10000000",
        };

        private int m_SelectPackPlatformNameIdx = -1;
        private int m_SelectPackPlatformNameIdxTemp = -1;
        private Vector2 m_ScrollPosition = Vector2.zero;

        private bool m_Editable = false;
        private PackPlatformBase m_PlatformBase = null;
        private PackPlatformBase m_PlatformBaseChange = null;

        private void DrawPackGUI()
        {
            EditorGUILayout.BeginVertical();
            EditorGUILayout.Space();
            m_SelectPackPlatformNameIdxTemp = m_SelectPackPlatformNameIdx;
            Rect position = EditorGUILayout.GetControlRect(false, PackGUI.kSingleLineHeight, PackGUI.styles.popup);
            m_SelectPackPlatformNameIdxTemp = EditorGUI.Popup(position, m_SelectPackPlatformNameIdxTemp, m_PackPlatformNames, PackGUI.styles.popup);
            if (m_SelectPackPlatformNameIdx != m_SelectPackPlatformNameIdxTemp)
            {
                m_SelectPackPlatformNameIdx = m_SelectPackPlatformNameIdxTemp;
                CheckSelectPackPlatform(true);
                if (m_PlatformBase != null)
                {
                    EditorPrefs.SetString(SELECT_PLAT_SAVE_KEY, m_PlatformBase.channelUniqueId);
                }
            }
            else
            {
                CheckSelectPackPlatform(false);
            }
            bool isChanged = (m_PlatformBase != null && m_PlatformBaseChange != null && !m_PlatformBase.Equals(m_PlatformBaseChange));
            EditorGUILayout.Space();
            EditorGUILayout.BeginHorizontal();
            GUILayout.FlexibleSpace();
            if (isChanged)
            {
                PackGUI.BeginChangeGUIColor(Color.green);
                if (GUILayout.Button("保存修改", PackGUI.styles.miniButtonLeft))
                {
                    SavePlatformSingleChange(false);
                }
                PackGUI.EndChangeGUIColor();
                PackGUI.BeginChangeGUIColor(Color.red);
                if (GUILayout.Button("取消修改", PackGUI.styles.miniButtonMid))
                {
                    CheckSelectPackPlatform(true);
                }
                PackGUI.EndChangeGUIColor();
            }
            bool editableTemp = GUILayout.Toggle(m_Editable, "解锁修改", isChanged ? PackGUI.styles.miniButtonMid : PackGUI.styles.miniButtonLeft);
            if (editableTemp != m_Editable)
            {
                if (!SavePlatformSingleChange())
                {
                    m_Editable = editableTemp;
                }
            }
            position = EditorGUILayout.GetControlRect(true, PackGUI.kSingleLineHeight, PackGUI.styles.miniButtonMid, GUILayout.Width(40));
            if (GUI.Button(position, "+", PackGUI.styles.miniButtonMid))
            {
                if (!SavePlatformSingleChange())
                {
                    EditorUtility.DisplayCustomMenu(position, contents, -1, (object userData, string[] options, int selected) =>
                    {
                        PackPlatformBase packPlatformBase = null;
                        if (selected < 0 || selected >= types.Length)
                        {
                            Debug.LogError("未知平台");
                        }
                        else
                        {
                            packPlatformBase = (PackPlatformBase)(Activator.CreateInstance(types[selected], null));
                            if (packPlatformBase != null)
                            {
                                packPlatformBase.channelUniqueId = channelIds[selected];
                            }
                        }
                        // if (selected == 0)
                        //     packPlatformBase = new PackPlatformAndroid();
                        // else if (selected == 1)
                        //     packPlatformBase = new PackPlatformiOS();
                        // else if (selected == 2)
                        //     packPlatformBase = new PackPlatformPC();
                        // else
                        //     Debug.LogError("未知平台");
                        if (packPlatformBase != null)
                        {
                            string channelUniqueName = packPlatformBase.GetChannelUniqueName();
                            string channelUniqueId = packPlatformBase.channelUniqueId;
                            int index = 1;
                            if (m_PackPlatformMap == null) m_PackPlatformMap = new Dictionary<string, PackPlatformBase>();
                            if (m_PackPlatformNames == null) m_PackPlatformNames = new string[0];
                            if (m_PackPlatformUniqueIds == null) m_PackPlatformUniqueIds = new string[0];
                            while (m_PackPlatformMap.ContainsKey(channelUniqueId) || ArrayUtility.Contains(m_PackPlatformNames, channelUniqueName))
                            {
                                packPlatformBase.distributeName = packPlatformBase.distributeName + index;
                                channelUniqueName = packPlatformBase.GetChannelUniqueName();
                                channelUniqueId = channelUniqueId + index;
                                packPlatformBase.channelUniqueId = channelUniqueId;
                            }
                            ArrayUtility.Add(ref m_PackPlatformNames, channelUniqueName);
                            ArrayUtility.Add(ref m_PackPlatformUniqueIds, channelUniqueId);
                            m_PackPlatformMap.Add(channelUniqueId, packPlatformBase);
                            SavePackPlatforms();
                            ResetDefaultPackPlatforms();
                            for (int i = 0, iMax = m_PackPlatformUniqueIds.Length; i < iMax; i++)
                            {
                                if (m_PackPlatformUniqueIds[i] == channelUniqueId)
                                {
                                    m_SelectPackPlatformNameIdx = i;
                                    EditorPrefs.SetString(SELECT_PLAT_SAVE_KEY, channelUniqueId);
                                    CheckSelectPackPlatform(true);
                                    break;
                                }
                            }
                        }
                    }, null);
                }
            }
            EditorGUI.BeginDisabledGroup((m_PlatformBase == null || m_PlatformBaseChange == null));
            if (GUILayout.Button("-", PackGUI.styles.miniButtonRight, GUILayout.Width(40)))
            {
                if (!SavePlatformSingleChange())
                {
                    if (EditorUtility.DisplayDialog("提示", "是否删除当前配置", "是", "否"))
                    {
                        string channelUniqueName = m_PlatformBase.GetChannelUniqueName();
                        string channelUniqueId = m_PlatformBase.channelUniqueId;
                        ArrayUtility.Remove(ref m_PackPlatformNames, channelUniqueName);
                        ArrayUtility.Remove(ref m_PackPlatformUniqueIds, channelUniqueId);
                        m_PackPlatformMap.Remove(channelUniqueId);
                        m_PlatformBase = null;
                        m_PlatformBaseChange = null;
                        m_SelectPackPlatformNameIdx = m_SelectPackPlatformNameIdx - 1;
                        if (m_SelectPackPlatformNameIdx < 0 && m_PackPlatformNames != null && m_PackPlatformNames.Length > 0)
                        {
                            m_SelectPackPlatformNameIdx = 0;
                        }
                        if (m_PackPlatformUniqueIds != null && m_PackPlatformUniqueIds.Length > m_SelectPackPlatformNameIdx)
                        {
                            EditorPrefs.SetString(SELECT_PLAT_SAVE_KEY, m_PackPlatformUniqueIds[m_SelectPackPlatformNameIdx]);
                        }
                        else
                        {
                            EditorPrefs.DeleteKey(SELECT_PLAT_SAVE_KEY);
                        }

                        CheckSelectPackPlatform(true);
                        SavePackPlatforms();
                    }
                }
            }
            EditorGUI.EndDisabledGroup();
            EditorGUILayout.EndHorizontal();

            if (m_PlatformBase != null && m_PlatformBaseChange != null)
            {
                EditorGUILayout.BeginVertical();
                EditorGUILayout.Space();
                m_ScrollPosition = EditorGUILayout.BeginScrollView(m_ScrollPosition);
                m_PlatformBaseChange.DrawGUI(m_Editable, m_PlatformBase);
                EditorGUILayout.EndScrollView();
                EditorGUILayout.EndVertical();
            }
            else
            {
                GUILayout.FlexibleSpace();
                EditorGUILayout.LabelField(GUIContent.none, EditorGUIUtility.TrTextContentWithIcon("暂无目标平台信息", MessageType.Warning), PackGUI.styles.helpBox);
                GUILayout.FlexibleSpace();
            }

            EditorGUI.BeginDisabledGroup((m_PlatformBase == null || m_PlatformBaseChange == null));
            EditorGUILayout.Space();
            EditorGUILayout.Space();
            EditorGUILayout.BeginVertical(PackGUI.styles.box);
            EditorGUILayout.Space();
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("当前已切换的平台信息", PackGUI.styles.boldLabel);
            EditorGUI.indentLevel += 1;
            if (m_PackPlatformMap == null || !m_PackPlatformMap.ContainsKey(PackRun.GetCurChannelUniqueId()))
                EditorGUILayout.LabelField("无", PackGUI.styles.label);
            else
                EditorGUILayout.LabelField(m_PackPlatformMap[PackRun.GetCurChannelUniqueId()].GetChannelUniqueName(), PackGUI.styles.label);
            EditorGUI.indentLevel -= 1;
            EditorGUILayout.Space();
            EditorGUILayout.Space();
            EditorGUILayout.BeginHorizontal();
            EditorGUI.BeginDisabledGroup(m_PlatformBase == null || !m_PlatformBase.CanChangePlatform());
            if (GUILayout.Button("切换平台", PackGUI.styles.miniButton))
            {
                if (EditorUtility.DisplayDialog("提示", "确认切换平台?", "是", "否"))
                {
                    if (!SavePlatformSingleChange())
                    {
                        try
                        {
                            PackRun.ChangePlatform(m_PlatformBase);
                            EditorUtility.DisplayDialog("提示", "切换成功", "好的");
                        }
                        catch (System.Exception e)
                        {
                            Debug.LogException(e);
                            EditorUtility.DisplayDialog("提示", "切换失败", "好的");
                        }
                    }
                }
                GUIUtility.ExitGUI();
            }
            EditorGUI.EndDisabledGroup();
            if (GUILayout.Button("清除当前切换的平台", PackGUI.styles.miniButton))
            {
                if (EditorUtility.DisplayDialog("提示", "确认清除当前切换的平台?", "是", "否"))
                {
                    if (!SavePlatformSingleChange())
                    {
                        try
                        {
                            PackRun.ClearBuildAndResetDefault();
                            EditorUtility.DisplayDialog("提示", "清除成功", "好的");
                        }
                        catch (System.Exception e)
                        {
                            Debug.LogException(e);
                            EditorUtility.DisplayDialog("提示", "清除失败", "好的");
                        }
                    }
                }
                GUIUtility.ExitGUI();
            }
            EditorGUI.BeginDisabledGroup(m_PlatformBase == null || !m_PlatformBase.CanBuildAssetBundles());
            if (GUILayout.Button("只打包AB", PackGUI.styles.miniButton))
            {
                if (EditorUtility.DisplayDialog("提示", "确认打包AB?", "是", "否"))
                {
                    if (!SavePlatformSingleChange())
                    {
                        try
                        {
                            PackRun.BuildAB(m_PlatformBase);
                            EditorUtility.DisplayDialog("提示", "打包AB成功", "好的");
                        }
                        catch (System.Exception e)
                        {
                            Debug.LogException(e);
                            EditorUtility.DisplayDialog("提示", "打包AB失败", "好的");
                        }
                    }
                }
                GUIUtility.ExitGUI();
            }
            EditorGUI.EndDisabledGroup();
            EditorGUI.BeginDisabledGroup(m_PlatformBase == null || !m_PlatformBase.CanBuildApp());
            if (GUILayout.Button("打包App", PackGUI.styles.miniButton))
            {
                if (EditorUtility.DisplayDialog("提示", "确认打包App?", "是", "否"))
                {
                    if (!SavePlatformSingleChange())
                    {
                        try
                        {
                            PackRun.BuildApp(m_PlatformBase);
                            EditorUtility.DisplayDialog("提示", "打包App成功", "好的");
                        }
                        catch (System.Exception e)
                        {
                            Debug.LogException(e);
                            EditorUtility.DisplayDialog("提示", "打包App失败", "好的");
                        }
                    }
                }
                GUIUtility.ExitGUI();
            }
            EditorGUI.EndDisabledGroup();
            EditorGUILayout.EndHorizontal();
            EditorGUILayout.Space();
            EditorGUILayout.Space();
            EditorGUILayout.EndVertical();
            EditorGUI.EndDisabledGroup();

            EditorGUILayout.EndVertical();
            PackGUI.EndAllChangeGUIColor();
            PackGUI.EndAllChangeGUIBgColor();
        }

        private void CheckSelectPackPlatform(bool forceUpdate)
        {
            if (!forceUpdate && m_PlatformBase != null && m_PlatformBaseChange != null) return;
            if (m_SelectPackPlatformNameIdx >= 0 && m_SelectPackPlatformNameIdx < m_PackPlatformUniqueIds.Length)
            {
                string channelUniqueId = m_PackPlatformUniqueIds[m_SelectPackPlatformNameIdx];
                if (m_PackPlatformMap != null)
                {
                    PackPlatformBase newPlatformBase = m_PackPlatformMap[channelUniqueId];
                    if (newPlatformBase != null)
                    {
                        if (m_PlatformBase != null && !m_PlatformBase.Equals(newPlatformBase))
                        {
                            if (SavePlatformSingleChange())
                            {
                                return;
                            }
                        }
                        m_PlatformBase = newPlatformBase;
                        if (m_PlatformBase != null)
                            m_PlatformBaseChange = (PackPlatformBase)m_PlatformBase.Clone();
                        return;
                    }
                }
            }
            ClearPlatformSingleChange();
        }

        private void ClearPlatformSingleChange()
        {
            m_PlatformBase = null;
            m_PlatformBaseChange = null;
        }

        private bool SavePlatformSingleChange(bool remind = true)
        {
            if (m_PlatformBase != null && m_PlatformBaseChange != null)
            {
                if (!m_PlatformBase.Equals(m_PlatformBaseChange))
                {
                    if (remind)
                    {
                        int overlay = (EditorUtility.DisplayDialogComplex("提示", "是否保存当前修改", "是", "再看看", "否"));
                        if (overlay == 1)
                        {
                            return true;
                        }
                        if (overlay == 2)
                        {
                            m_PlatformBaseChange = (PackPlatformBase)m_PlatformBase.Clone();
                            return false;
                        }
                    }
                    string channelUniqueId = m_PlatformBase.channelUniqueId;
                    string newChannelUniqueId = m_PlatformBaseChange.channelUniqueId;
                    string channelUniqueName = m_PlatformBase.GetChannelUniqueName();
                    string newChannelUniqueName = m_PlatformBaseChange.GetChannelUniqueName();
                    if (channelUniqueName != newChannelUniqueName && ArrayUtility.Contains(m_PackPlatformNames, newChannelUniqueName))
                    {
                        if (EditorUtility.DisplayDialog("提示", string.Format("名字重复 : {0}, 继续修改？", newChannelUniqueName), "修改", "不保存"))
                        {
                            return true;
                        }
                        else
                        {
                            m_PlatformBaseChange = (PackPlatformBase)m_PlatformBase.Clone();
                            return false;
                        }
                    }
                    if (channelUniqueId != newChannelUniqueId && m_PackPlatformMap.ContainsKey(newChannelUniqueId))
                    {
                        if (EditorUtility.DisplayDialog("提示", string.Format("唯一名字(工具打包时使用名字) : {0}, 继续修改？", newChannelUniqueId), "修改", "不保存"))
                        {
                            return true;
                        }
                        else
                        {
                            m_PlatformBaseChange = (PackPlatformBase)m_PlatformBase.Clone();
                            return false;
                        }
                    }
                    EditorPrefs.SetString(SELECT_PLAT_SAVE_KEY, newChannelUniqueId);
                    int index = ArrayUtility.FindIndex(m_PackPlatformUniqueIds, (x) => x == channelUniqueId);
                    m_PackPlatformNames[index] = newChannelUniqueName;
                    m_PackPlatformUniqueIds[index] = newChannelUniqueId;
                    m_PackPlatformMap.Remove(channelUniqueId);
                    m_PackPlatformMap.Add(newChannelUniqueId, m_PlatformBaseChange);
                    SavePackPlatforms();
                    m_PlatformBase = m_PlatformBaseChange;
                    m_PlatformBaseChange = (PackPlatformBase)m_PlatformBaseChange.Clone();
                }
            }
            return false;
        }
    }
}