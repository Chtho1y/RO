using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(CameraViewDistance))]
public class CameraViewDistanceEditor : Editor
{
    private SerializedProperty m_LayerCullSphericalSp;
    private SerializedProperty m_LayerCullDistancesSp;
    private Camera m_Camera;

    private void OnEnable() {
        m_LayerCullSphericalSp = serializedObject.FindProperty("m_LayerCullSpherical");
        m_LayerCullDistancesSp = serializedObject.FindProperty("m_LayerCullDistances");
        m_Camera = ((CameraViewDistance)target).GetComponent<Camera>();
    }

    public override void OnInspectorGUI()
    {
        serializedObject.Update();
        bool defaultEnabled = GUI.enabled;
        GUI.enabled = false;
        Editor.DrawPropertiesExcluding(serializedObject, "m_LayerCullSpherical", "m_LayerCullDistances" );
        GUI.enabled = defaultEnabled;
        EditorGUILayout.PropertyField(m_LayerCullSphericalSp, EditorGUIUtility.TrTextContent("视锥平面是否球形"));
        
        if (m_Camera)
        {
            int cullingMask = m_Camera.cullingMask;
            if (cullingMask != 0)
            {
                EditorGUILayout.LabelField("设置layer的最大显示距离", EditorStyles.boldLabel);
                EditorGUILayout.BeginVertical(EditorStyles.textArea);
                for (int i = 0; i < 32; i++)
                {
                    SerializedProperty elementSp = m_LayerCullDistancesSp.GetArrayElementAtIndex(i);
                    int mask = (1 << i);
                    if ((cullingMask & mask) == mask)
                    {
                        if (elementSp.floatValue <= 0) elementSp.floatValue = m_Camera.farClipPlane;
                        elementSp.floatValue = EditorGUILayout.Slider(LayerMask.LayerToName(i), elementSp.floatValue, m_Camera.nearClipPlane, m_Camera.farClipPlane);
                    }
                    else
                    {
                        elementSp.floatValue = 0f;
                    }
                }
                EditorGUILayout.EndVertical();
            }
        }
        
        if (serializedObject.ApplyModifiedProperties())
        {
            ((CameraViewDistance)target).Refresh();
        }
    }
}
