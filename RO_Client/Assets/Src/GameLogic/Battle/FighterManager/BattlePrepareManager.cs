using UnityEngine;
using System.Collections.Generic;

public class BattlePrepareManager : Singleton<BattlePrepareManager>
{
	public delegate void EffectReadyCallback (int id);

	Dictionary<int, EffectData> mEffectDataCache = new Dictionary<int, EffectData> ();
	Dictionary<int, BulletData> mBulletDataCache = new Dictionary<int, BulletData> ();
    Dictionary<int, BuffData> mBuffDataCache = new Dictionary<int, BuffData> ();

    Dictionary<string, List<string>> mPrecacheAssets = new Dictionary<string, List<string>>();
    List<string> mPrecacheParterModels = new List<string>();
    List<string> mPrecacheHeroModels = new List<string>();
    List<string> mPrecacheMonsterModels = new List<string>();
    List<string> mPrecachePetModels = new List<string>();
    List<string> mPrecacheCtrls = new List<string>();
    List<string> mPrecacheUIPrefabs = new List<string>();

    private bool mIsLoading = false;
	public bool IsLoading { get { return mIsLoading; } }
    int loadtaskCnt = 0;
    float loadingProgress = 0.4f;
    float loadingDelta = 0;

    public int CacheEffectCnt
    {
        get { return mEffectDataCache.Count; }
    }

    public override void Init()
    {
        base.Init();
    }

    public override void UnInit()
    {
        base.UnInit();
    }

    public void PrecacheEffect(int id)
    {
        if (mEffectDataCache.ContainsKey(id)) return;

        EffectData data = new EffectData(id);
        mEffectDataCache.Add(id, data);

        PrecacheAssets(Constants.EffectPath, data.effect);
    }

    public void PrecacheEffects (int[] ids)
	{
		for (int idx =0; idx < ids.Length;idx++)
        {
            var id = ids[idx];
            if (mEffectDataCache.ContainsKey (id))
				continue;
			EffectData data = new EffectData (id);
			mEffectDataCache.Add (id, data);
		}

		PrecacheEffectAssets (ids);
	}

    public EffectData PopEffectData(int id, bool autoPrecache = true)
    {
        if (!mEffectDataCache.ContainsKey(id))
        {
            if (autoPrecache)
            {
                PrecacheEffects(new[] { id });
                return mEffectDataCache[id];
            }
            else
                return new EffectData(id);
        }
        else
            return mEffectDataCache[id];
    }

 
    public void StartLoad()
    {
        foreach (var p in mPrecacheAssets)
        {
            if(p.Value.Count > 0)
            {
                loadtaskCnt++;
                ResourceMgr.Instance.LoadAsset<List<GameObject>>(OnLoadAssetsCompleted, p.Key, p.Value.ToArray());
            }
        }
        mPrecacheAssets.Clear();

        if (mPrecacheCtrls.Count > 0)
        {
            loadtaskCnt++;
            ResourceMgr.Instance.LoadAsset<List<RuntimeAnimatorController>>(OnLoadAssetsCompleted, Constants.AnimatorPath, mPrecacheCtrls.ToArray());
            mPrecacheCtrls.Clear();
        }

        if(mPrecacheUIPrefabs.Count > 0)
        {
            loadtaskCnt++;
            ResourceMgr.Instance.LoadAsset<List<GameObject>>(OnLoadAssetsCompleted, Constants.UIPath, mPrecacheUIPrefabs.ToArray());
            mPrecacheUIPrefabs.Clear();
        }

        if (mPrecacheHeroModels.Count > 0)
        {
            loadtaskCnt++;
            ResourceMgr.Instance.LoadAsset<List<GameObject>>(OnLoadAssetsCompleted, Constants.ModelPath, mPrecacheHeroModels.ToArray());
            mPrecacheHeroModels.Clear();
        }

        if(mPrecacheMonsterModels.Count > 0)
        {
            loadtaskCnt++;
            ResourceMgr.Instance.LoadAsset<List<GameObject>>(OnLoadAssetsCompleted, Constants.ModelPath, mPrecacheMonsterModels.ToArray());
            mPrecacheMonsterModels.Clear();
        }

        if(mPrecacheParterModels.Count > 0)
        {
            loadtaskCnt++;
            ResourceMgr.Instance.LoadAsset<List<GameObject>>(OnLoadAssetsCompleted, Constants.ModelPath, mPrecacheParterModels.ToArray());
            mPrecacheParterModels.Clear();
        }

        if(mPrecachePetModels.Count > 0)
        {
            loadtaskCnt++;
            ResourceMgr.Instance.LoadAsset<List<GameObject>>(OnLoadAssetsCompleted, Constants.ModelPath, mPrecachePetModels.ToArray());
            mPrecachePetModels.Clear();
        }

        mIsLoading = loadtaskCnt > 0;
        loadingProgress = 0.4f;
        if (mIsLoading)
            loadingDelta = 0.5f / loadtaskCnt;
        if(!mIsLoading)
        {
            EventMgr.DispatchEvent<bool>(new CoreEvent<bool>(ECoreEventType.EID_PREPARE_LOAD_OK, true));
        }
    }

    public void PrecacheBuffs(int[] ids, int gender, ProfessionType jobType, int jobStage, int jobBranch)
    {
        if (ids == null) return;

        for(int idx =0; idx < ids.Length;idx++)
        {
            if (mBuffDataCache.ContainsKey(ids[idx]))
                continue;

            PrecacheBuff(ids[idx],gender,jobType,jobStage,jobBranch);
        }
    }

    public BuffData PrecacheBuff(int id,int gender, ProfessionType jobType, int jobStage, int jobBranch)
    {
        if (mBuffDataCache.ContainsKey(id))
            return mBuffDataCache[id];

        BuffData data = new BuffData(id, gender,jobType,jobStage,jobBranch);
        mBuffDataCache.Add(id, data);
        List<int> buffs =  PrecacheBuffAssets(id);

        if(buffs != null && buffs.Count > 0)
        {
            for (int idx = 0; idx < buffs.Count; idx++)
            {
                PrecacheBuff(buffs[idx], (int)(Role_Gender.Male), jobType, jobStage, jobBranch);
            }
        }

        if (data.extendBuffs!=null)
        {
            for(int idx =0; idx < data.extendBuffs.Count;idx++)
            {
                PrecacheBuff(data.extendBuffs[idx].id, (int)(Role_Gender.Male),jobType,jobStage,jobBranch);
            }
        }

        if(data.markExtendList != null)
        {
            for (int idx = 0; idx < data.markExtendList.Count; idx++)
            {
                PrecacheBuff(data.markExtendList[idx].val, (int)(Role_Gender.Male), jobType, jobStage, jobBranch);
            }
        }
        return data;
    }

    public BulletData PopBulletData(int id, bool autoPrecache = true)
    {
        if (!mBulletDataCache.ContainsKey(id))
        {
            if (autoPrecache)
            {
                PrecacheBullets(new[] { id }, BattleMgr.Instance != null);
                return mBulletDataCache[id];
            }
            else
                return new BulletData(id);
        }
        else
            return mBulletDataCache[id];
    }

    public BuffData PopBuffData(int id, bool autoPrecache = true)
    {
        if (mBuffDataCache.ContainsKey(id))
        {
            return mBuffDataCache[id];
        }

        return null;    
    }

    public void PrecacheBullets(int[] ids, bool cacheAssets = true)
    {
        foreach (var id in ids)
        {
            if (mBulletDataCache.ContainsKey(id))
                continue;
            BulletData data = new BulletData(id);
            mBulletDataCache.Add(id, data);
        }

        if (cacheAssets)
            PrecacheBulletAssets(ids);
    }

    public void PrecacheModel(string prefabName, ActorType actorType)
    {
        if (ResourceMgr.Instance.HasAsset(Constants.ModelPath, prefabName)) return;
   
        if (actorType == ActorType.Hero)
        {
            if (!mPrecacheHeroModels.Contains(prefabName))
            {
                mPrecacheHeroModels.Add(prefabName);
            }
        }
        else if(actorType == ActorType.Fellow)
        {
            if(!mPrecacheParterModels.Contains(prefabName))
            {
                mPrecacheParterModels.Add(prefabName);
            }
        }
        else if(actorType == ActorType.Monster)
        {
            if(!mPrecacheMonsterModels.Contains(prefabName))
            {
                mPrecacheMonsterModels.Add(prefabName);
            }
        }
        else if(actorType == ActorType.Pet)
        {
            if(!mPrecachePetModels.Contains(prefabName))
            {
                mPrecachePetModels.Add(prefabName);
            }
        }
    }

    public void PrecacheAnimatorCtrl(string ctrlName)
    {
        if (string.IsNullOrEmpty(ctrlName)) return;

        if (mPrecacheCtrls.Contains(ctrlName)) return;

        if (ResourceMgr.Instance.HasAsset(Constants.AnimatorPath, ctrlName)) return;

        mPrecacheCtrls.Add(ctrlName);
    }

    public void PrecacheUIPrefabs(string[] prefabNames)
    {
        if (prefabNames == null || prefabNames.Length == 0) return;

        for(int idx =0; idx < prefabNames.Length;idx++)
        {
            PrecacheUIPrefab(prefabNames[idx]);
        }
    }

    public void PrecacheUIPrefab(string prefabName)
    {
        if (string.IsNullOrEmpty(prefabName)) return;

        if (mPrecacheUIPrefabs.Contains(prefabName)) return;

        if (ResourceMgr.Instance.HasAsset(Constants.UIPath, prefabName)) return;

        mPrecacheUIPrefabs.Add(prefabName);
    }

	public void LoadMonsterPrefabGo (string assetPath,string prefabName, ResourceLoadCallback<GameObject> cb)
	{
        ResourceMgr.Instance.LoadAsset<GameObject>(cb,assetPath , prefabName);
	}

	public void PrecacheAnimPrefabGo (string prefabName, ResourceLoadCallback<GameObject> callback)
	{
        ResourceMgr.Instance.LoadAsset<GameObject>(callback, Constants.AnimPath, prefabName);
    }

	public GameObject PopAssetGo (string path,string assetName)
	{
		return ResourceMgr.Instance.GetGoFromPool(path,assetName);
	}

	public GameObject GetMonsterPrefabGo (string prefabName)
	{
		return ResourceMgr.Instance.GetGoFromPool(Constants.ModelPath, prefabName);
	}

	public GameObject GetAnimPrefabGo (string prefabName)
	{
		return ResourceMgr.Instance.GetGoFromPool(Constants.AnimPath, prefabName);
	}

    //清理数据
	public void Clear ()
	{
		mEffectDataCache.Clear ();
		mBulletDataCache.Clear ();
		mBuffDataCache.Clear ();
        mPrecacheAssets.Clear();
        mPrecacheHeroModels.Clear();
        mPrecacheMonsterModels.Clear();
        mPrecacheParterModels.Clear();
        mPrecachePetModels.Clear();
        mIsLoading = false;
        loadtaskCnt = 0;
    }

    private void PrecacheEffectAssets(int[] ids)
    {
        List<string> assets = new List<string>();
        for (int i = 0; i < ids.Length; i++)
        {
            EffectData data = mEffectDataCache[ids[i]];
            if (!string.IsNullOrEmpty(data.effect))
                assets.Add(data.effect);
        }
        if (assets.Count > 0)
            PrecacheAssets(Constants.EffectPath, assets.ToArray());
    }

    private void PrecacheAssets(string packageName, params string[] assetNames)
    {
        List<string> assets = null;
        if (!mPrecacheAssets.TryGetValue(packageName, out assets))
        {
            assets = new List<string>();
            mPrecacheAssets.Add(packageName, assets);
        }

        for (int idx = 0; idx < assetNames.Length; idx++)
        {
            if (!assets.Contains(assetNames[idx]) && !ResourceMgr.Instance.HasAsset(packageName, assetNames[idx]))
            {
                assets.Add(assetNames[idx]);
            }
        }
    }

    private void PrecacheBulletAssets(int[] ids)
    {
        List<string> assets = new List<string>();
        List<string> sounds = new List<string>();
        List<int> effects = new List<int>();
        for (int i = 0; i < ids.Length; i++)
        {
            BulletData data = mBulletDataCache[ids[i]];
            if (!string.IsNullOrEmpty(data.effect))
                assets.Add(data.effect);
            if (!string.IsNullOrEmpty(data.sound))
                sounds.Add(data.sound);
        }
        if (sounds.Count > 0)
            MusicMgr.Instance.PreloadFightSound(sounds.ToArray());
        if (assets.Count > 0)
            PrecacheAssets(Constants.EffectPath, assets.ToArray());
        if (effects.Count > 0)
            PrecacheEffects(effects.ToArray());
    }

    List<int> PrecacheBuffAssets(int id)
    {
        BuffData buffData = mBuffDataCache[id];
        if (buffData.ActionFrameEvents == null || buffData.ActionFrameEvents.Length == 0) return null;

        List<string> sounds = new List<string>();
        List<int> effects = new List<int>();
        List<int> bulletActors = new List<int>();
        List<int> buffs = new List<int>();
        for (int idx = 0; idx < buffData.ActionFrameEvents.Length; idx++)
        {
            SkillActionFrameEvent ev = buffData.ActionFrameEvents[idx];
            switch (ev.eventType)
            {
                case SkillActionFrameEventType.FE_PlaySound:
                    {
                        string sound = ev.GetStr(Constants.s_skillaction_frame_key_sound);
                        if(!string.IsNullOrEmpty(sound) && !sounds.Contains(sound))
                        {
                            sounds.Add(sound);
                        }
                        break;
                    }
                case SkillActionFrameEventType.FE_PlayEffect:
                case SkillActionFrameEventType.FE_PlayUnscaleTimeEffect:
                    {
                        int v = ev.GetN(Constants.s_skillaction_frame_key_effect);
                        if (v > 0 && !effects.Contains(v))
                            effects.Add(v);
                        break;
                    }
                case SkillActionFrameEventType.FE_PlayEffectEx:
                    {
                        int v = (int)ev.GetN(Constants.s_skillaction_frame_key_effect);
                        if (v > 0 && !effects.Contains(v))
                            effects.Add(v);
                        break;
                    }
                case SkillActionFrameEventType.FE_Hit:
                case SkillActionFrameEventType.FE_Skill_Sing:
                case SkillActionFrameEventType.FE_Repeat_Caster:
                case SkillActionFrameEventType.FE_Delay_Hurt:
                case SkillActionFrameEventType.FE_Bullet:
                    {
                        SkillActionAttackInfo attackInfo = ev.CreateAttackInfo();
                        if (attackInfo != null)
                        {
                            if (attackInfo.bulletID > 0 && !bulletActors.Contains(attackInfo.bulletID))
                            {
                                bulletActors.Add(attackInfo.bulletID);
                            }
                            if (attackInfo.hitEffect > 0 && !effects.Contains(attackInfo.hitEffect))
                            {
                                effects.Add(attackInfo.hitEffect);
                            }
                            if(attackInfo.effect > 0 && !effects.Contains(attackInfo.effect))
                            {
                                effects.Add(attackInfo.effect);
                            }
                            if (!string.IsNullOrEmpty(attackInfo.sound) && !sounds.Contains(attackInfo.sound))
                            {
                                sounds.Add(attackInfo.sound);
                            }
                        }
                        break;
                    }
                case SkillActionFrameEventType.FE_Clone:
                    {
                        int npcPos = ev.GetN(Constants.s_skillaction_frame_key_npcPos);
                        int npcId = ev.GetN(Constants.s_skillaction_frame_key_npcId);
                        int bornEffectId = ev.GetN(Constants.s_skillaction_frame_key_effect);
                        if (bornEffectId > 0 && !effects.Contains(bornEffectId))
                        {
                            effects.Add(bornEffectId);
                        }
                        buffData.cloneBossId = npcId;
                    }
                    break;
                case SkillActionFrameEventType.FE_Buff:
                    {
                        int buffId = ev.GetN(Constants.s_skillaction_frame_key_buffid);
                        if (buffId > 0 && !buffs.Contains(buffId))
                            buffs.Add(buffId);
                    }
                    break;
                default:
                    break;
            }
        }

        for (int idx = 0; idx < buffData.BuffFunList.Count; idx++)
        {
            var data = buffData.BuffFunList[idx];
            if (data.effectId > 0 && !effects.Contains(data.effectId))
            {
                effects.Add(data.effectId);
            }
            if (data.endeffectId > 0 && !effects.Contains(data.endeffectId))
            {
                effects.Add(data.endeffectId);
            }
        }

        //添加的印记特效
        if(buffData.markData!=null && buffData.markData.markId > 0 && buffData.markData.markVal > 0)
        {
            MarkData markData = new MarkData(buffData.markData.markId);
            if(markData.Valid && markData.effectId > 0)
            {
                effects.Add(markData.effectId);
            }
        }

        if(effects.Count > 0)
            BattlePrepareManager.Instance.PrecacheEffects(effects.ToArray());

        if(bulletActors.Count > 0)
            BattlePrepareManager.Instance.PrecacheBullets(bulletActors.ToArray());

        if(sounds.Count > 0)
            MusicMgr.Instance.PreloadFightSound(sounds.ToArray());

        return buffs;
    }

    void OnLoadAssetsCompleted(List<GameObject> goes, string packageName, params string[] assetNames)
    {
        for (int idx = 0; idx < assetNames.Length; idx++)
        {
            GameObject instGo = ResourceMgr.Instance.GetGoFromPool(packageName, assetNames[idx]);
            if (instGo != null)
                ResourceMgr.Instance.RecycleGO(packageName, assetNames[idx], instGo);

        }

        CheckLoadStatus();
    }

    void OnLoadAssetsCompleted(List<RuntimeAnimatorController> ctrls,string packageName,params string[] assetNames)
    {
        CheckLoadStatus();
    }

    void CheckLoadStatus()
    {
        loadtaskCnt--;
        mIsLoading = loadtaskCnt > 0;
        loadingProgress += loadingDelta;

        EventMgr.DispatchEvent<float>(new CoreEvent<float>(ECoreEventType.EID_LOAD_PROGRESS, loadingProgress));
        if (!mIsLoading)
            EventMgr.DispatchEvent<bool>(new CoreEvent<bool>(ECoreEventType.EID_PREPARE_LOAD_OK, true));
    }
}

