using UnityEngine;
using UnityEditor;
using Flux;

namespace FluxEditor
{
    [CustomEditor(typeof(FMoveEvent))]
    public class FMoveEventInspector : FEventInspector
    {
        private FMoveEvent _moveEvent = null;

        private SerializedProperty _moveType = null;
        private SerializedProperty _initSpeed = null;
        private SerializedProperty _acceleration = null;
        private SerializedProperty _moveDistance = null;
        private SerializedProperty _moveOrientation = null;


        int[] moveTypes = new int[] { 0, 1, 2, 3, 4, 5, 6 };
        string[] moveTypeStrs = new string[] { "无", "击退", "冲刺到位置", "冲刺到目标", "跳起", "击飞", "掉落" };

        protected override void OnEnable()
        {
            base.OnEnable();

            _moveEvent = (FMoveEvent)target;
            _moveType = serializedObject.FindProperty("_moveType");
            _initSpeed = serializedObject.FindProperty("_initSpeed");
            _acceleration = serializedObject.FindProperty("_acceleration");
            _moveDistance = serializedObject.FindProperty("_moveDistance");
            _moveOrientation = serializedObject.FindProperty("_moveOrientation");
        }

        public override void OnInspectorGUI()
        {
            base.OnInspectorGUI();

            serializedObject.Update();
            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("移动类型:", EditorStyles.label, GUILayout.Width(140));
            _moveType.intValue = EditorGUILayout.IntPopup(_moveType.intValue,moveTypeStrs,moveTypes);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("初始速度:", EditorStyles.label, GUILayout.Width(140));
            _initSpeed.floatValue = EditorGUILayout.FloatField(_initSpeed.floatValue);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("加速度:", EditorStyles.label, GUILayout.Width(140));
            _acceleration.floatValue = EditorGUILayout.FloatField(_acceleration.floatValue);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("移动距离:", EditorStyles.label, GUILayout.Width(140));
            _moveDistance.floatValue = EditorGUILayout.FloatField(_moveDistance.floatValue);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("移动方向:", EditorStyles.label, GUILayout.Width(140));
            _moveOrientation.intValue = EditorGUILayout.IntField(_moveOrientation.intValue);
            EditorGUILayout.EndHorizontal();

            serializedObject.ApplyModifiedProperties();
        }
    }
}