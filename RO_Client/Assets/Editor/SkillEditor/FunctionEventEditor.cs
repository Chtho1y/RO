using UnityEngine;
using UnityEditor;
using System.Collections.Generic;
using System.IO;
using OfficeOpenXml;
using System;

public class FunctionEventEditor : EditorWindow
{
    static string s_functionExcelFileName = "FunctionCfg.xlsx";
    static List<FunctionDataAsset> m_funEvents = new List<FunctionDataAsset>();

    static List<string> m_funIcons = new List<string>();
    static List<string> m_textIcons = new List<string>();

    static FunctionEventEditor m_instance = null;

    static int m_buffId = 0;
    public static bool isShowing = false;
    public static void GetFunctionEventEditor(int buffId)
    {
        m_buffId = buffId;
        GetIcons();
        GetFunsList();
        RefreshPanel();
    }

    public static void RefreshPanel()
    {
        FunctionEventEditor panel = GetPanel();
        panel.Repaint();

        isShowing = true;
    }

    public static FunctionEventEditor GetPanel()
    {
        if (null == m_instance)
        {
            m_instance = EditorWindow.GetWindowWithRect<FunctionEventEditor>(new Rect(0,0,800,600),false, "buff效果编辑器");
        }
        return m_instance;
    }

    static void GetFunsList()
    {
        m_funEvents.Clear();
        try
        {
            string filePath = EditorPrefs.GetString(s_functionExcelFileName, string.Empty);
            if (!SkillEditor.IsVaildGlobalPath(filePath, s_functionExcelFileName))
            {
                string content = string.Concat("请选择", s_functionExcelFileName, "文件");
                string[] filters = new string[2]
                {
                    "Excel File", SkillEditor.c_ExcelFileExtension
                };
                filePath = EditorUtility.OpenFilePanelWithFilters(content, Application.dataPath, filters);
                if (!SkillEditor.IsVaildGlobalPath(filePath, s_functionExcelFileName))
                {
                    EditorUtility.DisplayDialog("错误", string.Concat("未选择", s_functionExcelFileName, "文件"), "确定");
                    return;
                }
                EditorPrefs.SetString(s_functionExcelFileName, filePath);
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
                        FunctionDataAsset fun = FunctionDataAsset.CreateFunAsset(sheet, rowIndex);
                        fun.iconIdx = GetIconIdx(fun.icon);
                        fun.wordIdx = GetTextIconIdx(fun.word);
                        fun.effectIdx = SkillEditor.GetEffectIdx(fun.effectId);
                        m_funEvents.Add(fun);
                        rowIndex += 1;
                    }
                }
            }

            if(m_funEvents.Count > 0)
                GetPanel().SetCurOpEvent(0);
        }
        catch (Exception e)
        {
            Debug.LogException(e);
            EditorUtility.DisplayDialog("错误", string.Concat("无法读取", s_functionExcelFileName, "文件数据"), "确定");
        }
        Debug.Log("fun cnt:" + m_funEvents.Count);

    }

    static void GetIcons()
    {
        m_funIcons.Clear();
        m_textIcons.Clear();

        string path = Constants.IconDir + "/Buff"; 
        string[] fileList = FileUtils.TraverseAllFiles(path, "*.png");
        for (int idx = 0; idx < fileList.Length; idx++)
        {
            string iconName = fileList[idx];
            string icon = FileUtils.RemoveExtension(FileUtils.RemoveParent(Constants.IconDir, iconName));
            if (icon.Contains("text_"))
                m_textIcons.Add(icon);
            else
                m_funIcons.Add(icon);
        }

    }

    GUIStyle curStyle = null;

    private void OnGUI()
    {
        EditorGUILayout.BeginHorizontal();

        ShowFunEventList();

        EditorGUILayout.BeginVertical(GUILayout.Width(400));
        ShowOpPnl();

        ShowFunEventData();
        EditorGUILayout.EndVertical();

        EditorGUILayout.EndHorizontal();
    }

    private void OnEnable()
    {
        if (curStyle == null)
        {
            curStyle = new GUIStyle();
            curStyle.fontSize = 20;
            curStyle.alignment = TextAnchor.MiddleLeft;
            curStyle.normal.textColor = Color.green;
        }
    }

    private void OnDestroy()
    {
        isShowing = false;
    }

    Vector2 scrollPos = Vector2.zero;
    bool bExtendTree = true;
    int curFunIdx = -1;
    public FunctionDataAsset curFunEventAsset = null;
    void ShowFunEventList()
    {
        EditorGUILayout.BeginVertical(GUILayout.Width(200));
        bExtendTree = EditorGUILayout.Foldout(bExtendTree, "效果列表");
        if (bExtendTree)
        {
            scrollPos = EditorGUILayout.BeginScrollView(scrollPos, false, false, GUILayout.Width(200));
            EditorGUI.indentLevel += 1;
            for (int idx = 0; idx < m_funEvents.Count; idx++)
            {
                bool flag = false;
                if (idx == curFunIdx)
                {
                    flag = EditorGUILayout.Foldout(true, m_funEvents[idx].id.ToString(), true, curStyle);
                }
                else
                {
                    flag = EditorGUILayout.Foldout(false, m_funEvents[idx].id.ToString(), true);
                    if (flag)
                    {
                        SetCurOpEvent(idx);
                    }
                }
            }
            EditorGUI.indentLevel -= 1;
            EditorGUILayout.EndScrollView();
        }
        EditorGUILayout.EndVertical();
    }

    void ShowOpPnl()
    {
        EditorGUILayout.Space();

        EditorGUILayout.BeginHorizontal();

        if(GUILayout.Button("新增"))
        {
            AddNewFunEvent();
        }
        if(GUILayout.Button("删除当前"))
        {
            RemoveCurFunEvent();
        }

        if(GUILayout.Button("应用"))
        {
            ApplyCurChange();
        }

        if(GUILayout.Button("撤销"))
        {
            CancelCurChange();
        }

        if(GUILayout.Button("保存到文件"))
        {
            SaveData();
        }

        if(GUILayout.Button("使用"))
        {
            UseCurFun();
        }

        EditorGUILayout.EndHorizontal();

        for(int idx =0; idx < 4;idx++)
            EditorGUILayout.Space();
    }

    void ShowFunEventData()
    {
        EditorGUILayout.BeginVertical();
        if (curFunEventAsset == null) return;

        curFunEventAsset.id = EditorGUILayout.IntField("id:", curFunEventAsset.id,GUILayout.Width(300));
        curFunEventAsset.name = EditorGUILayout.TextField("名字:", curFunEventAsset.name, GUILayout.Width(300));
        curFunEventAsset.buffType = (BattleBuffType)EditorGUILayout.EnumPopup("buff类型:",curFunEventAsset.buffType,GUILayout.Width(300));
        curFunEventAsset.functionType = (Buff_Function_Type)EditorGUILayout.EnumPopup("状态类型:",curFunEventAsset.functionType, GUILayout.Width(300));
        curFunEventAsset.canHurtStop = EditorGUILayout.ToggleLeft("是否可以伤害打断", curFunEventAsset.canHurtStop, GUILayout.Width(300));
        curFunEventAsset.forbidMove = EditorGUILayout.ToggleLeft("是否禁止移动", curFunEventAsset.forbidMove, GUILayout.Width(300));
        curFunEventAsset.forbidNormalAttack = EditorGUILayout.ToggleLeft("是否禁止普攻", curFunEventAsset.forbidNormalAttack, GUILayout.Width(300));
        curFunEventAsset.forbidSkill = EditorGUILayout.ToggleLeft("是否禁止技能", curFunEventAsset.forbidSkill, GUILayout.Width(300));
        curFunEventAsset.canIgnoreDodge = EditorGUILayout.ToggleLeft("是否忽略闪避", curFunEventAsset.canIgnoreDodge, GUILayout.Width(300));
        curFunEventAsset.desc = EditorGUILayout.TextField("描述:", curFunEventAsset.desc, GUILayout.Width(300));

        EditorGUILayout.Space();

        EditorGUILayout.BeginHorizontal();
        string lastFileName = curFunEventAsset.icon;
        Sprite icon = null;
        if(curFunEventAsset.iconIdx>=0)
        {
            curFunEventAsset.icon = m_funIcons[curFunEventAsset.iconIdx];
            if ((!string.IsNullOrEmpty(curFunEventAsset.icon) && lastFileName!=curFunEventAsset.icon) || icon == null)
                icon = AssetDatabase.LoadAssetAtPath<Sprite>(Constants.IconDir+"/"+curFunEventAsset.icon+".png");
        }

        EditorGUILayout.LabelField("图标", GUILayout.Width(200));
        curFunEventAsset.iconIdx = EditorGUILayout.Popup(curFunEventAsset.iconIdx, m_funIcons.ToArray(), GUILayout.Width(200));
        if (icon != null)
            EditorGUILayout.ObjectField(icon,typeof(Sprite),GUILayout.Width(60),GUILayout.Height(60));
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.Space();


        EditorGUILayout.BeginHorizontal();
        Sprite wordSp = null;
        lastFileName = curFunEventAsset.word;
        if (curFunEventAsset.wordIdx >= 0)
        {
            curFunEventAsset.word = m_textIcons[curFunEventAsset.wordIdx];
            if ((!string.IsNullOrEmpty(curFunEventAsset.word) && lastFileName != curFunEventAsset.word) || wordSp == null)
                wordSp = AssetDatabase.LoadAssetAtPath<Sprite>(Constants.IconDir + "/" + curFunEventAsset.word + ".png");
        }
        EditorGUILayout.LabelField("文字", GUILayout.Width(200));
        curFunEventAsset.wordIdx = EditorGUILayout.Popup(curFunEventAsset.wordIdx, m_textIcons.ToArray(), GUILayout.Width(200));
        if (wordSp != null)
            EditorGUILayout.ObjectField(wordSp, typeof(Sprite), GUILayout.Width(60), GUILayout.Height(60));
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.Space();
        EditorGUILayout.BeginHorizontal();
        if (curFunEventAsset.effectIdx >= 0)
        {
            curFunEventAsset.effectId = SkillEditor.m_effects[curFunEventAsset.effectIdx].id;
        }
        EditorGUILayout.LabelField("特效", GUILayout.Width(200));
        curFunEventAsset.effectIdx = EditorGUILayout.Popup(curFunEventAsset.effectIdx, SkillEditor.m_effectIds.ToArray(), GUILayout.Width(200));
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.EndVertical();
    }

    public void SetCurOpEvent(int idx)
    {
        curFunIdx = idx;
        if (curFunIdx >= 0 && curFunIdx < m_funEvents.Count)
        { 
            if(curFunEventAsset == null)
            {
                curFunEventAsset = new FunctionDataAsset();
            }
            curFunEventAsset.Copy(m_funEvents[idx]);
        }
        else
        { 
            curFunEventAsset = null;
        }
    }

    public void CancelCurChange()
    {
        if (curFunIdx < 0 || curFunIdx >= m_funEvents.Count) return;

        curFunEventAsset.Copy(m_funEvents[curFunIdx]);
    }

    public void ApplyCurChange()
    {
        if (curFunIdx < 0 || curFunIdx >= m_funEvents.Count) return;

        m_funEvents[curFunIdx].Copy(curFunEventAsset);
    }

    public void AddNewFunEvent()
    {
        curFunEventAsset = new FunctionDataAsset();
        m_funEvents.Add(curFunEventAsset);
        curFunIdx = m_funEvents.Count - 1;
        scrollPos.y = 3500;
    }

    public void RemoveCurFunEvent()
    {
        if (curFunIdx < 0 || curFunIdx >= m_funEvents.Count) return;

        m_funEvents.RemoveAt(curFunIdx);
        if(curFunIdx >= m_funEvents.Count)
        {
            SetCurOpEvent(m_funEvents.Count - 1);
        }
        else
        {
            SetCurOpEvent(curFunIdx);
        }
    }

    public bool SaveData()
    {
        bool success = true;
        try
        {
            string filePath = EditorPrefs.GetString(s_functionExcelFileName, string.Empty);
            FileInfo fileInfo = new FileInfo(filePath);
            using (var excelPackage = new ExcelPackage(fileInfo))
            {
                var sheets = excelPackage.Workbook.Worksheets;
                var sheet = sheets[1];
                int rowIndex = 4;
                for (int idx = 0; idx < m_funEvents.Count; idx++)
                {
                    m_funEvents[idx].SaveAssetToExcel(ref sheet, rowIndex);
                    rowIndex += 1;
                }
                excelPackage.SaveAs(fileInfo);
            }
        }
        catch(Exception e)
        {
            Debug.LogException(e);
            EditorUtility.DisplayDialog("错误", string.Concat("有其它程序在使用该文件", s_functionExcelFileName, ", 请关闭"), "确定");
            success = false;
        }
        return success;
    }

    public void UseCurFun()
    {
        if (curFunIdx < 0 || curFunIdx > m_funEvents.Count) return;

        if (curFunEventAsset == null) return;

        if (curFunEventAsset.id == 0) return;

        SkillEditor.AddFunEventToBuff(m_buffId,curFunEventAsset);
        GetPanel().Close();
    }

    static int GetIconIdx(string name)
    {
        if (string.IsNullOrEmpty(name)) return -1;

        for(int idx = 0; idx < m_funIcons.Count;idx++)
        {
            if (string.Compare(m_funIcons[idx], name) == 0)
                return idx;
        }
        return -1;
    }

    static int GetTextIconIdx(string name)
    {
        if (string.IsNullOrEmpty(name)) return -1;

        for (int idx = 0; idx < m_textIcons.Count; idx++)
        {
            if (string.Compare(m_textIcons[idx], name) == 0)
                return idx;
        }
        return -1;
    }
}