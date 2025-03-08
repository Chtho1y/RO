using UnityEngine;
using System.Collections;
using System;
using System.Collections.Generic;

public class PrefabLightmapData : MonoBehaviour
{
    //LightMap 信息
    [System.Serializable]
    public struct RendererInfo
    {
        public Renderer renderer;
        public int lightmapIndex;
        public Vector4 lightmapOffsetScale;

        public int realtimeLightmapIndex;
        public Vector4 realtimeLightmapScaleOffset;
        public string shaderName;
        public string shaderPath;
    }

    public List<RendererInfo> m_RendererInfo;
    public List<Texture2D> lightmapColor;
    public List<Texture2D> lightmapDir;
    public LightmapData[] lightmapDataList;
    public LightmapsMode lightmapsMode;

    /// <summary>
    /// 设置光照数据
    /// </summary>
    [ContextMenu("SetUpLightmap")]
    public void SetUpLightmap()
    {
        int count = lightmapColor.Count > lightmapDir.Count ? lightmapColor.Count : lightmapDir.Count;
        lightmapDataList = new LightmapData[count];
        for (int idx = 0; idx < count; idx++)
        {
            lightmapDataList[idx] = new LightmapData();
            lightmapDataList[idx].lightmapColor = idx < lightmapColor.Count ? lightmapColor[idx] : null;
            lightmapDataList[idx].lightmapDir = idx < lightmapDir.Count ? lightmapDir[idx] : null;
        }

        LightmapSettings.lightmapsMode = lightmapsMode;
        LightmapSettings.lightmaps = lightmapDataList;
        LoadLightmap();
    }


    /// <summary>
    /// 保存lightmap数据
    /// </summary>
    [ContextMenu("SaveLightmap")]
    public void SaveLightmap()
    {
        SaveLightmapData();
    }


    /// <summary>
    /// 保存lightmap信息
    /// </summary>
    private void SaveLightmapData()
    {
        lightmapColor = new List<Texture2D>();
        lightmapDir = new List<Texture2D>();
        LightmapData[] lightmaps = LightmapSettings.lightmaps;

        for (int idx = 0; idx < lightmaps.Length; idx++)
        {
            LightmapData data = lightmaps[idx];
            if (data.lightmapColor != null)
            {
                lightmapColor.Add(data.lightmapColor);
            }

            if (data.lightmapDir != null)
            {
                lightmapDir.Add(data.lightmapDir);
            }
        }

        m_RendererInfo = new List<RendererInfo>();
        MeshRenderer[] renderers = GetComponentsInChildren<MeshRenderer>();
        for (int idx = 0; idx < renderers.Length; idx++)
        {
            MeshRenderer renderer = renderers[idx];
            if (renderer.lightmapIndex != -1)
            {
                RendererInfo info = new RendererInfo();
                info.renderer = renderer;
                info.lightmapOffsetScale = renderer.lightmapScaleOffset;
                info.lightmapIndex = renderer.lightmapIndex;
                info.realtimeLightmapIndex = renderer.realtimeLightmapIndex;
                info.realtimeLightmapScaleOffset = renderer.realtimeLightmapScaleOffset;
                info.shaderName = renderer.sharedMaterial.shader.name;
#if UNITY_EDITOR
                info.shaderPath = UnityEditor.AssetDatabase.GetAssetPath(renderer.sharedMaterial.shader);
#endif
                m_RendererInfo.Add(info);
            }
        }

        lightmapsMode = LightmapSettings.lightmapsMode;
    }

    /// <summary>
    /// 加载lightmap信息
    /// </summary>
    private void LoadLightmap()
    {
        if (m_RendererInfo.Count <= 0) return;

        for (int idx = 0; idx < m_RendererInfo.Count; idx++)
        {
            RendererInfo item = m_RendererInfo[idx];
            item.renderer.lightmapIndex = item.lightmapIndex;
            item.renderer.lightmapScaleOffset = item.lightmapOffsetScale;
            item.renderer.realtimeLightmapIndex = item.realtimeLightmapIndex;
            item.renderer.realtimeLightmapScaleOffset = item.realtimeLightmapScaleOffset;
            Shader shader = ResourceMgr.Instance.FindShader(item.shaderName, item.shaderPath);
            if(shader!=null)
                item.renderer.material.shader = shader;
        }
    }
}
