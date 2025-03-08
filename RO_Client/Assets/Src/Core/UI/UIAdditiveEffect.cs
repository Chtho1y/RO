using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

[RequireComponent(typeof(Graphic))]
[ExecuteAlways]
public class UIAdditiveEffect : UIBehaviour, IMaterialModifier
{
    static private Material s_TempMaterial;
    static private int s_ReferenceNum = 0;

    private Graphic m_Graphic;

    protected override void OnDestroy()
    {
        base.OnDestroy();
        if (s_ReferenceNum <= 0 && s_TempMaterial)
        {
#if UNITY_EDITOR
            if (Application.isPlaying)
            {
                Destroy(s_TempMaterial);
            }
            else
            {
                DestroyImmediate(s_TempMaterial);
            }
#else
            Destroy(s_TempMaterial);
#endif
            s_TempMaterial = null;
            SetMaterialDirty();
        }
    }

    protected override void OnEnable()
    {
        base.OnEnable();
        if (!m_Graphic)
        {
            m_Graphic = GetComponent<Graphic>();
        }
        if (!m_Graphic)
        {
            enabled = false;
            return;
        }
        if (!s_TempMaterial)
        {
            Shader shader = ResourceMgr.Instance.FindShader("UI/UIAdditive", "Assets/Shaders/UI/UIAdditive");
            if (!shader)
            {
                enabled = false;
                return;
            }
            s_TempMaterial = new Material(shader);
        }
        if (!s_TempMaterial)
        {
            enabled = false;
            return;
        }
        s_ReferenceNum = s_ReferenceNum + 1;
        SetMaterialDirty();
    }

    protected override void OnDisable()
    {
        base.OnDisable();
        s_ReferenceNum = s_ReferenceNum - 1;
        SetMaterialDirty();
    }

    public Material GetModifiedMaterial(Material baseMaterial)
    {
        if (s_TempMaterial)
        {
            return s_TempMaterial;
        }
        return baseMaterial;
    }

    private void SetMaterialDirty()
    {
        if (m_Graphic)
        {
            m_Graphic.SetMaterialDirty();
        }
    }
}
