using UnityEditor;
using UnityEngine;
using UIExtensions;


public class UIParticleAdd
{
    [MenuItem("GameObject/UIParticleAdd", false, 22)]
    public static void AddUIParticle()
    {
        GameObject go = Selection.activeGameObject;
        ParticleSystem[] array = go.GetComponentsInChildren<ParticleSystem>();

        for (int i = 0; i < array.Length; ++i)
        {
            GameObject obj = array[i].gameObject;
            if (obj.GetComponent<RectTransform>() == null)
                ObjectFactory.AddComponent<RectTransform>(obj);

            UIParticle particle = obj.GetComponent<UIParticle>() == null ? obj.AddComponent<UIParticle>() : obj.GetComponent<UIParticle>();
            particle.cachedParticleSystem = array[i];
            if (i == 0)
            {
                UINode node = obj.GetComponent<UINode>() == null ? obj.AddComponent<UINode>() : obj.GetComponent<UINode>();
                node.UIName = go.name.ToLower();
            }
        }
        EditorUtility.SetDirty(go);

    }
}