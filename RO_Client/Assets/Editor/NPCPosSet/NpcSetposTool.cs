using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text.RegularExpressions;
using System.IO;
using UnityEngine;
using UnityEditor;
using UnityEditor.SceneManagement;
using OfficeOpenXml;

using Debug = UnityEngine.Debug;

public class NpcSetposTool : EditorWindow
{
    private class NpcInfo
    {
        public int id = 0;
        public string name;
        public int avatarId = 0;
        public Vector3 position;
        public Vector3 rotation;
        public Transform npcRoot;
        public Transform model;
        
        public void CreateNpc()
        {
            if (!npcRoot)
            {
                name = ConfigMgr.GetInstance().getValue(avatarId, "Name", "AvatarCfg");
                GameObject npcGo = new GameObject(name + "（" + id + "）");
                npcRoot = npcGo.transform;
                npcRoot.position = position;
                npcRoot.rotation = Quaternion.Euler(rotation);
            }
            if (!model)
            {
                string prefab = ConfigMgr.GetInstance().getValue(avatarId, "AvatarPrefab", "AvatarCfg");
                GameObject go = AssetDatabase.LoadAssetAtPath<GameObject>(Path.Combine(Constants.ModelPath, prefab + ".prefab"));
                if (go)
                {
                    GameObject modelGo = GameObject.Instantiate(go);
                    model = modelGo.transform;
                    model.parent = npcRoot;
                    model.localScale = Vector3.one;
                    model.localPosition = Vector3.zero;
                    model.localRotation = Quaternion.identity;
                    var colliders = modelGo.GetComponentsInChildren<Collider>();
                    foreach(var collider in colliders)
                    {
                        GameObject.DestroyImmediate(collider);
                    }
                }
            }
        }

        public void SaveNpc()
        {
            if (npcRoot)
            {
                position = npcRoot.position;
                rotation.y = npcRoot.rotation.eulerAngles.y;
            }
        }

        public void DeleteNpc()
        {
            if (npcRoot)
            {
                GameObject.DestroyImmediate(npcRoot.gameObject);
            }
        }
    }

    private const string c_MainCityScenePath = "Assets/Scenes/Scene_prontera_01/Scene_prontera_01.unity";
    private const string c_NPCExcelFilePathKey = "NPCExcelFilePathKey";
    private const string c_GlobalExcelFilePathKey = "GlobalExcelFilePathKey";
    private const string c_NPCDisableRadiusKey = "c_NPCDisableRadiusKey";
    private const string c_NPCCollisionRadiusKey = "c_NPCCollisionRadiusKey";
    private const string c_NPCTriggerRadiusKey = "c_NPCTriggerRadiusKey";
    private const string c_NPCExcelFileName = "MainCityNpcCfg.xlsx";
    private const string c_GlobalExcelFileName = "GlobalCfg.xlsx";
    private const string c_ExcelFileExtension = "xlsx";

    private const string c_NPCSetposSceneName = "NPC设置场景";
    private const string c_NPCRootGoName = "NPC";

    private bool m_NPCDisableRadiusShow = true;
    private bool m_NPCCollisionRadiusShow = true;
    private bool m_NPCTriggerRadiusShow = true;

    private float m_DiableRadiusDefault = 1;
    private float m_CollisionRadiusDefault = 1;
    private float m_TriggerRadiusDefault = 1;
    private float m_DiableRadius = 1;
    private float m_CollisionRadius = 1;
    private float m_TriggerRadius = 1;

    private Dictionary<int, NpcInfo> m_NpcInfos = new Dictionary<int, NpcInfo>();
    
    private void OnEnable() {
        SceneView.onSceneGUIDelegate += OnSceneGUI;
        var scene = EditorSceneManager.GetSceneByName(c_NPCSetposSceneName);
        EditorSceneManager.CloseScene(scene, true);

        m_NPCDisableRadiusShow = EditorPrefs.GetBool(c_NPCDisableRadiusKey, true);
        m_NPCCollisionRadiusShow = EditorPrefs.GetBool(c_NPCCollisionRadiusKey, true);
        m_NPCTriggerRadiusShow = EditorPrefs.GetBool(c_NPCTriggerRadiusKey, true);
    }

    private void OnDisable() {
        SceneView.onSceneGUIDelegate -= OnSceneGUI;
        var scene = EditorSceneManager.GetSceneByName(c_NPCSetposSceneName);
        EditorSceneManager.CloseScene(scene, true);
    }

    private void OnSceneGUI(SceneView sceneView) 
    {
        if (m_NpcInfos.Count <= 0 ) return;
        Rect rect = sceneView.position;
        Handles.BeginGUI();
        GUILayout.BeginArea(new Rect(rect.width - 200, rect.height - 100, 200, 100), "设置");
        GUILayout.BeginVertical();
        DrawParamItem(ref m_NPCDisableRadiusShow, ref m_DiableRadius, c_NPCDisableRadiusKey, "是否显示不可摆摊区域");
        DrawParamItem(ref m_NPCCollisionRadiusShow, ref m_CollisionRadius, c_NPCCollisionRadiusKey, "是否显示碰撞区域");
        DrawParamItem(ref m_NPCTriggerRadiusShow, ref m_TriggerRadius, c_NPCTriggerRadiusKey, "是否显示触发事件区域");
        GUILayout.EndVertical();
        GUILayout.EndArea();
        Handles.EndGUI();
        foreach(var item in m_NpcInfos)
        {
            var npcinfo = item.Value;
            if (npcinfo != null)
            {
                Vector3 rotation = npcinfo.npcRoot.rotation.eulerAngles;
                if (!Mathf.Approximately(0f, rotation.x) || !Mathf.Approximately(0f, rotation.z))
                {
                    rotation.x = 0f;
                    rotation.z = 0f;
                    npcinfo.npcRoot.rotation = Quaternion.Euler(rotation);
                }
                if (m_NPCDisableRadiusShow) DrawCylinder(npcinfo.npcRoot.position, m_DiableRadius, Color.red);
                if (m_NPCCollisionRadiusShow) DrawCylinder(npcinfo.npcRoot.position, m_CollisionRadius, Color.green);
                if (m_NPCTriggerRadiusShow) DrawCylinder(npcinfo.npcRoot.position, m_TriggerRadius, Color.blue);
            }
        }
    }

    private void DrawParamItem(ref bool show, ref float radius, string key, string content)
    {
        GUILayout.BeginHorizontal();
        bool showTemp = GUILayout.Toggle(show, content);
        if (showTemp != show)
        {
            show = showTemp;
            EditorPrefs.SetBool(key, show);
        }
        radius = EditorGUILayout.FloatField(radius);
        GUILayout.EndHorizontal();
    }

    private void DrawCylinder(Vector3 position, float radius, Color color)
    {
        Color defaultColor = Handles.color;
        Handles.color = color;
        Vector3 offset = new Vector3(0, 2, 0);
        Vector3 top = position + offset;
        Vector3 center = position + offset * 0.5f;
        Vector3 bottom = position;

        Vector3 point1 =  top + Vector3.left * radius;
        Vector3 point2 =  top + Vector3.right * radius;
        Vector3 point3 =  top + Vector3.forward * radius;
        Vector3 point4 =  top + Vector3.back * radius;

        Vector3 point5 =  bottom + Vector3.left * radius;
        Vector3 point6 =  bottom + Vector3.right * radius;
        Vector3 point7 =  bottom + Vector3.forward * radius;
        Vector3 point8 =  bottom + Vector3.back * radius;
        
        Handles.DrawWireDisc(top, Vector3.up, radius);
        Handles.DrawWireDisc(center, Vector3.up, radius);
        Handles.DrawWireDisc(bottom, Vector3.up, radius);
        
        Handles.DrawLine(point1, point5);
        Handles.DrawLine(point2, point6);
        Handles.DrawLine(point3, point7);
        Handles.DrawLine(point4, point8);
        Handles.color = defaultColor;
    }

    private void OnGUI() {
        if (EditorApplication.isPlaying)
        {
            GUILayout.FlexibleSpace();
            EditorGUILayout.HelpBox("不可在运行环境下编辑", MessageType.Warning);
            GUILayout.FlexibleSpace();
            return;
        }
        if (!IsMainCityScene())
        {
            GUILayout.FlexibleSpace();
            EditorGUILayout.HelpBox("需要先打开主城", MessageType.Info);
            if (GUILayout.Button("打开主城场景"))
            {
                OpenMainCityScene();
            }
            GUILayout.FlexibleSpace();
            return;
        }

        GUILayout.FlexibleSpace();
        if (GUILayout.Button("读取数据"))
        {
            bool success = ReadGlobalExcelData();
            if (success) success = ReadNPCExcelData();
        }
        EditorGUILayout.Space();
        EditorGUILayout.Space();
        if (GUILayout.Button("保存数据"))
        {
            if (m_NpcInfos.Count > 0)
            {
                bool success = SaveGlobalExcelData();
                if (success) success = SaveNPCExcelData();
            }
        }
        GUILayout.FlexibleSpace();
    }

    


    private bool IsMainCityScene()
    {
        return EditorSceneManager.sceneCount == 2
                && EditorSceneManager.GetSceneAt(0).path == c_MainCityScenePath
                && EditorSceneManager.GetActiveScene().name == c_NPCSetposSceneName;
    }

    private void OpenMainCityScene()
    {
        EditorSceneManager.SaveCurrentModifiedScenesIfUserWantsTo();
        EditorSceneManager.OpenScene(c_MainCityScenePath, OpenSceneMode.Single);
        var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Additive);
        scene.name = c_NPCSetposSceneName;
        EditorSceneManager.SetActiveScene(scene);
    }

    private bool HasNpcDatas()
    {
        return false;
    }

    private bool IsVaildGlobalPath(string path)
    {
        return (!string.IsNullOrEmpty(path) 
                && File.Exists(path) 
                && Path.GetFileName(path) == c_GlobalExcelFileName);
    }

    private bool IsVaildNPCPath(string path)
    {
        return (!string.IsNullOrEmpty(path) 
                && File.Exists(path) 
                && Path.GetFileName(path) == c_NPCExcelFileName);
    }

    private bool ReadGlobalExcelData()
    {
        bool success = true;
        try
        {
            string filePath = EditorPrefs.GetString(c_GlobalExcelFilePathKey, string.Empty);
            if (!IsVaildGlobalPath(filePath))
            {
                string content = string.Concat("请选择", c_GlobalExcelFileName, "文件");
                string[] filters = new string[2]
                {
                    "Excel File", c_ExcelFileExtension
                };
                filePath = EditorUtility.OpenFilePanelWithFilters(content, Application.dataPath, filters);
                if (!IsVaildGlobalPath(filePath))
                {
                    EditorUtility.DisplayDialog("错误", string.Concat("未选择", c_GlobalExcelFileName, "文件"), "确定");
                    return false;
                }
                EditorPrefs.SetString(c_GlobalExcelFilePathKey, filePath);
            }
            
            FileInfo fileInfo = new FileInfo(filePath);
            // using (var fs = new FileStream(filePath, FileMode.Open))
            {
                using(var excelPackage = new ExcelPackage(fileInfo))
                {
                    var sheets = excelPackage.Workbook.Worksheets;
                    var sheet = sheets[1];
                    int rowIndex = 4;
                    int colIndex = 1;
                    while(!string.IsNullOrEmpty(sheet.GetValue<string>(rowIndex, colIndex)))
                    {
                        int id = sheet.GetValue<int>(rowIndex, 1);
                        if (id == 34)
                        {
                            m_DiableRadius = m_DiableRadiusDefault = sheet.GetValue<float>(rowIndex, 5);
                        }
                        else if (id == 35)
                        {
                            m_CollisionRadius = m_CollisionRadiusDefault = sheet.GetValue<float>(rowIndex, 5);
                        }
                        else if (id == 36)
                        {
                            m_TriggerRadius = m_TriggerRadiusDefault = sheet.GetValue<float>(rowIndex, 5);
                        }
                        rowIndex += 1;
                    }
                }
            }
        }
        catch (Exception e)
        {
            Debug.LogException(e);
            EditorUtility.DisplayDialog("错误", string.Concat("无法读取", c_GlobalExcelFileName, "文件数据"), "确定");
            success = false;
        }
        return success;
    }
    
    
    private bool ReadNPCExcelData()
    {
        bool success = true;
        try
        {
            string filePath = EditorPrefs.GetString(c_NPCExcelFilePathKey, string.Empty);
            if (!IsVaildNPCPath(filePath))
            {
                string content = string.Concat("请选择", c_NPCExcelFileName, "文件");
                string[] filters = new string[2]
                {
                    "Excel File", c_ExcelFileExtension
                };
                filePath = EditorUtility.OpenFilePanelWithFilters(content, Application.dataPath, filters);
                if (!IsVaildNPCPath(filePath))
                {
                    EditorUtility.DisplayDialog("错误", string.Concat("未选择", c_NPCExcelFileName, "文件"), "确定");
                    return false;
                }
                EditorPrefs.SetString(c_NPCExcelFilePathKey, filePath);
            }

            foreach(var item in m_NpcInfos)
            {
                item.Value.DeleteNpc();
            }
            m_NpcInfos.Clear();

            EditorUtility.DisplayProgressBar("加载", "加载配置中", 0f);
            
            FileInfo fileInfo = new FileInfo(filePath);
            // using (var fs = new FileStream(filePath, FileMode.Open))
            {
                using(var excelPackage = new ExcelPackage(fileInfo))
                {
                    var sheets = excelPackage.Workbook.Worksheets;
                    var sheet = sheets[1];
                    int rowIndex = 4;
                    int colIndex = 1;
                    while(!string.IsNullOrEmpty(sheet.GetValue<string>(rowIndex, colIndex)))
                    {
                        NpcInfo npcInfo = new NpcInfo();
                        npcInfo.id = sheet.GetValue<int>(rowIndex, 1);
                        string positionStr = sheet.GetValue<string>(rowIndex, 2);
                        Vector3 position = Vector3.zero;
                        if (!string.IsNullOrEmpty(positionStr))
                        {
                            var positionArr = positionStr.Split(';');
                            if (positionArr.Length > 0) position.x = float.Parse(positionArr[0]);
                            if (positionArr.Length > 1) position.z = float.Parse(positionArr[1]);
                            if (positionArr.Length > 2) position.y = float.Parse(positionArr[2]);
                        }
                        npcInfo.position = position;
                        float rotationY = sheet.GetValue<float>(rowIndex, 3);
                        npcInfo.rotation = new Vector3(0, rotationY, 0);

                        npcInfo.avatarId = sheet.GetValue<int>(rowIndex, 4);

                        rowIndex += 1;
                        EditorUtility.DisplayProgressBar("加载", "加载配置中", (float)rowIndex / sheet.Cells.Rows);
                        npcInfo.CreateNpc();
                        m_NpcInfos.Add(npcInfo.id, npcInfo);
                    }
                }
            }
            EditorUtility.ClearProgressBar();
        }
        catch (Exception e)
        {
            Debug.LogException(e);
            EditorUtility.ClearProgressBar();
            EditorUtility.DisplayDialog("错误", string.Concat("无法读取", c_NPCExcelFileName, "文件数据"), "确定");
            success = false;
        }
        return success;
    }

    private bool SaveGlobalExcelData()
    {
        if (m_DiableRadius == m_DiableRadiusDefault
            && m_CollisionRadius == m_CollisionRadiusDefault
            && m_TriggerRadius == m_TriggerRadiusDefault)
            return true;
        bool success = true;
        try
        {
            string filePath = EditorPrefs.GetString(c_GlobalExcelFilePathKey, string.Empty);
            if (!IsVaildGlobalPath(filePath))
            {
                string content = string.Concat("请选择", c_GlobalExcelFileName, "文件");
                string[] filters = new string[2]
                {
                    "Excel File", c_ExcelFileExtension
                };
                filePath = EditorUtility.OpenFilePanelWithFilters(content, Application.dataPath, filters);
                if (!IsVaildGlobalPath(filePath))
                {
                    EditorUtility.DisplayDialog("错误", string.Concat("未选择", c_GlobalExcelFileName, "文件"), "确定");
                    return false;
                }
                EditorPrefs.SetString(c_GlobalExcelFilePathKey, filePath);
            }

            FileInfo fileInfo = new FileInfo(filePath);
            // using (var fs = new FileStream(filePath, FileMode.Open))
            {
                using(var excelPackage = new ExcelPackage(fileInfo))
                {
                    var sheets = excelPackage.Workbook.Worksheets;
                    var sheet = sheets[1];
                    int rowIndex = 4;
                    int colIndex = 1;
                    while(!string.IsNullOrEmpty(sheet.GetValue<string>(rowIndex, colIndex)))
                    {
                        int id = sheet.GetValue<int>(rowIndex, 1);
                        if (id == 34)
                        {
                            sheet.SetValue(rowIndex, 5, m_DiableRadius);
                            m_DiableRadiusDefault = m_DiableRadius;
                        }
                        else if (id == 35)
                        {
                            sheet.SetValue(rowIndex, 5, m_CollisionRadius);
                            m_CollisionRadiusDefault = m_CollisionRadius;
                        }
                        else if (id == 36)
                        {
                            sheet.SetValue(rowIndex, 5, m_TriggerRadius);
                            m_TriggerRadiusDefault = m_TriggerRadius;
                        }
                        rowIndex += 1;
                    }
                    excelPackage.SaveAs(fileInfo);
                }
            }
        }
        catch (Exception e)
        {
            Debug.LogException(e);
            EditorUtility.DisplayDialog("错误", string.Concat("有其它程序在使用该文件", c_GlobalExcelFileName, ", 请关闭"), "确定");
            success = false;
        }
        return success;
    }

    private bool SaveNPCExcelData()
    {
        bool success = true;
        try
        {
            string filePath = EditorPrefs.GetString(c_NPCExcelFilePathKey, string.Empty);
            if (!IsVaildNPCPath(filePath))
            {
                string content = string.Concat("请选择", c_NPCExcelFileName, "文件");
                string[] filters = new string[2]
                {
                    "Excel File", c_ExcelFileExtension
                };
                filePath = EditorUtility.OpenFilePanelWithFilters(content, Application.dataPath, filters);
                if (!IsVaildNPCPath(filePath))
                {
                    EditorUtility.DisplayDialog("错误", string.Concat("未选择", c_NPCExcelFileName, "文件"), "确定");
                    return false;
                }
                EditorPrefs.SetString(c_NPCExcelFilePathKey, filePath);
            }

            FileInfo fileInfo = new FileInfo(filePath);
            // using (var fs = new FileStream(filePath, FileMode.Open))
            {
                using(var excelPackage = new ExcelPackage(fileInfo))
                {
                    var sheets = excelPackage.Workbook.Worksheets;
                    var sheet = sheets[1];
                    int rowIndex = 4;
                    int colIndex = 1;
                    while(!string.IsNullOrEmpty(sheet.GetValue<string>(rowIndex, colIndex)))
                    {
                        int id = sheet.GetValue<int>(rowIndex, 1);
                        if (m_NpcInfos.ContainsKey(id))
                        {
                            NpcInfo npcInfo = m_NpcInfos[id];
                            npcInfo.SaveNpc();
                            string positionStr = npcInfo.position.x + ";" + npcInfo.position.z + ";" + npcInfo.position.y;
                            sheet.SetValue(rowIndex, 2, positionStr);
                            sheet.SetValue(rowIndex, 3, npcInfo.rotation.y);
                            rowIndex += 1;
                        }
                    }
                    excelPackage.SaveAs(fileInfo);
                }
            }
        }
        catch (Exception e)
        {
            Debug.LogException(e);
            EditorUtility.DisplayDialog("错误", string.Concat("有其它程序在使用该文件", c_NPCExcelFileName, ", 请关闭"), "确定");
            success = false;
        }
        return success;
    }





    [MenuItem("RO_Tool/主城Npc放置工具")]
    private static void OpenNpcSetposTool()
    {
        var window = EditorWindow.GetWindow<NpcSetposTool>("主城Npc放置");
    }
}
