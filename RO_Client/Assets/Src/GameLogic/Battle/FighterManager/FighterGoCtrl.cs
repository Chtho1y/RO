using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine.AI;

public class UIFixWordInfo
{
	public int x;
	public int y;
	public int randomX;
	public int randomY;

	public UIFixWordInfo (int vx, int vy, int vRandomX, int vRandomY)
	{
		x = vx;
		y = vy;
		randomX = vRandomX;
		randomY = vRandomY;
	}
}

public struct UIEventParamFighterHurt
{
    public Fighter mCaster;
	public Fighter mTarget;
	public int mHurtVal;
	public bool mIsCrit;
    public int mMultiSkillNum;
    public float mMultiKillInterval;
    public int mAttackSeq;
    public int mSkillId;
    public int mBuffId;
	public int mHurtByType;
    public int mLastDamage;
	// -1 未知， 0-5 技能类型 Id， 6 buff

	public UIEventParamFighterHurt (Fighter caster, Fighter target, 
        int hurtVal, bool isCrit, int hurtByType,int isMultiSkill,float killInterval,int seq,
        int skillId,int buffId,int lastDamage)
	{
        mCaster = caster;
		mTarget = target;
		mHurtVal = hurtVal;
		mIsCrit = isCrit;
        mMultiKillInterval = killInterval;
        mMultiSkillNum = isMultiSkill;
        mAttackSeq = seq;
        mHurtByType = hurtByType;
        mSkillId = skillId;
        mBuffId = buffId;
        mLastDamage = lastDamage;
	}
}

public class FighterGoCtrl : MonoBehaviour
{
    const string no_hit_sound = "none";

    GameObject mAvatarObject;
    bool mIsMirror = false;
    bool mIsLoading = false;
    bool mIsLoaded = false;

    BeHitColorChange mBeHitColorChange;
    FighterScaleInfo mFighterScaleInfo;
    Gray mGrayChange;
    Stiff mStiffCom;
    RimColor mRimColor;

    int mHitCommonEffectFlag = 0;

    int shadowEffectInstanceId = 0;
    int runsmokeEffectInstanceId = 0;
    int selfEffectInstanceId = 0;    //主角光环特效
    int bornEffectInstanceId = 0;
    bool mInSpecular = false;
    Dictionary<BodyPart, GameObject> mPartGoes = null;

    NavMeshAgent navAgent;
    #region property

    public Fighter Fighter { get; set; }

    private Animator mAnimator = null;
    public Animator Animator { get { return mAnimator; } }

    public bool IsLoaded { get { return mIsLoaded; } }

    public bool IsVisible {
        get { return mAvatarObject != null && mAvatarObject.activeInHierarchy; }
        set {
            if (mAvatarObject != null && mAvatarObject.activeInHierarchy != value) {
                mAvatarObject.SetActive(value);
                OnVisibleChanged();
            }
        }
    }

    public bool IsMirror {
        get { return mIsMirror; }
        set {
            if (mIsMirror != value) {
                mIsMirror = value;
            }
        }
    }

    #endregion //property

    #region monobehavior

    void Start()
    {
    }

    void OnEnable()
    {
        if (Fighter != null)
        {
            DebugHelper.LogError("OnEnable:" + Fighter.Name);
            Fighter.ForceSync(transform);
        }
    }

    void OnDestroy()
    {
        if (Fighter != null)
            Fighter.OnGoDestroy();
        Fighter = null;
        mAvatarObject = null;
        if (mBeHitColorChange != null)
        {
            GameObject.DestroyImmediate(mBeHitColorChange);
            mBeHitColorChange = null;
        }

        mFighterScaleInfo = null;

        if (mGrayChange != null)
            GameObject.DestroyImmediate(mGrayChange);
        mGrayChange = null;

        if (mRimColor != null)
            GameObject.DestroyImmediate(mRimColor);
        mRimColor = null;

        if (mStiffCom != null)
            GameObject.DestroyImmediate(mStiffCom);
        mStiffCom = null;

    }

    void Update()
    {
        if (null == Fighter)
            return;

        if (!Fighter.IsSpawned || Fighter.IsDisposed)
            return;

        if (!IsVisible)
            return;

        if (Fighter.IsNavRun)
            Fighter.SetPosition(transform.position); 
        else //if (Fighter.IsRun)
            UpdateCurrentPos(Time.deltaTime);        
    }

    #endregion

    #region event_callbacks

    public void OnSpawned()
    {
        IsVisible = true;
        ShowShadow();
        if (Fighter.BornEffectId > 0)
            bornEffectInstanceId = EffectManager.Instance.PlayEffect(Fighter.BornEffectId, Fighter, Fighter);

        EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_FIGHTER_SPAWN, Fighter));
    }

    public void OnRelive()
    {
        int reliveEffectId = GlobalConfig.Instance.GetConfigIntValue(GlobalConfig.c_relive_effectid);
        if (reliveEffectId > 0)
            EffectManager.Instance.PlayEffect(reliveEffectId, Fighter, Fighter);
        EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_FIGHTER_RELIVE, Fighter));
    }

    public void OnEnterTransfer()
    {
        int effectId = GlobalConfig.Instance.GetConfigIntValue(GlobalConfig.c_enter_transfer_effectId);
        if (effectId > 0)
            EffectManager.Instance.PlayEffect(effectId, Fighter, Fighter);
    }

    public void OnExitTransfer()
    {
        int effectId = GlobalConfig.Instance.GetConfigIntValue(GlobalConfig.c_exit_transfer_effectId);
        if (effectId > 0)
            EffectManager.Instance.PlayEffect(effectId, Fighter, Fighter);
    }

    Fadeout fadeout = null;
    public void FadeOut(float time)
    {
        if (mAvatarObject == null) return;

        //if (DeviceInfo.IsGoodDevice)
        //{
        //    fadeout = mAvatarObject.AddComponent<Fadeout>();
        //    fadeout.time = time;
        //}

        HideShadow();
    }

    public void OnDie()
    {
        EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_FIGHTER_DIE, Fighter));
    }

    public void OnLifeChanged()
    {

    }

    public void OnManaChanged()
    {

    }

    public void OnRageChanged()
    {

    }

    public void OnBeHit(SkillHitFighterInfo hitInfo, int seq)
    {
        if (hitInfo.IsImmunity)
        {
            EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_FIGHTER_IMMUNITY, Fighter));
        }
        else if (hitInfo.IsDodge || hitInfo.IsPerfectDodge)
        {
            EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_FIGHTER_DODGE, Fighter));
            EventMgr.DispatchEvent<Fighter,BaseSkill>(new CoreEvent<Fighter,BaseSkill>(ECoreEventType.EID_Fighter_Damage_Avoid, hitInfo.Caster,hitInfo.Skill));
        }
        else if (hitInfo.Damage > 0)
        {
            DoBeHitEffect(hitInfo.AttackInfo.hitEffect, hitInfo.Caster);
            DoBeHitColor();
        }
    }

    public void OnDisposed(bool destroyImmediatly = false)
    {
        if (Fighter.IsHero && mPartGoes != null)
        {
            RecyclePartGo();
            if (mAvatarObject != null)
            {
                GameObject.Destroy(mAvatarObject);
                mAvatarObject = null;
            }
        }
        else
        {
            if (mAvatarObject != null)
            {
                if (!Fighter.IsMainRole || BattleMgr.Instance.RoleModelGo == null)
                {
                    ResourceMgr.Instance.RecycleGO(Constants.ModelPath, Fighter.Actor.AvatarData.prefab, mAvatarObject);
                    if (fadeout != null)
                    {
                        fadeout.Reset();
                        GameObject.DestroyImmediate(fadeout);
                        fadeout = null;
                    }
                }
                mAvatarObject = null;
            }
        }


        mIsLoaded = false;

        if (bornEffectInstanceId > 0)
            EffectManager.Instance.RemoveEffectByInstanceID(bornEffectInstanceId);

        bornEffectInstanceId = 0;

        HideShadow();
        EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_FIGHTER_DISPOSE, Fighter));
    }

    private void RecyclePartGo()
    {
        if (mPartGoes == null) return;

        HeroActorData hero = Fighter.Actor as HeroActorData;

        foreach (var p in mPartGoes)
        {
            GameObject.Destroy(p.Value);
        }
        mPartGoes.Clear();
    }

    public void OnRotationChanged(Quaternion rot)
    {
        this.transform.rotation = rot;
    }

    public void OnForwardChanged()
    {
        if (Fighter.LocalForward.FEqual(Vector3.zero)) return;

        if (!this.transform.forward.FEqual(Fighter.LocalForward))
        {
            this.transform.forward = Fighter.LocalForward;
        }
    }

    private CoreEvent<CastSkillData> castSkillCE = null;
    public void OnEnterSkill(BaseSkill skill)
    {
        if (skill == null)
            return;

        if (Fighter.IsPlayer || Fighter.IsBoss)
        {
            if (!skill.IsNormalAttack)
            {
                CastSkillData skillParam = Fighter.CastSkill;

                if (skillParam != null)
                {
                    skillParam.isBoss = Fighter.IsBoss;
                    skillParam.actorId = Fighter.Actor.ID;
                    skillParam.teamSide = (int)Fighter.TeamSide;
                    skillParam.skillId = skill.Id;
                    skillParam.skillIcon = skill.SkillDataInfo.skillIcon;
                    skillParam.cdTime = 0;
                    skillParam.IsCasting = true;
                    skillParam.IsForbidden = false;
                    skillParam.IsEnhance = skill.IsEnhance;
                    if (castSkillCE == null)
                    {
                        castSkillCE = new CoreEvent<CastSkillData>(ECoreEventType.EID_Refresh_Skill, skillParam);
                    }
                    else
                    {
                        castSkillCE.SetData(skillParam);
                    }

                    EventMgr.DispatchEvent<CastSkillData>(castSkillCE);
                }
            }
        }


    }

    public void OnLeaveSkill(BaseSkill skill)
    {
        if (Fighter.IsPlayer || Fighter.IsBoss)
        {
            if (!skill.IsNormalAttack)
            {
                CastSkillData skillParam = Fighter.CastSkill;
                if (skillParam != null && Fighter.AI != null)
                {
                    BaseSkill nextSkill = Fighter.GetSkill(Fighter.AI.NextSelectAttack);
                    Fighter.CheckSkillEnhance(nextSkill, true);

                    skillParam.isBoss = Fighter.IsBoss;
                    skillParam.skillId = nextSkill.Id;
                    skillParam.actorId = Fighter.Actor.ID;
                    skillParam.teamSide = (int)Fighter.TeamSide;
                    skillParam.skillIcon = nextSkill.SkillDataInfo.skillIcon;
                    skillParam.cdTime = nextSkill.SkillDataInfo.cd;
                    skillParam.IsCasting = false;
                    skillParam.IsEnhance = nextSkill.IsEnhance;
                    skillParam.IsForbidden = Fighter.FuncMgr.HaveForbidSkillFunc();
                    castSkillCE.SetData(skillParam);
                    EventMgr.DispatchEvent<CastSkillData>(castSkillCE);
                }
            }
        }
    }

    public void OnFightingStart(BaseSkill skill)
    {
        if (Fighter.IsPlayer || Fighter.IsBoss)
        {
            if (!skill.IsNormalAttack)
            {
                CastSkillData skillParam = Fighter.CastSkill;
                if (skillParam != null)
                {
                    skillParam.isBoss = Fighter.IsBoss;
                    skillParam.skillId = skill.Id;
                    skillParam.actorId = Fighter.Actor.ID;
                    skillParam.teamSide = (int)Fighter.TeamSide;
                    skillParam.skillIcon = skill.SkillDataInfo.skillIcon;
                    skillParam.cdTime = skill.SkillDataInfo.cd;
                    skillParam.IsCasting = false;
                    skillParam.IsEnhance = skill.IsEnhance;
                    skillParam.IsForbidden = false;
                    if (castSkillCE == null)
                    {
                        castSkillCE = new CoreEvent<CastSkillData>(ECoreEventType.EID_Refresh_Skill, skillParam);
                    }
                    else
                    {
                        castSkillCE.SetData(skillParam);
                    }
                    EventMgr.DispatchEvent<CastSkillData>(castSkillCE);
                }
            }
        }
    }

    bool mInStiff = false;
    public void ProcessStiff(bool stiff)
    {
        if (mInStiff) return;

        if(mAvatarObject != null)
        {
            if(mStiffCom  == null)
            {
                mStiffCom = mAvatarObject.GetComponent<Stiff>();
                if (mStiffCom == null)
                    mStiffCom = mAvatarObject.AddComponent<Stiff>();
            }
            mStiffCom.SetStiff(stiff);
        }
    }

    public void ProcessVertigo(bool grey)
    {
        if (mInSpecular) return;

        if (mAvatarObject != null)
        {
            if (mGrayChange == null) {
                mGrayChange = mAvatarObject.GetComponent<Gray>();
                if (mGrayChange == null)
                    mGrayChange = mAvatarObject.AddComponent<Gray>();
            }
            mGrayChange.SetGrey(grey);
        }
    }

    public void ProcesssSpecularColor(bool add, Color clr)
    {
        if (mAvatarObject != null)
        {
            mInSpecular = add;
            if (mBeHitColorChange != null)
                mBeHitColorChange.enabled = false;
            if (mRimColor == null) {
                mRimColor = mAvatarObject.GetComponent<RimColor>();
                if (mRimColor == null)
                    mRimColor = mAvatarObject.AddComponent<RimColor>();
            }
            mRimColor.SetRimColor(add, clr);
        }
    }
    #endregion //event_callbacks

    #region public_methods

    public Vector3 GetChildRelativePosition(string name)
    {
        Transform t = UnityEngineUtils.RecurisiveFindTransformChild(transform, name);
        if (t != null && t != transform)
            return transform.InverseTransformPoint(t.position);
        return Vector3.zero;
    }

    public void SwitchNode(string childNodeName, int frameCount, bool show)
    {
        if (mAvatarObject == null)
            return;
    }

    public void StartScale(float intime, float scale, float time, float outtime)
    {
        Fighter.SetScale(scale);
        if (mFighterScaleInfo == null)
            mFighterScaleInfo = gameObject.AddComponent<FighterScaleInfo>();
        if (mFighterScaleInfo.enabled)
            mFighterScaleInfo.enabled = false;
        mFighterScaleInfo.fadeInTime = intime;
        mFighterScaleInfo.fadeOutTime = outtime;
        mFighterScaleInfo.scaleValue = scale;
        mFighterScaleInfo.continueTime = time;
        mFighterScaleInfo.enabled = true;
    }

    #endregion //public_methods

    public void ParseLoad()
    {
        if (IsLoaded || Fighter == null)
            return;

        if (Fighter.IsHero)
        {
            HeroActorData heroActorData = Fighter.Actor as HeroActorData;
            if (null != heroActorData && heroActorData.PartResList != null)
            {
                foreach (var p in heroActorData.PartResList)
                {
                    BattlePrepareManager.Instance.PrecacheModel(p.Value, Fighter.Actor.AType);
                }
                BattlePrepareManager.Instance.PrecacheAnimatorCtrl(heroActorData.AnimCtrlName);
            }
            else
            {
                if (!string.IsNullOrEmpty(Fighter.Actor.AvatarData.prefab))
                {
                    BattlePrepareManager.Instance.PrecacheModel(Fighter.Actor.AvatarData.prefab, Fighter.Actor.AType);
                }
            }
        }
        else
        {
            if (!string.IsNullOrEmpty(Fighter.Actor.AvatarData.prefab))
            {
                BattlePrepareManager.Instance.PrecacheModel(Fighter.Actor.AvatarData.prefab, Fighter.Actor.AType);
            }
            if (Fighter.IsFellow || Fighter.IsPet)
            {
                BattlePrepareManager.Instance.PrecacheAnimatorCtrl(Fighter.Actor.AnimCtrlName);
            }
        }


        if(Fighter.BornEffectId > 0)
        {
            BattlePrepareManager.Instance.PrecacheEffect(Fighter.BornEffectId);
        }
    }

    bool mPrefabLoaded = false;
    bool mAnimCtrlLoaded = false;
    public void AsyncLoad()
    {
        if (IsLoaded || Fighter == null)
            return;

        if (Fighter.IsHero && (!Fighter.IsPetHero))
        {
            mPrefabLoaded = false;
            mAnimCtrlLoaded = false;

            HeroActorData heroActorData = Fighter.Actor as HeroActorData;
            if (null != heroActorData && heroActorData.PartResList != null)
            {
                List<string> loadAssets = new List<string>(heroActorData.PartResList.Count);
                foreach (var p in heroActorData.PartResList)
                {
                    loadAssets.Add(p.Value);
                }

                ResourceMgr.Instance.LoadAsset<List<GameObject>>(OnHeroPartLoaded, Constants.ModelPath, loadAssets.ToArray());
                ResourceMgr.Instance.LoadAsset<RuntimeAnimatorController>(OnHeroAnimCtrlLoaded, Constants.AnimatorPath, heroActorData.AnimCtrlName);
            }
            else
            {
                if (!string.IsNullOrEmpty(Fighter.Actor.AvatarData.prefab))
                {
                    BattlePrepareManager.Instance.PrecacheModel(Fighter.Actor.AvatarData.prefab, Fighter.Actor.AType);
                }
            }
        }
        else
        {
            mPrefabLoaded = false;
            mAnimCtrlLoaded = (Fighter.IsFellow || Fighter.IsPet || Fighter.IsPetHero) ? false : true;
            ResourceMgr.Instance.GetGOFromPool(Constants.ModelPath, Fighter.Actor.AvatarData.prefab, OnAsyncLoaded);
            if (Fighter.IsFellow || Fighter.IsPet || Fighter.IsPetHero)
            {
                ResourceMgr.Instance.LoadAsset<RuntimeAnimatorController>(OnPartAnimCtrlLoaded, Constants.AnimatorPath, Fighter.Actor.AnimCtrlName);
            }
        }
    }

    void OnHeroPartLoaded(List<GameObject> partPrefabs, string assetPath, string[] assetNames)
    {
        mPrefabLoaded = true;
        if (mPrefabLoaded && mAnimCtrlLoaded)
        {
            EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_FIGHTER_ASYNC_LOADED, Fighter));
        }
    }

    void OnHeroAnimCtrlLoaded(RuntimeAnimatorController ctrl, string assetPath, string[] assetNames)
    {
        mAnimCtrlLoaded = true;
        if (mPrefabLoaded && mAnimCtrlLoaded)
        {
            EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_FIGHTER_ASYNC_LOADED, Fighter));
        }
    }

    void OnPartAnimCtrlLoaded(RuntimeAnimatorController ctrl, string assetPath, string[] assetNames)
    {
        mAnimCtrlLoaded = true;
        if (mPrefabLoaded && mAnimCtrlLoaded)
        {
            SetAvatarAnimCtrl();
            EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_FIGHTER_ASYNC_LOADED, Fighter));
        }
    }

    void OnAsyncLoaded(GameObject go)
    {
        mPrefabLoaded = true;
        OnAvatarLoaded(go, Constants.ModelPath, Fighter.Actor.AvatarData.prefab);
        if (mPrefabLoaded && mAnimCtrlLoaded)
        {
            SetAvatarAnimCtrl();
            EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_FIGHTER_ASYNC_LOADED, Fighter));
        }
    }

    public void Load()
    {
        if (IsLoaded || Fighter == null)
            return;

        if (Fighter.IsMainRole && BattleMgr.Instance.RoleModelGo != null)
        {
            OnAvatarLoaded(BattleMgr.Instance.RoleModelGo, Constants.ModelPath, Fighter.Actor.AvatarData.prefab);
        }
        else
        {
            if (Fighter.IsHero)
            {
                HeroActorData data = Fighter.Actor as HeroActorData;
                if (null != data && data.PartResList != null && data.PartResList.Count > 0)
                {
                    mPartGoes = new Dictionary<BodyPart, GameObject>();
                    foreach (var p in data.PartResList)
                    {
                        LoadBodyPartGo(p.Key, p.Value);
                    }
                    InitAvatar();
                }
                else
                {
                    GameObject go = ResourceMgr.Instance.GetGoFromPool(Constants.ModelPath, Fighter.Actor.AvatarData.prefab);
                    OnAvatarLoaded(go, Constants.ModelPath, Fighter.Actor.AvatarData.prefab);
                }
            }
            else
            {
                GameObject go = ResourceMgr.Instance.GetGoFromPool(Constants.ModelPath, Fighter.Actor.AvatarData.prefab);
                OnAvatarLoaded(go, Constants.ModelPath, Fighter.Actor.AvatarData.prefab);
                SetAvatarAnimCtrl();
            }
        }
    }

    private void LoadBodyPartGo(BodyPart part, string prefabName)
    {
        if (string.IsNullOrEmpty(prefabName) || mPartGoes.ContainsKey(part)) return;

        GameObject go = ResourceMgr.Instance.GetGoFromPool(Constants.ModelPath, prefabName);
        if (go != null)
        {
            mPartGoes.Add(part, go);
            go.layer = Fighter.Layer;
        }
    }

    private void InitAvatar()
    {
        GameObject skeletonGo = mPartGoes[BodyPart.Skeleton];
        if (skeletonGo == null)
        {
            DebugHelper.LogError(string.Format("{0}的基础骨骼加载失败!", Fighter.Name));
            return;
        }

        foreach (var p in mPartGoes)
        {
            BodyPart part = p.Key;

            if (part == BodyPart.Skeleton) continue;

            if (part == BodyPart.Hair)
            {
                HeroActorData hero = Fighter.Actor as HeroActorData;
                ChangeHairColor(mPartGoes[part], hero.FashionData.hairClrParam);
            }

            if (part == BodyPart.Face || part == BodyPart.HairStyle
                || part == BodyPart.Pupil || part == BodyPart.Eye
                || part == BodyPart.Hair || part == BodyPart.Cloth)
            {
                ResetMeshBones(skeletonGo, part);
            }
            else
            {
                LinkPart(skeletonGo, part);
            }
        }

        UnityEngine.Object asset = ResourceMgr.Instance.GetAsset(Constants.AnimatorPath, Fighter.Actor.AnimCtrlName);
        if (asset != null)
        {
            Animator skeletonAnimator = skeletonGo.GetComponent<Animator>();
            if (skeletonAnimator != null)
                skeletonAnimator.runtimeAnimatorController = asset as RuntimeAnimatorController;
        }

        OnAvatarLoaded(skeletonGo, Constants.ModelPath, Fighter.Actor.AvatarData.prefab);
    }

    private void ResetMeshBones(GameObject skeleton, BodyPart part)
    {
        if (!mPartGoes.ContainsKey(part)) return;

        GameObject src = mPartGoes[part];
        if (src == null) return;

        string tmpName = string.Empty;
        string tmpName2 = string.Empty;
        string srcName = src.name;

        SkinnedMeshRenderer[] smrs = src.GetComponentsInChildren<SkinnedMeshRenderer>(true);
        if (smrs.Length > 0)
        {
            for (int i = 0; i < smrs.Length; ++i)
            {
                Transform smrsparent = smrs[i].transform.parent;
                tmpName = smrsparent.name;
                if (tmpName.Equals(srcName))
                {
                    Transform[] bones = smrs[i].bones;
                    int bonesCount = bones.Length;
                    Transform[] newbones = new Transform[bonesCount];

                    for (int j = 0; j < bonesCount; ++j)
                    {
                        string path = UnityEngineUtils.GetParentPath(bones[j], src.transform);
                        newbones[j] = skeleton.transform.Find(path);
                    }

                    string path2 = UnityEngineUtils.GetParentPath(smrs[i].rootBone, src.transform);
                    Transform tr = skeleton.transform.Find(path2);
                    smrs[i].bones = newbones;
                    smrs[i].rootBone = tr;
                    smrs[i].transform.SetParentNormalize(skeleton.transform);
                }
            }
        }
    }

    private void LinkPart(GameObject skeleton, BodyPart part)
    {
        if (!mPartGoes.ContainsKey(part)) return;

        GameObject src = mPartGoes[part];
        if (src == null) return;

        HeroActorData hero = Fighter.Actor as HeroActorData;

        BodyPartParam partParam = hero.GetBodyPartParam(part);
        if (string.IsNullOrEmpty(partParam.linkPoint)) return;

        Transform partTrans = src.transform;
        string linkPoint = partParam.linkPoint;

        Transform linkTrans = UnityEngineUtils.RecurisiveFindTransformChild(skeleton.transform, linkPoint);
        if (linkTrans == null) return;

        partTrans.SetParent(linkTrans);
        partTrans.localPosition = partParam.pos;
        partTrans.localRotation = Quaternion.Euler(partParam.rot);
        partTrans.localScale = partParam.scale;
    }

    void ChangeHairColor(GameObject go, HairColorParam colorParam)
    {
        SkinnedMeshRenderer smr = go.GetComponentInChildren<SkinnedMeshRenderer>();
        if (smr == null) return;

        Material mat = smr.material;
        if (mat == null) return;

        mat.SetTextureOffset("_MainTex", colorParam.uvOffset);
    }

    void OnAvatarLoaded(GameObject go, string path, params string[] assetName)
    {
        if (go != null)
        {
            go.transform.SetParent(transform);
            go.transform.localPosition = Fighter.Actor.Offset;
            go.transform.localEulerAngles = Fighter.Actor.Rot;
            go.transform.localScale = Vector3.one * Fighter.Actor.AvatarData.scale;
            go.name = "avatar";
            mAvatarObject = go;

            if (Fighter.IsPlayer || Fighter.IsPet)
            {
                navAgent = this.gameObject.GetComponent<NavMeshAgent>();
                if (navAgent == null)
                {
                    navAgent = this.gameObject.AddComponent<NavMeshAgent>();
                    navAgent.speed = GlobalConfig.Instance.GetConfigIntValue(GlobalConfig.c_rushspeed_configid);
                    navAgent.acceleration = navAgent.speed * 6;
                }
                EnableNavAgent(false);
            }

            mAnimator = go.GetComponent<Animator>();
            if (mAnimator != null) {
                mAnimator.logWarnings = false;
                mAnimator.SetFloat("moveSpeed", 1);
                mAnimator.cullingMode = AnimatorCullingMode.AlwaysAnimate;
            }

            SetLayer(Fighter.Layer);
        }
        else
        {
            DebugHelper.LogError("{0}/{1} 加载失败", path, assetName[0]);
        }

        mIsLoading = false;
        mIsLoaded = true;
        IsVisible = Fighter.IsSpawned;
    }

    void SetAvatarAnimCtrl()
    {
        if (mAnimator == null) return;

        if (Fighter.IsFellow || Fighter.IsPet)
        {
            UnityEngine.Object ctrl = ResourceMgr.Instance.GetAsset(Constants.AnimatorPath, Fighter.Actor.AnimCtrlName);
            if (ctrl != null)
            {
                mAnimator.runtimeAnimatorController = ctrl as RuntimeAnimatorController;
            }
        }
    }

    void DoBeHitColor()
    {
        if (Fighter.IsPlayer || Fighter.IsPet || mInSpecular || !DeviceInfo.IsGoodDevice) return;

        if (mAvatarObject != null)
        {
            if (mBeHitColorChange == null) { 
                mBeHitColorChange = mAvatarObject.GetComponent<BeHitColorChange>();
                if (mBeHitColorChange == null)
                    mBeHitColorChange = mAvatarObject.AddComponent<BeHitColorChange>();
            }
            mBeHitColorChange.color = Color.white;
            mBeHitColorChange.time = 0.2f;
            mBeHitColorChange.enabled = false;
            mBeHitColorChange.enabled = true;
        }
    }

    public void DoBeHitEffect (int effectId, Fighter caster)
	{
		if (effectId > 0)
        {
            EffectManager.Instance.PlayEffect(effectId, caster, Fighter);
        }
    }

	void DoBeHitSound (string strSound, bool isBullet)
	{
		if (!string.IsNullOrEmpty (strSound)) {
            MusicMgr.Instance.PlayFightSound(strSound);
        }
	}

	public void PlayFullScreenEffect (string name, float time, bool follow, bool hideSelf)
	{
		FullScreenSkillEffect effectCtrl = GetComponent<FullScreenSkillEffect> ();
		if (effectCtrl == null)
			effectCtrl = gameObject.AddComponent<FullScreenSkillEffect> ();
		bool mirror = Fighter.TeamSide == eTeamType.Enemy;
		effectCtrl.Play (name, time, follow, hideSelf, mirror);
	}

	public void Pause ()
	{
		EffectManager.Instance.PauseEffectOfOwnerFighter (Fighter);
		PauseAnim ();
	}

	public void ResumePause ()
	{
		EffectManager.Instance.ResumeEffectOfOwnerFighter (Fighter);
		ResumeAnim ();
	}

	public void PauseAnim ()
	{
		if (Animator != null)
			Animator.speed = 0;
	}

	public void ResumeAnim ()
	{
		if (Animator != null)
			Animator.speed = 1;
	}


    public void SetLayer(int layer)
    {
        if (mAvatarObject == null) return;

        //mAvatarObject.layer = layer;
        //for (int i = 0; i < mAvatarObject.transform.childCount; ++i)
        //{
        //    mAvatarObject.transform.GetChild(i).gameObject.layer = layer;
        //}

        CommonUtil.SetGameObjectLayer(mAvatarObject, layer);

        if (shadowEffectInstanceId > 0)
        {
            if (layer == LayerMask.NameToLayer(BattleCamera.HideLayerName))
            {
                EffectManager.Instance.HideEffectByInstanceId(shadowEffectInstanceId);
            }
            else
            {
                EffectManager.Instance.UnHideEffectByInstanceId(shadowEffectInstanceId);
            }
        }
    }

	void OnVisibleChanged ()
	{
	}
    
    public Vector3 GetPosByLink(string linkName)
    {
        if (mAvatarObject == null) return Fighter.Position;

        if (string.IsNullOrEmpty(linkName)) return Fighter.Position;

        Transform trans = mAvatarObject.transform.Find(linkName);
        if (trans == null) return Fighter.Position;

        return trans.position;
    }

    public Vector3 GetUIPointPos()
    {
        if (mAvatarObject == null) return Fighter.Position;

        Transform uiPointTrans = mAvatarObject.transform.Find("ui_point");
        if (uiPointTrans == null) return Fighter.Position;

        return uiPointTrans.position;
    }

    Transform mFoot;
    Transform Foot
    {
        get {
            if (mFoot == null)
            {
                mFoot = mAvatarObject.transform.Find("foot_point");
                if (mFoot != null)
                {
                    Vector3 pos = mFoot.localPosition;
                    if (Fighter.IsPlayer)
                        pos.y += 0.03f;
                    mFoot.localPosition = pos;
                }
            }
            return mFoot;
        }
    }

    void ShowShadow()
    {
        if (Foot == null) return;

        if(shadowEffectInstanceId == 0)
            shadowEffectInstanceId = EffectManager.Instance.PlayEffect(GlobalConfig.Instance.GetConfigIntValue(GlobalConfig.c_shadow_effectid), Foot, Foot);
        if(shadowEffectInstanceId > 0)
        {
            EffectManager.Instance.SetEffectScaleByInstanceId(shadowEffectInstanceId, Fighter.Actor.AvatarData.shadowScale);
        }

        if (Fighter.IsMainRole && selfEffectInstanceId == 0)
        {
            selfEffectInstanceId = EffectManager.Instance.PlayEffect(GlobalConfig.Instance.GetConfigIntValue(GlobalConfig.c_self_effectid),Foot,Foot);
        }
    }

    void HideShadow()
    {
        EffectManager.Instance.RemoveEffectByInstanceID(shadowEffectInstanceId);

        if(selfEffectInstanceId > 0)
        {
            EffectManager.Instance.RemoveEffectByInstanceID(selfEffectInstanceId);
            selfEffectInstanceId = 0;
        }
    }

    public void SetShadowVisible(bool vis)
    {
        if(shadowEffectInstanceId > 0)
        {
            if (vis)
                EffectManager.Instance.UnHideEffectByInstanceId(shadowEffectInstanceId);
            else
                EffectManager.Instance.HideEffectByInstanceId(shadowEffectInstanceId);
        }
    }

    public void ShowRunSmoke()
    {
        if (Foot == null) return;

        if (runsmokeEffectInstanceId == 0)
        {
            runsmokeEffectInstanceId = EffectManager.Instance.PlayEffect(GlobalConfig.Instance.GetConfigIntValue(GlobalConfig.c_runsmoke_effectid), Foot, Foot);
        }
        else
        {
            EffectManager.Instance.UnHideEffectByInstanceId(runsmokeEffectInstanceId);
        }
    }

    public void HideRunSmoke()
    {
        if(runsmokeEffectInstanceId > 0)
            EffectManager.Instance.HideEffectByInstanceId(runsmokeEffectInstanceId);
    }

    public void OnBreakSkill()
    {
        //DebugHelper.LogError("mFighter:" + Fighter.Name);
        //EventMgr.DispatchEvent<Fighter>(new CoreEvent<Fighter>(ECoreEventType.EID_SKILL_BREAK, Fighter));
    }

    public void RunToWithNav(Vector3 dest)
    {
        bool result = false;
        if (navAgent != null) {
            EnableNavAgent(true);
            result = navAgent.SetDestination(dest);
            if(result)
            {
                if (null == Fighter.Actor)
                    return;
                float speed = GlobalConfig.Instance.GetConfigIntValue(GlobalConfig.c_rushspeed_configid);
                if(Fighter.IsBack)
                {
                    SetMoveSpeed(UnityEngine.Random.Range(speed, speed * 1.1f));
                }
            }
            else
            {
                DebugHelper.LogError("RunToWithNav:" + dest);
            }
        }

        //DebugHelper.LogError("RunToWithNav:" + dest + " result = "+ result);
    }

    public void EnableNavAgent(bool enabled)
    {
        if (navAgent != null)
            navAgent.enabled = enabled;
    }

    public void SetStopDistance(float dist)
    {
        if (navAgent != null)
            navAgent.stoppingDistance = Mathf.Min(dist,10);
    }

    public bool IsNavRunStop()
    {
        if (navAgent != null)
            return navAgent.isStopped || navAgent.velocity.FEqual(Vector3.zero,0.001f);
        return true;
    }

    public float AnimSpeed
    {
        get
        {
            float attackSpeedPercent = Mathf.Max(1- Fighter.AttrAttackSpeedPercent,0.3f) * Mathf.Max(1 - Fighter.SkillAttackSpeedPercent,0.3f);
            return 1 / attackSpeedPercent;
        }
    }

    public void SetMoveSpeed(float speed)
    {
        if (navAgent == null) return;

        navAgent.speed = speed;
        navAgent.acceleration = navAgent.speed * 6;
    }

    public bool NavAgentEnabled
    {
        get { return navAgent != null ? navAgent.enabled : false; }
    }

    public FixVector3 mMoveDestPos = FixVector3.Zero;
    Fix64 fDeltaTime = Fix64.Zero;
    bool bIsMove = false;
    public void MoveTo(FixVector3 destPos)
    {
        bIsMove = true;
        mMoveDestPos = destPos;
        fDeltaTime = Fix64.Zero;
    }
    public bool IsMoveing()
    {
        return bIsMove;
    }
    public void EndMoveTo()
    {
        bIsMove = false;
        fDeltaTime = Fix64.Zero;
        Fighter.SyncPosition(mMoveDestPos.ToVector3());
    }

    private void UpdateCurrentPos(float deltaTime)
    {
        if (!IsMoveing())
            return;
        fDeltaTime += (Fix64)Time.deltaTime;
        FixVector3 fv3Pos = new FixVector3(Fighter.Position);
        FixVector3 fv3MovePos = mMoveDestPos;
        Fix64 Lerp = fDeltaTime / Constants.s_internaltime;
        Lerp = Fix64.Clamp(Lerp, Fix64.Zero, Fix64.One);
        FixVector3 fv3EndPos = FixVector3.Lerp(fv3Pos, fv3MovePos, Lerp);
        Fighter.SyncPosition(fv3EndPos.ToVector3());
        if (Lerp == Fix64.One)
            EndMoveTo();
    }

    //Vector3 mMoveDestPos = Vector3.zero;
    //bool bChaseTarget = false;
    //Fighter mChaseFighter = null;
    //float mStopDist = 0;
    //public void MoveTo(Vector3 destPos,bool chaseTarget,Fighter chaseFighter,float stopDist)
    //{
    //    bChaseTarget = chaseTarget;
    //    mMoveDestPos = destPos;
    //    mChaseFighter = chaseFighter;
    //    mStopDist = stopDist;
    //    Fighter.LookAt(mMoveDestPos);
    //}

    //private void UpdateCurrentPos(float deltaTime)
    //{
    //    Vector3 dest = mMoveDestPos;
    //    if (bChaseTarget)
    //    {
    //        if (mChaseFighter == null || !mChaseFighter.IsAlive)
    //        {
    //            mChaseFighter = null;
    //            Fighter.StateData.ChangeState(Fighter.StateData.GetIdleNext());
    //            return;
    //        }

    //        Vector3 tPos = mChaseFighter.Position;
    //        Vector3 selfPos = Fighter.Position;
    //        tPos.y = Fighter.CurrentBattleField.FloorY;
    //        selfPos.y = Fighter.CurrentBattleField.FloorY;

    //        Vector3 dir = (tPos - selfPos).normalized;
    //        float dist = Vector3.Distance(tPos, selfPos);
    //        dest = Fighter.Position + Mathf.Max((dist - mStopDist), 0) * dir;
    //    }
    //    dest.y = Fighter.CurrentBattleField.FloorY;
    //    mMoveDestPos = dest;


    //    Vector3 pos = Vector3.MoveTowards(Fighter.Position, dest, Fighter.MoveSpeed * deltaTime * Fighter.SpeedRatio);
    //    Fighter.SyncPosition(pos);
    //    if (Fighter.Position.FEqual(dest, 0.1f))
    //    {
    //        mChaseFighter = null;
    //        Fighter.SyncPosition(dest);
    //        Fighter.StateData.ChangeState(Fighter.StateData.GetIdleNext());
    //    }
    //}

    public void RebindAvatarGo(GameObject avatarGo)
    {
        if (avatarGo == null) return;

        OnAvatarLoaded(avatarGo, null, null);

        ShowShadow();
    }

    //public void ForceToDest()
    //{
    //    if(Fighter.IsRun)
    //    {
    //        mChaseFighter = null;
    //        Fighter.SyncPosition(mMoveDestPos);
    //    }  
    //}
}
