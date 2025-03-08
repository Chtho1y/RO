using System;
using System.Reflection;
using UnityEngine;
using UnityEditor;
using Edge = UnityEngine.RectTransform.Edge;

[CustomEditor(typeof(UIUnsafeArea))]
[DisallowMultipleComponent]
public class UIUnsafeAreaInspector : Editor
{
    private MethodInfo m_CalcAdaptMethodInfo = null;
    private MethodInfo m_GetSizeOfMainGameViewMethodInfo = null;


    private SerializedProperty m_UnsafeEdge;
    private SerializedProperty m_SafeSide1;
    private SerializedProperty m_SafeSide2;

    private SerializedObject m_RectTransform;
    private SerializedProperty m_RectTransform_AnchorMin;
    private SerializedProperty m_RectTransform_AnchorMax;
    private SerializedProperty m_RectTransform_Pivot;
    private SerializedProperty m_RectTransform_SizeDelta;
    private SerializedProperty m_RectTransform_AnchoredPosition;

    private void OnEnable()
    {
        Type gameViewType = typeof(Editor).Assembly.GetType("UnityEditor.GameView");
        m_GetSizeOfMainGameViewMethodInfo = gameViewType.GetMethod("GetSizeOfMainGameView", BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Static);
        m_CalcAdaptMethodInfo = typeof(UIControlArea).GetMethod("CalcAdapt", BindingFlags.Instance | BindingFlags.NonPublic, null, new Type[] { typeof(Rect), typeof(ScreenOrientation), typeof(int), typeof(int) }, null);
    
        m_UnsafeEdge = serializedObject.FindProperty("m_UnsafeEdge");
        m_SafeSide1 = serializedObject.FindProperty("m_SafeSide1");
        m_SafeSide2 = serializedObject.FindProperty("m_SafeSide2");

        m_RectTransform = new SerializedObject((target as UIUnsafeArea).transform as RectTransform);
        m_RectTransform_AnchorMin = m_RectTransform.FindProperty("m_AnchorMin");
        m_RectTransform_AnchorMax = m_RectTransform.FindProperty("m_AnchorMax");
        m_RectTransform_Pivot = m_RectTransform.FindProperty("m_Pivot");
        m_RectTransform_SizeDelta = m_RectTransform.FindProperty("m_SizeDelta");
        m_RectTransform_AnchoredPosition = m_RectTransform.FindProperty("m_AnchoredPosition");


        if (!Application.isPlaying)
        {
            Edge unsafeEdge = (Edge)Enum.Parse(typeof(Edge), m_UnsafeEdge.enumNames[m_UnsafeEdge.enumValueIndex]);
            ResetRectTransform(unsafeEdge);
        }
    }

    private void OnDisable() {
        if (m_RectTransform != null) m_RectTransform.Dispose();
        m_RectTransform = null;
    }

    public override void OnInspectorGUI()
    {
        EditorGUILayout.HelpBox("跟随UI的方向\n不受设备方向变化而变化", MessageType.Info);
        EditorGUILayout.Space();
        serializedObject.Update();
        int enumValueIndex = m_UnsafeEdge.enumValueIndex;
        EditorGUILayout.PropertyField(m_UnsafeEdge);
        Edge unsafeEdge = (Edge)Enum.Parse(typeof(Edge), m_UnsafeEdge.enumNames[m_UnsafeEdge.enumValueIndex]);
        
        if (unsafeEdge == Edge.Bottom)
        {
            EditorGUILayout.PropertyField(m_SafeSide2, EditorGUIUtility.TrTempContent("Left Safe"));
            EditorGUILayout.PropertyField(m_SafeSide1, EditorGUIUtility.TrTempContent("Right Safe"));
        }
        else if (unsafeEdge == Edge.Left)
        {
            EditorGUILayout.PropertyField(m_SafeSide2, EditorGUIUtility.TrTempContent("Top Safe"));
            EditorGUILayout.PropertyField(m_SafeSide1, EditorGUIUtility.TrTempContent("Bottom Safe"));
        }
        else if (unsafeEdge == Edge.Right)
        {
            EditorGUILayout.PropertyField(m_SafeSide1, EditorGUIUtility.TrTempContent("Top Safe"));
            EditorGUILayout.PropertyField(m_SafeSide2, EditorGUIUtility.TrTempContent("Bottom Safe"));
        }
        else
        {
            EditorGUILayout.PropertyField(m_SafeSide1, EditorGUIUtility.TrTempContent("Left Safe"));
            EditorGUILayout.PropertyField(m_SafeSide2, EditorGUIUtility.TrTempContent("Right Safe"));
        }

        if (enumValueIndex != m_UnsafeEdge.enumValueIndex)
        {
            ResetRectTransform(unsafeEdge);
        }

        if (serializedObject.ApplyModifiedProperties())
        {
            if (Application.isPlaying && SafeRectCheck.Instance && m_GetSizeOfMainGameViewMethodInfo != null)
            {
                Rect rect = SafeRectCheck.Instance.safeArea;
                ScreenOrientation orientation = SafeRectCheck.Instance.orientation;
                Vector2 screenSize = (Vector2)m_GetSizeOfMainGameViewMethodInfo.Invoke(null, null);
                m_CalcAdaptMethodInfo.Invoke(target as UIUnsafeArea, new object[] { rect, orientation, SafeRectCheck.Instance.screenWidth, SafeRectCheck.Instance.screenHeight});
            }
        }
    }


    private void  ResetRectTransform(Edge unsafeEdge)
    {
        m_RectTransform.Update();
        bool isChanged = false;

        Vector2 anchorMin, anchorMax, pivot;
        if (unsafeEdge == Edge.Bottom)
        {
            anchorMin = Vector2.zero;
            anchorMax = Vector2.right;
            pivot = new Vector2(0.5f, 1f);
        }
        else if (unsafeEdge == Edge.Left)
        {
            anchorMin = Vector2.zero;
            anchorMax = Vector2.up;
            pivot = new Vector2(1f, 0.5f);
        }
        else if (unsafeEdge == Edge.Right)
        {
            anchorMin = Vector2.right;
            anchorMax = Vector2.one;
            pivot = new Vector2(0f, 0.5f);
        }
        else
        {
            anchorMin = Vector2.up;
            anchorMax = Vector2.one;
            pivot = new Vector2(0.5f, 0f);
        }

        if (m_RectTransform_AnchorMin.vector2Value != anchorMin)
        {
            m_RectTransform_AnchorMin.vector2Value = anchorMin;
            isChanged = true;
        }
        if (m_RectTransform_AnchorMax.vector2Value != anchorMax)
        {
            m_RectTransform_AnchorMax.vector2Value = anchorMax;
            isChanged = true;
        }
        if (m_RectTransform_Pivot.vector2Value != pivot)
        {
            m_RectTransform_Pivot.vector2Value = pivot;
            isChanged = true;
        }
        if (m_RectTransform_SizeDelta.vector2Value != Vector2.zero)
        {
            m_RectTransform_SizeDelta.vector2Value = Vector2.zero;
            isChanged = true;
        }
        if (m_RectTransform_AnchoredPosition.vector2Value != Vector2.zero)
        {
            m_RectTransform_AnchoredPosition.vector2Value = Vector2.zero;
            isChanged = true;
        }

        if (isChanged)
        {
            m_RectTransform.ApplyModifiedProperties();
            EditorUtility.SetDirty(m_RectTransform.targetObject);
        }
    }
}
