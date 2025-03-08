using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(TowerTeamBornInfoPoint))]
public class TowerTeamBornInfoEditor : Editor
{
    TowerTeamBornInfoPoint bornInfo;
    GameObject camTarget;
    Camera cam;

    private void OnEnable()
    {
        bornInfo = target as TowerTeamBornInfoPoint;
        camTarget = GameObject.Find("camera_target");
        if(camTarget!=null)
        {
            cam = camTarget.GetComponentInChildren<Camera>();
        }
    }

    public override void OnInspectorGUI()
    {
        serializedObject.Update();

        EditorGUILayout.BeginVertical();
        for(int idx = 0; idx < bornInfo.bornPosList.Length;idx++)
        {
            Vector3 pos = bornInfo.bornPosList[idx];
            pos = EditorGUILayout.Vector3Field(string.Format("玩家{0}位置:", (idx + 1)), pos);
            bornInfo.bornPosList[idx] = pos;
        }

        bornInfo.camPos = EditorGUILayout.Vector3Field("出生时相机位置:", bornInfo.camPos);
        bornInfo.camRot = EditorGUILayout.Vector3Field("出生点相机旋转:", bornInfo.camRot);
        bornInfo.fov = EditorGUILayout.FloatField("出生时相机fov:", bornInfo.fov);

        EditorGUILayout.EndVertical();
    }
}
