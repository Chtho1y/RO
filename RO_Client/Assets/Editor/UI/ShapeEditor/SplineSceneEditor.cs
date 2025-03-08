using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEditorInternal;

public class SplineSceneEditor
{
    private static class Styles
    {
        public static readonly GUIContent editModeButton = EditorGUIUtility.TrIconContent("EditCollider");
        public static readonly GUIContent editModeLabel = EditorGUIUtility.TrTextContent("Edit Polygon");
    }

    int m_RectSelectionID = -1;

    Editor m_CurrentEditor;
    ShapeEditor m_ShapeEditor;
    RectSelectionTool m_RectSelectionTool = new RectSelectionTool();
    SerializedProperty m_Points;
    UnityEngine.Object m_UndoObject;
    Vector3 m_LastPosition;
    Quaternion m_LastRotation;
    Vector3 m_LastScale;
    int m_LastHashCode;
    Bounds m_Bounds;

    public SplineSceneEditor(SerializedProperty points, Editor editor, UnityEngine.Object undoObject)
    {
        m_Points = points;
        m_CurrentEditor = editor;
        m_UndoObject = undoObject;

        SetupSpriteShapeEditor();

        Undo.undoRedoPerformed += OnUndoRedo;
    }

    public void OnDisable()
    {
        Undo.undoRedoPerformed -= OnUndoRedo;
    }

    private void OnUndoRedo()
    {
        m_ShapeEditor.SetDirty();
        SceneView.RepaintAll();
    }

    public void OnInspectorGUI()
    {
        EditMode.DoEditModeInspectorModeButton(EditMode.SceneViewEditMode.Collider, "Edit Polygon", Styles.editModeButton, GetBounds, m_CurrentEditor);
    }

    public void OnSceneGUI()
    {
        TransformChangedCheck();

        EditorGUI.BeginChangeCheck();

        m_ShapeEditor.OnGUI();
        DoRectSelectionGUI();

        if (EditorGUI.EndChangeCheck())
        {
            m_ShapeEditor.SetDirty();
            m_CurrentEditor.Repaint();
        }

        SplineHashCheck();

        if (Event.current.type == EventType.MouseMove)
            HandleUtility.Repaint();
    }

    private void DoRectSelectionGUI()
    {
        ISelection selection = ShapeEditorCache.GetSelection();

        if (m_RectSelectionID == -1)
            m_RectSelectionID = GUIUtility.GetControlID("RectSelection".GetHashCode(), FocusType.Passive);

        if (Event.current.GetTypeForControl(m_RectSelectionID) == EventType.MouseDown && Event.current.button == 0)
        {
            if (!Event.current.shift && !EditorGUI.actionKey)
            {
                ShapeEditorCache.RecordUndo("Edit Selection");
                ShapeEditorCache.ClearSelection();
                GUI.changed = true;
            }
        }

        if (Event.current.GetTypeForControl(m_RectSelectionID) == EventType.MouseUp && Event.current.button == 0)
        {
            ShapeEditorCache.RecordUndo("Edit Selection");

            selection.EndSelection(true);
            m_ShapeEditor.HandleSinglePointSelection();

            GUI.changed = true;
        }

        EditorGUI.BeginChangeCheck();

        Rect selectionRect = m_RectSelectionTool.Do(m_RectSelectionID, (m_CurrentEditor.target as Component).transform.position);

        if (EditorGUI.EndChangeCheck())
        {
            selection.BeginSelection();

            for (int i = 0; i < m_Points.arraySize; ++i)
            {
                if (selectionRect.Contains(HandleUtility.WorldToGUIPoint(LocalToWorld(m_Points.GetArrayElementAtIndex(i).vector2Value)), true))
                    selection.Select(i, true);
            }
        }
    }

    private void SplineHashCheck()
    {
        int hashCode = m_Points.GetHashCode();

        if (m_LastHashCode != hashCode)
            m_ShapeEditor.SetDirty();

        m_LastHashCode = hashCode;
    }

    private void TransformChangedCheck()
    {
        Transform transform = GetTransform();
        if (m_LastPosition != transform.position || m_LastRotation != transform.rotation || m_LastScale != transform.lossyScale)
        {
            m_ShapeEditor.SetDirty();

            m_LastPosition = transform.position;
            m_LastRotation = transform.rotation;
            m_LastScale = transform.lossyScale;
        }
    }

    private Transform GetTransform()
    {
        return (m_CurrentEditor.target as Component).transform;
    }

    private Vector3 LocalToWorld(Vector3 position)
    {
        return GetTransform().TransformPoint(position);
    }

    private Vector3 WorldToLocal(Vector3 position)
    {
        Transform transform = GetTransform();
        RectTransform rectTransform = transform as RectTransform;
        Vector2 pos = transform.InverseTransformPoint(position);
        if (rectTransform)
        {
            if (!rectTransform.rect.Contains(pos))
            {
                if (pos.x < rectTransform.rect.min.x)
                {
                    pos.x = rectTransform.rect.min.x;
                }
                if (pos.x > rectTransform.rect.max.x)
                {
                    pos.x = rectTransform.rect.max.x;
                }
                if (pos.y < rectTransform.rect.min.y)
                {
                    pos.y = rectTransform.rect.min.y;
                }
                if (pos.y > rectTransform.rect.max.y)
                {
                    pos.y = rectTransform.rect.max.y;
                }
            }
        }
        return pos;
    }

    private  void SetupSpriteShapeEditor()
    {
        if (m_Points.arraySize <= 0)
        {
            Transform transform = GetTransform();
            RectTransform rectTransform = transform as RectTransform;
            m_Points.serializedObject.Update();
            m_Points.InsertArrayElementAtIndex(0);
            m_Points.InsertArrayElementAtIndex(1);
            m_Points.InsertArrayElementAtIndex(2);
            m_Points.InsertArrayElementAtIndex(3);
            if (rectTransform)
            {
                m_Points.GetArrayElementAtIndex(0).vector2Value = new Vector2(rectTransform.rect.xMin, rectTransform.rect.yMin);
                m_Points.GetArrayElementAtIndex(1).vector2Value = new Vector2(rectTransform.rect.xMin, rectTransform.rect.yMax);
                m_Points.GetArrayElementAtIndex(2).vector2Value = new Vector2(rectTransform.rect.xMax, rectTransform.rect.yMax);
                m_Points.GetArrayElementAtIndex(3).vector2Value = new Vector2(rectTransform.rect.xMax, rectTransform.rect.yMin);
            }
            else
            {
                m_Points.GetArrayElementAtIndex(0).vector2Value = new Vector2(-1, -1);
                m_Points.GetArrayElementAtIndex(1).vector2Value = new Vector2(-1, 1);
                m_Points.GetArrayElementAtIndex(2).vector2Value = new Vector2(1, 1);
                m_Points.GetArrayElementAtIndex(3).vector2Value = new Vector2(1, -1);
            }
            m_Points.serializedObject.ApplyModifiedProperties();
        }

        m_ShapeEditor = new ShapeEditor()
        {
            //Data
            GetPosition = i =>
            {
                m_Points.serializedObject.Update();
                return LocalToWorld(m_Points.GetArrayElementAtIndex(i).vector2Value);
            },
            SetPosition = (i, p) =>
            {
                m_Points.serializedObject.Update();
                m_Points.GetArrayElementAtIndex(i).vector2Value = WorldToLocal(p);
                m_Points.serializedObject.ApplyModifiedProperties();
            },
            GetLeftTangent = i => Vector3.left,
            SetLeftTangent = (i, p) => {},
            GetRightTangent = i => Vector3.left,
            SetRightTangent = (i, p) => {},
            GetTangentMode = i => ShapeEditor.TangentMode.Linear,
            SetTangentMode = (i, m) => {},
            InsertPointAt = (i, p) => 
            {
                m_Points.serializedObject.Update();
                m_Points.InsertArrayElementAtIndex(i);
                m_Points.GetArrayElementAtIndex(i).vector2Value = WorldToLocal(p);
                m_Points.serializedObject.ApplyModifiedProperties();
            },
            RemovePointAt = i =>
            {
                m_Points.serializedObject.Update();
                m_Points.DeleteArrayElementAtIndex(i);
                m_Points.serializedObject.ApplyModifiedProperties();
            },
            GetPointCount = () =>
            {
                m_Points.serializedObject.Update();
                return m_Points.arraySize;
            },
            // Transforms
            ScreenToWorld = (p) => ScreenToWorld(p),
            LocalToWorldMatrix = () => Matrix4x4.identity,
            WorldToScreen = (p) => HandleUtility.WorldToGUIPoint(p),
            GetForwardVector = () => GetTransform().forward,
            GetUpVector = () => GetTransform().up,
            GetRightVector = () => GetTransform().right,
            // Other
            Snap = (p) => SnapPoint(p),
            RecordUndo = RecordUndo,
            OpenEnded = () => false,
            Repaint = m_CurrentEditor.Repaint
        };
    }

    private Bounds GetBounds()
    {
        Transform transform = GetTransform();
        m_Bounds = RectTransformUtility.CalculateRelativeRectTransformBounds(transform);
        var min = transform.TransformPoint(m_Bounds.min);
        var max = transform.TransformPoint(m_Bounds.max);
        m_Bounds.SetMinMax(min, max);
        return m_Bounds;
    }

    private Vector3 ScreenToWorld(Vector2 screenPosition, Plane plane)
    {
        Ray ray = HandleUtility.GUIPointToWorldRay(screenPosition);

        float distance;
        plane.Raycast(ray, out distance);
        return ray.GetPoint(distance);
    }

    private Vector3 ScreenToWorld(Vector2 screenPosition)
    {
        Transform transform = GetTransform();
        return ScreenToWorld(screenPosition, new Plane(transform.forward, transform.position));
    }

    private Vector3 SnapPoint(Vector3 position)
    {
        Vector2 np0screen = m_ShapeEditor.WorldToScreen(position);
        Vector2 snappedScreen = m_ShapeEditor.WorldToScreen(SnappingUtility.Snap(position));

        float snapDistance = (np0screen - snappedScreen).magnitude;
        if (snapDistance < 15f)
        {
            position = SnappingUtility.Snap(position);
        }
        return position;
    }

    private void RecordUndo()
    {
        Undo.RegisterCompleteObjectUndo(m_UndoObject, "Edit Spline");
    }
}
