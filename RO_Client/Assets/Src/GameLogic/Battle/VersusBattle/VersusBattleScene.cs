using UnityEngine;
using System.Collections;
using UnityEngine.SceneManagement;

public class VersusBattleScene : BaseBattleScene
{
    public VersusBattleScene(VersusBattle battle):
        base(battle,battle.SceneName)
    {
    }

    public override void OnSceneLoaded()
    {
        GameObject[] rootObjs = mScene.GetRootGameObjects();
        ReadyPoint actorBornPoint = null, enemyBornPoint = null;
        GameObject spawnPoint = rootObjs.FindFirst(a => a.name.CompareTo(Constants.actor_born_point) == 0);
        if (spawnPoint != null)
        {
            actorBornPoint = spawnPoint.GetComponent<ReadyPoint>();
        }

        spawnPoint = rootObjs.FindFirst(a => a.name.CompareTo(Constants.enemy_actor_born_point) == 0);
        if (spawnPoint != null)
        {
            enemyBornPoint = spawnPoint.GetComponent<ReadyPoint>();
        }

        VersusBattle battle = mBattle as VersusBattle;
        battle.SetReadyPoint(actorBornPoint, enemyBornPoint);
    }
}
