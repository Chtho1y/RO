using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class SkillName2D
{
    public const string HUD_SKILLNAME_PREFAB = "Battle/SkillNameText";

    private Text mSkillName;
    private GameObject mHud;
    private RectTransform mItemRt = null;

    //引导条
    private GameObject mCastingGo;
    private Image mCastingAdd;
    private Image mCastingImage;

    private GameObject mBreakGo;

    private GameObject mSingGo;
    private Image mSingImage;

    private Animator mAnimator = null;

    private Fighter mFighter = null;

    private int mHideBreakTimer = 0;
    private int mAutoTimer = 0;
    private Vector3 m_skillNamePos;
    const float c_miniShowTime = 1.0f;

    public void Born(Fighter owner)
    {
        mFighter = owner;
        mHud = null;
        mItemRt = null;
    }

    bool registered = false;
    void RegisterEvents()
    {
        if (registered) return;

        registered = true;
        //EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_FIGHTER_DO_SKILL, OnShowSkillName);
    }

    void UnRegisterEvents()
    {
        registered = false;
        //EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_FIGHTER_DO_SKILL, OnShowSkillName);
    }

    public void Dispose()
    {
        if (mHud != null)
        {
            ResourceMgr.Instance.RecycleGO(Constants.UIPath, HUD_SKILLNAME_PREFAB, mHud);
        }

        m_skillNamePos = Vector3.zero;
        mHud = null;
        mItemRt = null;

        if (mHideBreakTimer > 0)
        {
            TimerManager.Instance.RemoveTimer(mHideBreakTimer);
            mHideBreakTimer = 0;
        }
        RemoveAutoTimer();

        mItemRt = null;
        mHud = null;
        mSingImage = null;

        mCastingGo = null;
        mCastingAdd = null;
        mCastingImage = null;
        mAnimator = null;
    }

    public void Destroy()
    {
        UnRegisterEvents();
        Dispose();
    }

    public void Prepare()
    {
        InitHudUI();
    }

    public void Fight()
    {
#if UNITY_EDITOR
        if (mHud)
        {
            mHud.name = mFighter.Ctrl.name + "_skillName";
        }
#endif
        ResetHudUI();
        RegisterEvents();
    }

    public void Deactive()
    {
        SetVisible(false);
    }

    public void OnActorDead()
    {
        if (mFighter == null) return;

        UnRegisterEvents();
        SetVisible(false);
    }

    public void OnActorRevive()
    {
        if (mFighter == null) return;

        RegisterEvents();
        SetVisible(false);
    }

    public void SetVisible(bool vis)
    {
        if (mHud == null) return;

        mHud.SetActive(vis);
    }

    public void LateUpdate(float deltaTime)
    {
        if (mHud == null) return;

        if (mFighter == null)
        {
            Dispose();
            return;
        }

        // 这几种情况不需要更新下面的东西，太费了
        if (!mFighter.IsVisible)
        {
            return;
        }

        // Update Hud
        if (mHud.activeSelf && Camera.main != null && Camera.main.enabled)
        {
            Vector3 curSkillNamePos = mFighter.Ctrl.GetUIPointPos() + mFighter.Actor.AvatarData.skillNamePos;
            Vector3 pos = Camera.main.WorldToViewportPoint(curSkillNamePos);

            bool isNeedUpdateUIHud = (m_skillNamePos != pos);

            if (isNeedUpdateUIHud && mItemRt != null)
            {
                mItemRt.anchoredPosition3D = new Vector3((pos.x - 0.5f) * UIMgr.SCREEN_WIDTH, (pos.y - 0.5f) * UIMgr.SCREEN_HEIGHT, 0); ;
                m_skillNamePos = pos;
            }

            if (curentCastingTime > 0 && mCastingImage != null && BattleMgr.Instance.Battle.IsFighting)
            {
                mCastingImage.fillAmount = curentCastingTime / totalCastingTime;
                if (mCastingAdd != null)
                    mCastingAdd.fillAmount = mCastingImage.fillAmount;
                curentCastingTime -= deltaTime;
            }
        }
    }

    ///-------------------------------------------------
    /// 初始化Hud UI
    ///-------------------------------------------------
    private void InitHudUI()
    {
        if (mFighter == null)
            return;

        if (mHud == null)
        {
            mHud = ResourceMgr.Instance.GetGoFromPool(Constants.UIPath, HUD_SKILLNAME_PREFAB);
            DebugHelper.Assert(mHud != null, "wtf?");
            if (mHud == null)
            {
                return;
            }

            Transform hudPanel = BattleFlyWordMgr.Instance.HudRootTrans;
            if (hudPanel != null)
            {
                mHud.transform.SetParent(hudPanel, true);
                mHud.transform.localScale = Vector3.one;
                mHud.transform.localRotation = Quaternion.identity;
            }

            RectTransform rt = mHud.GetComponent<RectTransform>();
            rt.anchorMin = Vector2.zero;
            rt.anchorMax = Vector2.one;
            rt.anchoredPosition3D = Vector3.zero;
            rt.offsetMin = rt.offsetMax = Vector2.zero;


            Transform item = mHud.transform.Find("Item");
            mAnimator = item.GetComponent<Animator>();
            mAnimator.logWarnings = false;
            mItemRt = item.GetComponent<RectTransform>();

            mSkillName = item.Find("name").GetComponent<Text>();

            mSingGo = item.Find("Sing").gameObject;
            mSingImage = item.getGameObject("Sing/singImg").GetComponent<Image>();
            mSingGo.SetActive(false);

            mCastingGo = item.Find("Working").gameObject;
            mCastingImage = item.getGameObject("Working/workingImg").GetComponent<Image>();
            mCastingAdd = item.getGameObject("Working/workingAdd").GetComponent<Image>();
            mCastingGo.SetActive(false);

            mBreakGo = item.Find("Broken").gameObject;
            mBreakGo.SetActive(false);
        }
        SetVisible(false);
    }

    private void ResetHudUI()
    {
        if (mHud == null || mFighter == null)
        {
            return;
        }

        Transform hudPanel = BattleFlyWordMgr.Instance.HudRootTrans;
        if (hudPanel != null)
        {
            mHud.transform.SetParent(hudPanel, true);
            mHud.transform.localScale = Vector3.one;
            mHud.transform.localRotation = Quaternion.identity;
        }

        SetVisible(false);
    }

    private void OnShowSkillName(CoreEvent<Fighter> ce)
    {
        Fighter fighter = ce.Data;
        if (fighter != mFighter) return;

        OnShowSkillName(ce.Param.ToString());
    }

    public void OnShowSkillName(string skillName)
    {
        RemoveAutoTimer();
        mSkillName.text = skillName;
        SetVisible(true);
        mAutoTimer = TimerManager.Instance.AddTimer((int)(c_miniShowTime * 1000), 1, OnHideSkillNameTimer);
        LateUpdate(0);
    }

    private void OnHideSkillNameTimer(int seq)
    {
        SetVisible(false);
        mAutoTimer = 0;
    }

    public void OnBeginSing(float totalTime)
    {
        if (totalTime > c_miniShowTime )
            RemoveAutoTimer();

        mSingGo.SetActive(true);
        mCastingGo.SetActive(false);
        mBreakGo.SetActive(false);
    }

    public void OnUpdateSing(float totalTime, float leftTime)
    {
        if (mSingImage != null)
        {
            mSingImage.fillAmount = (totalTime - leftTime) / totalTime;
        }
    }

    public void OnEndSing()
    {
        mSingGo.SetActive(false);
        if (mAutoTimer == 0)
            SetVisible(false);
    }

    float totalCastingTime = 0;
    float curentCastingTime = 0;
    public void OnCasting(float totalTime, bool vis)
    {
        if(totalTime > c_miniShowTime)
            RemoveAutoTimer();

        if (mAnimator != null)
        {
            if (vis)
            {
                mCastingImage.fillAmount = 1;
                mCastingAdd.fillAmount = 1;
                totalCastingTime = totalTime;
                curentCastingTime = totalCastingTime;
                mAnimator.Play("Working");
            }
            else
            {
                if(mAutoTimer == 0)
                    SetVisible(false);
            }
        }
        mCastingGo.SetActive(vis);
    }

    public void OnSkillBreak()
    {
        if (mAnimator == null) return;

        if (mHideBreakTimer == 0) return;//已经打断

        if (mCastingGo.activeSelf || mSingGo.activeSelf)
        {
            mBreakGo.SetActive(true);
            mAnimator.Play("Broken");
            mHideBreakTimer = TimerManager.Instance.AddTimer(1000, 1, OnHideBreakGo);
        }
    }

    private void OnHideBreakGo(int timerSequence)
    {
        mHideBreakTimer = 0;
        if (null != mBreakGo)
            mBreakGo.SetActive(false);        
    }

    private void RemoveAutoTimer()
    {
        if (mAutoTimer > 0) {
            TimerManager.Instance.RemoveTimer(mAutoTimer);
            mAutoTimer = 0;
        }
    }
}
