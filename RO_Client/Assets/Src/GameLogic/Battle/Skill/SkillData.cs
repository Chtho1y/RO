using UnityEngine;
using System.Collections.Generic;
using System.Collections;
using System;

public enum SkillRangeType
{
    RangeType_Caster = 0,       //技能范围以攻击者为基准
    RangeType_Target = 1,       //技能范围以目标为基准
    RangeType_Bullet = 2,       //技能范围以子弹为基准
    RangeType_Position = 3,     //技能范围以攻击者+攻击距离偏移为基准
}

public enum SkillFunctionType
{
    FT_Undefined = 0,
    FT_HitFly = 1,          //击飞
    FT_Combo = 2,           //连击
    FT_Hurt = 3,            //杀伤
    FT_Cure = 4,            //治疗
    FT_Strength = 5,        //强化
    FT_Weaken = 6,          //弱化
    FT_Assist = 7,          //辅助
}

public enum SkillActionFrameEventType
{
    FE_NONE     = 0,            //无
    FE_HideNode = 1,            //隐藏血条节点
    FE_PlaySound = 2,           //播放声音
    FE_ScaleTime = 3,           //时间加减速
    FE_PlayEffect = 4,          //播放特效
    FE_PlaySkillAnim = 5,       //播放技能动作
    FE_Summon = 6,              //召唤
    FE_Buff = 7,                //buff
    FE_Move = 8,                //移动
    FE_ShakeCamera = 9,         //相机震动
    FE_EnterSoloMode = 10,      //进入单人模式
    FE_LeaveSoloMode = 11,      //离开单人模式
    FE_ScaleCaster = 12,        //缩放释放者
    FE_ChangeShape = 13,        //释放者变形
    FE_ChangeCamera = 14,       //镜头变换
    FE_PlayPrefab = 15,         //播放动画
    FE_Unbeatable = 16,         //无敌
    FE_UseCameraAction = 17,    //使用相机动作
    FE_SetDownSpeed = 18,       //设置下落初速度
    FE_Change_Face = 19,                //设置表情
    FE_Change_Camera_Weight = 20,       //修改相机权重
    FE_PlayRepeatSound = 21,            //播放重复声音
    FE_PauseFighters = 22,              //暂停其他玩家
    FE_ResumeFighters = 23,             //恢复其他玩家暂停状态
    FE_HideFighters = 24,               //隐藏其他玩家
    FE_ShowFighters = 25,               //显示其他玩家
    FE_DisableFighters = 26,            //停止其他玩家（暂停+变暗）
    FE_EnableFighters = 27,             //其他玩家从停止状态恢复
    FE_HideScene = 28,                  //隐藏场景
    FE_ShowScene = 29,                  //显示场景
    FE_DisableScene = 30,               //场景变暗
    FE_EnableScene = 31,                //场景从变暗恢复
    FE_StopCameraAction = 32,           //停止相机动作
    FE_PlayUnscaleTimeEffect = 33,      //播放不受时间影响的特效
    FE_Weapon_Rotate_To_Target = 34,    //武器节点朝向目标
    FE_Weapon_Restore_Rotation = 35,    //恢复武器节点旋转
    FE_PlayEffectEx = 36,               //播放特效，带播放选项
    FE_Disable_Attack_Shake = 37,       //关闭攻击抖动
    FE_Focus_Fighter = 38,              //镜头聚焦玩家
    FE_LookAtTarget = 39,               //朝向指向目标
    FE_Skill_End = 40,                  //技能结束
    FE_Predict_Targets = 41,            //划定目标为下一次攻击的目标玩家列表。此后的攻击目标直接选择列表内玩家
    FE_Fix_HurtWordPosition = 42,       //锁定伤害数字位置
    FE_Unfix_HurtWordPosition = 43,	    //取消伤害数字位置的锁定
    FE_Skill_Sing = 44,                 //技能吟唱
    FE_Repeat_Caster = 45,              //持续施法
    FE_Hit = 46,                        //打击点
    FE_Bullet = 47,                     //发射子弹
    FE_Delay_Hurt= 48,                     //延迟伤害
    FE_SELECT_TARGET = 49,                  //切换目标
    FE_SWITCH_SKILL = 50,                   //切换技能
    FE_Clone = 51,                          //召唤分身
    FE_ChangeSkyboxMat = 52,                //替换天空盒材质
    FE_BattleUI_Visible = 53,               //战斗UI的可见配置
}

//public enum SkillTriggerBuffType
//{
//    None = 0,
//    Skill_Crit_Trigger = 1,                       //暴击触发buff
//    Skill_Interrtupted_Trigger = 2,               //技能被打断触发buff
//    Skill_Break_Trigger = 3,                      //技能打断目标触发
//    Skill_Miss_Trigger = 4,                       //技能未命中触发
//    Kill_Target_Trigger = 5,                      //技能杀死目标
//    Disperse_Target_Buff_Trigger = 6,             //技能成功驱散目标buff
//    Purify_Target_Debuff_Trigger = 7,             //技能成功净化目标debuff触发
//}

public static class SkillType
{
    public const int NormalAttack = 0;       //普通攻击
    public const int Attack1 = 1;
    public const int Attack2 = 2;
    public const int Attack3 = 3;
    public const int Attack4 = 4;

    public const int Alternative = 5;
    public const int Passive = 6;
    public const int TypeCount = 7;
}

public class SkillActionAttackInfo
{
    public BaseSkill skill;
    public int bulletID;
    public int buffID;
    public float damagePercent;
    public SkillRangeType rangeType;
    public float rangeX;
    public float rangeY;
    public float rangeZ;
    public float rangeOffsetX;
    public float rangeOffsetY;
    public float targetMoveTime;
    public int hitEffect;
    public int effect;
    public float hitFrame;
    public string sound;
    //public string hitSound;
    public int multiHitCount;
    public float multiHitIntervalTime;
    public int delayHurtCount;
    public int delayHurtIntervalFrame;
    public int delayHurtDelayFrame;
    public bool reselectTarget;
    public bool normalizeRangeDir;
    public string fromSkills;
    public string toSkills;

    public int hitMoveType;
    public float hitMoveInitSpeed;
    public float hitMoveAcceleration;
    public float hitMoveDist;
    public int hitMoveOrientation;

    public int rate;


    public float stiffTime;

    public void Dispose()
    {
        skill = null;
    }

    public void LoadFromFrameEvent(SkillActionFrameEvent frameEv)
    {
        bulletID = (int)frameEv.GetN(Constants.s_skillaction_frame_key_bulletid);
        buffID = (int)frameEv.GetN(Constants.s_skillaction_frame_key_buffid);
        damagePercent = (int)frameEv.GetN(Constants.s_skillaction_frame_key_damagePercent) / 100f;
        rangeType = (SkillRangeType)frameEv.GetN(Constants.s_skillaction_frame_key_rangeType);
        rangeX = frameEv.GetN(Constants.s_skillaction_frame_key_rangeX) / 100f;
        rangeY = frameEv.GetN(Constants.s_skillaction_frame_key_rangeY) / 100f;
        rangeZ = frameEv.GetN(Constants.s_skillaction_frame_key_rangeZ) / 100f;
        if (rangeZ == 0f)
            rangeZ = 0.5f;
        rangeOffsetX = frameEv.GetN(Constants.s_skillaction_frame_key_rangeOffsetX) / 100f;
        rangeOffsetY = frameEv.GetN(Constants.s_skillaction_frame_key_rangeOffsetY) / 100f;
        float flyLength = frameEv.GetN(Constants.s_skillaction_frame_key_flyLen) / 100f;
       
        hitEffect = (int)frameEv.GetN(Constants.s_skillaction_frame_key_hiteffect);
        hitFrame = ((float)frameEv.GetN(Constants.s_skillaction_frame_key_hitframe)/1000f);
        //hitSound = frameEv.GetStr(Constants.s_skillaction_frame_key_hitsound);
        effect = (int)frameEv.GetN(Constants.s_skillaction_frame_key_effect);
        sound = frameEv.GetStr(Constants.s_skillaction_frame_key_sound);
        multiHitCount = (int)frameEv.GetN(Constants.s_skillaction_frame_key_multihit);
        multiHitIntervalTime = frameEv.GetN(Constants.s_skillaction_frame_key_multihitinterval) / 1000f;
        reselectTarget = frameEv.GetN(Constants.s_skillaction_frame_key_reselectTarget) == 1;
        normalizeRangeDir = frameEv.GetN(Constants.s_skillaction_frame_key_normalizerange) == 1;
        delayHurtCount = frameEv.GetN(Constants.s_skillaction_frame_key_delay_hurt_count);
        delayHurtIntervalFrame = frameEv.GetN(Constants.s_skillaction_frame_key_delay_hurt_interval);
        delayHurtDelayFrame = frameEv.GetN(Constants.s_skillaction_frame_key_delay_hurt_delay_frame);
        fromSkills = frameEv.GetStr(Constants.s_skillaction_frame_key_replace_skill_from);
        toSkills = frameEv.GetStr(Constants.s_skillaction_frame_key_replace_skill_to);

        hitMoveType = frameEv.GetN(Constants.s_skillaction_frame_key_move_type);
        hitMoveOrientation = frameEv.GetN(Constants.s_skillaction_frame_key_move_orientation);
        hitMoveInitSpeed = frameEv.GetN(Constants.s_skillaction_frame_key_move_speed) * 0.01f;
        hitMoveAcceleration = frameEv.GetN(Constants.s_skillaction_frame_key_move_acceleration) * 0.01f;
        hitMoveDist = frameEv.GetN(Constants.s_skillaction_frame_key_move_dist) * 0.01f;

        rate = frameEv.GetN(Constants.s_skillaction_frame_key_rate);

        if (rangeX <= 0f)
            rangeX = 3f;

        if (rangeY <= 0f)
            rangeY = 1;

        if (multiHitCount == 0)
            multiHitCount = 1;
    }
}

public class SkillActionMoveInfo
{
    public float speed;
    public float acceleration;
    public float selfOffsetX;
    public float selfOffsetY;
    public float targetOffsetX;
    public float targetOffsetY;
}

public class SkillActionCameraInfo
{
    public float time;
    public int looktype;
    public float lookoffsetx;
    public float lookoffsety;
    public float offsetx;
    public float offsety;
    public float distance;
    public float fov;
    public float followSpeedRate;
    public int moveMode;
}

public class FrameEventParam
{
    public string name;
    public int nValue;
    public float fValue;
    public string sValue;
}

public class SkillActionFrameEvent : IComparable
{
    public string name;
    public int skillid;

    public Fix64 initStartTime;
    public Fix64 initEndTime;
    public Fix64 startTime;
    public Fix64 endTime;

    public int initStartFrame;
    public int initEndFrame;
    public int startFrame;
    public int endFrame;

    public SkillActionFrameEventType eventType;
    public FrameEventParam[] paramerters;
    public SkillActionAttackInfo attackInfo = null;
    public bool bAffectBySing = false;      //是否受吟唱时长的影响

    public SkillActionFrameEvent(int skillid)
    {
        this.skillid = skillid;
    }

    private bool mbDisposed = false;
    public void Dispose()
    {
        if (mbDisposed)
            return;

        if (attackInfo != null)
        {
            attackInfo.Dispose();
            attackInfo = null;
        }

        paramerters = null;

        mbDisposed = true;
    }

    public string ToString()
    {
        string strParams = "";

        if (paramerters == null || paramerters.Length == 0)
            strParams = "{}";
        else
        {
            bool isArray = false;
            if (string.IsNullOrEmpty(paramerters[0].name) || paramerters[0].name == paramerters[0].sValue)
                isArray = true;
            foreach (FrameEventParam param in paramerters)
            {
                string strParam = "";
                if (param.nValue != 0)
                {
                    if (!isArray)
                        strParam = "\"" + param.name + "\":";
                    strParam += param.nValue.ToString();
                }
                else if (!string.IsNullOrEmpty(param.sValue))
                {
                    if (!isArray)
                        strParam = "\"" + param.name + "\":";
                    strParam += "\"" + param.sValue + "\"";
                }

                if (strParam.Length > 0)
                {
                    if (strParams.Length > 0)
                        strParams += ("," + strParam);
                    else
                        strParams = strParam;
                }
            }
            strParams = "{" + strParams + "}";
        }

        return initStartFrame.ToString() + "," + ((int)eventType).ToString() + " : " + strParams;
    }

    public int ParamCount
    {
        get { return paramerters.Length; }
    }

    void AddParam(FrameEventParam pa)
    {
        if (paramerters == null || paramerters.Length == 0)
        {
            paramerters = new FrameEventParam[1];
        }
        else
        {
            FrameEventParam[] oldParams = paramerters;
            paramerters = new FrameEventParam[oldParams.Length + 1];
            oldParams.CopyTo(paramerters, 0);
        }
        paramerters[paramerters.Length - 1] = pa;
    }

    public int GetN(int idx = 0)
    {
        if (paramerters == null || idx >= paramerters.Length)
            return 0;

        return paramerters[idx].nValue;
    }

    public int GetN(string name)
    {
        if (string.IsNullOrEmpty(name))
            return GetN();

        foreach (FrameEventParam param in paramerters)
        {
            if (param.name == name)
                return param.nValue;
        }

        return 0;
    }

    public void SetN(string name, int value)
    {
        if (string.IsNullOrEmpty(name))
            return;

        if (paramerters != null)
        {
            foreach (FrameEventParam param in paramerters)
            {
                if (param.name == name)
                {
                    param.nValue = value;
                    return;
                }
            }
        }

        FrameEventParam pa = new FrameEventParam();
        pa.name = name;
        pa.nValue = value;
        AddParam(pa);
    }

    public string GetStr(int idx = 0)
    {
        if (paramerters == null || idx >= paramerters.Length)
            return "";

        return paramerters[idx].sValue;
    }

    public string GetStr(string name)
    {
        if (string.IsNullOrEmpty(name))
            return GetStr();

        foreach (FrameEventParam param in paramerters)
        {
            if (param.name == name)
                return param.sValue;
        }

        return "";
    }

    public void SetStr(string name, string value)
    {
        if (string.IsNullOrEmpty(name))
            return;

        if (paramerters != null)
        {
            foreach (FrameEventParam param in paramerters)
            {
                if (param.name == name)
                {
                    param.sValue = value;
                    return;
                }
            }
        }

        FrameEventParam pa = new FrameEventParam();
        pa.name = name;
        pa.sValue = value;
        AddParam(pa);
    }

    public SkillActionAttackInfo CreateAttackInfo()
    {
//#if UNITY_EDITOR
//        attackInfo = new SkillActionAttackInfo();
//        attackInfo.LoadFromFrameEvent(this);
//#else
        if (attackInfo == null)
        {
            attackInfo = new SkillActionAttackInfo();
            attackInfo.LoadFromFrameEvent(this);
        }
//#endif
        return attackInfo;
    }

    public int CompareTo(object obj)
    {
        try
        {
            SkillActionFrameEvent rhs = (SkillActionFrameEvent)obj;
            if (initStartFrame > rhs.initStartFrame)
                return 1;
            else if (initStartFrame < rhs.initStartFrame)
                return -1;
            else
                return 0;

        }
        catch (System.Exception e)
        {
            DebugHelper.LogError(e);
            return 0;
        }
    }
}

public struct SkillTriggerBuffInfo
{
    public BuffTriggerType type;
    public int buffId;
    public float ratio;

    public SkillTriggerBuffInfo(BuffTriggerType type,int buffId,float  ratio)
    {
        this.type = type;
        this.buffId = buffId;
        this.ratio = ratio;
    }
}

public enum BuffPointType
{
    None = 0,            //无
    AddPoint = 1,       //添加点数
    OwnPoint = 2,       //拥有点数触发
    DetectPoint = 3,    //消耗点数触发
}

public class SkillData
{
    public int skillId;
    public string skillName;
    public string skillIcon;
    public int skillLv;         //技能等级
    public SkillTriggerType skillTriggerType;   //技能触发类型
    public int spCost;                  //消耗能量
    public float fixedSingTime;             //固定吟唱时长
    public float variableSingTime;          //可变吟唱时长
    public float preCastingTime;            //施法前摇时长
    public float castingTime;               //施法时长
    public float postCastingTime;          //施法后摇时长
    public float cd;                        //技能cd
    public int[] buffIds;                   //buffid
    public Dictionary<int,float> skillDistDic = new Dictionary<int, float>();             //技能施法距离
    public bool hide;                       //是否隐藏
    public List<SkillTriggerBuffInfo> triggerBuffs = null;
    public List<int> extendBuffIds = null; 

    public int pointBuffId;
    public BuffPointType buffPointType = BuffPointType.None;
    public int[] pointBuffParams = null;

    public bool valid = false;

    private bool mbDisposed = false;

    public SkillData(int skillId,int level)
    {
        try
        {
            Dictionary<string, string> dic = ConfigMgr.Instance.getLine(skillId, Config.SkillCfgName);
            if (dic != null)
            {
                this.skillId = skillId;
                this.skillLv = level;

                this.skillName = I18N.T(dic["Name"]);
                this.skillIcon = dic["Icon"];

                int temp = 0; 
                if(int.TryParse(dic["SkillType"],out temp))
                {
                    skillTriggerType = (SkillTriggerType)temp;
                }

                for (int idx =0; idx <= (int)ProfessionType.Pro_Type_Priest;idx++)
                {
                    string skillDistKey = "PerceptionRange" + idx;
                    if (dic.ContainsKey(skillDistKey))
                    {
                        float tempDist;
                        float.TryParse(dic[skillDistKey], out tempDist);
                        skillDistDic.Add(idx, tempDist);
                    }
                }
          
                if(dic.ContainsKey("Hide"))
                {
                    int.TryParse(dic["Hide"], out temp);
                    hide = temp > 0;
                }

                if (dic.ContainsKey("BuffPoint"))
                {
                    List<int> tempInts = StringUtil.convert2IntList(dic["BuffPoint"], ':');
                    if (tempInts != null)
                    {
                        if (tempInts.Count > 1)
                        {
                            pointBuffId = tempInts[0];
                            buffPointType = (BuffPointType)tempInts[1];

                            pointBuffParams = new int[tempInts.Count - 2];

                            for (int pIdx = 2; pIdx < tempInts.Count; pIdx++)
                            {
                                pointBuffParams[pIdx - 2] = tempInts[pIdx];
                            }
                        }
                    }
                }

                if(dic.ContainsKey("ExtendBuffs"))
                {
                    extendBuffIds = StringUtil.convert2IntList(dic["ExtendBuffs"],';');
                }

                ReadSkillLevelCfg(skillId, level);
                valid = true;
            }
            else
            {
                DebugHelper.LogError("加载技能{0} lv={1} 配置不存在", skillId,level);
            }
        }
        catch (System.Exception e)
        {
            DebugHelper.LogError("加载技能{0}数据错误：{1} -- {2}", skillId, e.StackTrace, e.Message);
        }
    }

    void ReadSkillLevelCfg(int skillId, int level)
    {
        int id = skillId * 1000 + level;

        Dictionary<string, string> dic = ConfigMgr.Instance.getLine(id, Config.SkillLvCfgName);
        if(dic != null)
        {
            if (dic.ContainsKey("Cost"))
                int.TryParse(dic["Cost"], out this.spCost);
            else
                this.spCost = 0;

            if (dic.ContainsKey("FixedSingTime"))
            {
                float.TryParse(dic["FixedSingTime"], out this.fixedSingTime);
            }

            if (dic.ContainsKey("ChangeSingTime"))
            {
                float.TryParse(dic["ChangeSingTime"], out this.variableSingTime);
            }

            if (dic.ContainsKey("PreCastingTime"))
            {
                float.TryParse(dic["PreCastingTime"], out this.preCastingTime);
            }

            if (dic.ContainsKey("CastingTime"))
            {
                float.TryParse(dic["CastingTime"], out this.castingTime);
            }

            if (dic.ContainsKey("AfterCastingTime"))
            {
                float.TryParse(dic["AfterCastingTime"], out this.postCastingTime);
            }

            if (dic.ContainsKey("CD"))
            {
                float.TryParse(dic["CD"], out this.cd);
            }

            if (dic.ContainsKey("Buffs"))
            {
                buffIds = StringUtil.split2Int(dic["Buffs"], ';');
            }

            if (dic.ContainsKey("TriggerBuffs"))
            {
                string[] tempStrList = StringUtil.split(dic["TriggerBuffs"], ';');
                if (tempStrList != null && tempStrList.Length > 0)
                {
                    triggerBuffs = new List<SkillTriggerBuffInfo>();
                    for (int idx = 0; idx < tempStrList.Length; idx++)
                    {
                        int[] vals = StringUtil.split2Int(tempStrList[idx], ':');
                        if (vals.Length >= 3)
                        {
                            SkillTriggerBuffInfo buffInfo = new SkillTriggerBuffInfo((BuffTriggerType)vals[0], vals[1], vals[2] * 0.0001f);
                            triggerBuffs.Add(buffInfo);
                        }
                    }
                }
            }
        }
        else
        {
            DebugHelper.LogError("加载技能等级配置{0} lv={1} 配置不存在", skillId, level);
        }
    }

    public void Dispose()
    {
        if (mbDisposed)
            return;

        mbDisposed = true;
    }
}
