using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace UIExtensions
{
    public class UIParticleOptimizeReference : UIParticle
    {
        [SerializeField]
        private string shaderName;
        [SerializeField]
        private string shaderPath;
        [SerializeField]
        private Texture2D texture2D;

        private Material m_TempMaterial;

        protected override void OnEnable()
        {
            base.OnEnable();
            if (!m_TempMaterial)
            {
                Shader shader = ResourceMgr.Instance.FindShader(shaderName, shaderPath);
                if (shader)
                {
                    m_TempMaterial = new Material(shader);
                }
                else
                {
                    _renderer.enabled = false;
                }
            }
            if (m_TempMaterial)
            {
                m_TempMaterial.SetTexture("_MainTex", texture2D);
                _renderer.sharedMaterial = m_TempMaterial;
            }
            else
            {
                _renderer.enabled = false;
            }
        }

        protected override void OnDisable()
        {
            base.OnDisable();
        }

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
                m_TempMaterial = null;
                _renderer.sharedMaterial = null;
            }
        }
    }
}