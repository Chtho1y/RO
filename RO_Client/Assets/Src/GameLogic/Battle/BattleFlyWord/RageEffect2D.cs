using UnityEngine;
using System.Collections;

public class RageEffect2D
{
    public const string HUD_RAGE_PREFAB = "Battle/RageImage";
    private GameObject mHud;
    private Fighter mFighter = null;
    private RectTransform mItemRt = null;
    Vector3 m_ragePos;

    public void Born(Fighter owner)
    {
        mFighter = owner;
        mHud = null;
        mItemRt = null;
        //EventMgr.AddEventListener<bool>(ECoreEventType.EID_BOSS_IN_RAGE, OnShowRage);
    }

    public void Dispose()
    {
        if (mHud != null)
        {
            ResourceMgr.Instance.RecycleGO(Constants.UIPath, HUD_RAGE_PREFAB, mHud);
        }

        mHud = null;
        mItemRt = null;
    }

    public void Destroy()
    {
        //EventMgr.RemoveEventListener<bool>(ECoreEventType.EID_BOSS_IN_RAGE, OnShowRage);
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
            mHud.name = mFighter.Ctrl.name + "_Rage";
        }
#endif
        ResetHudUI();
    }

    public void Deactive()
    {
        SetVisible(false);
    }

    public void OnActorDead()
    {
        if (mFighter == null) return;

        SetVisible(false);
    }

    public void OnActorRevive()
    {
        if (mFighter == null) return;

        SetVisible(false);
    }

    public void SetVisible(bool vis)
    {
        if (mHud == null) return;

        mHud.SetActive(vis);
    }

    public void LateUpdate()
    {
        if (mHud == null) return;

        if (mFighter == null)
        {
            ResourceMgr.Instance.RecycleGO(Constants.UIPath, HUD_RAGE_PREFAB, mHud);
            mHud = null;
            return;
        }

        // 这几种情况不需要更新下面的东西，太费了
        if (!mFighter.IsVisible)
        {
            return;
        }

        Vector3 curUIPointPos = mFighter.Ctrl.GetUIPointPos();
        // Update Hud
        if (mHud.activeSelf)
        {
            Vector3 hudPosition = curUIPointPos + mFighter.Actor.AvatarData.crazyPos;
            Vector3 curPos = Camera.main.WorldToViewportPoint(hudPosition);
            bool isNeedUpdateUIHud = (m_ragePos != curPos);
            m_ragePos = curPos;

            if (isNeedUpdateUIHud)
            {
                UpdateUIHud(ref curPos);
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
            mHud = ResourceMgr.Instance.GetGoFromPool(Constants.UIPath, HUD_RAGE_PREFAB);
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
            //hudCanvas.sortingOrder = 0;

            Transform item = mHud.transform.Find("Item");
            mItemRt = item.GetComponent<RectTransform>();
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

    ///-------------------------------------------------
    /// 更新UI Hud
    ///-------------------------------------------------
    private void UpdateUIHud(ref Vector3 curPos)
    {
        if (mItemRt != null)
        {
            mItemRt.anchoredPosition3D = new Vector3((curPos.x - 0.5f) * UIMgr.SCREEN_WIDTH, (curPos.y - 0.5f) * UIMgr.SCREEN_HEIGHT, 0);
        }
    }

    public void OnShowRage(bool rage)
    {
        SetVisible(rage);
    }
}
