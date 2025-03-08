using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class PostEffectHelper {

    public static RawImage renderTargetRawImage = null;
    public static int renderTextureWidth = 640;
    public static Material material;

    static RenderTexture sharedRenderTexture;
    static int sharedRenderTextureRefCount;
    public static void RefSharedRenderTexture(float aspect = 0)
    {
        sharedRenderTextureRefCount++;
        if (sharedRenderTexture == null)
        {
            if (aspect == 0)
                aspect = Screen.width * 1f / Screen.height;

            int width = renderTextureWidth > Screen.width ? Screen.width : renderTextureWidth;
            int height = Mathf.RoundToInt(width / aspect);
            sharedRenderTexture = new RenderTexture(width, height, 16);
            sharedRenderTexture.hideFlags = HideFlags.DontSave;

            if (renderTargetRawImage != null)
            {
                renderTargetRawImage.texture = sharedRenderTexture;
                renderTargetRawImage.material = material;
                renderTargetRawImage.gameObject.SetActive(true);
            }
        }
    }

    public static void UnRefSharedRenderTexture()
    {
        sharedRenderTextureRefCount--;
        if (sharedRenderTextureRefCount <= 0)
        {
            if (renderTargetRawImage != null)
            {
                renderTargetRawImage.texture = null;
                renderTargetRawImage.material = null;
                renderTargetRawImage.gameObject.SetActive(false);
            }

            GameObject.DestroyImmediate(sharedRenderTexture);
            sharedRenderTexture = null;
        }
    }

    public static RenderTexture SharedRenderTexture
    {
        get { return sharedRenderTexture; }
    }
}
