using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class ActorAvatar
{
    private GameObject mAvatarObject;
    private Animator mAnimator;
    private bool mIsLoaded = false;
    private bool mIsLoading = false;
    private BoxCollider mCollider;
    private ModelTopUI mModelTopUI;
    private HeroActorData mHeroData;
    private FellowActorData mFellowData;
    private Dictionary<BodyPart, GameObject> mPartGoes = null;
    private string mUIPrefabName = "Battle/HeadName";
    private bool mIsVisible = true;

    private RenderTexture mRT = null;
    private GameObject mRTCamGo = null;
    private Camera mRTCam = null;
    public ActorData Data { get; private set; }


    public RenderTexture RT
    {
        get { return mRT; }
    }

    public bool IsLoaded
    {
        get { return mIsLoaded; }
    }

    public GameObject AvatarGo
    {
        get { return mAvatarObject; }
    }

    public bool IsVisible
    {
        get
        {
            return mIsVisible;
        }
        set
        {
            if (mIsVisible == value) return;

            mIsVisible = value;
            mAvatarObject.SetSafeActive(mIsVisible);
            if (mModelTopUI != null)
            {
                mModelTopUI.SetVisible(mIsVisible);
            }
            if(mRTCamGo!=null)
            {
                mRTCamGo.SetActive(mIsVisible);
                if(mIsVisible)
                {
                    if (mRT == null)
                    {
                        mRT = RenderTexture.GetTemporary(512, 512, 32);
                    }
                    mRTCam.targetTexture = mRT;
                }
                else
                {
                    mRTCam.targetTexture = null;
                    if (mRT != null)
                    {
                        RenderTexture.ReleaseTemporary(mRT);
                        mRT = null;
                    }
                }
            }
        }
    }

    Transform mFoot;
    private Transform Foot
    {
        get
        {
            if (mFoot == null)
            {
                mFoot = mAvatarObject.transform.Find("foot_point");
                Vector3 pos = mFoot.localPosition;
                mFoot.localPosition = pos;
            }
            return mFoot;
        }
    }

    int fighterLayer = 0;
    int effectId = 0;

    public ActorAvatar(ActorData data)
    {
        Data = data;
        if (Data != null)
        {
            if (Data.IsHero)
                mHeroData = Data as HeroActorData;
            else if (Data.IsFellow)
                mFellowData = Data as FellowActorData;
        }
        fighterLayer = LayerMask.NameToLayer(BattleCamera.FighterLayerName);
        mIsLoaded = false;
        mIsLoading = false;
    }

    public void ParseLoad()
    {
        if (mIsLoaded || Data == null || mIsLoading) return;

        mIsLoading = true;
        if (mHeroData != null)
        {
            if (mHeroData.PartResList != null)
            {
                foreach (var p in mHeroData.PartResList)
                {
                    BattlePrepareManager.Instance.PrecacheModel(p.Value, Data.AType);
                }
                BattlePrepareManager.Instance.PrecacheAnimatorCtrl(mHeroData.ShowAnimCtrlName);
                //BattlePrepareManager.Instance.PrecacheEffect(GlobalConfig.Instance.GetConfigIntValue(GlobalConfig.c_arena_choosen_effectid));
            }
        }
        else if (mFellowData != null)
        {
            if (!string.IsNullOrEmpty(Data.AvatarData.prefab))
            {
                BattlePrepareManager.Instance.PrecacheModel(Data.AvatarData.prefab, Data.AType);
                BattlePrepareManager.Instance.PrecacheAnimatorCtrl(mFellowData.ShowAnimCtrlName);
            }
        }

        //BattlePrepareManager.Instance.PrecacheUIPrefab(mUIPrefabName);
    }

    public void CreateGo(Vector3 pos, Camera cam,bool createName = false)
    {
        if (IsLoaded || Data == null) 
        {
            mAvatarObject.transform.position = pos;
            IsVisible = true;
            return;
        }


        if (mHeroData != null)
        {
            if (mHeroData.PartResList != null && mHeroData.PartResList.Count > 0)
            {
                mPartGoes = new Dictionary<BodyPart, GameObject>();
                foreach (var p in mHeroData.PartResList)
                {
                    LoadBodyPartGo(p.Key, p.Value);
                }
                InitAvatar();
            }
            else
            {
                GameObject go = ResourceMgr.Instance.GetGoFromPool(Constants.ModelPath, mHeroData.AvatarData.prefab);
                OnAvatarLoaded(go, Constants.ModelPath, mHeroData.AvatarData.prefab);
            }
        }
        else if (mFellowData != null)
        {
            GameObject go = ResourceMgr.Instance.GetGoFromPool(Constants.ModelPath, Data.AvatarData.prefab);
            OnAvatarLoaded(go, Constants.ModelPath, Data.AvatarData.prefab);
        }

        if (mAvatarObject != null)
        {
            mAvatarObject.transform.position = pos;
            if(createName)
            {
                mModelTopUI = new ModelTopUI(mAvatarObject, cam, mUIPrefabName);
                mModelTopUI.SetNameAndLevel(Data.Name, Data.Level);
            }
        }
    }


    public void GenerateRT()
    {
        if (mRTCamGo != null)
        {
            Vector3 camPos = mAvatarObject.transform.position;
            camPos.y += 1.1f;
            camPos.z -= 2;
            mRTCamGo.transform.position = camPos;
            return;
        }

        if(mRTCamGo == null)
        {
            mRTCamGo = new GameObject(Data.Name + "_RTCam");
        }

        mRTCamGo.transform.SetParent(PreviewTeamMgr.Instance.transform);
        mRTCam = mRTCamGo.GetComponent<Camera>();
        if(mRTCam == null)
        {
            mRTCam = mRTCamGo.AddComponent<Camera>();
        }

        mRTCam.cullingMask = LayerMask.GetMask("Model");
        mRTCam.farClipPlane = 10;
        mRTCam.orthographicSize = 1.5f;
        mRTCam.useOcclusionCulling = false;
        mRTCam.clearFlags = CameraClearFlags.SolidColor;
        mRTCam.orthographic = true;
        if (mRT == null)
        {
            mRT = RenderTexture.GetTemporary(512, 512, 32);
        }
        mRTCam.targetTexture = mRT;
        if(GameMgr.Instance.IsBadDevice)
        {
            mRTCam.allowMSAA = false;
        }
        else
        {
            mRTCam.allowMSAA = true;
        }

        Vector3 pos = mAvatarObject.transform.position;
        pos.y += 1.1f;
        pos.z -= 2;
        mRTCamGo.transform.position = pos;
    }


    public void LookAt(Vector3 pos)
    {
        if (mAvatarObject == null) return;

        mAvatarObject.transform.LookAt(pos);
    }

    public void Update(Camera cam)
    {
        if (mModelTopUI != null)
        {
            mModelTopUI.Update(cam);
        }
    }

    public void Dispose()
    {
        mRTCam = null;
        if(mRTCamGo != null)
        {
            GameObject.Destroy(mRTCamGo);
            mRTCamGo = null;
        }

        if(mRT!=null)
        {
            RenderTexture.ReleaseTemporary(mRT);
            mRT = null;
        }


        StopEffect();

        if (mCollider != null)
        {
            GameObject.DestroyImmediate(mCollider);
            mCollider = null;
        }

        if (mModelTopUI != null)
        {
            mModelTopUI.Dispose();
            mModelTopUI = null;
        }

        if (mHeroData != null)
        {
            RecyclePartGo();
            if (mAvatarObject != null)
            {
                GameObject.Destroy(mAvatarObject);
                mAvatarObject = null;
            }
        }
        else if (mFellowData != null)
        {
            if (mAvatarObject != null)
            {
                ResourceMgr.Instance.RecycleGO(Constants.ModelPath, mFellowData.AvatarData.prefab, mAvatarObject);
            }
        }

        Data = null;
        mAvatarObject = null;
        mHeroData = null;
        mFellowData = null;
        mIsLoaded = false;
        mIsLoading = false;
    }

    public void PlayEffect()
    {
        if (effectId == 0)
            effectId = EffectManager.Instance.PlayEffect(GlobalConfig.Instance.GetConfigIntValue(GlobalConfig.c_arena_choosen_effectid), Foot, Foot);
    }

    public void SetBattleFlag(bool inBattle)
    {
        if (mModelTopUI != null)
            mModelTopUI.SetBattleFlag(inBattle);
    }

    public void StopEffect()
    {
        if (effectId > 0)
        {
            EffectManager.Instance.RemoveEffectByInstanceID(effectId);
            effectId = 0;
        }
    }

    public void PlayAnim(string animName)
    {
        if (mAnimator == null) return;

        mAnimator.CrossFade(animName,0.1f);
    }

    private void LoadBodyPartGo(BodyPart part, string prefabName)
    {
        if (string.IsNullOrEmpty(prefabName) || mPartGoes.ContainsKey(part)) return;

        GameObject go = ResourceMgr.Instance.GetGoFromPool(Constants.ModelPath, prefabName);
        if (go != null)
        {
            mPartGoes.Add(part, go);
        }
    }
    private void InitAvatar()
    {
        GameObject skeletonGo = mPartGoes[BodyPart.Skeleton];
        if (skeletonGo == null)
        {
            DebugHelper.LogError(string.Format("{0}的基础骨骼加载失败!", Data.Name));
            return;
        }

        foreach (var p in mPartGoes)
        {
            BodyPart part = p.Key;

            if (part == BodyPart.Skeleton) continue;

            if (part == BodyPart.Hair)
            {
                HeroActorData hero = Data as HeroActorData;
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

        OnAvatarLoaded(skeletonGo, Constants.ModelPath, Data.AvatarData.prefab);
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

        BodyPartParam partParam = mHeroData.GetBodyPartParam(part);
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

    private void OnAvatarLoaded(GameObject go, string path, params string[] assetName)
    {
        if (go != null)
        {
            go.transform.SetParent(PreviewTeamMgr.Instance.transform);
            go.transform.localPosition = Data.Offset;
            go.transform.localEulerAngles = new Vector3(0,180,0);
            go.transform.localScale = Vector3.one * Data.AvatarData.scale;
            CommonUtil.SetGameObjectLayer(go, "Model");
            go.name = Data.Name;
            mAvatarObject = go;

            mCollider = mAvatarObject.GetComponent<BoxCollider>();
            if (mCollider == null)
                mCollider = mAvatarObject.AddComponent<BoxCollider>();
            mCollider.center = new Vector3(0, 0.5f, 0);
            mCollider.size = new Vector3(2, 2, 2);
            go.SetActive(true);

            mAnimator = go.GetComponent<Animator>();
            if (mAnimator != null)
            {
                UnityEngine.Object asset = ResourceMgr.Instance.GetAsset(Constants.AnimatorPath, Data.ShowAnimCtrlName);
                if (asset != null)
                {
                    mAnimator.runtimeAnimatorController = asset as RuntimeAnimatorController;
                }
                mAnimator.cullingMode = AnimatorCullingMode.AlwaysAnimate;
            }
        }
        else
        {
            DebugHelper.LogError("{0}/{1} 加载失败", path, assetName[0]);
        }

        mIsLoading = false;
        mIsLoaded = true;
    }

    private void RecyclePartGo()
    {
        if (mPartGoes == null) return;

        foreach (var p in mPartGoes)
        {
            GameObject.Destroy(p.Value);
        }
        mPartGoes.Clear();
    }


}
