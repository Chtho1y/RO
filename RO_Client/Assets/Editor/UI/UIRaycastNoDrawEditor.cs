using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(UIRaycastNoDraw))]
public class UIRaycastNoDrawEditor : Editor
{
    private SerializedProperty m_Script;
    private SerializedProperty m_RaycastTarget;

    private void OnEnable()
    {
        m_Script = serializedObject.FindProperty("m_Script");
        m_RaycastTarget = serializedObject.FindProperty("m_RaycastTarget");
    }

    public override void OnInspectorGUI()
    {
        serializedObject.UpdateIfRequiredOrScript();
        using (new EditorGUI.DisabledScope(true))
        {
            EditorGUILayout.PropertyField(m_Script, true);
        }
        EditorGUILayout.PropertyField(m_RaycastTarget, true);
        serializedObject.ApplyModifiedProperties();
        EditorGUILayout.Separator();
        EditorGUILayout.HelpBox("该组件可以使被挂载的对象能被点击，但是不进入渲染队列", MessageType.Info);
        EditorGUILayout.Separator();
    }
}
