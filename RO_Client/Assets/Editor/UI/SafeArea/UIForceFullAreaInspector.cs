using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(UIForceFullArea))]
public class UIForceFullAreaInspector : Editor
{
    public override void OnInspectorGUI()
    {
        EditorGUILayout.HelpBox("不管在哪，保持区域铺满屏幕", MessageType.Info);
    }
}
