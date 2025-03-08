using UnityEngine;
using System.Collections;

public class AtlasInfo : ScriptableObject {

    [System.Serializable]
    public class UVDetail
    {
        public Vector2 uvTL;

        public Vector2 uvTR;

        public Vector2 uvBL;

        public Vector2 uvBR;

        public bool rotate;

        public string Name;

        public int x;

        public int y;

        public int width;

        public int height;
    }


    public Texture2D texture;

    public Texture2D textureAlpha;

    public UVDetail[] uvDetails;

    public Material specialMaterial = null;

    [System.NonSerialized]
    private Material m_material = null;


    public UVDetail GetUV(string atlasName)
    {
        if(string.IsNullOrEmpty(atlasName))
        {
            return null;
        }
        for(int i = 0; i < uvDetails.Length; ++i)
        {
            if(uvDetails[i].Name == atlasName)
            {
                return uvDetails[i];
            }
        }
        return null;
    }


    public Material material
    {
        get
        {
            if(null == m_material)
            {
                if (specialMaterial != null)
                {
                    m_material = specialMaterial;
                }
                else
                {
                    Shader shader = Shader.Find("UI/UI3D");
                    m_material = new Material(shader);
                }
                m_material.SetTexture("_MainTex", texture);
                if (null != textureAlpha)
                {
                    m_material.SetTexture("_AlphaTex", textureAlpha);
                    m_material.EnableKeyword("_SEPERATE_ALPHA_TEX_ON");
                }
            }
            return m_material;
        }
    }
}
