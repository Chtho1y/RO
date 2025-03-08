using UnityEngine;
using System.Collections;

public class RimColor : MonoBehaviour
{
    SkinnedMeshRenderer[] mRenderers;

    Color multiClr = new Color(160.0f/255, 221.0f/255, 233.0f/255);
    // Use this for initialization
    void Start()
    {
        mRenderers = gameObject.GetComponentsInChildren<SkinnedMeshRenderer>();
    }

    public void SetRimColor(bool enabled,Color clr)
    {
        if(enabled)
        {
            if (mRenderers == null)
                mRenderers = gameObject.GetComponentsInChildren<SkinnedMeshRenderer>();
            if (mRenderers != null)
            {
                for (int i = 0; i < mRenderers.Length; i++)
                {
                    if (mRenderers[i] != null && mRenderers[i].material != null)
                    {
                        mRenderers[i].material.SetFloat("_Rim_Strength", 0.85f);
                        mRenderers[i].material.SetColor("_Muti_Color", multiClr);
                        mRenderers[i].material.SetColor("_Rim_Color", clr);
                    }
                }
            }
        }
        else
        {
            if (mRenderers != null)
            {
                for (int i = 0; i < mRenderers.Length; i++)
                {
                    if (mRenderers[i] != null && mRenderers[i].material != null)
                    {
                        mRenderers[i].material.SetFloat("_Rim_Strength", 0);
                        mRenderers[i].material.SetColor("_Muti_Color", Color.white);
                        mRenderers[i].material.SetColor("_Rim_Color", Color.black);
                    }
                }
            }
        }
    }
}
