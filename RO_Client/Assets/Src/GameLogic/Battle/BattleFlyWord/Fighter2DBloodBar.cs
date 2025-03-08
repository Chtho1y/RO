using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using System.Collections.Generic;

public class Fighter2DBloodBar
{
    public const string HUD_HERO_PREFAB = "Battle/BloodBarHero";

    private GameObject mHud;
    private RectTransform mItemRt = null;

    private GameObject mBloodGo;
    private Image mBloodImage;

    private GameObject mSpGo;
    private Image mSpImage;

    private GameObject mSingGo;
    private Image mSingImage;

    private GameObject mCastingGo;
    private Image mCastingAdd;
    private Image mCastingImage;

    private GameObject mBreakGo;

    private Image mBossShockImage;
    private SwitchSprite mBloodSprites = null;
    private LoopHorizontalScrollRect mScrollRect = null;
    private RectTransform mScrollRt = null;
    private List<string> icons = null;

    private Vector3 m_bloodPos;

    private bool m_bloodDirty = false;
    private bool m_hudLogicVisible = false;
    private bool m_updateSing = false;
    private bool m_showShock = false;
    private float m_beginShowShockTime = 0;
    private Fighter mFighter = null;
    private Animator mAnimator = null;
    int mHideBreakTimer = 0;

    private float mBloodHeight;
    private float mSpHeight;
    private float mBuffIconHeight;

    float mShowTime = 2.0f;

    bool registered = false;
    void RegisterEvents()
    {
        if (registered) return;

        registered = true;
        //EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_SHOW_BUFF_ICON, OnShowIcon);
        //EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_REMOVE_BUFF_ICON, OnRemoveBuffIcon);
        //EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_FIGHTER_LIFE_CHANGED, OnLifeChanged);
        //EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_FIGHTER_ENERGY_CHAGNED, OnSpChanged);
        //EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_SKILL_BEGIN_SING, OnBeginSing);
        //EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_SKILL_FRESH_SING, OnUpdateSing);
        //EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_SKILL_END_SING, OnEndSing);
        //EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_SHOW_SKILL_REPEATCASTING, OnShowRepeatCasting);
        //EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_SKILL_BREAK, OnSkillBreak);
    }

    void UnRegisterEvents()
    {
        registered = false;
        //EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_FIGHTER_LIFE_CHANGED, OnLifeChanged);
        //EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_FIGHTER_ENERGY_CHAGNED, OnSpChanged);
        //EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_SKILL_BEGIN_SING, OnBeginSing);
        //EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_SKILL_FRESH_SING, OnUpdateSing);
        //EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_SKILL_END_SING, OnEndSing);
        //EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_SHOW_SKILL_REPEATCASTING, OnShowRepeatCasting);
        //EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_SHOW_BUFF_ICON, OnShowIcon);
        //EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_REMOVE_BUFF_ICON, OnRemoveBuffIcon);
        //EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_SKILL_BREAK, OnSkillBreak);
    }

    public void Born(Fighter owner)
    {
        mFighter = owner;
        mHud = null;
        mBloodImage = null;
        mSpImage = null;
        mItemRt = null;
        m_bloodPos = Vector3.zero;

        if (icons == null)
            icons = new List<string>();
        else
            icons.Clear();
    }

    public void Dispose()
    {
        if (mHud != null)
        {
            ResourceMgr.Instance.RecycleGO(Constants.UIPath, HUD_HERO_PREFAB, mHud);
        }

        if(mHideBreakTimer > 0)
        {
            TimerManager.Instance.RemoveTimer(mHideBreakTimer);
            mHideBreakTimer = 0;
        }
        mItemRt = null;
        mHud = null;
        mBloodImage = null;
        mSpImage = null;
        mSingImage = null;

        mCastingGo = null;
        mCastingAdd = null;
        mCastingImage = null;

        mBossShockImage = null;
        mAnimator = null;

        m_bloodPos = Vector3.zero;
        if (icons != null)
            icons.Clear();
    }

    public void Destroy()
    {
        UnRegisterEvents();
        Dispose();
    }

    public void Prepare()
    {
        InitHudUI();
        mHud.SetActive(false);
    }

    public void Fight()
    {
#if UNITY_EDITOR
        if (mHud)
        {
            mHud.name = mFighter.Ctrl.name + "_hud";
        }
#endif
        ResetHudUI();
        RegisterEvents();
    }

    public void Deactive()
    {
        setHudLogicVisible(false);
    }

    public void OnActorDead()
    {
        if (mFighter == null) return;

        setHudLogicVisible(false);
        UnRegisterEvents();

        if(icons!=null)
        {
            ClearIcon();
        }
    }

    public void OnActorRevive()
    {
        if (mFighter == null) return;

        setHudLogicVisible(false);
        RegisterEvents();
    }

    public void LateUpdate(float deltaTime)
    {
        if (mHud == null) return;

        if (mFighter == null)
        {
            ResourceMgr.Instance.RecycleGO(Constants.UIPath, HUD_HERO_PREFAB, mHud);
            mHud = null;
            return;
        }

        // 这几种情况不需要更新下面的东西，太费了
        if (!mFighter.IsVisible)
        {
            if(m_bloodDirty)
            {
                m_bloodDirty = false;
                mHud.SetActive(false);
            }
            return;
        }

        if (!BattleCamera.Instance.BattleCameraEnabled) return;

        if (mShowTime > 0)
        {
            mShowTime -= deltaTime;
            if (mShowTime <= 0)
            {
                setHudLogicVisible(false);
                return;
            }
        }

        Vector3 curUIPointPos = mFighter.Ctrl.GetUIPointPos();

        // 血条可见性需要修改
        if (m_bloodDirty)
        {
            m_bloodDirty = false;

            bool result = m_hudLogicVisible && mFighter.IsVisible && mFighter.IsAlive && mFighter.IsFighting;
            mHud.SetActive(result);
        }

        // Update Hud
        //if (mHud.activeSelf)
        {
            Vector3 hudPosition = curUIPointPos + mFighter.Actor.AvatarData.bloodBarPos;
            Vector3 curBloodPos = Camera.main.WorldToViewportPoint(hudPosition);
            bool isNeedUpdateUIHud = (m_bloodPos != curBloodPos);
            m_bloodPos = curBloodPos;

            if (isNeedUpdateUIHud)
            {
                UpdateUIHud(ref curBloodPos);
            }
        }

        if (m_showShock)
        {
            float showShockedTime = Time.realtimeSinceStartup - m_beginShowShockTime;
            if (showShockedTime >= 2)
            {
                mBossShockImage.gameObject.SetActive(false);
                m_showShock = false;
            }
        }

        if (curentCastingTime > 0 && mCastingImage != null)
        {
            mCastingImage.fillAmount = curentCastingTime / totalCastingTime;
            if (mCastingAdd != null)
                mCastingAdd.fillAmount = mCastingImage.fillAmount;
            curentCastingTime -= deltaTime;
        }
    }

    float totalCastingTime = 0;
    float curentCastingTime = 0;
    public void OnShowRepeatCasting(float totalTime,bool vis)
    {
        if (mCastingImage != null && mCastingImage.gameObject.activeInHierarchy)
        {
            if (mAnimator != null)
            {
                if (vis)
                {
                    mCastingImage.fillAmount = 1;
                    mCastingAdd.fillAmount = 1;
                    totalCastingTime = totalTime;
                    curentCastingTime = totalCastingTime;
                    mAnimator.Play("working");
                    mSpGo.SetActive(false);
                }
                else
                {
                    if(curentCastingTime < totalCastingTime)
                    {
                        mAnimator.Play("broken");
                    }
                    else
                    {
                        mAnimator.Play("idle");
                    }
                }
            }
            mCastingGo.SetActive(vis);
        }
    }

    public void OnBeginSing()
    {
        curentCastingTime = 0;
        totalCastingTime = 0;
        mSingGo.SetActive(true);
        mSpGo.SetActive(false);
        mCastingGo.SetActive(false);
        mBreakGo.SetActive(false);
    }

    public void OnUpdateSing(float totalTime,float leftTime)
    {
        if (mSingImage != null)
        {
            mSingImage.fillAmount = (totalTime - leftTime) / totalTime;
        }

    }

    public void OnEndSing()
    {
        if (mSingImage == null) return;

        mSingGo.SetActive(false);
        mBloodGo.SetActive(mFighter.Life < mFighter.MaxLife);
    }

    //private void OnBossSpawned(CoreEvent<Fighter> ce)
    //{
    //    Fighter fighter = ce.Data;
    //    if (!mFighter.IsHero) return;

    //    mBloodGo.SetActive(false);
    //    mSingGo.SetActive(false);
    //    mSpGo.SetActive(false);
    //    mBreakGo.SetActive(false);
    //    mBossShockImage.gameObject.SetActive(true);
    //    m_showShock = true;
    //    m_beginShowShockTime = Time.realtimeSinceStartup;
    //}

    public void OnLifeChanged(int life, int maxLife)
    {
        if (life < maxLife)
            setHudLogicVisible(true);

        if(mBloodGo!=null)
            mBloodGo.SetActive(true);
        UpdateBloodBar(life, maxLife);
    }
    ///-------------------------------------------------
    /// 更新血条值
    ///-------------------------------------------------
    private void UpdateBloodBar(int curValue, int maxValue)
    {
        if (mHud != null && maxValue != 0)
        {
            if ((curValue == 0 || curValue >= maxValue) && mFighter.IsDisposed)
            {
                setHudLogicVisible(false);
            }
            else
            {
                setHudLogicVisible(true);
                if (mBloodImage != null)
                {
                    float lastVal = mBloodImage.fillAmount;

                    mBloodImage.fillAmount = ((float)curValue / (float)maxValue);
                    if (mFighter.Actor.IsNpc)
                    {
                        if (lastVal > 0.5f && mBloodImage.fillAmount < 0.5f)
                        {
                            mBloodImage.sprite = mBloodSprites.GetSprite("Bar_HP_yellow");
                        }
                    }
                    else
                    {
                        if (lastVal > 0.2f && mBloodImage.fillAmount < 0.2f)
                        {
                            mBloodImage.sprite = mBloodSprites.GetSprite("Bar_HP_red");
                        }
                    }
                }
            }
        }
    }

    public void OnSpChanged(float sp,int maxSp)
    {
        if (mSpImage != null)
        {
            mSpImage.fillAmount = ((float)sp / maxSp);
            if (mFighter.IsPlayer)
            {
                mSpGo.SetActive(true);
            }
        }
    }

    private void setHudLogicVisible(bool isVisible)
    {
        m_hudLogicVisible = isVisible;
        refreshHudVisible();
        if (isVisible)
            mShowTime = 2;
    }

    private void refreshHudVisible()
    {
        if (mHud)
        {
            bool result = m_hudLogicVisible && mFighter.IsVisible && mFighter.IsFighting;

            if (result != mHud.activeSelf)
            {
                m_bloodDirty = true;     
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
           
            mHud = ResourceMgr.Instance.GetGoFromPool(Constants.UIPath, HUD_HERO_PREFAB);
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

            //Canvas hudCanvas = mHud.GetComponent<Canvas>();
            //hudCanvas.overrideSorting = true;
            //hudCanvas.sortingOrder = mFighter.IsPlayer ? 1:0;

            Transform item = mHud.transform.Find("Item");

            mAnimator = item.GetComponent<Animator>();
            mItemRt = item.GetComponent<RectTransform>();

            mBloodGo = item.Find("HP").gameObject;
            mBloodImage = item.Find("HP/bloodImg").GetComponent<Image>();

            RectTransform tempRT = mBloodGo.GetComponent<RectTransform>();
            mBloodHeight = tempRT.rect.height;
            DebugHelper.Assert(mBloodImage != null);

            if (mBloodImage != null)
            {
                mBloodSprites = mBloodImage.GetComponent<SwitchSprite>();

                mBloodImage.sprite = mBloodSprites.GetSprite(mFighter.IsTeamMember ? "Bar_HP" : "Bar_HP_pink");
                if (mFighter.Life > 0)
                {
                    mBloodImage.fillAmount = ((float)mFighter.Life / (float)mFighter.MaxLife);
                }
                else
                {
                    mBloodImage.fillAmount = 0;
                }
            }

            mSpGo = item.Find("Sp").gameObject;
            GameObject energyFore = item.getGameObject("Sp/spImg");
            if (energyFore != null)
            {
                mSpImage = energyFore.GetComponent<Image>();
            }

            tempRT = mSpGo.GetComponent<RectTransform>();
            mSpHeight = tempRT.rect.height;

            DebugHelper.Assert(mSpImage != null);
            if (mSpImage != null)
            {
                if (mFighter.Sp > 0)
                {
                    mSpImage.fillAmount = ((float)mFighter.Sp / mFighter.MaxSp);
                }
                else
                {
                    energyFore.SetActive(false);
                }
                mSpGo.SetActive(mFighter.Sp > 0);
            }


            mBossShockImage = item.getGameObject("shock").GetComponent<Image>();
            mBossShockImage.gameObject.SetActive(false);

            mSingGo = item.Find("Sing").gameObject;
            mSingImage = item.getGameObject("Sing/singImg").GetComponent<Image>();
            mSingGo.SetActive(false);

            mCastingGo = item.Find("Working").gameObject;
            mCastingImage = item.getGameObject("Working/workingImg").GetComponent<Image>();
            mCastingAdd = item.getGameObject("Working/workingAdd").GetComponent<Image>();
            mCastingGo.SetActive(false);

            mBreakGo = item.Find("Broken").gameObject;
            mBreakGo.SetActive(false);
           
            mScrollRect = mItemRt.GetComponentInChildren<LoopHorizontalScrollRect>(true);
            if(mScrollRect!=null)
                mScrollRt = mScrollRect.GetComponent<RectTransform>(); 
        }
        setHudLogicVisible(false);
    }

    private void ResetHudUI()
    {
        if (mHud == null || mFighter == null)
        {
            return;
        }

        mBloodImage.sprite = mBloodSprites.GetSprite(mFighter.IsTeamMember ? "Bar_HP" : "Bar_HP_pink");

        if (mFighter.Life > 0)
        {
            mBloodImage.fillAmount = ((float)mFighter.Life / (float)mFighter.MaxLife);
        }
        else
        {
            mBloodImage.fillAmount = 0;
        }

        mSpGo.SetActive(mFighter.IsPlayer);
        mBloodGo.SetActive(true);
        mSingGo.SetActive(false);
        mCastingGo.SetActive(false);
        mBreakGo.SetActive(false);
        ClearIcon();

        //添加到对应的Panel
        Transform hudPanel = BattleFlyWordMgr.Instance.HudRootTrans;
        if (hudPanel != null)
        {
            mHud.transform.SetParent(hudPanel, true);
            mHud.transform.localScale = Vector3.one;
            mHud.transform.localRotation = Quaternion.identity;
        }
        setHudLogicVisible(false);
    }

    ///-------------------------------------------------
    /// 更新UI Hud
    ///-------------------------------------------------
    private void UpdateUIHud(ref Vector3 bloodPosition)
    {
        if (mItemRt != null)
        {
            bloodPosition.Set(bloodPosition.x, bloodPosition.y, bloodPosition.z);

            if (CameraMgr.Instance.UICamera == null)
            {
                return;
            }

            mItemRt.anchoredPosition3D = new Vector3((bloodPosition.x - 0.5f) * UIMgr.SCREEN_WIDTH, (bloodPosition.y - 0.5f) * UIMgr.SCREEN_HEIGHT, 0);
            //mItemRt.anchoredPosition3D = new Vector3(bloodPosition.x,bloodPosition.y,0);
        }
    }

    public void OnShowIcon(string iconName)
    {
        setHudLogicVisible(true);

        if (ExistIcon(iconName)) return;

        AddIcon(iconName);
    }

    public void OnRemoveBuffIcon(string iconName)
    {
        if (!ExistIcon(iconName)) return;

        RemoveIcon(iconName);
    }

    public void OnSkillBreak()
    {
        if (mAnimator == null) return;

        if(mCastingGo.activeSelf || mSingGo.activeSelf)
        {
            setHudLogicVisible(true);
            mBreakGo.SetActive(true);
            if(BloodIsVisible)
                mAnimator.Play("broken");
            mHideBreakTimer = TimerManager.Instance.AddTimer(1000, 1, OnHideBreakGo);
        }
    }

    void OnHideBreakGo(int timerSequence)
    {
        mBreakGo.SetActive(false);
        mHideBreakTimer = 0;
    }

    bool ExistIcon(string iconName)
    {
        if (icons == null) return false;

        for (int idx = 0; idx < icons.Count; idx++)
        {
            if (icons[idx].CompareTo(iconName) == 0) return true;
        }

        return false;
    }

    void AddIcon(string iconName)
    {
        icons.Add(iconName);
        RefreshIcon();
    }

    void RemoveIcon(string iconName)
    {
        icons.Remove(iconName);
        RefreshIcon();
    }

    void ClearIcon()
    {
        icons.Clear();
        if (mScrollRect != null)
        {
            mScrollRect.totalCount = 0;
            mScrollRect.ClearCells();
        }
    }

    Vector2 maxPos = new Vector2(0, 36);
    Vector2 minPos = new Vector2(0, 25);
    void RefreshIcon()
    {
        if (icons == null) return;

        if (mScrollRect == null) return;

        mScrollRect.gameObject.SetActive(icons.Count > 0);
        mScrollRect.totalCount = icons.Count;
        mScrollRect.CellCallback = SetIconData;
        if (icons.Count > 0)
            mScrollRect.RefreshCells();
        else
            mScrollRect.ClearCells();
    }

    void SetIconData(GameObject go, int idx)
    {
        if (idx < 0 || idx >= icons.Count) return;

        go.name = "icon" + idx;
        Image icon = go.GetComponent<Image>();
        if (icon != null)
        {
            ResourceMgr.Instance.LoadAsset<Sprite>((sprite, path, name) => { icon.sprite = sprite; }, Constants.IconDir, icons[idx]);
        }
    }

    public Vector3 BloodPos
    {
        get { return mItemRt.anchoredPosition3D; }
    }

    public float BloodHeight
    {
        get
        {
            return mBloodHeight + mSpHeight + mScrollRect.content.rect.height;
        }
    }

    public bool BloodIsVisible
    {
        get { return mHud.activeSelf; }
    }
}
