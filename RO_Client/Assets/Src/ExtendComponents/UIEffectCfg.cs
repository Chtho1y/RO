using System;
using UnityEngine;
using System.Collections.Generic;

public class UIEffectCfg:MonoBehaviour
{
    [Serializable]
    public struct stUIEffect
    {
        /// <summary>
        /// 特效资源名字
        /// </summary>
        public string assetName;

        /// <summary>
        /// 特效挂载的parent路径
        /// </summary>
        public Transform parent;
    }

    
    public stUIEffect[] UsedEffect;

    bool mReady = false;

    List<String> mEffectNames;

    List<GameObject> mInstGoes;

    long loadingSeqId = 0;

    public bool Ready
    {
        get { return mReady; }
    } 
    

    public void LoadEffect()
    {
        if (UsedEffect == null || UsedEffect.Length == 0) return;

        mEffectNames = new List<string>();
        for (int idx = 0; idx < UsedEffect.Length; idx++)
        {
            stUIEffect effectCfg = UsedEffect[idx];
            string effectName = effectCfg.assetName;
            if (!string.IsNullOrEmpty(effectName))
            {
                if (!mEffectNames.Contains(effectName))
                    mEffectNames.Add(effectName);
            }
        }

        if (mEffectNames.Count > 0)
        {
            mReady = false;
            loadingSeqId =  ResourceMgr.Instance.LoadAsset<List<GameObject>>(OnLoadUIEffectCompleted, Constants.UIEffectPath, mEffectNames.ToArray());
        }
    }


    void OnLoadUIEffectCompleted(List<GameObject> prefabs, string assetPath, string[] assetNames)
    {
        mReady = true;
        loadingSeqId = 0;

        mInstGoes = new List<GameObject>();

        for (int idx = 0; idx < UsedEffect.Length; idx++)
        {
            stUIEffect effectCfg = UsedEffect[idx];
            if (!string.IsNullOrEmpty(effectCfg.assetName))
            {
                GameObject effectGo = ResourceMgr.Instance.GetGoFromPool(Constants.UIEffectPath, effectCfg.assetName);
                effectGo.name = effectCfg.assetName;
                effectGo.transform.SetParent(effectCfg.parent);
                effectGo.transform.localPosition = Vector3.zero;
                effectGo.transform.localRotation = Quaternion.identity;
                effectGo.transform.localScale = Vector3.one;
                effectGo.SetActive(false);
                mInstGoes.Add(effectGo);
            }
        }
    }

    void OnDestroy()
    {
        if (UsedEffect == null && UsedEffect.Length == 0) return;

        Clean();

        mInstGoes = null;
        UsedEffect = null;
    }

    /// <summary>
    /// 显示特效
    /// </summary>
    /// <param name="name"></param>
    /// <param name="parent"></param>
    /// <returns></returns>
    
    public void ShowEffect(string name, Transform parent)
    {
        if (string.IsNullOrEmpty(name) || parent == null) return;

        Transform effectNode = parent.Find(name);
        if (effectNode == null) return;

        effectNode.gameObject.SetActive(true);
    }

    public void HideEffect(string name, Transform parent)
    {
        if (string.IsNullOrEmpty(name) || parent == null) return;

        Transform effectNode = parent.Find(name);
        if (effectNode == null) return;

        effectNode.gameObject.SetActive(false);
    }

	public void Clean()
	{
        if(loadingSeqId > 0)
        {
            ResourceMgr.Instance.UnloadAssetBySeqId(loadingSeqId);
            loadingSeqId = 0;
        }

        if (mInstGoes != null && mInstGoes.Count > 0)
        {
            for (int idx = 0; idx < mInstGoes.Count; idx++)
            {
                ResourceMgr.Instance.RecycleGO(Constants.UIEffectPath, mInstGoes[idx].name, mInstGoes[idx]);
            }

            mInstGoes.Clear();
        }

        mReady = false;
    }
}