using UnityEngine;
using System.Collections;

public class Gray : MonoBehaviour
{
    SkinnedMeshRenderer[] mRenderers;

    // Use this for initialization
    void Start()
    {
        mRenderers = gameObject.GetComponentsInChildren<SkinnedMeshRenderer>();
    }

    public void SetGrey(bool gray)
    {
        if (mRenderers == null)
            mRenderers = gameObject.GetComponentsInChildren<SkinnedMeshRenderer>();

        if (mRenderers != null)
        {
            for (int i = 0; i < mRenderers.Length; i++)
            {
                if (mRenderers[i] != null)
                {
                    Material mMaterial = mRenderers[i].material;
                    if (mMaterial != null && mMaterial.HasProperty("_Strength"))
                    {
                        if (gray)
                        {
                            mMaterial.SetFloat("_Strength", 0.7f);
                        }
                        else
                        {
                            mMaterial.SetFloat("_Strength", 1);
                        }
                    }
                }
            }
        }
    }
}
