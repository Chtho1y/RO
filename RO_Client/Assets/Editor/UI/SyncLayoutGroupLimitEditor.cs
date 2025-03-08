using System;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;
using UnityEditor.UI;
using FitMode = UnityEngine.UI.ContentSizeFitter.FitMode;

[CustomEditor(typeof(SyncLayoutGroupLimit), true)]
[CanEditMultipleObjects]
public class SyncLayoutGroupLimitEditor : Editor
{
    private SerializedProperty m_LayoutPriority;
    private SerializedProperty m_SyncTargetRect;
    private SerializedProperty m_HorizontalFit;
    private SerializedProperty m_VerticalFit;
    private SerializedProperty m_MaxWidth;
    private SerializedProperty m_MaxHeight;

    protected virtual void OnEnable()
    {
        m_LayoutPriority = serializedObject.FindProperty("m_LayoutPriority");
        m_SyncTargetRect = serializedObject.FindProperty("m_SyncTargetRect");
        m_HorizontalFit = serializedObject.FindProperty("m_HorizontalFit");
        m_VerticalFit = serializedObject.FindProperty("m_VerticalFit");
        m_MaxWidth = base.serializedObject.FindProperty("m_MaxWidth");
        m_MaxHeight = base.serializedObject.FindProperty("m_MaxHeight");
    }

    /// <summary>
    ///   <para>See: Editor.OnInspectorGUI.</para>
    /// </summary>
    public override void OnInspectorGUI()
    {
        serializedObject.Update();
        EditorGUILayout.PropertyField(m_SyncTargetRect);
        EditorGUILayout.Space();
        if (m_SyncTargetRect.objectReferenceValue)
        {
            EditorGUILayout.PropertyField(m_HorizontalFit, true);
            FitMode fitMode = (FitMode)Enum.Parse(typeof(FitMode), m_HorizontalFit.enumNames[m_HorizontalFit.enumValueIndex]);
            if (fitMode == FitMode.MinSize)
            {
                LayoutElementField(m_MaxWidth, t => LayoutUtility.GetMinWidth(t));
            }
            else if (fitMode == FitMode.PreferredSize)
            {
                LayoutElementField(m_MaxWidth, t => LayoutUtility.GetPreferredWidth(t));
            }
            EditorGUILayout.PropertyField(m_VerticalFit, true);
            fitMode = (FitMode)Enum.Parse(typeof(FitMode), m_VerticalFit.enumNames[m_VerticalFit.enumValueIndex]);
            if (fitMode == FitMode.MinSize)
            {
                LayoutElementField(m_MaxHeight, t => LayoutUtility.GetMinHeight(t));
            }
            else if (fitMode == FitMode.PreferredSize)
            {
                LayoutElementField(m_MaxHeight, t => LayoutUtility.GetPreferredHeight(t));
            }
        }
        EditorGUILayout.PropertyField(m_LayoutPriority);
        serializedObject.ApplyModifiedProperties();
    }

    private void LayoutElementField(SerializedProperty property, float defaultValue)
    {
        LayoutElementField(property, (RectTransform _) => defaultValue);
    }

    private void LayoutElementField(SerializedProperty property, Func<RectTransform, float> defaultValue)
    {
        Rect controlRect = EditorGUILayout.GetControlRect();
        GUIContent label = EditorGUI.BeginProperty(controlRect, null, property);
        Rect val = EditorGUI.PrefixLabel(controlRect, label);
        Rect position = val;
        position.width = 16f;
        Rect position2 = val;
        position2.xMin = (position2.xMin + 16f);
        EditorGUI.BeginChangeCheck();
        bool flag = EditorGUI.ToggleLeft(position, GUIContent.none, property.floatValue >= 0f);
        if (EditorGUI.EndChangeCheck())
        {
            property.floatValue = ((!flag) ? -1f : defaultValue((base.target as RectTransform)));
        }
        if (!property.hasMultipleDifferentValues && property.floatValue >= 0f)
        {
            EditorGUIUtility.labelWidth = 4f;
            EditorGUI.BeginChangeCheck();
            float num = EditorGUI.FloatField(position2, new GUIContent(" "), property.floatValue);
            if (EditorGUI.EndChangeCheck())
            {
                property.floatValue = Mathf.Max(0f, num);
            }
            EditorGUIUtility.labelWidth = 0f;
        }
        EditorGUI.EndProperty();
    }
}
