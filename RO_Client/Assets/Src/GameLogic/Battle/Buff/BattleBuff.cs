using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;

public class BattleBuff
{
    #region properties
    int repeatCastingEffectInstanceId = 0;
    int singEffectInstanceId = 0;
    bool mHasBeenStop = false;
    bool mExecuteDelayHurt = false;

    float mCurTime = 0;
    //float mTotalTime;
    int mEventIdx = 0;

    BuffData mBuffData;
    Fighter mFighter;
    BaseBattle mBattle;
    BaseSkill mSkill;
    int skillLv = 1;
    //float mSingTotalTime = 0;

    //TimeDelayManager<SkillActionAttackInfo> mDelayAttackInfo;
    //TimeDelayManager<SkillActionAttackInfo> mDelayAttackEffect;
    FrameDelayManager<SkillActionAttackInfo> mDelayAttackInfo;
    FrameDelayManager<SkillActionAttackInfo> mDelayAttackEffect;

    List<int> mTriggeredEffects;
    List<Fighter> mTempHitFighters = new List<Fighter>();
    List<SkillHitFighterInfo> mHitFighterInfoList;
    List<SkillActionFrameEvent> mWaitEndEventList = null;
    List<int> mSingEffectList = new List<int>();
    Fighter mTarget = null;
    int totalHurtCnt = 1;
    int hurtTimes = 0;
    bool changeSpeed = false;
    private bool mIsEnhance = false;        //是否为增强buff
    private float mCastingTime = 0;
    private List<stDamageParam> mDamageList = new List<stDamageParam>();

    private int mFrame;
    public int Frame
    {
        get { return mFrame; }
    }

    private int mTotalFrame;
    public int TotalFrame
    {
        get { return mTotalFrame; }
    }


    private int mSingTotalFrame = 0;
    #endregion

    #region public_fields
    public Fighter OwnerFighter { get { return mFighter; } }

    public BaseSkill Skill { get { return mSkill; } }

    //记录buff 释放源
    private Fighter mSourceFighter;
    public Fighter SourceFighter { get { return mSourceFighter; } }  
    public void SetSourceFighter(Fighter pSourceFighter)//设置释放源
    {
        if (null == mSourceFighter)
            mSourceFighter = pSourceFighter;
    }
    public Fighter GetSourceFighter()//获取释放源
    {
        if (null != mSourceFighter)//没有释放源 就取buff挂在角色
            return mSourceFighter;
        else
            return OwnerFighter;
    }

    public int BuffId { get { return mBuffData.buffID; } }

    public int SortValue { get { return mBuffData.sortValue; } }

    public bool Expired { get { return mFrame > mTotalFrame; } }
    
    public bool HasBeenStop { get { return mHasBeenStop; } }

    public bool IsHide { get; private set; }

    public Target_Select_Rule BuffTargetType { get { return mBuffData.funTargetType; } }

    public TargetFilterRule FilterRule { get { return mBuffData.filterRule; } }

    public BuffData Data { get { return mBuffData; } }

    private int mCastFrameCnt = 0;
    public int CastFrameCnt
    {
        get { return mCastFrameCnt; }
    }

    public bool IsEnhance
    {
        get { return mIsEnhance; }
        set { mIsEnhance = value; }
    }

    int mEffectEventIdx = 0;
    private List<SkillActionFrameEvent> mEffectActionEventList = null;

    private bool bCheckMark = false;

    //目标伤害总值
    private Dictionary<int, int> mDicTotalDamage = new Dictionary<int, int>();
    #endregion


    public BattleBuff(BuffData buffData, Fighter fighter, BaseSkill skill)
    {
        mCastingTime = Time.realtimeSinceStartup;
        mCastFrameCnt = Time.frameCount;
        mBuffData = buffData;
        mFighter = fighter;
        mBattle = fighter.Battle;
        mSkill = skill;
        mDicTotalDamage.Clear();
        bCheckMark = false;
        if (mSkill != null)
        {
            mSingTotalFrame = (int)((Fix64)mSkill.SingTotalTime * (Fix64)Constants.frame_to_time);
            skillLv = mSkill.Level;
            mBuffData.SetLevel(skillLv);
        }
        else
        {
            skillLv = buffData.BuffLevel;//由技能buff 触发的buff 使用上一个buff 等级
        }
        mCurTime = 0;

        Fix64 fAttrAttackSpeedPercent = (Fix64)SDataUtil.InvConvert(mFighter.AttrAttackSpeedPercent);
        Fix64 fSkillAttackSpeedPercent = (Fix64)SDataUtil.InvConvert(mFighter.SkillAttackSpeedPercent);      
        mTotalFrame = (int)(mBuffData.totalFrame * Fix64.Max(Fix64.One - fAttrAttackSpeedPercent, (Fix64)0.3f) * Fix64.Max(Fix64.One - fSkillAttackSpeedPercent, (Fix64)0.3f));
        mFrame = 0;
        totalHurtCnt = mBuffData.multiHurtCnt;
        mTriggeredEffects = new List<int>();
        mWaitEndEventList = new List<SkillActionFrameEvent>();
        mDelayAttackInfo = new FrameDelayManager<SkillActionAttackInfo>(PerformAttackInfo);
        mDelayAttackEffect = new FrameDelayManager<SkillActionAttackInfo>(PerformAttackEffect);
        RefreshFrameEvents();
        CheckSkillAnimSpeed();
    }

    private void RefreshFrameEvents()
    {
        SkillActionFrameEvent fe = mBuffData.SingFrameEvent;
        if (fe == null) return;

        int deltaFrame = mSingTotalFrame - fe.initEndFrame;
        fe.initEndFrame = fe.initEndFrame + deltaFrame;
        for (int idx = 0; idx < mBuffData.ActionFrameEvents.Length; idx++)
        {
            SkillActionFrameEvent evt = mBuffData.ActionFrameEvents[idx];
            if (evt != fe && evt.bAffectBySing)
            {
                evt.initStartFrame = evt.initStartFrame + deltaFrame;
                evt.initStartTime = (Fix64)evt.initStartTime + (Fix64)deltaFrame / (Fix64)Constants.frame_to_time;
                if (evt.initEndFrame > 0)
                {
                    evt.initEndFrame = evt.initEndFrame + deltaFrame;
                    evt.initEndTime = (Fix64)evt.initEndTime + (Fix64)deltaFrame / (Fix64)Constants.frame_to_time;
                }
            }
        }
    }

    private void CheckSkillAnimSpeed()
    {
        bool isSingSkill = mSkill != null ? mSkill.IsSingSkill : false;

        if (!isSingSkill)
        {
            for (int idx = 0; idx < mBuffData.ActionFrameEvents.Length; idx++)
            {
                SkillActionFrameEvent evt = mBuffData.ActionFrameEvents[idx];
                Fix64 fAttrAttackSpeedPercent = (Fix64)SDataUtil.InvConvert(mFighter.AttrAttackSpeedPercent);
                Fix64 fSkillAttackSpeedPercent = (Fix64)SDataUtil.InvConvert(mFighter.SkillAttackSpeedPercent);
                evt.startFrame = (int)(evt.initStartFrame * Fix64.Max(Fix64.One - fAttrAttackSpeedPercent, (Fix64)0.3f) * Fix64.Max(Fix64.One - fSkillAttackSpeedPercent, (Fix64)0.3f));
                evt.endFrame = (int)(evt.initEndFrame * Fix64.Max(Fix64.One - fAttrAttackSpeedPercent, (Fix64)0.3f) * Fix64.Max(Fix64.One - fSkillAttackSpeedPercent, (Fix64)0.3f));

                evt.startTime = evt.initStartTime * Fix64.Max(Fix64.One - fAttrAttackSpeedPercent, (Fix64)0.3f) * Fix64.Max(Fix64.One - fSkillAttackSpeedPercent, (Fix64)0.3f);
                evt.endTime = evt.initEndTime * Fix64.Max(Fix64.One - fAttrAttackSpeedPercent, (Fix64)0.3f) * Fix64.Max(Fix64.One - fSkillAttackSpeedPercent, (Fix64)0.3f);
            }
        }
        else
        {
            for (int idx = 0; idx < mBuffData.ActionFrameEvents.Length; idx++)
            {
                SkillActionFrameEvent evt = mBuffData.ActionFrameEvents[idx];
                evt.startFrame = evt.initStartFrame;
                evt.endFrame = evt.initEndFrame;

                evt.startTime = evt.initStartTime;
                evt.endTime = evt.initEndTime;
            }
        }
    }

    public void Start()
    {
        bCheckMark = false;
        mCurTime = 0;
        mFrame = 0;
        SelectTarget();
        //if (BattleMgr.Instance.Battle.IsPlayRecord || BattleMgr.Instance.Battle.IsKillingBoss)
        //    DebugHelper.LogError(this.BuffId + "-------------Fighter=" + mFighter.Id + " start:" + Time.frameCount);
    }

    public void Stop()
    {
        if (mHasBeenStop)
            return;

        if (!BattleMgr.Instance.Battle.IsPlayRecord && BattleMgr.Instance.Battle.Recorder != null)
        {
            if (mSkill != null)
            {
                BattleMgr.Instance.Battle.Recorder.RecordFighterSkillData(mSkill.Id, mCastingTime, mFighter.Actor.ID, mFighter.Actor.BaseId, (int)mFighter.TeamSide, mDamageList);
            }
        }

        if (Data.removeFunAfterStop)
        {
            for (int idx = Data.BuffFunList.Count - 1; idx >= 0; idx--)
            {
                mFighter.FuncMgr.RemoveDurationFunEvent(Data.BuffFunList[idx].id, Data.BuffFunList[idx].Group);
            }
        }

        mFighter.RemoveFunctionPoint(BuffId);

        if (changeSpeed)
            mFighter.StateData.SetAnimSpeed(1);

        for (int i = 0; i < mTriggeredEffects.Count; i++)
            EffectManager.Instance.RemoveEffectByInstanceID(mTriggeredEffects[i]);

        EndRepeatingCasting();
        mDelayAttackEffect.Clear();
        mDelayAttackInfo.Clear();
        mWaitEndEventList.Clear();
        mHasBeenStop = true;
        mDelayAttackEffect = null;
        mDelayAttackInfo = null;
        changeSpeed = false;
        mDicTotalDamage.Clear();
    }

    //public void AddTotalTime(float time)
    //{
    //    mTotalTime += time;
    //}

    public void AddTotalFrame(int frame)
    {
        mTotalFrame += frame;
    }

    public void Update(float deltaTime)
    {
        if (mHasBeenStop)
            return;

        //角色存在禁止释放技能  通过AI释放的SKILL 没有延迟伤害  跑三帧打断停止 
        if (mFrame >= Constants.s_protectframe && !mExecuteDelayHurt && (mSkill != null) && mSkill.IsAutoSkill && mFighter.FuncMgr.HaveForbidSkillFunc())
        {
            Stop();
            return;
        }

        //角色存在打断效果 跑三帧打断停止
        if (mFrame >= Constants.s_protectframe && mFighter.FuncMgr.HaveBuffFunction(Buff_Function_Type.Break))
        {
            Stop();
            return;
        }

        //if (mCurTime <= mTotalTime)
        //      {
        //          mDelayAttackInfo.Update(deltaTime);
        //          mDelayAttackEffect.Update(deltaTime);

        //          UpdateFrame(deltaTime);
        //          CheckEndFrame();
        //      }
        //      else
        //      {
        //          Stop();
        //      }

        if (mFrame <= mTotalFrame)
        {
            if(null != mDelayAttackInfo)
                mDelayAttackInfo.Update();
            if(null != mDelayAttackEffect)
                mDelayAttackEffect.Update();

            //UpdateTime(deltaTime);
            UpdateFrame();
            CheckEndFrame();
        }
        else
        {
            Stop();
        }
    }

    private void UpdateFrame()
    {
        while (mEventIdx < mBuffData.ActionFrameEvents.Length && !mHasBeenStop)
        {
            if (mBuffData.ActionFrameEvents[mEventIdx].startFrame > mFrame)
                break;

            SkillActionFrameEvent fe = mBuffData.ActionFrameEvents[mEventIdx++];      
            if (ProcessEvent(fe) && fe.endFrame > 0)
            {
                mWaitEndEventList.Add(fe);
            }
        }
        mFrame++;
    }

    //private void UpdateTime(float deltaTime)
    //{
    //    while (mEffectEventIdx < mEffectActionEventList.Count && !mHasBeenStop)
    //    {
    //        if (mEffectActionEventList[mEffectEventIdx].startTime > mCurTime)
    //            break;

    //        SkillActionFrameEvent fe = mEffectActionEventList[mEffectEventIdx++];
    //        ProcessEventWithTime(fe);
    //    }

    //    mCurTime += deltaTime;
    //}

    private void CheckEndFrame()
    {
        for (int idx = mWaitEndEventList.Count - 1; idx >= 0; idx--)
        {
            SkillActionFrameEvent fe = mWaitEndEventList[idx];
            if (fe.endFrame <= mFrame)
            {
                ProcessEndEvent(fe);
                mWaitEndEventList.RemoveAt(idx);
            }
        }
    }

    //private bool ProcessEventWithTime(SkillActionFrameEvent frameEv)
    //{
    //    bool canProcess = true;
    //    if (mFrame >= Constants.s_protectframe && mSkill != null && mSkill.IsAutoSkill && mFighter.FuncMgr.HaveForbidSkillFunc())
    //    {
    //        canProcess = false;
    //    }

    //    switch (frameEv.eventType)
    //    {
    //        case SkillActionFrameEventType.FE_PlayEffect:
    //            if (mFighter.Ctrl != null)
    //            {
    //                int effectId = frameEv.GetN(Constants.s_skillaction_frame_key_effect);
    //                int effectInstanceID = EffectManager.Instance.PlayEffect(effectId, mFighter, mFighter);
    //                if (effectInstanceID >= 0)
    //                    mTriggeredEffects.Add(effectInstanceID);
    //            }
    //            break;
    //    }
    //    return canProcess;
    //}

    private bool ProcessEvent(SkillActionFrameEvent frameEv)
    {
        if (null == mFighter)
            return false;
        bool canProcess = true;
        bool bforbidSkill = false;
        if (null != mFighter.FuncMgr && mFighter.FuncMgr.HaveForbidSkillFunc())
            bforbidSkill = true;
        if (mFrame >= Constants.s_protectframe && mSkill != null && mSkill.IsAutoSkill && bforbidSkill)
        {
            canProcess = false;
        }
        try
        {
            switch (frameEv.eventType)
            {
                case SkillActionFrameEventType.FE_ShakeCamera:
                    float leftRightVal = frameEv.GetN("leftright") * 0.01f;
                    float upDownVal = frameEv.GetN("updown") * 0.01f;
                    float forwardbackward = frameEv.GetN("forwardbackward") * 0.01f;
                    float shakeTime = frameEv.GetN("time") * 0.01f;
                    int cycle = frameEv.GetN("cycle");
                    if (cycle > 0 && shakeTime > 0)
                    {
                        BattleCamera.Instance.Shake(leftRightVal, upDownVal, forwardbackward, shakeTime, cycle);
                    }
                    break;
                case SkillActionFrameEventType.FE_ChangeCamera:
                    Vector3 camPos = StringUtil.convertVector3(frameEv.GetStr(Constants.s_skillaction_frame_key_cam_pos));
                    Vector3 camRot = StringUtil.convertVector3(frameEv.GetStr(Constants.s_skillaction_frame_key_cam_rot));
                    int camFov = frameEv.GetN(Constants.s_skillaction_frame_key_cam_fov);
                    BattleCamera.Instance.SetCameraPosAndRot(camPos, camRot, camFov);
                    break;
                case SkillActionFrameEventType.FE_PlaySound:
                    if (null != mFighter && mFighter.Ctrl != null)
                    {
                        string sound = frameEv.GetStr(Constants.s_skillaction_frame_key_sound);
                        if (!string.IsNullOrEmpty(sound))
                        {
                            MusicMgr.Instance.PlayFightSound(sound);
                        }
                    }
                    break;
                case SkillActionFrameEventType.FE_PlayEffect:
                    if (null != mFighter && mFighter.Ctrl != null)
                    {
                        int effectId = frameEv.GetN(Constants.s_skillaction_frame_key_effect);
                        int effectInstanceID = EffectManager.Instance.PlayEffect(effectId, mFighter, mFighter);
                        if (effectInstanceID >= 0)
                            mTriggeredEffects.Add(effectInstanceID);
                    }
                    break;
                case SkillActionFrameEventType.FE_PlaySkillAnim:
                    if (canProcess)
                    {
                        if(null != mFighter.StateData)
                        {
                            mFighter.StateData.PlayAnim(frameEv.GetStr("animName"));
                            int animSpeed = frameEv.GetN("animSpeed");
                            if (animSpeed > 0)
                            {
                                changeSpeed = true;
                                mFighter.StateData.SetAnimSpeed(animSpeed * 0.01f);
                            }
                        }
                    }
                    break;
                case SkillActionFrameEventType.FE_Move:
                    {
                        FighterMoveType moveType = (FighterMoveType)frameEv.GetN(Constants.s_skillaction_frame_key_move_type);
                        Fix64 speed = frameEv.GetN(Constants.s_skillaction_frame_key_move_speed) * (Fix64)0.01f;
                        Fix64 acceleration = frameEv.GetN(Constants.s_skillaction_frame_key_move_acceleration) * (Fix64)0.01f;
                        Fix64 dist = frameEv.GetN(Constants.s_skillaction_frame_key_move_dist) * (Fix64)0.01f;
                        int angle = frameEv.GetN(Constants.s_skillaction_frame_key_move_orientation);
                        FixVector3 v3SelfPos = new FixVector3(mFighter.Position);

                        if (null != mFighter.StateData && null != mFighter.StateData.SkillStateData 
                            && null != mFighter.StateData.SkillStateData.MoveProcessor)
                        {
                            if (moveType == FighterMoveType.Jump)
                            {
                                mFighter.StateData.SkillStateData.MoveProcessor.Start(speed, acceleration, v3SelfPos + FixVector3.Up * dist);
                            }
                            else if (moveType == FighterMoveType.Sprint_Target)
                            {
                                FixVector3 v3TargetPos = new FixVector3(mTarget.Position);
                                FixVector3 v3TargetForward = new FixVector3(mTarget.Forward);
                                FixVector3 destPos = v3TargetPos + v3TargetForward * dist;
                                mFighter.StateData.SkillStateData.MoveProcessor.Start(speed, acceleration, destPos);
                            }
                            else if (moveType == FighterMoveType.Sprint_Position)
                            {
                                //旋转 之后修改计算
                                FixVector3 eulerAngle = new FixVector3(mFighter.EulerAngle);
                                eulerAngle.y += angle;
                                mFighter.SetRotation(Quaternion.Euler(eulerAngle.ToVector3()));
                                FixVector3 SelfForward = new FixVector3(mFighter.Ctrl.transform.forward);
                                FixVector3 destPos = v3SelfPos + SelfForward * dist;
                                mFighter.StateData.SkillStateData.MoveProcessor.Start(speed, acceleration, destPos);
                            }
                        }
                    }
                    break;
                case SkillActionFrameEventType.FE_Buff:
                    int buffId = frameEv.GetN(Constants.s_skillaction_frame_key_buffid);
                    int rate = frameEv.GetN(Constants.s_skillaction_frame_key_rate);
                    if (buffId > 0)
                    {
                        int random = (int)(mBattle.RandomValue(true) * 100);
                        if (random <= rate)
                        {
                            BattleBuff pBuff = mFighter.CastBuff(null, buffId, skillLv);
                            if (null != pBuff)
                            {
                                Fighter pFighter = GetSourceFighter();  //获取源 设置新BUFF源
                                pBuff.SetSourceFighter(pFighter);
                            }
                        }
                    }
                    break;
                case SkillActionFrameEventType.FE_Summon:
                    if (canProcess)
                    {
                        int npcId = frameEv.GetN(Constants.s_skillaction_frame_key_npcId);
                        int npcPos = frameEv.GetN(Constants.s_skillaction_frame_key_npcPos);
                        if (mSkill != null && npcId > 0 && npcPos > 0)
                        {
                            Fighter f = mSkill.PopSummonActor(npcId, npcPos);
                            if (f != null && null != f.Actor && null != mFighter.CurrentBattleField)
                            {
                                f.Actor.SetLevel(mBattle.CurLevelMonsterLv);
                                Vector3 pos, rot;
                                mFighter.CurrentBattleField.GetFieldSummonPos(f.PositionValue, out pos, out rot);
                                f.Spawn(pos, Vector3.forward, Quaternion.Euler(rot));
                                f.SetRotation(Quaternion.Euler(rot));
                                if(null != f.Ctrl)
                                    f.Ctrl.SetLayer(LayerMask.NameToLayer(BattleCamera.FighterLayerName));
                            }
                        }
                    }
                    break;
                case SkillActionFrameEventType.FE_Skill_Sing:
                    if (canProcess)
                    {
                        SkillActionAttackInfo attackInfo = frameEv.CreateAttackInfo();
                        mFighter.BeginSing(frameEv.GetStr("animName"), attackInfo.hitEffect);

                    }
                    break;
                case SkillActionFrameEventType.FE_Repeat_Caster:
                    if (canProcess)
                    {
                        BeginRepeatCasting(frameEv);
                    }
                    break;
                case SkillActionFrameEventType.FE_Hit:
                    if (canProcess)
                    {
                        SkillActionAttackInfo attackInfo = frameEv.CreateAttackInfo();
                        PerformAttackInfo(attackInfo);
                    }
                    break;
                case SkillActionFrameEventType.FE_Bullet:
                    if (canProcess)
                    {
                        FireBullet(frameEv);
                    }
                    break;
                case SkillActionFrameEventType.FE_Delay_Hurt:
                    {
                        if (canProcess)
                        {
                            SkillActionAttackInfo attackInfo = frameEv.CreateAttackInfo();
                            if(null != attackInfo && null != mBuffData)
                            {
                                totalHurtCnt = attackInfo.delayHurtCount;
                                mBuffData.multiHurtIntervalTime = attackInfo.delayHurtDelayFrame / Constants.frame_to_time;
                                for (int idx = 0; idx < attackInfo.delayHurtCount; idx++)
                                {
                                    //mDelayAttackEffect.Add(attackInfo, (idx * attackInfo.delayHurtIntervalFrame)/ Constants.frame_to_time);
                                    //mDelayAttackInfo.Add(attackInfo,(idx*attackInfo.delayHurtIntervalFrame + attackInfo.delayHurtDelayFrame) / Constants.frame_to_time);
                                    if(null != mDelayAttackEffect)
                                    mDelayAttackEffect.Add(attackInfo, idx * attackInfo.delayHurtIntervalFrame);
                                    if (null != mDelayAttackInfo)
                                        mDelayAttackInfo.Add(attackInfo, idx * attackInfo.delayHurtIntervalFrame + attackInfo.delayHurtDelayFrame);
                                }
                            }                           
                        }
                        mExecuteDelayHurt = true;
                    }
                    break;
                case SkillActionFrameEventType.FE_SELECT_TARGET:
                    mFighter.SelectTarget = null;
                    SelectTarget();
                    break;
                case SkillActionFrameEventType.FE_SWITCH_SKILL:
                    if (canProcess)
                    {
                        SwitchSkill(frameEv);
                    }
                    break;
                case SkillActionFrameEventType.FE_Clone:
                    if (canProcess)
                    {
                        int npcId = frameEv.GetN(Constants.s_skillaction_frame_key_npcId);
                        int npcPos = frameEv.GetN(Constants.s_skillaction_frame_key_npcPos);
                        Vector3 position = StringUtil.convertVector3(Constants.s_skillaction_frame_key_position);
                        Vector3 rotation = StringUtil.convertVector3(Constants.s_skillaction_frame_key_rotation);
                        if (npcId > 0 && npcPos > 0)
                        {
                            Fighter f = null;
                            if (mSkill != null)
                            {
                                f = mSkill.PopSummonActor(npcId, npcPos);
                            }
                            else if (null != mFighter.Actor && BuffId == mFighter.Actor.RageId)
                            {
                                f = mFighter.RageCloneBoss;
                            }

                            if (f != null && null != mFighter.CurrentBattleField && null != f.StateData)
                            {
                                if (null != f.Actor && null != mFighter.Actor)
                                {
                                    f.Actor.SetLevel(mFighter.Actor.Level);
                                    f.Actor.IsBoss = true;
                                }
                                int bornEffectId = frameEv.GetN(Constants.s_skillaction_frame_key_effect);
                                f.BornEffectId = bornEffectId;
                                f.IsCloned = true;

                                Vector3 pos, rot;
                                mFighter.CurrentBattleField.GetFieldSummonPos(npcPos, out pos, out rot);
                                Quaternion r = Quaternion.identity;
                                if (rotation.FEqual(Vector3.zero, 0.01f))
                                {
                                    r = Quaternion.Euler(rot);
                                }
                                else
                                {
                                    r = Quaternion.Euler(rotation);
                                }

                                if (position.FEqual(Vector3.zero, 0.01f))
                                {
                                    f.Spawn(pos, Vector3.forward, r);
                                }
                                else
                                {
                                    f.Spawn(position, Vector3.forward, r);
                                }

                                if (rotation.FEqual(Vector3.zero, 0.01f))
                                {
                                    f.SetRotation(Quaternion.Euler(rot));
                                }
                                else
                                {
                                    f.SetRotation(Quaternion.Euler(rotation));
                                }
                                f.StateData.IsRageStatus = mFighter.StateData.IsRageStatus;

                                if(null != mBattle && null != mBattle.CurBattleField)
                                    mBattle.CurBattleField.RemoveFighter(mFighter);
                                mFighter.Dispose();
                                Stop();

                                EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_CLONE_NEW_BOSS, f));
                            }
                        }

                    }
                    break;
                case SkillActionFrameEventType.FE_ChangeSkyboxMat:
                    if (canProcess)
                    {
                        string switchScene = frameEv.GetStr(Constants.s_skillaction_frame_key_switchscene);
                        if (!string.IsNullOrEmpty(switchScene))
                        {
                            EventMgr.DispatchEvent<string>(new CoreEvent<string>(ECoreEventType.EID_SHOW_SCENE_GO, switchScene));
                        }

                        string matName = frameEv.GetStr(Constants.s_skillaction_frame_key_material_name);
                        EventMgr.DispatchEvent<string>(new CoreEvent<string>(ECoreEventType.EID_CHAGNE_SKYBOX_MATERIAL, matName));
                    }
                    break;
                case SkillActionFrameEventType.FE_PlayPrefab:
                    {
                        string prefabName = frameEv.GetStr(Constants.s_skillaction_frame_key_prefabname);
                        if (!string.IsNullOrEmpty(prefabName))
                        {
                            EventMgr.DispatchEvent<string>(new CoreEvent<string>(ECoreEventType.EID_PLAY_SKILL_PREFAB, prefabName));
                        }

                        string sound = frameEv.GetStr(Constants.s_skillaction_frame_key_sound);
                        if (!string.IsNullOrEmpty(sound))
                        {
                            MusicMgr.Instance.PlayFightSound(sound);
                        }
                    }
                    break;
                case SkillActionFrameEventType.FE_BattleUI_Visible:
                    {
                        int visFlag = frameEv.GetN(Constants.s_skillaction_frame_key_battleui_visible);
                        EventMgr.DispatchEvent<bool>(new CoreEvent<bool>(ECoreEventType.EID_BattleUI_Visible, visFlag > 0 ? true : false));
                    }
                    break;
                case SkillActionFrameEventType.FE_HideFighters:
                    {
                        if(null != mBattle && null != mBattle.CurBattleField)
                            mBattle.CurBattleField.HideFighters();
                    }
                    break;
                case SkillActionFrameEventType.FE_ShowFighters:
                    {
                        if (null != mBattle && null != mBattle.CurBattleField)
                            mBattle.CurBattleField.ShowFighters();
                    }
                    break;
            }
        }
        catch (System.Exception e)
        {
            Debug.LogError(e);            
        }        
        return canProcess;
    }
    
    private void ProcessEndEvent(SkillActionFrameEvent frameEv)
    {
        switch (frameEv.eventType)
        {
            case SkillActionFrameEventType.FE_Skill_Sing:
                {
                    mFighter.EndSing();
                }
                break;
            case SkillActionFrameEventType.FE_Repeat_Caster:
                {
                    EndRepeatingCasting();
                }
                break;
            case SkillActionFrameEventType.FE_Move:
                {
                    FighterMoveType moveType = (FighterMoveType)frameEv.GetN(Constants.s_skillaction_frame_key_move_type);
                    
                    if(moveType == FighterMoveType.Jump)
                    {
                        FixVector3 pos =new FixVector3(mFighter.Position);
                        pos.y = (Fix64)mFighter.CurrentBattleField.FloorY;
                        mFighter.StateData.SkillStateData.MoveProcessor.Start(Fix64.Zero, (Fix64)Constants.gravity, pos);
                    }
                }
                break;
            case SkillActionFrameEventType.FE_PlayPrefab:
                {
                    string prefabName = frameEv.GetStr(Constants.s_skillaction_frame_key_prefabname);
                    if (!string.IsNullOrEmpty(prefabName))
                    {
                        EventMgr.DispatchEvent<string>(new CoreEvent<string>(ECoreEventType.EID_CLOSE_SKILL_PREFAB, prefabName));
                    }
                }
                break;
        }
    }

    private bool isCasting = false;
    private void BeginRepeatCasting(SkillActionFrameEvent frameEv)
    {
        SkillActionAttackInfo attackInfo = frameEv.CreateAttackInfo();
        mFighter.StateData.PlayAnim(frameEv.GetStr("animName"));
        
        if(attackInfo.hitEffect > 0)
        {
            repeatCastingEffectInstanceId = EffectManager.Instance.PlayEffect((int)attackInfo.hitEffect, mFighter, mFighter);
            if (repeatCastingEffectInstanceId > 0)
                mTriggeredEffects.Add(repeatCastingEffectInstanceId);
        }

        mFighter.ShowCasting((frameEv.endFrame - frameEv.startFrame) / Constants.frame_to_time, true);
        isCasting = true;
    }

    private void EndRepeatingCasting()
    {
        if(isCasting)
        {
            if (repeatCastingEffectInstanceId > 0)
            {
                EffectManager.Instance.RemoveEffectByInstanceID(repeatCastingEffectInstanceId);
                mTriggeredEffects.Remove(repeatCastingEffectInstanceId);
                repeatCastingEffectInstanceId = 0;
            }
            mFighter.ShowCasting(0, false);

            isCasting = false;
        }
    }

    private void FireBullet(SkillActionFrameEvent frameEv)
    {
        if (mTempHitFighters == null || mTempHitFighters.Count == 0) return;

        SkillActionAttackInfo info = frameEv.CreateAttackInfo();
        if (info.bulletID == 0) return;

        for (int idx =0; idx < mTempHitFighters.Count;idx++)
        {
            Fighter f = mTempHitFighters[idx];
            if (f == mFighter || f.IsDisposed || !f.IsAlive) continue;

            mFighter.StateData.SkillStateData.BulletMgr.Add(mFighter, f, info,this);
        }
    }

    private void SwitchSkill(SkillActionFrameEvent frameEv)
    {
        if (mTempHitFighters == null || mTempHitFighters.Count == 0) return;

        SkillActionAttackInfo info = frameEv.CreateAttackInfo();
        PerformAttackInfo(info);
    }

    private void SelectTarget()
    {
        bool reselect = false;
        if(mFighter.StateData.IsSneer && 
            (FilterRule.teamType == FilterTeamType.Team_Type_Enemy) &&
            (BuffTargetType == Target_Select_Rule.Target_Select_OnlyOne ||
            BuffTargetType == Target_Select_Rule.Target_Select_RandomOne ||
            BuffTargetType == Target_Select_Rule.Target_Select_RandomOne_Prior_Front ||
            BuffTargetType == Target_Select_Rule.Target_Select_RandomOne_Prior_Back))
        {
            DurationFunctionEvent evt = mFighter.FuncMgr.GetFunctionByType(Buff_Function_Type.Sneer);
            if(evt != null)
            {
                mTempHitFighters.Clear();
                mTempHitFighters.Add(evt.Caster);
                RotateToTarget(evt.Caster);
            }
            else
            {
                reselect = true;
            }
        }
        else
        {
            reselect = true;
        }

        if(reselect)
        {
            mTarget = GetBeHitFightersByAttackInfo();
            if (mTarget != null)
            {
                RotateToTarget(mTarget);
            }
        }
    }

    #region BeHitFighter TotalDamage
    private int GetTotalDamageByHitFighterIndex(int nIdx)
    {
        bool bIsFind = mDicTotalDamage.ContainsKey(nIdx);
        if(!bIsFind)
        {
            mDicTotalDamage.Add(nIdx, 0);
        }
        return mDicTotalDamage[nIdx];
    }

    private void AddTotalDamageByHitFighterIndex(int nIdx,int nDamage)
    {
        bool bIsFind = mDicTotalDamage.ContainsKey(nIdx);
        if (!bIsFind)
        {
            mDicTotalDamage.Add(nIdx, nDamage);
            return;
        }
        mDicTotalDamage[nIdx] += nDamage;
    }
    #endregion
    public void PerformAttackInfo(SkillActionAttackInfo attackInfo)
    {
        attackInfo.skill = mSkill;
        if (mHitFighterInfoList == null)
            mHitFighterInfoList = new List<SkillHitFighterInfo>();
        else
            mHitFighterInfoList.Clear();

        //mFighter.ProcessTriggerBuff(BuffTriggerType.Trigger_Attack);
        EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_Fighter_Attack, mFighter));

        hurtTimes++;
        for (int idx = 0; idx < mTempHitFighters.Count; idx++)
        {
            Fighter pCaster = GetSourceFighter();//伤害计算 采用源
            mHitFighterInfoList.Add(new SkillHitFighterInfo(pCaster, mTempHitFighters[idx],BuffId, attackInfo));
        }

        CheckMark();

        for (int idx = 0; idx < mHitFighterInfoList.Count; idx++)
        {
            if (mHasBeenStop) return;

            SkillHitFighterInfo hitInfo = mHitFighterInfoList[idx];
           
            ExecuteFunction(hitInfo, idx);

            if(attackInfo.buffID > 0)
            {
                int random = (int)(mBattle.RandomValue(true) * 100);
                if (random <= attackInfo.rate)
                {
                    BattleBuff pBuff = hitInfo.Target.CastBuff(null, attackInfo.buffID);
                    if (null != pBuff)
                    {
                        Fighter pFighter = GetSourceFighter();  //获取源 设置新BUFF源
                        pBuff.SetSourceFighter(pFighter);
                    }
                }
            }
            mDamageList.Add(hitInfo.HitParam);
        }

        MusicMgr.Instance.PlayFightSound(attackInfo.sound);
    }

    //子彈攻击
    public void PerformBullteAttackInfo(SkillActionAttackInfo attackInfo,Fighter pBullteTarget)
    {
        attackInfo.skill = mSkill;
        if (mHitFighterInfoList == null)
            mHitFighterInfoList = new List<SkillHitFighterInfo>();
        else
            mHitFighterInfoList.Clear();

        //mFighter.ProcessTriggerBuff(BuffTriggerType.Trigger_Attack);
        EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_Fighter_Attack, mFighter));

        hurtTimes++;
       
        if(null != pBullteTarget)
        {
            Fighter pCaster = GetSourceFighter();//伤害计算 采用源
            mHitFighterInfoList.Add(new SkillHitFighterInfo(pCaster, pBullteTarget, BuffId, attackInfo));            
        }

        CheckMark();

        for (int idx = 0; idx < mHitFighterInfoList.Count; idx++)
        {
            if (mHasBeenStop) return;

            SkillHitFighterInfo hitInfo = mHitFighterInfoList[idx];

            ExecuteFunction(hitInfo, idx);
           
            if (attackInfo.buffID > 0)
            {
                int random = (int)(mBattle.RandomValue(true) * 100);
                if (random <= attackInfo.rate)
                {
                    BattleBuff pBuff = hitInfo.Target.CastBuff(null, attackInfo.buffID);
                    if (null != pBuff)
                    {
                        Fighter pFighter = GetSourceFighter();  //获取源 设置新BUFF源
                        pBuff.SetSourceFighter(pFighter);
                    }                    
                }
            }
            mDamageList.Add(hitInfo.HitParam);
        }
        MusicMgr.Instance.PlayFightSound(attackInfo.sound);
    }

    private void PerformAttackEffect(SkillActionAttackInfo attackInfo)
    {
        for (int idx = 0; idx < mTempHitFighters.Count; idx++)
        {
            Fighter target = mTempHitFighters[idx];
            target.Ctrl.DoBeHitEffect(attackInfo.effect, mFighter);
        } 
    }

    private void ExecuteFunction(SkillHitFighterInfo hitInfo,int nIdx)
    {
        bool isDamage = false;
        Fighter pCaster = hitInfo.Caster;
        for (int idx = 0; idx < mBuffData.BuffFunList.Count; idx++)
        {
            if (mHasBeenStop) break;

            BuffFunctionData data = mBuffData.BuffFunList[idx];
            if (data.IsInstantFunc)
            {
                if(data.buffType == BattleBuffType.Hurt)
                {
                    isDamage = true;
                    mFighter.FuncMgr.AddFunctionEvent(BuffId,data, pCaster, hitInfo);
                }
                else
                {
                    hitInfo.Target.FuncMgr.AddFunctionEvent(BuffId,data, pCaster, hitInfo);
                }         
            }
            else
            {
                hitInfo.Target.FuncMgr.AddFunctionEvent(BuffId,data, pCaster, hitInfo);
            }
        }

        if (hitInfo.Target == null || hitInfo.Target.IsDisposed || !hitInfo.Target.IsAlive || !isDamage)
        {
            mFighter.FuncMgr.RemoveFunctionByBuffType(BattleBuffType.Hurt);
            if(hitInfo.Target!=null && !hitInfo.Target.IsDisposed && hitInfo.Target.IsAlive)
                hitInfo.Target.Ctrl.DoBeHitEffect(hitInfo.AttackInfo.hitEffect, hitInfo.Caster);
            return;
        }
      
        SInt damage = hitInfo.CalculateDamage(mBuffData.damageType,mBuffData.hitType);
        if (!mBuffData.ignoreMultiHurt)
        {
            hitInfo.AttackInfo.multiHitCount = totalHurtCnt;
            hitInfo.AttackInfo.multiHitIntervalTime = mBuffData.multiHurtIntervalTime;
        }
        else
        {
            hurtTimes = 0;
        }

        if (BattleMgr.Instance.Battle.CanPrintLog)
            DebugHelper.LogError(this.BuffId + "-------------Fighter=" + mFighter.Name + " target:" + hitInfo.Target.Name + " damage=" + damage + " IsPerfactDodge:" + hitInfo.IsPerfectDodge + " IsDodge:" + hitInfo.IsDodge + " IsCrit:" + hitInfo.IsCrit + " 无敌:" + hitInfo.Target.StateData.IsInvincible);


        //累计当前伤害
        int nTotalDamge = GetTotalDamageByHitFighterIndex(nIdx);
        hitInfo.Target.ProcessBeHit(hitInfo, hurtTimes, nTotalDamge);
        hitInfo.SetRealDamage((int)hitInfo.Damage);
        AddTotalDamageByHitFighterIndex(nIdx, (int)hitInfo.Damage);
        mFighter.FuncMgr.RemoveFunctionByBuffType(BattleBuffType.Hurt);
               
        if (mFighter.Statistics != null)
            mFighter.Statistics.StatHitInfo(hitInfo);

        //反伤伤害数据
        if (hitInfo.ReflectDamage > 0)
        {            
            pCaster.ProcessReflectDamage(hitInfo.ReflectDamage, mSkill!=null?mSkill.SkillName:"", hitInfo.Target);
        }

        //吸收伤害
        if (hitInfo.SuckDamge > 0)
        {
            hitInfo.Target.ProcessSuckDamage(hitInfo.SuckDamge, mSkill != null ? mSkill.SkillName : "", pCaster);
        }
    }

    private Fighter GetBeHitFightersByAttackInfo()
    {
        mTempHitFighters.Clear();
        List<Fighter> filterFighters = FilterTargets(mFighter.CurrentBattleField.Fighters);

        bool hasFront, hasback;
        CheckTargetInfo(filterFighters,out hasFront, out hasback);

        if(BuffTargetType == Target_Select_Rule.Target_Select_All)
        {
            for(int idx =0; idx < filterFighters.Count;idx++)
            {
                var f = filterFighters[idx];
                mTempHitFighters.Add(f);
            }
        }
        else if (BuffTargetType == Target_Select_Rule.Target_Select_Self)
        {
            if(mFighter.IsAlive)
                mTempHitFighters.Add(mFighter);
        }
        else if(BuffTargetType == Target_Select_Rule.Target_Select_Owner_And_Pet)
        {
            if (mFighter.IsAlive)
                mTempHitFighters.Add(mFighter);

            if(mFighter.IsPlayer)
            {
                if(mFighter.UsedPetId > 0)
                {
                    Fighter pet = mFighter.Battle.FighterMgr.GetFighterByID(mFighter.UsedPetId, mFighter.TeamSide);
                    if(pet!=null && pet.IsAlive)
                    {
                        mTempHitFighters.Add(pet);
                    }
                }
            }
            else if(mFighter.IsPet)
            {
                Fighter owner = mFighter.Battle.FighterMgr.GetFighterByID(mFighter.OwnerId, mFighter.TeamSide);
                if(owner != null && owner.IsAlive)
                {
                    mTempHitFighters.Add(owner);
                }
            }
        }
        else if(BuffTargetType == Target_Select_Rule.Target_Select_Owner)
        {
            Fighter owner = mFighter.Battle.FighterMgr.GetFighterByID(mFighter.OwnerId, mFighter.TeamSide);
            if(owner != null)
            {
                if(owner.IsAlive)
                    mTempHitFighters.Add(owner);
            }
            else
            {
                if(mFighter.IsAlive)
                    mTempHitFighters.Add(mFighter);
            }
        }
        else if(IsSingleTarget(BuffTargetType))
        {
            Fighter fighter = SkillSelectHelper.SelectTargetsByRules(mFighter, filterFighters, BuffTargetType, OnBeforeFilter, OnAfterCompare);
            if (fighter != null)
            {
                mTempHitFighters.Add(fighter);
            }
        }
        else if(BuffTargetType == Target_Select_Rule.Target_Select_Exclude_Self)
        {
            for (int idx = 0; idx < filterFighters.Count; idx++)
            {
                Fighter f = filterFighters[idx];
                if (f == mFighter) continue;

                mTempHitFighters.Add(f);
            }
        }
        else if(BuffTargetType == Target_Select_Rule.Target_Select_RandomOne)
        {
            if (filterFighters.Count >= 1)
            {
                int idx = (int)(BattleMgr.Instance.Battle.RandomValue(false) * filterFighters.Count);
                Fighter f = filterFighters[idx];
                mTempHitFighters.Clear();
                mTempHitFighters.Add(f);
            }
        }
        else if(BuffTargetType == Target_Select_Rule.Target_Select_RandomOne_Prior_Front ||
                BuffTargetType == Target_Select_Rule.Target_Select_RandomOne_Prior_Back)
        {
            for (int idx = 0; idx < filterFighters.Count; idx++)
            {
                Fighter f = filterFighters[idx];

                if (BuffTargetType == Target_Select_Rule.Target_Select_RandomOne_Prior_Front)
                {
                    if (f.IsFront || !hasFront)
                        mTempHitFighters.Add(f);
                }
                else if (BuffTargetType == Target_Select_Rule.Target_Select_RandomOne_Prior_Back)
                {
                    if (f.IsBack || !hasback)
                        mTempHitFighters.Add(f);
                }
            }

            if (mTempHitFighters.Count > 1)
            {
                int idx = (int)((BattleMgr.Instance.Battle.RandomValue(false) * (mTempHitFighters.Count * 50) / 50.0f));
                Fighter f = mTempHitFighters[idx];
                mTempHitFighters.Clear();
                mTempHitFighters.Add(f);
            }
        }
        else if(BuffTargetType == Target_Select_Rule.Target_Select_Pos_Prior_Front ||
                BuffTargetType == Target_Select_Rule.Target_Select_Pos_Prior_Back)
        {
            for (int idx = 0; idx < filterFighters.Count; idx++)
            {
                Fighter f = filterFighters[idx];

                if (BuffTargetType == Target_Select_Rule.Target_Select_Pos_Prior_Front)
                {
                    if (f.IsFront || !hasFront)
                        mTempHitFighters.Add(f);
                }
                else if (BuffTargetType == Target_Select_Rule.Target_Select_Pos_Prior_Back)
                {
                    if (f.IsBack || !hasback)
                        mTempHitFighters.Add(f);
                }
            }
        }


        if (mFighter.SelectTarget!=null && mTempHitFighters.Contains(mFighter.SelectTarget))
        {
            return mFighter.SelectTarget;
        }

        Fighter target = null;
        float dist = 100000f;
        for(int idx =0; idx < mTempHitFighters.Count;idx++)
        {
            float d = Vector3.Distance(mTempHitFighters[idx].Position, mFighter.Position);
            if(d < dist)
            {
                d = dist;
                target = mTempHitFighters[idx];
            }
        }
        return target;
    }

    private List<Fighter> temp1 = null;
    private List<Fighter> temp2 = null;
    private List<Fighter> FilterTargets(List<Fighter> fighters)
    {
        if (fighters == null || fighters.Count == 0) return null;

        if (temp1 == null)
            temp1 = new List<Fighter>();
        else
            temp1.Clear();

        if (temp2 == null)
            temp2 = new List<Fighter>();
        else
            temp2.Clear();

        for (int idx = 0; idx < fighters.Count; idx++)
        {
            var f = fighters[idx];
            if (!f.IsAlive) continue;

            if (FilterRule.teamType == FilterTeamType.Team_Type_Self_Team)
            {
                if(f.TeamSide == mFighter.TeamSide)
                {
                    temp1.Add(f);
                }
            }
            else if (FilterRule.teamType == FilterTeamType.Team_Type_Enemy)
            {
                if (f.TeamSide != mFighter.TeamSide)
                {
                    temp1.Add(f);
                }
            }
        }

        for(int idx =0; idx < temp1.Count;idx++)
        {
            var f = temp1[idx];
            
            if(FilterRule.actorType == FilterActorType.Actor_Type_All ||
               (int)FilterRule.actorType == (int)f.Actor.AType || 
               (FilterRule.actorType == FilterActorType.Actor_Type_Hero_Fellow && f.IsPlayer))
            {
                temp2.Add(f);
            }
            else if (FilterRule.actorType == FilterActorType.Actor_Type_Exclude_Pet)
            {
                if (!f.IsPet)
                {
                    temp2.Add(f);
                }
            }
        }

        if(FilterRule.paramType == FilterParamType.Param_Type_None) return temp2;


        if(FilterRule.paramType == FilterParamType.Param_Type_Profession)
        {
            temp1.Clear();
            for(int idx = 0; idx < temp2.Count;idx++)
            {
                var f = temp2[idx];
                if(FilterRule.paramVal == -1 || FilterRule.paramVal == (int)f.ProfType)
                {
                    temp1.Add(f);
                }
            }
        }
        else if(FilterRule.paramType == FilterParamType.Param_Type_Nature)
        {
            temp1.Clear();
            for(int idx =0; idx < temp2.Count;idx++)
            {
                var f = temp2[idx];
                if(FilterRule.paramVal == -1 || FilterRule.paramVal == f.NatureId)
                {
                    temp1.Add(f);
                }
            }
        }
        else if(FilterRule.paramType == FilterParamType.Param_Type_PetId)
        {
            temp1.Clear();
            for (int idx = 0; idx < temp2.Count; idx++)
            {
                var f = temp2[idx];
                if (FilterRule.paramVal == f.Actor.BaseId)
                {
                    temp1.Add(f);
                }
            }
        }

        return temp1;
    }

    private void CheckTargetInfo(List<Fighter> fighters,out bool hasFront,out bool hasBack)
    {
        hasFront = false;
        hasBack = false;
        for (int idx = 0; idx < fighters.Count;idx++)
        {
            Fighter f = fighters[idx];
            if (f == null || !f.IsAlive) continue;

            if (!hasFront)
                hasFront = f.IsFront;

            if (!hasBack)
                hasBack = f.IsBack;
        }
    }

    private bool IsSingleTarget(Target_Select_Rule targetType)
    {
        return targetType == Target_Select_Rule.Target_Select_OnlyOne ||
            targetType == Target_Select_Rule.Target_Select_LeastBlood ||
            targetType == Target_Select_Rule.Target_Select_Most_NegativeBuff ||
            targetType == Target_Select_Rule.Target_Select_Most_LeastLifePercent ||
            targetType == Target_Select_Rule.Target_Select_MostLife;
    }

    private bool OnBeforeFilter(Fighter fighter)
    {
        bool ret = SkillSelectHelper.CheckTargetSelectable(mSkill, mFighter, fighter);
        return ret;
    }

    private int OnAfterCompare(Fighter fighter1, Fighter fighter2, Target_Select_Rule rule)
    {
        return SkillSelectHelper.CompareFighterByRule(mFighter, fighter1, fighter2,rule);
    }

    private void RotateToTarget(Fighter target)
    {
        if (target == null) return;


        mFighter.SelectTarget = target;
        Vector3 pos = target.Position;

        if(target.TeamSide == mFighter.TeamSide)
        {
            int maxRotate = GlobalConfig.Instance.GetConfigIntValue(GlobalConfig.c_maxRotate_InTeam);
            Vector3 dir = pos - mFighter.Position;
            float angle = Vector3.Dot(mFighter.Forward, dir);
            if(angle >= Mathf.Cos(maxRotate))
            {
                mFighter.LookAt(pos);
            }
        }
        else
        {
            mFighter.LookAt(pos);
        }
    }

    private void CheckMark()
    {
        if (bCheckMark) return;

        bCheckMark = true;

        if (mBuffData.markData != null)
        {
            var markData = mBuffData.markData;
            if(markData.markVal > 0)
            {
                if (markData.markTargetType == 1)
                {
                    mFighter.AddMark(markData.markId, markData.markVal);
                }
                else if (markData.markTargetType == 2)
                {
                    for (int idx = 0; idx < mHitFighterInfoList.Count; idx++)
                    {
                        var target = mHitFighterInfoList[idx].Target;
                        target.AddMark(markData.markId, markData.markVal);
                    }
                }
            }
            else
            {
                if(mBuffData.markExtendList != null)
                {
                    int extendBuffId = 0;
                    for(int idx = mBuffData.markExtendList.Count - 1; idx>=0; idx--)
                    {
                        var extendMark = mBuffData.markExtendList[idx];
                        if (markData.markTargetType == 1)
                        {
                            if(mFighter.HasMarkNLayer(markData.markId,extendMark.id))
                            {
                                extendBuffId = extendMark.val;
                                if(markData.markVal < 0)
                                {
                                    mFighter.DecMark(markData.markId, extendMark.id);
                                }
                            }
                            
                        }
                        else if (markData.markTargetType == 2 && mHitFighterInfoList.Count > 0)
                        {
                            for (int i = 0; i < mHitFighterInfoList.Count; i++)
                            {
                                var target = mHitFighterInfoList[i].Target;
                                if(target.HasMarkNLayer(markData.markId, extendMark.id))
                                {
                                    extendBuffId = extendMark.val;
                                    if(markData.markVal < 0)
                                    {
                                        target.DecMark(markData.markId, extendMark.id);
                                    }
                                    break;
                                }
                            }
                        }
                        if(extendBuffId > 0)
                        {
                            break;
                        }
                    }

                    if(extendBuffId > 0)
                    {
                        BattleBuff pBuff = mFighter.CastBuff(null, extendBuffId, skillLv);
                        if (null != pBuff)
                        {
                            Fighter pFighter = GetSourceFighter();  //获取源 设置新BUFF源
                            pBuff.SetSourceFighter(pFighter);
                        }
                        Stop();
                    }
                }
            }
        }
    }
}
