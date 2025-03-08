using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

public class TeamActorInfo
{
    public int id =0;
    public int level = 0;
    public Role_Gender gender = Role_Gender.Male;      //性别 1： 女，2男
    public int skillId = 0;
    public int skillLv = 1;
    public bool invincible = false;

    public TeamActorInfo(int id,int level,int skillId,int skillLv,Role_Gender gender,bool invincible)
    {
        this.id = id;
        this.level = level;
        this.skillId = skillId;
        this.skillLv = skillLv;
        this.gender = gender;
        this.invincible = invincible;
    }
}

public class EnemyActorInfo
{
    public int id = 0;
    public int level = 0;
    public int posVal = 1;
    public bool invincible = false;

    public EnemyActorInfo(int id, int level, int posVal,bool invincible)
    {
        this.id = id;
        this.level = level;
        this.posVal = posVal;
        this.invincible = invincible;
    }
}

public class TrainCampScene : EditorWindow
{
    const int c_team_num = 4;
    const int c_enemy_num = 6;

    private List<TeamActorInfo> teamActorInfos = new List<TeamActorInfo>();
    private List<EnemyActorInfo> enemyActorInfos = new List<EnemyActorInfo>();

    private string[] _arrProfessionName;
    private int[] _arrProfessionId;

    private string[] _arrFellowName;
    private int[] _arrFellowId;

    private string[] _arrSkillName;
    private int[] _arrSkillId;

    private string[] _arrNpcName;
    private int[] _arrNpcId;

    private bool enableLog = false;

    bool initedCfg = false;

    [MenuItem("Skill_Tool/启动训练营测试")]
    public static void OpenPreviewWindow()
    {
        ConfigMgr.CreateInstance();
        EditorWindow.GetWindow(typeof(TrainCampScene));
    }

    private void OnEnable()
    {
    }

    private void OnDestroy()
    {
        
    }

    private void Update()
    {
        if(!initedCfg && ConfigMgr.InitFinished)
        {
            ReadSkillCfg();
            ReadFellowNpcCfg();
            ReadNpcCfg();
            ReadProfessionCfg();
            ReadCache();
            initedCfg = true;
        }
        else
        {
            if (teamActorInfos.Count == 0)
            {
                ReadCache();
            }
        }
    }

    void ReadCache()
    {
        teamActorInfos.Clear();
        enemyActorInfos.Clear();
        for(int idx =0; idx < c_team_num; idx++)
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
                invincible = PlayerPrefs.GetInt(invincibleKey)>0?true:false;

            TeamActorInfo info = new TeamActorInfo(id,lv,skillId,skillLv,gender, invincible);
            teamActorInfos.Add(info);
        }

        for(int idx = 0; idx < c_enemy_num; idx++)
        {
            string idKey = string.Format("TrainCamp_NpcID_{0}", idx);
            string levelKey = string.Format("TrainCamp_NpcLevel_{0}", idx);
            string posKey = string.Format("TrainCamp_NpcPos_{0}", idx);
            string invincibleKey = string.Format("TrainCamp_NpcInvincible_{0}", idx);

            int id = 0, level = 0,pos = 0;
            bool invincible = false;
            if (PlayerPrefs.HasKey(idKey))
                id = PlayerPrefs.GetInt(idKey);

            if (PlayerPrefs.HasKey(levelKey))
                level = PlayerPrefs.GetInt(levelKey);

            if (PlayerPrefs.HasKey(posKey))
                pos = PlayerPrefs.GetInt(posKey);

            if (PlayerPrefs.HasKey(invincibleKey))
                invincible = PlayerPrefs.GetInt(invincibleKey) > 0 ? true : false;

            EnemyActorInfo info = new EnemyActorInfo(id, level,pos, invincible);
            enemyActorInfos.Add(info);
        }

        if (PlayerPrefs.HasKey("EnabledLog"))
            enableLog = PlayerPrefs.GetInt("EnabledLog") > 0 ? true : false;
    }

    void SaveCache()
    {
        for (int idx = 0; idx < c_team_num; idx++)
        {
            string idKey = string.Format("TrainCamp_HeroID_{0}", idx);
            string levelKey = string.Format("TrainCamp_HeroLevel_{0}", idx);
            string skillIdKey = string.Format("TrainCamp_HeroSkillId_{0}", idx);
            string skillLvKey = string.Format("TrainCamp_HeroSkillLv_{0}", idx);
            string genderKey = string.Format("TrainCamp_Gender_{0}", idx);
            string invincibleKey = string.Format("TrainCamp_Invincible_{0}", idx);

            TeamActorInfo info = teamActorInfos[idx];
            PlayerPrefs.SetInt(idKey, info.id);
            PlayerPrefs.SetInt(levelKey, info.level);
            PlayerPrefs.SetInt(skillIdKey, info.skillId);
            PlayerPrefs.SetInt(skillLvKey, info.skillLv);
            PlayerPrefs.SetInt(genderKey, (int)info.gender);
            PlayerPrefs.SetInt(invincibleKey, info.invincible?1:0);
        }

        for (int idx = 0; idx < c_enemy_num; idx++)
        {
            string idKey = string.Format("TrainCamp_NpcID_{0}", idx);
            string levelKey = string.Format("TrainCamp_NpcLevel_{0}", idx);
            string posKey = string.Format("TrainCamp_NpcPos_{0}", idx);
            string invincibleKey = string.Format("TrainCamp_NpcInvincible_{0}", idx);


            EnemyActorInfo info = enemyActorInfos[idx];
            PlayerPrefs.SetInt(idKey, info.id);
            PlayerPrefs.SetInt(levelKey, info.level);
            PlayerPrefs.SetInt(posKey, info.posVal);
            PlayerPrefs.SetInt(invincibleKey, info.invincible?1:0);
        }

        PlayerPrefs.SetInt("EnabledLog", enableLog ? 1 : 0);
    }

    void ReadSkillCfg()
    {
        List<int> skillIds = new List<int>();
        List<string> skillNames = new List<string>();
        Dictionary<string, Dictionary<string, string>>  dic = ConfigMgr.Instance.getTable(Config.SkillCfgName);
        if(dic != null)
        {
            foreach(var cfg in dic)
            {
                if (cfg.Key.ToLower() == "id" || cfg.Key.ToLower() == "int") continue;

                int uniqueId = 0;
                int.TryParse(cfg.Key, out uniqueId);

                if (uniqueId <= 0) continue;

                Dictionary<string, string> temp = cfg.Value;
                if(temp!=null)
                {
                    int skillId = 0;
                    if (temp.ContainsKey("SkillId"))
                    {
                        int.TryParse(temp["SkillId"], out skillId);
                    }

                    if (skillId == 0) continue;

                    if (skillIds.Contains(skillId)) continue;

                    skillIds.Add(skillId);
                    skillNames.Add(temp["Name"]);
                }

            }    
        }

        _arrSkillId = skillIds.ToArray();
        _arrSkillName = skillNames.ToArray();
    }

    void ReadNpcCfg()
    {
        List<int> npcIds = new List<int>();
        List<string> npcNames = new List<string>();
        Dictionary<string, Dictionary<string, string>> dic = ConfigMgr.Instance.getTable(Config.NpcCfgName);
        if(dic!=null)
        {
            foreach (var cfg in dic)
            {
                if (cfg.Key.ToLower() == "id" || cfg.Key.ToLower() == "int") continue;

                int npcId = 0;
                int.TryParse(cfg.Key, out npcId);

                if (npcId <= 0) continue;

                Dictionary<string, string> temp = cfg.Value;
                if (temp != null)
                {
                    if (npcIds.Contains(npcId)) continue;

                    npcIds.Add(npcId);
                    npcNames.Add(temp["Name"]);
                }
            }
        }

        _arrNpcId = npcIds.ToArray();
        _arrNpcName = npcNames.ToArray();
    }

    void ReadFellowNpcCfg()
    {
        List<int> fellowIds = new List<int>();
        List<string> fellowNames = new List<string>();

        Dictionary<string, Dictionary<string, string>> dic = ConfigMgr.Instance.getTable(Config.FellowCfgName);
        if (dic != null)
        {
            foreach (var cfg in dic)
            {
                if (cfg.Key.ToLower() == "parterid" || cfg.Key.ToLower() == "int") continue;

                int fellowId = 0;
                int.TryParse(cfg.Key, out fellowId);

                if (fellowId <= 0) continue;

                Dictionary<string, string> temp = cfg.Value;
                if (temp != null)
                {
                    if (fellowIds.Contains(fellowId)) continue;

                    fellowIds.Add(fellowId);
                    fellowNames.Add(temp["Name"]);
                }
            }
        }

        _arrFellowId = fellowIds.ToArray();
        _arrFellowName = fellowNames.ToArray();
    }

    void ReadProfessionCfg()
    {
        List<int> professionIds = new List<int>();
        List<string> professionNames = new List<string>();

        Dictionary<string, Dictionary<string, string>> dic = ConfigMgr.Instance.getTable(Config.JobCfgName);
        if (dic != null)
        {
            professionIds.Add(0);
            professionNames.Add("0");
            foreach (var cfg in dic)
            {
                if (cfg.Key.ToLower() == "id" || cfg.Key.ToLower() == "int") continue;

                int professionId = 0;
                int.TryParse(cfg.Key, out professionId);

                if (professionId <= 0) continue;

                Dictionary<string, string> temp = cfg.Value;
                if (temp != null)
                {
                    if (professionIds.Contains(professionId)) continue;

                    professionIds.Add(professionId);
                    professionNames.Add(temp["Desc"]);
                }
            }
        }

        _arrProfessionId = professionIds.ToArray();
        _arrProfessionName = professionNames.ToArray();
    }

    protected void OnGUI()
    {
        if (!initedCfg) return;

        EditorGUILayout.LabelField("-------------------------我方英雄设置---------------------");
        // 选择英雄
        for (int idx =0; idx < c_team_num && idx < teamActorInfos.Count;idx++)
        {
            EditorGUILayout.BeginHorizontal();
            if (idx == 0)
            {
                EditorGUILayout.LabelField("职业ID:",GUILayout.Width(80));
                teamActorInfos[idx].id = EditorGUILayout.IntPopup(teamActorInfos[idx].id, _arrProfessionName, _arrProfessionId,GUILayout.Width(100));
                EditorGUILayout.LabelField(teamActorInfos[idx].id.ToString(),GUILayout.Width(100));
                EditorGUILayout.LabelField("等级:", GUILayout.Width(80));
                teamActorInfos[idx].level = EditorGUILayout.IntField(teamActorInfos[idx].level, GUILayout.Width(100));
                EditorGUILayout.LabelField("性别:", GUILayout.Width(80));
                teamActorInfos[idx].gender =(Role_Gender)EditorGUILayout.EnumPopup(teamActorInfos[idx].gender, GUILayout.Width(80));
            }
            else
            {
                EditorGUILayout.LabelField("伙伴ID:", GUILayout.Width(80));
                teamActorInfos[idx].id = EditorGUILayout.IntPopup(teamActorInfos[idx].id, _arrFellowName, _arrFellowId, GUILayout.Width(100));
                EditorGUILayout.LabelField(teamActorInfos[idx].id.ToString(), GUILayout.Width(100));
                EditorGUILayout.LabelField("等级:", GUILayout.Width(80));
                teamActorInfos[idx].level = EditorGUILayout.IntField(teamActorInfos[idx].level, GUILayout.Width(100));
                teamActorInfos[idx].gender = Role_Gender.Male;
            }
            EditorGUILayout.LabelField("测试技能:", GUILayout.Width(80));
            teamActorInfos[idx].skillId = EditorGUILayout.IntPopup(teamActorInfos[idx].skillId, _arrSkillName, _arrSkillId, GUILayout.Width(100));
            EditorGUILayout.LabelField(teamActorInfos[idx].skillId.ToString(), GUILayout.Width(100));
            EditorGUILayout.LabelField("技能等级:", GUILayout.Width(80));
            teamActorInfos[idx].skillLv = EditorGUILayout.IntField(teamActorInfos[idx].skillLv, GUILayout.Width(100));
            EditorGUILayout.LabelField("无敌:", GUILayout.Width(40));
            teamActorInfos[idx].invincible = EditorGUILayout.Toggle("", teamActorInfos[idx].invincible, GUILayout.Width(20));
            EditorGUILayout.EndHorizontal();
        }

        EditorGUILayout.Space();

        EditorGUILayout.LabelField("----------------------------------------怪物设置-------------------------------------");
        for (int idx = 0; idx < c_enemy_num && idx < enemyActorInfos.Count; idx++)
        {
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("npcid:", GUILayout.Width(80));
            enemyActorInfos[idx].id = EditorGUILayout.IntPopup(enemyActorInfos[idx].id, _arrNpcName, _arrNpcId, GUILayout.Width(100));
            EditorGUILayout.LabelField(enemyActorInfos[idx].id.ToString(), GUILayout.Width(100));
            EditorGUILayout.LabelField("等级:", GUILayout.Width(80));
            enemyActorInfos[idx].level = EditorGUILayout.IntField(enemyActorInfos[idx].level, GUILayout.Width(100));
            EditorGUILayout.LabelField("站位:", GUILayout.Width(80));
            enemyActorInfos[idx].posVal = EditorGUILayout.IntField(enemyActorInfos[idx].posVal, GUILayout.Width(100));
            EditorGUILayout.LabelField("无敌:", GUILayout.Width(40));
            enemyActorInfos[idx].invincible = EditorGUILayout.Toggle("", enemyActorInfos[idx].invincible, GUILayout.Width(20));
            EditorGUILayout.EndHorizontal();
        }
        EditorGUILayout.Space();

        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("开启日志:");
        enableLog = EditorGUILayout.Toggle(enableLog);
        EditorGUILayout.LabelField(enableLog.ToString());
        EditorGUILayout.EndHorizontal();


        EditorGUILayout.Space();

        // 开始预览
        if (GUILayout.Button("开始预览"))
        {
            StartPreview();
        }
    }


    void StartPreview()
    {
        SaveCache();

        GameObject bootObj = null;
        if (EditorApplication.isPlaying)
        {
            bootObj = GameObject.Find("BootObj");
            if (null != bootObj)
            {
                if (bootObj.GetComponent<EditorBattleMgr>() != null)
                {
                    bootObj.GetComponent<EditorBattleMgr>().Restart();
                }
                return;
            }
            EditorApplication.ExecuteMenuItem("Edit/Play");
        }
        // 打开启动场景
        EditorApplication.OpenScene("Assets/Scenes_Discard/Test_TrainCamp/TrainCamp.unity");
        // 开始播放
        EditorApplication.ExecuteMenuItem("Edit/Play");
        // 将GameFramework替换为预览组件
        bootObj = GameObject.Find("BootObj");
        if (bootObj != null)
        {
            EditorBattleMgr mgr = bootObj.GetComponent<EditorBattleMgr>();
            if (mgr != null)
                GameObject.DestroyImmediate(mgr);

            bootObj.AddComponent<EditorBattleMgr>();
        }
    }
}