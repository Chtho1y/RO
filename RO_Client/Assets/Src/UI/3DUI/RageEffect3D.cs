using UnityEngine;
using System.Collections;

public class RageEffect3D
{
    public const string HUD_RAGE_PREFAB = "Battle/RageImage";
    private GameObject mHud;
    private Fighter mFighter = null;
    Vector3 m_ragePos;

    public void Born(Fighter owner)
    {
        mFighter = owner;
        mHud = null;
        //EventMgr.AddEventListener<bool>(ECoreEventType.EID_BOSS_IN_RAGE, OnShowRage);
    }

    public void Dispose()
    {
        if (mHud != null)
        {
            ResourceMgr.Instance.RecycleGO(Constants.UI3DPath, HUD_RAGE_PREFAB, mHud);
        }

        mHud = null;
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
            mHud.name = mFighter.Ctrl.name + "_RageHud";
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
            ResourceMgr.Instance.RecycleGO(Constants.UI3DPath, HUD_RAGE_PREFAB, mHud);
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
            Vector3 curBloodPos = Camera.main.WorldToScreenPoint(hudPosition);
            bool isNeedUpdateUIHud = (m_ragePos != curBloodPos);
            m_ragePos = curBloodPos;

            if (isNeedUpdateUIHud)
            {
                UpdateUIHud(ref curBloodPos);
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
            mHud = ResourceMgr.Instance.GetGoFromPool(Constants.UI3DPath, HUD_RAGE_PREFAB);
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
        }
        SetVisible(false);
    }

    private void ResetHudUI()
    {
        if (mHud == null || mFighter == null)
        {
            return;
        }

        //添加到对应的Panel
        Transform hudPanel = GetHudPanel();
        if (hudPanel != null)
        {
            mHud.transform.SetParent(hudPanel, true);
            mHud.transform.localScale = Vector3.one;
            mHud.transform.localRotation = Quaternion.identity;
        }
        //Camera_UI3D.GetInstance().GetCurrentCanvas().RefreshLayout();
        SetVisible(false);
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

    private Transform GetHudPanel()
    {
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
        Transform child = root.Find("SkillNames");
        if (child == null)
        {
            DebugHelper.LogError("WTF????");
        }
        return child;
    }

    private void OnShowRage(CoreEvent<bool> ce)
    {
        bool rage = ce.Data;
        SetVisible(rage);
    }
}
