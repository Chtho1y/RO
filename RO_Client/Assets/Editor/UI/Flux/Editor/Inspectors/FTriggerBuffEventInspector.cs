using UnityEngine;
using UnityEditor;
using Flux;

namespace FluxEditor
{
    [CustomEditor(typeof(FTriggerBuffEvent))]
    public class FTriggerBuffEventInspector : FEventInspector
    {
        private FTriggerBuffEvent _buffEvent = null;

        private SerializedProperty _buffId = null;
        private SerializedProperty _rate = null;

        protected override void OnEnable()
        {
            base.OnEnable();

            _buffEvent = (FTriggerBuffEvent)target;

            _buffId = serializedObject.FindProperty("_buffId");
            _rate = serializedObject.FindProperty("_rate");
        }

        public override void OnInspectorGUI()
        {
            base.OnInspectorGUI();

            serializedObject.Update();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("触发buffid:", EditorStyles.label, GUILayout.Width(140));
            _buffId.intValue = EditorGUILayout.IntField(_buffId.intValue, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("触发buff概率:", EditorStyles.label, GUILayout.Width(140));
            _rate.intValue = EditorGUILayout.IntField(_rate.intValue, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            serializedObject.ApplyModifiedProperties();
        }
    }
}