using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public enum BattleMode
{
    None = 0,        //非法
    Normal = 1,      //正常巡游战斗
    Versus = 2,      //对战
    Boss = 3,        //挑战boss
    Time = 4,        //时间模式的战斗
}

public enum PreloadingStep
{
    None,
    LoadingScene,
    LoadingRoleAssets,
    LoadingFlywordAssets,
    LoadingPrepareAssets,
    LoadingInstantiate,
    OpeningScreen,
}

public class BattleEndCondition
{
    public int endType;         //判断结束条件类型: 1: 队伍阵亡； 2: 超时; 3: 达到伤害量
    public int endVal;          //数值
    public int resultType;      //结束的结果类型 1:正常流程， 2：特殊情况
    public bool win;            //结果类型为特殊时：true 胜利，false:失败
    
    public BattleEndCondition()
    {

    }

    public BattleEndCondition(int type,int resultType)
    {
        this.endType = type;
        this.resultType = resultType;
    }

    public BattleEndCondition(int type,int val,int resultType,bool win)
    {
        this.endType = type;
        this.endVal = val;
        this.resultType = resultType;
        this.win = win;
    }
}

public class BaseBattle
{
    #region Rand_Module
    protected NPack.MersenneTwister _rand;

    //	int randCallCount = 0;
    /// <summary>
    /// Randoms the value
    /// </summary>
    /// <returns>The value between [0, 1).</returns>
    public float RandomValue()
    {
        return _rand.NextSingle();
    }

    /// <summary>
    /// Randoms the value.
    /// </summary>
    /// <returns>The value between [0, 1] or [0, 1).</returns>
    /// <param name="includeOne">If set to <c>true</c> include one.</param>
    public float RandomValue(bool includeOne)
    {
        return _rand.NextSingle(includeOne);
    }

    /// <summary>
    /// Randoms the value.
    /// </summary>
    /// <returns>The value between [min, max).</returns>
    /// <param name="min">Minimum.</param>
    /// <param name="max">Max.</param>
    public float RandomValue(float min, float max)
    {
        return min + _rand.NextSingle() * (max - min);
    }

    /// <summary>
    /// Randoms the value.
    /// </summary>
    /// <returns>The value between [min, max] or [min, max).</returns>
    /// <param name="min">Minimum.</param>
    /// <param name="max">Max.</param>
    /// <param name="includeMax">If set to <c>true</c> include max.</param>
    public float RandomValue(float min, float max, bool includeMax)
    {
        return min + _rand.NextSingle(includeMax) * (max - min);
    }

    /// <summary>
    /// Randoms the value.
    /// </summary>
    /// <returns>The value int between [min, max).</returns>
    /// <param name="min">Minimum.</param>
    /// <param name="max">Max.</param>
    public int RandomValue(int min, int max)
    {
        return max > min ? _rand.Next(min, max) : min;
    }

    /// <summary>
    /// Randoms the value.
    /// </summary>
    /// <returns>The value int between [min, max] or [min, max).</returns>
    /// <param name="min">Minimum.</param>
    /// <param name="max">Max.</param>
    /// <param name="includeMax">If set to <c>true</c> include max.</param>
    public int RandomValue(int min, int max, bool includeMax)
    {
        return max > min ? _rand.Next(min, includeMax ? max : max - 1) : min;
    }

    /// <summary>
    /// Randoms the int.
    /// </summary>
    /// <returns>The int.</returns>
    public int RandomInt()
    {
        return _rand.Next(int.MaxValue);
    }
    #endregion

    protected int mFrameCount;
    public int FrameCount { get { return mFrameCount; } }

    private BattleMode mBattleMode = BattleMode.None;
    public BattleMode Mode { get { return mBattleMode; } }

    public virtual BattleSubMode SubBattleMode { get { return BattleSubMode.None; } }

    public int RandSeed { get; protected set; }


    public ValType[] Factors { get; set; }

    protected BattleField mBattleField;

    public BattleField CurBattleField
    {
        get { return mBattleField; }
    }

    public bool IsFighting { get { return mBattleField != null ? mBattleField.IsFightingState : false; } }

    public virtual int CurLevelMonsterLv { get { return 1; } }

    public virtual List<ActorData> MyFighters { get { return null; } }

    public virtual List<ActorData> EnemyFighters { get { return null; } }

    public virtual List<ActorData> TeamActors { get { return null; } }

    public virtual List<ActorData> EnemyActors { get { return null; } }

    public virtual List<ActorData> TeamPlayerActors { get { return null; } }

    public virtual List<ActorData> EnemyPlayerActors { get { return null; } }


    public virtual LevelItem CurLevelItem { get { return null; } }

    public virtual Vector3 BattleBossCamPos { get { return Vector3.zero; } }

    public virtual Vector3 BattleBossCamRot { get { return Vector3.zero; } }

    public virtual float BattleCamFar { get { return 0; } }

    public virtual bool IsKillingBoss { get { return false; } }

    public BattleStatistics BattleStatistics { get; private set; }

    public BattleOutput BattleOut { get; private set; }


    public FighterManager FighterMgr { get; set; }

    public GlobalTrigger globalTrigger
    {
        get;set;
    }

    public bool ChallengeBoss { get; set; }

    public bool IsLogicOnly { get; protected set; }

    private bool mIsLoadingActor = false;
    public bool IsLoadingActor
    {
        get { return mIsLoadingActor; }
        set { mIsLoadingActor = value; }
    }

    public bool IsNormalBattle
    {
        get { return mBattleMode == BattleMode.Normal; }
    }

    public bool IsVersusBattle
    {
        get { return mBattleMode == BattleMode.Versus; }
    }

    public bool IsBossBattle
    {
        get { return mBattleMode == BattleMode.Boss; }
    }

    public bool IsTimeBattle
    {
        get { return mBattleMode == BattleMode.Time; }
    }

    private bool mServerAckOk = false;
    public bool ServerAckOk
    {
        get { return mServerAckOk; }
        set { mServerAckOk = value; }
    }

    private float mFighterLiftRatio = 1.0f;
    public float FighterLifeRatio
    {
        get { return mFighterLiftRatio; }
        set { mFighterLiftRatio = value; }
    }

    //暫時只在PVP生效
    private int mBattleBeginMarkId = -1;
    public int BattleBeginMarkId
    {
        get { return mBattleBeginMarkId; }
        set { mBattleBeginMarkId = value; }
    }

    public virtual Vector3 TeamCenter
    {
        get
        {
            Vector3 min = Vector3.zero;
            Vector3 max = Vector3.zero;
            bool hasSet = false;
            if(FighterMgr.TeamHeroFighters!=null)
            {
                for (int idx = 0; idx < FighterMgr.TeamHeroFighters.Count; idx++)
                {
                    Fighter f = FighterMgr.TeamHeroFighters[idx];
                    if (!hasSet)
                    {
                        min = f.Position;
                        max = f.Position;
                        hasSet = true;
                    }
                    else
                    {
                        min = Vector3.Min(f.Position, min);
                        max = Vector3.Max(f.Position, max);
                    }
                }
            }

            return 0.5f * (min + max) + Vector3.up * 1.0f;
        }
    }

    public bool IsPlayRecord { get; protected set; }

    public string RecorderStr { get; set; }

    public BattleRecorder Recorder { get; protected set; }


    private List<BattleEndCondition> mEndCondList;
    public List<BattleEndCondition> EndCondList
    {
        get { return mEndCondList; }
    }

    private bool m_bIsShutDown = false;
    public bool IsShutDown
    {
        get { return m_bIsShutDown; }
        set { m_bIsShutDown = value; }
    }

    public BaseBattle(BattleMode mode,List<BattleEndCondition> endCondList)
    {
        mBattleMode = mode;
        IsPlayRecord = false;
        InitStatistics();
        RegisterEvents();
        RecorderStr = null;
        mEndCondList = endCondList;
        IsShutDown = false;
    }


    public void SetRandSeed(int randSeed = 0)
    {
        RandSeed = randSeed > 0 ? randSeed : Random.Range(1, int.MaxValue);
        _rand = new NPack.MersenneTwister(RandSeed);
    }

    public void SetBattleField(BattleField battleField)
    {
        mBattleField = battleField;
    }

    public virtual void Start(int seed = 0,ValType[] factors = null)
    {
        if (!IsPlayRecord)
        {
            SetRandSeed(seed);
            Factors = factors;
        }
        else
        {
            SetRandSeed(Recorder.Seed);
            Factors = Recorder.Factors;
        }

        mFrameCount = 0;
        GameMgr.RandSeed = RandSeed;
    }

    public virtual void OnLoadComplete()
    {
        NotifyLoadProgress(1.0f);
        EventMgr.DispatchEvent<bool>(new CoreEvent<bool>(ECoreEventType.EID_LOAD_COMPLETE, true));
    }

    public virtual void Update(float deltaTime)
    {
        mFrameCount++;
        if(BattleStatistics!=null)
        {
            BattleStatistics.AnalyzeData();
        }
    }

    public virtual void ShutDown()
    {
        UnregisterEvents();
        IsShutDown = true;
    }

    public virtual void Dispose()
    {
        //if (BattleStatistics != null)
        //{
        //    BattleStatistics.Dispose();
        //    BattleStatistics = null;
        //}    

        if(BattleOut != null)
        {
            BattleOut.Dispose();
            BattleOut = null;
        }

        if (mBattleField != null)
        {
            mBattleField.Dispose();
            mBattleField = null;
        }

        if (FighterMgr != null)
        {
            FighterMgr.Dispose();
            FighterMgr = null;
        }

        if(globalTrigger != null)
        {
            globalTrigger.Dispose();
            globalTrigger = null;
        }

        if(mEndCondList != null)
        {
            mEndCondList.Clear();
            mEndCondList = null;
        }

        BattlePrepareManager.Instance.Clear();
        BattleCamera.Instance.Clear();
        ResourceMgr.Instance.ClearAllResource();
        MusicMgr.Instance.RemoveAllSound();
        MusicMgr.Instance.Clean();
        GameMgr.Instance.CleanUnusedAssets();
        mBattleMode = BattleMode.None;
    }

    public virtual void EnterNextBattle()
    {

    }

    public virtual void ContinueCurrentBattle()
    {

    }

    public virtual void AddActor(ActorData actor,eTeamType teamSide = eTeamType.Friend,bool spawn = true)
    {

    }

    public virtual void RemoveActor(long actorId)
    {

    }

    public virtual void SyncActorLife(long actorId,int hp)
    {

    }

    public virtual void SyncBossLife(int life)
    {

    }

    public virtual void SyncFighterPos(Fighter f)
    {

    }

    public virtual void FighterMove2BattleCenter(Fighter f,Vector3 pos)
    {

    }

    public virtual void CalcNextPoint()
    { }

    public virtual bool AddNewActors(List<ActorData> actors, eTeamType teamside = eTeamType.Friend, bool spawn = true)
    {
        return false;
    }

    public virtual void MoveToNextBattleField(bool setStopDistance)
    {

    }

    public virtual void StartStoryScript()
    {

    }

    public void TeamIntoBattlField()
    {
        if (CurBattleField == null) return;

        List<Fighter> Members = FighterMgr.TeamFighters;

        for (int idx = 0; idx < Members.Count; idx++)
        {
            Fighter member = Members[idx];
            member.StateData.Clear();
            CurBattleField.AddFighter(member);
        }
    }

    public void SetLoadSetting()
    {
        QualitySettings.asyncUploadBufferSize = 32;
        QualitySettings.asyncUploadTimeSlice = 8;
        Application.backgroundLoadingPriority = ThreadPriority.High;
    }

    public void RestoreLoadSetting()
    {
        QualitySettings.asyncUploadBufferSize = 16;
        QualitySettings.asyncUploadTimeSlice = 4;
        Application.backgroundLoadingPriority = ThreadPriority.Normal;
    }

    public virtual bool IsAllFightersReady()
    {
        List<Fighter> fighters = FighterMgr.AllFighters;

        for (int idx = 0; idx < fighters.Count; idx++)
        {
            if (!fighters[idx].IsIdle)
                return false;
        }
        return true;
    }

    public void NotifyLoadProgress(float progress)
    {
        EventMgr.DispatchEvent<float>(new CoreEvent<float>(ECoreEventType.EID_LOAD_PROGRESS, progress));
    }

    public void GetBattleFactors(out int magicAtkFactor,out int atkFactor,out int hpFactor,out int spFactor)
    {
        magicAtkFactor = FindBattleFactor(ActorData.Attr_MagicAttack);
        atkFactor = FindBattleFactor(ActorData.Attr_Attack);
        hpFactor = FindBattleFactor(ActorData.Attr_MaxHp);
        spFactor = FindBattleFactor(ActorData.Attr_MaxSp);
        
    }

    public int FindBattleFactor(int attrId)
    {
        if (Factors == null) return 0;

        for(int idx =0; idx < Factors.Length;idx++)
        {
            if (Factors[idx].id == attrId) return Factors[idx].val;
        }

        return 0;
    }

    private void RegisterEvents()
    {
        EventMgr.AddEventListener<object[]>(ECoreEventType.EID_FIGHTER_HEAL, OnFighterHeal);
        EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_FIGHTER_DO_SKILL, OnFighterDoSkill);
        EventMgr.AddEventListener<Fighter, string>(ECoreEventType.EID_NEGATIVE_FUNCTION, OnFighterNegativeFun);
        EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_Fighter_Attack, OnFighterAttack);
        EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_Fighter_BeHit, OnFighterBeHit);
        EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_Fighter_Treatment, OnFighterTreatment);
        EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_Fighter_Vertigo, OnFighterVertigo);
        EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_Fighter_Damage_FromCrit, OnFighterDamageFromCrit);
        EventMgr.AddEventListener<Fighter, BaseSkill>(ECoreEventType.EID_Fighter_Damage_WithCrit, OnFighterDamageWithCrit);
        EventMgr.AddEventListener<Fighter, BaseSkill>(ECoreEventType.EID_Fighter_Damage_Avoid, OnFighterDamageAvoid);
        EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_FIGHTER_DODGE, OnFighterDodge);
        EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_Fighter_HP_Lower, OnFighterHp);
        EventMgr.AddEventListener<Fighter, BaseSkill>(ECoreEventType.EID_Fighter_Break_Skill, OnFighterBreakSkill);
        EventMgr.AddEventListener<Fighter, BaseSkill>(ECoreEventType.EID_Fighter_Skill_Broken, OnFighterSkillBroken);
        EventMgr.AddEventListener<Fighter,int>(ECoreEventType.EID_Fighter_AddSp, OnFighterAddSp);
        EventMgr.AddEventListener<Fighter, BaseSkill>(ECoreEventType.EID_Fighter_Kill, OnFighterKill);
        EventMgr.AddEventListener<Fighter, BaseSkill>(ECoreEventType.EID_Fighter_Disperse_Buff, OnFighterDisperseBuff);
        EventMgr.AddEventListener<Fighter, BaseSkill>(ECoreEventType.EID_Fighter_Purify_Debuff, OnFighterPurifyDebuff);
        EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_FIGHTER_ADD_SHIELD, OnFighterAddShield);
        EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_FIGHTER_CLEAR_SHIELD, OnFighterClearShield);
        EventMgr.AddEventListener<UIEventParamFighterHurt>(ECoreEventType.EID_FIGHTER_HURT, OnFighterHurt);

        EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_Fighter_Silence, OnFighterSilence);
        EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_Fighter_Curse, OnFighterCurse);
    }

    private void UnregisterEvents()
    {
        EventMgr.RemoveEventListener<object[]>(ECoreEventType.EID_FIGHTER_HEAL, OnFighterHeal);
        EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_FIGHTER_DO_SKILL, OnFighterDoSkill);
        EventMgr.RemoveEventListener<Fighter, string>(ECoreEventType.EID_NEGATIVE_FUNCTION, OnFighterNegativeFun);
        EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_Fighter_Attack, OnFighterAttack);
        EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_Fighter_BeHit, OnFighterBeHit);
        EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_Fighter_Treatment, OnFighterTreatment);
        EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_Fighter_Vertigo, OnFighterVertigo);
        EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_Fighter_Damage_FromCrit, OnFighterDamageFromCrit);
        EventMgr.RemoveEventListener<Fighter, BaseSkill>(ECoreEventType.EID_Fighter_Damage_WithCrit, OnFighterDamageWithCrit);
        EventMgr.RemoveEventListener<Fighter, BaseSkill>(ECoreEventType.EID_Fighter_Damage_Avoid, OnFighterDamageAvoid);
        EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_FIGHTER_DODGE, OnFighterDodge);
        EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_Fighter_HP_Lower, OnFighterHp);
        EventMgr.RemoveEventListener<Fighter, BaseSkill>(ECoreEventType.EID_Fighter_Break_Skill, OnFighterBreakSkill);
        EventMgr.RemoveEventListener<Fighter, BaseSkill>(ECoreEventType.EID_Fighter_Skill_Broken, OnFighterSkillBroken);
        EventMgr.RemoveEventListener<Fighter,int>(ECoreEventType.EID_Fighter_AddSp, OnFighterAddSp);
        EventMgr.RemoveEventListener<Fighter, BaseSkill>(ECoreEventType.EID_Fighter_Kill, OnFighterKill);
        EventMgr.RemoveEventListener<Fighter,BaseSkill>(ECoreEventType.EID_Fighter_Disperse_Buff, OnFighterDisperseBuff);
        EventMgr.RemoveEventListener<Fighter, BaseSkill>(ECoreEventType.EID_Fighter_Purify_Debuff, OnFighterPurifyDebuff);
        EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_FIGHTER_ADD_SHIELD, OnFighterAddShield);
        EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_FIGHTER_CLEAR_SHIELD, OnFighterClearShield);
        EventMgr.RemoveEventListener<UIEventParamFighterHurt>(ECoreEventType.EID_FIGHTER_HURT, OnFighterHurt);
        
        EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_Fighter_Silence, OnFighterSilence);
        EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_Fighter_Curse, OnFighterCurse);   
    }

    private void OnFighterHurt(CoreEvent<UIEventParamFighterHurt> ce)
    {
        CheckPassiveBuff(BuffTriggerType.Trigger_Accumulative_TakeDamage, ce.Data.mTarget);
        CheckPassiveBuff(BuffTriggerType.Trigger_Multi_Accumulative_TakeDamage, ce.Data.mTarget);

        CheckPassiveBuff(BuffTriggerType.Trigger_Accumulative_TakeDamage_Precent, ce.Data.mTarget);
        CheckPassiveBuff(BuffTriggerType.Trigger_Multi_Accumulative_TakeDamage_Precent, ce.Data.mTarget);
    }

    private void OnFighterAddShield(CoreEvent<Fighter> ce)
    {
        CheckPassiveBuff(BuffTriggerType.Trigger_Add_Shield, ce.Data);
    }

    private void OnFighterClearShield(CoreEvent<Fighter> ce)
    {
        CheckPassiveBuff(BuffTriggerType.Trigger_Clear_Shield, ce.Data);
    }

    private void OnFighterHeal(CoreEvent<object[]> ce)
    {
        object[] paramList = ce.Data;
        Fighter caster = (Fighter)paramList[0];
        int addHp = (int)paramList[1];
        if(addHp > 0)
        {
            CheckPassiveBuff(BuffTriggerType.Trigger_Healed, caster);
        }
    }

    private void OnFighterDoSkill(CoreEvent<Fighter> ce)
    {
        CheckPassiveBuff(BuffTriggerType.Trigger_CastingSkill, ce.Data);
    }

    private void OnFighterNegativeFun(CoreEvent<Fighter,string> ce)
    {
        CheckPassiveBuff(BuffTriggerType.Trigger_Negative_Fun, ce.Data);
    }

    private void OnFighterAttack(CoreEvent<Fighter> ce)
    {
        CheckPassiveBuff(BuffTriggerType.Trigger_Attack, ce.Data);
    }

    private void OnFighterBeHit(CoreEvent<Fighter> ce)
    {
        CheckPassiveBuff(BuffTriggerType.Trigger_Hit, ce.Data);
    }

    private void OnFighterTreatment(CoreEvent<Fighter> ce)
    {
        CheckPassiveBuff(BuffTriggerType.Trigger_Heal, ce.Data);
    }

    private void OnFighterVertigo(CoreEvent<Fighter> ce)
    {
        CheckPassiveBuff(BuffTriggerType.Trigger_Vertigo, ce.Data);
    }

    private void OnFighterDamageFromCrit(CoreEvent<Fighter> ce)
    {
        CheckPassiveBuff(BuffTriggerType.Trigger_Damage_From_Crit, ce.Data);
    }
    //被沉默
    private void OnFighterSilence(CoreEvent<Fighter> ce)
    {
        CheckPassiveBuff(BuffTriggerType.Trigger_Silence, ce.Data);
    }
    //被诅咒
    private void OnFighterCurse(CoreEvent<Fighter> ce)
    {
        CheckPassiveBuff(BuffTriggerType.Trigger_Curse, ce.Data);
    }  

    private void OnFighterDamageWithCrit(CoreEvent<Fighter, BaseSkill> ce)
    {
        CheckPassiveBuff(BuffTriggerType.Trigger_Damage_With_Crit, ce.Data);
        CheckSkillTriggerBuff(BuffTriggerType.Trigger_FixedSkill_CritDamage, ce.Data,ce.Data1);
    }

    private void OnFighterDamageAvoid(CoreEvent<Fighter,BaseSkill> ce)
    {
        CheckPassiveBuff(BuffTriggerType.Trigger_Damage_Missed, ce.Data);
        CheckSkillTriggerBuff(BuffTriggerType.Trigger_FixedSkill_Avoid, ce.Data, ce.Data1);
    }

    private void OnFighterDodge(CoreEvent<Fighter> ce)
    {
        CheckPassiveBuff(BuffTriggerType.Trigger_Miss, ce.Data);
    }

    private void OnFighterHp(CoreEvent<Fighter> ce)
    {
        CheckPassiveBuff(BuffTriggerType.Trigger_HP_Lower, ce.Data);
    }

    private void OnFighterBreakSkill(CoreEvent<Fighter,BaseSkill> ce)
    {
        if (ce.Data1 == null) return;

        //if(ce.Data1.CanBreak)//打断不需要判断 
        //{
        //    CheckPassiveBuff(BuffTriggerType.Trigger_Break_SingSkill, ce.Data);
        //}
        CheckPassiveBuff(BuffTriggerType.Trigger_Break_SingSkill, ce.Data);
        CheckSkillTriggerBuff(BuffTriggerType.Trigger_FixedSkill_Break_Skill, ce.Data,ce.Data1);
    }

    private void OnFighterSkillBroken(CoreEvent<Fighter,BaseSkill> ce)
    {
        if (ce.Data1.CanBreak) 
        { 
            CheckPassiveBuff(BuffTriggerType.Trigger_SingSkill_Broken, ce.Data);
        }
        CheckSkillTriggerBuff(BuffTriggerType.Trigger_FixedSkill_Broken, ce.Data,ce.Data1);
    }

    private void OnFighterAddSp(CoreEvent<Fighter,int> ce)
    {
        CheckPassiveBuff(BuffTriggerType.Trigger_AddSp, ce.Data);
    }

    private void OnFighterKill(CoreEvent<Fighter,BaseSkill> ce)
    {
        CheckSkillTriggerBuff(BuffTriggerType.Trigger_FixedSkill_KillTarget, ce.Data,ce.Data1);
    }

    private void OnFighterDisperseBuff(CoreEvent<Fighter,BaseSkill> ce)
    {
        CheckSkillTriggerBuff(BuffTriggerType.Trigger_FixedSkill_DisperseBuff, ce.Data,ce.Data1);
    }

    private void OnFighterPurifyDebuff(CoreEvent<Fighter, BaseSkill> ce)
    {
        CheckSkillTriggerBuff(BuffTriggerType.Trigger_FixedSkill_PurifyDeBuff, ce.Data,ce.Data1);
    }

    private void CheckPassiveBuff(BuffTriggerType type,Fighter caster)
    {
        if (CurBattleField == null) return;

        List<Fighter> fighters = CurBattleField.Fighters;
        for (int idx = 0; idx < fighters.Count; idx++)
        {
            var f = fighters[idx];
            f.ProcessTriggerBuff(caster,type);
        }
    }

    private void CheckSkillTriggerBuff(BuffTriggerType type, Fighter caster,BaseSkill skill)
    {
        if (skill == null) return;

        if (CurBattleField == null) return;

        List<Fighter> fighters = CurBattleField.Fighters;
        for (int idx = 0; idx < fighters.Count; idx++)
        {
            var f = fighters[idx];
            f.ProcessTriggerSkillBuff(caster,skill,type);
        }
    }

    #region record_methods
    public void InitStatistics()
    {
        BattleStatistics = new BattleStatistics();
        BattleOut = new BattleOutput();
    }

    public void StartStatistics()
    {
        BattleStatistics.Start();
    }

    public void EndStatistics()
    {
        BattleStatistics.End();
    }

    public void StartOutput()
    {
        BattleOut.Begin();
    }


    public void EndOutput()
    {
        BattleOut.End();
    }

    public void Output(OutputType type, Fighter caster, Fighter target = null, string skillName = null, object val = null)
    {
        if (BattleOut == null) return;

        BattleOut.Output(type, caster, target, skillName, val);
    }


    public void InitRecorder()
    {
        if (IsPlayRecord)
        {
            Recorder.ResetToPlayRecord(this);
        }
        else
        {
            Recorder = new BattleRecorder(this);
        }
    }

    public void CloseRecorder()
    {
        Recorder = null;
        IsPlayRecord = false;
    }

    public void ReplayRecords(BattleRecorder recorder)
    {
        this.Recorder = recorder;
        IsPlayRecord = true;
        SetRandSeed(Recorder.Seed);
        Factors = Recorder.Factors;
    }
    #endregion

    public bool CanPrintLog
    {
        get
        {return Constants.printBattleLog &&
         (BattleMgr.Instance.Battle.IsPlayRecord ||
         BattleMgr.Instance.Battle.IsKillingBoss ||
         BattleMgr.Instance.Battle.IsTimeBattle);
        }
    }
}
