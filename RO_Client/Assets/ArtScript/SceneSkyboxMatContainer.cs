using UnityEngine;
using System.Collections;

public class SceneSkyboxMatContainer : MonoBehaviour
{
    public Material[] SkyboxMats;

    private Material lastSkyboxMat = null;

    public bool ChangeSkyboxMat(string matName)
    {
        if(string.IsNullOrEmpty(matName))
        {
            RenderSettings.skybox = null;
            return false;
        }

        if (SkyboxMats == null || SkyboxMats.Length == 0) return false;

        for(int idx =0; idx < SkyboxMats.Length;idx++)
        {
            if(SkyboxMats[idx].name == matName)
            {
                lastSkyboxMat = RenderSettings.skybox;
                RenderSettings.skybox = SkyboxMats[idx];
                return true;
            }
        }

        return false;
    }


    public void ChangeSkyboxMat(int matIdx)
    {
        if (SkyboxMats == null || SkyboxMats.Length == 0) return;

        if (matIdx < 0 || matIdx >= SkyboxMats.Length) return;

        lastSkyboxMat = RenderSettings.skybox;

        RenderSettings.skybox = SkyboxMats[matIdx];
    }


    public void RestoreSkyboxMat()
    {
        RenderSettings.skybox = lastSkyboxMat;
        lastSkyboxMat = null;
    }
}
