using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;


[CustomEditor(typeof(SlideHorizontalOrVerticalLayoutGroup), true)]
[CanEditMultipleObjects]
public class SlideHorizontalOrVerticalLayoutGroupEditor : Editor
{
    SerializedProperty m_Padding;
    SerializedProperty m_Spacing;
    SerializedProperty m_ChildAlignment;
    SerializedProperty m_ChildControlWidth;
    SerializedProperty m_ChildControlHeight;
    SerializedProperty m_ChildForceExpandWidth;
    SerializedProperty m_ChildForceExpandHeight;
    SerializedProperty m_SnapEnable;
    SerializedProperty m_InverseChildPosEnable;
    SerializedProperty m_InvisibleVaild;

    protected virtual void OnEnable()
    {
        m_Padding = serializedObject.FindProperty("m_Padding");
        m_Spacing = serializedObject.FindProperty("m_Spacing");
        m_ChildAlignment = serializedObject.FindProperty("m_ChildAlignment");
        m_ChildControlWidth = serializedObject.FindProperty("m_ChildControlWidth");
        m_ChildControlHeight = serializedObject.FindProperty("m_ChildControlHeight");
        m_ChildForceExpandWidth = serializedObject.FindProperty("m_ChildForceExpandWidth");
        m_ChildForceExpandHeight = serializedObject.FindProperty("m_ChildForceExpandHeight");
        m_SnapEnable = serializedObject.FindProperty("m_SnapEnable");
        m_InverseChildPosEnable = serializedObject.FindProperty("m_InverseChildPosEnable");
        m_InvisibleVaild = serializedObject.FindProperty("m_InvisibleVaild");
    }

    public override void OnInspectorGUI()
    {
        serializedObject.Update();
        EditorGUILayout.PropertyField(m_Padding, true);
        EditorGUILayout.PropertyField(m_Spacing, true);
        EditorGUILayout.PropertyField(m_ChildAlignment, true);

        Rect rect = EditorGUILayout.GetControlRect();
        rect = EditorGUI.PrefixLabel(rect, -1, EditorGUIUtility.TrTextContent("Child Controls Size"));
        rect.width = Mathf.Max(50, (rect.width - 4) / 3);
        EditorGUIUtility.labelWidth = 50;
        ToggleLeft(rect, m_ChildControlWidth, EditorGUIUtility.TrTextContent("Width"));
        rect.x += rect.width + 2;
        ToggleLeft(rect, m_ChildControlHeight, EditorGUIUtility.TrTextContent("Height"));
        EditorGUIUtility.labelWidth = 0;

        rect = EditorGUILayout.GetControlRect();
        rect = EditorGUI.PrefixLabel(rect, -1, EditorGUIUtility.TrTextContent("Child Force Expand"));
        rect.width = Mathf.Max(50, (rect.width - 4) / 3);
        EditorGUIUtility.labelWidth = 50;
        ToggleLeft(rect, m_ChildForceExpandWidth, EditorGUIUtility.TrTextContent("Width"));
        rect.x += rect.width + 2;
        ToggleLeft(rect, m_ChildForceExpandHeight, EditorGUIUtility.TrTextContent("Height"));
        EditorGUIUtility.labelWidth = 0;

        EditorGUILayout.PropertyField(m_SnapEnable, true);
        EditorGUILayout.PropertyField(m_InverseChildPosEnable, true);

        if (!m_ChildControlWidth.boolValue && !m_ChildControlHeight.boolValue)
        {
            EditorGUILayout.PropertyField(m_InvisibleVaild, true);
        }
        else
        {
            if (m_InvisibleVaild.boolValue)
            {
                m_InvisibleVaild.boolValue = false;
            }
        }

        serializedObject.ApplyModifiedProperties();
    }

    void ToggleLeft(Rect position, SerializedProperty property, GUIContent label)
    {
        bool toggle = property.boolValue;
        EditorGUI.showMixedValue = property.hasMultipleDifferentValues;
        EditorGUI.BeginChangeCheck();
        int oldIndent = EditorGUI.indentLevel;
        EditorGUI.indentLevel = 0;
        toggle = EditorGUI.ToggleLeft(position, label, toggle);
        EditorGUI.indentLevel = oldIndent;
        if (EditorGUI.EndChangeCheck())
        {
            property.boolValue = property.hasMultipleDifferentValues ? true : !property.boolValue;
        }
        EditorGUI.showMixedValue = false;
    }
}
