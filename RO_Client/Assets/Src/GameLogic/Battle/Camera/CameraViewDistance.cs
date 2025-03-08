using System;
using UnityEngine;

[ExecuteInEditMode]
[DisallowMultipleComponent]
[RequireComponent(typeof(Camera))]
public class CameraViewDistance : MonoBehaviour
{
    [SerializeField]
    private bool m_LayerCullSpherical;
    [SerializeField]
    private float[] m_LayerCullDistances;

    private Camera m_Camera;
    private float[] m_DefaultLayerCullDistances;

    private void Awake() {
        m_Camera = GetComponent<Camera>();
        m_DefaultLayerCullDistances = m_Camera.layerCullDistances;
        if (m_LayerCullDistances == null)
        {
            m_LayerCullDistances = new float[m_DefaultLayerCullDistances.Length];
            m_DefaultLayerCullDistances.CopyTo(m_LayerCullDistances, 0);
        }
    }

    private void OnEnable() {
        m_Camera.layerCullSpherical = m_LayerCullSpherical;
        m_Camera.layerCullDistances = m_LayerCullDistances;
    }

    private void OnDisable() {
        m_Camera.layerCullSpherical = false;
        m_Camera.layerCullDistances = m_DefaultLayerCullDistances;
    }

#if UNITY_EDITOR
    public void Refresh()
    {
        OnEnable();
    }
#endif
}
