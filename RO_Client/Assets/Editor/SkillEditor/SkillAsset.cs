using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using OfficeOpenXml;
using Mono.Xml;
using System.Security;

public class EffectAsset
{
    public int id;
    public string desc;
    public string effect;
    public string link;
    public int followType;
    public int targetType;
    public Vector3 rot;
    public float lifeTime;

    public static EffectAsset CreateEffectAsset(ExcelWorksheet sheet, int row)
    {
        EffectAsset effect = new EffectAsset();
        int col = 1;

        effect.id = sheet.GetValue<int>(row, col++);
        effect.desc = sheet.GetValue<string>(row, col++);
        effect.effect = sheet.GetValue<string>(row, col++);
        effect.link = sheet.GetValue<string>(row, col++);
        effect.followType = sheet.GetValue<int>(row, col++);
        effect.targetType = sheet.GetValue<int>(row, col++);
        effect.rot = StringUtil.convertVector3(sheet.GetValue<string>(row, col++));
        effect.lifeTime = sheet.GetValue<float>(row, col++);

        return effect;
    }

    public void SaveAssetToExcel(ref ExcelWorksheet sheet, int  row)
    {
        if (sheet == null) return;

        int col = 1;
        sheet.SetValue(row, col++, this.id);
        sheet.SetValue(row, col++, this.desc);
        sheet.SetValue(row, col++, this.effect);
        sheet.SetValue(row, col++, this.link);
        sheet.SetValue(row, col++, this.followType);
        sheet.SetValue(row, col++, this.targetType);
        sheet.SetValue(row, col++, StringUtil.ConvertVector2Str(this.rot));
        sheet.SetValue(row, col++, this.lifeTime);
    }
}

public class FunctionDataAsset
{
    public int id;
    public string name;
    public BattleBuffType buffType;
    public Buff_Function_Type functionType;
    public int group;       
    public bool canHurtStop;            //是否可以伤害打断
    public bool forbidMove;             //是否影响动作
    public bool forbidNormalAttack;     //禁止普攻
    public bool forbidSkill;            //禁止技能释放
    public bool canIgnoreDodge;         //是否可以闪避
    public string desc;

    public float intervalTime;      //间隔时长
    public int fromAttr;            //来源属性
    public string icon;                //图标
    public int effectId;            //特效id
    public string word;             //文字

    public int iconIdx = -1;
    public int wordIdx = -1;
    public int effectIdx = -1;

    public static FunctionDataAsset CreateFunAsset(ExcelWorksheet sheet, int  row)
    {
        FunctionDataAsset funAsset = new FunctionDataAsset();
        int col = 1;

        funAsset.id = sheet.GetValue<int>(row, col++);
        funAsset.name = sheet.GetValue<string>(row, col++);
        funAsset.functionType = (Buff_Function_Type)(sheet.GetValue<int>(row, col++));
        funAsset.group = sheet.GetValue<int>(row, col++);
        funAsset.buffType = (BattleBuffType)(sheet.GetValue<int>(row, col++));
        funAsset.canHurtStop = sheet.GetValue<int>(row, col++) > 0 ? true : false;
        funAsset.forbidMove = sheet.GetValue<int>(row, col++) > 0 ? true : false;
        funAsset.forbidNormalAttack = sheet.GetValue<int>(row, col++) > 0 ? true : false;
        funAsset.forbidSkill = sheet.GetValue<int>(row, col++) > 0 ? true : false;
        funAsset.canIgnoreDodge = sheet.GetValue<int>(row, col++) > 0 ? true : false;
        funAsset.desc = sheet.GetValue<string>(row, col++);
        funAsset.icon = sheet.GetValue<string>(row, col++);
        string temp = sheet.GetValue<string>(row, col++);
        int.TryParse(temp, out funAsset.effectId);
        funAsset.word = sheet.GetValue<string>(row, col++);

        return funAsset;
    }

    public void SaveAssetToExcel(ref ExcelWorksheet sheet, int row)
    {
        if (sheet == null) return;

        int col = 1;
        sheet.SetValue(row, col++, this.id);
        sheet.SetValue(row, col++, this.name);
        sheet.SetValue(row, col++, (int)this.functionType);
        sheet.SetValue(row, col++, this.group);
        sheet.SetValue(row, col++, (int)this.buffType);
        sheet.SetValue(row, col++, this.canHurtStop ? 1 : 0);
        sheet.SetValue(row, col++, this.forbidMove?1:0);
        sheet.SetValue(row, col++, this.forbidNormalAttack?1:0);
        sheet.SetValue(row, col++, this.forbidSkill ? 1 : 0);
        sheet.SetValue(row, col++, this.canIgnoreDodge ? 1 : 0);
        sheet.SetValue(row, col++, this.desc);
        sheet.SetValue(row, col++, this.icon);
        sheet.SetValue(row, col++, this.effectId);
        sheet.SetValue(row, col++, this.word);
    }


    public void Copy(FunctionDataAsset from)
    {
        if (from == null) return;

        this.id = from.id;
        this.name = from.name;
        this.buffType = from.buffType;
        this.functionType = from.functionType;
        this.group = from.group;
        this.canHurtStop = from.canHurtStop;
        this.forbidMove = from.forbidMove;
        this.forbidNormalAttack = from.forbidNormalAttack;
        this.forbidSkill = from.forbidSkill;
        this.canIgnoreDodge = from.canIgnoreDodge;
        this.desc = from.desc;
        this.intervalTime = from.intervalTime;
        this.fromAttr = from.fromAttr;
        this.icon = from.icon;
        this.effectId = from.effectId;
        this.word = from.word;
        this.iconIdx = from.iconIdx;
        this.wordIdx = from.wordIdx;
        this.effectIdx = from.effectIdx;
    }
}

public class FrameEventParamEditor
{
    public string name;
    public string val;
    public string valType;
    public int valTypeIdx = -1;

    public int valIdx = -1;

    public SecurityElement SaveCfgToXml()
    {
        SecurityElement paramNode = new SecurityElement("param");
        paramNode.AddAttribute("name", this.name);
        paramNode.AddAttribute("value", this.val);
        paramNode.AddAttribute("valueType", this.valType);
        return paramNode;
    }
}

public class ActionEventParamEditor
{
    public int startFrame;
    public int endFrame;
    public int eventType;
    public string desc;
    public bool bAffectBySing;
    public List<FrameEventParamEditor> frameParams;

    public ActionEventParamEditor()
    {

    }

    public ActionEventParamEditor(ActionEventParamEditor src)
    {
        if(src!=null)
        {
            this.startFrame = src.startFrame;
            this.endFrame = src.endFrame;
            this.eventType = src.eventType;
            this.desc = src.desc;
            this.bAffectBySing = src.bAffectBySing;
            if (this.frameParams == null)
                this.frameParams = new List<FrameEventParamEditor>();
            this.frameParams.Clear();
            if (src.frameParams != null)
                this.frameParams.AddRange(src.frameParams);
        }
    }

    public SecurityElement SaveCfgToXml()
    {
        SecurityElement eventNode = new SecurityElement("event");
        eventNode.AddAttribute("startFrame", this.startFrame.ToString());
        eventNode.AddAttribute("endFrame", this.endFrame.ToString());
        eventNode.AddAttribute("type", this.eventType.ToString());
        eventNode.AddAttribute("affectBySing", this.bAffectBySing.ToString());
        eventNode.AddAttribute("desc", this.desc);
        if(this.frameParams != null)
        {
            for(int idx =0; idx < this.frameParams.Count;idx++)
            {
                FrameEventParamEditor paramData = this.frameParams[idx];
                if (string.IsNullOrEmpty(paramData.val) || string.IsNullOrEmpty(paramData.valType) || string.IsNullOrEmpty(paramData.name)) continue;

                SecurityElement paramNode = paramData.SaveCfgToXml();
                eventNode.AddChild(paramNode);
            }
        }
        return eventNode;
    }
}

public class ActionEventDataEditor
{
    private int mId;
    public int Id
    {
        get { return mId; }
    }

    public string Name
    {
        get;set;
    }

    private int mTotalFrame = 0;
    public int TotalFrame
    {
        get { return mTotalFrame; }
        set
        {
            mTotalFrame = value;
        }
    }

    /// <summary>
    /// 性别
    /// </summary>
    private int mGender = 2;
    public int Gender
    {
        get { return mGender; }
        set { mGender = value; }
    }

    public List<ActionEventParamEditor> ActionEventList
    {
        get; private set;
    }

    public ActionEventDataEditor(int id, int totalFrame,string name,int gender)
    {
        this.mId = id;
        this.mTotalFrame = totalFrame;
        this.Name = name;
        this.mGender = gender;
    }

    public void AddEvent(ActionEventParamEditor eve)
    {
        if (ActionEventList == null)
        {
            ActionEventList = new List<ActionEventParamEditor>();
        }

        ActionEventList.Add(eve);
    }
}

public class FunctionValData
{
    public int funId;
    public float val;           //初始值
    public float incVal;        //随等级变化值
    public float duration;      //初始时长
    public float incDuration;   //随等级变化时长

    public int fromAttr;        //依赖那个属性进行计算
    public float intervalTime;  //间隔时间

    public bool extendFold;

    public FunctionValData(int id, float val, float incVal, float dur, float incDur, int fromAttr, float intervalTime)
    {
        this.funId = id;
        this.val = val;
        this.incVal = incVal;
        this.duration = dur;
        this.incDuration = incDur;
        this.fromAttr = fromAttr;
        this.intervalTime = intervalTime;
        this.extendFold = true;
    }

    public FunctionValData(FunctionValData src)
    {
        if(src != null)
        {
            this.funId = src.funId;
            this.val = src.val;
            this.incVal = src.incVal;
            this.duration = src.duration;
            this.incDuration = src.duration;
            this.fromAttr = src.fromAttr;
            this.intervalTime = src.intervalTime;
        }
    }

    public override string ToString()
    {
        return funId + ":" + val + (incVal > 0 ? ("_" + incVal) : "") + ":" + duration + (incDuration > 0 ? ("_" + incDuration) : "") + ":" + fromAttr + ":" + intervalTime;
    }

    public void Apply(FunctionValData src)
    {
        if (src != null)
        {
            this.funId = src.funId;
            this.val = src.val;
            this.incVal = src.incVal;
            this.duration = src.duration;
            this.incDuration = src.duration;
            this.fromAttr = src.fromAttr;
            this.intervalTime = src.intervalTime;
        }
    }
}

public class BuffDataAsset
{
    public int id;
    public string desc;
    public string extendFuns;
    public int damageType;      //伤害类型
    public int targetType;      //目标类型
    public int hitType;         //命中类型
    public int effectiveness;   //生效率
    public bool ignoreMultiHurt; //是否忽略多段伤害
    public bool removeFunWhenStop;      //buff移除时是否关闭对应的fun
    public List<FunctionValData> funList;
    public ActionEventDataEditor actionEventData;
    public ActionEventDataEditor femaleActionEventData;

    public bool canPerfectDodge = false;
    public bool canDodge = false;
    public bool canResist = false;
    public bool canCrit = false;


    #region 工具中使用的东西
    public bool extendBaseFold = true;
    public bool extendFunFold = true;
    public bool extendFrameEventFold = true;
    public bool extendFemaleFrameEventFold = false;
    public bool extendModelPrefab = true;
    public Vector2 scrollPos = Vector2.zero;
    public RuntimeAnimatorController modelAnimator = null;
    public UnityEditor.Animations.AnimatorStateMachine stateMachine = null;
    public string[] animClipNames = null;
    public int animClipIdx = -1;
    #endregion

    public static BuffDataAsset CreateBuffAsset(ExcelWorksheet sheet,int row)
    {
        BuffDataAsset buffAsset = new BuffDataAsset();
        int col = 1;
        buffAsset.id = sheet.GetValue<int>(row, col++);
        buffAsset.desc = sheet.GetValue<string>(row, col++);

        string funStr = sheet.GetValue<string>(row, col++);
        if(!string.IsNullOrEmpty(funStr))
        {
            string[] funStrList = funStr.Split(';');
            buffAsset.funList = new List<FunctionValData>(funStrList.Length);
            for (int idx = 0; idx < funStrList.Length; idx++)
            {
                string[] funTemp = funStrList[idx].Split(':');
                if (funTemp.Length < 2) continue;

                int funId = 0;
                float funVal = 0;
                float funIncVal = 0;

                float funDuration = 0;
                float funIncDuration = 0;

                int fromAttr = 0;
                float intervalTime = 0;

                if (funTemp.Length > 1)
                {
                    float[] funValList = StringUtil.split2Float(funTemp[1], '_');
                    if (funValList.Length > 0)
                        funVal = funValList[0];

                    if (funValList.Length > 1)
                        funIncVal = funValList[1];
                }

                if (funTemp.Length > 2)
                {
                    float[] funDurList = StringUtil.split2Float(funTemp[2], '_');
                    if (funDurList.Length > 0)
                        funDuration = funDurList[0];

                    if (funDurList.Length > 1)
                        funIncDuration = funDurList[1];
                }

                if (funTemp.Length > 3)
                {
                    int.TryParse(funTemp[3], out fromAttr);
                }

                if (funTemp.Length > 4)
                {
                    float.TryParse(funTemp[4], out intervalTime);
                }


                if (int.TryParse(funTemp[0], out funId))
                {
                    FunctionValData fun = new FunctionValData(funId, funVal, funIncVal, funDuration, funIncDuration, fromAttr, intervalTime);
                    buffAsset.funList.Add(fun);
                }
            }
        }

        buffAsset.extendFuns = sheet.GetValue<string>(row, col++);
        buffAsset.damageType = sheet.GetValue<int>(row, col++);
        buffAsset.targetType = sheet.GetValue<int>(row, col++);
        buffAsset.hitType = sheet.GetValue<int>(row, col++);
        buffAsset.effectiveness = sheet.GetValue<int>(row, col++);
        buffAsset.ignoreMultiHurt = sheet.GetValue<int>(row, col++) > 0 ? true : false;
        buffAsset.removeFunWhenStop = sheet.GetValue<int>(row, col++) > 0 ? true : false;


        buffAsset.canPerfectDodge = (buffAsset.hitType & (int)BuffHitType.Perfect_Dodge) == (int)BuffHitType.Perfect_Dodge;
        buffAsset.canDodge = (buffAsset.hitType & (int)BuffHitType.Dodge) == (int)BuffHitType.Dodge;
        buffAsset.canResist = (buffAsset.hitType & (int)BuffHitType.Resist) == (int)BuffHitType.Resist;
        buffAsset.canCrit = (buffAsset.hitType & (int)BuffHitType.Critical) == (int)BuffHitType.Critical;

        return buffAsset;
    }

    public BuffDataAsset()
    {

    }

    public BuffDataAsset(int buffId)
    {
        this.id = buffId;
    }

    public void Copy(BuffDataAsset src)
    {
        if (src == null) return;

        this.id = src.id;
        this.desc = src.desc;
        this.extendFuns = src.extendFuns;
        this.damageType = src.damageType;
        this.targetType = src.targetType;
        this.hitType = src.hitType;
        this.effectiveness = src.effectiveness;
        this.ignoreMultiHurt = src.ignoreMultiHurt;
        this.removeFunWhenStop = src.removeFunWhenStop;
        this.canPerfectDodge = src.canPerfectDodge;
        this.canDodge = src.canDodge;
        this.canResist = src.canResist;
        this.canCrit = src.canCrit;
        this.actionEventData = src.actionEventData;
        this.femaleActionEventData = src.femaleActionEventData;

        if (this.funList == null)
            this.funList = new List<FunctionValData>();
        this.funList.Clear();

        if(src.funList != null && src.funList.Count > 0)
        {
            for(int idx = 0; idx < src.funList.Count;idx++)
            {
                this.funList.Add(new FunctionValData(src.funList[idx]));
            }
        }
    }

    public void Apply(BuffDataAsset src)
    {
        if (src == null) return;

        this.id = src.id;
        this.desc = src.desc;
        this.extendFuns = src.extendFuns;
        this.damageType = src.damageType;
        this.targetType = src.targetType;
        this.hitType = src.hitType;
        this.effectiveness = src.effectiveness;
        this.ignoreMultiHurt = src.ignoreMultiHurt;
        this.removeFunWhenStop = src.removeFunWhenStop;

        this.canPerfectDodge = src.canPerfectDodge;
        this.canDodge = src.canDodge;
        this.canResist = src.canResist;
        this.canCrit = src.canCrit;
        this.actionEventData = src.actionEventData;
        this.femaleActionEventData = src.femaleActionEventData;

        if (src.funList != null && src.funList.Count > 0)
        {
            for (int idx = 0; idx < src.funList.Count; idx++)
            {
                FunctionValData funVal = GetFunData(src.funList[idx].funId);
                if(funVal == null)
                {
                    funVal = new FunctionValData(src.funList[idx]);
                    this.funList.Add(funVal);
                }
                else
                {
                    funVal.Apply(src.funList[idx]);
                }
            }
        }

        for(int idx = this.funList.Count-1; idx >= 0 ;idx--)
        {
            FunctionValData val = src.GetFunData(this.funList[idx].funId);
            if(val == null)
            {
                this.funList.RemoveAt(idx);
            }
        }
    }

    public FunctionValData GetFunData(int id)
    {
        if (funList == null) return null;

        for(int idx =0; idx < funList.Count;idx++)
        {
            if (funList[idx].funId == id) return funList[idx];
        }
        return null;
    }

    public void SaveAssetToExcel(ref ExcelWorksheet sheet, int row)
    {
        if (sheet == null) return;

        string funStr = "";
        if(funList != null)
        {
            for(int idx =0; idx < funList.Count;idx++)
            {
                FunctionValData val = funList[idx];
                if(idx == 0)
                {
                    funStr = val.ToString();
                }
                else
                {
                    funStr = funStr + ";" + val.ToString();
                }
            }
        }

        int col = 1;
        this.hitType = 0;
        if (this.canPerfectDodge)
            this.hitType |= (int)BuffHitType.Perfect_Dodge;

        if (this.canDodge)
            this.hitType |= (int)BuffHitType.Dodge;

        if (this.canResist)
            this.hitType |= (int)BuffHitType.Resist;

        if (this.canCrit)
            this.hitType |= (int)BuffHitType.Critical;

        sheet.SetValue(row, col++, this.id);
        sheet.SetValue(row, col++, this.desc);
        sheet.SetValue(row, col++, funStr);
        sheet.SetValue(row, col++, this.extendFuns);
        sheet.SetValue(row, col++, (int)this.damageType);
        sheet.SetValue(row, col++, (int)this.targetType);
        sheet.SetValue(row, col++, this.hitType);
        sheet.SetValue(row, col++, this.effectiveness);
        sheet.SetValue(row, col++, this.ignoreMultiHurt ? 1 : 0);
        sheet.SetValue(row, col++, this.removeFunWhenStop ? 1 : 0);
    }

    public SecurityElement SaveFrameEventToXml()
    {
        if (actionEventData == null) return null;

        SecurityElement buffNode = new SecurityElement("buff");
        buffNode.AddAttribute("id", this.actionEventData.Id.ToString());
        buffNode.AddAttribute("name", this.actionEventData.Name);
        buffNode.AddAttribute("endFrame", this.actionEventData.TotalFrame.ToString());
        buffNode.AddAttribute("gender", this.actionEventData.Gender.ToString());

        if(this.actionEventData.ActionEventList!=null)
        {
            for(int idx =0; idx < this.actionEventData.ActionEventList.Count;idx++)
            {
                ActionEventParamEditor eventData = this.actionEventData.ActionEventList[idx];
                SecurityElement eventNode = eventData.SaveCfgToXml();
                buffNode.AddChild(eventNode);
            }
        }
        return buffNode;
    }

    public SecurityElement SaveFemaleFrameEventToXml()
    {
        if (femaleActionEventData == null) return null;

        SecurityElement buffNode = new SecurityElement("buff");
        buffNode.AddAttribute("id", this.femaleActionEventData.Id.ToString());
        buffNode.AddAttribute("name", this.femaleActionEventData.Name);
        buffNode.AddAttribute("endFrame", this.femaleActionEventData.TotalFrame.ToString());
        buffNode.AddAttribute("gender", this.femaleActionEventData.Gender.ToString());

        if (this.femaleActionEventData.ActionEventList != null)
        {
            for (int idx = 0; idx < this.femaleActionEventData.ActionEventList.Count; idx++)
            {
                ActionEventParamEditor eventData = this.femaleActionEventData.ActionEventList[idx];
                SecurityElement eventNode = eventData.SaveCfgToXml();
                buffNode.AddChild(eventNode);
            }
        }
        return buffNode;
    }
}

public class SkillAsset
{
    public int uniqueId;
    public int skillId;
    public int skillLv;
    public string skillName;
    public string skillDesc;
    public string skillIcon;
    public int skillType;
    public int cost;
    public int jobType;
    public int jobBranch;
    public int jobStage;
    public float fixedSingTime;
    public float changeSingTime;
    public float preCastingTime;
    public float castingTime;
    public float afterCastingTime;
    public float cd;
    public bool hide;
    public string levelUpDesc;
    public float[] PerceptionRange = new float[6];
    public List<int> buffIdList;
    public List<BuffDataAsset> buffList;


    public bool bAddNewBuff = false;
    public bool extendPerceptionFold = false;
    public bool extendBuffFold = true;
    public int iconIdx = -1;

    public SkillAsset()
    {
        this.skillId = 0;
    }

    public void AddNewBuff(BuffDataAsset buffData)
    {
        if (buffList == null)
            buffList = new List<BuffDataAsset>();

        buffList.Add(buffData);
    }

    public void RemoveBuff(BuffDataAsset buffData)
    {
        if (buffList == null || buffData == null) return;

        for(int idx =0; idx < buffList.Count;idx++)
        {
            if(buffList[idx].id == buffData.id)
            {
                buffList.RemoveAt(idx);
                return;
            }
        }
    }

    public BuffDataAsset GetBuffData(int buffId)
    {
        if (buffList == null) return null;

        for(int idx =0; idx < buffList.Count;idx++)
        {
            if (buffList[idx].id == buffId) return buffList[idx];
        }

        return null;
    }

    public void AddFunEventToBuff(int buffId, FunctionDataAsset funAsset)
    {
        BuffDataAsset buffData = GetBuffData(buffId);
        if (buffData == null) return;

        if (buffData.funList == null)
            buffData.funList = new List<FunctionValData>();

        FunctionValData newFunVal = new FunctionValData(funAsset.id, 0, 0, 0, 0, 0, 0);
        buffData.funList.Add(newFunVal);
    }

    public void Copy(SkillAsset src)
    {
        if (src == null) return;

        this.uniqueId = src.uniqueId;
        this.skillId = src.skillId;
        this.skillLv = src.skillLv;
        this.skillName = src.skillName;
        this.skillDesc = src.skillDesc;
        this.skillIcon = src.skillIcon;
        this.skillType = src.skillType;
        this.cost = src.cost;
        this.jobType = src.jobType;
        this.jobBranch = src.jobBranch;
        this.jobStage = src.jobStage;
        this.fixedSingTime = src.fixedSingTime;
        this.changeSingTime = src.changeSingTime;
        this.preCastingTime = src.preCastingTime;
        this.castingTime = src.castingTime;
        this.afterCastingTime = src.afterCastingTime;
        this.cd = src.cd;
        this.hide = src.hide;
        this.levelUpDesc = src.levelUpDesc;
        for (int idx = 0; idx < src.PerceptionRange.Length; idx++)
            this.PerceptionRange[idx] = src.PerceptionRange[idx];

        if (buffList == null)
            buffList = new List<BuffDataAsset>();
        buffList.Clear();
        if (src.buffList != null && src.buffList.Count > 0)
        {
            for(int idx =0; idx < src.buffList.Count;idx++)
            {
                BuffDataAsset srcBuffdata = src.buffList[idx];

                BuffDataAsset buff = new BuffDataAsset();
                buff.Copy(srcBuffdata);
                buffList.Add(buff);
            }
        }

        this.iconIdx = src.iconIdx;
    }

    public void Apply(SkillAsset src)
    {
        this.skillId = src.skillId;
        this.skillLv = src.skillLv;
        this.skillName = src.skillName;
        this.skillDesc = src.skillDesc;
        this.skillIcon = src.skillIcon;
        this.skillType = src.skillType;
        this.cost = src.cost;
        this.jobType = src.jobType;
        this.jobBranch = src.jobBranch;
        this.jobStage = src.jobStage;
        this.fixedSingTime = src.fixedSingTime;
        this.changeSingTime = src.changeSingTime;
        this.preCastingTime = src.preCastingTime;
        this.castingTime = src.castingTime;
        this.afterCastingTime = src.afterCastingTime;
        this.cd = src.cd;
        this.hide = src.hide;
        this.levelUpDesc = src.levelUpDesc;
        for (int idx = 0; idx < src.PerceptionRange.Length; idx++)
            this.PerceptionRange[idx] = src.PerceptionRange[idx];

        if (src.buffList != null && src.buffList.Count > 0)
        {
            for (int idx = 0; idx < src.buffList.Count; idx++)
            {
                BuffDataAsset srcBuff = src.buffList[idx];
                BuffDataAsset buff = GetBuffData(srcBuff.id);
                if(buff == null)
                {
                    buff = new BuffDataAsset();
                    buff.Copy(srcBuff);
                    buffList.Add(buff);
                }
                else
                {
                    buff.Apply(srcBuff);
                }
            }
        }

        for(int idx = buffList.Count -1; idx>=0; idx--)
        {
            BuffDataAsset buff = src.GetBuffData(buffList[idx].id);
            if(buff == null)
            {
                this.buffList.RemoveAt(idx);
            }
        }

        this.iconIdx = src.iconIdx;
    }

    public static SkillAsset CreateSkillAsset(ExcelWorksheet sheet,int rowIndex)
    {
        int colIndex = 1;

        SkillAsset skill = new SkillAsset();
        skill.uniqueId = sheet.GetValue<int>(rowIndex, colIndex++);
        skill.skillId = sheet.GetValue<int>(rowIndex, colIndex++);
        skill.skillName = sheet.GetValue<string>(rowIndex, colIndex++);
        skill.skillDesc = sheet.GetValue<string>(rowIndex, colIndex++);
        skill.skillIcon = sheet.GetValue<string>(rowIndex, colIndex++);
        skill.skillLv = sheet.GetValue<int>(rowIndex, colIndex++);
        skill.skillType = sheet.GetValue<int>(rowIndex, colIndex++);
        skill.cost = sheet.GetValue<int>(rowIndex, colIndex++);
        skill.jobType = sheet.GetValue<int>(rowIndex, colIndex++);
        skill.jobBranch = sheet.GetValue<int>(rowIndex, colIndex++);
        skill.jobStage = sheet.GetValue<int>(rowIndex, colIndex++);
        skill.fixedSingTime = sheet.GetValue<float>(rowIndex, colIndex++);
        skill.changeSingTime = sheet.GetValue<float>(rowIndex, colIndex++);
        skill.preCastingTime = sheet.GetValue<float>(rowIndex, colIndex++);
        skill.castingTime = sheet.GetValue<float>(rowIndex, colIndex++);
        skill.afterCastingTime = sheet.GetValue<float>(rowIndex, colIndex++);
        skill.cd = sheet.GetValue<float>(rowIndex, colIndex++);

        string buffStr = sheet.GetValue<string>(rowIndex, colIndex++);
        if (!string.IsNullOrEmpty(buffStr))
        {
            skill.buffIdList = StringUtil.convert2IntList(buffStr, ';'); 
        }

        for (int idx = 0; idx <= 5; idx++)
        {
            skill.PerceptionRange[idx] = sheet.GetValue<float>(rowIndex, colIndex++);
        }

        skill.hide = sheet.GetValue<int>(rowIndex, colIndex++) > 1 ? true : false;
        skill.levelUpDesc = sheet.GetValue<string>(rowIndex, colIndex++);


        return skill;
    }

    public void SaveAssetToExcel(ref ExcelWorksheet sheet, int row)
    {
        int col = 1;

        Debug.Log("skillId:" + this.skillId + " LV:" + this.skillLv);
        this.uniqueId = this.skillId * 100 + this.skillLv;
        sheet.SetValue(row, col++,this.uniqueId);
        sheet.SetValue(row, col++, this.skillId);
        sheet.SetValue(row, col++, this.skillName);
        sheet.SetValue(row, col++, this.skillDesc);
        sheet.SetValue(row, col++, this.skillIcon);
        sheet.SetValue(row, col++, this.skillLv);
        sheet.SetValue(row, col++, this.skillType);
        sheet.SetValue(row, col++, this.cost);
        sheet.SetValue(row, col++, this.jobType);
        sheet.SetValue(row, col++, this.jobBranch);
        sheet.SetValue(row, col++, this.jobStage);
        sheet.SetValue(row, col++, string.Format("{0:F}",this.fixedSingTime));
        sheet.SetValue(row, col++, string.Format("{0:F}", this.changeSingTime));
        sheet.SetValue(row, col++, string.Format("{0:F}", this.preCastingTime));
        sheet.SetValue(row, col++, string.Format("{0:F}", this.castingTime));
        sheet.SetValue(row, col++, string.Format("{0:F}", this.afterCastingTime));
        sheet.SetValue(row, col++, this.cd);

        string buffStr = "";
        if(buffList!=null)
        {
            for(int idx =0; idx < buffList.Count;idx++)
            {
                if (idx == 0)
                    buffStr = buffList[idx].id.ToString();
                else
                    buffStr = buffStr+";"+ buffList[idx].id.ToString();
            }
        }
        sheet.SetValue(row, col++, buffStr);

        for(int idx =0; idx <= 5;idx++)
        {
            sheet.SetValue(row, col++, PerceptionRange[idx]);
        }

        sheet.SetValue(row, col++, this.hide ? 1: 0);
        sheet.SetValue(row, col++, this.levelUpDesc);
    }
}
