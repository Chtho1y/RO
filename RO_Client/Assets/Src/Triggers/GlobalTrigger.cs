using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Security;

public interface ITrigger
{
    GameObject GetTriggerObj();
};

/// <summary>
/// 新增枚举只能从后面加，因为已有配置被序列化到文件
/// </summary>
public enum EGlobalTriggerAct
{
    TriggerDialogue,
    TriggerSpawn,
    TriggerPauseGame,
    TriggerSetGlobalVariable, 
    TriggerMove,
    TriggerComingAnim,  
    TriggerPlayEffect,
    TriggerExitBattle,
    TriggerCalcNextPoint,
    TriggerDisactive,
    TriggerCameraMove,
    TriggerRunGame,
    TriggerShowSkip,
    TriggerEnableSkill,
    TriggerDisableSkill,
    TriggerSetUINodeVis,
    TriggerPlayBGM,
}

/// <summary>
/// 新增枚举只能从后面加，因为已有配置被序列化到文件
/// </summary>
public enum EGlobalGameEvent
{
    SpawnGroupDead,
    ActorDead,
    FightPrepare,
    ActorDamage,
    FightStart,
    UseSkill,
    ActorInit,
    EnterCombat,
    DialogueFinished,
    MoveEnd,
}

public enum ECondtionType
{
    None = 0,
    HP = 1,
    SP = 2,
    SkillId = 3,
    DialogueId = 4,
    FighterId = 5,
}

[Serializable]
public struct STriggerCondition
{
    public Int32 ActorId;

    public ECondtionType ConType;

    [FriendlyName("百分比数")]
    public int Percent;

    public bool FilterMatch(EGlobalGameEvent inEventType
        , int baseId
        , eTeamType teamId
        , int param)
    {
        if (ActorId != baseId)
        {
            return false;
        }
        switch (inEventType)
        {
            case EGlobalGameEvent.ActorDamage:
                Fighter fighter = BattleMgr.Instance.Battle.FighterMgr.GetFighterByBaseId(baseId, teamId);
                if (fighter == null)
                {
                    return false;
                }

                if (!FilterMatchDamage(fighter.Life,fighter.MaxLife))
                {
                    return false;
                }
                break;
            case EGlobalGameEvent.UseSkill:
                if (!FilterMatchSkill(param))
                {
                    return false;
                }
                break;
            case EGlobalGameEvent.DialogueFinished:
                return Percent == param;
            case EGlobalGameEvent.MoveEnd:
                return Percent == param;
            default:
                break;
        }

        return true;
    }

    private bool FilterMatchDamage(int curHp,int maxLife)
    {
        int percentRevised = Percent;
        if (percentRevised < 0)
        {
            percentRevised = 0;
        }
        else if (percentRevised > 100)
        {
            percentRevised = 100;
        }
        int hpThreshold = maxLife * percentRevised / 100;

        if (curHp <= hpThreshold)
        {
            return true;
        }

        return false;
    }

    private bool FilterMatchSkill(int skillId)
    {
        return Percent == skillId;
    }
}

[Serializable]
public class CTriggerMatch
{
    public const int TriggerCountMax = 1;

    [FriendlyName("角色ID")]
    public int ActorId = 0;
    public eTeamType TeamType = eTeamType.Friend;
    public EGlobalGameEvent EventType = EGlobalGameEvent.SpawnGroupDead;
    public STriggerCondition[] Conditions = new STriggerCondition[0];
    [SerializeField]
    public TriggerActionWrapper[] ActionList = new TriggerActionWrapper[0];

    [FriendlyName("延迟触发时间（0表示无延迟,单位ms）")]
    public int DelayTime = 0;

    [HideInInspector, NonSerialized]
    public int m_triggeredCounter;
}

[AddComponentMenu("Trigger/Global Trigger")]
public class GlobalTrigger : MonoBehaviour, ITrigger{

    public CTriggerMatch[] TriggerMatches = new CTriggerMatch[0];

    private class CDelayMatch
    {
        public CTriggerMatch TriggerMatch;
    }

    private Dictionary<int, CDelayMatch> DelayTimeSeqMap = new Dictionary<int, CDelayMatch>();

    public GameObject GetTriggerObj()
    {
        return gameObject;
    }

    private void Awake()
    {
        RegisterEvents();
    }

    private void OnDestroy()
    {
        UnregisterEvents();
        ClearDelayTimers();

        foreach (CTriggerMatch match in TriggerMatches)
        {
            if (match == null)
            {
                continue;
            }

            foreach (TriggerActionWrapper taw in match.ActionList)
            {
                if (taw != null)
                {
                    taw.Destroy();
                }
            }
        }

    }

    private void RegisterEvents()
    {
        EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_FIGHTER_DIE, onActorDead);
        EventMgr.AddEventListener<UIEventParamFighterHurt>(ECoreEventType.EID_FIGHTER_HURT, onActorDamage);
        EventMgr.AddEventListener<bool>(ECoreEventType.EID_BATTLE_NEW_FIGHTING_START, onFightStart);
        EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_FIGHTER_SPAWN, onActorInit);
        EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_FIGHTER_ENTERCOMBAT, onEnterCombat);
        EventMgr.AddEventListener<CastSkillData>(ECoreEventType.EID_Refresh_Skill, onFighterCastSkill);
        EventMgr.AddEventListener<int>(ECoreEventType.EID_Dialogue_Finished,onDialogueFinished);
        EventMgr.AddEventListener<int>(ECoreEventType.EID_Fighter_Move_End, onFighterMoveEnd);
    }

    private void UnregisterEvents()
    {
        EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_FIGHTER_DIE, onActorDead);
        EventMgr.RemoveEventListener<UIEventParamFighterHurt>(ECoreEventType.EID_FIGHTER_HURT, onActorDamage);
        EventMgr.RemoveEventListener<bool>(ECoreEventType.EID_BATTLE_NEW_FIGHTING_START, onFightStart);
        EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_FIGHTER_SPAWN, onActorInit);
        EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_FIGHTER_ENTERCOMBAT, onEnterCombat);
        EventMgr.RemoveEventListener<CastSkillData>(ECoreEventType.EID_Refresh_Skill, onFighterCastSkill);
        EventMgr.RemoveEventListener<int>(ECoreEventType.EID_Dialogue_Finished, onDialogueFinished);
        EventMgr.RemoveEventListener<int>(ECoreEventType.EID_Fighter_Move_End, onFighterMoveEnd);
    }

    public void UpdateLogic(float delta)
    {
    }

    /// <summary>
    /// 全局Trigger在备战阶段即生效
    /// </summary>
    public void PrepareFight()
    {
        int count = TriggerMatches.Length;
        for (int i = 0; i < count; ++i)
        {
            CTriggerMatch match = TriggerMatches[i];
            if (match == null)
            {
                continue;
            }

            if (FilterMatch(EGlobalGameEvent.FightPrepare, match, 0, 0,i))
            {
                DoTriggering(match);
            }
        }
    }

    public void Dispose()
    {
        ClearDelayTimers();

        foreach (CTriggerMatch match in TriggerMatches)
        {
            if (match == null)
            {
                continue;
            }

            foreach (TriggerActionWrapper taw in match.ActionList)
            {
                if (taw != null)
                {
                    taw.Destroy();
                }
            }
        }
    }

    private void DoTriggeringImpl(CTriggerMatch match, int baseId,eTeamType teamSide)
    {
        if (match.ActionList != null && match.ActionList.Length > 0)
        {
            int count = match.ActionList.Length;
            for (int i = 0; i < count; ++i)
            {
                TriggerActionWrapper taw = match.ActionList[i];
                if (taw == null)
                {
                    continue;
                }

                TriggerActionBase tab = taw.GetActionInternal();
                if (tab == null)
                {
                    taw.Init(0);
                    tab = taw.GetActionInternal();
                    DebugHelper.Assert(tab != null);
                }

                Fighter src = BattleMgr.Instance.Battle.FighterMgr.GetFighterByBaseId(baseId, teamSide);
                tab.TriggerEnter(src, this);
            }
        }
    }

    public void ClearDelayTimers()
    {
        var iter = DelayTimeSeqMap.GetEnumerator();
        while (iter.MoveNext())
        {
            int timeSeq = iter.Current.Key;
            TimerManager.Instance.RemoveTimer(timeSeq);
        }
        DelayTimeSeqMap.Clear();
    }

    private void OnDelayTriggerTimer(int inTimeSeq)
    {
        if (DelayTimeSeqMap.ContainsKey(inTimeSeq))
        {
            CDelayMatch delay = DelayTimeSeqMap[inTimeSeq];
            if (delay != null)
            {
                DoTriggeringImpl(delay.TriggerMatch, delay.TriggerMatch.ActorId,delay.TriggerMatch.TeamType);
            }

            DelayTimeSeqMap.Remove(inTimeSeq);
        }

        TimerManager.Instance.RemoveTimer(inTimeSeq);
    }

    private void DoTriggering(CTriggerMatch match)
    {
        if (CTriggerMatch.TriggerCountMax > 0)
        {
            if (++match.m_triggeredCounter > CTriggerMatch.TriggerCountMax)
            {
                return;
            }
        }

        Fighter src = BattleMgr.Instance.Battle.FighterMgr.GetFighterByBaseId(match.ActorId, match.TeamType);
        if (match.DelayTime > 0)
        {
            int timeSeq = TimerManager.Instance.AddTimer(match.DelayTime, 1, OnDelayTriggerTimer);
            if (timeSeq >= 0)
            {
                DebugHelper.Assert(!DelayTimeSeqMap.ContainsKey(timeSeq));

                CDelayMatch delay = new CDelayMatch();
                delay.TriggerMatch = match;
                DelayTimeSeqMap.Add(timeSeq, delay);
            }
        }
        else
        {
            DoTriggeringImpl(match, match.ActorId,match.TeamType);
        }
    }

    private bool FilterMatch(EGlobalGameEvent inEventType, CTriggerMatch match,int baseId,eTeamType teamId,int param)
    {
        if (match.EventType != inEventType)
        {
            return false;
        }

        if(match.Conditions == null || match.Conditions.Length == 0)
        {
            return true;
        }

        for(int idx =0; idx < match.Conditions.Length;idx++)
        {
            if (!match.Conditions[idx].FilterMatch(inEventType, baseId, teamId, param))
            {
                return false;
            }

        }

        return true;
    }

    private void onActorDead(CoreEvent<Fighter> ce)
    {
        Fighter src = ce.Data;
        int count = TriggerMatches.Length;
        for (int i = 0; i < count; ++i)
        {
            CTriggerMatch match = TriggerMatches[i];
            if (match == null)
            {
                continue;
            }

            if (FilterMatch(EGlobalGameEvent.ActorDead, match, src.Actor.BaseId, src.TeamSide, i))
            {
                DoTriggering(match);
            }
        }
    }

    private void onActorDamage(CoreEvent<UIEventParamFighterHurt> ce)
    {
        UIEventParamFighterHurt hurtParam = ce.Data;
        int count = TriggerMatches.Length;
        for (int i = 0; i < count; ++i)
        {
            CTriggerMatch match = TriggerMatches[i];
            if (match == null)
            {
                continue;
            }

            if (FilterMatch(EGlobalGameEvent.ActorDamage, match, hurtParam.mTarget.Actor.BaseId,hurtParam.mTarget.TeamSide,i))
            {
                DoTriggering(match);
            }
        }
    }

    private void onFighterCastSkill(CoreEvent<CastSkillData> ce)
    {
        CastSkillData skillData = ce.Data;
        if(skillData.IsCasting)
        {
            int count = TriggerMatches.Length;
            for (int i = 0; i < count; ++i)
            {
                CTriggerMatch match = TriggerMatches[i];
                if (match == null)
                {
                    continue;
                }

                Fighter f = BattleMgr.Instance.Battle.FighterMgr.GetFighterByID(skillData.actorId,(eTeamType)skillData.teamSide);

                if (f!=null && FilterMatch(EGlobalGameEvent.UseSkill, match, f.Actor.BaseId, f.TeamSide, skillData.skillId))
                {
                    DoTriggering(match);
                }
            }
        }
    }

    private void onFightStart(CoreEvent<bool> ce)
    {
        bool f = ce.Data;
        int count = TriggerMatches.Length;
        for (int i = 0; i < count; ++i)
        {
            CTriggerMatch match = TriggerMatches[i];
            if (match == null)
            {
                continue;
            }

            if (FilterMatch(EGlobalGameEvent.FightStart, match, 0, 0,i))
            {
                DoTriggering(match);
            }
        }
    }

    private void onDialogueFinished(CoreEvent<int> ce)
    {
        int dialogueId = ce.Data;
        //DebugHelper.LogError("onDialogueFinished:" + dialogueId);
        int count = TriggerMatches.Length;
        for (int i = 0; i < count; ++i)
        {
            CTriggerMatch match = TriggerMatches[i];
            if (match == null)
            {
                continue;
            }

            if (FilterMatch(EGlobalGameEvent.DialogueFinished, match,0,0, dialogueId))
            {
                DoTriggering(match);
            }
        }
    }

    private void onFighterMoveEnd(CoreEvent<int> ce)
    {
        int fighterCfgId = ce.Data;
        int count = TriggerMatches.Length;
        for (int i = 0; i < count; ++i)
        {
            CTriggerMatch match = TriggerMatches[i];
            if (match == null)
            {
                continue;
            }

            if (FilterMatch(EGlobalGameEvent.MoveEnd, match, 0, 0, fighterCfgId))
            {
                DoTriggering(match);
            }
        }
    }

    private void onActorInit(CoreEvent<Fighter> ce)
    {
        Fighter f = ce.Data;
        int count = TriggerMatches.Length;
        for (int i = 0; i < count; ++i)
        {
            CTriggerMatch match = TriggerMatches[i];
            if (match == null)
            {
                continue;
            }

            if (FilterMatch(EGlobalGameEvent.ActorInit, match, f.Actor.BaseId, f.TeamSide, i))
            {
                DoTriggering(match);
            }
        }
    }

    private void onEnterCombat(CoreEvent<Fighter> ce)
    {
        Fighter f = ce.Data;
        int count = TriggerMatches.Length;
        
        for (int i = 0; i < count; ++i)
        {
            CTriggerMatch match = TriggerMatches[i];
            if (match == null)
            {
                continue;
            }

            if (FilterMatch(EGlobalGameEvent.EnterCombat, match, f.Actor.BaseId, f.TeamSide, i))
            {
                DoTriggering(match);
            }
        }
    }

    public void SaveCfgToXml(SecurityElement parent)
    {
        AreaEventTriggerSpawn[] spawnTriggers = GetComponentsInChildren<AreaEventTriggerSpawn>(true);
        for(int idx =0; idx < spawnTriggers.Length;idx++)
        {
            AreaEventTriggerSpawn triggerSpawn = spawnTriggers[idx];
            SecurityElement childNode = triggerSpawn.SaveToXml();
            parent.AddChild(childNode);
        }

        if(TriggerMatches != null)
        {
            List<int> effectIds = new List<int>();
            SecurityElement effectGroupNode = new SecurityElement("EffectGroup");
            for (int idx =0; idx < TriggerMatches.Length;idx++)
            {
                CTriggerMatch tm = TriggerMatches[idx];
                if(tm!=null && tm.ActionList.Length > 0)
                {
                    for(int jdx =0; jdx < tm.ActionList.Length;jdx++)
                    {
                        TriggerActionWrapper act = tm.ActionList[jdx];
                        if(act!=null && act.TriggerType == EGlobalTriggerAct.TriggerPlayEffect && act.EnterUniqueId > 0)
                        {
                            if (effectIds.Contains(act.EnterUniqueId)) continue;

                            SecurityElement effectNode = new SecurityElement("Effect");
                            effectNode.AddAttribute("id", act.EnterUniqueId.ToString());
                            effectGroupNode.AddChild(effectNode);
                            effectIds.Add(act.EnterUniqueId);
                        }
                    }
                }
            }
            parent.AddChild(effectGroupNode);
        }
    }
}
