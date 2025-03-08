using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// No inheritation. Like CTriggerMatch
/// </summary>
[Serializable]
public class TriggerActionWrapper
{
    //[FriendlyName("触发器类型")]
    public EGlobalTriggerAct TriggerType;

    [HideInInspector]
    public GameObject[] RefObjList = new GameObject[0];

    [FriendlyName("配置ID")]
    public int EnterUniqueId;

    [FriendlyName("参数[类型]")]
    public string ParamStr;

    [FriendlyName("持续时间")]
    public int TotalTime;

    [FriendlyName("是否立马设置位置")]
    public bool bSetPos;

    [HideInInspector]
    public bool bEnable = true;

    [HideInInspector]
    public bool bStopWhenLeaving = true;

    [HideInInspector]
    public bool bSrc;

    [HideInInspector]
    public bool bAtker;

    private TriggerActionBase m_internalAct;
    private int m_triggerId;

    /// <summary>
    /// Dummy. For GameSerializer.CreateInstance
    /// </summary>
    public TriggerActionWrapper()
    {
        bEnable = true;
    }

    public TriggerActionWrapper(EGlobalTriggerAct inTriggerType)
    {
        TriggerType = inTriggerType;
        bEnable = true;
    }

    public void Init(int inTriggerId)
    {
        m_triggerId = inTriggerId;

        if (m_internalAct != null)
        {
            return;
        }

        switch (TriggerType)
        {
            case EGlobalTriggerAct.TriggerSpawn:
                m_internalAct = new TriggerActionSpawn(this, m_triggerId);
                break;
            case EGlobalTriggerAct.TriggerDialogue:
                m_internalAct = new TriggerActionDialogue(this, m_triggerId);
                break;
            case EGlobalTriggerAct.TriggerPauseGame:
                m_internalAct = new TriggerActionPauseGame(this, m_triggerId);
                break;
            case EGlobalTriggerAct.TriggerSetGlobalVariable:
                m_internalAct = new TriggerActionSetGlobalVariable(this, m_triggerId);

                break;
            case EGlobalTriggerAct.TriggerMove:
                m_internalAct = new TriggerMove(this, m_triggerId);
                break;
            case EGlobalTriggerAct.TriggerComingAnim:
                m_internalAct = new TriggerComingAnim(this, m_triggerId);
                break;
            case EGlobalTriggerAct.TriggerPlayEffect:
                m_internalAct = new TriggerPlayEffect(this,m_triggerId);
                break;
            case EGlobalTriggerAct.TriggerSetUINodeVis:
                m_internalAct = new TriggerSetUINodeVis(this, m_triggerId);
                break;
            case EGlobalTriggerAct.TriggerPlayBGM:
                m_internalAct = new TriggerPlayBGM(this, m_triggerId);
                break;
            case EGlobalTriggerAct.TriggerExitBattle:
                m_internalAct = new TriggerExitBattle(this, m_triggerId);
                break;
            case EGlobalTriggerAct.TriggerCalcNextPoint:
                m_internalAct = new TriggerCalcNextPoint(this, m_triggerId);
                break;
            case EGlobalTriggerAct.TriggerDisactive:
                m_internalAct = new TriggerDisactive(this, m_triggerId);
                break;
            case EGlobalTriggerAct.TriggerCameraMove:
                m_internalAct = new TriggerCameraMove(this, m_triggerId);
                break;
            case EGlobalTriggerAct.TriggerRunGame:
                m_internalAct = new TriggerRunGame(this, m_triggerId);
                break;
            case EGlobalTriggerAct.TriggerShowSkip:
                m_internalAct = new TriggerShowSkip(this, m_triggerId);
                break;
            case EGlobalTriggerAct.TriggerEnableSkill:
                m_internalAct = new TriggerEnableSkill(this, m_triggerId);
                break;
            case EGlobalTriggerAct.TriggerDisableSkill:
                m_internalAct = new TriggerDisableSkill(this, m_triggerId);
                break;
            default:
                DebugHelper.Assert(false);
                break;
        }
    }

    public void Destroy()
    {
        if (m_internalAct != null)
        {
            m_internalAct.Destroy();
            m_internalAct = null;
        }
    }

    public void Stop()
    {
        if (m_internalAct != null)
        {
            m_internalAct.Stop();
        }
    }

    public TriggerActionBase GetActionInternal()
    {
        return m_internalAct;
    }

    public void TriggerEnter(Fighter src, ITrigger inTrigger)
    {
        if (m_internalAct == null)
        {
            return;
        }

        m_internalAct.TriggerEnter(src, inTrigger);
    }

    public void TriggerLeave(Fighter src, ITrigger inTrigger)
    {
        if (m_internalAct == null)
        {
            return;
        }

        m_internalAct.TriggerLeave(src, inTrigger);
    }

    public void TriggerUpdate(Fighter src, ITrigger inTrigger)
    {
        if (m_internalAct == null)
        {
            return;
        }

        try
        {
            m_internalAct.TriggerUpdate(src, inTrigger);
        }
        catch (Exception e)
        {
            DebugHelper.LogError("TriggerUpdate Err:" + e + "," + e.StackTrace);
        }
    }

    public virtual void OnCoolDown(ITrigger inTrigger)
    {
        if (m_internalAct == null)
        {
            return;
        }

        m_internalAct.OnCoolDown(inTrigger);
    }

    public virtual void OnTriggerStart(ITrigger inTrigger)
    {
        if (m_internalAct == null)
        {
            return;
        }

        m_internalAct.OnTriggerStart(inTrigger);
    }
}

public abstract class TriggerActionBase
{
    public int EnterUniqueId;

    public bool bEnable;
    public bool bStopWhenLeaving;

    public bool bSrc;
    public bool bAtker;

    public bool bSetPos;

    public int TotalTime;

    public string Param;

    public int TriggerId
    {
        get;
        private set;
    }


    public TriggerActionBase(TriggerActionWrapper inWrapper, int inTriggerId)
    {
        EnterUniqueId = inWrapper.EnterUniqueId;
        bEnable = inWrapper.bEnable;
        bStopWhenLeaving = inWrapper.bStopWhenLeaving;
        bSrc = inWrapper.bSrc;
        bAtker = inWrapper.bAtker;
        TotalTime = inWrapper.TotalTime;
 
        TriggerId = inTriggerId;
        bSetPos = inWrapper.bSetPos;
        Param = inWrapper.ParamStr;
    }

    public virtual void Destroy()
    {
        Stop();
    }

    public virtual void Stop() { }

    public abstract void TriggerEnter(Fighter src, ITrigger inTrigger);

    public virtual void TriggerLeave(Fighter src, ITrigger inTrigger) { }
    
    public virtual void TriggerUpdate(Fighter src, ITrigger inTrigger) { }

    public virtual void OnCoolDown(ITrigger inTrigger) { }

    public virtual void OnTriggerStart(ITrigger inTrigger) { }
}

public class TriggerActionSpawn : TriggerActionBase
{
    public TriggerActionSpawn(TriggerActionWrapper inWrapper, int inTriggerId)
        : base(inWrapper, inTriggerId)
    {

    }

    public override void TriggerEnter(Fighter src, ITrigger inTrigger)
    {
        if (src!=null && BattleMgr.Instance.Battle!=null && BattleMgr.Instance.Battle.CurBattleField!=null)
        {
            BattleMgr.Instance.Battle.CurBattleField.AddFighter(src);
            src.Ctrl.SetLayer(LayerMask.NameToLayer(BattleCamera.FighterLayerName));
            if(bSetPos)
            {
                BattleMgr.Instance.Battle.SyncFighterPos(src);
            }
            bool aiEnabeld = true;
            bool.TryParse(Param,out aiEnabeld);
            src.IsAiEnabled = aiEnabeld;
        }
    }
}

public class TriggerActionDialogue : TriggerActionBase
{
    public TriggerActionDialogue(TriggerActionWrapper inWrapper, int inTriggerId)
        : base(inWrapper, inTriggerId)
    {

    }

    public override void TriggerEnter(Fighter src, ITrigger inTrigger)
    {
        if (EnterUniqueId > 0)
        {
            int DialogueGroupId = EnterUniqueId;
            GameMgr.Instance.PlayDialog(1, DialogueGroupId);
        }

        return;
    }

    public override void TriggerLeave(Fighter src, ITrigger inTrigger)
    {
    }
}

public class TriggerRunGame:TriggerActionBase
{
    public TriggerRunGame(TriggerActionWrapper inWrapper, int inTriggerId)
        : base(inWrapper, inTriggerId)
    {

    }

    public override void TriggerEnter(Fighter src, ITrigger inTrigger)
    {
        BattleMgr.Instance.DoPauseFighting(false);
    }
}

public class TriggerActionPauseGame : TriggerActionBase
{
    private int timer = -1;

    public TriggerActionPauseGame(TriggerActionWrapper inWrapper, int inTriggerId)
        : base(inWrapper, inTriggerId)
    {

    }

    public override void TriggerEnter(Fighter src, ITrigger inTrigger)
    {
        if (timer != -1)
        {
            return;
        }

        DoPauseGame(true);

        if (TotalTime > 0)
        {
            timer = TimerManager.Instance.AddTimer(TotalTime, 1, OnTimeUp);
        }

        return;
    }

    public override void Stop()
    {
        if (timer != -1)
        {
            TimerManager.Instance.RemoveTimer(timer);
            timer = -1;
        }
        base.Stop();
    }

    private void OnTimeUp(int timersequence)
    {
        DoPauseGame(false);

        if (timer != -1)
        {
            TimerManager.Instance.RemoveTimer(timer);
            timer = -1;
        }
    }

    private void DoPauseGame(bool bPause)
    {
        BattleMgr.Instance.DoPauseFighting(bPause);
    }

    public override void TriggerUpdate(Fighter src, ITrigger inTrigger)
    {

    }

    public override void TriggerLeave(Fighter src, ITrigger inTrigger)
    {
        if (bStopWhenLeaving)
        {
            DoPauseGame(false);
        }
    }
}

public class TriggerActionSetGlobalVariable : TriggerActionBase
{
    public TriggerActionSetGlobalVariable(TriggerActionWrapper inWrapper, int inTriggerId)
        : base(inWrapper, inTriggerId)
    {

    }

    public override void TriggerEnter(Fighter src , ITrigger inTrigger)
    {
        //if (BattleLogic.instance.m_globalTrigger != null)
        //{
        //    BattleLogic.instance.m_globalTrigger.CurGlobalVariable = EnterUniqueId;
        //}

        return;
    }
}

public class TriggerMove:TriggerActionBase
{
    public TriggerMove(TriggerActionWrapper inWrapper, int inTriggerId)
        : base(inWrapper, inTriggerId)
    {

    }

    public override void TriggerEnter(Fighter src, ITrigger inTrigger)
    {
        if (src != null && BattleMgr.Instance.Battle != null && BattleMgr.Instance.Battle.CurBattleField != null)
        {
            Vector3 destPos = Vector3.zero;
            if (!string.IsNullOrEmpty(Param))
            {
                destPos = StringUtil.convertVector3(Param);
            }
            BattleMgr.Instance.Battle.FighterMove2BattleCenter(src, destPos);
            EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_SHOW_FIGHTER, src));
        }
    }
}

public class TriggerComingAnim : TriggerActionBase
{
    public TriggerComingAnim(TriggerActionWrapper inWrapper,int inTriggerId)
        :base(inWrapper,inTriggerId)
    {

    }

    public override void TriggerEnter(Fighter src,ITrigger inTrigger)
    {
        if(src!=null)
        {
            //DebugHelper.LogError(src.Name);
            src.ForceComing(TotalTime*0.001f);
        }
    }

    public override void TriggerUpdate(Fighter src, ITrigger inTrigger)
    {
        
    }

    public override void TriggerLeave(Fighter src, ITrigger inTrigger)
    {
        if(src!=null)
        {
            src.ForceIdle();
        }
    }
}

public class TriggerPlayEffect : TriggerActionBase
{
    public TriggerPlayEffect(TriggerActionWrapper inWrapper,int inTriggerId)
        :base(inWrapper,inTriggerId)
    {

    }

    public override void TriggerEnter(Fighter src, ITrigger inTrigger)
    {
        if(src!=null)
        {
            EffectManager.Instance.PlayEffect(EnterUniqueId, src, src);
        }
        else
        {
            if (EnterUniqueId > 0)
            {
                EffectManager.Instance.PlayEffect(EnterUniqueId);
            }
        }
    }
}

public class TriggerSetUINodeVis : TriggerActionBase
{
    public TriggerSetUINodeVis(TriggerActionWrapper inWrapper, int inTriggerId)
       : base(inWrapper, inTriggerId)
    {

    }

    public override void TriggerEnter(Fighter src, ITrigger inTrigger)
    {
        if(!string.IsNullOrEmpty(Param))
        {
            BattleMgr.Instance.SetUINodeVis(Param);
        }
    }
}

public class TriggerPlayBGM : TriggerActionBase
{
    public TriggerPlayBGM(TriggerActionWrapper inWrapper,int inTriggerId)
        :base(inWrapper,inTriggerId)
    {

    }

    public override void TriggerEnter(Fighter src, ITrigger inTrigger)
    {
        if(!string.IsNullOrEmpty(Param))
        {
            MusicMgr.Instance.PlayBGMusic(Param);
        }
    }
}

public class TriggerExitBattle: TriggerActionBase
{
    public TriggerExitBattle(TriggerActionWrapper inWrapper,int inTriggerId)
        :base(inWrapper, inTriggerId)
    {

    }

    public override void TriggerEnter(Fighter src, ITrigger inTrigger)
    {
        BattleMgr.Instance.OnBattleEnd(2);
    }
}

public class TriggerCalcNextPoint:TriggerActionBase
{
    public TriggerCalcNextPoint(TriggerActionWrapper inWrapper,int inTriggerId)
        :base(inWrapper,inTriggerId)
    {

    }

    public override void TriggerEnter(Fighter src, ITrigger inTrigger)
    {
        BattleMgr.Instance.Battle.CalcNextPoint();
    }
}


public class TriggerDisactive:TriggerActionBase
{
    private int timer = -1;
    private Fighter mSrc;
    public TriggerDisactive(TriggerActionWrapper inWrapper,int inTriggerId)
        :base(inWrapper,inTriggerId)
    {

    }

    public override void TriggerEnter(Fighter src, ITrigger inTrigger)
    {
        if (timer != -1)
        {
            return;
        }

        mSrc = src;
        if (src!=null)
        {
            src.Ctrl.SetLayer(LayerMask.NameToLayer(BattleCamera.HideLayerName));
        }

        if (TotalTime > 0)
        {
            timer = TimerManager.Instance.AddTimer(TotalTime, 1, OnTimeUp);
        }
    }

    public override void Stop()
    {
        if (timer != -1)
        {
            TimerManager.Instance.RemoveTimer(timer);
            timer = -1;
        }
        base.Stop();
    }

    private void OnTimeUp(int timersequence)
    {
        if (mSrc != null)
        {
            mSrc.Ctrl.SetLayer(LayerMask.NameToLayer(BattleCamera.FighterLayerName));
        }

        if (timer != -1)
        {
            TimerManager.Instance.RemoveTimer(timer);
            timer = -1;
        }

        mSrc = null;
    }
}

public class TriggerCameraMove:TriggerActionBase
{
    public TriggerCameraMove(TriggerActionWrapper inWrapper, int inTriggerId)
        : base(inWrapper, inTriggerId)
    {

    }

    public override void TriggerEnter(Fighter src, ITrigger inTrigger)
    {
        string[] paramList = StringUtil.split(Param, ';');
        if(paramList.Length == 2)
        {
            BattleMgr.Instance.PlayComingCameraAnim(paramList[0],paramList[1]);
        } 
    }
}

public class TriggerEnableSkill:TriggerActionBase
{
    public TriggerEnableSkill(TriggerActionWrapper inWrapper, int inTriggerId)
       : base(inWrapper, inTriggerId)
    {

    }

    public override void TriggerEnter(Fighter src, ITrigger inTrigger)
    {
        if (src != null)
        {
            src.AIEnable = true;
        }
    }
}

public class TriggerDisableSkill: TriggerActionBase
{
    public TriggerDisableSkill(TriggerActionWrapper inWrapper, int inTriggerId)
      : base(inWrapper, inTriggerId)
    {

    }

    public override void TriggerEnter(Fighter src, ITrigger inTrigger)
    {
        if (src != null)
        {
            src.AIEnable = false;
        }
    }
}

public class TriggerShowSkip : TriggerActionBase
{
    public TriggerShowSkip(TriggerActionWrapper inWrapper, int inTriggerId)
        : base(inWrapper, inTriggerId)
    {

    }

    public override void TriggerEnter(Fighter src, ITrigger inTrigger)
    {
        BattleMgr.Instance.ShowSkipBattle();
    }
}