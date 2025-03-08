using UnityEngine;
using System.Collections.Generic;

public class LogicBattleStartInfo
{
	public SceneItem curSceneItem;
	public LevelItem curLevelItem;

	public string leftPlayerName;
	public string rightPlayerName;

    private int mStartBattleIdx = 0;
    public int StartBattleIdx
    {
        get { return mStartBattleIdx; }
    }

	public LogicBattleStartInfo (int sceneId, int levelId, bool offline = false)
	{
        if (sceneId > 0 && levelId > 0) {
            this.curSceneItem = new SceneItem(sceneId);
			this.curLevelItem = this.curSceneItem.GetLevelItem(levelId);
            mStartBattleIdx = this.curSceneItem.GetLevelIndex(curLevelItem.LevelId);

            if (this.curLevelItem.LevelId != levelId) {
				DebugHelper.LogError ("invalid dungeon {0}:{1}", sceneId, levelId);
				return;
			}
        }
        else
        {
            DebugHelper.LogError(string.Format("{0} scene {1} level 参入出错", sceneId, levelId));
        }

	}

	public int SceneId { get { return curLevelItem != null ? curLevelItem.MapId : 0; } }

	public int LevelId { get { return curLevelItem != null ? curLevelItem.LevelId : 0; } }

	public int LevelType { get { return SceneData.SCENE_TYPE_COMMON; } }

	public List<ActorData> GetMyFighters ()
	{
        List<ActorData> fighters = new List<ActorData>();
        //List<ActorData> teamActors = GameMgr.Instance.CharacterInfo.NormleBattleTeamActors;
        List<ActorData> teamActors = GameMgr.Instance.CharacterInfo.TeamActors;
        if (teamActors != null)
        {
            for (int idx = 0; idx < teamActors.Count; idx++)
            {
                ActorData actor = teamActors[idx];
                fighters.Add(actor);
                if (actor.HasPet)
                {
                    fighters.Add(actor.PetData);
                }
            }
        }
        return fighters;
    }

	public List<ActorData> GetEnemyFighters (LogicBattleScene battleScene)
	{
		List<ActorData> fighters = new List<ActorData> ();

        int curLevelIdx = 0;
        if (curLevelItem != null)
        {
            curLevelIdx = curSceneItem.GetLevelIndex(curLevelItem.LevelId);
        }

        for(int idx = curLevelIdx; idx < curSceneItem.LevelNum; idx++)
        {
            LevelItem li = curSceneItem.LevelItems[idx];
            if (li.BossActor != null)
            {
                fighters.Add(li.BossActor);
            }
            
            if(li.Monsters!=null)
            {
                for(int mdx = 0; mdx < li.Monsters.Count;mdx++)
                {
                    fighters.Add(li.Monsters[mdx]);
                }
            }
        }

        for(int idx = 0;idx < battleScene.SpawnPointList.Count;idx++)
        {
            SpawnPointCfg cfg = battleScene.SpawnPointList[idx];
            for(int jdx =0;jdx < cfg.PointList.Count;jdx++)
            {
                var loc = cfg.PointList[jdx];
                if(loc.npcId > 0)
                {
                    ActorData npcActor = BattleActorMgr.Instance.GetNpcActorData(CommonUtil.CalcPointUniqueId(curSceneItem.MapId, idx + 1, jdx), loc.npcId);
                    fighters.Add(npcActor);
                    loc.npcInstanceId = npcActor.ID;
                    cfg.PointList[jdx] = loc;

                }
            }
        }
		return fighters;
	}
}
