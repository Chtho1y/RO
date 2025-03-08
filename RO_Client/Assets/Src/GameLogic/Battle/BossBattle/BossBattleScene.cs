using UnityEngine;
using System.Collections;
using UnityEngine.SceneManagement;

public class BossBattleScene : BaseBattleScene
{
    public BossBattleScene(BossBattle battle, string sceneName):
        base(battle,sceneName)
    {
    }

    public override void OnSceneLoaded()
    {
        GameObject[] rootObjs = mScene.GetRootGameObjects();
        ReadyPoint actorBornPoint = null;
        GameObject spawnPoint = rootObjs.FindFirst(a => a.name.CompareTo(Constants.actor_born_point) == 0);
        if (spawnPoint != null)
        {
            actorBornPoint = spawnPoint.GetComponent<ReadyPoint>();
        }

        BossBattle battle = mBattle as BossBattle;
        battle.SetActorReadyPoint(actorBornPoint);
    }
}
