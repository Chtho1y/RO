using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

[CustomEditor(typeof(SpawnPoint))]
public class SpawnPointEditor : Editor
{
    public static List<int> addedNpcList = new List<int>();
    public static List<string> addedNpcStrList = new List<string>();

    SpawnPoint sp;

    private SerializedProperty typeProperty;
    private GUIContent typeLbl = new GUIContent("Type");
    private GUIContent npcIdLbl = new GUIContent("NpcId");
    private GUIContent bossCamPosLbl = new GUIContent("Boss战镜头位置");
    private GUIContent bossCamRotLbl = new GUIContent("Boss战镜头旋转");
    private GUIContent bossCamFarLbl = new GUIContent("Boss战镜头最远距离");

    private void OnEnable()
    {
        sp = target as SpawnPoint;
    }

    void Init()
    {
        typeProperty = serializedObject.FindProperty("type");
    }

    public override void OnInspectorGUI()
    {
        serializedObject.Update();

        SpawnPointType preType = sp.type;
        sp.type = (SpawnPointType)EditorGUILayout.EnumPopup(typeLbl,sp.type);

        if(sp.type == SpawnPointType.Boss)
        {
            if(sp.TransferGo == null)
            {
                if (GUILayout.Button("添加传送位置"))
                {
                    sp.AddTransferPoint();
                }
            }
            sp.camPos = EditorGUILayout.Vector3Field(bossCamPosLbl, sp.camPos);
            sp.camRot = EditorGUILayout.Vector3Field(bossCamRotLbl, sp.camRot);
            sp.camFar = EditorGUILayout.FloatField(bossCamFarLbl, sp.camFar);
            
        }else if(sp.type == SpawnPointType.Monster && preType == SpawnPointType.Boss)
        {
            sp.DeleteTransferPoint();
        }

        if(sp.type == SpawnPointType.Monster)
        {
            sp.npcIds.Clear();
            for(int idx =0; idx < sp.spawnLocs.Count;idx++)
            {
                MonsterSpawnLoc loc = sp.spawnLocs[idx];

                EditorGUILayout.BeginHorizontal();
                loc.npcId = EditorGUILayout.IntField("NpcId" + (idx + 1), loc.npcId);
                AddNpc(loc.npcId);

                if(addedNpcList.Count > 0)
                {
                    int temp = EditorGUILayout.IntPopup(loc.npcId, addedNpcStrList.ToArray(), addedNpcList.ToArray());
                    if(temp > 0)
                    {
                        loc.npcId = temp;
                    }
                }
                sp.spawnLocs[idx] = loc;
                sp.npcIds.Add(loc.npcId);
                EditorGUILayout.EndHorizontal();
            }
        }

        sp.fHorSpace = EditorGUILayout.FloatField("水平间隔", sp.fHorSpace);
        sp.fVerSpace = EditorGUILayout.FloatField("垂直间隔", sp.fVerSpace);
        sp.fActorReadyDist = EditorGUILayout.FloatField("角色出生距离", sp.fActorReadyDist);

        if(GUILayout.Button("保存位置"))
        {
            sp.CalcPointPos();
        }

        sp.fRandomValue = EditorGUILayout.FloatField("随机距离", sp.fRandomValue);
        if(GUILayout.Button("随机位置"))
        {
            sp.RandomPos();
        }
    }

    static void AddNpc(int npcId)
    {
        if (npcId == 0) return;

        if (addedNpcList.Contains(npcId)) return;

        addedNpcList.Add(npcId);
        addedNpcStrList.Add(npcId.ToString());
    }
}