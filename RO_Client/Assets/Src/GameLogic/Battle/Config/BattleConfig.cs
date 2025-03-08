using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class BattleConfig : MonoBehaviour
{
    private List<SpawnPointCfg> mSpawnPointList;
    public List<SpawnPointCfg> SpawnPointList
    {
        get { return mSpawnPointList; }
    }

    public void AddSpawnPoint(SpawnPointCfg sp)
    {
        mSpawnPointList.Add(sp);
    }

    public void DeleteSpawnPoint(SpawnPointCfg sp)
    {
        mSpawnPointList.Remove(sp);
    }
}
