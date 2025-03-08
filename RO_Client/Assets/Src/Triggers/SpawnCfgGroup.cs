using UnityEngine;
using System.Collections;
using System.Security;

public class SpawnCfgGroup : SpawnCfg
{
    [HideInInspector]
    public int GroupId;

    [FriendlyName("需要触发器")]
    public bool bTriggerSpawn;

    private Color GroupColor = new Color(0.8f, 0.1f, 0.1f, 0.8f);
    private SpawnCfg[] drawPoints = null;

    private bool bSpawned = false;

    protected override void Start()
    {
        SpawnCfg next = nextPoint;
#if UNITY_EDITOR
        int nTmp = 0;
#endif
        while (next)
        {
            mSpawnCfgList.Add(next);
            next.onAllDeadEvt += this.onSpawnPointAllDead;
            next = next.nextPoint;
#if UNITY_EDITOR
            if (++nTmp > 100)
            {
                DebugHelper.LogError("超过100个，tm死循环了吧！！");
                break;
            }
#endif
        }

        base.Start();
    }

    public override void UpdateLogic(float delta)
    {
        if (!isStartup)
        {
            return;
        }
    }

    public override void Stop()
    {
        base.Stop();

        mSpawnedList.Clear();
    }

    protected override void DecSpawnPointOver()
    {
        base.DecSpawnPointOver();
    }

    public override void Startup()
    {
        if (!bTriggerSpawn && !isStartup)
        {
            base.Startup();
        }
    }

    public void TriggerStartUp()
    {
        if (!isStartup)
        {
            base.Startup();
        }
    }

    private SpawnCfg[] FindChildrenPoints()
    {
        return GetComponentsInChildren<SpawnCfg>(); // parent always the 1st
    }

    protected void onSpawnPointAllDead(SpawnCfg inSpawnPoint)
    {
        if (mSpawnCfgList.Contains(inSpawnPoint))
        {
            DecSpawnPointOver();
        }
    }

    void OnDrawGizmos()
    {
        Gizmos.color = GroupColor;
        Gizmos.DrawSphere(transform.position, 0.3f);

        drawPoints = FindChildrenPoints();

        if (drawPoints != null && drawPoints.Length > 0)
        {
            Gizmos.color = GroupColor;

            for (int i = 0; i < drawPoints.Length - 1; ++i)
            {
                var Start = drawPoints[0].gameObject.transform.position;
                var End = drawPoints[i + 1].gameObject.transform.position;

                var direction = (End - Start).normalized;

                var Length = Vector3.Distance(End, Start) - drawPoints[i + 1].radius - drawPoints[0].radius;

                Start = Start + direction * drawPoints[0].radius;
                End = Start + direction * Length;
                Gizmos.DrawLine(Start, End);

                drawPoints[i + 1].PointColor = GroupColor;
            }

            // draw start icon
            Gizmos.DrawIcon(
                    new Vector3(drawPoints[0].transform.position.x,
                        drawPoints[0].transform.position.y + drawPoints[0].radius * 3.0f,
                        drawPoints[0].transform.position.z
                        ),
                    "StartPoint",
                    true
                );
        }
    }
}
