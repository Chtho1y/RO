using UnityEngine;
using System.Collections;

public class Stiff : MonoBehaviour
{
    SkinnedMeshRenderer[] mRenderers;

    // Use this for initialization
    void Start()
    {
        mRenderers = gameObject.GetComponentsInChildren<SkinnedMeshRenderer>();
    }

    // Update is called once per frame
    public void SetStiff(bool stiff)
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
                    if (mMaterial != null && mMaterial.HasProperty("_StatueDegree"))
                    {
                        if (stiff)
                        {
                            mMaterial.SetFloat("_StatueDegree", 1.0f);
                        }
                        else
                        {
                            mMaterial.SetFloat("_StatueDegree", 0.0f);
                        }
                    }
                }
            }
        }
    }
}
