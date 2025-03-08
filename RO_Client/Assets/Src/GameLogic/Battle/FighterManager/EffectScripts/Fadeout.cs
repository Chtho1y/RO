using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Fadeout : MonoBehaviour
{
    public float time = 1;

    float playTime;
    SkinnedMeshRenderer[] mRenderers;
    string orgShaderName;
    float orgStrength = 1.0f;
    List<Shader> orgShaders = new List<Shader>();
    Shader fadeOutShader = null;

    int mAplhaPropId = 0;
    int mClrStrengthPropId = 0;

    List<MaterialPropertyBlock> mPropBlocks;
    private void Awake()
    {
        mAplhaPropId = Shader.PropertyToID("_Alpha");
        mClrStrengthPropId = Shader.PropertyToID("_ClrStrength");
        mPropBlocks = new List<MaterialPropertyBlock>();


        if (mRenderers == null)
            mRenderers = GetComponentsInChildren<SkinnedMeshRenderer>();
        if(mRenderers!=null)
        {
            for(int idx =0; idx < mRenderers.Length;idx++)
            {
                mPropBlocks.Add(new MaterialPropertyBlock());
            }
        }

    }

    void OnEnable()
    {
        playTime = 0;

        if (mRenderers == null)
            mRenderers = GetComponentsInChildren<SkinnedMeshRenderer>();

        orgShaders.Clear();

        if(fadeOutShader == null)
            fadeOutShader = ResourceMgr.Instance.FindShader("Hero/FadeOut", "Assets/Shaders/Actor/FadeOut");

        for (int i = 0; i < mRenderers.Length; i++)
        { 
            if (mRenderers[i] != null && mRenderers[i].material != null)
            {
                orgShaders.Add(mRenderers[i].material.shader);

                orgShaderName = mRenderers[i].material.shader.name;

                if(fadeOutShader != null)
                {
                    mRenderers[i].material.shader = fadeOutShader;
                }
                //mRenderers[i].material.SetFloat("_Alpha", 1);
                orgStrength = mRenderers[i].material.GetFloat("_ClrStrength");
                mPropBlocks[i].SetFloat(mAplhaPropId, 1);
                mRenderers[i].SetPropertyBlock(mPropBlocks[i]);
            }
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (mRenderers != null && time > 0)
        {
            for (int i = 0; i < mRenderers.Length; i++)
                if (mRenderers[i] != null && mRenderers[i].material != null)
                { 
                    //mRenderers[i].material.SetFloat("_Alpha", 1 - playTime / time);
                    //mRenderers[i].material.SetFloat("_ClrStrength", 0.9f + 0.8f * playTime / time);

                    mPropBlocks[i].SetFloat(mAplhaPropId, 1 - playTime / time);
                    mPropBlocks[i].SetFloat(mClrStrengthPropId, 0.9f + 0.8f * playTime / time);
                    mRenderers[i].SetPropertyBlock(mPropBlocks[i]);
                }
        }

        playTime += Time.deltaTime;
    }

    public void Reset()
    {
        for (int i = 0; i < mRenderers.Length; i++)
        {
            if (mRenderers[i] != null && mRenderers[i].material != null)
            {
                //mRenderers[i].material.SetFloat("_Alpha", 1);
                //mRenderers[i].material.SetFloat("_ClrStrength", orgStrength);
                mPropBlocks[i].SetFloat(mAplhaPropId, 1);
                mPropBlocks[i].SetFloat(mClrStrengthPropId, orgStrength);
                mRenderers[i].SetPropertyBlock(mPropBlocks[i]);
                mRenderers[i].material.shader = orgShaders[i];
            }
        }
    }
}
