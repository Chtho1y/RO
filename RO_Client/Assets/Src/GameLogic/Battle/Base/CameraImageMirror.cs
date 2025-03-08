using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class CameraImageMirror : MonoBehaviour
{
    static Material m_Material = null;
    static Material material
    {
        get
        {
            if (m_Material == null)
            {
                m_Material = new Material(Shader.Find("Custom/MirrorImage"));
                m_Material.hideFlags = HideFlags.DontSave;
            }
            return m_Material;
        }
    }

    // --------------------------------------------------------
    Camera c;
    bool hasRenderTextureRef = false;    
    // --------------------------------------------------------

    protected void Start()
    {
        // Disable if we don't support image effects
        if (!SystemInfo.supportsImageEffects)
        {
            enabled = false;
            return;
        }
        // Disable if the shader can't run on the users graphics card
        if (material.shader == null || !material.shader.isSupported)
        {
            enabled = false;
            return;
        }

        if (c == null)
            c = GetComponent<Camera>();
    }

    void OnEnable()
    {
        if (c == null)
            c = GetComponent<Camera>();

        if (c != null)
        {
            PostEffectHelper.material = material;
            PostEffectHelper.RefSharedRenderTexture(c.aspect);
            hasRenderTextureRef = true;
            c.targetTexture = PostEffectHelper.SharedRenderTexture;
        }
    }
    protected void OnDisable()
    {
        if (c.targetTexture != null)
            c.targetTexture = null;

        if (hasRenderTextureRef)
            PostEffectHelper.UnRefSharedRenderTexture();
    }
}
