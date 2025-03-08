using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(TowerBattleInfoPoint))]
public class TowerBattleInfoPointEditor : Editor
{
    TowerBattleInfoPoint point;

    private void OnEnable()
    {
        point = target as TowerBattleInfoPoint;
    }

    public override void OnInspectorGUI()
    {
        serializedObject.Update();

        EditorGUILayout.BeginVertical();
        point.spawnDist = EditorGUILayout.FloatField("对手出生距离", point.spawnDist,GUILayout.Width(200));
        point.battleDist = EditorGUILayout.FloatField("双方开战距离", point.battleDist,GUILayout.Width(200));

        EditorGUILayout.LabelField("相机配置:", GUILayout.Width(300));
        if(point.CamCfgList!=null)
        {
            GameObject camGo = GameObject.Find("camera_target");

            for (int idx =0; idx < point.CamCfgList.Count;idx++)
            {
                MapCameraConfig camCfg = point.CamCfgList[idx];
                camCfg.pos = EditorGUILayout.Vector3Field("相机位置:", camCfg.pos, GUILayout.Width(200));
                camCfg.rot = EditorGUILayout.Vector3Field("相机旋转:", camCfg.rot, GUILayout.Width(200));
                camCfg.fov = EditorGUILayout.FloatField("相机FOV:", camCfg.fov, GUILayout.Width(200));
                camCfg.moveSpeed = EditorGUILayout.FloatField("相机移动速度:", camCfg.moveSpeed, GUILayout.Width(200));
                camCfg.rotSpeed = EditorGUILayout.FloatField("相机旋转速度:", camCfg.rotSpeed, GUILayout.Width(200));
                camCfg.fovSpeed = EditorGUILayout.FloatField("相机FOV速度:", camCfg.fovSpeed, GUILayout.Width(200));

                if (GUILayout.Button("查看镜头"))
                {
                    if (camGo != null)
                    {
                        camGo.transform.position = camCfg.pos;
                        camGo.transform.rotation = Quaternion.Euler(camCfg.rot);
                        Camera cam = camGo.GetComponentInChildren<Camera>();
                        if (cam != null)
                            cam.fieldOfView = camCfg.fov;
                    }   
                }
                else if(GUILayout.Button("删除镜头"))
                {
                    point.CamCfgList.RemoveAt(idx);
                    return;
                }
            }
        }

        if(GUILayout.Button("添加新镜头"))
        {
            MapCameraConfig newCamCfg = new MapCameraConfig();
            if (point.CamCfgList == null)
                point.CamCfgList = new System.Collections.Generic.List<MapCameraConfig>();

            point.CamCfgList.Add(newCamCfg);
        }

        GameObject actorBornGo = GameObject.Find("ActorBornPoint");
        if (actorBornGo != null)
        {
            ReadyPoint rp = actorBornGo.GetComponent<ReadyPoint>();
            if (rp != null)
            {
                Vector3 center = point.transform.position + point.transform.forward * point.battleDist;
                Vector3 rot = point.transform.rotation.eulerAngles;
                rot.y = 180 + rot.y;
                rp.CalcNextBattleFieldPoints(center, rot);
            }
        }

        GameObject enemyBornGo = GameObject.Find("EnemyActorBornPoint");
        if (enemyBornGo != null)
        {
            ReadyPoint rp = actorBornGo.GetComponent<ReadyPoint>();
            if (rp != null)
            {
                Vector3 center = point.transform.position - point.transform.forward * point.battleDist;
                Vector3 rot = point.transform.rotation.eulerAngles;
                rp.CalcNextBattleFieldPoints(center, rot);
            }
        }
        EditorGUILayout.EndVertical();
    }
}