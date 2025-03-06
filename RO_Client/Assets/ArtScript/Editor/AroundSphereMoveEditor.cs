using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(AroundSphereMove))]
public class AroundSphereMoveEditor : Editor
{
    private SerializedProperty m_ShakeDir;
    private SerializedProperty m_ShakeSpeed;
    private SerializedProperty m_MoveRadius;
    private SerializedProperty m_MoveAngleSpeed;
    private SerializedProperty m_SelfRotateSpeed;
    private SerializedProperty m_OffsetAngle;
    private SerializedProperty m_SelfScale;
    private SerializedProperty m_SelfHeight;

    private FieldInfo m_NeedResetFieldInfo;

    void OnEnable()
    {
        m_ShakeDir = serializedObject.FindProperty("m_ShakeDir");
        m_ShakeSpeed = serializedObject.FindProperty("m_ShakeSpeed");
        m_MoveRadius = serializedObject.FindProperty("m_MoveRadius");
        m_MoveAngleSpeed = serializedObject.FindProperty("m_MoveAngleSpeed");
        m_SelfRotateSpeed = serializedObject.FindProperty("m_SelfRotateSpeed");
        m_OffsetAngle = serializedObject.FindProperty("m_OffsetAngle");
        m_SelfScale = serializedObject.FindProperty("m_SelfScale");
        m_SelfHeight = serializedObject.FindProperty("m_SelfHeight");

        m_NeedResetFieldInfo = typeof(AroundSphereMove).GetField("m_NeedReset", BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Static);
    }

    public override void OnInspectorGUI()
    {
        serializedObject.Update();

        bool changed = false;

        EditorGUILayout.PropertyField(m_ShakeDir, EditorGUIUtility.TrTextContent("抖动方向"));
        EditorGUILayout.PropertyField(m_ShakeSpeed, EditorGUIUtility.TrTextContent("抖动速度"));
        EditorGUI.BeginChangeCheck();
        EditorGUILayout.PropertyField(m_MoveRadius, EditorGUIUtility.TrTextContent("绕圈半径"));
        changed = EditorGUI.EndChangeCheck() || changed;
        EditorGUILayout.PropertyField(m_MoveAngleSpeed, EditorGUIUtility.TrTextContent("绕圈速度"));
        EditorGUI.BeginChangeCheck();
        EditorGUILayout.PropertyField(m_SelfRotateSpeed, EditorGUIUtility.TrTextContent("自转速度"));
        changed = EditorGUI.EndChangeCheck() || changed;
        EditorGUI.BeginChangeCheck();
        m_OffsetAngle.quaternionValue = Quaternion.Euler(EditorGUILayout.Vector3Field(EditorGUIUtility.TrTextContent("初始角度"), m_OffsetAngle.quaternionValue.eulerAngles));
        changed = EditorGUI.EndChangeCheck() || changed;
        EditorGUI.BeginChangeCheck();
        EditorGUILayout.PropertyField(m_SelfScale, EditorGUIUtility.TrTextContent("自身缩放"));
        changed = EditorGUI.EndChangeCheck() || changed;
        EditorGUILayout.PropertyField(m_SelfHeight, EditorGUIUtility.TrTextContent("初始偏移高度"));

        serializedObject.ApplyModifiedProperties();

        if (changed)
        {
            foreach(var item in targets)
            {
                m_NeedResetFieldInfo.SetValue(item, true);
            }
        }
    }
}
