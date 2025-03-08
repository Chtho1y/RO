using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;
using UnityEditor.SceneManagement;
using Mono.Xml;
using System.Security;

public class BattleLevelUtil : EditorWindow
{
    private List<SpawnPointCfg> spawnPointCfgList = new List<SpawnPointCfg>();
    private List<SpawnPoint> spawnPointList = new List<SpawnPoint>();
    public static string EditorLevelName
    {
        get
        {
            string levelName = EditorSceneManager.GetActiveScene().name;
            return levelName;
        }
    }

    public static bool s_openAddPoint = false;

    [MenuItem("RO_Tool/战场/出生点配置")]
    static void RecreateBorn()
    {
        if (Application.isPlaying)
        {
            EditorUtility.DisplayDialog("无法生成", "运行中不能执行该操作。", "确定");
            return;
        }

        BattleLevelUtil window = (BattleLevelUtil)EditorWindow.GetWindow(typeof(BattleLevelUtil));
        window.minSize = new Vector2(200, 300);
    }

    void OnGUI()
    {
        if(GUILayout.Button("加载当前场景的出生点配置"))
        {
            LoadCfg();
        }else if(GUILayout.Button("保存当前场景的出生点配置"))
        {
            SaveCfg();
        }

        if(!s_openAddPoint)
        {
            if (GUILayout.Button("开启增加出生点"))
            {
                s_openAddPoint = true;
                SceneView.onSceneGUIDelegate = OnSceneGUI;
            }
        }
        else
        {
            if (GUILayout.Button("关闭增加出生点"))
            {
                s_openAddPoint = false;
            }
        }


        if(Selection.activeGameObject!=null && Selection.activeGameObject.GetComponent<SpawnPoint>()!=null)
        {
            if(GUILayout.Button("删除当前选中的出生点"))
            {
                DeleteSpawnPoint(Selection.activeGameObject);
            }
        }
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
            if(e.type == EventType.MouseDown && e.button == 0)
            {
                GameObject go =  GameObject.FindGameObjectWithTag("Terrain");
                Vector3 worldPos = GetWorldPosition(sceneview, go.transform);
                worldPos.y = 0;
                BattleLevelUtil window = (BattleLevelUtil)EditorWindow.GetWindow(typeof(BattleLevelUtil));
                window.AddNewSpawnPoint(worldPos);
            }
        }
    }

    static Vector3 GetWorldPosition(SceneView sceneView,Transform parent)
    {
        Camera cam = sceneView.camera;
        Vector3 mousePos = Event.current.mousePosition;
        mousePos.z = -cam.worldToCameraMatrix.MultiplyPoint(parent.position).z;
        mousePos.y = cam.pixelHeight - mousePos.y;
        mousePos = sceneView.camera.ScreenToWorldPoint(mousePos);
        return mousePos;
    }
    
    //添加一个新的点
    public void AddNewSpawnPoint(Vector3 pos)
    {
        GameObject go = new GameObject("MonsterSpawnPoint" + (spawnPointList.Count+1));
        SpawnPoint sp = go.AddComponent<SpawnPoint>();
        sp.type = SpawnPointType.Monster;
        sp.transform.position = pos;
        sp.transform.rotation = Quaternion.identity;

        GameObject child = new GameObject("p1");
        child.transform.SetParent(sp.transform);
        child.transform.localEulerAngles = Vector3.zero;
        child.transform.localPosition = Vector3.forward * 1.0f + Vector3.right * -1.0f;

        child = new GameObject("p2");
        child.transform.SetParent(sp.transform);
        child.transform.localEulerAngles = Vector3.zero;
        child.transform.localPosition = Vector3.forward * 1.0f;

        child = new GameObject("p3");
        child.transform.SetParent(sp.transform);
        child.transform.localEulerAngles = Vector3.zero;
        child.transform.localPosition = Vector3.forward * 1.0f + Vector3.right * 1.0f;

        child = new GameObject("p4");
        child.transform.SetParent(sp.transform);
        child.transform.localEulerAngles = Vector3.zero;
        child.transform.localPosition = Vector3.forward * -1.0f + Vector3.right * -1.0f;

        child = new GameObject("p5");
        child.transform.SetParent(sp.transform);
        child.transform.localEulerAngles = Vector3.zero;
        child.transform.localPosition = Vector3.forward * -1.0f;

        child = new GameObject("p6");
        child.transform.SetParent(sp.transform);
        child.transform.localEulerAngles = Vector3.zero;
        child.transform.localPosition = Vector3.forward * -1.0f + Vector3.right * 1.0f;

        sp.SavePoint();

        SpawnPointCfg spCfg = new SpawnPointCfg();
        spCfg.SaveCfg(sp);

        spawnPointList.Add(sp);
        spawnPointCfgList.Add(spCfg);
        sp.tag = "SpawnPoint";
    }

    //删除一个新的点
    void DeleteSpawnPoint(GameObject spGo)
    {
        if (spGo == null) return;

        SpawnPoint sp = spGo.GetComponent<SpawnPoint>();
        if (sp == null) return;

        RemoveCfg(sp);
        spawnPointList.Remove(sp);
        GameObject.DestroyImmediate(spGo);
    }

    void RemoveCfg(SpawnPoint sp)
    {
        for(int idx =0; idx < spawnPointCfgList.Count;idx++)
        {
            if(spawnPointCfgList[idx].CurrentSpawnPoint == sp)
            {
                spawnPointCfgList.RemoveAt(idx);
                break;
            }
        }
    }

    void ClearAll()
    {
        for(int idx =0; idx < spawnPointList.Count;idx++)
        {
            if(spawnPointList[idx]!=null)
                GameObject.DestroyImmediate(spawnPointList[idx].gameObject);
        }

        GameObject[] spGoes = GameObject.FindGameObjectsWithTag("SpawnPoint");
        for (int idx = 0; idx < spGoes.Length; idx++)
            GameObject.DestroyImmediate(spGoes[idx]);
    }

    void LoadCfg()
    {
        string cfgFileName = "Born_" + EditorLevelName + ".xml";
        string filePath = Application.dataPath + "/Content/Xml/" + cfgFileName;

        if (!FileSystem.Exists(filePath))
        {
            Debug.LogError("未生成过场景的出生点配置文件");
            return;
        }

        TextAsset ta = AssetDatabase.LoadAssetAtPath<TextAsset>(Constants.XmlConfig+"/"+cfgFileName);
        if(ta == null)
        {
            Debug.LogError("配置文件有问题");
            return;
        }

        ClearAll();
        spawnPointCfgList.Clear();
        spawnPointList.Clear();

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

        SecurityElement root = doc.SelectSingleNode("SpawnPoints");
        if (root == null || root.Children == null) return;
        for (int idx = 0; idx < root.Children.Count; idx++)
        {
            var spNode = root.Children[idx] as SecurityElement;
            SpawnPointCfg spCfg = new SpawnPointCfg();
            spCfg.LoadCfgXml(spNode);
            spawnPointCfgList.Add(spCfg);
        }

        for(int idx =0; idx < spawnPointCfgList.Count;idx++)
        {
            SpawnPointCfg spCfg = spawnPointCfgList[idx];
            SpawnPoint sp = CreateSpawnPointGo(spCfg, idx + 1);
        }
    }

    void SaveCfg()
    {
        string cfgFileName = "Born_" + EditorLevelName + ".xml";
        string filePath = Application.dataPath + "/Content/Xml/" + cfgFileName;

        SecurityElement root = new SecurityElement("SpawnPoints");
        for(int idx =0; idx < spawnPointCfgList.Count;idx++)
        {
            SpawnPointCfg cfg = spawnPointCfgList[idx];
            SecurityElement spNode = cfg.SaveCfgToXml();
            root.AddChild(spNode);
        }
         
        SecurityTools.DumpSecurityElementToXml(root, filePath);
        AssetDatabase.Refresh();
    }

    SpawnPoint CreateSpawnPointGo(SpawnPointCfg cfg, int cnt)
    {
        GameObject go = new GameObject("MonsterSpawnPoint" + cnt);
        SpawnPoint sp = go.AddComponent<SpawnPoint>();
        sp.type = cfg.PointType;
        sp.transform.position = cfg.Pos;
        sp.transform.eulerAngles = cfg.Rot;
        sp.fActorReadyDist = cfg.ActorReadyDist;
        sp.fHorSpace = cfg.HorSpace;
        sp.fVerSpace = cfg.VerSpace;

        for(int idx =0; idx < cfg.PointList.Count;idx++)
        {
            MonsterSpawnLoc pLoc = cfg.PointList[idx];
            GameObject child = new GameObject("p" +(idx+1));
            child.transform.SetParent(sp.transform);
            child.transform.eulerAngles = pLoc.rot;
            child.transform.position = pLoc.pos;
            sp.npcIds.Add(pLoc.npcId);
        }

        if(cfg.PointType == SpawnPointType.Boss)
        {
            GameObject child = new GameObject("transfer");
            child.transform.SetParent(sp.transform);
            child.transform.eulerAngles = cfg.TransferRot;
            child.transform.position = cfg.TransferPos;
            sp.camPos = cfg.BossCamPos;
            sp.camRot = cfg.BossCamRot;
            sp.camFar = cfg.CamFar;
        }

        sp.SavePoint();
        spawnPointList.Add(sp);
        cfg.CurrentSpawnPoint = sp;
        sp.tag = "SpawnPoint";

        return sp;
    }
}