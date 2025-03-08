using UnityEngine;
using UnityEditor;
using Flux;

namespace FluxEditor
{
    [CustomEditor(typeof(FCameraShakeEvent))]
    public class FCameraShakeEventInspector : FEventInspector
    {
        private FCameraShakeEvent _camShakeEvent = null;

        private SerializedProperty _leftRightValue = null;
        private SerializedProperty _upDownValue = null;
        private SerializedProperty _forwardbackward = null;
        private SerializedProperty _shakeTime = null;
        private SerializedProperty _cycle = null;

        protected override void OnEnable()
        {
            base.OnEnable();

            _camShakeEvent = (FCameraShakeEvent)target;

            _leftRightValue = serializedObject.FindProperty("_leftRightValue");
            _upDownValue = serializedObject.FindProperty("_upDownValue");
            _forwardbackward = serializedObject.FindProperty("_forwardbackward");
            _shakeTime = serializedObject.FindProperty("_shakeTime");
            _cycle = serializedObject.FindProperty("_cycle");
        }

        public override void OnInspectorGUI()
        {
            base.OnInspectorGUI();

            serializedObject.Update();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("左右震动强度:", EditorStyles.label, GUILayout.Width(140));
            _leftRightValue.floatValue = EditorGUILayout.FloatField(_leftRightValue.floatValue, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("上下震动强度:", EditorStyles.label, GUILayout.Width(140));
            _upDownValue.floatValue = EditorGUILayout.FloatField(_upDownValue.floatValue, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("前后震动强度:", EditorStyles.label, GUILayout.Width(140));
            _forwardbackward.floatValue = EditorGUILayout.FloatField(_forwardbackward.floatValue, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("震动时间:", EditorStyles.label, GUILayout.Width(140));
            _shakeTime.floatValue = EditorGUILayout.FloatField(_shakeTime.floatValue, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("震动次数:", EditorStyles.label, GUILayout.Width(140));
            _cycle.intValue = EditorGUILayout.IntField(_cycle.intValue, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();
            serializedObject.ApplyModifiedProperties();
        }
    }
}