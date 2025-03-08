using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;

public enum FONT_TYPE
{
    GREEN_FONT = 1,     //绿色数值
    RED_FONT = 2,       //红色数值
    WHITE_FONT = 3,     //白色数值
    YELLOW_FONT = 4,    //黄色数值
    SP_FONT = 5,        //蓝量颜色
}

//数字飘字类型
public enum DIGIT_TYPE
{
    Invalid,
    AttackHurt,           //普通伤害
    CritHurt,             //暴击伤害
    MultiSkillHurtMerge,    //多段伤害的技能的累积伤害
    Heal,                   //治疗
    PlayerHurt,             //玩家伤害
    PlayerMultiSkillHurtMerget,         //玩家多段伤害的技能的累积伤害
    ChangeSP,                           //蓝量变化
};

//其他文本飘字内容
public enum enOtherFloatTextContent
{
    Absorb,                 //吸收
    Missing,               //被致盲，普攻miss
    AdditiveEffect,               //增益效果
    NegativeEffect,             //减益效果
};

public enum RESTRICT_TYPE
{
    None = 0, // 无
    Dizzy = 1,
    SlowDown = 2,
    Taunt = 3,
    Fear = 4,
    Frozen = 5,
    Floating = 6,
    Slient = 7,
    Stone = 8,
}

//飘字信息
public struct stFloatText
{
    public int m_floatTextSequence;
    public Vector3 m_worldPosition;
};

public struct FloatDigitInfo
{
    public Fighter attacker;
    public Fighter target;
    public DIGIT_TYPE digitType;
    public int value;
    public int buffId;
    public float showTime;
    public bool tweenAlpha;
    public bool lastHurt;

    public FloatDigitInfo(Fighter attacker, Fighter target, int buffId, DIGIT_TYPE digitType, int value, float showTime,bool tweenAlpha,bool lastHurt)
    {
        this.attacker = attacker;
        this.target = target;
        this.buffId = buffId;
        this.digitType = digitType;
        this.value = value;
        this.showTime = showTime;
        this.tweenAlpha = tweenAlpha;
        this.lastHurt = lastHurt;
    }

    public void Dispose()
    {
        this.attacker = null;
        this.target = null;
    }
}

//延迟飘字 角色ID(角色唯一ID * 10 + 敌我方)
public class DelayFlyWord
{
    public const float m_c_fDelayTime = 0.5f;
    private long m_nId = 0;
    private float m_fCurTime = 0.0f;
    private enOtherFloatTextContent m_enTextCon;
    private Queue<string> mQueueDelayShowWord = new Queue<string>();

    private void RefreshTime()
    {
        if (mQueueDelayShowWord.Count <= 0)
            m_fCurTime = 0.0f;       
    }

    //添加
    public void AddDelayShowWord(long nId,enOtherFloatTextContent EnTextContent,string strinfo)
    {
        m_nId = nId;
        m_enTextCon = EnTextContent;
        if (null == mQueueDelayShowWord)
            mQueueDelayShowWord = new Queue<string>();
        //RefreshTime(); 初次 没有延迟
        mQueueDelayShowWord.Enqueue(strinfo);      
    }

    //处理
    public bool ProcessDelayShowWord(out long nID,out enOtherFloatTextContent enContent,out string strInfo)
    {
        strInfo = string.Empty;
        nID = m_nId;
        enContent = m_enTextCon;

        m_fCurTime -= Time.deltaTime;
        if (m_fCurTime <= 0)
        {
            m_fCurTime = 0.0f;            
        }
            
        if (null != mQueueDelayShowWord && mQueueDelayShowWord.Count > 0)
        {            
            if(m_fCurTime <= 0)
            {
                strInfo = mQueueDelayShowWord.Dequeue();
                m_fCurTime = m_c_fDelayTime;
                return true;
            }
        }
        return false;
    }

    public void ClearDelayShowWord()
    {
        m_nId = 0;
        if (null != mQueueDelayShowWord)
        {
            mQueueDelayShowWord.Clear();
            mQueueDelayShowWord = null;
        }
    }
}

public class BattleFlyWordMgr : SingletonMono<BattleFlyWordMgr>
{
    public const int c_max_battleFlyWordNum = 50;
    public const string white_font_prefix = "number_w_";
    public const string yellow_font_prefix = "number_y_";
    public const string red_font_prefix = "number_r_";
    public const string green_font_prefix = "number_g_";


    const string FLOAT_TEXT_PREFAB = "Battle/FloatText";
    const string FLOAT_BUFF_TEXT_PREFAB = "Battle/FloatBuffText";
    const uint DEFAULT_FONT_SIZE = 6;

    private static string[][] s_battleFloatDigitAnimatorStates = new string[][]
    {
        new string[]{""},
        new string[]{ "Hurt_Left", "Hurt_Right"},
        new string[]{ "Hurt_Left", "Hurt_Right"},
        new string[]{ "SkillMergeHurt01","SkillMergeHurt01" },
        new string[]{ "Heal_Up","Heal_Up" },
        new string[]{ "HurtPlayer_Left", "HurtPlayer_Right" },
        new string[]{ "SkillMergeHurtPlayer01","SkillMergeHurtPlayer01" },
        new string[]{ "Heal_Up","Heal_Up" },
    };

    bool bLoaded = false;
    bool bLoaded3d = false;

    private List<FloatDigitInfo> mFloatDigitInfoList;

    private List<BattleFloatTextComponent> mFloatTextComList = new List<BattleFloatTextComponent>();

    private List<BattleFloatBuffText> mFloatBuffTextComList = new List<BattleFloatBuffText>();

    private Dictionary<long, DelayFlyWord> mDicDelayShowWord = new Dictionary<long, DelayFlyWord>();

    private GameObject mHud = null;

    private Canvas mHudCanvas = null;

    private GameObject mFloatTextRoot = null;

    public GameObject HudRoot
    {
        get { return mHud; }
    }

    public Transform HudRootTrans
    {
        get { return mHud!=null?mHud.transform:null; }
    }

    public bool Loaded
    {
        get { return bLoaded && bLoaded3d; }
    }

    public int FloatTextCnt
    {
        get { return mFloatTextComList.Count; }
    }

    public override void InitMgr()
    {
        base.InitMgr();

        Init();
        EventMgr.AddEventListener<UIEventParamFighterHurt>(ECoreEventType.EID_FIGHTER_HURT, OnFighterHurt);
        EventMgr.AddEventListener<object[]>(ECoreEventType.EID_FIGHTER_HEAL, OnFighterHeal);
        EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_FIGHTER_DODGE, OnFighterMissing);
        EventMgr.AddEventListener<Fighter,int>(ECoreEventType.EID_SHIELD_ABSORT_HURT, OnShowShieldHurt);
        EventMgr.AddEventListener<Fighter,string>(ECoreEventType.EID_ADD_FUNCTION, OnAddFunction);
        EventMgr.AddEventListener<Fighter, string>(ECoreEventType.EID_NEGATIVE_FUNCTION, OnNegativeFunction);
        EventMgr.AddEventListener<Fighter,int>(ECoreEventType.EID_Fighter_AddSp, OnFighterChangeSp);
    }

    private void Init()
    {
        mHud = new GameObject("HudRoot");
        mHud.transform.SetParent(UIMgr.Instance.UIBattleRootTrans);
        RectTransform rt = mHud.AddComponent<RectTransform>();
        rt.anchorMin = Vector2.zero;
        rt.anchorMax = Vector2.one;
        rt.anchoredPosition3D = Vector3.zero;
        rt.offsetMin = rt.offsetMax = Vector2.zero;
        rt.localScale = Vector3.one;

        mHudCanvas = mHud.AddComponent<Canvas>();
        mHudCanvas.overrideSorting = true;
        mHudCanvas.sortingOrder = 0;
        mHud.layer = LayerMask.NameToLayer("UI");                
    }

    protected override void Dispose()
    {
        EventMgr.RemoveEventListener<UIEventParamFighterHurt>(ECoreEventType.EID_FIGHTER_HURT, OnFighterHurt);
        EventMgr.RemoveEventListener<object[]>(ECoreEventType.EID_FIGHTER_HEAL, OnFighterHeal);
        EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_FIGHTER_DODGE, OnFighterMissing);
        EventMgr.RemoveEventListener<Fighter, int>(ECoreEventType.EID_SHIELD_ABSORT_HURT, OnShowShieldHurt);
        EventMgr.RemoveEventListener<Fighter,string>(ECoreEventType.EID_ADD_FUNCTION, OnAddFunction);
        EventMgr.RemoveEventListener<Fighter, string>(ECoreEventType.EID_NEGATIVE_FUNCTION, OnNegativeFunction);
        EventMgr.RemoveEventListener<Fighter,int>(ECoreEventType.EID_Fighter_AddSp, OnFighterChangeSp);

        Clear();
        base.Dispose();
    }
    ///---------------------------------------------延迟显示
    private void AddDelayShowWord(long nFighterId, enOtherFloatTextContent EnTextContent, string strinfo)
    {
        if (null == mDicDelayShowWord)
            mDicDelayShowWord = new Dictionary<long, DelayFlyWord>();
        bool bIsFinde = mDicDelayShowWord.ContainsKey(nFighterId);
        if(!bIsFinde)
        {
            DelayFlyWord pDelayWord = new DelayFlyWord();
            mDicDelayShowWord.Add(nFighterId,pDelayWord);
        }
        mDicDelayShowWord[nFighterId].AddDelayShowWord(nFighterId, EnTextContent, strinfo);
    }

    private void ClearDelayShowWord()
    {
        if (null != mDicDelayShowWord)
        {           
            var etr = mDicDelayShowWord.GetEnumerator();          
            while (etr.MoveNext())
            {
                etr.Current.Value.ClearDelayShowWord();                
            }
            mDicDelayShowWord.Clear();
            mDicDelayShowWord = null;
        }        
    }

    private void ProcessDelayShowWord()
    {
        if (null != mDicDelayShowWord)
        {
            var etr = mDicDelayShowWord.GetEnumerator();
            while (etr.MoveNext())
            {
                long nFighterId = 0;
                string strInfo = string.Empty;
                enOtherFloatTextContent enContent;
                bool bIsProcess = etr.Current.Value.ProcessDelayShowWord(out nFighterId,out enContent,out strInfo);
                if(bIsProcess)
                {
                    if(null != BattleMgr.Instance.Battle)
                    {
                        long nId = nFighterId / 10;
                        long nSide = nFighterId - nId * 10;                       
                        Fighter pFighter = BattleMgr.Instance.Battle.FighterMgr.GetFighterByID(nId, (eTeamType)nSide);
                        if(null == pFighter)
                        {
                            continue;
                        }                      
                        CreateBattleFunctionText(pFighter, enContent, strInfo);
                    }                    
                }
            }
        }
    }
    //-----------------------------------------延迟显示end
    public void StartLoad()
    {
        //

        bLoaded = false;
        bLoaded3d = true;
        string[] assetNames = new string[] { FighterHPBar.HUD_HERO_PREFAB, FLOAT_TEXT_PREFAB, FLOAT_BUFF_TEXT_PREFAB, SkillName2D.HUD_SKILLNAME_PREFAB, RageEffect2D.HUD_RAGE_PREFAB, BattleDropMgr.drop_gold_prefab_name,BattleDropMgr.drop_exp_prefab_name ,BattleDropMgr.drop_partnerexp_prefab_name,BattleDropMgr.drop_item_prefab_name,BattleDropMgr.drop_jobexp_prefab_name };
        ResourceMgr.Instance.LoadAsset<List<GameObject>>(OnLoadFlyWordCompleted, Constants.UIPath, assetNames);

        //string[] assetNamesFor3D = new string[] { BattleDropMgr.drop_prefab_name};
        //ResourceMgr.Instance.LoadAsset<List<GameObject>>(OnLoad3DFlyWordCompleted, Constants.ModelPath, assetNamesFor3D);
    }

    public void SetHudVisible(bool vis,int recoverTime = 0)
    {
        if(mHudCanvas != null)
        {
            mHudCanvas.enabled = vis;
        }

        if(recoverTime > 0 )
        {
            TimerManager.Instance.AddTimer(recoverTime, 1, OnRecoverVis);
        }
    }

    void OnRecoverVis(int seq)
    {
        if(mHudCanvas != null)
        {
            mHudCanvas.enabled = !mHudCanvas.enabled;
        }
    }

    public void Clear()
    {
        bLoaded = false;
        bLoaded3d = false;

        if (mFloatDigitInfoList != null)
        {
            for(int idx =0; idx < mFloatDigitInfoList.Count;idx++)
            {
                mFloatDigitInfoList[idx].Dispose();
            }
            mFloatDigitInfoList.Clear();
        }

        if(mFloatTextComList!=null)
        {
            for(int idx =0; idx < mFloatTextComList.Count;idx++)
            {
                BattleFloatTextComponent com = mFloatTextComList[idx];
                if (com == null) continue;

                ResourceMgr.Instance.RecycleGO(Constants.UIPath, FLOAT_TEXT_PREFAB, com.transform.parent.gameObject);
                com.Dispose();
            }
            mFloatTextComList.Clear();
        }

        if(removeList!=null)
        {
            for(int idx =0; idx < removeList.Count;idx++)
            {
                removeList[idx].Destroy();
            }
            removeList.Clear();
        }

        if(mFloatBuffTextComList!=null)
        {
            for (int idx = 0; idx < mFloatBuffTextComList.Count; idx++)
            {
                BattleFloatBuffText com = mFloatBuffTextComList[idx];
                if (com == null) continue;

                ResourceMgr.Instance.RecycleGO(Constants.UIPath, FLOAT_BUFF_TEXT_PREFAB, com.transform.parent.gameObject);
                com.Dispose();
            }
            mFloatBuffTextComList.Clear();
        }

        ClearDelayShowWord();
    }

    void OnLoadFlyWordCompleted(List<GameObject> prefabs, string assetPath, params string[] assetName)
    {
        bLoaded = true;
        PrecacheGo();
    }

    void OnLoad3DFlyWordCompleted(List<GameObject> prefabs, string assetPath, params string[] assetName)
    {
        bLoaded3d = true;
    }
    
    void PrecacheGo()
    {
        ResourceMgr.Instance.SetGoPoolMaxCacheNum(Constants.UIPath, FLOAT_TEXT_PREFAB, c_max_battleFlyWordNum);
        ResourceMgr.Instance.SetGoPoolMaxCacheNum(Constants.UIPath, FLOAT_BUFF_TEXT_PREFAB, c_max_battleFlyWordNum);
        for (int idx = 0; idx < c_max_battleFlyWordNum; idx++)
        {
            GameObject go = ResourceMgr.Instance.GetGoFromPool(Constants.UIPath, FLOAT_TEXT_PREFAB);
            if (go != null)
            {
                ResourceMgr.Instance.RecycleGO(Constants.UIPath, FLOAT_TEXT_PREFAB, go);
            }
        }

        for (int idx = 0; idx < c_max_battleFlyWordNum; idx++)
        {
            GameObject go = ResourceMgr.Instance.GetGoFromPool(Constants.UIPath, FLOAT_BUFF_TEXT_PREFAB);
            if (go != null)
            {
                ResourceMgr.Instance.RecycleGO(Constants.UIPath, FLOAT_BUFF_TEXT_PREFAB, go);
            }
        }

        BattleDropMgr.Instance.PrecacheGo();
    }
    private void OnFighterMissing(CoreEvent<Fighter> ce)
    {
        CreateBattleFunctionText(ce.Data, enOtherFloatTextContent.Missing);
    }

    private void OnShowShieldHurt(CoreEvent<Fighter,int> ce)
    {
        CreateBattleFunctionText(ce.Data, enOtherFloatTextContent.Absorb,"",ce.Data1);
    }

    private void OnAddFunction(CoreEvent<Fighter,string> ce)
    {
        long nId = ce.Data.Id * 10 + (int)ce.Data.TeamSide;
        AddDelayShowWord(nId, enOtherFloatTextContent.AdditiveEffect, ce.Data1);
        //CreateBattleFunctionText(ce.Data, enOtherFloatTextContent.AdditiveEffect,ce.Data1);
    }

    private void OnNegativeFunction(CoreEvent<Fighter,string> ce)
    {
        long nId = ce.Data.Id * 10 + (int)ce.Data.TeamSide;
        AddDelayShowWord(nId, enOtherFloatTextContent.NegativeEffect, ce.Data1);
        //CreateBattleFunctionText(ce.Data, enOtherFloatTextContent.NegativeEffect, ce.Data1);
    }

    private void OnFighterHeal(CoreEvent<object[]> ce)
    {
        object[] data = ce.Data;
        Fighter fighter = (Fighter)data[0];
        int healVal = (int)data[1];
        DIGIT_TYPE digitType = DIGIT_TYPE.Heal;
        CollectFloatDigitInSingleFrame(fighter, fighter, 0, digitType, healVal, 1.0f,true);
    }

    private void OnFighterChangeSp(CoreEvent<Fighter,int> ce)
    {
        Fighter f = ce.Data;
        CollectFloatDigitInSingleFrame(f, f, 0, DIGIT_TYPE.ChangeSP, ce.Data1, 1.0f, true);
    }

    private void OnFighterHurt(CoreEvent<UIEventParamFighterHurt> ce)
    {
        UIEventParamFighterHurt param = ce.Data;
        Fighter caster = param.mCaster;
        Fighter target = param.mTarget;
        bool isCrit = param.mIsCrit;
        int isMultiSkill = param.mMultiSkillNum;
        int buffId = param.mBuffId;
        int killSeq = param.mAttackSeq;
        int lastDamage = param.mLastDamage;

        DIGIT_TYPE digitType = DIGIT_TYPE.AttackHurt;
        bool createMulitiSkillHurt = false;
        if(isCrit && (isMultiSkill<=1) && target.Actor.IsNpc)
        {
            digitType = DIGIT_TYPE.CritHurt;
        }else if (isMultiSkill>1)        {

            createMulitiSkillHurt = true;
        }

        if((digitType == DIGIT_TYPE.AttackHurt || digitType == DIGIT_TYPE.CritHurt) && target!=null && target.IsPlayer)
        {
            digitType = DIGIT_TYPE.PlayerHurt;
        }

        CollectFloatDigitInSingleFrame(caster,target, buffId, digitType, param.mHurtVal,1.0f,true);
        if (createMulitiSkillHurt)
        {
            //DebugHelper.LogError("killSeq:" + killSeq + " multiSkill:" + isMultiSkill);
            float showTime = (killSeq == isMultiSkill)? 2: param.mMultiKillInterval;
            if(target.TeamSide == 0)
            {
                CollectFloatDigitInSingleFrame(caster, target, buffId, DIGIT_TYPE.PlayerMultiSkillHurtMerget, param.mHurtVal + lastDamage, showTime, killSeq == isMultiSkill, killSeq == isMultiSkill);
            }
            else
            {
                CollectFloatDigitInSingleFrame(caster, target, buffId, DIGIT_TYPE.MultiSkillHurtMerge, param.mHurtVal + lastDamage, showTime, killSeq == isMultiSkill, killSeq == isMultiSkill);
            }
        }
    }

    /// <summary>
    /// 用于判断两个飘字类型是否可以合并为一个暴击的飘字类型
    /// </summary>
    /// <param name="type1"></param>
    /// <param name="type2"></param>
    /// <returns></returns>
    private bool CanMergeToCritText(ref DIGIT_TYPE type1, DIGIT_TYPE type2)
    {
        if (type1 == DIGIT_TYPE.AttackHurt && type2 == DIGIT_TYPE.AttackHurt)
        {
            if (type1 < type2)
            {
                type1 = type2;
            }
            return true;
        }
        else
        {
            return false;
        }
    }

    /// <summary>
    /// 合并同一帧中的伤害飘字
    /// </summary>
    /// <param name="attacker">攻击者</param>
    /// <param name="target">受击目标</param>
    /// <param name="digitType">飘字类型</param>
    /// <param name="value">飘字数值</param>
    public void CollectFloatDigitInSingleFrame(Fighter attacker, Fighter target, int buffId, DIGIT_TYPE digitType, int value, float showTime, bool lastHurt, bool tweenAlpha=true)
    {
        if (mFloatDigitInfoList == null)
        {
            mFloatDigitInfoList = new List<FloatDigitInfo>();
        }

        //低端机
        if (FloatTextCnt>= c_max_battleFlyWordNum)
        {
            return;
        }

        FloatDigitInfo tempInfo = new FloatDigitInfo(attacker, target, buffId, digitType, value,showTime, tweenAlpha, lastHurt);
        mFloatDigitInfoList.Add(tempInfo);
    }

    /// <summary>
    /// 显示上一帧合并起来的伤害飘字
    /// </summary>
    private void updateFloatDigitInLastFrame()
    {
        if (mFloatDigitInfoList == null || mFloatDigitInfoList.Count == 0)
        {
            return;
        }

        for (int i = 0; i < mFloatDigitInfoList.Count; i++)
        {
            FloatDigitInfo infoNode = mFloatDigitInfoList[i];

            if (infoNode.attacker == null || infoNode.target == null)
            {
                continue;
            }

            Vector3 targetPos = infoNode.target.Position;
            Vector3 attackerPos = infoNode.attacker.Position;
            //往左飘
            if (Vector3.Cross(targetPos, attackerPos).y > 0)
            {
                CreateBattleFloatDigit(infoNode, 1);
            }
            else
            {
                CreateBattleFloatDigit(infoNode, 0);
            }
        }
        mFloatDigitInfoList.Clear();
    }

    BattleFloatTextComponent FindFloatTextCom(FloatDigitInfo info)
    {
        for(int idx =0; idx < mFloatTextComList.Count; idx++)
        {
            BattleFloatTextComponent com = mFloatTextComList[idx];
            if (com.CanMerge(info))
                return com;
        }
        return null;
    }
    
    //--------------------------------------------------
    /// 创建数字飘字
    /// @digitValue
    /// @digitType
    /// @worldPosition
    /// @animatIndex 动画数组下标
    //--------------------------------------------------
    public void CreateBattleFloatDigit(FloatDigitInfo info,int animatIndex)
    {
        // Fighter caster, Fighter target,int skillId, int digitValue, DIGIT_TYPE digitType,  
        string[] animatorStates = s_battleFloatDigitAnimatorStates[(int)info.digitType];
        if (animatorStates.Length <= 0 || animatIndex < 0 || animatIndex >= animatorStates.Length)
        {
            return;
        }


        string animName = animatorStates[animatIndex];
        if(info.digitType == DIGIT_TYPE.MultiSkillHurtMerge && info.lastHurt)
        {
            animName = "SkillMergeHurt_Up";
        }else if(info.digitType == DIGIT_TYPE.PlayerMultiSkillHurtMerget && info.lastHurt)
        {
            animName = "SkillMergeHurtPlayer_Up";
        }

        CreateBattleFloatText(info, animName );
    }

    //--------------------------------------------------
    /// 创建战斗飘字
    /// @digitObject
    /// @worldPosition
    //--------------------------------------------------
    private void CreateBattleFloatText(FloatDigitInfo info,string animatorState)
    {
        if (string.IsNullOrEmpty(animatorState))
        {
            return;
        }

        GameObject digit = ResourceMgr.Instance.GetGoFromPool(Constants.UIPath, FLOAT_TEXT_PREFAB);

        if (digit == null) return;

        //digit.name = info.target!=null?"floattext_"+info.target.Name+"_"+info.digitType: "floattext_unknown";

        BattleFloatTextComponent component = digit.GetComponentInChildren<BattleFloatTextComponent>();
        if (digit == null)
        {
            return;
        }

        if (null == CameraMgr.Instance.UICamera)
        {
            ResourceMgr.Instance.RecycleGO(Constants.UIPath, FLOAT_TEXT_PREFAB, digit);
            return;
        }

        digit.transform.SetParent(HudRootTrans);
        digit.transform.localScale = Vector3.one;
        digit.transform.localRotation = Quaternion.identity;

        RectTransform rt = digit.GetComponent<RectTransform>();
        rt.anchorMin = Vector2.zero;
        rt.anchorMax = Vector2.one;
        rt.anchoredPosition3D = Vector3.zero;
        rt.offsetMin = rt.offsetMax = Vector2.zero;

        //Canvas hudCanvas = digit.GetComponent<Canvas>();
        //hudCanvas.overrideSorting = true;
        //hudCanvas.sortingOrder = 0;

        FONT_TYPE fontType = FONT_TYPE.WHITE_FONT;
        if(info.digitType == DIGIT_TYPE.Heal)
        {
            fontType = FONT_TYPE.GREEN_FONT;
        }else if(info.digitType == DIGIT_TYPE.ChangeSP)
        {
            fontType = FONT_TYPE.SP_FONT;
        }
        else
        {
            if (info.target!=null &&  info.target.IsTeamMember)
            {
                fontType = FONT_TYPE.RED_FONT;
            }
            else
            {
                if (info.digitType == DIGIT_TYPE.CritHurt || 
                    info.digitType == DIGIT_TYPE.MultiSkillHurtMerge ||
                    info.digitType == DIGIT_TYPE.PlayerMultiSkillHurtMerget)
                {
                    fontType = FONT_TYPE.YELLOW_FONT;
                }
            }
        }
       

        component.ShowHurt(info.attacker,info.target,info.buffId, info.value, info.digitType,fontType, info.showTime,info.tweenAlpha);

        Animator animator = component.anim;
        if (animator != null && animator.gameObject.activeInHierarchy)
        {
            animator.Play(animatorState);
        }

        mFloatTextComList.Add(component);
    }


    private void CreateBattleFunctionText(Fighter target, enOtherFloatTextContent type, string icon = "",float hurt = 0)
    {
        //if (!target.IsHero) return;

        GameObject digit = ResourceMgr.Instance.GetGoFromPool(Constants.UIPath, FLOAT_BUFF_TEXT_PREFAB);
        if (digit == null)
        {
            return;
        }
        digit.name = target != null ? GetFloatTextName(type) +"_"+ target.Name : "floattext_unknown";
        BattleFloatBuffText component = digit.GetComponentInChildren<BattleFloatBuffText>();

        if (null == CameraMgr.Instance.UICamera)
        {
            ResourceMgr.Instance.RecycleGO(Constants.UIPath, FLOAT_TEXT_PREFAB, digit);
            return;
        }

        digit.transform.SetParent(mHud.transform);
        digit.transform.localScale = Vector3.one;
        digit.transform.localRotation = Quaternion.identity;

        RectTransform rt = digit.GetComponent<RectTransform>();
        rt.anchorMin = Vector2.zero;
        rt.anchorMax = Vector2.one;
        rt.anchoredPosition3D = Vector3.zero;
        rt.offsetMin = rt.offsetMax = Vector2.zero;

        //Canvas hudCanvas = digit.GetComponent<Canvas>();
        //hudCanvas.overrideSorting = true;
        //hudCanvas.sortingOrder = 0;

        if(type == enOtherFloatTextContent.Absorb)
        {
            component.ShowShield(target,hurt);
        }else if(type == enOtherFloatTextContent.Missing)
        {
            component.ShowMissing(target);
        }
        else
        {
            component.ShowBuffText(target,icon, type == enOtherFloatTextContent.AdditiveEffect);
        }
   
        mFloatBuffTextComList.Add(component);
    }

    private string GetFloatTextName(enOtherFloatTextContent type)
    {
        switch(type)
        {
            case enOtherFloatTextContent.Absorb:
                return "Shield";
            case enOtherFloatTextContent.Missing:
                return "Missing";
            case enOtherFloatTextContent.AdditiveEffect:
            case enOtherFloatTextContent.NegativeEffect:
                return "Function";
        }
        return "";
    }

    //--------------------------------------------------
    /// 清理所有飘字
    //--------------------------------------------------
    public void ClearAllBattleFloatText()
    {
        if (mFloatDigitInfoList != null)
        {
            mFloatDigitInfoList.Clear();
        }

        if(mFloatBuffTextComList != null)
        {
            mFloatBuffTextComList.Clear();
        }
    }

    public void LateUpdate()
    {
        ProcessDelayShowWord();//延迟飘字
        updateFloatDigitInLastFrame();
        checkFloatCompleted();
        UpdateBufffFloat();
    }

    List<BattleFloatTextComponent> removeList = new List<BattleFloatTextComponent>();
    void checkFloatCompleted()
    {
        for(int idx =0; idx < mFloatTextComList.Count;idx++)
        {
            BattleFloatTextComponent com = mFloatTextComList[idx];
            if (com.CheckTime())
            {
                removeList.Add(com);
            }
        }

        for(int idx =0; idx < removeList.Count; idx++)
        {
            BattleFloatTextComponent com = removeList[idx];
            ResourceMgr.Instance.RecycleGO(Constants.UIPath, FLOAT_TEXT_PREFAB, com.transform.parent.gameObject);
            mFloatTextComList.Remove(com);
            com.Dispose();
        }
        removeList.Clear();
    }

    void UpdateBufffFloat()
    {
        for(int idx = mFloatBuffTextComList.Count-1; idx>=0;idx--)
        {
            var com = mFloatBuffTextComList[idx];
            if (com.Finished)
            {
                ResourceMgr.Instance.RecycleGO(Constants.UIPath, FLOAT_BUFF_TEXT_PREFAB, com.transform.parent.gameObject);
                mFloatBuffTextComList.Remove(com);
                com.Dispose();
            }
        }
    }
}
