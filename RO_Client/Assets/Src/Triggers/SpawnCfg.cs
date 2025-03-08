using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public delegate void SpawnPointAllDeadEvent(SpawnCfg spawnCfg);
public delegate void OnAllSpawned(SpawnCfg spawnCfg);

public class SpawnCfg : FuncRegion
{
    [HideInInspector]
    public Color PointColor = new Color(1, 0, 0);
    [HideInInspector]
    public float radius = 0.25f;

    public int ConfigId;
    public ActorType actorType;

    public SpawnCfg nextPoint;

    public event SpawnPointAllDeadEvent onAllDeadEvt;
    public event OnAllSpawned onAllSpawned;

    protected List<Fighter> mSpawnedList = new List<Fighter>();
    protected List<SpawnCfg> mSpawnCfgList = new List<SpawnCfg>();
    protected int mSpawnPointOver;


    protected virtual void Start()
    {    
    }

    protected void OnDestroy()
    {
    }

    public override void UpdateLogic(float delta)
    {

    }

    protected virtual void DecSpawnPointOver()
    {
        if (--mSpawnPointOver == 0)
        {
            if (onAllDeadEvt != null)
            {
                onAllDeadEvt(this);
            }
        }
    }

    void OnDrawGizmos()
    {
        Gizmos.color = PointColor;
        Gizmos.DrawSphere(transform.position, 0.15f);
    }

    public List<Fighter> GetSpawnedList()
    {
        return mSpawnedList;
    }
}
