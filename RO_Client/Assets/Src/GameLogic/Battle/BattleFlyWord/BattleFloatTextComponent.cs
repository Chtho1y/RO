using UnityEngine;
using System.Collections;
using UnityEngine.UI;

//普攻  技能伤害、白字；暴击伤害、黄字+红底；我方、红字；我方治疗、绿字【直接往上效果】
//多段总伤害【直接往上、慢】这个技能的累积伤害
public class BattleFloatTextComponent : MonoBehaviour
{
    public Animator anim;
    public Transform iconTrans;
    public float space = 0.3f;

    //Sprite3D critBg = null;
    //Sprite3D[] numArray = null;
    Image critBg = null;
    Text hurtNum = null;
    float beginShowTime = 0;
    Fighter caster = null;
    Fighter target = null;
    bool bDisposed = false;
    bool bInited = false;
    int hurtVal = 0;
    int buffId = 0;
    DIGIT_TYPE dightType = DIGIT_TYPE.AttackHurt;
    FONT_TYPE fontType = FONT_TYPE.WHITE_FONT;
    float duration = 1.0f;
    bool enableTweenAlpha = false;

    RectTransform rt = null;

    private void Start()
    {
        rt = GetComponent<RectTransform>();
        UpdatePos();
    }

    private void Update()
    {
        if (bDisposed || !bInited) return;

        UpdatePos();
    }

    private void OnDestroy()
    {
        Dispose();
    }

    /// <summary>
    /// 显示伤害数值
    /// </summary>
    /// <param name="hurtVal">伤害数值</param>
    /// <param name="fontType">字体类型</param>
    public void ShowHurt(Fighter caster,Fighter target,int buffId,int hurtVal, DIGIT_TYPE dightType,FONT_TYPE fontType,float duration,bool enableTweenAplha=true)
    {
        this.caster = caster;
        this.target = target;
        this.buffId = buffId;
        bDisposed = false;
        this.hurtVal = hurtVal;
        this.fontType = fontType;
        this.dightType = dightType;
        this.duration = duration;
        this.enableTweenAlpha = false;

        if (!bInited)
        {
            InitCom();
        }

        CalcHurt();
    }

    public bool CanMerge(FloatDigitInfo info)
    {
        if (caster == null || target == null) return false;

        if (info.attacker == caster &&
            info.target == target &&
            dightType == DIGIT_TYPE.MultiSkillHurtMerge && 
            dightType == DIGIT_TYPE.PlayerMultiSkillHurtMerget &&
            info.buffId == buffId) return true;

        return false;
    }

    public bool CheckTime()
    {
        if (target == null) return true;

        float passedTime = Time.realtimeSinceStartup - beginShowTime;
        if (passedTime >= duration)
            return true;

        if (enableTweenAlpha)
        {
            float alpha = 1 - passedTime / duration;

            if (critBg.isActiveAndEnabled)
            {
                Color clr = critBg.color;
                clr.a = alpha;
                critBg.color = clr;
            }
            else
            {
                Color clr = hurtNum.color;
                clr.a = alpha;
                hurtNum.color = clr;
            }
        }
       

        return false;
    }

    public void Dispose()
    {
        if(critBg!=null)
            critBg.gameObject.SetActive(false);
        target = null;
        bDisposed = true;
        caster = null;
        hurtVal = 0;
        buffId = 0;
        beginShowTime = 0;
        //hurtNum.gameObject.SetActive(false);
    }

    void InitCom()
    {
        if (bInited) return;

         hurtNum = iconTrans.Find("hurt").GetComponent<Text>();
         critBg = iconTrans.Find("critBg").GetComponent<Image>();

         SetCritBgVisible();

         bInited = true;
    }
    void CalcHurt()
    {
        iconTrans.localScale = Vector3.one;

        HandleHurtNum();
        UpdatePos();
        transform.localRotation = Quaternion.identity;
        beginShowTime = Time.realtimeSinceStartup;
    }

    void HandleHurtNum()
    {
        if(this.dightType == DIGIT_TYPE.ChangeSP && hurtVal > 0)
        {
            hurtNum.text = "+"+hurtVal.ToString();
        }
        else
        {
            hurtNum.text = hurtVal.ToString();
        }
        hurtNum.color = GetFonfColor(fontType);

        //hurtNum.gameObject.SetActive(true);
        SetCritBgVisible();
    }

    void SetCritBgVisible()
    {
        if (critBg != null)
        {
            critBg.gameObject.SetActive(this.dightType == DIGIT_TYPE.CritHurt);
            if (this.dightType == DIGIT_TYPE.CritHurt)
            {
                Color clr = critBg.color;
                clr.a = 1.0f;
                critBg.color = clr;   
            }
        }
    }

    void UpdatePos()
    {
        if (target == null || target.Ctrl == null) return;

        Vector3 relativePos = target.Ctrl.GetUIPointPos() + target.Actor.AvatarData.hurtPos;
        Vector3 pos = BattleCamera.Instance.RealCamera.WorldToViewportPoint(relativePos);
        if (rt!=null)
            rt.anchoredPosition3D = new Vector3((pos.x - 0.5f) * UIMgr.SCREEN_WIDTH, (pos.y - 0.5f) * UIMgr.SCREEN_HEIGHT, 0);

    }

    string GetFontPrefix(FONT_TYPE fontType)
    {
        switch (fontType)
        {
            case FONT_TYPE.GREEN_FONT:
                return BattleFlyWordMgr.green_font_prefix;
            case FONT_TYPE.RED_FONT:
                return BattleFlyWordMgr.red_font_prefix;
            case FONT_TYPE.YELLOW_FONT:
                return BattleFlyWordMgr.yellow_font_prefix;
            case FONT_TYPE.WHITE_FONT:
                return BattleFlyWordMgr.white_font_prefix;
            default:
                return BattleFlyWordMgr.white_font_prefix;
        }
    }

    Color GetFonfColor(FONT_TYPE fontType)
    {
        switch (fontType)
        {
            case FONT_TYPE.GREEN_FONT:
                return Constants.green;
            case FONT_TYPE.RED_FONT:
                return Constants.red;
            case FONT_TYPE.YELLOW_FONT:
                return Constants.yellow;
            case FONT_TYPE.WHITE_FONT:
                return Color.white;
            case FONT_TYPE.SP_FONT:
                return Constants.spClr;
            default:
                return Color.white;
        }
    }

}
