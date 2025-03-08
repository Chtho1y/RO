using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

[RequireComponent(typeof(Graphic))]
[ExecuteAlways]
public class UIEdgeFadeEffect : UIBehaviour, IMaterialModifier 
{
    public enum EdgeType
    {
        UV = 1,
        Size = 2,
    }

    [HideInInspector][SerializeField]
    private EdgeType m_EdgeType = EdgeType.UV;

    public EdgeType edgeType
    {
        get { return m_EdgeType; }
        set
        {
            if (m_EdgeType == value) return;
            m_EdgeType = value;
            SetDirty();
        }
    }

    [HideInInspector][SerializeField]
    private float m_EdgeValue = 0;

    public float edgeValue
    {
        get { return m_EdgeValue; }
        set
        {
            if (m_EdgeValue == value) return;
            m_EdgeValue = value;
            SetDirty();
        }
    }

    private Material m_TempMaterial;
    private Graphic m_Graphic;

    protected override void OnDestroy()
    {
        base.OnDestroy();
        if (m_TempMaterial)
        {
#if UNITY_EDITOR
            if (Application.isPlaying)
            {
                Destroy(m_TempMaterial);
            }
            else
            {
                DestroyImmediate(m_TempMaterial);
            }
#else
            Destroy(m_TempMaterial);
#endif
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
        if (!m_TempMaterial)
        {
            Shader shader = ResourceMgr.Instance.FindShader("RO/UI/UIEdgeFade", "Assets/Shaders/UI/UIEdgeFade");
            if (!shader)
            {
                enabled = false;
                return;
            }
            m_TempMaterial = new Material(shader);
        }
        if (!m_TempMaterial)
        {
            enabled = false;
            return;
        }
        SetDirty();
    }

    protected override void OnDisable()
    {
        base.OnDisable();
        SetMaterialDirty();
    }
    
    public Material GetModifiedMaterial(Material baseMaterial)
    {
        if (m_TempMaterial)
        {
            return m_TempMaterial;
        }
        return baseMaterial;
    }

    private void SetDirty()
    {
        if (m_TempMaterial)
        {
            float realValue = m_EdgeValue;
            if (m_EdgeType == EdgeType.UV)
            {
                realValue = Mathf.Clamp01(realValue);
            }
            else if (m_EdgeType == EdgeType.Size)
            {
                RectTransform rectTransform = null;
                if (m_Graphic)
                {
                    rectTransform = m_Graphic.rectTransform;
                }
                if (rectTransform)
                {
                    Rect rect = rectTransform.rect;
                    float size = Mathf.Min(rect.width, rect.height);
                    if (size == 0)
                    {
                        realValue = 0;
                    }
                    else
                    {
                        realValue = realValue / size;
                        realValue = Mathf.Clamp01(realValue);
                    }

                }
            }
            m_TempMaterial.SetFloat("_EdgeValue", realValue);
        }
        SetMaterialDirty();
    }

    private void SetMaterialDirty()
    {
        if (m_Graphic)
        {
            m_Graphic.SetMaterialDirty();
        }
    }
}