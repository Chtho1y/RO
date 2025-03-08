using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public enum SummonPositionRule
{
    Summon_PR_NearCaster = 0,
    Summon_PR_NearTarget = 1,
    Summon_PR_SelfTeam = 2,
    Summon_PR_EnemyTeam = 3,
}

public class BaseSkill
{
    protected SkillData mSkillData;
    protected int mSkillLv = 0;
    int mTypeId = 0;
 
    List<BuffData> mBuffList = new List<BuffData>();
    public List<BuffData> BuffList { get { return mBuffList; } }
    #region Properties

    private int mId;
    public int Id { get { return mId; } }

    public int Level
    {
        get { return mSkillLv; }
    }

    public int SkillTypeID { get { return mTypeId; } set { mTypeId = value; } }

    public string SkillName { get { return mSkillData.skillName; } }

    public int SpCost { get { return mSkillData.spCost; } }

    public bool IsNormalAttack { get { return SkillTypeID == SkillType.NormalAttack; } }

    public bool IsAutoSkill { get { return SkillTypeID >= SkillType.Attack1 && SkillTypeID <= SkillType.Attack4; } }

    public bool IsEnabled { get { return IsValid && Level > 0; } }

    public bool IsValid { get { return mSkillData != null && mSkillData.valid; } }

    //是否为被动技能
    public bool IsPassiveSkill { get { return mSkillData.skillTriggerType == SkillTriggerType.Passive_Trigger; } }

    public bool CanBreak { get { return mSkillData.skillTriggerType == SkillTriggerType.Casting_Sing || mSkillData.skillTriggerType == SkillTriggerType.Continuous_Casting_NoSing || mSkillData.skillTriggerType == SkillTriggerType.Continuous_Casting_Sing; } }

    public SkillData SkillDataInfo { get { return mSkillData; } }

    //是否为多段技能
    public bool IsMultiSkill { get { /*return mSkillData.attackNum > 1;*/  return false; } }

    public string SkillAnimName { get; private set; }

    public string SkillSingAnimName { get; private set; }

    public float SingTotalTime
    {
        get;set;
    }

    public bool IsSingSkill { get; private set; }

    public float Duration { get { return SingTotalTime + mSkillData.preCastingTime + mSkillData.castingTime + mSkillData.postCastingTime; } }

    private List<ValType> mSummonNpcs = null;
    public List<ValType> SummonActors {
        get
        {
            return mSummonNpcs;
        }
    }

    private List<ValType> mSummonBosses = null;
    public List<ValType> SummonBosses
    {
        get { return mSummonBosses; }
    }
    
    private List<Fighter> mSummonActorInsts = null;

    public List<Fighter> SummonActorInsts
    {
        get { return mSummonActorInsts; }
    }

    private bool mbDisposed = false;

    private string mEventFileName;


    private bool mIsEnhance = false;
    public bool IsEnhance
    {
        get { return mIsEnhance; }
        set { mIsEnhance = value; }
    }

    private int mTriggerRate = 100;
    public int TriggerRate
    {
        get { return mTriggerRate; }
        set { mTriggerRate = value; }
    }
    #endregion


    private ProfessionType mJobType;
    private int mJobStage;
    private int mJobBranch;
    public BaseSkill(int id,int level, int skillTypeId,int gender, ProfessionType jobType,int jobStage,int jobBranch)
    {
        mTypeId = skillTypeId;
        mId = id;
        mSkillData = new SkillData(id,level);
        mSkillLv = level;
        mIsEnhance = false;
        mJobType = jobType;
        mJobStage = jobStage;
        mJobBranch = jobBranch;
        LoadBuffData(gender,jobType,jobStage,jobBranch);
    }

    public void SetLevel(int level)
    {
        if (mSkillLv == level) return;

        mSkillLv = level;
        mSkillData = new SkillData(mId, level);
    }

    void LoadBuffData(int gender, ProfessionType jobType, int jobStage, int jobBranch)
    {
        mBuffList.Clear();
        if (mSkillData.buffIds!=null)
        {
            for(int idx =0; idx < mSkillData.buffIds.Length;idx++)
            {
                BuffData buffData = new BuffData(mSkillData.buffIds[idx], gender,jobType,jobStage,jobBranch);
                mBuffList.Add(buffData);
            }
        }  
    }

    void ParseExtendBuff()
    {
        for (int idx = 0; idx < mBuffList.Count; idx++)
        {
            BuffData buffData = mBuffList[idx];
            if (buffData.extendBuffs != null)
            {
                for (int jdx = 0; jdx < buffData.extendBuffs.Count; jdx++)
                {
                    BattlePrepareManager.Instance.PrecacheBuff(buffData.extendBuffs[jdx].id, (int)(Role_Gender.Male), mJobType, mJobStage, mJobBranch);
                }
            }

            if(buffData.markExtendList != null)
            {
                for(int jdx = 0; jdx < buffData.markExtendList.Count;jdx++)
                {
                    BattlePrepareManager.Instance.PrecacheBuff(buffData.markExtendList[jdx].val, (int)(Role_Gender.Male), mJobType, mJobStage, mJobBranch);
                }
            }
        }

        if (mSkillData.triggerBuffs != null && mSkillData.triggerBuffs.Count > 0)
        {
            for (int idx = 0; idx < mSkillData.triggerBuffs.Count; idx++)
            {
                SkillTriggerBuffInfo triggerBuffInfo = mSkillData.triggerBuffs[idx];
                if (triggerBuffInfo.buffId > 0)
                {
                    BattlePrepareManager.Instance.PrecacheBuff(triggerBuffInfo.buffId, (int)(Role_Gender.Male), mJobType, mJobStage, mJobBranch);
                }
            }
        }

        if(mSkillData.extendBuffIds != null && mSkillData.extendBuffIds.Count > 0)
        {
            for(int idx =0; idx < mSkillData.extendBuffIds.Count;idx++)
            {
                if(mSkillData.extendBuffIds[idx] > 0)
                {
                    BattlePrepareManager.Instance.PrecacheBuff(mSkillData.extendBuffIds[idx], (int)(Role_Gender.Male), mJobType, mJobStage, mJobBranch);
                }
            }
        }
    }


    List<int> effects = new List<int>();
    List<int> bulletActors = new List<int>();
    List<int> buffs = new List<int>();
    List<string> sounds = new List<string>();
    List<string> prefabs = new List<string>();

    void ParseSkillData(Fighter owner)
    {
        for (int i = 0; i < mBuffList.Count; i++)
        {
            BuffData buffData = mBuffList[i];
            if (buffData.ActionFrameEvents == null || buffData.ActionFrameEvents.Length == 0) continue;

            for (int idx = 0; idx < buffData.ActionFrameEvents.Length; idx++)
            {
                SkillActionFrameEvent ev = buffData.ActionFrameEvents[idx];
                switch (ev.eventType)
                {
                    case SkillActionFrameEventType.FE_PlaySound:
                        {
                            string sound = ev.GetStr(Constants.s_skillaction_frame_key_sound);
                            if (!string.IsNullOrEmpty(sound) && !sounds.Contains(sound))
                            {
                                sounds.Add(sound);
                            }
                            break;
                        }
                    case SkillActionFrameEventType.FE_PlayEffect:
                    case SkillActionFrameEventType.FE_PlayUnscaleTimeEffect:
                        {
                            int v = ev.GetN(Constants.s_skillaction_frame_key_effect);
                            if (v > 0 && !effects.Contains(v))
                                effects.Add(v);
                            break;
                        }
                    case SkillActionFrameEventType.FE_PlayEffectEx:
                        {
                            int v = (int)ev.GetN(Constants.s_skillaction_frame_key_effect);
                            if (v > 0 && !effects.Contains(v))
                                effects.Add(v);
                            break;
                        }
                    case SkillActionFrameEventType.FE_Hit:
                    case SkillActionFrameEventType.FE_Skill_Sing:
                    case SkillActionFrameEventType.FE_Repeat_Caster:
                    case SkillActionFrameEventType.FE_Delay_Hurt:
                    case SkillActionFrameEventType.FE_Bullet:
                        {
                            SkillActionAttackInfo attackInfo = ev.CreateAttackInfo();
                            if (attackInfo != null)
                            {
                                if (attackInfo.bulletID > 0 && !bulletActors.Contains(attackInfo.bulletID))
                                {
                                    bulletActors.Add(attackInfo.bulletID);
                                }
                                if (attackInfo.hitEffect > 0 && !effects.Contains(attackInfo.hitEffect))
                                {
                                    effects.Add(attackInfo.hitEffect);
                                }
                                if (attackInfo.effect > 0 && !effects.Contains(attackInfo.effect))
                                {
                                    effects.Add(attackInfo.effect);
                                }
                                if (!string.IsNullOrEmpty(attackInfo.sound) && !sounds.Contains(attackInfo.sound))
                                {
                                    sounds.Add(attackInfo.sound);
                                }
                                if (attackInfo.buffID > 0 && !buffs.Contains(attackInfo.buffID))
                                {
                                    buffs.Add(attackInfo.buffID);
                                }
                            }
                            break;
                        }
                    case SkillActionFrameEventType.FE_Buff:
                        {
                            int buffId = ev.GetN(Constants.s_skillaction_frame_key_buffid);
                            if (buffId > 0 && !buffs.Contains(buffId))
                                buffs.Add(buffId);
                            break;
                        }
                    case SkillActionFrameEventType.FE_Summon:
                        {
                            int npcPos = ev.GetN(Constants.s_skillaction_frame_key_npcPos);
                            int npcId = ev.GetN(Constants.s_skillaction_frame_key_npcId);
                            if (mSummonNpcs == null)
                                mSummonNpcs = new List<ValType>();
  
                            if (npcId > 0)
                            {
                                ValType val = new ValType(npcId, npcPos);
                                mSummonNpcs.Add(val);
                            }
                            break;
                        }
                    case SkillActionFrameEventType.FE_Clone:
                        {
                            int npcPos = ev.GetN(Constants.s_skillaction_frame_key_npcPos);
                            int npcId = ev.GetN(Constants.s_skillaction_frame_key_npcId);
                            int bornEffectId = ev.GetN(Constants.s_skillaction_frame_key_effect);
                            if (bornEffectId > 0 && !effects.Contains(bornEffectId))
                            {
                                effects.Add(bornEffectId);
                            }

                            if (owner.IsBoss)
                            {
                                if (mSummonBosses == null)
                                    mSummonBosses = new List<ValType>();
                                if (npcId > 0)
                                {
                                    ValType val = new ValType(npcId, npcPos);
                                    mSummonBosses.Add(val);
                                }
                            }
                            else
                            {
                                if (mSummonNpcs == null)
                                    mSummonNpcs = new List<ValType>();

                                if (npcId > 0)
                                {
                                    ValType val = new ValType(npcId, owner.PositionValue);
                                    mSummonNpcs.Add(val);
                                }
                            }
                        }
                        break;
                    case SkillActionFrameEventType.FE_PlayPrefab:
                        {
                            string prefabName = ev.GetStr(Constants.s_skillaction_frame_key_prefabname);
                            if (!string.IsNullOrEmpty(prefabName) && !prefabs.Contains(prefabName))
                                prefabs.Add(prefabName);

                            string sound = ev.GetStr(Constants.s_skillaction_frame_key_sound);
                            if (!string.IsNullOrEmpty(sound) && !sounds.Contains(sound))
                            {
                                sounds.Add(sound);
                            }
                        }
                        break;
                    default:
                        break;
                }
            }

            for (int idx = 0; idx < buffData.BuffFunList.Count; idx++)
            {
                var data = buffData.BuffFunList[idx];
                if (data.effectId > 0 && !effects.Contains(data.effectId))
                {
                    effects.Add(data.effectId);
                }
                if (data.endeffectId > 0 && !effects.Contains(data.endeffectId))
                {
                    effects.Add(data.endeffectId);
                }
            }
        }
    }


    public void Prepare(Fighter owner)
    {
        effects.Clear();
        bulletActors.Clear();
        buffs.Clear();
        sounds.Clear();
        prefabs.Clear();
        ParseExtendBuff();
        ParseSkillData(owner);

        BattlePrepareManager.Instance.PrecacheEffects(effects.ToArray());
        BattlePrepareManager.Instance.PrecacheBullets(bulletActors.ToArray());
        BattlePrepareManager.Instance.PrecacheBuffs(buffs.ToArray(),owner.Gender,owner.ProfType,owner.JobStage,owner.JobBranch);
        BattlePrepareManager.Instance.PrecacheUIPrefabs(prefabs.ToArray());
        MusicMgr.Instance.PreloadFightSound(sounds.ToArray());
    }

    public void Load(int gender, ProfessionType jobType, int jobStage, int jobBranch)
    {
        effects.Clear();
        bulletActors.Clear();
        buffs.Clear();
        sounds.Clear();
        prefabs.Clear();
        ParseExtendBuff();
        ParseSkillData(null);

        BattlePrepareManager.Instance.PrecacheEffects(effects.ToArray());
        BattlePrepareManager.Instance.PrecacheBullets(bulletActors.ToArray());
        BattlePrepareManager.Instance.PrecacheBuffs(buffs.ToArray(), gender,jobType,jobStage,jobBranch);
        BattlePrepareManager.Instance.PrecacheUIPrefabs(prefabs.ToArray());
        MusicMgr.Instance.PreloadFightSound(sounds.ToArray());
    }

    public float GetBuffRate(BuffData buffData)
    {
        if (buffData.rate == 0)
            return 1;
        return buffData.rate;
    }

    public void AddSummonActor (Fighter summon)
    {
        if (mSummonActorInsts == null)
            mSummonActorInsts = new List<Fighter>();

        mSummonActorInsts.Add(summon);
    }

    public void Dispose()
    {
        if (mbDisposed)
            return;

        if (mSkillData != null)
        {
            mSkillData.Dispose();
            mSkillData = null;
        }

        for(int idx =0; idx < mBuffList.Count;idx++)
        {
            mBuffList[idx].Dispose();
        }
        mBuffList.Clear();

        if (mSummonActorInsts != null)
            mSummonActorInsts.Clear();

        mSummonActorInsts = null;

        mbDisposed = true;
    }

    public float GetSkillDist(int professionType)
    {
        if (SkillDataInfo == null) return 0;

        float dist;
        SkillDataInfo.skillDistDic.TryGetValue(professionType, out dist);
        return dist;
    }

    public SkillTriggerBuffInfo GetTriggerBuffByType(BuffTriggerType type)
    {
        if (mSkillData == null) return default(SkillTriggerBuffInfo);

        if (mSkillData.triggerBuffs == null || mSkillData.triggerBuffs.Count == 0) return default(SkillTriggerBuffInfo);

        for(int idx =0; idx < mSkillData.triggerBuffs.Count;idx++)
        {
            if (mSkillData.triggerBuffs[idx].type == type) return mSkillData.triggerBuffs[idx];
        }

        return default(SkillTriggerBuffInfo);
    }

    public bool HasBuff(int buffId)
    {
        if (mSkillData == null) return false;

        if (mSkillData.buffIds == null || mSkillData.buffIds.Length == 0) return false;

        for(int idx =0; idx < mSkillData.buffIds.Length;idx++)
        {
            if (mSkillData.buffIds[idx] == buffId) return true;
        }

        return false;
    }

    public Fighter PopSummonActor(int npcId,int npcPos)
    {
        if (mSummonActorInsts == null)
            return null;

        for(int idx =0; idx < mSummonActorInsts.Count;idx++)
        {
            Fighter f = mSummonActorInsts[idx];
            if(f.Actor.BaseId == npcId && f.PositionValue == npcPos)
            {
                return f;
            }
        }
        return null;
    }

    public JSONObject ToJson()
    {
        JSONObject json = new JSONObject();
        json.Add(mId);
        json.Add(mSkillLv);
        json.Add(mTriggerRate);
        return json;
    }
}
