using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEditorInternal;
using UnityEngine;

[CustomEditor(typeof(UIPolygonRaycastFilter))]
public class UIPolygonRaycastFilterEditor : Editor
{
    private static class Styles
    {
        public static readonly GUIContent editModeButton = EditorGUIUtility.TrIconContent("EditCollider");
        public static readonly GUIContent editModeLabel = EditorGUIUtility.TrTextContent("Edit Polygon");
    }

    private SerializedProperty m_Points;

    SplineSceneEditor m_SplineSceneEditor;

    public bool editing
    {
        get { return EditMode.editMode == EditMode.SceneViewEditMode.Collider && EditMode.IsOwner(this); }
    }

    private void OnEnable() {
        m_Points = serializedObject.FindProperty("m_Points");

        m_SplineSceneEditor = new SplineSceneEditor(m_Points, this, target);
        EditMode.onEditModeStartDelegate += OnEditModeStart;
        EditMode.onEditModeEndDelegate += OnEditModeEnd;
    }

    private void OnDestroy() {
        if (m_SplineSceneEditor != null)
            m_SplineSceneEditor.OnDisable();
        OnEditModeEnd(this);
        EditMode.onEditModeStartDelegate -= OnEditModeStart;
        EditMode.onEditModeEndDelegate -= OnEditModeEnd;
    }

    protected void OnEditModeStart(Editor owner, EditMode.SceneViewEditMode mode)
    {
        if (mode != EditMode.SceneViewEditMode.Collider || owner != this) return;
        OnEditStart();
    }

    protected void OnEditModeEnd(Editor owner)
    {
        if (owner != this) return;
        ShapeEditorCache.InvalidateCache();
        OnEditEnd();
    }

    public override void OnInspectorGUI()
    {
        m_SplineSceneEditor.OnInspectorGUI();
        serializedObject.Update();
        EditorGUILayout.PropertyField(m_Points, true);
        serializedObject.ApplyModifiedProperties();
    }

    public void OnSceneGUI()
    {
        if (!EditMode.IsOwner(this))
            return;

        EditorGUI.BeginChangeCheck();

        m_SplineSceneEditor.OnSceneGUI();

        if (EditorGUI.EndChangeCheck())
        {
            EditorUtility.SetDirty(target);
        }
    }

    protected virtual void OnEditStart()
    {
        if (target == null)
            return;
        
    }
    
    protected virtual void OnEditEnd()
    {

    }


    [DrawGizmo(GizmoType.InSelectionHierarchy)]
    static void RenderPolygon(UIPolygonRaycastFilter filter, GizmoType gizmoType)
    {
        if (filter.points == null || filter.points.Length <= 0) return;
        Matrix4x4 oldMatrix = Handles.matrix;
        Color oldColor = Handles.color;
        Handles.matrix = filter.transform.localToWorldMatrix;
        Handles.color = Color.gray;
        for (int i = 0, iMax = filter.points.Length; i < iMax; i++)
        {
            Vector3 p1 = filter.points[i];
            Vector3 p2 = filter.points[(i + 1) % iMax];
            Handles.DrawLine(p1, p2);
        }
        Handles.matrix = oldMatrix;
        Handles.color = oldColor;
    }
}
