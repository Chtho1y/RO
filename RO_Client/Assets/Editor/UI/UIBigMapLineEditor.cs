using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Text;
using UnityEngine;
using UnityEditor;
using UnityEditorInternal;
using UnityEditor.UI;

[CustomEditor(typeof(UIBigMapLine))]
public class UIBigMapLineEditor : GraphicEditor
{
    protected SerializedProperty m_PassColor;
    protected SerializedProperty m_LineWidth;
    protected SerializedProperty m_LineSmooth;
    protected SerializedProperty m_Sprite;

    protected UIBigMapLine m_Line;
    // 为了不对外开放内部数据，则使用反射调用
    protected FieldInfo m_PassPointIdxFieldInfo = null;
    protected FieldInfo m_PointsFieldInfo = null;
    protected List<Vector2> m_Points;
    protected ReorderableList m_PointList;
    
    protected static int s_DropAreaHash = "UIBigMapLineDropArea".GetHashCode();

    protected override void OnEnable()
    {
        base.OnEnable();
        m_LineWidth = serializedObject.FindProperty("m_LineWidth");
        m_LineSmooth = serializedObject.FindProperty("m_LineSmooth");
        m_Sprite = serializedObject.FindProperty("m_Sprite");
        m_Line = target as UIBigMapLine;
        m_PassPointIdxFieldInfo = typeof(UIBigMapLine).GetField("m_PassPointIdx", BindingFlags.Instance | BindingFlags.NonPublic);
        m_PointsFieldInfo = typeof(UIBigMapLine).GetField("m_Points", BindingFlags.Instance | BindingFlags.NonPublic);
        m_Points = ((List<Vector2>)m_PointsFieldInfo.GetValue(m_Line));
        m_PointList = new ReorderableList(m_Points, typeof(Vector2), true, false, true, true);
        m_PointList.drawElementCallback = DrawElementCallback;
        m_PointList.onChangedCallback = OnChangedCallback;
    }

    public override void OnInspectorGUI()
    {
        serializedObject.Update();
        EditorGUI.BeginDisabledGroup(true);
        EditorGUILayout.PropertyField(m_Script);
        EditorGUI.EndDisabledGroup();
        EditorGUILayout.Space();
        EditorGUILayout.PropertyField(m_LineWidth, EditorGUIUtility.TrTextContent("线宽"));
        EditorGUILayout.PropertyField(m_LineSmooth, EditorGUIUtility.TrTextContent("线平滑度"));
        EditorGUILayout.PropertyField(m_Sprite, EditorGUIUtility.TrTextContent("Sprite"));
        if (m_LineWidth.floatValue < 0)
        {
            m_LineWidth.floatValue = 0.001f;
        }
        if (m_LineSmooth.intValue < 1)
        {
            m_LineSmooth.intValue = 1;
        }
        m_Line.passPointIdx = EditorGUILayout.IntSlider("通过到点", (int)m_PassPointIdxFieldInfo.GetValue(m_Line), 0, (m_Points != null ? m_Points.Count - 1 : 0));
        m_PointList.DoLayoutList();

        EditorGUILayout.Space();
        if (GUILayout.Button("All Points To Log"))
        {
            StringBuilder builder = new StringBuilder();
            for (int i = 0; i < m_Points.Count; i++)
            {
                builder.Append(m_Points[i].x);
                builder.Append(";");
                builder.Append(m_Points[i].y);
                builder.Append("\n");
            }
            builder.Append("\n");
            builder.Append("\n");
            Debug.LogError(builder.ToString());
        }
        EditorGUILayout.Space();

        if (serializedObject.ApplyModifiedProperties())
        {
            m_Line.SetAllDirty();
        }
    }

    public void DrawElementCallback(Rect rect, int index, bool isActive, bool isFocused)
    {
        Rect labelRect = new Rect(rect.x, rect.y, 50, rect.height);
        int id = GUIUtility.GetControlID(s_DropAreaHash, FocusType.Passive, labelRect);
        labelRect = EditorGUI.PrefixLabel(labelRect, id, GUIContent.none);
        Event evt = Event.current;
        if (evt.type == EventType.Repaint)
        {
            EditorStyles.label.Draw(labelRect, EditorGUIUtility.TrTextContent(index.ToString()), id);
        }
        if (evt.type == EventType.DragUpdated)
        {
            if (rect.Contains(evt.mousePosition))
            {
                DragAndDrop.visualMode = DragAndDropVisualMode.Copy;
            }
        }
        if (evt.type == EventType.DragPerform)
        {
            if (rect.Contains(evt.mousePosition))
            {
                DragAndDrop.AcceptDrag();
                if (DragAndDrop.objectReferences != null && DragAndDrop.objectReferences.Length > 0)
                {
                    GameObject go = DragAndDrop.objectReferences[0] as GameObject;
                    if (go && go.activeInHierarchy)
                    {
                        m_Points[index] = m_Line.transform.InverseTransformPoint(go.transform.position);
                    }
                }
            }
        }


        EditorGUI.LabelField(new Rect(rect.x, rect.y, 50, rect.height), index.ToString());
        Vector2 newPoint = EditorGUI.Vector2Field(new Rect(rect.x + 50, rect.y, rect.width - 100, rect.height), string.Empty, m_Points[index]);
        if (m_Points[index] != newPoint)
        {
            m_Points[index] = newPoint;
            m_Line.SetAllDirty();
        }
        if (GUI.Button(new Rect(rect.x + rect.width - 50, rect.y, 50, rect.height), "Copy"))
        {
            GUIUtility.systemCopyBuffer = m_Points[index].x + ";" + m_Points[index].y;
        }
    }

    public void OnChangedCallback(ReorderableList list)
    {
        m_Line.SetAllDirty();
    }
}
