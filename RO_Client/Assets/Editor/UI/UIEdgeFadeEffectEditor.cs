using System;
using System.Reflection;
using UnityEngine;
using UnityEditor;
using EdgeType = UIEdgeFadeEffect.EdgeType;

[CustomEditor(typeof(UIEdgeFadeEffect), true)]
[CanEditMultipleObjects]
public class UIRawImageEdgeFadeEditor : Editor
{
    SerializedProperty m_EdgeType;
    SerializedProperty m_EdgeValue;

    GUIContent m_EdgeTypeContent;

    MethodInfo methodInfo;

    protected virtual void OnEnable()
    {
        m_EdgeType           = serializedObject.FindProperty("m_EdgeType");
        m_EdgeValue          = serializedObject.FindProperty("m_EdgeValue");

        m_EdgeTypeContent     = EditorGUIUtility.TrTextContent("Edge Type");

        methodInfo = typeof(UIEdgeFadeEffect).GetMethod("SetDirty", BindingFlags.NonPublic | BindingFlags.Instance);
    }

    public override void OnInspectorGUI()
    {
        serializedObject.Update();

        EditorGUI.BeginChangeCheck();
        int tempValueIndex = EditorGUILayout.Popup(m_EdgeTypeContent, (m_EdgeType.hasMultipleDifferentValues ? -1 : m_EdgeType.enumValueIndex), m_EdgeType.enumDisplayNames);
        if (EditorGUI.EndChangeCheck())
        {
            if (tempValueIndex != m_EdgeType.enumValueIndex)
            {
                m_EdgeType.enumValueIndex = tempValueIndex;
            }
        }

        EditorGUI.BeginChangeCheck();
        var edgeType = (EdgeType)Enum.GetValues (typeof (EdgeType)).GetValue (m_EdgeType.enumValueIndex);
        float tempEdgeValue = m_EdgeValue.floatValue;
        if (edgeType == EdgeType.UV)
        {
            tempEdgeValue = EditorGUILayout.Slider("Edge Value", Mathf.Clamp01(tempEdgeValue), 0, 1);
        }
        else
        {
            tempEdgeValue = EditorGUILayout.FloatField("Edge Value", m_EdgeValue.floatValue);
        }
        if (EditorGUI.EndChangeCheck())
        {
            if (tempEdgeValue != m_EdgeValue.floatValue)
            {
                m_EdgeValue.floatValue = tempEdgeValue;
            }
        }
        
        if (serializedObject.ApplyModifiedProperties())
        {
            if (methodInfo != null)
            {
                foreach  (UIEdgeFadeEffect item in targets)
                {
                    if (item)
                    {
                        methodInfo.Invoke(item, null);
                    }
                }
            }
        }
    }
}
