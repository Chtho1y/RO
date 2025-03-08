using UnityEngine;
using UnityEditor;
using System.Collections;

[CustomEditor(typeof(GuideMask))]
[CanEditMultipleObjects]
public class GuideMaskEditor : Editor
{
    GuideMask item;
    private void OnEnable()
    {
        item = (GuideMask)target;
    }

    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();

        if (GUILayout.Button("SetTargetInfoClose"))
        {
            item.Init(null, null, null);
            Transform targetImg = item.target;
            Vector2 size = targetImg.GetComponent<RectTransform>().sizeDelta;
            size = new Vector2(100, 100);
            item.SetTargetInfoClose(targetImg.position, size, 0.5f);
        }

        if (GUILayout.Button("SetTargetInfoOpen"))
        {
            item.Init(null, null, null);
            Transform targetImg = item.target;
            Vector2 size = targetImg.GetComponent<RectTransform>().sizeDelta;
            size = new Vector2(100, 100);
            item.SetTargetInfoOpen(targetImg.position, size, 0.5f);
        }
    }
}