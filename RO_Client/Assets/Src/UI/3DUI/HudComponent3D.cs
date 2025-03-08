using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class HudComponent3D
{
    public const string HUD_HERO_PREFAB = "Battle/Blood_Bar_Hero";
    private const int DEPTH = 30;

    private GameObject mHud;
    private Sprite3D mBloodBg;
    private Sprite3D mBloodImage;
    private Sprite3D mSpImage;
    private Sprite3D mSpBg;
    private Sprite3D mSingImage;
    private Sprite3D mCastingImage;
    private Sprite3D mBossShockImage;

    private Vector3 m_bloodPos;
    private bool m_bloodDirty = false;
    private bool m_hudLogicVisible = false;
    private bool m_updateSing = false;
    private bool m_showShock = false;
    private float m_beginShowShockTime = 0;


    private Fighter mFighter = null;
    public void Born(Fighter owner)
    {
        mFighter = owner;
        mHud = null;
        mBloodBg = null;
        mBloodImage = null;
        mSpImage = null;     
        m_bloodPos = Vector3.zero;

        //EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_FIGHTER_LIFE_CHANGED, OnLifeChanged);
        //EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_FIGHTER_ENERGY_CHAGNED, OnSpChanged);
        //EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_SKILL_BEGIN_SING, OnBeginSing);
        //EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_SKILL_FRESH_SING, OnUpdateSing);
        //EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_SKILL_END_SING, OnEndSing);
        //EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_BOSS_SPAWNED, OnBossSpawned);
        //EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_SHOW_SKILL_REPEATCASTING, OnShowRepeatCasting);
    }

    public void Dispose()
    {
        if (mHud != null)
        {
            ResourceMgr.Instance.RecycleGO(Constants.UI3DPath, HUD_HERO_PREFAB, mHud);
        }

        mHud = null;
        mBloodBg = null;
        mBloodImage = null;
        mSpImage = null;
        mSingImage = null;
        mCastingImage = null;
        mBossShockImage = null;
        m_bloodPos = Vector3.zero;
    }

    public void Destroy()
    {
        //EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_FIGHTER_LIFE_CHANGED, OnLifeChanged);
        //EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_FIGHTER_ENERGY_CHAGNED, OnSpChanged);
        //EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_SKILL_BEGIN_SING, OnBeginSing);
        //EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_SKILL_FRESH_SING, OnUpdateSing);
        //EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_SKILL_END_SING, OnEndSing);
        //EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_BOSS_SPAWNED, OnBossSpawned);
        //EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_SHOW_SKILL_REPEATCASTING, OnShowRepeatCasting);
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
            mHud.name = mFighter.Ctrl.name +"_hud";
        }
#endif
        ResetHudUI();
    }

    public void Deactive()
    {
        setHudLogicVisible(false);
    }

    public void OnActorDead()
    {
        if (mFighter == null) return;

        setHudLogicVisible(false);
    }

    public void OnActorRevive()
    {
        if (mFighter == null) return;

        setHudLogicVisible(false);
    }

    public void LateUpdate()
    {
        if (mHud == null) return;

        if(mFighter == null)
        {
            ResourceMgr.Instance.RecycleGO(Constants.UI3DPath,HUD_HERO_PREFAB, mHud);
            mHud = null;
            return;
        }

        // 这几种情况不需要更新下面的东西，太费了
        if (!mFighter.IsVisible)
        {
            return;
        }

        if (!BattleCamera.Instance.BattleCameraEnabled) return;

        Vector3 curUIPointPos = mFighter.Ctrl.GetUIPointPos();

        // 血条可见性需要修改
        if (m_bloodDirty)
        {
            m_bloodDirty = false;

            bool result = m_hudLogicVisible && mFighter.IsVisible;
            mHud.SetActive(result);
        }

        // Update Hud
        if (mHud.activeSelf)
        {
            Vector3 hudPosition = curUIPointPos + mFighter.Actor.AvatarData.bloodBarPos;
            Vector3 curBloodPos = Camera.main.WorldToScreenPoint(hudPosition);
            bool isNeedUpdateUIHud = (m_bloodPos != curBloodPos);
            m_bloodPos = curBloodPos;

            if (isNeedUpdateUIHud)
            {
                UpdateUIHud(ref curBloodPos);
            }
        }

        if(m_showShock )
        {
            float showShockedTime = Time.realtimeSinceStartup - m_beginShowShockTime;
            if (showShockedTime >= 2)
            {
                mBossShockImage.gameObject.SetActive(false);
                m_showShock = false;
            }
        }

        if(curentCastingFrame > 0 && mCastingImage!=null)
        {
            mCastingImage.fillAmount = curentCastingFrame * 1.0f / totalCastingFrame;
            curentCastingFrame--;
        }
    }

    int totalCastingFrame = 0;
    int curentCastingFrame = 0;
    private void OnShowRepeatCasting(CoreEvent<Fighter> ce)
    {
        if (ce.Data != mFighter) return;

        if(mCastingImage!=null)
        {
            bool vis = (bool)ce.Param2;
            totalCastingFrame = (int)ce.Param;
            curentCastingFrame = totalCastingFrame;
            mCastingImage.gameObject.SetActive(vis);
            mCastingImage.fillAmount = 1;
            setHudLogicVisible((mFighter.Life < mFighter.MaxLife) || vis);
        }
    }

    private void OnBeginSing(CoreEvent<Fighter> ce)
    {
        Fighter fighter = ce.Data;
        if (fighter != mFighter) return;

        curentCastingFrame = 0;
        totalCastingFrame = 0;
        mSingImage.gameObject.SetActive(true);
        mSpImage.gameObject.SetActive(false);
        setHudLogicVisible(true);
    }

    private void OnUpdateSing(CoreEvent<Fighter> ce)
    {
        if (ce.Data != mFighter) return;

        if (mSingImage != null)
        {
            int leftTime = (int)ce.Param2;
            int totalTime = (int)ce.Param;
            mSingImage.fillAmount = ((totalTime - leftTime) * 1.0f) / totalTime;
        }
        
    }

    private void OnEndSing(CoreEvent<Fighter> ce)
    {
        if (mSingImage == null) return;

        Fighter fighter = ce.Data;
        if (fighter != mFighter) return;

        mSingImage.gameObject.SetActive(false);
        mSpImage.gameObject.SetActive(true);
        setHudLogicVisible(mFighter.Life < mFighter.MaxLife);
    }

    private void OnBossSpawned(CoreEvent<Fighter> ce)
    {
        Fighter fighter = ce.Data;
        if (fighter != mFighter) return;

        mBloodBg.gameObject.SetActive(false);
        mBloodImage.gameObject.SetActive(false);
        mSpImage.gameObject.SetActive(false);
        mSpBg.gameObject.SetActive(false);
        mSingImage.gameObject.SetActive(false);
        mCastingImage.gameObject.SetActive(false);
        mBossShockImage.gameObject.SetActive(true);
        m_showShock = true;
        m_beginShowShockTime = Time.realtimeSinceStartup;
        setHudLogicVisible(true);
    }

    private void OnLifeChanged(CoreEvent<Fighter> ev)
    {
        Fighter fighter = ev.Data;
        if (fighter != mFighter) return;

        if (mFighter.Life < mFighter.MaxLife)
            setHudLogicVisible(true);

        UpdateBloodBar(mFighter.Life, mFighter.MaxLife);
    }
    ///-------------------------------------------------
    /// 更新血条值
    ///-------------------------------------------------
    private void UpdateBloodBar(int curValue, int maxValue)
    {
        if (mHud != null && maxValue != 0)
        {
            if ((curValue == 0 ||  curValue >= maxValue) && mFighter.IsDisposed)
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
                        if (lastVal>0.5f && mBloodImage.fillAmount < 0.5f)
                        {
                            mBloodImage.spriteName = "Bar_HP_yellow";
                        }
                    }
                    else
                    {
                        if(lastVal > 0.2f && mBloodImage.fillAmount < 0.2f)
                        {
                            mBloodImage.spriteName = "Bar_HP_red";
                        }
                    }
                }
            }
        }
    }

    private void OnSpChanged(CoreEvent<Fighter> ce)
    {
        Fighter fighter = ce.Data;
        if (fighter != mFighter) return;

        if (mSpImage != null )
        {
            mSpImage.fillAmount = ((float)mFighter.Sp / mFighter.MaxSp);
            if (mFighter.IsPlayer)
            {
                mSpImage.gameObject.SetActive(true);
                mSpBg.gameObject.SetActive(true);
            }
        }

        if(fighter == BattleMgr.Instance.Battle.FighterMgr.self)
            setHudLogicVisible(true);
    }

    private void setHudLogicVisible(bool isVisible)
    {
        m_hudLogicVisible = isVisible;
        refreshHudVisible();
    }

    private void refreshHudVisible()
    {
        if (mHud)
        {
            bool result = m_hudLogicVisible && mFighter.IsVisible;

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
            mHud = ResourceMgr.Instance.GetGoFromPool(Constants.UI3DPath, HUD_HERO_PREFAB);
            DebugHelper.Assert(mHud != null, "wtf?");
            if (mHud == null)
            {
                return;
            }

            Transform hudPanel = GetHudPanel();
            if (hudPanel != null)
            {
                mHud.transform.SetParent(hudPanel, true);
                mHud.transform.localScale = Vector3.one;
                mHud.transform.localRotation = Quaternion.identity;
            }

            mBloodBg = mHud.transform.Find("bloodBg").GetComponent<Sprite3D>();
            mBloodImage = mHud.transform.Find("bloodImg").GetComponent<Sprite3D>();
            DebugHelper.Assert(mBloodImage != null);

            if (mBloodImage != null)
            {
                mBloodImage.spriteName = mFighter.IsTeamMember ? "Bar_HP" : "Bar_HP_pink";
                if (mFighter.Life > 0)
                {
                    mBloodImage.fillAmount = ((float)mFighter.Life / (float)mFighter.MaxLife);
                }
                else
                {
                    mBloodImage.fillAmount = 0;
                }
            }

            GameObject energyFore = mHud.transform.getGameObject("spImg");
            if (energyFore != null)
            {
                mSpImage = energyFore.GetComponent<Sprite3D>();
            }

            mSpBg = mHud.transform.getGameObject("spBg").GetComponent<Sprite3D>();

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
                    mSpBg.gameObject.SetActive(false);
                }
            }

            mSingImage = mHud.transform.getGameObject("singImg").GetComponent<Sprite3D>();
            mSingImage.spriteName = "Bar_SP_green";
            mSingImage.gameObject.SetActive(false);

            mBossShockImage = mHud.transform.getGameObject("shock").GetComponent<Sprite3D>();
            mBossShockImage.gameObject.SetActive(false);

            mCastingImage = mHud.transform.getGameObject("singImg").GetComponent<Sprite3D>();
        }
        setHudLogicVisible(false);
    }

    private void ResetHudUI()
    {
        if (mHud == null || mFighter == null)
        {
            return;
        }

        mBloodImage.spriteName = mFighter.IsTeamMember ? "Bar_HP" : "Bar_HP_pink";

        if (mFighter.Life > 0)
        {
            mBloodImage.fillAmount = ((float)mFighter.Life / (float)mFighter.MaxLife);
        }
        else
        {
            mBloodImage.fillAmount = 0;
        }

        mSpImage.gameObject.SetActive(mFighter.IsPlayer);
        mSpBg.gameObject.SetActive(mFighter.IsPlayer);
        mBloodImage.gameObject.SetActive(true);
        mBloodBg.gameObject.SetActive(false);

        //添加到对应的Panel
        Transform hudPanel = GetHudPanel();
        if (hudPanel != null)
        {
            mHud.transform.SetParent(hudPanel, true);
            mHud.transform.localScale = Vector3.one;
            mHud.transform.localRotation = Quaternion.identity;
        }
        //Camera_UI3D.GetInstance().GetCurrentCanvas().RefreshLayout();
        setHudLogicVisible(false);
        m_bloodDirty = true;
    }

    ///-------------------------------------------------
    /// 更新UI Hud
    ///-------------------------------------------------
    private void UpdateUIHud(ref Vector3 bloodPosition)
    {
        if (mHud != null)
        {
            bloodPosition.Set(bloodPosition.x, bloodPosition.y, bloodPosition.z);

            var UI3D_Came = Camera_UI3D.GetInstance().GetCurrentCamera();
            if (UI3D_Came == null)
            {
                return;
            }
            mHud.transform.position = UI3D_Came.ScreenToWorldPoint(bloodPosition);
        }
    }

    //--------------------------------------------------
    /// 返回HudPanel控件
    //--------------------------------------------------
    private Transform GetHudPanel()
    {
        string UNKNOWN_PANEL = "Unknown_Panel";
        if (null == BattleCamera.Instance.RealCamera)
        {
            return null;
        }

        var UI3D_Came = Camera_UI3D.GetInstance().GetCurrentCamera();
        if (UI3D_Came == null)
        {
            return null; //有可能该局已经结束了，此时还在loading协程
        }

        Transform root = UI3D_Came.transform.Find("Hud");
        if (root == null)
        {
            GameObject hud = new GameObject("Hud");
            root = hud.transform;
            root.parent = UI3D_Came.transform;
            root.localPosition = Vector3.zero;
            root.localRotation = Quaternion.identity;
            root.localScale = Vector3.one;

            string[] objNames = new string[5] { "Panel_MonsterHud", "Panel_HeroHud", "FloatTexts", "SkillNames", UNKNOWN_PANEL };
            for (int i = 0; i < objNames.Length; ++i)
            {
                GameObject childGO = new GameObject(objNames[i]);
                Transform childTrans = childGO.transform;
                childTrans = childGO.transform;
                childTrans.SetParent(root);
                childTrans.localPosition = Vector3.zero;
                childTrans.localRotation = Quaternion.identity;
                childTrans.localScale = Vector3.one;
            }
        }

        string childName = "";

        if (mFighter.IsNpc)
        {
            childName = "Panel_MonsterHud";
        }
        else if (mFighter.IsPlayer)
        {
            childName = "Panel_HeroHud";
        }

        if (string.IsNullOrEmpty(childName))
        {
            childName = UNKNOWN_PANEL;
        }

        Transform child = root.Find(childName);
        if (child == null)
        {
            DebugHelper.LogError("WTF????");
        }
        return child;
    }
}
