using UnityEngine;
using UnityEditor;
using System.Collections;
[CustomEditor(typeof(Canvas3D))]
public class Canvas3DEditor : Editor
{
    public override void OnInspectorGUI()
    {
        serializedObject.Update();
        Canvas3D canvas = (Canvas3D)target;
        EditorGUILayout.BeginVertical();

        if (GUILayout.Button("Refresh Layout"))
        {
            Canvas3DImpl.GetInstance().RefreshLayout(canvas.transform);
            Canvas3DImpl.GetInstance().RebuildAtlasImmediately();
        }

        EditorGUILayout.EndVertical();
    }
}
