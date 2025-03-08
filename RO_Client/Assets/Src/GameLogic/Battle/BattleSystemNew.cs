using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;
using Mono.Xml;

public class BattleMgr : SingletonMono<BattleMgr>
{

    public delegate void DoSomethingCallback(object arg);

    public static int c_updateFPS = 30;
    public static float c_targetFrameTime = 1.0f / (float)c_updateFPS;

    public static float speed_up_rate = 1f;

    public static Vector3 s_reward_pos = Vector3.zero;
    private bool m_bIsShutDown = false;

    private Dictionary<int, BattleStatistics> mBattleStatisticDic = new Dictionary<int, BattleStatistics>();
    private Dictionary<long, string> mBattleRecordList = new Dictionary<long, string>();
    #region fields
    public bool IsCameraDoingStart
    {
        get { return BattleCamera.Instance != null && BattleCamera.Instance.IsDoingSpecialCamera; }
    }

    private bool mInFighting = false;
    public bool InFighting { get { return mInFighting; } }

    private bool bShowBossIntroEnd = false;
    public bool ShowBossIntroEnd
    {
        get { return bShowBossIntroEnd; }
        set { bShowBossIntroEnd = value; }
    }

    BaseBattle mBattle;
    public BaseBattle Battle { get { return mBattle; } }

    [HideInInspector]
    public LuaTable LuaBattleMgr
    {
        set { mLuaBattleMgr = value; }
        get { return mLuaBattleMgr; }
    }


    private LuaTable mLuaVersusMgr;
    public LuaTable LuaTowerMgr
    {
        get { return mLuaVersusMgr; }
        set { mLuaVersusMgr = value; }
    }

    private LuaTable mLuaBossBattleMgr;
    public LuaTable LuaBossBattleMgr
    {
        get { return mLuaBossBattleMgr; }
        set { mLuaBossBattleMgr = value; }
    }

    private LuaTable mLuaTimeBattleMgr;
    public LuaTable LuaTimeBattleMgr
    {
        get { return mLuaTimeBattleMgr; }
        set { mLuaTimeBattleMgr = value; }
    }

    private LevelItem mCurrentLevelItem;
    private LuaTable mLuaBattleMgr = null;

    public int CurExp
    {
        get { return (mCurrentLevelItem != null) ? mCurrentLevelItem.Exp : 0; }
    }

    public int CurParnterExp
    {
        get { return (mCurrentLevelItem != null) ? mCurrentLevelItem.PartnerExp : 0; }
    }

    public int CurZeny
    {
        get { return (mCurrentLevelItem != null) ? mCurrentLevelItem.Zeny : 0; }
    }

    public int CurCruise
    {
        get { return (mCurrentLevelItem != null) ? mCurrentLevelItem.CruiseVal : 0; }
    }

    public int CurGold
    {
        get { return (mCurrentLevelItem != null) ? mCurrentLevelItem.Gold : 0; }
    }

    public int CurEvil
    {
        get { return (mCurrentLevelItem != null) ? mCurrentLevelItem.Evil : 0; }
    }

    public int ChallengeLevel
    {
        get { return (mCurrentLevelItem != null) ? mCurrentLevelItem.ChallengeLv : 0; }
    }

    public bool IsKillBoss
    {
        get { return mBattle != null && mBattle.CurBattleField != null && mBattle.CurBattleField.killBoss; }
    }

    public float FightingTime
    {
        get { return (mBattle != null && mBattle.CurBattleField != null) ? mBattle.CurBattleField.FightingTime : 0; }
    }

    public override void InitMgr()
    {
        base.InitMgr();
    }

    public bool IsRotatingCam
    {
        get; private set;
    }

    private List<int> mCommonEffectIds = new List<int>();
    public List<int> CommonEffectIds
    {
        get { return mCommonEffectIds; }
    }

    public bool SkillDirty
    {
        get { return skillDirty; }
    }

    public bool TeamDirty
    {
        get { return teamDataDirty; }
    }


    protected override void Dispose()
    {
        EventMgr.RemoveEventListener<ValType[]>(ECoreEventType.EID_Click_Challenge, OnChallengeBoss);
        EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_BOSS_SPAWNED, OnBossSpawned);
        EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_CLONE_NEW_BOSS, OnCloneNewBoss);
        EventMgr.RemoveEventListener<string>(ECoreEventType.EID_BATTLE_NEW_NEXT_WAVE, OnBattleNewWave);
        EventMgr.RemoveEventListener<bool>(ECoreEventType.EID_BATTLE_CONTINUE_WAVE, OnContinueBattle);
        EventMgr.RemoveEventListener<bool>(ECoreEventType.EID_BEGIN_BOSS_RAGE_TIME, OnShowBossRage);
        EventMgr.RemoveEventListener<int>(ECoreEventType.EID_SHOW_BOSS_RAGE_LEFTTIME, OnShowBossRageLeftTime);
        EventMgr.RemoveEventListener<bool>(ECoreEventType.EID_BOSS_IN_RAGE, OnBossInRage);
        //EventMgr.RemoveEventListener<string>(ECoreEventType.EID_SHOW_SCENE_GO, OnSwitchScene);
        //EventMgr.RemoveEventListener<bool>(ECoreEventType.EID_RESTORE_SCENE, OnRestoreScene);
        EventMgr.RemoveEventListener<bool>(ECoreEventType.EID_FIGHTERS_LOAD_OK, OnLoadTeam);
        EventMgr.RemoveEventListener<bool>(ECoreEventType.EID_PREPARE_LOAD_OK, OnPrepareLoadOk);
        EventMgr.RemoveEventListener<bool>(ECoreEventType.EID_LOAD_BEGIN, OnLoadBegin);
        EventMgr.RemoveEventListener<bool>(ECoreEventType.EID_LOAD_COMPLETE, OnLoadComplete);
        EventMgr.RemoveEventListener<float>(ECoreEventType.EID_LOAD_PROGRESS, OnLoadProgress);
        EventMgr.RemoveEventListener<UIEventParamFighterHurt>(ECoreEventType.EID_FIGHTER_HURT, OnFighterHurt);
        EventMgr.RemoveEventListener<CastSkillData>(ECoreEventType.EID_Refresh_Skill, OnFighterCastSkill);
        EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_FIGHTER_LIFE_CHANGED, OnFighterLifeChanged);
        EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_FIGHTER_ENERGY_CHAGNED, OnFighterEnergyChanged);
        EventMgr.RemoveEventListener<stBuffParam>(ECoreEventType.EID_SHOW_BUFF_ICON, OnShowBossBuffIcon);
        //EventMgr.RemoveEventListener<string>(ECoreEventType.EID_SHOW_DEBUFF_ICON, OnShowBossDebuffIcon);
        EventMgr.RemoveEventListener<stBuffParam>(ECoreEventType.EID_REMOVE_BUFF_ICON, OnRemoveBuffIcon);
        EventMgr.RemoveEventListener<SkillCDParam>(ECoreEventType.EID_REFRESH_SKILL_CD, OnFighterSkillCDChanged);
        EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_SHOW_FIGHTER, OnShowFighter);
        EventMgr.RemoveEventListener<string>(ECoreEventType.EID_PLAY_SKILL_PREFAB, OnShowSkillPrefab);
        EventMgr.RemoveEventListener<string>(ECoreEventType.EID_CLOSE_SKILL_PREFAB, OnCloseSkillPrefab);
        EventMgr.RemoveEventListener<bool>(ECoreEventType.EID_BattleUI_Visible, OnBattleUIVis);

        EventMgr.RemoveEventListener<Vector2>(ECoreEventType.EID_START_MOVE_MOUSE, OnStartMoveMouse);
        //EventMgr.RemoveEventListener<Vector2>(ECoreEventType.EID_MOUSE_DELTA, OnMouseMove);
        EventMgr.RemoveEventListener<Vector2>(ECoreEventType.EID_END_MOVE_MOUSE, OnEndMoveMouse);
        EventMgr.RemoveEventListener<bool>(ECoreEventType.EID_REPLAY_BATTLE_LOADOK, OnReplayBattleLoadedOk);

        base.Dispose();
    }

    protected override void OnApplicationQuit()
    {
        base.OnApplicationQuit();
    }
    #endregion

    void Start()
    {
        EventMgr.AddEventListener<ValType[]>(ECoreEventType.EID_Click_Challenge, OnChallengeBoss);
        EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_BOSS_SPAWNED, OnBossSpawned);
        EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_CLONE_NEW_BOSS, OnCloneNewBoss);
        EventMgr.AddEventListener<string>(ECoreEventType.EID_BATTLE_NEW_NEXT_WAVE, OnBattleNewWave);
        EventMgr.AddEventListener<bool>(ECoreEventType.EID_BATTLE_CONTINUE_WAVE, OnContinueBattle);
        EventMgr.AddEventListener<bool>(ECoreEventType.EID_BEGIN_BOSS_RAGE_TIME, OnShowBossRage);
        EventMgr.AddEventListener<int>(ECoreEventType.EID_SHOW_BOSS_RAGE_LEFTTIME, OnShowBossRageLeftTime);
        EventMgr.AddEventListener<bool>(ECoreEventType.EID_BOSS_IN_RAGE, OnBossInRage);
        //EventMgr.AddEventListener<string>(ECoreEventType.EID_SHOW_SCENE_GO, OnSwitchScene);
        //EventMgr.AddEventListener<bool>(ECoreEventType.EID_RESTORE_SCENE, OnRestoreScene);
        EventMgr.AddEventListener<bool>(ECoreEventType.EID_FIGHTERS_LOAD_OK, OnLoadTeam);
        EventMgr.AddEventListener<bool>(ECoreEventType.EID_PREPARE_LOAD_OK, OnPrepareLoadOk);
        EventMgr.AddEventListener<bool>(ECoreEventType.EID_LOAD_BEGIN, OnLoadBegin);
        EventMgr.AddEventListener<bool>(ECoreEventType.EID_LOAD_COMPLETE, OnLoadComplete);
        EventMgr.AddEventListener<float>(ECoreEventType.EID_LOAD_PROGRESS, OnLoadProgress);
        EventMgr.AddEventListener<UIEventParamFighterHurt>(ECoreEventType.EID_FIGHTER_HURT, OnFighterHurt);
        EventMgr.AddEventListener<CastSkillData>(ECoreEventType.EID_Refresh_Skill, OnFighterCastSkill);
        EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_FIGHTER_LIFE_CHANGED, OnFighterLifeChanged);
        EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_FIGHTER_ENERGY_CHAGNED, OnFighterEnergyChanged);
        EventMgr.AddEventListener<stBuffParam>(ECoreEventType.EID_SHOW_BUFF_ICON, OnShowBossBuffIcon);
        //EventMgr.AddEventListener<string>(ECoreEventType.EID_SHOW_DEBUFF_ICON, OnShowBossDebuffIcon);
        EventMgr.AddEventListener<stBuffParam>(ECoreEventType.EID_REMOVE_BUFF_ICON, OnRemoveBuffIcon);
        EventMgr.AddEventListener<SkillCDParam>(ECoreEventType.EID_REFRESH_SKILL_CD, OnFighterSkillCDChanged);
        EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_SHOW_FIGHTER, OnShowFighter);
        EventMgr.AddEventListener<string>(ECoreEventType.EID_PLAY_SKILL_PREFAB, OnShowSkillPrefab);
        EventMgr.AddEventListener<string>(ECoreEventType.EID_CLOSE_SKILL_PREFAB, OnCloseSkillPrefab);
        EventMgr.AddEventListener<bool>(ECoreEventType.EID_BattleUI_Visible, OnBattleUIVis);

        EventMgr.AddEventListener<Vector2>(ECoreEventType.EID_START_MOVE_MOUSE, OnStartMoveMouse);
        //EventMgr.AddEventListener<Vector2>(ECoreEventType.EID_MOUSE_DELTA, OnMouseMove);
        EventMgr.AddEventListener<Vector2>(ECoreEventType.EID_END_MOVE_MOUSE, OnEndMoveMouse);
        EventMgr.AddEventListener<bool>(ECoreEventType.EID_REPLAY_BATTLE_LOADOK, OnReplayBattleLoadedOk);

        Time.timeScale = speed_up_rate;
        Init();
    }

    void Init()
    {        
        BattleFlyWordMgr.Instance.InitMgr();
        mRecordTime2 = Time.realtimeSinceStartup;
    }

    void Update()
    {
        if (null == mBattle)
            return;
        if (mBattle.IsShutDown)
            return;
        UpdateLogic();
        UpdateTrigger();
        UpdateElse();
    }


    float mNextActionTime;
    float mRecordTime2 = 0;
    float passedTime = 0;
    void UpdateLogic()
    {
        if (mBattle != null)
        {
            if (mNextActionTime > 0f)
            {
                mNextActionTime -= Time.deltaTime;
                passedTime += Time.deltaTime;
            }


            if (mNextActionTime > 0f)
                return;
#if PROFILE
            UnityEngine.Profiling.Profiler.BeginSample("LogicBattle Update");
#endif
            mBattle.Update(passedTime);

            EffectManager.Instance.Update(passedTime);
#if PROFILE
            UnityEngine.Profiling.Profiler.EndSample();
#endif
            mNextActionTime = c_targetFrameTime;
            passedTime = 0;
        }
        else
        {
            passedTime = 0;
        }

    }

    void UpdateTrigger()
    {
        if (mBattle != null && mBattle.globalTrigger != null)
        {
            mBattle.globalTrigger.UpdateLogic(Time.deltaTime);
        }
    }

    void UpdateElse()
    {
        if (mBattle != null)
        {
#if PROFILE
            UnityEngine.Profiling.Profiler.BeginSample("BattleDropMgr Update");
#endif
            BattleDropMgr.Instance.Update(Time.deltaTime);
#if PROFILE
            UnityEngine.Profiling.Profiler.EndSample();
#endif

#if PROFILE
            UnityEngine.Profiling.Profiler.BeginSample("ScaleTimeInfo Update");
#endif

            //ScaleTimeInfo.Instance.Update(Time.deltaTime);

#if PROFILE
            UnityEngine.Profiling.Profiler.EndSample();
#endif

#if PROFILE
            UnityEngine.Profiling.Profiler.BeginSample("EffectManager Update");
#endif
            //EffectManager.Instance.Update(Time.deltaTime);

#if PROFILE
            UnityEngine.Profiling.Profiler.EndSample();
#endif
        }
    }

    public BattleStatistics GetBattleStatistics(BattleMode mode, BattleSubMode subMode)
    {
        int type = ((int)mode) * 100 + ((int)subMode);
        BattleStatistics data;
        mBattleStatisticDic.TryGetValue(type, out data);
        return data;
    }

    public bool HasBattleStatistics(BattleMode mode, BattleSubMode subMode)
    {
        var data = GetBattleStatistics(mode, subMode);
        if (data == null) return false;

        return data.Exist;
    }

    public void SetSpeedUp(float speedUp)
    {
        if (speed_up_rate != speedUp)
        {
            speed_up_rate = speedUp;
            Time.timeScale = speed_up_rate;
        }
    }

    private void LateUpdate()
    {
        if (mBattle != null)
        {
            BattleCamera.Instance.Update(Time.deltaTime);
        }
    }


    public float GetLeftFightingTime()
    {
        if (mBattle == null) return 0;

        if (mBattle.IsTimeBattle)
        {
            return mBattle.CurBattleField.MaxFightingTime - mBattle.CurBattleField.FightingTime;
        }
        return 0;
    }

    public void StartBattle(LogicBattleStartInfo startInfo)
    {
        try
        {
            List<BattleEndCondition> endConds = new List<BattleEndCondition>();
            BattleEndCondition con = new BattleEndCondition(Constants.EndBattle_By_UndeadCount, Constants.ResultType_Normal);
            endConds.Add(con);

            mCommonEffectIds.Clear();
            mBattle = new LogicBattle(startInfo, false, endConds);
            mBattle.Start();
            mCurrentLevelItem = mBattle.CurLevelItem;
            SaveBattleStat();
        }
        catch (System.Exception e)
        {
            DebugHelper.LogError(e.StackTrace);
        }
    }

    public void StartVersusBattle(BattleSubMode mode, ActorData[] teamActors, ActorData[] enemyActors, string sceneName, float maxBattlingTime, BattleEndCondition[] endConds,
                        GvGMark[] OurMarks, GvGMark[] EnemyMarks,bool IsPresspoint,int nPresspoint)
    {
        mCommonEffectIds.Clear();
        if (teamActors == null || enemyActors == null || string.IsNullOrEmpty(sceneName)) return;

        if (endConds == null || endConds.Length == 0) return;

        try
        {
            List<BattleEndCondition> conds = new List<BattleEndCondition>();
            conds.AddRange(endConds);
            ForceSyncSkill();
            TowerBattleInfo bi = TowerBattleCfgMgr.Instance.GetTowerBattleInfo();
            mBattle = new VersusBattle(mode, bi, teamActors, enemyActors, sceneName, maxBattlingTime, conds, OurMarks,EnemyMarks,IsPresspoint, nPresspoint);
            mBattle.Start();
            SaveBattleStat();
        }
        catch (System.Exception e)
        {
            DebugHelper.LogError(e.StackTrace);
        }

    }

    public void StartBossBattle(ActorData[] actors, int bossId, int sceneId, BattleEndCondition[] endConds)
    {
        mCommonEffectIds.Clear();

        if (actors == null || actors.Length == 0)
        {
            DebugHelper.LogError("传入的玩家信息为空");
            return;
        }

        if (bossId == 0)
        {
            DebugHelper.LogError("挑战的bossid不能为0");
            return;
        }

        if (sceneId == 0)
        {
            DebugHelper.LogError("挑战boss的boss场景id不能为0");
            return;
        }

        ForceSyncSkill();
        ActorData bossActor = ActorData.CreateNpcPlayerActor(bossId, bossId, 1);
        bossActor.IsBoss = true;
        if (!bossActor.valid)
        {
            DebugHelper.LogError(string.Format("挑战{0}boss配置正确，请查看npc配表", bossId));
            return;
        }

        if (endConds == null || endConds.Length == 0)
        {
            Debugger.LogError("战斗结束条件不能配置为空");
            return;
        }

        try
        {
            List<BattleEndCondition> conds = new List<BattleEndCondition>();
            conds.AddRange(endConds);

            mBattle = new BossBattle(actors, bossActor, sceneId, BattleSubMode.WorldBoss, conds);
            mBattle.Start();
            SaveBattleStat();
        }
        catch (System.Exception e)
        {
            DebugHelper.LogError(e.StackTrace);
        }

    }


    public bool StartTimeBattle(LuaTable luaTbl,
                                BattleSubMode mode, float maxFightingTime, string sceneName, string bgmMusic,
                                ActorData[] ourActors, ActorData[] enemyActors, ServerFighterParam[] fighterParams,
                                BattleEndCondition[] endConds, ValType[] factors,int nRestoreSp, GvGMark[] OurMarks,
                                  GvGMark[] EnemyMarks)
    {
        if (mode == BattleSubMode.None) return false;

        if (string.IsNullOrEmpty(sceneName)) return false;

        if (ourActors == null || enemyActors == null || ourActors.Length == 0 || enemyActors.Length == 0) return false;

        if (mBattle != null && mBattle.IsTimeBattle) return false;

        if (endConds == null || endConds.Length == 0)
        {
            Debugger.LogError("战斗结束条件不能配置为空");
            return false;
        }

        try
        {
            List<BattleEndCondition> conds = new List<BattleEndCondition>();
            conds.AddRange(endConds);

            ShutDownCurrentBattle();

            ForceSyncSkill();
            mLuaTimeBattleMgr = luaTbl;
            mBattle = new TimeBattle(mode, ourActors, enemyActors, sceneName, maxFightingTime, bgmMusic, fighterParams, conds, nRestoreSp, OurMarks, EnemyMarks);
            mBattle.Start(0, factors);
            SaveBattleStat();
            return true;
        }
        catch (System.Exception e)
        {
            DebugHelper.LogError(e.StackTrace);
            return false;
        }
    }

    public bool ReplayTimeBattle(LuaTable luaTbl, BattleSubMode mode, float maxFightingTime, string sceneName, string bgmMusic, string battleRecordStr)
    {
        if (mode == BattleSubMode.None) return false;

        if (string.IsNullOrEmpty(sceneName)) return false;

        if (string.IsNullOrEmpty(battleRecordStr)) return false;

        if (mBattle != null && mBattle.IsTimeBattle) return false;

        if (mBattle != null && mBattle.IsPlayRecord) return false;

        ShutDownCurrentBattle();

        mLuaTimeBattleMgr = luaTbl;
        JSONObject json = JSONObject.Create(CompressionUtil.UnCompress(battleRecordStr));
        BattleRecorder battleRecord = new BattleRecorder(json);

        List<BattleEndCondition> endConds = new List<BattleEndCondition>();
        BattleEndCondition con = new BattleEndCondition(Constants.EndBattle_By_UndeadCount, Constants.ResultType_Normal);
        endConds.Add(con);

        mBattle = new TimeBattle(mode, sceneName, maxFightingTime, bgmMusic, battleRecord, endConds);
        mBattle.Start();
        SaveBattleStat();
        return true;
    }

    public void SaveBattleStat()
    {
        if (mBattle.IsNormalBattle ||
             mBattle.IsVersusBattle ||
             mBattle.IsTimeBattle)
        {
            if (mBattle.BattleStatistics != null)
            {
                int type = ((int)mBattle.Mode) * 100 + ((int)mBattle.SubBattleMode);
                if (mBattleStatisticDic.ContainsKey(type))
                {
                    mBattleStatisticDic[type] = mBattle.BattleStatistics;
                }
                else
                {
                    mBattleStatisticDic.Add(type, mBattle.BattleStatistics);
                }
            }
        }
    }

    public List<ActorData> StartNewbieBossBattle(int sceneId, int sex)
    {
        mCommonEffectIds.Clear();
        if (sceneId == 0)
        {
            DebugHelper.LogError("挑战boss的boss场景id不能为0");
            return null;
        }

        string ta = ConfigMgr.Instance.GetXmlCfg("Newbie_Design");
        if (ta == null)
        {
            DebugHelper.LogError("新手训练没有配置全局触发器文件");
            return null;
        }

        SecurityParser doc = new SecurityParser();
        try
        {
            doc.LoadXml(ta);
        }
        catch (System.Exception e)
        {
            DebugHelper.Assert(false, "exception = {0}", e.Message);
            return null;
        }

        List<ActorData> fellows = new List<ActorData>();
        ActorData bossActor = null;

        System.Security.SecurityElement root = doc.SelectSingleNode("GlobalTrigger");
        if (root == null || root.Children == null) return null;

        for (int idx = 0; idx < root.Children.Count; idx++)
        {
            var node = root.Children[idx] as System.Security.SecurityElement;
            if (node.Tag.CompareTo("TriggerSpawnGroup") == 0)
            {
                for (int jdx = 0; jdx < node.Children.Count; jdx++)
                {
                    var spawnNode = node.Children[jdx] as System.Security.SecurityElement;
                    if (spawnNode.Tag.CompareTo("Spawn") == 0)
                    {
                        int id = 0, type;
                        int.TryParse(spawnNode.Attribute("id"), out id);
                        int.TryParse(spawnNode.Attribute("actorType"), out type);
                        if (id > 0)
                        {
                            ActorType aType = (ActorType)type;
                            if (aType == ActorType.Hero)
                            {
                                int newId = id;
                                if (sex == (int)Role_Gender.Female)
                                {
                                    newId = newId + 1;
                                }
                                ActorData fellow = ActorData.CreateFellowActor(sceneId * 1000 + 100 + jdx, newId, 1, null);
                                fellows.Add(fellow);
                                fellow.BaseId = id;
                                fellow.Gender = sex;
                            }
                            else if (aType == ActorType.Fellow)
                            {
                                ActorData fellow = ActorData.CreateFellowActor(sceneId * 1000 + 100 + jdx, id, 1, null);
                                fellows.Add(fellow);
                            }
                            else if (aType == ActorType.Monster)
                            {
                                bossActor = ActorData.CreateNpcPlayerActor(sceneId * 1000 + 110, id, 1);
                                bossActor.IsBoss = true;
                                bossActor.PositionValue = 2;
                            }
                        }
                    }
                }
            }
            else if (node.Tag.CompareTo("EffectGroup") == 0)
            {
                for (int jdx = 0; jdx < node.Children.Count; jdx++)
                {
                    var effectNode = node.Children[jdx] as System.Security.SecurityElement;
                    if (effectNode.Tag.CompareTo("Effect") == 0)
                    {
                        int effectId = 0;
                        int.TryParse(effectNode.Attribute("id"), out effectId);
                        if (effectId > 0 && !mCommonEffectIds.Contains(effectId))
                        {
                            mCommonEffectIds.Add(effectId);
                        }
                    }
                }
            }
        }

        if (fellows.Count == 0 || bossActor == null)
        {
            DebugHelper.LogError("新手训练营没有配置伙伴或者boss");
            return null;
        }

        List<BattleEndCondition> endConds = new List<BattleEndCondition>();
        BattleEndCondition con = new BattleEndCondition(Constants.EndBattle_By_UndeadCount, Constants.ResultType_Normal);
        endConds.Add(con);

        mBattle = new BossBattle(fellows.ToArray(), bossActor, sceneId, BattleSubMode.NewbieBoss, endConds);
        mBattle.Start();
        return fellows;
    }


    public void EnterNextBattle()
    {
        Debug.Log("EnterNextBattle -----------> ");

        //if(GameMgr.Instance.isByteDance){
        //    //ByteDance.Instance.stopRecordViedo();
        //}

        if (mBattle == null) return;

        if (mBattle.IsNormalBattle)
        {
            if (mBattle.CurBattleField.IsIdleState)
            {
                mBattle.EnterNextBattle();
            }
            else
            {
                mBattle.ServerAckOk = true;
            }
        }
    }

    public void DoPauseFighting(bool pause)
    {
        if (mBattle != null && mBattle.CurBattleField != null)
        {
            mBattle.CurBattleField.DoPauseFight(pause);
        }
    }

    public void AddActorToBossBattle(ActorData actor)
    {
        if (mBattle == null || actor == null) return;

        mBattle.AddActor(actor);
    }

    public void SetActorDead(long actorId)
    {
        if (mBattle == null) return;

        mBattle.SyncActorLife(actorId, 0);
    }

    public void RemoveActorFromBossBattle(long actorId)
    {
        if (mBattle == null) return;

        mBattle.RemoveActor(actorId);
    }

    public void SyncBossLife(int life)
    {
        if (mBattle == null) return;

        mBattle.SyncBossLife(life);
    }

    public void SetVersusActors(ActorData[] teamActors, ActorData[] enemyActors, float maxBattlingTime)
    {
        if (teamActors == null || enemyActors == null || mBattle == null || teamActors.Length == 0 || enemyActors.Length == 0)
        {
            DebugHelper.LogError("对战数据不能为空");
            return;
        }

        if (mBattle.Mode != BattleMode.Versus) return;

        VersusBattle tb = mBattle as VersusBattle;
        tb.SetVersusActors(teamActors, enemyActors, maxBattlingTime);
    }

    public void BeginVersus()
    {
        if (mBattle == null) return;

        if (mBattle.Mode != BattleMode.Versus) return;

        VersusBattle tb = mBattle as VersusBattle;
        tb.StartVersus();
    }

    public void StartStoryScript()
    {
        if (mBattle == null) return;

        mBattle.StartStoryScript();
        if (mBattle.IsBossBattle)
        {
            if (mLuaBossBattleMgr == null) return;

            mLuaBossBattleMgr.CallCS2Lua("OpenNewbieBattleUI");
        }
    }

    private List<ActorData> ParseTeamActors(ActorParam[] paramList)
    {
        if (paramList == null) return null;

        List<ActorData> actors = new List<ActorData>();
        for (int idx = 0; idx < paramList.Length; idx++)
        {
            ActorParam param = paramList[idx];
            ActorData ad = null;
            if (param.isRole)
            {
                ad = ActorData.CreatePlayerActor(param);
            }
            else
            {

                ad = ActorData.CreateFellowActor(param);
            }
            ad.IsMainRole = param.isMainRole;

            if (ad.valid)
                actors.Add(ad);
        }
        return actors;
    }

    public void DisposeCurrentBattle()
    {
        if (mSkillPrefabs != null && mSkillPrefabs.Count > 0)
        {
            foreach (var p in mSkillPrefabs)
            {
                ResourceMgr.Instance.RecycleGO(Constants.UIPath, p.Key, p.Value);
            }
            mSkillPrefabs.Clear();
        }

        if (mBattle != null)
        {
            mBattle.Dispose();
            mBattle = null;
        }
    }

    public void ShutDownCurrentBattle(bool bIsDispose = true)
    {
        if (mBattle != null)
        {
            mBattle.ShutDown();
        }

        if (bIsDispose)
            DisposeCurrentBattle();

        mLuaBattleMgr = null;
        mLuaBossBattleMgr = null;
        mLuaVersusMgr = null;
        mLuaTimeBattleMgr = null;
        bHasLoadedRole = false;
        bRoleModelDirty = false;
        mRoleModelGo = null;
        bLoadingRoleModel = false;

        //ScaleTimeInfo.Instance.Stop();
        EffectManager.Instance.Clear();
        if (BattleFlyWordMgr.HasInstance())
            BattleFlyWordMgr.Instance.Clear();
        if (MusicMgr.HasInstance())
            MusicMgr.Instance.CleanBeforeChangeScene();
    }

    public void Replay(BattleRecorder recorder)
    {
        if (mBattle == null)
            return;

        if (mBattle.IsNormalBattle)
        {
            mBattle.CurBattleField.PeaceEnd();
            mBattle.ReplayRecords(recorder);
        }
    }

    public void ClearBattleLog()
    {
        if (mBattle == null)
            return;
        mBattle.BattleOut.Clean();//清空本场战斗
        if (mBattle.IsNormalBattle)
        {
            if (mLuaBattleMgr == null) return;

            mLuaBattleMgr.CallCS2Lua("ClearBattleLog");//清空历史所有
        }
    }

    public void ForceStopBattle()
    {
        if (mBattle == null)
            return;
        mBattle.CurBattleField.PeaceEnd();
    }

    public void ShowStartFighting()
    {
        EventMgr.DispatchEvent<bool>(new CoreEvent<bool>(ECoreEventType.EID_BATTLE_NEW_START_FIGHTING, true));
    }

    public void SetBattleCamera()
    {
        if (BattleCamera.Instance != null)
        {
            EnableBattleCamera();
        }
    }

    public void DisableBattleCamera()
    {
        if (BattleCamera.Instance != null)
        {
            BattleCamera.Instance.DisableBattleCam();
        }
    }

    int mCurrentBattlePageId = 0;
    public void HideBattleUI()
    {
        mCurrentBattlePageId = UIMgr.Instance.GetCurrentBattlePageId();
        if (mCurrentBattlePageId > 0)
            UIMgr.Instance.Hide(mCurrentBattlePageId);
    }

    public void ShowBattleUI()
    {
        if (mCurrentBattlePageId > 0)
        {
            UIMgr.Instance.Show(mCurrentBattlePageId);
        }
    }

    public void EnableBattleCamera()
    {
        if (BattleCamera.Instance != null && UIMgr.Instance.HasBattleMainPage() && !IsPlayingComingCamera())
        {
            BattleCamera.Instance.EnableBattleCam();
        }
    }

    public void SetBossBattleCamera()
    {
        if (BattleCamera.Instance != null)
        {
            EnableBattleCamera();
            BattleCamera.Instance.SetCameraPosAndRot(mBattle.BattleBossCamPos, mBattle.BattleBossCamRot, 0, mBattle.BattleCamFar);
        }
    }

    public void SetFollowCamera(Vector3 forward, bool immediate = false)
    {
        if (BattleCamera.Instance != null)
        {
            EnableBattleCamera();
            if(0 < mBattle.FighterMgr.TeamFighters.Count)
                BattleCamera.Instance.LockFighter(mBattle.FighterMgr.TeamFighters[0], BattleCamera.Instance.CamCfg.followCamOffset, forward, BattleCamera.Instance.CamCfg.followCameraFov, BattleCamera.Instance.CamCfg.followDist, immediate);
        }
    }

    public void LookAtBattleFieldCenter()
    {
        if (mBattle.IsKillingBoss) return;

        Vector3 focusForward = mBattle.CurBattleField.FighterForward;
        Vector3 toFocus = mBattle.CurBattleField.FieldFocus;

        Vector3 toPosition = BattleCamera.Instance.CamPosition + BattleCamera.Instance.CamCfg.batttleCamOffset;
        BattleCamera.Instance.SetCameraWithFocus(toPosition, toFocus, BattleCamera.Instance.CamCfg.battleCameraFov);
    }

    public void PerformStartCamera(List<MapCameraConfig> cfgs, bool tweenTo)
    {
        EnableBattleCamera();
        BattleCamera.Instance.PerformStartCamera(cfgs, tweenTo);
    }

    public void EnterBossIntro()
    {
        ShowBossIntroEnd = false;
        BattleFlyWordMgr.Instance.SetHudVisible(false);
        UIMgr.Instance.Hide(UIPageIDs.PAGE_ID_BATTLE);
        BattleCamera.Instance.EnterBossIntroCam();
    }

    public void ExitBossIntro()
    {
        BattleFlyWordMgr.Instance.SetHudVisible(true);
        UIMgr.Instance.Show(UIPageIDs.PAGE_ID_BATTLE);
        UIMgr.Instance.Close(UIPageIDs.PAGE_ID_BOSS_INTRO);
        BattleCamera.Instance.ExitBossIntroCam();
    }

    public void ShowComingCamera()
    {
        if (BattleCamera.Instance.ComingCameraGo != null)
        {
            BattleCamera.Instance.ComingCameraGo.SetActive(true);
        }
    }

    public void PlayComingCameraAnim(string goName, string anim)
    {
        if (string.IsNullOrEmpty(anim) || string.IsNullOrEmpty(goName)) return;

        GameObject animGo = GameObject.Find(goName);
        if (animGo != null)
        {
            Animator animator = animGo.GetComponent<Animator>();
            if (animator != null)
                animator.Play(anim);
        }
    }

    public void HideComingCamera()
    {
        if (BattleCamera.Instance.ComingCameraGo != null)
        {
            BattleCamera.Instance.ComingCameraGo.SetActive(false);
        }
    }

    public bool IsPlayingComingCamera()
    {
        if (BattleCamera.Instance.ComingCameraGo != null)
        {
            return BattleCamera.Instance.ComingCameraGo.activeInHierarchy;
        }
        return false;
    }

    public void ActiveSceneAnim(string goName, string animName, bool active)
    {
        if (string.IsNullOrEmpty(goName))
            return;
        GameObject go = GameObject.Find(goName);
        if (go != null)
        {
            if (active)
                PocHelper.PlayGoAnim(go, animName);
            else
                PocHelper.StopGoAnim(go);
        }
    }

    public void ActiveSceneGo(string goName, bool active)
    {
        GameObject go = GameObject.Find(goName);
        if (go != null)
            go.SetActive(active);
    }

    public void SetUINodeVis(string nodePath)
    {
        if (string.IsNullOrEmpty(nodePath)) return;

        if (mBattle == null) return;

        if (mBattle.IsBossBattle)
        {
            if (mLuaBossBattleMgr == null) return;

            mLuaBossBattleMgr.CallCS2Lua("SetUINodeVis", nodePath);
        }
    }

    public void OnRefreshBattleOutput()
    {
        if (mBattle.IsNormalBattle)
        {
            if (mLuaBattleMgr == null) return;

            mLuaBattleMgr.CallCS2Lua("OnRefreshBattleOutput");
        }
    }

    public void OnFightingStart()
    {
        mInFighting = true;
        BattleCamera.Instance.MoveSpeed = BattleCamera.Instance.CamCfg.CamMoveSpeed;
        UIMgr.Instance.RestoreBattleUIVisible();
        BattleFlyWordMgr.Instance.SetHudVisible(true);
        EventMgr.DispatchEvent<bool>(new CoreEvent<bool>(ECoreEventType.EID_BATTLE_NEW_FIGHTING_START, true));
        if (mBattle.IsNormalBattle)
        {
            if (mLuaBattleMgr == null) return;

            mLuaBattleMgr.CallCS2Lua("OnFightingStart", IsKillBoss);
        }
        else if (mBattle.IsTimeBattle)
        {
            if (mLuaTimeBattleMgr == null) return;

            mLuaTimeBattleMgr.CallCS2Lua("OnFightingStart");
        }
        else if (mBattle.IsVersusBattle)
        {
            if (mLuaVersusMgr != null)
                mLuaVersusMgr.CallCS2Lua("OnFightingStart");
        }
    }

    bool teamDataDirty = false;
    public bool TeamDataDirty { get { return teamDataDirty; } }
    List<ActorData> needChangeActors = new List<ActorData>();
    public void SyncTeams(bool bIsForce)
    {
        if (mBattle == null) return;

        teamDataDirty = true;
        if (mInFighting)
        {
            if(bIsForce)// 强制结束战斗 同步属性（巡游战斗中）
            {                
                ForceStopBattle();
                ClearBattleLog();
            }
            else
            {
                return; //下场战斗开始 同步
            }
        }
        BattleMgr.Instance.SyncTeamData();    //同步数据
    }

    public void ClearSkillDirty()
    {
        dirtySkills.Clear();
        skillDirty = false;
    }

    Dictionary<int, List<SkillParam>> dirtySkills = new Dictionary<int, List<SkillParam>>();
    bool skillDirty = false;
    public void UpdateTeamSkills(LuaTable heroSkills)
    {
        if (heroSkills == null) return;

        dirtySkills.Clear();
        for (int i = heroSkills.Length; i >= 1; i--)
        {
            int uid = 0;
            LuaTable ltt = (LuaTable)heroSkills[i];
            int.TryParse(ltt["uid"].ToString(), out uid);            
            if (uid == 0) continue;

            if (ltt["skills"] == null) continue;            
            List<SkillParam> skillParams = ActorData.ParseSkillParam((LuaTable)ltt["skills"]);
            dirtySkills.Add(uid, skillParams);
        }        

        if (mInFighting)
        {
            //skillDirty = true;
            //return;
            ForceStopBattle();
            ClearBattleLog();
        }


        skillDirty = true;
        CheckSkill();
    }

    public void UpdateTeamSkills(int uid, List<SkillParam> skillParams)
    {
        if (skillParams == null) return;

        bool bIsFind = dirtySkills.ContainsKey(uid);
        if(bIsFind)
        {
            dirtySkills[uid] = skillParams;
        }
        else
        {
            dirtySkills.Add(uid, skillParams);
        }

        if (mInFighting)
        {
            //skillDirty = true;
            //return;
            ForceStopBattle();
            ClearBattleLog();
        }


        skillDirty = true;
        CheckSkill();
    }

    bool professionDirty = false;
    int mCacheJobId = 0;
    public void SetProfessionDirty(bool dirty, int jobId)
    {
        professionDirty = dirty;
        mCacheJobId = jobId;
    }

    public void SetTeamData()
    {
        if (teamDataDirty)
        {
            //var teamActors = GameMgr.Instance.CharacterInfo.NormleBattleTeamActors;
            var teamActors = GameMgr.Instance.CharacterInfo.TeamActors;
            bool ret = mBattle.AddNewActors(teamActors);
            teamDataDirty = false;

            for (int idx = 0; idx < teamActors.Count; idx++)
            {
                ActorDataMgr.Instance.RefreshFellowActorData(teamActors[idx].ID, teamActors[idx].BaseId);
            }
        }
    }

    private void OnChallengeBoss(CoreEvent<ValType[]> ce)
    {
        if (mBattle == null) return;

        mBattle.ChallengeBoss = true;
        mBattle.Factors = ce.Data;

        if (mBattle.CurBattleField != null)
        {
            if (mBattle.CurBattleField.CanKillBoss)
            {
                mBattle.CurBattleField.killBoss = true;
            }
        }
    }

    public void ReplayBattle(string recordStr)
    {
        if (string.IsNullOrEmpty(recordStr)) return;

        if (mBattle == null) return;

        if (mBattle.IsPlayRecord) return;

        if (mBattle.IsKillingBoss) return;

        string recordContent = CompressionUtil.UnCompress(recordStr);

        JSONObject json = JSONObject.Create(recordContent);
        BattleRecorder battleRecord = new BattleRecorder(json);
        Replay(battleRecord);
    }

    private void OnCloneNewBoss(CoreEvent<Fighter> ce)
    {
        Fighter f = ce.Data;
        if (mBattle.IsNormalBattle)
        {
            if (mLuaBattleMgr == null) return;

            mLuaBattleMgr.CallCS2Lua("OnCloneNewBoss", f.Name, (int)f.Life, (int)f.MaxLife, f.CastSkill);
        }
    }

    private void OnBossSpawned(CoreEvent<Fighter> ce)
    {
        Fighter f = ce.Data;
        if (mBattle.IsNormalBattle)
        {
            if (mLuaBattleMgr == null) return;

            mLuaBattleMgr.CallCS2Lua("OnBossSpawned", f.Actor, f.Name, (int)f.Life, (int)f.MaxLife, f.CastSkill, mBattle.IsPlayRecord);
        }
        else if (mBattle.IsBossBattle)
        {
            if (mLuaBossBattleMgr == null) return;

            mLuaBossBattleMgr.CallCS2Lua("OnBossSpawned", f.Name, (int)f.Life, (int)f.MaxLife, f.CastSkill);
        }
    }

    public void OnReplayEnd()
    {
        if (mBattle.IsNormalBattle)
        {
            if (mLuaBattleMgr == null) return;

            mLuaBattleMgr.CallCS2Lua("OnReplayEnd");
        }
        else if (mBattle.IsBossBattle)
        {
            if (mLuaBossBattleMgr == null) return;

            mLuaBossBattleMgr.CallCS2Lua("OnReplayEnd");
        }
        else if (mBattle.IsVersusBattle)
        {
            if (mLuaVersusMgr == null) return;

            mLuaVersusMgr.CallCS2Lua("OnReplayEnd");
        }
        else if (mBattle.IsTimeBattle)
        {
            if (mLuaTimeBattleMgr == null) return;

            mLuaTimeBattleMgr.CallCS2Lua("OnReplayEnd");
        }
    }

    public void OnBattleEnd(int flag = 0, BattleEndInfo pEndInfo = null)
    {
        mInFighting = false;
        BattleFlyWordMgr.Instance.SetHudVisible(false);
        ActorDataMgr.Instance.ResetData();

        if (mBattle.IsNormalBattle)
        {
            if (mBattle.CurBattleField.killBoss)
            {
                mBattle.ChallengeBoss = false;
            }

            StopCameraRelieveEffect();
            CheckRoleModel();
            if (mLuaBattleMgr == null) return;

            bool bIsRecord = mBattle.CurBattleField.IsPlayingRecorder;
            if (null != pEndInfo)
                bIsRecord = pEndInfo.IsPlayRecord;

            mLuaBattleMgr.CallCS2Lua("OnBattleEnd", mBattle.CurBattleField.killBoss, FightingTime, mBattle.CurBattleField.IsWin, bIsRecord);
        }
        else if (mBattle.IsVersusBattle)
        {
            if (mLuaVersusMgr != null)
            {
                mLuaVersusMgr.CallCS2Lua("OnBattleEnd");
            }
        }
        else if (mBattle.IsBossBattle)
        {
            if (mLuaBossBattleMgr != null)
            {
                mLuaBossBattleMgr.CallCS2Lua("OnBattleEnd", flag);
            }
        }
        else if (mBattle.IsTimeBattle)
        {
            if (mLuaTimeBattleMgr != null)
            {
                mLuaTimeBattleMgr.CallCS2Lua("OnBattleEnd", mBattle.CurBattleField.IsPlayingRecorder);
            }
        }
    }
    
    public void OnBattleForceStop(bool bossBattle)
    {
        if (mBattle.IsNormalBattle)
        {
            if (mLuaBattleMgr == null) return;
            mLuaBattleMgr.CallCS2Lua("OnForceBattleFailed", bossBattle, mBattle.IsPlayRecord);
        }
        else if(mBattle.IsTimeBattle)
        {
            mLuaTimeBattleMgr.CallCS2Lua("OnForceBattleFailed");            
        }
    }

    public void OnBattleWin(bool bossBattle)
    {
        if (mBattle.IsNormalBattle)
        {
            if (mLuaBattleMgr == null) return;

            long timeStamp = DateTimeUtil.GetCurrentTimeStamp();
            string recordStr = mBattle.Recorder != null ? mBattle.Recorder.RecordStr : null;
            if (!string.IsNullOrEmpty(recordStr))
            {
                mBattleRecordList.Add(timeStamp, recordStr);
            }
            int mapId = 0;
            int levelId = 0;
            if (mBattle.CurLevelItem != null)
            {
                mapId = mBattle.CurLevelItem.MapId;
                levelId = mBattle.CurLevelItem.LevelId;
            }

            mLuaBattleMgr.CallCS2Lua("OnBattleWin", bossBattle, FightingTime, mapId, levelId, mBattle.IsPlayRecord, timeStamp);
        }
        else if (mBattle.IsBossBattle)
        {
            if (mLuaBossBattleMgr == null) return;

            mLuaBossBattleMgr.CallCS2Lua("OnBattleWin");
        }
        else if (mBattle.IsVersusBattle)
        {
            if (mLuaVersusMgr == null) return;

            mLuaVersusMgr.CallCS2Lua("OnBattleWin");
        }
        else if (mBattle.IsTimeBattle)
        {
            if (mLuaTimeBattleMgr == null) return;

            long timeStamp = DateTimeUtil.GetCurrentTimeStamp();
            if (!string.IsNullOrEmpty(mBattle.RecorderStr))
            {
                mBattleRecordList.Add(timeStamp, mBattle.RecorderStr);
            }

            List<ServerFighterParam> fighterParams = new List<ServerFighterParam>();
            for (int idx = 0; idx < mBattle.CurBattleField.TeamFighters.Count; idx++)
            {
                var f = mBattle.CurBattleField.TeamFighters[idx];
                if (f.IsPlayer)
                {
                    TimeBattle pTimeBattle = mBattle as TimeBattle;
                    float fRestorSp = 0.0f;                    
                    if(null != pTimeBattle)
                    {                      
                        fRestorSp = pTimeBattle.GetRestoreSp();//远征之门 战斗胜利后的 回蓝                      
                    }
                    float fhpPercent = (f.Life * 1.0f) / f.MaxLife;
                    float fspPercent = f.Sp / f.MaxSp + fRestorSp;
                    MathUtil.ConverFloatRound(ref fhpPercent);                   
                    MathUtil.ConverFloatRound(ref fspPercent);
                    fhpPercent = Mathf.Min(fhpPercent, 1.0f);
                    fspPercent = Mathf.Min(fspPercent, 1.0f);
                    fighterParams.Add(new ServerFighterParam(f.Actor.ID, 0, 0, fhpPercent, fspPercent));
                }
            }

            mLuaTimeBattleMgr.CallCS2Lua("OnBattleWin", mBattle.CurBattleField.BattleFrame / Constants.frame_to_time, mBattle.IsPlayRecord, timeStamp, fighterParams);
        }
    }

    public void OnBattleFailed(bool bossBattle, int bossLife = 0, int bossSp = 0,bool bIsShowFailedUi = true)
    {
        if (mBattle.IsNormalBattle)
        {
            if (mLuaBattleMgr == null) return;
           
            mLuaBattleMgr.CallCS2Lua("OnBattleFailed", bossBattle, mBattle.IsPlayRecord);
           
        }
        else if (mBattle.IsBossBattle)
        {
            if (mLuaBossBattleMgr == null) return;

            mLuaBossBattleMgr.CallCS2Lua("OnBattleFailed");
        }
        else if (mBattle.IsVersusBattle)
        {
            if (mLuaVersusMgr == null) return;

            mLuaVersusMgr.CallCS2Lua("OnBattleFailed");
        }
        else if (mBattle.IsTimeBattle)
        {
            if (mLuaTimeBattleMgr == null) return;

            List<ServerFighterParam> fighterParams = new List<ServerFighterParam>();
            for (int idx = 0; idx < mBattle.CurBattleField.TeamFighters.Count; idx++)
            {
                var f = mBattle.CurBattleField.TeamFighters[idx];
                if (f.IsPlayer)
                {
                    float fhpPercent = (f.Life * 1.0f) / f.MaxLife;
                    float fspPercent = f.Sp / f.MaxSp;
                    MathUtil.ConverFloatRound(ref fhpPercent);
                    MathUtil.ConverFloatRound(ref fspPercent);//防止丢之精度 2位后有值 向前进一位
                    fhpPercent = Mathf.Min(fhpPercent, 1.0f);
                    fspPercent = Mathf.Min(fspPercent, 1.0f);
                    fighterParams.Add(new ServerFighterParam(f.Actor.ID, 0,0, fhpPercent, fspPercent));
                }
            }
           
             mLuaTimeBattleMgr.CallCS2Lua("OnBattleFailed", mBattle.CurBattleField.BattleFrame / Constants.frame_to_time, fighterParams, bossLife, bossSp);
            
        
        }
    }

    private void OnBattleNewWave(CoreEvent<string> ce)
    {
        if (mBattle.IsNormalBattle)
        {
            if (mLuaBattleMgr == null) return;

            mCurrentLevelItem = mBattle.CurBattleField.BattleInfo;
            mLuaBattleMgr.CallCS2Lua("OnBattleNewWave", ce.Data);
        }
    }

    private void OnContinueBattle(CoreEvent<bool> ce)
    {
        if (mBattle.IsNormalBattle)
        {
            if (mLuaBattleMgr == null) return;

            mLuaBattleMgr.CallCS2Lua("OnContinueBattle");
        }
    }

    private void OnShowBossRage(CoreEvent<bool> ce)
    {
        if (mBattle.IsNormalBattle)
        {
            if (mLuaBattleMgr == null) return;

            mLuaBattleMgr.CallCS2Lua("OnShowBossRage", ce.Data, mBattle.IsPlayRecord);
        }
    }

    private void OnShowBossRageLeftTime(CoreEvent<int> ce)
    {
        if (mBattle.IsNormalBattle)
        {
            if (mLuaBattleMgr == null) return;

            mLuaBattleMgr.CallCS2Lua("OnShowBossRageLeftTime", ce.Data, mBattle.IsPlayRecord);
        }
        else if (mBattle.IsBossBattle)
        {
            if (mLuaBossBattleMgr == null) return;

            mLuaBossBattleMgr.CallCS2Lua("OnShowBossRageLeftTime", ce.Data);
        }
    }

    private void OnBossInRage(CoreEvent<bool> ce)
    {
        if (mBattle.IsNormalBattle)
        {
            if (mLuaBattleMgr == null) return;

            mLuaBattleMgr.CallCS2Lua("OnBossInRage", mBattle.IsPlayRecord);
        }
        else if (mBattle.IsBossBattle)
        {
            if (mLuaBossBattleMgr == null) return;

            mLuaBossBattleMgr.CallCS2Lua("OnBossInRage");
        }
    }

    private void OnFighterHurt(CoreEvent<UIEventParamFighterHurt> ce)
    {
        if (mBattle != null)
        {
            if (mBattle.IsBossBattle)
            {
                if (mLuaBossBattleMgr == null) return;
                UIEventParamFighterHurt hurtParam = ce.Data;
                Fighter target = hurtParam.mTarget;
                if (target.IsBoss)
                {
                    mLuaBossBattleMgr.CallCS2Lua("OnSyncBossDamage", hurtParam.mHurtVal, mBattle.IsPlayRecord);
                }
            }
            else if (mBattle.IsTimeBattle &&( mBattle.SubBattleMode == BattleSubMode.Guild || mBattle.SubBattleMode == BattleSubMode.GuildEx) )
            {
                if (mLuaTimeBattleMgr == null) return;
                UIEventParamFighterHurt hurtParam = ce.Data;
                Fighter target = hurtParam.mTarget;
                if (target.TeamSide == eTeamType.Enemy)
                {
                    mLuaTimeBattleMgr.CallCS2Lua("OnFighterHurt", hurtParam.mHurtVal);
                }
            }

        }
    }

    private void OnFighterCastSkill(CoreEvent<CastSkillData> ce)
    {
        CastSkillData skillParam = ce.Data;
        if (mBattle != null)
        {
            if (mBattle.IsNormalBattle && IsKillBoss && mLuaBattleMgr != null)
            {
                mLuaBattleMgr.CallCS2Lua("OnFighterCastSkill", skillParam, mBattle.IsPlayRecord);
            }
            else if (mBattle.IsBossBattle)
            {
                if (mLuaBossBattleMgr != null)
                    mLuaBossBattleMgr.CallCS2Lua("OnFighterCastSkill", skillParam);
            }
            else if (mBattle.IsVersusBattle)
            {
                if (mLuaVersusMgr != null)
                {
                    mLuaVersusMgr.CallCS2Lua("OnFighterCastSkill", skillParam);
                }
            }
            else if (mBattle.IsTimeBattle)
            {
                if (mLuaTimeBattleMgr != null)
                {
                    mLuaTimeBattleMgr.CallCS2Lua("OnFighterCastSkill", skillParam);
                }
            }
        }
    }

    private void OnShowBossBuffIcon(CoreEvent<stBuffParam> ce)
    {
        stBuffParam param = ce.Data;

        if (mBattle != null)
        {
            if (mBattle.IsNormalBattle && IsKillBoss && mLuaBattleMgr != null)
            {
                mLuaBattleMgr.CallCS2Lua("OnShowBossBuff", param.actorId, param.isBoss, param.buffIcon, param.pointNum, mBattle.IsPlayRecord);
            }
            else if (mBattle.IsVersusBattle)
            {
                if (mLuaVersusMgr != null)
                    mLuaVersusMgr.CallCS2Lua("OnShowBossBuff", param.teamSide, param.actorId, param.isBoss, param.buffIcon, param.pointNum);
            }
            else if (mBattle.IsBossBattle)
            {
                if (mLuaBossBattleMgr != null)
                    mLuaBossBattleMgr.CallCS2Lua("OnShowBossBuff", param.actorId, param.isBoss, param.buffIcon, param.pointNum);
            }
            else if (mBattle.IsTimeBattle)
            {
                if (mLuaTimeBattleMgr != null)
                    mLuaTimeBattleMgr.CallCS2Lua("OnShowBossBuff", param.teamSide, param.actorId, param.isBoss, param.buffIcon, param.pointNum);
            }
        }
    }

    private void OnRemoveBuffIcon(CoreEvent<stBuffParam> ce)
    {
        stBuffParam param = ce.Data;
        if (mBattle != null)
        {
            if (mBattle.IsNormalBattle && IsKillBoss && mLuaBattleMgr != null)
            {
                mLuaBattleMgr.CallCS2Lua("OnRemoveBossBuff", param.actorId, param.isBoss, param.buffIcon, mBattle.IsPlayRecord);
            }
            else if (mBattle.IsVersusBattle)
            {
                if (mLuaVersusMgr != null)
                    mLuaVersusMgr.CallCS2Lua("OnRemoveBossBuff", param.teamSide, param.actorId, param.isBoss, param.buffIcon);
            }
            else if (mBattle.IsBossBattle)
            {
                if (mLuaBossBattleMgr != null)
                    mLuaBossBattleMgr.CallCS2Lua("OnRemoveBossBuff", param.actorId, param.isBoss, param.buffIcon);
            }
            else if (mBattle.IsTimeBattle)
            {
                if (mLuaTimeBattleMgr != null)
                    mLuaTimeBattleMgr.CallCS2Lua("OnRemoveBossBuff", param.teamSide, param.actorId, param.isBoss, param.buffIcon);
            }
        }
    }

    private void OnFighterLifeChanged(CoreEvent<Fighter> ce)
    {
        if (mBattle == null) return;

        Fighter f = ce.Data;
        if (mBattle.IsNormalBattle)
        {
            if (IsKillBoss)
            {
                if (mLuaBattleMgr != null && (f.IsPlayer || f.IsBoss))
                    mLuaBattleMgr.CallCS2Lua("OnFighterLifeChanged", f.IsBoss, f.Actor.ID, (int)f.Life, (int)f.MaxLife);
            }
        }
        else if (mBattle.IsBossBattle)
        {
            if (mLuaBossBattleMgr != null && (f.IsPlayer || f.IsBoss))
                mLuaBossBattleMgr.CallCS2Lua("OnFighterLifeChanged", f.IsBoss, f.Actor.ID, (int)f.Life, (int)f.MaxLife);

        }
        else if (mBattle.IsVersusBattle)
        {
            if (mLuaVersusMgr != null && f.IsPlayer)
                mLuaVersusMgr.CallCS2Lua("OnFighterLifeChanged", f.IsBoss, f.Actor.ID, (int)f.Life, (int)f.MaxLife, (int)f.TeamSide);
        }
        else if (mBattle.IsTimeBattle)
        {
            if (mLuaTimeBattleMgr != null)
            {
                if (f.IsPlayer || f.IsBoss)
                {
                    mLuaTimeBattleMgr.CallCS2Lua("OnFighterLifeChanged", f.IsBoss,
                                                                         f.Actor.ID,
                                                                         (int)f.Life,
                                                                         (int)f.MaxLife,
                                                                         (int)f.Sp,
                                                                         (int)f.MaxSp);
                }
            }
        }
    }

    private void OnFighterEnergyChanged(CoreEvent<Fighter> ce)
    {
        Fighter f = ce.Data;
        if (mBattle != null)
        {
            if (mBattle.IsNormalBattle)
            {
                if (IsKillBoss && mLuaBattleMgr != null && f.IsPlayer)
                    mLuaBattleMgr.CallCS2Lua("OnFighterEnergyChanged", f.Actor.ID, (int)f.Sp, (int)f.MaxSp, mBattle.IsPlayRecord);
            }
            else if (mBattle.IsBossBattle)
            {
                if (mLuaBossBattleMgr != null && f.IsPlayer)
                    mLuaBossBattleMgr.CallCS2Lua("OnFighterEnergyChanged", f.Actor.ID, (int)f.Sp, (int)f.MaxSp);
            }
            else if (mBattle.IsVersusBattle)
            {
                if (mLuaVersusMgr != null && f.IsPlayer)
                {
                    mLuaVersusMgr.CallCS2Lua("OnFighterEnergyChanged", f.Actor.ID, (int)f.Sp, (int)f.MaxSp, (int)f.TeamSide);
                }
            }
            else if (mBattle.IsTimeBattle)
            {
                if (mLuaTimeBattleMgr != null && (f.IsPlayer || f.IsBoss))
                {
                    mLuaTimeBattleMgr.CallCS2Lua("OnFighterEnergyChanged", f.IsBoss,
                                                                           f.Actor.ID,
                                                                           (int)f.Life,
                                                                           (int)f.MaxLife,
                                                                           (int)f.Sp,
                                                                           (int)f.MaxSp);
                }
            }
        }
    }

    private void OnFighterSkillCDChanged(CoreEvent<SkillCDParam> ce)
    {
        if (mBattle != null && IsKillBoss)
        {
            SkillCDParam cdParam = ce.Data;
            if (mLuaBattleMgr != null)
                mLuaBattleMgr.CallCS2Lua("OnRefreshSkillCD", cdParam.isBoss, cdParam.actorId, cdParam.leftCD, cdParam.totalCD, mBattle.IsPlayRecord);
        }
    }

    private void OnShowFighter(CoreEvent<Fighter> ce)
    {
        Fighter f = ce.Data;
        if (mBattle != null)
        {
            if (mBattle.IsNormalBattle)
            {
                if (mLuaBattleMgr != null)
                    mLuaBattleMgr.CallCS2Lua("OnShowFighter", f.Id, mBattle.IsPlayRecord);
            }
            else if (mBattle.IsBossBattle)
            {
                if (mLuaBossBattleMgr != null)
                    mLuaBossBattleMgr.CallCS2Lua("OnShowFighter", f.Id);
            }
        }
    }

    Dictionary<string, GameObject> mSkillPrefabs = new Dictionary<string, GameObject>();
    private void OnShowSkillPrefab(CoreEvent<string> ce)
    {
        string prefabName = ce.Data;
        if (string.IsNullOrEmpty(prefabName)) return;

        GameObject skillPrefab = ResourceMgr.Instance.GetGoFromPool(Constants.UIPath, prefabName);
        if (skillPrefab != null)
        {
            Transform hudPanel = BattleFlyWordMgr.Instance.HudRootTrans;
            if (hudPanel != null)
            {
                skillPrefab.transform.SetParent(hudPanel, true);
                skillPrefab.transform.localScale = Vector3.one;
                skillPrefab.transform.localRotation = Quaternion.identity;
            }

            RectTransform rt = skillPrefab.GetComponent<RectTransform>();
            rt.anchorMin = Vector2.zero;
            rt.anchorMax = Vector2.one;
            rt.anchoredPosition3D = Vector3.zero;
            rt.offsetMin = rt.offsetMax = Vector2.zero;
            mSkillPrefabs.Add(prefabName, skillPrefab);
        }
    }

    private void OnCloseSkillPrefab(CoreEvent<string> ce)
    {
        string prefabName = ce.Data;
        if (string.IsNullOrEmpty(prefabName)) return;

        if (mSkillPrefabs.ContainsKey(prefabName))
        {
            GameObject go = mSkillPrefabs[prefabName];
            mSkillPrefabs.Remove(prefabName);
            ResourceMgr.Instance.RecycleGO(Constants.UIPath, prefabName, go);
        }
    }

    private void OnBattleUIVis(CoreEvent<bool> ce)
    {
        if (mBattle != null)
        {
            if (mBattle.IsNormalBattle)
            {
                if (mLuaBattleMgr != null)
                    mLuaBattleMgr.CallCS2Lua("OnBattleUIVis", ce.Data);

                if (BattleFlyWordMgr.Instance.HudRoot != null)
                    BattleFlyWordMgr.Instance.HudRoot.SetActive(ce.Data);
            }
        }
    }

    public void ShowBossWarning()
    {
        if (mBattle.IsNormalBattle)
        {
            if (mLuaBattleMgr == null) return;

            if (!mBattle.IsPlayRecord)
                mLuaBattleMgr.CallCS2Lua("OnShowBossWarning");
        }
        else if (mBattle.IsBossBattle)
        {
            if (mLuaBossBattleMgr == null) return;

            mLuaBossBattleMgr.CallCS2Lua("OnShowBossWarning");
        }
    }

    public void ShowPVPPressPoint()
    {       
        if (mLuaVersusMgr == null) return;
        mLuaVersusMgr.CallCS2Lua("OnShowPvpPressPoint");        
    }
   
    //显示战斗结束转场
    public void ShowBattleEndInterlude()
    {
        if (mLuaVersusMgr != null)
        {
            mLuaVersusMgr.CallCS2Lua("ShowBattleEndInterlude");
        }
    }

    //开始巡游
    public void OnBeginSearch()
    {
        mBattle.TeamIntoBattlField();
        SetFollowCamera(Vector3.zero);
    }

    //更新队伍数据  技能等级
    public void SyncTeamData()
    {
        bool bIsProcessLoad = false;//是否有更新加载
        if (!mBattle.IsPlayRecord)
        {
            SetTeamData();
            CheckSkill();
            bIsProcessLoad = CheckProfession();
            SyncTeamName();
        }
        if (bIsProcessLoad || bRoleModelDirty)     //是否需要刷新形象
        {           
            NotifyRefreshRoleView(); //刷新形象
            CheckRoleModel();
        }        
    }

    public void SyncTeamName()
    {
        //HeroActorData hero = GameMgr.Instance.CharacterInfo.Actor; 
        //HeroActorData Battlehero = GameMgr.Instance.CharacterInfo.mBattleActor;
        //if(null != hero && null != Battlehero)
        //{
        //    Battlehero.Name = hero.Name;//战斗数据同步  源数据
        //}
    }

    public void CheckSkill()
    {
        //同步主属性       
        bool needLoad = false;
        foreach (var p in dirtySkills)
        {            
            ActorData ad = ActorDataMgr.Instance.GetActorsById(p.Key);
            if (ad != null)
            {
                needLoad = ad.SkillMgr.SetSkillLevels(p.Value);
                ad.ResetFirstSkill();                
            }            
        }
        if (null == mBattle)
            return;
        //同步战斗属性
        if (skillDirty)
        {                 
            foreach (var p in dirtySkills)
            {               
                Fighter f = mBattle.FighterMgr.GetTeamMemberById(p.Key);
                if (f != null)
                {
                    bool ret = f.Actor.SkillMgr.SetSkillLevels(p.Value);
                    needLoad |= ret;
                    f.Actor.ResetFirstSkill();
                }
            }

            if (needLoad)
            {
                BattlePrepareManager.Instance.StartLoad();
            }
            skillDirty = false;
        }
    }

    public bool CheckProfession()
    {
        if (professionDirty)
        {
            HeroActorData hero = GameMgr.Instance.CharacterInfo.Actor; //更新源数据
            //HeroActorData Battlehero = GameMgr.Instance.CharacterInfo.mBattleActor;//更新备份战斗数据
            //Battlehero.SetProfessionId(mCacheJobId, true);
            hero.SetProfessionId(mCacheJobId, true);
            BattlePrepareManager.Instance.StartLoad();

            if (IsLoadingBattleAssets)
            {
                for (int idx = 0; idx < mBattle.FighterMgr.TeamFighters.Count; idx++)
                {
                    mBattle.FighterMgr.TeamFighters[idx].Ctrl.EnableNavAgent(false);
                }
            }

            professionDirty = false;

            //通知lua 主角转职正式完成
            if (mBattle.IsNormalBattle)
            {
                if (mLuaBattleMgr != null) 
                    mLuaBattleMgr.CallCS2Lua("HeroChangeProfessionSuccess");
            }
            else if (mBattle.IsBossBattle)
            {
                if (mLuaBossBattleMgr != null)
                    mLuaBossBattleMgr.CallCS2Lua("HeroChangeProfessionSuccess");
            }
            return true;
        }
        return false;
    }

    public void ForceSyncSkill()
    {
        if (skillDirty)
        {
            foreach (var p in dirtySkills)
            {
                ActorData actor = ActorDataMgr.Instance.GetActorsById(p.Key);
                if (actor != null && p.Value != null)
                {
                    actor.RefreshSkills(p.Value.ToArray());
                }
            }

            skillDirty = false;
        }
    }

    public void RefreshStatistics()
    {
        if (mBattle.IsNormalBattle)
        {
            if (mLuaBattleMgr != null)
                mLuaBattleMgr.CallCS2Lua("RefreshStatistics");
        }
        else if (mBattle.IsTimeBattle)
        {
            if (mLuaTimeBattleMgr != null)
                mLuaTimeBattleMgr.CallCS2Lua("RefreshStatistics");
        }
        else if (mBattle.IsVersusBattle)
        {
            if (mLuaVersusMgr != null)
                mLuaVersusMgr.CallCS2Lua("RefreshStatistics");
        }
    }


    
    int notifiedStatus = -1;
    public void NotifyLoadingStatus(int status)
    {
        if (mBattle != null)
        {
            if (mLuaBattleMgr != null)
                mLuaBattleMgr.CallCS2Lua("NotifyLoadingStatus", status);
        }
    }

    public void NotifyLoadingStatusEnd()
    {
        if (mBattle != null)
        {
            if (mLuaBattleMgr != null)
                mLuaBattleMgr.CallCS2Lua("NotifyLoadingStatusEnd", notifiedStatus);
        }
    }

    public void StartingFight()
    {
        if (mBattle != null)
        {
            if (mLuaVersusMgr != null)
                mLuaVersusMgr.CallCS2Lua("OnStartingFight");
        }
    }

    public void Skip()
    {
        if (mBattle.IsPlayRecord)
            mBattle.Recorder.Skip();
    }

    public const int m_angle_effect_id_cfgid = 32;
    int cameraRelieveEffectIstanceId = 0;
    public void PlayCameraReliveEffect()
    {
        if (cameraRelieveEffectIstanceId > 0) return;

        int effectId = GlobalConfig.Instance.GetConfigIntValue(m_angle_effect_id_cfgid);
        if (effectId > 0)
        {
            cameraRelieveEffectIstanceId = EffectManager.Instance.PlayEffect(effectId);
        }
    }

    public void StopCameraRelieveEffect()
    {
        if (cameraRelieveEffectIstanceId > 0)
        {
            cameraRelieveEffectIstanceId = 0;
        }
    }

    void WorldPos2MinimapPos(Vector3 pos, int mapSizeX, int mapSizeZ, int miniMapSizeX, int miniMapSizeZ, ref float x, ref float z)
    {
        float xRate = pos.x / mapSizeX;
        float zRate = pos.z / mapSizeZ;
        x = miniMapSizeX * xRate;
        z = miniMapSizeZ * zRate;
    }

    public void RefreshMinimap(Vector3 center, int mapSizeX, int mapSizeZ, int miniMapSizeX, int miniMapSizeZ, GameObject hero, params RectTransform[] goes)
    {
        GetFightersPos();
        int cnt = mFightersPos.Count;
        if (cnt < 2 || goes.Length < 1 || hero == null) return;

        //设置主角的位置
        RectTransform miniMapGO = goes[0];
        float mapX = 0, mapZ = 0;
        WorldPos2MinimapPos(mFightersPos[0], mapSizeX, mapSizeZ, miniMapSizeX, miniMapSizeZ, ref mapX, ref mapZ);
        Vector3 pos = miniMapGO.anchoredPosition;
        pos.x = miniMapSizeX * ((float)center.x / mapSizeX) - mapX;
        pos.y = miniMapSizeZ * ((float)center.z / mapSizeZ) - mapZ;
        miniMapGO.anchoredPosition = pos;

        //设置主角的朝向
        Vector3 rot = mFightersPos[1];
        rot.x = 0; rot.z = -rot.y; rot.y = 0;
        hero.transform.localRotation = Quaternion.Euler(rot);

        //设置怪物的位置
        for (int idx = 1; idx < goes.Length; idx++)
        {
            if (idx + 1 >= cnt)
            {
                goes[idx].gameObject.SetActive(false);
            }
            else
            {
                goes[idx].gameObject.SetActive(true);
                Vector3 deltaPos = mFightersPos[idx + 1] - mFightersPos[0];
                float enemyX = 0, enemyZ = 0;
                WorldPos2MinimapPos(deltaPos, mapSizeX, mapSizeZ, miniMapSizeX, miniMapSizeZ, ref enemyX, ref enemyZ);

                var p = goes[idx].anchoredPosition;
                p.x = enemyX;
                p.y = enemyZ;
                goes[idx].anchoredPosition = p;
            }
        }
    }

    List<Vector3> mFightersPos = new List<Vector3>();
    public List<Vector3> GetFightersPos()
    {
        mFightersPos.Clear();
        if (mBattle == null || mBattle.CurBattleField == null || !mBattle.IsNormalBattle) return mFightersPos;

        if (mBattle.CurBattleField.TeamFighters.Count > 0)
        {
            mFightersPos.Add(mBattle.CurBattleField.TeamFighters[0].Position);
            mFightersPos.Add(mBattle.CurBattleField.TeamFighters[0].Ctrl.transform.rotation.eulerAngles);
        }

        for (int idx = 0; idx < mBattle.CurBattleField.EnemyFighters.Count; idx++)
        {
            mFightersPos.Add(mBattle.CurBattleField.EnemyFighters[idx].Position);
        }
        return mFightersPos;
    }

    void OnStartMoveMouse(CoreEvent<Vector2> ce)
    {
        if (mBattle == null) return;

        if (!mBattle.IsNormalBattle) return;

        if (mBattle.IsKillingBoss) return;

        IsRotatingCam = true;

        BattleCamera.Instance.BeginCamRotate();
    }

    void OnEndMoveMouse(CoreEvent<Vector2> ce)
    {
        if (mBattle == null) return;

        if (!mBattle.IsNormalBattle) return;

        if (mBattle.IsKillingBoss) return;

        IsRotatingCam = false;

        BattleCamera.Instance.RestoreCamRotate();
    }

    //bool newScene = false;
    //void OnSwitchScene(CoreEvent<string> ce)
    //{
    //    newScene = true;
    //}

    //void OnRestoreScene(CoreEvent<bool> ce)
    //{
    //    newScene = false;
    //}

    void OnLoadTeam(CoreEvent<bool> ce)
    {
        if (mBattle.IsLoadingActor)
        {
            NotifyLoadingStatus(1);
            for (int idx = 0; idx < mBattle.FighterMgr.TeamFighters.Count; idx++)
            {
                mBattle.FighterMgr.TeamFighters[idx].Ctrl.EnableNavAgent(false);
            }
        }
        else
        {
            if (!IsLoadingBattleAssets)
            {
                mBattle.MoveToNextBattleField(false);
            }
            NotifyLoadingStatusEnd();
        }
    }

    void OnPrepareLoadOk(CoreEvent<bool> ce)
    {
        if (mBattle == null) return;

        if (mBattle.Mode != BattleMode.Normal) return;

        if (!IsLoadingBattleAssets)
        {
            NotifyLoadingStatusEnd();
        }
    }

    void OnReplayBattleLoadedOk(CoreEvent<bool> ce)
    {
        if (mBattle == null) return;

        if (mBattle.IsNormalBattle)
        {
            if (mLuaBattleMgr == null) return;

            mLuaBattleMgr.CallCS2Lua("OnLoadComplete");
        }
        else if (mBattle.IsVersusBattle)
        {
            if (mLuaVersusMgr == null) return;

            mLuaVersusMgr.CallCS2Lua("OnLoadComplete");
        }
        else if (mBattle.IsBossBattle)
        {
            if (mLuaBossBattleMgr == null) return;

            mLuaBossBattleMgr.CallCS2Lua("OnLoadComplete");
        }
        else if (mBattle.IsTimeBattle)
        {
            if (mLuaTimeBattleMgr == null) return;

            mLuaTimeBattleMgr.CallCS2Lua("OnLoadComplete");
        }
    }

    public bool IsLoadingBattleAssets
    {
        get { return (mBattle != null && mBattle.IsLoadingActor) || BattlePrepareManager.Instance.IsLoading; }
    }

    public void CheckRoleModel()
    {
        if (!bRoleModelDirty) return;

        mLuaBattleMgr.CallCS2Lua("RefreshRoleView");

        bRoleModelDirty = false;
    }

    private bool bHasLoadedRole = false;
    private bool bLoadingRoleModel = false;
    private GameObject mRoleModelGo = null;
    private bool bRoleModelDirty = false;

    public bool LoadingRoleModel
    {
        get { return bLoadingRoleModel; }
    }

    public GameObject RoleModelGo
    {
        get
        {
            return mRoleModelGo;
        }
    }

    public void LoadRole()
    {
        if (bHasLoadedRole) return;

        bLoadingRoleModel = true;
        mLuaBattleMgr.CallCS2Lua("CreateRoleView");
    }

    public void OnLoadRoleCompleted(GameObject go, bool bRefresh, bool isNew)
    {
        bLoadingRoleModel = false;
        bHasLoadedRole = true;
        mRoleModelGo = go;
        if (bRefresh && isNew && mBattle != null)
        {
            var f = mBattle.FighterMgr.GetTeamMemberById(1);
            if (f.Ctrl != null)
                f.Ctrl.RebindAvatarGo(go);

            mBattle.MoveToNextBattleField(false);
            f.Ctrl.Animator.Play(FighterAnimatorHash.StateRun);
        }
    }

    public void NotifyRefreshRoleView()
    {
        bRoleModelDirty = true;
    }

    public string PopBattleRecord(long timeStamp)
    {
        if (mBattleRecordList.ContainsKey(timeStamp))
        {
            string recordStr = mBattleRecordList[timeStamp];
            mBattleRecordList.Remove(timeStamp);
            return recordStr;
        }
        return null;
    }

    public void ShowSkipBattle()
    {
        if (mBattle.IsBossBattle)
        {
            if (mLuaBossBattleMgr == null) return;

            mLuaBossBattleMgr.CallCS2Lua("ShowSkipBattle");
        }
    }

    void OnLoadBegin(CoreEvent<bool> ce)
    {
        if (mBattle == null) return;

        if (mBattle.IsNormalBattle)
        {
            if (mLuaBattleMgr == null) return;

            mLuaBattleMgr.CallCS2Lua("OnLoadBegin");
        }
        else if (mBattle.IsBossBattle)
        {
            if (mLuaBossBattleMgr == null) return;

            mLuaBossBattleMgr.CallCS2Lua("OnLoadBegin");
        }
        else if (mBattle.IsVersusBattle)
        {
            if (mLuaVersusMgr == null) return;

            mLuaVersusMgr.CallCS2Lua("OnLoadBegin");
        }
        else if (mBattle.IsTimeBattle)
        {
            if (mLuaTimeBattleMgr == null) return;

            mLuaTimeBattleMgr.CallCS2Lua("OnLoadBegin");
        }
    }

    void OnLoadComplete(CoreEvent<bool> ce)
    {
        if (mBattle == null) return;

        if (mBattle.IsNormalBattle)
        {
            if (mLuaBattleMgr == null) return;

            mLuaBattleMgr.CallCS2Lua("OnLoadComplete");
        }
        else if (mBattle.IsVersusBattle)
        {
            if (mLuaVersusMgr == null) return;

            mLuaVersusMgr.CallCS2Lua("OnLoadComplete");
        }
        else if (mBattle.IsBossBattle)
        {
            if (mLuaBossBattleMgr == null) return;

            mLuaBossBattleMgr.CallCS2Lua("OnLoadComplete");
        }
        else if (mBattle.IsTimeBattle)
        {
            if (mLuaTimeBattleMgr == null) return;

            mLuaTimeBattleMgr.CallCS2Lua("OnLoadComplete");
        }
    }

    void OnLoadProgress(CoreEvent<float> ce)
    {
        if (mBattle == null) return;

        if (mBattle.IsNormalBattle)
        {
            if (mLuaBattleMgr == null) return;

            mLuaBattleMgr.CallCS2Lua("OnLoadProgress", ce.Data);
        }
        else if (mBattle.IsVersusBattle)
        {
            if (mLuaVersusMgr == null) return;

            mLuaVersusMgr.CallCS2Lua("OnLoadProgress", ce.Data);
        }
        else if (mBattle.IsBossBattle)
        {
            if (mLuaBossBattleMgr == null) return;

            mLuaBossBattleMgr.CallCS2Lua("OnLoadProgress", ce.Data);
        }
        else if (mBattle.IsTimeBattle)
        {
            if (mLuaTimeBattleMgr == null) return;

            mLuaTimeBattleMgr.CallCS2Lua("OnLoadProgress", ce.Data);
        }
    }
}
