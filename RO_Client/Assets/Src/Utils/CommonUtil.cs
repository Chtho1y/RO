using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public static class CommonUtil
{
    /// <summary>
    /// 写成静态，可以给不同的地方进行调用 [调用完之后请调用 CleanPreloadContain 清空处理]
    /// </summary>
    public static List<int> s_Effects = new List<int>();
    public static List<int> s_Secondactors = new List<int>();
    public static List<int> s_Buffs = new List<int>();
    public static List<string> s_Sounds = new List<string>();
    public static List<string> s_Prefabs = new List<string>();
    public static List<string> s_FbxAnims = new List<string>();

    public static Shader shaderTexture = Shader.Find("Mobile/Unlit (Supports Lightmap)");
    public static Shader shaderProjector = Shader.Find("Projector/Multiply");
    public static Shader shaderDoubleRim = Shader.Find("GOD/DoubleRim");
    public static Shader shaderDoubleRimRed = Shader.Find("GOD/DoubleRimRed");
    public static Shader shaderDoubleRimRedEx = Shader.Find("GOD/DoubleRimRedEx");
    public static Shader shagerCustomFog = Shader.Find("GOD/CustomFog");

    public static string s_AssetsMappingPkgName = "assetsmapping.ab";

    public static void CleanPreloadContain()
    {
        s_Effects.Clear();
        s_Secondactors.Clear();
        s_Buffs.Clear();
        s_Sounds.Clear();
        s_Prefabs.Clear();
        s_FbxAnims.Clear();
    }

    public static void RefreshModel(Transform trans, bool useSpecShader = false)
    {
        Shader shader;

        if (trans == null)
            return;
        for (int i = 0; i < trans.childCount; ++i)
        {
            RefreshModel(trans.GetChild(i), useSpecShader);
        }

        Renderer r = trans.GetComponent<Renderer>();
        if (r != null)
        {
            foreach (Material m in r.materials)
            {
                if (m != null)
                {
                    if (useSpecShader)
                    {
                        DebugHelper.LogWarning("[ refreshModel ]r:{0}, m:{1}, old shader:{2}, shader:{3}.", r, m, m.shader, shaderTexture);
                    }
                    shader = useSpecShader ? shaderTexture : Shader.Find(m.shader.name);
                    if (shader)
                        m.shader = shader;
                }
            }
        }
    }

    public static void SetGameObjectLayer(GameObject go, string layerName)
    {
        if (go == null)
            return;
        LayerMask mask = LayerMask.NameToLayer(layerName);
        SetGameObjectLayer(go.transform, mask);
    }

    public static void SetGameObjectLayerFrom(GameObject go, string fromLayer, string toLayer)
    {
        if (go == null)
            return;
        LayerMask fromMask = LayerMask.NameToLayer(fromLayer);
        LayerMask toMask = LayerMask.NameToLayer(toLayer);
        SetGameObjectLayerFrom(go.transform, fromMask, toMask);
    }

    public static void SetGameObjectLayer(GameObject go, int layer)
    {
        if (go == null)
            return;
        for (int i = 0; i < go.transform.childCount; ++i)
        {
            SetGameObjectLayer(go.transform.GetChild(i), layer);
        }
        go.layer = layer;
    }

    public static void SetGameObjectLayerExcept(Transform t, int layer, int exceptLayerMask)
    {
        if (t == null)
            return;

        if (exceptLayerMask != 0)
        {
            int checkMask = 1 << t.gameObject.layer;
            if ((checkMask & exceptLayerMask) != 0)
                return;
        }

        for (int i = 0; i < t.childCount; ++i)
            SetGameObjectLayerExcept(t.GetChild(i), layer, exceptLayerMask);

        t.gameObject.layer = layer;
    }

    public static void SetGameObjectLayerFrom(GameObject go, int fromLayer, int toLayer)
    {
        if (go == null)
            return;
        for (int i = 0; i < go.transform.childCount; ++i)
            SetGameObjectLayerFrom(go.transform.GetChild(i), fromLayer, toLayer);
        if (go.layer == fromLayer)
            go.layer = toLayer;
    }

    static void SetGameObjectLayer(Transform trans, LayerMask mask)
    {
        if (trans == null)
            return;
        for (int i = 0; i < trans.childCount; ++i)
        {
            SetGameObjectLayer(trans.GetChild(i), mask);
        }
        trans.gameObject.layer = mask;
    }

    static void SetGameObjectLayerFrom(Transform trans, LayerMask fromLayer, LayerMask toLayer)
    {
        if (trans == null)
            return;
        for (int i = 0; i < trans.childCount; ++i)
        {
            SetGameObjectLayerFrom(trans.GetChild(i), fromLayer, toLayer);
        }
        if (trans.gameObject.layer == fromLayer)
            trans.gameObject.layer = toLayer;
    }


    static public GameObject AddChild(GameObject parent, GameObject prefab, bool resetPosition = false, bool instantiate = true)
    {
        GameObject go = instantiate ? (GameObject.Instantiate(prefab) as GameObject) : prefab;
#if UNITY_EDITOR
        UnityEditor.Undo.RegisterCreatedObjectUndo(go, "Create Object");
#endif
        if (go != null && parent != null)
        {
            Transform t = go.transform;
            t.SetParent(parent.transform);

            if (resetPosition)
            {
                t.localPosition = Vector3.zero;
                t.localRotation = Quaternion.identity;
            }

            t.localScale = Vector3.one;
            go.layer = parent.layer;
        }

        return go;
    }

    public static IEnumerator WaitForUnscaleTime(float time)
    {
        float waitTime = 0f;
        while (waitTime < time)
        {
            yield return 1;
            waitTime += Time.unscaledDeltaTime;
        }
    }

    public static Vector3 ConvertPosToUIPos(Vector3 worldPos)
    {
        if (Camera.main == null) return worldPos;

        Vector3 pos1 = Camera.main.WorldToScreenPoint(worldPos);
        return CameraMgr.Instance.UICamera.ScreenToWorldPoint(pos1);
    }

    #region Sound

    static public bool GetActive(Behaviour mb)
    {
        return mb && mb.enabled && mb.gameObject.activeInHierarchy;
    }

    /// <summary>
    /// Play the specified audio clip.
    /// </summary>

    static private AudioSource PlaySound(AudioClip clip) { return PlaySound(clip, 1f, 1f); }

    /// <summary>
    /// Play the specified audio clip with the specified volume.
    /// </summary>

    static private AudioSource PlaySound(AudioClip clip, float volume) { return PlaySound(clip, volume, 1f); }

    /// <summary>
    /// Play the specified audio clip with the specified volume and pitch.
    /// </summary>

    static AudioListener mListener = null;
    static private AudioSource PlaySound(AudioClip clip, float volume, float pitch)
    {
        //volume *= soundVolume;

        if (clip != null && volume > 0.01f)
        {
            if (mListener == null || !GetActive(mListener))
            {
                AudioListener[] listeners = GameObject.FindObjectsOfType(typeof(AudioListener)) as AudioListener[];

                if (listeners != null)
                {
                    for (int i = 0; i < listeners.Length; ++i)
                    {
                        if (GetActive(listeners[i]))
                        {
                            mListener = listeners[i];
                            break;
                        }
                    }
                }

                if (mListener == null)
                {
                    Camera cam = Camera.main;
                    if (cam == null) cam = GameObject.FindObjectOfType(typeof(Camera)) as Camera;
                    if (cam != null) mListener = cam.gameObject.AddComponent<AudioListener>();
                }
            }

            if (mListener != null && mListener.enabled && GetActive(mListener))
            {
                AudioSource source = mListener.GetComponent<AudioSource>();
                if (source == null) source = mListener.gameObject.AddComponent<AudioSource>();
                source.pitch = pitch;
                source.PlayOneShot(clip, volume);
                return source;
            }
        }
        return null;
    }

    public static void SortList<T>(System.Collections.Generic.List<T> list, System.Comparison<T> comparer)
    {
        for (int i = 1; i < list.Count; i++)
        {
            for (int j = 0; j < i; j++)
            {
                if (comparer(list[j], list[i]) > 0)
                {
                    list.Insert(j, list[i]);
                    list.RemoveAt(i + 1);
                    break;
                }
            }
        }
    }

    public static string GetProfessionName(int type)
    {
        ProfessionType ptype = (ProfessionType)type;
        switch(ptype)
        {
            case ProfessionType.Pro_Type_0:
                return "初心者";
            case ProfessionType.Pro_Type_Sword:
                return "剑士";
            case ProfessionType.Pro_Type_Hunter:
                return "猎人";
            case ProfessionType.Pro_Type_Magic:
                return "法师";
            case ProfessionType.Pro_Type_Priest:
                return "手持";
            case ProfessionType.Pro_Type_Thief:
                return "盗贼";
        }
        return "";
    }

    public static long CalcNpcUniqueId(int mapId, int levelId, int pos, int baseId)
    {
        return mapId * 10000000 + levelId * 100000 + baseId * 10 + pos;
    }

    public static long CalcPointUniqueId(int mapId,int pointCnt,int pos)
    {
        return mapId * 1000000 + pointCnt * 10000 + pos;
    }

    public static long CalcSummonNpcUniqueId(int mapId,int num)
    {
        return mapId * 100000 + num;
    }

    #endregion
}