using UnityEngine;
using System.Collections;

public class RadialBlurEffect : PostEffectBase
{
    [Range(1, 32)]
    public int IterationNumber = 16;

    [Range(0, 1)]
    public float Intensity = 0.1f;

    [Range(-1, 1)]
    public float CenterX = 0;

    [Range(-1, 1)]
    public float CenterY = 0;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if(Mat)
        {
            Mat.SetFloat("_IterationNumber", IterationNumber);
            Mat.SetFloat("_Intensity", Intensity);
            Mat.SetFloat("_OffsetX", CenterX + 0.5f);
            Mat.SetFloat("_OffsetY", CenterY + 0.5f);
            Graphics.Blit(source, destination, Mat);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }

    public void FadeIn()
    {
        this.enabled = true;
    }

    public void FadeOut()
    {
        this.enabled = false;
    }
}
