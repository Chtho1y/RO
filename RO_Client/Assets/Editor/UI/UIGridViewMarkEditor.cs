using UnityEngine;
using UnityEditor;
using System.Collections;
[CustomEditor(typeof(UIGridViewMark))]
[CanEditMultipleObjects]
public class UIGridViewMarkEditor : Editor
{
    UIGridViewMark item;
    private void OnEnable()
    {
        item = (UIGridViewMark)target;
    }

    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();

        serializedObject.Update();

        GameObject master = item.gameObject;
        if (string.IsNullOrEmpty(item.GridItemName))
        {
            item.GridItemName = master.name;
        }
        if (string.IsNullOrEmpty(item.GridItemName))
        {
            item.OriName = master.name;
        } 
        EditorUtility.SetDirty(target);
        serializedObject.ApplyModifiedProperties();
    }
}
