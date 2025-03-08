using System;
using System.Reflection;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(UISafeArea))]
public class UISafeAreaInspector : Editor
{
    private MethodInfo m_CalcAdaptMethodInfo = null;
    private MethodInfo m_GetSizeOfMainGameViewMethodInfo = null;

    private void OnEnable()
    {
        Type gameViewType = typeof(Editor).Assembly.GetType("UnityEditor.GameView");
        m_GetSizeOfMainGameViewMethodInfo = gameViewType.GetMethod("GetSizeOfMainGameView", BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Static);
        m_CalcAdaptMethodInfo = typeof(UIControlArea).GetMethod("CalcAdapt", BindingFlags.Instance | BindingFlags.NonPublic, null, new Type[] { typeof(Rect), typeof(ScreenOrientation), typeof(int), typeof(int) }, null);
    }

    public override void OnInspectorGUI()
    {
        EditorGUILayout.HelpBox("会自动根据设备方向变化", MessageType.Info);
        EditorGUILayout.Space();
        serializedObject.Update();
        Editor.DrawPropertiesExcluding(serializedObject, "m_Script");
        if (serializedObject.ApplyModifiedProperties())
        {
            if (Application.isPlaying && SafeRectCheck.Instance && m_GetSizeOfMainGameViewMethodInfo != null)
            {
                Rect rect = SafeRectCheck.Instance.safeArea;
                ScreenOrientation orientation = SafeRectCheck.Instance.orientation;
                Vector2 screenSize = (Vector2)m_GetSizeOfMainGameViewMethodInfo.Invoke(null, null);
                m_CalcAdaptMethodInfo.Invoke(target as UISafeArea, new object[] { rect, orientation, SafeRectCheck.Instance.screenWidth, SafeRectCheck.Instance.screenHeight});
            }
        }
    }
}
