using UnityEngine;
using System.Collections.Generic;

public class SpawnPoint : MonoBehaviour
{
    public List<MonsterSpawnLoc> spawnLocs = new List<MonsterSpawnLoc>();

    [SerializeField]
    public SpawnPointType type = SpawnPointType.Monster;        //出生点类型：0

    private GameObject transferGo = null;

    public GameObject TransferGo
    {
        get { return transferGo; }
    }

    public float fRandomValue = 1;
    public float fHorSpace = 1.0f;
    public float fVerSpace = 1.0f;
    public float fActorReadyDist = 3;

    public Vector3 transferPos;
    public Vector3 transferRot;
    public Vector3 camPos;
    public Vector3 camRot;
    public float camFar;

    public List<int> npcIds = new List<int>();


    public void SavePoint()
    {
        //DebugHelper.LogError("npcIds:" + npcIds.Count);
        int pointCnt = transform.childCount;
        spawnLocs = new List<MonsterSpawnLoc>();
        for (int idx = 0; idx < pointCnt; idx++)
        {
            Transform child = transform.Find("p" + (idx + 1));
            if (child != null)
            {
                MonsterSpawnLoc loc = new MonsterSpawnLoc();
                loc.pos = child.position;
                loc.rot = child.eulerAngles;
                if (idx <= npcIds.Count - 1)
                    loc.npcId = npcIds[idx];
                else
                    loc.npcId = 0;
                spawnLocs.Add(loc);
            }
        }

        Transform transferTrans = transform.Find("transfer");
        if (transferTrans != null)
        {
            if (type == SpawnPointType.Boss)
            {
                transferPos = transferTrans.position;
                transferRot = transferTrans.eulerAngles;
            }
            else
            {
                GameObject.Destroy(transferTrans.gameObject);
                transferGo = null;
            }
        }
    }

    public void RandomPos()
    {
        if (fRandomValue < 1) return;

        for (int idx = 0; idx < 2; idx++)
        {
            int step = idx == 0 ? 1 : -1;
            for (int jdx = 0; jdx < 3; jdx++)
            {
                int cursor = (idx * 3 + jdx) + 1;

                Vector3 pos = Vector3.forward * step * fVerSpace + Vector3.right * (jdx - 1) * fHorSpace;
                if (cursor != 2)
                {
                    pos.x = pos.x + Random.Range(-fRandomValue, fRandomValue);
                    pos.z = pos.z + Random.Range(-fRandomValue, fRandomValue);
                }

                Transform child = transform.Find("p" + cursor);
                if (child != null)
                    child.localPosition = pos;
            }
        }

        SavePoint();
    }

    public void CalcPointPos()
    {
        for (int idx = 0; idx < 2; idx++)
        {
            int step = idx == 0 ? 1 : -1;
            for (int jdx = 0; jdx < 3; jdx++)
            {
                Vector3 pos = Vector3.forward * step * fVerSpace + Vector3.right * (jdx - 1) * fHorSpace;
                int cursor = (idx * 3 + jdx) + 1;
                Transform child = transform.Find("p" + cursor);
                if (child != null)
                    child.localPosition = pos;
            }
        }

        SavePoint();
    }

    public void AddTransferPoint()
    {
        Vector3 transferPos = this.transform.position + this.transform.forward * 5;
        if (transferGo == null)
        {
            transferGo = new GameObject("transfer");
            transferGo.transform.SetParent(this.transform);
        }

        transferGo.transform.position = transferPos;
    }

    public void DeleteTransferPoint()
    {
        Transform transferTrans = transform.Find("transfer");
        if (transferTrans != null)
        {
            GameObject.DestroyImmediate(transferTrans.gameObject);
            transferGo = null;
        }
    }

#if UNITY_EDITOR
    private void OnDrawGizmos()
    {
        for (int jdx = 0; jdx < this.transform.childCount; jdx++)
        {
            Transform child = this.transform.GetChild(jdx);
            DrawPoint(child.position,child.rotation);
        }

    }

    void DrawPoint(Vector3 pos,Quaternion rot)
    {
        Gizmos.color = Color.red;
        Gizmos.DrawSphere(pos,0.1f);

        UnityEditor.Handles.color = Color.blue;
        UnityEditor.Handles.ArrowHandleCap(0, pos, rot, transform.localScale.z, EventType.Repaint);
        UnityEditor.Handles.Disc(rot, pos, Vector3.up, transform.localScale.z * 0.5f, false, 1);
    }
#endif
}
