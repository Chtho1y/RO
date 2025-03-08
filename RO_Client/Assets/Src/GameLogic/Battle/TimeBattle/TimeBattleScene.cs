using UnityEngine;
using System.Collections;

public class TimeBattleScene : BaseBattleScene
{
    public TimeBattleScene(TimeBattle battle,string sceneName):
        base(battle,sceneName)
    {

    }

    public override void OnSceneLoaded()
    {
        GameObject[] rootObjs = mScene.GetRootGameObjects();
        ReadyPoint actorBornPoint = null;
        SpawnPoint enemyBornPoint = null;
        GameObject spawnPoint = rootObjs.FindFirst(a => a.name.CompareTo(Constants.actor_born_point) == 0);
        if (spawnPoint != null)
        {
            actorBornPoint = spawnPoint.GetComponent<ReadyPoint>();
        }

        spawnPoint = rootObjs.FindFirst(a => a.name.CompareTo(Constants.enemy_actor_born_point) == 0);
        if (spawnPoint != null)
        {
            enemyBornPoint = spawnPoint.GetComponent<SpawnPoint>();
            enemyBornPoint.SavePoint();
        }

        TimeBattle battle = mBattle as TimeBattle;
        battle.SetReadyPoint(actorBornPoint, enemyBornPoint);
    }
}
