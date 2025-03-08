using UnityEngine;
using System.Collections;
using TMPro;

public class SkillName3D
{
    public const string HUD_SKILLNAME_PREFAB = "Battle/SkillNameText";

    private TextMeshPro mSkillName;
    private GameObject mHud;
    private Fighter mFighter = null;
    Vector3 m_bloodPos;
    public void Born(Fighter owner)
    {
        mFighter = owner;
        mHud = null;
        //EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_FIGHTER_DO_SKILL, OnShowSkillName);
    }

    public void Dispose()
    {
        if (mHud != null)
        {
            ResourceMgr.Instance.RecycleGO(Constants.UI3DPath, HUD_SKILLNAME_PREFAB, mHud);
        }

        mHud = null;
    }

    public void Destroy()
    {
        //EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_FIGHTER_DO_SKILL, OnShowSkillName);
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
            mHud.name = mFighter.Ctrl.name + "_skillNameHud";
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
            ResourceMgr.Instance.RecycleGO(Constants.UI3DPath, HUD_SKILLNAME_PREFAB, mHud);
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
        if (mHud.activeSelf && Camera.main!=null && Camera.main.enabled)
        {
            Vector3 hudPosition = curUIPointPos + mFighter.Actor.AvatarData.skillNamePos;
            Vector3 curBloodPos = Camera.main.WorldToScreenPoint(hudPosition);
            bool isNeedUpdateUIHud = (m_bloodPos != curBloodPos);
            m_bloodPos = curBloodPos;

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
            mHud = ResourceMgr.Instance.GetGoFromPool(Constants.UI3DPath, HUD_SKILLNAME_PREFAB);
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

            mSkillName = mHud.transform.Find("name").GetComponent<TextMeshPro>();
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

        Transform child = root.Find("SkillNames");
        if (child == null)
        {
            DebugHelper.LogError("WTF????");
        }
        return child;
    }

    private void OnShowSkillName(CoreEvent<Fighter> ce)
    {
        Fighter fighter = ce.Data;
        if (fighter != mFighter) return;

        string skillName = ce.Param.ToString();
        mSkillName.text = skillName;
        SetVisible(true);
        TimerManager.Instance.AddTimer(2000, 1, OnHideSkillNameTimer);
    }

    private void OnHideSkillNameTimer(int seq)
    {
        SetVisible(false);
    }

}
