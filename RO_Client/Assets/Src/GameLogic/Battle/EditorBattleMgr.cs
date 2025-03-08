#if UNITY_EDITOR
using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;

public class EditorBattleMgr : SingletonMono<EditorBattleMgr>
{
    LogicBattleField battleField = null;
    FighterManager fighterMgr = null;
    ReadyPoint actorSpawnPoint = null;
    SpawnPoint monsterSpawnPoint = null;

    bool bInitedFighter = false;
    bool bStartGame = false;

    public override void InitMgr()
    {
        base.InitMgr();    
    }

    private void Start()
    {
        Constants.isOffline = true;
        EventMgr.AddEventListener<int>(ECoreEventType.EID_ConfigMgrInit, OnCfgLoaded);
        MusicMgr.Instance.InitMgr();
        ConfigMgr.CreateInstance();

        GameObject readyPointGo = GameObject.Find("ActorBornPoint");
        if(readyPointGo!=null)
        {
            actorSpawnPoint = readyPointGo.GetComponent<ReadyPoint>();
        }

        GameObject spawnPointGo = GameObject.Find("SpawnPoint");
        if(spawnPointGo!=null)
        {
            monsterSpawnPoint = spawnPointGo.GetComponent<SpawnPoint>();
        }
    }

    private void OnCfgLoaded(CoreEvent<int> ce)
    {
        if(ce.Data == 1)
        {
            StartGame();
        }
    }

    void Update()
    {
        if (!bInitedFighter)
        {
            if(bStartGame && !BattlePrepareManager.Instance.IsLoading)
            {
                Spawn();
            }
            return;
        }

        if(battleField != null)
        {
            battleField.Update(Time.deltaTime);
        }

        if (fighterMgr != null)
        {
            fighterMgr.FixedUpdateByEditor(Time.deltaTime);
            EffectManager.Instance.Update(Time.deltaTime);
        }
    }


    public void Restart()
    {
        EndGame();
        StartGame();
    }

    public void StartGame()
    {
        if(actorSpawnPoint == null)
        {
            EditorUtility.DisplayDialog("错误", "角色出生点没有，请配置！！", "确定");
            return;
        }

        if(monsterSpawnPoint == null)
        {
            EditorUtility.DisplayDialog("错误", "怪物出生点没有，请配置!", "确定");
            return;
        }


        List<ActorData> teamActors = new List<ActorData>();
        List<ActorData> enemyActors = new List<ActorData>();

        for (int idx = 0; idx < 4; idx++)
        {
            string idKey = string.Format("TrainCamp_HeroID_{0}", idx);
            string levelKey = string.Format("TrainCamp_HeroLevel_{0}", idx);
            string skillIdKey = string.Format("TrainCamp_HeroSkillId_{0}", idx);
            string skillLvKey = string.Format("TrainCamp_HeroSkillLv_{0}", idx);
            string genderKey = string.Format("TrainCamp_Gender_{0}", idx);
            string invincibleKey = string.Format("TrainCamp_Invincible_{0}", idx);

            int id = 0, lv = 0, skillId = 0, skillLv = 0;
            Role_Gender gender = Role_Gender.Male;
            bool invincible = false;

            if (PlayerPrefs.HasKey(idKey))
                id = PlayerPrefs.GetInt(idKey);

            if (PlayerPrefs.HasKey(levelKey))
                lv = PlayerPrefs.GetInt(levelKey);

            if (PlayerPrefs.HasKey(skillIdKey))
                skillId = PlayerPrefs.GetInt(skillIdKey);

            if (PlayerPrefs.HasKey(skillLvKey))
                skillLv = PlayerPrefs.GetInt(skillLvKey);

            if (PlayerPrefs.HasKey(genderKey))
                gender = (Role_Gender)PlayerPrefs.GetInt(genderKey);

            if (PlayerPrefs.HasKey(invincibleKey))
                invincible = PlayerPrefs.GetInt(invincibleKey) > 0 ? true : false;

            if (id >0 && lv > 0 && skillId > 0 && skillLv > 0)
            {
                SkillParam skill = new SkillParam();
                skill.skillId = skillId;
                skill.skillLv = skillLv;

                List<SkillParam> skills = new List<SkillParam>();
                skills.Add(skill);

                ActorData hero = null;
                if (idx == 0)
                {
                    HeroActorData temp = ActorData.CreatePlayerActor(100000 + idx, id * 10 + (int)gender, lv, skills!=null?skills.ToArray():null) as HeroActorData;
                    temp.SetProfessionId(id);
                    hero = temp;
                }
                else
                {
                    hero = ActorData.CreateFellowActor(100000 + idx, id, lv, skills!=null?skills.ToArray():null);
                }

                hero.Invincible = invincible;
                teamActors.Add(hero);
            }
        }

        for (int idx = 0; idx < 6; idx++)
        {
            string idKey = string.Format("TrainCamp_NpcID_{0}", idx);
            string levelKey = string.Format("TrainCamp_NpcLevel_{0}", idx);
            string posKey = string.Format("TrainCamp_NpcPos_{0}", idx);
            string invincibleKey = string.Format("TrainCamp_NpcInvincible_{0}", idx);

            int id = 0, level = 0, pos = 1;
            bool invincible = false;

            if (PlayerPrefs.HasKey(idKey))
                id = PlayerPrefs.GetInt(idKey);

            if (PlayerPrefs.HasKey(levelKey))
                level = PlayerPrefs.GetInt(levelKey);
            else
                level = 1;

            if (PlayerPrefs.HasKey(posKey))
                pos = PlayerPrefs.GetInt(posKey);

            if (PlayerPrefs.HasKey(invincibleKey))
                invincible = PlayerPrefs.GetInt(invincibleKey) > 0 ? true : false;

            if (id > 0 && level > 0 )
            {
                ActorData npc = ActorData.CreateNpcPlayerActor(200000+ idx, id, level);
                npc.PositionValue = pos;
                npc.Invincible = invincible;
                enemyActors.Add(npc);
            }
        }

        if (teamActors.Count == 0)
        {
            EditorUtility.DisplayDialog("错误", "我方英雄没有一个合格的测试者", "确定");
            return;
        }

        if(enemyActors.Count == 0)
        {
            EditorUtility.DisplayDialog("错误", "请正确部署最少一个怪", "确定");
            return;
        }

        bool enableLog = false;
        if(PlayerPrefs.HasKey("EnabledLog"))
            enableLog = PlayerPrefs.GetInt("EnabledLog") > 0 ? true:false;

        if(enableLog)
        {
            DebugHelper.LogLevel = LogLevel.Info;
        }

      
        fighterMgr = new FighterManager(null);
        fighterMgr.AddFighters(teamActors.ToArray(), eTeamType.Friend);
        fighterMgr.AddFighters(enemyActors.ToArray(), eTeamType.Enemy);
        fighterMgr.ParseLoad();
        BattlePrepareManager.Instance.StartLoad();
        bStartGame = true;
    }

    void Spawn()
    {
        if (bInitedFighter) return;

        if (battleField == null) { 
            battleField = new LogicBattleField(null, null);
        }
        
        for (int idx = 0; idx < fighterMgr.AllFighters.Count; idx++)
        {
            Fighter f = fighterMgr.AllFighters[idx];
            f.StateData.IsInvincible = f.Actor.Invincible;
            if (f.TeamSide == eTeamType.Friend)
            { 
                f.Spawn(actorSpawnPoint.GetBornPointPos(f.ProfType,f.ReadyPosOrder).heroPos, Vector3.forward, Quaternion.identity);
            }
            else
            {
                Vector3 pos = Vector3.zero;  
                Transform p = monsterSpawnPoint.transform.Find("point" + f.PositionValue);
                if (p != null)
                    pos = p.position;
                f.Spawn(pos, Vector3.back, Quaternion.identity);
            }

            battleField.AddFighter(f);
        }
        bInitedFighter = true;
        battleField.CurrentState = LogicBattleFieldStateType.EditorFighting;
    }

    public void EndGame()
    {
        if (fighterMgr != null)
        {
            fighterMgr.Dispose();
            fighterMgr = null;
        }

        //ScaleTimeInfo.Instance.Stop();
        EffectManager.Instance.Clear();
        if (MusicMgr.HasInstance())
            MusicMgr.Instance.CleanBeforeChangeScene();
    }
}

#endif