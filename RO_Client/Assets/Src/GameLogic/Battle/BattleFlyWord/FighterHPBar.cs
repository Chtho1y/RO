using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class FighterHPBar
{
    public const string HUD_HERO_PREFAB = "Battle/HPBar";

    private GameObject mHud;
    private RectTransform mItemRt = null;

    private GameObject mBloodGo;
    private Image mBloodImage;
    private Vector3 m_bloodPos;
    private Fighter mFighter = null;

    private bool m_bloodDirty = false;
    private bool m_hudLogicVisible = false;

    public void Born(Fighter owner)
    {
        mFighter = owner;
        mHud = null;
        mBloodImage = null;
        mItemRt = null;
        m_bloodPos = Vector3.zero;
    }

    public void Dispose()
    {
        if (mHud != null)
        {
            ResourceMgr.Instance.RecycleGO(Constants.UIPath, HUD_HERO_PREFAB, mHud);
        }

        mItemRt = null;
        mHud = null;
        mBloodImage = null;
        m_bloodPos = Vector3.zero;
    }

    public void Destroy()
    {
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
            mHud.name = mFighter.Ctrl.name + "_hpbar";
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
        if (null == mHud)
            return;
        mHud.SetActive(false);
        setHudLogicVisible(false);
    }

    public void OnActorRevive()
    {
        if (mFighter == null) return;

        setHudLogicVisible(false);
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
            if (m_bloodDirty)
            {
                m_bloodDirty = false;
                mHud.SetActive(false);
            }
            return;
        }

        if (!BattleCamera.Instance.BattleCameraEnabled) return;
        

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
    }

    public void OnLifeChanged(int life, int maxLife)
    {
        if (life < maxLife)
            setHudLogicVisible(true);

        UpdateBloodBar(life, maxLife);
    }

    private void setHudLogicVisible(bool isVisible)
    {
        m_hudLogicVisible = isVisible;
        refreshHudVisible();
    }

    private void refreshHudVisible()
    {
        if (null != mHud)
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

            Transform item = mHud.transform.Find("Item");    
            mItemRt = item.GetComponent<RectTransform>();

            mBloodGo = item.Find("HP").gameObject;
            mBloodImage = item.Find("HP/bloodImg").GetComponent<Image>();

            DebugHelper.Assert(mBloodImage != null);

            if (mBloodImage != null)
            {
                if (mFighter.Life > 0)
                {
                    mBloodImage.fillAmount = ((float)mFighter.Life / (float)mFighter.MaxLife);
                }
                else
                {
                    mBloodImage.fillAmount = 0;
                }
            }
        }
        setHudLogicVisible(false);
    }

    private void ResetHudUI()
    {
        if (mHud == null || mFighter == null || mBloodImage == null)
        {
            return;
        }

        if (mFighter.Life > 0)
        {
            mBloodImage.fillAmount = ((float)mFighter.Life / (float)mFighter.MaxLife);
        }
        else
        {
            mBloodImage.fillAmount = 0;
        }

        mBloodGo.SetActive(true);

        //添加到对应的Panel
        Transform hudPanel = BattleFlyWordMgr.Instance.HudRootTrans;
        if (hudPanel != null)
        {
            mHud.transform.SetParent(hudPanel, true);
            mHud.transform.localScale = Vector3.one;
            mHud.transform.localRotation = Quaternion.identity;
        }
        setHudLogicVisible(true);
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
        }
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
                }
            }
        }
    }
}
