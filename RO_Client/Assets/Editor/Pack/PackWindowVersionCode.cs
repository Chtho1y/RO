using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

namespace Pack
{
    public partial class PackWindow
    {
        private string[] m_CanSelectPlatforms = new string[]
        {
        BuildTarget.Android.ToString(),
        BuildTarget.iOS.ToString(),
        BuildTarget.StandaloneWindows64.ToString(),
        };

        private string[] m_SelectedPlatforms = new string[0];
        private string[] m_SelectedPlatformsChange = new string[0];
        private Dictionary<string, PackPlatformBase> m_PackPlatformMapChange = new Dictionary<string, PackPlatformBase>();
        private VersionCode? m_GameVersionCodeMax;
        private VersionCode? m_ResVersionCodeMax;
        private VersionCode? m_GameVersionCodeMaxChange;
        private VersionCode? m_ResVersionCodeMaxChange;
        private VersionCode? m_GameVersionCodeMin;
        private VersionCode? m_ResVersionCodeMin;

        private void DrawChangeVersionGUI()
        {
            EditorGUILayout.BeginVertical();
            EditorGUILayout.BeginHorizontal();
            Rect totalPosition = EditorGUILayout.GetControlRect(false, PackGUI.kSingleLineHeight, PackGUI.styles.popup);
            var id = GUIUtility.GetControlID(PackGUI.s_MutliSelectField, FocusType.Keyboard, totalPosition);
            Vector2 size = PackGUI.styles.label.CalcSize(EditorGUIUtility.TrTempContent("选择平台"));
            float labelWidth = size.x;
            Rect labelPosition = new Rect(totalPosition.x + PackGUI.indent, totalPosition.y, labelWidth - PackGUI.indent, PackGUI.kSingleLineHeight);
            Rect fieldPosition = new Rect(totalPosition.x + labelWidth, totalPosition.y, totalPosition.width - labelWidth, totalPosition.height);
            EditorGUI.HandlePrefixLabel(labelPosition, totalPosition, EditorGUIUtility.TrTempContent("选择平台"), id, PackGUI.styles.label);
            m_SelectedPlatformsChange = MutliSelectFieldGUI.DoMutliSelectFieldShowValue(fieldPosition, id, m_CanSelectPlatforms, m_SelectedPlatformsChange, null, -1, true, PackGUI.styles.popup);
            EditorGUILayout.EndHorizontal();

            if (!ArrayUtility.ArrayEquals(m_SelectedPlatforms, m_SelectedPlatformsChange))
            {
                ClearSavePlatformVersionCodeChange();
                ArrayUtility.AddRange(ref m_SelectedPlatforms, m_SelectedPlatformsChange);
            }

            if (m_PackPlatformUniqueIds == null || m_PackPlatformUniqueIds.Length <= 0
                || m_PackPlatformMap == null || m_PackPlatformMap.Count <= 0
                || m_SelectedPlatformsChange.Length <= 0)
            {
                GUILayout.FlexibleSpace();
                EditorGUILayout.LabelField(GUIContent.none, EditorGUIUtility.TrTextContentWithIcon("暂无目标平台信息", MessageType.Warning), PackGUI.styles.helpBox);
                GUILayout.FlexibleSpace();
            }
            else
            {
                EditorGUILayout.Space();
                m_ScrollPosition = EditorGUILayout.BeginScrollView(m_ScrollPosition);
                for (int i = 0, iMax = m_PackPlatformUniqueIds.Length; i < iMax; i++)
                {
                    string channelUniqueId = m_PackPlatformUniqueIds[i];
                    if (m_PackPlatformMap.ContainsKey(channelUniqueId))
                    {
                        PackPlatformBase srcPackPlatformBase = m_PackPlatformMap[channelUniqueId];
                        if (ArrayUtility.Contains(m_SelectedPlatforms, srcPackPlatformBase.GetBuildTarget().ToString()))
                        {
                            if (!m_PackPlatformMapChange.ContainsKey(channelUniqueId))
                            {
                                m_PackPlatformMapChange.Add(channelUniqueId, (PackPlatformBase)srcPackPlatformBase.Clone());
                            }
                            PackPlatformBase packPlatformBase = m_PackPlatformMapChange[channelUniqueId];
                            packPlatformBase.DrawVersionCodeGUI(true, srcPackPlatformBase);
                            EditorGUILayout.Space();
                            if (m_GameVersionCodeMin == null || m_GameVersionCodeMin == null)
                            {
                                m_GameVersionCodeMin = srcPackPlatformBase.gameVersionCode;
                                m_GameVersionCodeMax = srcPackPlatformBase.gameVersionCode;
                            }
                            else if (srcPackPlatformBase.gameVersionCode < m_GameVersionCodeMin)
                            {
                                m_GameVersionCodeMin = srcPackPlatformBase.gameVersionCode;
                            }
                            else if (srcPackPlatformBase.gameVersionCode > m_GameVersionCodeMax)
                            {
                                m_GameVersionCodeMax = srcPackPlatformBase.gameVersionCode;
                            }
                            if (m_ResVersionCodeMin == null || m_ResVersionCodeMax == null)
                            {
                                m_ResVersionCodeMin = srcPackPlatformBase.resVersionCode;
                                m_ResVersionCodeMax = srcPackPlatformBase.resVersionCode;
                            }
                            else if (srcPackPlatformBase.resVersionCode < m_ResVersionCodeMin)
                            {
                                m_ResVersionCodeMin = srcPackPlatformBase.resVersionCode;
                            }
                            else if (srcPackPlatformBase.resVersionCode > m_ResVersionCodeMax)
                            {
                                m_ResVersionCodeMax = srcPackPlatformBase.resVersionCode;
                            }
                        }
                    }
                    else
                    {
                        if (m_PackPlatformMapChange.ContainsKey(channelUniqueId))
                        {
                            m_PackPlatformMapChange.Remove(channelUniqueId);
                        }
                    }
                }
                EditorGUILayout.EndScrollView();
                EditorGUILayout.Space();
                GUILayout.FlexibleSpace();

                labelWidth = EditorGUIUtility.labelWidth;
                EditorGUIUtility.labelWidth = 220;
                EditorGUILayout.BeginVertical(PackGUI.styles.box);
                EditorGUILayout.BeginHorizontal();
                EditorGUILayout.BeginVertical();
                EditorGUILayout.LabelField("App版本号", PackGUI.styles.boldLabel);
                EditorGUILayout.Space();
                EditorGUI.indentLevel += 1;
                PackGUI.DrawLabelField("最大App版本号", m_GameVersionCodeMax.ToString());
                PackGUI.DrawLabelField("最小App版本号", m_GameVersionCodeMin.ToString());
                // PackGUI.DrawVersionCodeField("最大App版本号", false, m_GameVersionCodeMax, ref m_GameVersionCodeMax);
                // PackGUI.DrawVersionCodeField("最小App版本号", false, m_GameVersionCodeMin, ref m_GameVersionCodeMin);
                EditorGUI.indentLevel -= 1;
                EditorGUILayout.EndVertical();
                EditorGUILayout.BeginVertical();
                EditorGUILayout.LabelField("资源版本号", PackGUI.styles.boldLabel);
                EditorGUILayout.Space();
                EditorGUI.indentLevel += 1;
                PackGUI.DrawLabelField("最大资源版本号", m_ResVersionCodeMax.ToString());
                PackGUI.DrawLabelField("最小资源版本号", m_ResVersionCodeMin.ToString());
                // PackGUI.DrawVersionCodeField("最大资源版本号", false, m_GameVersionCodeMax, ref m_GameVersionCodeMax);
                // PackGUI.DrawVersionCodeField("最小资源版本号", false, m_GameVersionCodeMin, ref m_GameVersionCodeMin);
                EditorGUI.indentLevel -= 1;
                EditorGUILayout.EndVertical();
                EditorGUILayout.EndHorizontal();
                EditorGUILayout.Space();
                if (!m_GameVersionCodeMaxChange.HasValue) m_GameVersionCodeMaxChange = m_GameVersionCodeMax;
                VersionCode versionCode = m_GameVersionCodeMaxChange.Value;
                PackGUI.DrawVersionCodeField("全部修改App版本号", false, m_GameVersionCodeMax.Value, ref versionCode);
                m_GameVersionCodeMaxChange = versionCode;
                if (!m_ResVersionCodeMaxChange.HasValue) m_ResVersionCodeMaxChange = m_ResVersionCodeMax;
                versionCode = m_ResVersionCodeMaxChange.Value;
                PackGUI.DrawVersionCodeField("全部修改资源版本号", false, m_ResVersionCodeMax.Value, ref versionCode);
                m_ResVersionCodeMaxChange = versionCode;
                EditorGUILayout.Space();
                if (GUILayout.Button("保存修改", PackGUI.styles.miniButton))
                {
                    SavePlatformVersionCodeChange(false);
                }
                EditorGUILayout.EndVertical();
                EditorGUIUtility.labelWidth = labelWidth;
                EditorGUILayout.Space();
            }

            EditorGUILayout.EndVertical();
        }

        private void ClearSavePlatformVersionCodeChange()
        {
            m_PackPlatformMapChange.Clear();
            ArrayUtility.Clear(ref m_SelectedPlatforms);
            m_GameVersionCodeMin = null;
            m_GameVersionCodeMax = null;
            m_GameVersionCodeMaxChange = null;
            m_ResVersionCodeMin = null;
            m_ResVersionCodeMax = null;
            m_ResVersionCodeMaxChange = null;
        }

        private bool SavePlatformVersionCodeChange(bool remind = true)
        {
            bool change1 = false;
            if (m_PackPlatformMapChange != null)
            {
                foreach (var item in m_PackPlatformMapChange)
                {
                    if (m_PackPlatformMap == null
                        || (m_PackPlatformMap.ContainsKey(item.Value.channelUniqueId) && !m_PackPlatformMap[item.Value.channelUniqueId].Equals(item.Value)))
                    {
                        change1 = true;
                        break;
                    }
                }
            }
            bool change2 = !m_GameVersionCodeMaxChange.Equals(m_GameVersionCodeMax);
            bool change3 = !m_ResVersionCodeMaxChange.Equals(m_ResVersionCodeMax);
            bool change4 = (change2 || change3);
            if (!change1 && !change4)
            {
                ClearSavePlatformVersionCodeChange();
                return false;
            }
            if (change1 || change4)
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
                        ClearSavePlatformVersionCodeChange();
                        return false;
                    }
                }
            }

            if (change1 && change4)
            {
                if (EditorUtility.DisplayDialog("提示", "有版本单独做了修改, 是否继续保存？", "是", "否"))
                {
                    int overlay = (EditorUtility.DisplayDialogComplex("提示", "有版本单独做了修改, 是否全局修改覆盖它？", "覆盖", "取消修改", "不覆盖"));
                    if (overlay == 1)
                    {
                        return true;
                    }
                    foreach (var item in m_PackPlatformMapChange)
                    {
                        if ((m_PackPlatformMap.ContainsKey(item.Value.channelUniqueId)))
                        {
                            if (!m_PackPlatformMap[item.Value.channelUniqueId].Equals(item.Value))
                            {
                                if (overlay == 0)
                                {
                                    if (change2)
                                        item.Value.gameVersionCode = m_GameVersionCodeMaxChange.Value;
                                    if (change3)
                                        item.Value.resVersionCode = m_ResVersionCodeMaxChange.Value;
                                }
                            }
                            else
                            {
                                if (change2)
                                    item.Value.gameVersionCode = m_GameVersionCodeMaxChange.Value;
                                if (change3)
                                    item.Value.resVersionCode = m_ResVersionCodeMaxChange.Value;
                            }
                        }
                    }
                }
                else
                {
                    return true;
                }
            }
            else if (change4)
            {
                foreach (var item in m_PackPlatformMapChange)
                {
                    if ((m_PackPlatformMap.ContainsKey(item.Value.channelUniqueId)))
                    {
                        if (change2)
                            item.Value.gameVersionCode = m_GameVersionCodeMaxChange.Value;
                        if (change3)
                            item.Value.resVersionCode = m_ResVersionCodeMaxChange.Value;
                    }
                }
            }
            foreach (var item in m_PackPlatformMapChange)
            {
                if ((m_PackPlatformMap.ContainsKey(item.Value.channelUniqueId)))
                {
                    m_PackPlatformMap[item.Value.channelUniqueId] = item.Value;
                }
            }
            SavePackPlatforms();
            ClearSavePlatformVersionCodeChange();
            return false;
        }
    }
}