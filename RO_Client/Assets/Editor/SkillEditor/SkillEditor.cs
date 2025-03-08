using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System;
using System.IO;
using OfficeOpenXml;
using Mono.Xml;
using System.Security;

public class SkillEditor : EditorWindow
{
    static string[] s_skilltrigerTypeStr = new string[] { "普通攻击", "顺发技能", "免吟唱持续施法", "吟唱直接施法", "吟唱持续施法", "被动技能" };
    static string[] s_professionTypeStr = new string[] { "初心者", "剑士", "盗贼", "弓手", "法师", "手持" };
    static string[] s_damageTypeStr = new string[] { "无", " 物理伤害", "魔法伤害", "真实伤害" };
    static string[] s_targetSelectRuleStr = new string[] { "无", "敌方单体", "敌方前排", "敌方后排", "敌方全体", "自己", "生命最低的队友",
                                                            "本方全体", "随机一个敌方目标", "随机一个敌方后排目标", "敌方整排,优先前排目标",
                                                            "敌方整排,优先后排目标", "敌方单体,优先前排", "敌方单体,优先后排", "我方整排,优先前排",
                                                            "我方整排,优先后排","我方减益buff最多的单位","我方生命值百分比最低的单位"};

    static string[] s_genderStr = new string[] { "无", "女", "男" };
    static int[] s_genderInt = new int[] { 0, 1, 2 };

    static string s_skillExcelFileName = "SkillCfg.xlsx";
    static string s_buffExcelFileName = "BuffCfg.xlsx";
    static string s_effectExcelFileName = "EffectCfg.xlsx";

    static string s_eventtemplate_XMLFileName = "EventTemplate.xml";
    public const string c_ExcelFileExtension = "xlsx";
    const string c_XmlFileExtension = "xml";


    static string[] s_valTypes = new string[] { "string", "int", "float" };

    private SkillAsset currentSkillAsset = null;

    static List<BuffDataAsset> m_buffs = new List<BuffDataAsset>();
    public static List<EffectAsset> m_effects = new List<EffectAsset>();
    public static List<string> m_effectIds = new List<string>();

    static List<string> m_icons = new List<string>();
    static List<SkillAsset> m_Skills = new List<SkillAsset>();
    static List<SkillAsset> m_miniLevelSkills = new List<SkillAsset>();
    static List<ActionEventParamEditor> s_template_events = new List<ActionEventParamEditor>();
    static Dictionary<int, ActionEventDataEditor> s_ActionEventDic = new Dictionary<int, ActionEventDataEditor>();
    //static Dictionary<string, Dictionary<int, ActionEventDataEditor>> s_ActionEventDic = new Dictionary<string, Dictionary<int, ActionEventDataEditor>>();

    bool bExtendSkillTree = true;
    bool bExtendSkillBaseFold = true;

    GUIStyle contentStyle = null;
    GUIStyle lblStyle = null;
    GUIStyle paramStyle = null;
    GUIStyle leftParamStyle = null;
    GUIStyle selectedItemStyle = null;
    GUIStyle selectedEventTemplateStyle = null;

    //[MenuItem("Skill_Tool/Skill Editor")]
    public static void ShowSkillTreeViewPanel()
    {
        ReadEventTemplate();
        GetEffectList();
        GetSkillIcons();

        GetFrameEventFiles();
        GetBuffs();
        GetSkillData();

        RefreshPanel();
    }

    static SkillEditor m_instance = null;
    public static SkillEditor GetPanel()
    {
        if (null == m_instance)
        {
            m_instance = EditorWindow.GetWindow<SkillEditor>(false, "技能编辑器", false);
        }
        return m_instance;
    }

    #region 读取配置模块

    static void GetFrameEventFiles()
    {
        s_ActionEventDic.Clear();
        string[] fileList = FileUtils.TraverseAllFiles(Constants.XmlConfig, "*.xml");
        for (int idx = 0; idx < fileList.Length; idx++)
        {
            if (!fileList[idx].Contains("buff_")) continue;

            ReadFrameEvent(fileList[idx]);
        }
    }

    static void ReadFrameEvent(string fileName)
    {
        TextAsset ta = AssetDatabase.LoadAssetAtPath(fileName, typeof(TextAsset)) as TextAsset;


        SecurityParser doc = new SecurityParser();
        try
        {
            doc.LoadXml(ta.text);
        }
        catch (System.Exception e)
        {
            DebugHelper.Assert(false, "Load Frame Event, exception = {1}", e.Message);
            return;
        }

        SecurityElement root = doc.SelectSingleNode("FrameEvent");
        if (root == null || root.Children == null) return;

        for (int idx = 0; idx < root.Children.Count; idx++)
        {
            var buffNode = root.Children[idx] as SecurityElement;
            string idStr = buffNode.Attribute("id");
            int id = int.Parse(idStr);
            string frameStr = buffNode.Attribute("endFrame");
            int frame = int.Parse(frameStr);
            string name = buffNode.Attribute("name");
            int gender = 2;
            if(!int.TryParse(buffNode.Attribute("gender"),out gender))
            {
                gender = 2;
            }

            ActionEventDataEditor aed = new ActionEventDataEditor(id, frame, name, gender);
            if (buffNode.Children != null)
            {
                for (int jdx = 0; jdx < buffNode.Children.Count; jdx++)
                {
                    var eventNode = buffNode.Children[jdx] as SecurityElement;

                    ActionEventParamEditor aep = new ActionEventParamEditor();
                    int.TryParse(eventNode.Attribute("startFrame"), out aep.startFrame);
                    int.TryParse(eventNode.Attribute("endFrame"), out aep.endFrame);
                    int.TryParse(eventNode.Attribute("type"), out aep.eventType);
                    bool.TryParse(eventNode.Attribute("affectBySing"), out aep.bAffectBySing);
                    aep.desc = eventNode.Attribute("desc");

                    aep.frameParams = new List<FrameEventParamEditor>();
                    if (eventNode.Children != null)
                    {
                        for (int kdx = 0; kdx < eventNode.Children.Count; kdx++)
                        {
                            var paramNode = eventNode.Children[kdx] as SecurityElement;

                            FrameEventParamEditor param = new FrameEventParamEditor();
                            param.name = paramNode.Attribute("name");
                            param.val = paramNode.Attribute("value");
                            param.valType = paramNode.Attribute("valueType");
                            if (string.IsNullOrEmpty(param.valType))
                                param.valType = paramNode.Attribute("valType");

                            param.valTypeIdx = GetValueTypeIndex(param.valType);
                            if(param.name == "effect" || param.name == "hiteffect")
                            {
                                int effectId = 0;
                                if(int.TryParse(param.val,out effectId))
                                {
                                    param.valIdx = GetEffectIdx(effectId);
                                }
                            }

                            aep.frameParams.Add(param);
                        }
                    }

                    aed.AddEvent(aep);
                }
            }

            int uniqueId = id * 10 + gender;
            if (!s_ActionEventDic.ContainsKey(uniqueId))
            { 
                s_ActionEventDic.Add(uniqueId, aed);
            }
            else
            {
                Debug.LogError("其他的frameevent配置一样的buff event");
            }
        }

    }

    static void ReadEventTemplate()
    {
        s_template_events.Clear();
        try
        {
            string filePath = EditorPrefs.GetString(s_eventtemplate_XMLFileName, string.Empty);
            if (!IsVaildGlobalPath(filePath, s_eventtemplate_XMLFileName))
            {
                string content = string.Concat("请选择", s_eventtemplate_XMLFileName, "文件");
                string[] filters = new string[2]
                {
                    "Xml File", c_XmlFileExtension
                };
                filePath = EditorUtility.OpenFilePanelWithFilters(content, Application.dataPath, filters);
                if (!IsVaildGlobalPath(filePath, s_eventtemplate_XMLFileName))
                {
                    EditorUtility.DisplayDialog("错误", string.Concat("未选择", s_eventtemplate_XMLFileName, "文件"), "确定");
                    return;
                }
                EditorPrefs.SetString(s_eventtemplate_XMLFileName, filePath);
            }

            FileStream stream = new FileStream(filePath, FileMode.Open);
            byte[] buffData = new byte[stream.Length];
            stream.Read(buffData,0,(int)stream.Length);
            stream.Close();

            string str =System.Text.Encoding.Default.GetString(buffData, 0, buffData.Length);

            SecurityParser doc = new SecurityParser();
            try
            {
                doc.LoadXml(str);
            }
            catch (System.Exception e)
            {
                DebugHelper.Assert(false, "Load Frame Event, exception = {1}", e.Message);
                return;
            }

            SecurityElement root = doc.SelectSingleNode("events");
            if (root == null || root.Children == null) return;

            for (int idx = 0; idx < root.Children.Count; idx++)
            {
                var eventNode = root.Children[idx] as SecurityElement;

                ActionEventParamEditor aep = new ActionEventParamEditor();
                int.TryParse(eventNode.Attribute("startFrame"), out aep.startFrame);
                int.TryParse(eventNode.Attribute("endFrame"), out aep.endFrame);
                int.TryParse(eventNode.Attribute("type"), out aep.eventType);
                bool.TryParse(eventNode.Attribute("affectBySing"), out aep.bAffectBySing);
                aep.desc = eventNode.Attribute("desc");

                aep.frameParams = new List<FrameEventParamEditor>();
                if (eventNode.Children != null)
                {
                    for (int kdx = 0; kdx < eventNode.Children.Count; kdx++)
                    {
                        var paramNode = eventNode.Children[kdx] as SecurityElement;

                        FrameEventParamEditor param = new FrameEventParamEditor();
                        param.name = paramNode.Attribute("name");
                        param.val = paramNode.Attribute("value");
                        param.valType = paramNode.Attribute("valueType");
                        param.valTypeIdx = GetValueTypeIndex(param.valType);

                        aep.frameParams.Add(param);
                    }
                }

                s_template_events.Add(aep);
            }
        }
        catch (Exception e)
        {
            Debug.LogException(e);
            EditorUtility.DisplayDialog("错误", string.Concat("无法读取", s_eventtemplate_XMLFileName, "文件数据"), "确定");
        }
        Debug.Log("template cnt:" + s_template_events.Count);
    }

    public static void RefreshPanel()
    {
        SkillEditor panel = GetPanel();
        panel.Repaint();
        panel.ResetData();
    }

    static void GetEffectList()
    {
        m_effects.Clear();
        m_effectIds.Clear();
        try
        {
            string filePath = EditorPrefs.GetString(s_effectExcelFileName, string.Empty);
            if (!IsVaildGlobalPath(filePath, s_effectExcelFileName))
            {
                string content = string.Concat("请选择", s_effectExcelFileName, "文件");
                string[] filters = new string[2]
                {
                    "Excel File", c_ExcelFileExtension
                };
                filePath = EditorUtility.OpenFilePanelWithFilters(content, Application.dataPath, filters);
                if (!IsVaildGlobalPath(filePath, s_effectExcelFileName))
                {
                    EditorUtility.DisplayDialog("错误", string.Concat("未选择", s_effectExcelFileName, "文件"), "确定");
                    return;
                }
                EditorPrefs.SetString(s_effectExcelFileName, filePath);
            }

            FileInfo fileInfo = new FileInfo(filePath);     
            {
                using (var excelPackage = new ExcelPackage(fileInfo))
                {
                    var sheets = excelPackage.Workbook.Worksheets;
                    var sheet = sheets[1];
                    int rowIndex = 4;
                    while (!string.IsNullOrEmpty(sheet.GetValue<string>(rowIndex, 1)))
                    {
                        EffectAsset effect = EffectAsset.CreateEffectAsset(sheet, rowIndex);
                        m_effects.Add(effect);
                        m_effectIds.Add(effect.id.ToString());
                        rowIndex += 1;
                    }
                }
            }
        }
        catch (Exception e)
        {
            Debug.LogException(e);
            EditorUtility.DisplayDialog("错误", string.Concat("无法读取", s_effectExcelFileName, "文件数据"), "确定");
        }
        Debug.Log("effect cnt:" + m_effects.Count);
    }

   

    static void GetBuffs()
    {
        m_buffs.Clear();
        try
        {
            string filePath = EditorPrefs.GetString(s_buffExcelFileName, string.Empty);
            if (!IsVaildGlobalPath(filePath, s_buffExcelFileName))
            {
                string content = string.Concat("请选择", s_buffExcelFileName, "文件");
                string[] filters = new string[2]
                {
                    "Excel File", c_ExcelFileExtension
                };
                filePath = EditorUtility.OpenFilePanelWithFilters(content, Application.dataPath, filters);
                if (!IsVaildGlobalPath(filePath, s_buffExcelFileName))
                {
                    EditorUtility.DisplayDialog("错误", string.Concat("未选择", s_buffExcelFileName, "文件"), "确定");
                    return;
                }
                EditorPrefs.SetString(s_buffExcelFileName, filePath);
            }

            FileInfo fileInfo = new FileInfo(filePath);
            {
                using (var excelPackage = new ExcelPackage(fileInfo))
                {
                    var sheets = excelPackage.Workbook.Worksheets;
                    var sheet = sheets[1];
                    int rowIndex = 4;
                    while (!string.IsNullOrEmpty(sheet.GetValue<string>(rowIndex, 1)))
                    {
                        BuffDataAsset buff = BuffDataAsset.CreateBuffAsset(sheet, rowIndex);
                        buff.actionEventData = GetActionEventData(buff.id);
                        buff.femaleActionEventData = GetActionEventData(buff.id, 1);
                        m_buffs.Add(buff);
                        rowIndex += 1;
                    }
                }
            }
        }
        catch (Exception e)
        {
            Debug.LogException(e);
            EditorUtility.DisplayDialog("错误", string.Concat("无法读取", s_buffExcelFileName, "文件数据"), "确定");
        }
        Debug.Log("buff cnt:" + m_buffs.Count);

    }

    static void GetSkillData()
    {
        m_Skills.Clear();
        m_miniLevelSkills.Clear();
        try
        {
            string filePath = EditorPrefs.GetString(s_skillExcelFileName, string.Empty);
            if (!IsVaildGlobalPath(filePath, s_skillExcelFileName))
            {
                string content = string.Concat("请选择", s_skillExcelFileName, "文件");
                string[] filters = new string[2]
                {
                    "Excel File", c_ExcelFileExtension
                };
                filePath = EditorUtility.OpenFilePanelWithFilters(content, Application.dataPath, filters);
                if (!IsVaildGlobalPath(filePath, s_skillExcelFileName))
                {
                    EditorUtility.DisplayDialog("错误", string.Concat("未选择", s_skillExcelFileName, "文件"), "确定");
                    return;
                }
                EditorPrefs.SetString(s_skillExcelFileName, filePath);
            }

            FileInfo fileInfo = new FileInfo(filePath);
            // using (var fs = new FileStream(filePath, FileMode.Open))
            {
                using (var excelPackage = new ExcelPackage(fileInfo))
                {
                    var sheets = excelPackage.Workbook.Worksheets;
                    var sheet = sheets[1];
                    int rowIndex = 4;
                    while (!string.IsNullOrEmpty(sheet.GetValue<string>(rowIndex, 1)))
                    {
                        SkillAsset skill = SkillAsset.CreateSkillAsset(sheet, rowIndex);
                        if(skill.buffIdList!=null)
                        {
                            for(int sIdx = 0; sIdx < skill.buffIdList.Count;sIdx++)
                            {
                                BuffDataAsset buffData = GetBuffAsset(skill.buffIdList[sIdx]);
                                if(buffData == null)
                                {
                                    buffData = new BuffDataAsset(skill.buffIdList[sIdx]);
                                }
                                skill.AddNewBuff(buffData);
                            }
                        }
                        skill.iconIdx = GetIconIdx(skill.skillIcon);
                        m_Skills.Add(skill);
                        if (!ExistSkill(skill.skillId))
                        {
                            m_miniLevelSkills.Add(skill);
                        }
                        rowIndex += 1;
                    }
                }
            }
        }
        catch (Exception e)
        {
            Debug.LogException(e);
            EditorUtility.DisplayDialog("错误", string.Concat("无法读取", s_skillExcelFileName, "文件数据"), "确定");
        }
        Debug.Log("skill cnt:" + m_Skills.Count);
    }

    static bool ExistSkill(int skillId)
    {
        for (int idx = 0; idx < m_miniLevelSkills.Count;idx++)
        {
            if (m_miniLevelSkills[idx].skillId == skillId)
                return true;
        }
        return false;
    }

    public static bool IsVaildGlobalPath(string path,string fileName)
    {
        return (!string.IsNullOrEmpty(path)
                && File.Exists(path)
                && Path.GetFileName(path) == fileName);
    }

    static void GetSkillIcons()
    {
        m_icons.Clear();

        string path = Constants.IconDir + "/Skills";
        string[] fileList = FileUtils.TraverseAllFiles(path, "*.png");
        for(int idx =0; idx < fileList.Length;idx++)
        {
            string iconName = fileList[idx];
            string icon = FileUtils.RemoveExtension(FileUtils.RemoveParent(path, iconName));
            m_icons.Add(icon);
        }

        Debug.Log("icon cnt:" + m_icons.Count);
    }
    #endregion

    private void OnEnable()
    {
        if (contentStyle == null) { 
            contentStyle = new GUIStyle();
            contentStyle.fontSize = 12;
            contentStyle.alignment = TextAnchor.MiddleRight;
            contentStyle.normal.textColor = Color.green;
        }

        if(lblStyle == null)
        {
            lblStyle = new GUIStyle();
            lblStyle.fontSize = 40;
            lblStyle.alignment = TextAnchor.MiddleCenter;
            lblStyle.fontStyle = FontStyle.Bold;
        }

        if(paramStyle == null)
        {
            paramStyle = new GUIStyle();
            paramStyle.fontSize = 12;
            paramStyle.alignment = TextAnchor.MiddleRight;
            paramStyle.normal.textColor = Color.red;
        }

        if(leftParamStyle == null)
        {
            leftParamStyle = new GUIStyle();
            leftParamStyle.fontSize = 12;
            leftParamStyle.alignment = TextAnchor.MiddleLeft;
            leftParamStyle.normal.textColor = Color.white;
        }

        if (selectedItemStyle == null)
        {
            selectedItemStyle = new GUIStyle();
            selectedItemStyle.fontSize = 20;
            selectedItemStyle.alignment = TextAnchor.MiddleLeft;
            selectedItemStyle.normal.textColor = Color.green;
        }

        if(selectedEventTemplateStyle == null)
        {
            selectedEventTemplateStyle = new GUIStyle();
            selectedEventTemplateStyle.fontSize = 20;
            selectedEventTemplateStyle.alignment = TextAnchor.MiddleLeft;
            selectedEventTemplateStyle.normal.textColor = Color.red;
        }
    }

    private void OnGUI()
    {
        EditorGUILayout.BeginHorizontal();
        DrawSkillTree();


        EditorGUILayout.BeginVertical();
        DrawSpace(4);
        ShowOpPnl();

        DrawSpace(1);
        DrawSkillPnl();
        EditorGUILayout.EndVertical();

        drawEventTemplatePnl();
        EditorGUILayout.EndHorizontal();

        DrawSpace(6);
    }

    void DrawSpace(int cnt)
    {
        for(int idx =0; idx < cnt;idx++)
            EditorGUILayout.Space();
    }

    void ShowOpPnl()
    {
        EditorGUILayout.BeginHorizontal();

        if(GUILayout.Button("新增技能",GUILayout.Width(100)))
        {
            AddNewSkill();
        }

        if (GUILayout.Button("删除当前", GUILayout.Width(100)))
        {
            RemoveCurSkill();
        }

        if(GUILayout.Button("应用修改", GUILayout.Width(100)))
        {
            ApplyCurChange();
        }

        if(GUILayout.Button("撤销修改", GUILayout.Width(100)))
        {
            CancelCurChange();
        }

        if(GUILayout.Button("保存到文件",GUILayout.Width(100)))
        {
            if(SaveData())
            {
                EditorUtility.DisplayDialog("提示", "保存成功 请关闭!!", "确定");
            }
        }

        EditorGUILayout.EndHorizontal();
    }

    void SetCurrentEditSkill(int idx)
    {
        curSkillIdx = idx;
        if (curSkillIdx >= 0 && curSkillIdx < m_miniLevelSkills.Count)
        {
            if (currentSkillAsset == null)
            {
                currentSkillAsset = new SkillAsset();
            }
            currentSkillAsset.Copy(m_miniLevelSkills[idx]);
        }
        else
        {
            currentSkillAsset = null;
        }
    }

    void AddNewSkill()
    {
        SkillAsset newSkill = new SkillAsset();
        m_Skills.Add(newSkill);
        m_miniLevelSkills.Add(newSkill);
        _scrollPos.y = 3500;

        SetCurrentEditSkill(m_miniLevelSkills.Count - 1);
    }

    void RemoveCurSkill()
    {
        if (curSkillIdx < 0 || curSkillIdx >= m_miniLevelSkills.Count) return;

        RemoveSkillById(m_miniLevelSkills[curSkillIdx].skillId);

        m_miniLevelSkills.RemoveAt(curSkillIdx);
        if (curSkillIdx >= m_miniLevelSkills.Count)
        {
            SetCurrentEditSkill(m_miniLevelSkills.Count - 1);
        }
        else
        {
            SetCurrentEditSkill(curSkillIdx);
        }
    }

    void RemoveSkillById(int skillId)
    {
        for(int idx = m_Skills.Count -1; idx >= 0; idx--)
        {
            if(m_Skills[idx].skillId == skillId)
            {
                m_Skills.RemoveAt(idx);
            }
        }
    }

    void CancelCurChange()
    {
        if (curSkillIdx < 0 || curSkillIdx >= m_miniLevelSkills.Count) return;

        currentSkillAsset.Copy(m_miniLevelSkills[curSkillIdx]);
        currentSkillAsset.bAddNewBuff = false;
    }

    public void ApplyCurChange()
    {
        if (curSkillIdx < 0 || curSkillIdx >= m_miniLevelSkills.Count) return;

        m_miniLevelSkills[curSkillIdx].Apply(currentSkillAsset);
        currentSkillAsset.bAddNewBuff = false;
    }

    bool ExistBuff(int buffId)
    {
        for(int idx =0; idx < m_buffs.Count;idx++)
        {
            if (m_buffs[idx].id == buffId)
                return true;
        }
        return false;
    }
    
    int GetBuffIndex(int buffId)
    {
        for (int idx = 0; idx < m_buffs.Count; idx++)
        {
            if (m_buffs[idx].id == buffId)
                return idx;
        }
        return -1;
    }

    public bool SaveData()
    {
        return SaveBuffDataToExcel() && SaveSkillDataToExcel();
    }

    public bool SaveBuffDataToExcel()
    {
        bool success = true;
        try
        {
            string filePath = EditorPrefs.GetString(s_buffExcelFileName, string.Empty);
            FileInfo fileInfo = new FileInfo(filePath);
            using (var excelPackage = new ExcelPackage(fileInfo))
            {
                var sheets = excelPackage.Workbook.Worksheets;
                var sheet = sheets[1];
                int rowIndex = 4;
                for (int idx = 0; idx < m_buffs.Count; idx++)
                {
                    m_buffs[idx].SaveAssetToExcel(ref sheet, rowIndex);
                    rowIndex += 1;
                }
                excelPackage.SaveAs(fileInfo);
            }
        }
        catch (Exception e)
        {
            Debug.LogException(e);
            EditorUtility.DisplayDialog("错误", string.Concat("有其它程序在使用该文件", s_buffExcelFileName, ", 请关闭"), "确定");
            success = false;
        }
        return success;
    }

    public bool SaveSkillDataToExcel()
    {
        bool success = true;
        try
        {
            string filePath = EditorPrefs.GetString(s_skillExcelFileName, string.Empty);
            FileInfo fileInfo = new FileInfo(filePath);
            using (var excelPackage = new ExcelPackage(fileInfo))
            {
                var sheets = excelPackage.Workbook.Worksheets;
                var sheet = sheets[1];
                int rowIndex = 4;
                for (int idx = 0; idx < m_Skills.Count; idx++)
                {
                    m_Skills[idx].SaveAssetToExcel(ref sheet, rowIndex);
                    rowIndex += 1;
                }
                excelPackage.SaveAs(fileInfo);
            }
        }
        catch (Exception e)
        {
            Debug.LogException(e);
            EditorUtility.DisplayDialog("错误", string.Concat("有其它程序在使用该文件", s_skillExcelFileName, ", 请关闭"), "确定");
            success = false;
        }
        return success;
    }

    #region 显示技能模块
    private Vector2 _scrollPos;
    int curSkillIdx = -1;
    void DrawSkillTree()
    {
        EditorGUILayout.BeginVertical(GUILayout.Width(200));
        bExtendSkillTree = EditorGUILayout.Foldout(bExtendSkillTree, "技能列表");
        if(bExtendSkillTree)
        {
            if(m_miniLevelSkills.Count > 0)
            {
                _scrollPos = EditorGUILayout.BeginScrollView(_scrollPos, false, false, GUILayout.Width(200));
                EditorGUI.indentLevel += 1;
                for (int idx = 0; idx < m_miniLevelSkills.Count; idx++)
                {
                    if (curSkillIdx == idx)
                    {
                        EditorGUILayout.Foldout(false, m_miniLevelSkills[idx].skillId.ToString(), true, selectedItemStyle);
                    }
                    else
                    {
                        bool flag = EditorGUILayout.Foldout(false, m_miniLevelSkills[idx].skillId.ToString(), true);
                        if (flag)
                        {
                            SetCurrentEditSkill(idx);
                        }
                    }
                }
                EditorGUI.indentLevel -= 1;
                EditorGUILayout.EndScrollView();
            }
            else
            {
                DrawSpace(20);
                if(GUILayout.Button("加载技能数据",GUILayout.Width(100),GUILayout.Height(60)))
                {
                    ReadEventTemplate();
                    GetSkillIcons();
                    GetFrameEventFiles();
                    GetEffectList();
                    GetBuffs();
                    GetSkillData();
                }
            }
        }
        EditorGUILayout.EndVertical();
    }

    Vector2 _templateScrollPos = Vector2.zero;
    ActionEventParamEditor curSelectedEventTemplate = null;
    int curEventTemplateIdx = -1;
    void drawEventTemplatePnl()
    {
        if (currentSkillAsset == null) return;

        if (s_template_events.Count > 0)
        {
            EditorGUILayout.BeginVertical(GUILayout.Width(200));
            bExtendEventTemplate = EditorGUILayout.Foldout(bExtendEventTemplate, "事件模板");
            if (bExtendEventTemplate)
            {
                _templateScrollPos = EditorGUILayout.BeginScrollView(_templateScrollPos, false, false, GUILayout.Width(200));
                EditorGUI.indentLevel += 1;
                for (int idx = 0; idx < s_template_events.Count; idx++)
                {
                    if(curEventTemplateIdx == idx)
                    {
                        EditorGUILayout.Foldout(false, s_template_events[idx].desc.ToString(), true,selectedEventTemplateStyle);
                    }
                    else
                    {
                        bool flag = EditorGUILayout.Foldout(false, s_template_events[idx].desc.ToString(), true);
                        if (flag)
                        {
                            curSelectedEventTemplate = s_template_events[idx];
                            curEventTemplateIdx = idx;
                        }
                    }
                }
                EditorGUI.indentLevel -= 1;
                EditorGUILayout.EndScrollView();
            }
            EditorGUILayout.EndVertical();
        }
    }

    Vector2 skillScrollPos = Vector2.zero;
    void DrawSkillPnl()
    {
        if (currentSkillAsset == null) return;

        skillScrollPos = EditorGUILayout.BeginScrollView(skillScrollPos, false, false);

        EditorGUILayout.BeginVertical();
        bExtendSkillBaseFold = EditorGUILayout.Foldout(bExtendSkillBaseFold, "技能基础属性");
        if(bExtendSkillBaseFold)
        {
            EditorGUI.indentLevel += 1;
            #region 技能基础信息
            currentSkillAsset.skillId = EditorGUILayout.IntField("技能ID:", currentSkillAsset.skillId,GUILayout.Width(400));
            currentSkillAsset.skillLv = EditorGUILayout.IntField("技能等级:", currentSkillAsset.skillLv, GUILayout.Width(400));
            currentSkillAsset.skillName = EditorGUILayout.TextField("技能名字:", currentSkillAsset.skillName, GUILayout.Width(400));
            currentSkillAsset.skillDesc = EditorGUILayout.TextField("技能描述:", currentSkillAsset.skillDesc, GUILayout.Width(400));
            currentSkillAsset.levelUpDesc = EditorGUILayout.TextField("升级描述:", currentSkillAsset.levelUpDesc, GUILayout.Width(400));
            //currentSkillAsset.skillIcon = EditorGUILayout.TextField("技能icon:", currentSkillAsset.skillIcon, GUILayout.Width(400));

            EditorGUILayout.BeginHorizontal();
            string lastFileName = currentSkillAsset.skillIcon;
            Sprite icon = null;
            if (currentSkillAsset.iconIdx >= 0)
            {
                currentSkillAsset.skillIcon = "Skills/"+m_icons[currentSkillAsset.iconIdx];
                if ((!string.IsNullOrEmpty(currentSkillAsset.skillIcon) && lastFileName != currentSkillAsset.skillIcon) || icon == null)
                    icon = AssetDatabase.LoadAssetAtPath<Sprite>(Constants.IconDir + "/" + currentSkillAsset.skillIcon + ".png");
            }

            EditorGUILayout.LabelField("技能ICON:", GUILayout.Width(100));
            currentSkillAsset.iconIdx = EditorGUILayout.Popup(currentSkillAsset.iconIdx, m_icons.ToArray(), GUILayout.Width(200));
            if (icon != null)
                EditorGUILayout.ObjectField(icon, typeof(Sprite), GUILayout.Width(120), GUILayout.Height(100));
            EditorGUILayout.EndHorizontal();

            currentSkillAsset.skillType = EditorGUILayout.Popup("技能类型:", currentSkillAsset.skillType,s_skilltrigerTypeStr, GUILayout.Width(400));
            currentSkillAsset.cost = EditorGUILayout.IntField("SP消耗:", currentSkillAsset.cost, GUILayout.Width(400));
            currentSkillAsset.jobType = EditorGUILayout.Popup("职业类型:", currentSkillAsset.jobType,s_professionTypeStr, GUILayout.Width(400));
            currentSkillAsset.jobStage = EditorGUILayout.IntField("职业阶段:", currentSkillAsset.jobStage, GUILayout.Width(400));
            currentSkillAsset.fixedSingTime = EditorGUILayout.FloatField("固定吟唱时间:", currentSkillAsset.fixedSingTime, GUILayout.Width(400));
            currentSkillAsset.changeSingTime = EditorGUILayout.FloatField("可变吟唱时间:", currentSkillAsset.changeSingTime, GUILayout.Width(400));
            currentSkillAsset.preCastingTime = EditorGUILayout.FloatField("施法前摇时间:", currentSkillAsset.preCastingTime, GUILayout.Width(400));
            currentSkillAsset.castingTime = EditorGUILayout.FloatField("持续施法时间:", currentSkillAsset.castingTime, GUILayout.Width(400));
            currentSkillAsset.afterCastingTime = EditorGUILayout.FloatField("施法后摇时间:", currentSkillAsset.afterCastingTime, GUILayout.Width(400));
            currentSkillAsset.cd = EditorGUILayout.FloatField("施法延迟:", currentSkillAsset.cd, GUILayout.Width(400));
            currentSkillAsset.hide = EditorGUILayout.Toggle("技能树中是否隐藏:", currentSkillAsset.hide, GUILayout.Width(400));

            currentSkillAsset.extendPerceptionFold = EditorGUILayout.Foldout(currentSkillAsset.extendPerceptionFold, "感知范围");
            if(currentSkillAsset.extendPerceptionFold)
            {
                EditorGUI.indentLevel += 1;
                EditorGUILayout.BeginHorizontal();
                for (int idx = 0; idx <= 2; idx++)
                {
                    string lblName = CommonUtil.GetProfessionName(idx);
                    currentSkillAsset.PerceptionRange[idx] = EditorGUILayout.FloatField(lblName+":", currentSkillAsset.PerceptionRange[idx], GUILayout.Width(200));
                }
                EditorGUILayout.EndHorizontal();

                EditorGUILayout.BeginHorizontal();
                for (int idx=3; idx <= 5;idx++)
                {
                    string lblName = CommonUtil.GetProfessionName(idx);
                    currentSkillAsset.PerceptionRange[idx] = EditorGUILayout.FloatField(lblName + ":", currentSkillAsset.PerceptionRange[idx], GUILayout.Width(200));
                }
                EditorGUILayout.EndHorizontal();
                EditorGUI.indentLevel -= 1;
            }
            #endregion
            EditorGUI.indentLevel -= 1;
        }

        EditorGUILayout.BeginVertical(GUILayout.Height(800));
        currentSkillAsset.extendBuffFold = EditorGUILayout.Foldout(currentSkillAsset.extendBuffFold, "技能buff配置");
        if (currentSkillAsset.extendBuffFold)
        {
            EditorGUI.indentLevel += 1;
            if (currentSkillAsset.buffList != null && currentSkillAsset.buffList.Count > 0)
            {
                for (int idx = 0; idx < currentSkillAsset.buffList.Count; idx++)
                {
                    EditorGUILayout.BeginHorizontal(GUILayout.Width(220));
                    currentSkillAsset.buffList[idx].id = EditorGUILayout.IntField("buffId", currentSkillAsset.buffList[idx].id, contentStyle, GUILayout.Width(200));
                    EditorGUILayout.LabelField("", GUILayout.Width(200));
                    if (GUILayout.Button("删除buff",GUILayout.Width(100)))
                    {
                        RemoveBuff(currentSkillAsset.buffList[idx]);
                        return;
                    }

                    if(idx == currentSkillAsset.buffList.Count-1)
                    {
                        if (GUILayout.Button("添加新buff", GUILayout.Width(100)))
                        {
                            AddNewBuff();
                            return;
                        }
                    }
                
                    EditorGUILayout.EndHorizontal();
                    DrawBuff(currentSkillAsset.buffList[idx]);
                }
            }
            else
            {
                DrawSpace(20);
                EditorGUILayout.BeginHorizontal();
                EditorGUILayout.LabelField("", GUILayout.Width(500));

                if (GUILayout.Button("添加技能buff", GUILayout.Width(200), GUILayout.Height(60)))
                {
                    AddNewBuff();
                    return;
                }

                EditorGUILayout.LabelField("", GUILayout.Width(500));
                EditorGUILayout.EndHorizontal();
            }
            EditorGUI.indentLevel -= 1;
        }
        EditorGUILayout.EndVertical();

        EditorGUILayout.EndVertical();

        EditorGUILayout.EndScrollView();
    }

    void RemoveBuff(BuffDataAsset buffData)
    {
        if (currentSkillAsset == null) return;

        currentSkillAsset.RemoveBuff(buffData);
    }

    void AddNewBuff()
    {
        if (currentSkillAsset == null) return;

        BuffDataAsset newBuffData = new BuffDataAsset();
        currentSkillAsset.AddNewBuff(newBuffData);
        currentSkillAsset.bAddNewBuff = true;
    }

    bool bExtendEventTemplate = true;

    void DrawBuff(BuffDataAsset buffData)
    {
        if (buffData == null) return;

        #region buff基础信息
        buffData.extendBaseFold = EditorGUILayout.Foldout(buffData.extendBaseFold, "buff基本信息");
        if (buffData.extendBaseFold)
        {
            EditorGUILayout.BeginVertical(GUILayout.Width(700));
            buffData.desc = EditorGUILayout.TextField("描述:", buffData.desc);
            buffData.damageType = EditorGUILayout.Popup("伤害类型:", buffData.damageType, s_damageTypeStr);
            buffData.targetType = EditorGUILayout.Popup("目标类型:", buffData.targetType, s_targetSelectRuleStr);
            EditorGUILayout.EndVertical();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("命中效果:", GUILayout.Width(100));
            buffData.canPerfectDodge = EditorGUILayout.ToggleLeft("可完美闪避", buffData.canPerfectDodge, GUILayout.Width(160), GUILayout.Height(40));
            buffData.canDodge = EditorGUILayout.ToggleLeft("可闪避", buffData.canDodge, GUILayout.Width(100), GUILayout.Height(40));
            buffData.canResist = EditorGUILayout.ToggleLeft("可抵抗", buffData.canResist, GUILayout.Width(100), GUILayout.Height(40));
            buffData.canCrit = EditorGUILayout.ToggleLeft("可暴击", buffData.canCrit, GUILayout.Width(100), GUILayout.Height(40));
            EditorGUILayout.EndHorizontal();

            buffData.effectiveness = EditorGUILayout.IntField("生效率:", buffData.effectiveness, GUILayout.Width(400));
            buffData.ignoreMultiHurt = EditorGUILayout.Toggle("是否忽略多段伤害", buffData.ignoreMultiHurt);
        }
       

        #endregion


        #region buff效果配置
        EditorGUILayout.BeginVertical();
        buffData.extendFunFold = EditorGUILayout.Foldout(buffData.extendFunFold, "buff效果配置");
        if(buffData.extendFunFold)
        {
            if(buffData.funList!=null && buffData.funList.Count > 0)
            {
                EditorGUI.indentLevel += 1;

                for (int idx = 0; idx < buffData.funList.Count; idx++)
                {
                    EditorGUILayout.BeginHorizontal();
                    FunctionValData funParam = buffData.funList[idx];
                    DrawFunParam(funParam);
                    if(GUILayout.Button("-",GUILayout.Width(60)))
                    {
                        buffData.funList.RemoveAt(idx);
                        return;
                    }

                    if(idx == buffData.funList.Count -1)
                    {
                        if (!FunctionEventEditor.isShowing)
                        {
                            if (GUILayout.Button("+", GUILayout.Width(60)))
                            {
                                FunctionEventEditor.GetFunctionEventEditor(buffData.id);
                                return;
                            }
                        }
                    }
                    EditorGUILayout.EndHorizontal();

                    EditorGUILayout.Space();
                }
 
                EditorGUI.indentLevel -= 1;
            }
            else
            {
                DrawSpace(20);
                EditorGUILayout.BeginHorizontal();
                EditorGUILayout.LabelField("", GUILayout.Width(500));

                if (GUILayout.Button("添加Function", GUILayout.Width(200), GUILayout.Height(40)))
                {
                    FunctionEventEditor.GetFunctionEventEditor(buffData.id);
                    return;
                }

                EditorGUILayout.LabelField("", GUILayout.Width(500));
                EditorGUILayout.EndHorizontal();
            }
        }
        EditorGUILayout.EndVertical();
        #endregion


        #region 动作预览对象
        buffData.extendModelPrefab = EditorGUILayout.Foldout(buffData.extendModelPrefab, "预览模型");
        EditorGUILayout.BeginVertical();
        if (buffData.extendModelPrefab)
        {
            UnityEngine.Object temp = EditorGUILayout.ObjectField("动作控制器:",buffData.modelAnimator,typeof(RuntimeAnimatorController),GUILayout.Width(300));
            if (temp != null) {
                RuntimeAnimatorController ctrl = temp as RuntimeAnimatorController;
                if(buffData.modelAnimator != ctrl)
                {
                    buffData.modelAnimator = ctrl;

                    UnityEditor.Animations.AnimatorController ac = ctrl as UnityEditor.Animations.AnimatorController;

                    buffData.stateMachine = ac.layers[0].stateMachine;
                    buffData.animClipNames = new string[buffData.stateMachine.states.Length];
                    for (int i = 0; i < buffData.animClipNames.Length; i++) {
                        buffData.animClipNames[i] = buffData.stateMachine.states[i].state.name;
                    }
                }
            }
        }
        EditorGUILayout.EndVertical();
        #endregion

        #region buff帧事件
        buffData.extendFrameEventFold = EditorGUILayout.Foldout(buffData.extendFrameEventFold, "frameevent");
        EditorGUILayout.BeginVertical();
        if (buffData.extendFrameEventFold)
        {
            EditorGUI.indentLevel += 1;
            int flag = DrawFrameEvent(buffData.id, ref buffData.actionEventData,2,buffData.animClipNames, buffData.stateMachine);
            if (flag == 1)
            {
                SaveCurrentBuffFrameEvent(buffData);
            }else if(flag == 2)
            {
                buffData.SaveFrameEventToXml();
            }
            EditorGUI.indentLevel -= 1;
        }
        EditorGUILayout.EndVertical();


        buffData.extendFemaleFrameEventFold = EditorGUILayout.Foldout(buffData.extendFemaleFrameEventFold, "female_frameevent");
        EditorGUILayout.BeginVertical();
        if (buffData.extendFemaleFrameEventFold)
        {
            EditorGUI.indentLevel += 1;
            int flag = DrawFrameEvent(buffData.id, ref buffData.femaleActionEventData, 1, buffData.animClipNames, buffData.stateMachine);
            if (flag == 1)
            {
                SaveCurrentBuffFrameEvent(buffData);
            }
            else if (flag == 2)
            {
                buffData.SaveFemaleFrameEventToXml();
            }
            EditorGUI.indentLevel -= 1;
        }
        EditorGUILayout.EndVertical();
        #endregion

    }

    void DrawFunParam(FunctionValData param)
    {
        EditorGUILayout.LabelField("id:",contentStyle, GUILayout.Width(50));  param.funId = EditorGUILayout.IntField(param.funId, GUILayout.Width(100));
        EditorGUILayout.LabelField("数值:", contentStyle, GUILayout.Width(50)); param.val = EditorGUILayout.FloatField(param.val, GUILayout.Width(100));
        EditorGUILayout.LabelField("数值增量:", contentStyle, GUILayout.Width(90)); param.incVal = EditorGUILayout.FloatField( param.incVal, GUILayout.Width(100));
        EditorGUILayout.LabelField("持续时长:", contentStyle, GUILayout.Width(90)); param.duration = EditorGUILayout.FloatField(param.duration, GUILayout.Width(100));
        EditorGUILayout.LabelField("时长增量:", contentStyle, GUILayout.Width(90)); param.incDuration = EditorGUILayout.FloatField(param.incDuration, GUILayout.Width(100));
        EditorGUILayout.LabelField("来源属性:", contentStyle, GUILayout.Width(90)); param.fromAttr = EditorGUILayout.IntField(param.fromAttr, GUILayout.Width(100));
        EditorGUILayout.LabelField("间隔时间:", contentStyle, GUILayout.Width(90)); param.intervalTime = EditorGUILayout.FloatField(param.intervalTime, GUILayout.Width(100));
    }

    int DrawFrameEvent(int buffId,ref ActionEventDataEditor actionEventData,int gender,string[] animNames, UnityEditor.Animations.AnimatorStateMachine ctrl)
    {
        if (actionEventData != null)
        { 
            DrawSpace(1);
            EditorGUILayout.BeginHorizontal();
            actionEventData.Name = EditorGUILayout.TextField("名字", actionEventData.Name, GUILayout.Width(400));
            actionEventData.TotalFrame = EditorGUILayout.IntField("帧数", actionEventData.TotalFrame, GUILayout.Width(200));
            EditorGUILayout.LabelField("",GUILayout.Width(200));
            if (GUILayout.Button("保存buff帧数据", GUILayout.Width(100), GUILayout.Height(20)))
            {
                return 1;
            }
            EditorGUILayout.EndHorizontal();
            DrawSpace(4);

            List<ActionEventParamEditor> eventList = actionEventData.ActionEventList;

            if (eventList != null && eventList.Count > 0)
            {
                for (int idx = 0; idx < eventList.Count; idx++)
                {
                    int flag = DrawEvent(idx + 1, eventList.Count, eventList[idx], animNames,ctrl);
                    if (flag == 1)       //移除帧数据
                    {
                        eventList.RemoveAt(idx);
                        return 0;
                    }
                    else if (flag == 2)     //增加新帧数据
                    {
                        if (curSelectedEventTemplate != null)
                        {
                            ActionEventParamEditor newEvent = new ActionEventParamEditor(curSelectedEventTemplate);
                            eventList.Add(newEvent);
                        }
                        else
                        {
                            EditorUtility.DisplayDialog("错误", string.Concat("没有选择添加的事件模板"), "确定");
                        }

                        return 0;
                    }
                    DrawSpace(2);
                }
            }
            else
            {
                DrawSpace(20);
                EditorGUILayout.BeginHorizontal();
                EditorGUILayout.LabelField("", GUILayout.Width(500));

                if (GUILayout.Button("新增Event Node",GUILayout.Width(200),GUILayout.Height(40)))
                {
                    if(eventList == null)
                    {
                        if (curSelectedEventTemplate != null)
                        {
                            ActionEventParamEditor newEvent = new ActionEventParamEditor(curSelectedEventTemplate);
                            actionEventData.AddEvent(newEvent);
                        }
                        else
                        {
                            EditorUtility.DisplayDialog("错误", string.Concat("没有选择添加的事件模板"), "确定");
                        }
                        return 0;
                    }
                }

                EditorGUILayout.LabelField("", GUILayout.Width(500));
                EditorGUILayout.EndHorizontal();
            }
        }
        else
        {
            DrawSpace(20);
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("", GUILayout.Width(500));
            if (GUILayout.Button("创建FrameEvent文件", GUILayout.Width(300), GUILayout.Height(40)))
            {
                actionEventData = new ActionEventDataEditor(buffId, 30, buffId.ToString(), gender);
                return 2;
            }
            EditorGUILayout.LabelField("", GUILayout.Width(500));
            EditorGUILayout.EndHorizontal();
        }
        return 0;
    }

    int DrawEvent(int cnt,int maxCnt,ActionEventParamEditor eventParam, string[] animNames, UnityEditor.Animations.AnimatorStateMachine ctrl)
    {
        EditorGUILayout.BeginVertical();

        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.LabelField(string.Format("Event{0}",cnt), contentStyle, GUILayout.Width(80));
        EditorGUILayout.LabelField("起始帧数:", contentStyle, GUILayout.Width(80)); eventParam.startFrame = EditorGUILayout.IntField(eventParam.startFrame, GUILayout.Width(100));
        EditorGUILayout.LabelField("结束帧数:", contentStyle, GUILayout.Width(80)); eventParam.endFrame = EditorGUILayout.IntField(eventParam.endFrame, GUILayout.Width(100));
        SkillActionFrameEventType eType = (SkillActionFrameEventType)eventParam.eventType;
        EditorGUILayout.LabelField("事件类型:", contentStyle, GUILayout.Width(80)); eType = (SkillActionFrameEventType)EditorGUILayout.EnumPopup(eType, GUILayout.Width(300)); eventParam.eventType = (int)eType;
        EditorGUILayout.LabelField("受吟唱影响:", contentStyle, GUILayout.Width(100)); eventParam.bAffectBySing = EditorGUILayout.Toggle(eventParam.bAffectBySing, GUILayout.Width(40));
        EditorGUILayout.LabelField("备注:", contentStyle, GUILayout.Width(60)); eventParam.desc = EditorGUILayout.TextField(eventParam.desc, GUILayout.Width(240));
        if (GUILayout.Button("-", GUILayout.Width(40)))
        {
            return 1;
        }

        if (cnt == maxCnt)
        {
            if (!FunctionEventEditor.isShowing)
            {
                if (GUILayout.Button("+", GUILayout.Width(40)))
                {
                    return 2;
                }
            }
        }
        EditorGUILayout.EndHorizontal();

        EditorGUI.indentLevel += 1;
        for (int idx =0; idx < eventParam.frameParams.Count;idx++)
        {
            DrawEventParam(eventParam.frameParams[idx], animNames,ctrl);
            EditorGUILayout.Space();
        }
        EditorGUI.indentLevel -= 1;
        EditorGUILayout.EndVertical();
        return 0;
    }

    void DrawEventParam(FrameEventParamEditor param, string[] animNames, UnityEditor.Animations.AnimatorStateMachine stateMachine)
    {
        EditorGUILayout.BeginHorizontal();

        EditorGUILayout.LabelField("参数名字:", paramStyle, GUILayout.Width(100)); param.name = EditorGUILayout.TextField(param.name, GUILayout.Width(200));
        if(param.name=="effect" || param.name == "hiteffect")
        {
            if (param.valIdx >= 0)
            {
                param.val = m_effects[param.valIdx].id.ToString();
            }
            EditorGUILayout.LabelField("参数数值:", paramStyle, GUILayout.Width(100)); EditorGUILayout.LabelField(param.val, GUILayout.Width(200));
            param.valIdx = EditorGUILayout.Popup(param.valIdx, m_effectIds.ToArray(), GUILayout.Width(200));
        }else if(param.name == "animName")
        {
            EditorGUILayout.LabelField("参数数值:", paramStyle, GUILayout.Width(100));
            if(animNames != null)
            {
                if(param.valIdx == -1)
                {
                    for (int i = 0; i < animNames.Length; i++)
                    {
                        if (param.val == animNames[i])
                        {
                            param.valIdx = i;
                            break;
                        }
                    }
                }

                int frameCnt = 0;
                param.valIdx = EditorGUILayout.Popup(param.valIdx, animNames, GUILayout.Width(200));
                if (param.valIdx >= 0) { 
                    param.val = animNames[param.valIdx];
                    if(stateMachine != null)
                    {
                        Motion motion = stateMachine.states[param.valIdx].state.motion;
                        if (motion != null)
                        {
                            frameCnt = (int)(motion.averageDuration * 30);
                        }
                    }
                }

                EditorGUILayout.LabelField(param.val.ToString(), paramStyle, GUILayout.Width(100));
                EditorGUILayout.LabelField(frameCnt.ToString(), selectedItemStyle, GUILayout.Width(80));
            }
           
        }
        else
        {
            EditorGUILayout.LabelField("参数数值:", paramStyle, GUILayout.Width(100)); param.val = EditorGUILayout.TextField(param.val, GUILayout.Width(200));
        }
        
        EditorGUILayout.LabelField("数值类型:", paramStyle, GUILayout.Width(100)); param.valTypeIdx = EditorGUILayout.Popup(param.valTypeIdx,s_valTypes, GUILayout.Width(150));
        if (param.valTypeIdx >= 0)
            param.valType = s_valTypes[param.valTypeIdx];
        else
            param.valType = "";

        EditorGUILayout.EndHorizontal();
    }

    public void ResetData()
    {
        if(curSkillIdx >= 0 && curSkillIdx<m_miniLevelSkills.Count)
        {
            currentSkillAsset = m_miniLevelSkills[curSkillIdx];
        }
        else
        {
            curSkillIdx = -1;
            currentSkillAsset = null;
        }
        
        if(curEventTemplateIdx>=0 && curEventTemplateIdx < s_template_events.Count)
        {
            curSelectedEventTemplate = s_template_events[curEventTemplateIdx];
        }
        else
        {
            curEventTemplateIdx = -1;
            curSelectedEventTemplate = null;
        }
    }

    void SaveCurrentBuffFrameEvent(BuffDataAsset buffDataAsset)
    {
        if (buffDataAsset == null || buffDataAsset.id == 0) return;

        string buffFrameEventFileName = string.Format("{0}/Content/Xml/buff_{1}.xml", Application.dataPath, buffDataAsset.id);

        SecurityElement root = new SecurityElement("FrameEvent");
        SecurityElement buffNode = buffDataAsset.SaveFrameEventToXml();
        if (buffNode != null)
        {
            root.AddChild(buffNode);
        }

        SecurityElement femaleBuffNode = buffDataAsset.SaveFemaleFrameEventToXml();
        if(femaleBuffNode!=null)
        {
            root.AddChild(femaleBuffNode);
        }

        SecurityTools.DumpSecurityElementToXml(root, buffFrameEventFileName);
    }
    #endregion

    static BuffDataAsset GetBuffAsset(int buffId)
    {
        for(int idx =0; idx < m_buffs.Count;idx++)
        {
            if (m_buffs[idx].id == buffId)
                return m_buffs[idx];
        }
        return null;
    }

    public static ActionEventDataEditor GetActionEventData(int id, int gender = 2)
    {
        int uniqueId = id * 10 + gender;
        ActionEventDataEditor data = null;
        if (s_ActionEventDic.TryGetValue(uniqueId, out data))
        {
            return data;
        }
        return null;
    }

    static int GetValueTypeIndex(string valType)
    {
        for(int idx = 0; idx < s_valTypes.Length;idx++)
        {
            if (s_valTypes[idx] == valType) return idx;
        }
        return -1;
    }

    static int GetIconIdx(string name)
    {
        string pureName = FileUtils.ExtractPureName(name);
        if (string.IsNullOrEmpty(name)) return -1;

        for (int idx = 0; idx < m_icons.Count; idx++)
        {
            if (string.Compare(m_icons[idx], pureName) == 0)
                return idx;
        }
        return -1;
    }

    public static void AddFunEventToBuff(int buffId,FunctionDataAsset funAsset)
    {
        GetPanel().AddFunToSkillBuff(buffId,funAsset);
    }

    public static int GetEffectIdx(int effectId)
    {
        if (effectId <= 0) return -1;

        for (int idx = 0; idx < m_effects.Count; idx++)
        {
            if (m_effects[idx].id == effectId)
                return idx;
        }

        return -1;
    }

    public void AddFunToSkillBuff(int buffId, FunctionDataAsset funAsset)
    {
        if (currentSkillAsset == null) return;

        currentSkillAsset.AddFunEventToBuff(buffId, funAsset);
    }
}
