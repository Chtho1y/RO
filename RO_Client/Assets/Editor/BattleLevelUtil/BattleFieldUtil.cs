using UnityEngine;
using UnityEditor;
using System.Collections.Generic;
using Mono.Xml;
using System.Security;

public class BattleFieldUtil : EditorWindow
{
    private TowerTeamBornInfoPoint teamBornInfo = null;
    private List<TowerBattleInfo> battleFieldList = new List<TowerBattleInfo>();
    private List<TowerBattleInfoPoint> pointList = new List<TowerBattleInfoPoint>();

    public static bool s_openAddPoint = false;

    private GameObject teamBornGo = null;

    [MenuItem("RO_Tool/战场/战场区域配置")]
    static void CreateBattleField()
    {
        if (Application.isPlaying)
        {
            EditorUtility.DisplayDialog("无法生成", "运行中不能执行该操作。", "确定");
            return;
        }

        BattleFieldUtil window = (BattleFieldUtil)EditorWindow.GetWindow(typeof(BattleFieldUtil));
        window.minSize = new Vector2(200, 300);
    }

    private void OnEnable()
    {
        teamBornGo = GameObject.Find("TeamBorn");
        if (teamBornGo == null)
        {
            teamBornGo = new GameObject("TeamBorn");
            teamBornGo.transform.position = Vector3.zero;
            teamBornGo.transform.rotation = Quaternion.identity;
        }

        teamBornInfo = teamBornGo.GetComponent<TowerTeamBornInfoPoint>();
        if (teamBornInfo == null)
            teamBornInfo = teamBornGo.AddComponent<TowerTeamBornInfoPoint>();
    }

    void OnGUI()
    {
        if (GUILayout.Button("加载当前场景的出生点配置"))
        {
            LoadCfg();
        }
        else if (GUILayout.Button("保存当前场景的出生点配置"))
        {
            SaveCfg();
        }

        if (!s_openAddPoint)
        {
            if (GUILayout.Button("添加新的战场"))
            {
                s_openAddPoint = true;
                SceneView.onSceneGUIDelegate = OnSceneGUI;
            }
        }
        else
        {
            if (GUILayout.Button("关闭增加战场"))
            {
                s_openAddPoint = false;
            }
        }


        if (Selection.activeGameObject != null && Selection.activeGameObject.GetComponent<TowerBattleInfoPoint>() != null)
        {
            if (GUILayout.Button("删除当前选中的战场点"))
            {
                DeleteBattleField(Selection.activeGameObject);
            }
        }
    }

    TowerBattleInfoPoint CreatePointGo(TowerBattleInfo cfg, int cnt)
    {
        GameObject go = GameObject.CreatePrimitive(PrimitiveType.Capsule);
        go.name = "BattleField" + cnt;
        go.transform.localScale = new Vector3(5,5,5);
        TowerBattleInfoPoint point = go.AddComponent<TowerBattleInfoPoint>();
        point.transform.position = cfg.fieldPos;
        point.transform.eulerAngles = cfg.fieldRot;
        point.spawnDist = cfg.spawnDist;
        point.battleDist = cfg.battleDist;

        if(cfg.CamCfgList!=null)
        {
            if (point.CamCfgList == null)
                point.CamCfgList = new List<MapCameraConfig>();
            else
                point.CamCfgList.Clear();

            point.CamCfgList.AddRange(cfg.CamCfgList);
        }

        pointList.Add(point);
        cfg.Point = point;
        point.tag = "SpawnPoint";

        return point;
    }

    public void AddNewBattleField(Vector3 pos)
    {
        GameObject go = GameObject.CreatePrimitive(PrimitiveType.Capsule);
        go.name = "BattleField" + (pointList.Count + 1);
        go.transform.localScale = new Vector3(5, 5, 5);
        TowerBattleInfoPoint point = go.AddComponent<TowerBattleInfoPoint>();
        point.transform.position = pos;
        point.transform.rotation = Quaternion.identity;

        TowerBattleInfo newBI = new TowerBattleInfo();
        newBI.SaveCfg(point);
        battleFieldList.Add(newBI);
        pointList.Add(point);
        point.tag = "SpawnPoint";
    }

    public void DeleteBattleField(GameObject go)
    {
        if (go == null) return;

        TowerBattleInfoPoint point = go.GetComponent<TowerBattleInfoPoint>();
        if (point == null) return;

        RemoveCfg(point);
        pointList.Remove(point);
        GameObject.DestroyImmediate(go);
    }

    void RemoveCfg(TowerBattleInfoPoint point)
    {
        for(int idx =0; idx < battleFieldList.Count;idx++)
        {
            if(battleFieldList[idx].Point == point)
            {
                battleFieldList.RemoveAt(idx);
                break;
            }
        }
    }

    void LoadCfg()
    {
        string cfgFileName = "TowerBattleCfg.xml";
        string filePath = Application.dataPath + "/Content/Xml/" + cfgFileName;

        if (!FileSystem.Exists(filePath))
        {
            Debug.LogError("爬塔战场配置文件不存在");
            return;
        }

        TextAsset ta = AssetDatabase.LoadAssetAtPath<TextAsset>(Constants.XmlConfig + "/" + cfgFileName);
        if (ta == null)
        {
            Debug.LogError("配置文件有问题");
            return;
        }

        ClearAll();
        battleFieldList.Clear();
        pointList.Clear();

        SecurityParser doc = new SecurityParser();
        try
        {
            doc.LoadXml(ta.text);
        }
        catch (System.Exception e)
        {
            DebugHelper.Assert(false, "exception = {0}", e.Message);
            return;
        }

        SecurityElement root = doc.SelectSingleNode("BattleFields");
        if (root == null || root.Children == null) return;
        for (int idx = 0; idx < root.Children.Count; idx++)
        {
            var node = root.Children[idx] as SecurityElement;
            if(node.Tag.CompareTo("BattleField") == 0)
            {
                TowerBattleInfo battleFieldCfg = new TowerBattleInfo();
                battleFieldCfg.LoadCfgXml(node);
                battleFieldList.Add(battleFieldCfg);
            }
            else if(node.Tag.CompareTo("TeamBorn") == 0)
            {
                teamBornInfo.LoadCfgXml(node);
            }
        }

        for (int idx = 0; idx < battleFieldList.Count; idx++)
        {
            TowerBattleInfo cfg = battleFieldList[idx];
            TowerBattleInfoPoint sp = CreatePointGo(cfg, idx + 1);
        }
    }

    void SaveCfg()
    {
        string cfgFileName = "TowerBattleCfg.xml";
        string filePath = Application.dataPath + "/Content/Xml/" + cfgFileName;

        SecurityElement root = new SecurityElement("BattleFields");
        for (int idx = 0; idx < battleFieldList.Count; idx++)
        {
            TowerBattleInfo cfg = battleFieldList[idx];
            SecurityElement node = cfg.SaveCfgToXml();
            root.AddChild(node);
        }

        SecurityElement bornNode = teamBornInfo.SaveCfgToXml();
        root.AddChild(bornNode);

        SecurityTools.DumpSecurityElementToXml(root, filePath);
        AssetDatabase.Refresh();
    }

    void ClearAll()
    {
        for (int idx = 0; idx < pointList.Count; idx++)
        {
            if (pointList[idx] != null)
                GameObject.DestroyImmediate(pointList[idx].gameObject);
        }

        GameObject[] points = GameObject.FindGameObjectsWithTag("SpawnPoint");
        for (int idx = 0; idx < points.Length; idx++)
            GameObject.DestroyImmediate(points[idx]);
    }

    public static bool IsLimitSceneSelectGameObject = true;

    static void OnSceneGUI(SceneView sceneview)
    {
        Event e = Event.current;

        int controlID = GUIUtility.GetControlID(FocusType.Passive);

        if (IsLimitSceneSelectGameObject && e.type == EventType.Layout)
        {
            HandleUtility.AddDefaultControl(controlID);
        }

        if (IsLimitSceneSelectGameObject && s_openAddPoint)
        {
            if (e.type == EventType.MouseDown && e.button == 0)
            {
                GameObject go = GameObject.FindGameObjectWithTag("Terrain");
                Vector3 worldPos = GetWorldPosition(sceneview, go.transform);
                worldPos.y = 0;
                BattleFieldUtil window = (BattleFieldUtil)EditorWindow.GetWindow(typeof(BattleFieldUtil));
                window.AddNewBattleField(worldPos);
            }
        }
    }

    static Vector3 GetWorldPosition(SceneView sceneView, Transform parent)
    {
        Camera cam = sceneView.camera;
        Vector3 mousePos = Event.current.mousePosition;
        mousePos.z = -cam.worldToCameraMatrix.MultiplyPoint(parent.position).z;
        mousePos.y = cam.pixelHeight - mousePos.y;
        mousePos = sceneView.camera.ScreenToWorldPoint(mousePos);
        return mousePos;
    }
}