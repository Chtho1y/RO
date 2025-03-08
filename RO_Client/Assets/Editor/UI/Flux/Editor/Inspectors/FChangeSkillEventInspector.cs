using UnityEngine;
using UnityEditor;
using Flux;

namespace FluxEditor
{
    [CustomEditor(typeof(FChangeSkillEvent))]
    public class FChangeSkillEventInspector : FEventInspector
    {
        private FChangeSkillEvent _changeSkillEvent = null;

        private SerializedProperty _fromSkillId = null;
        private SerializedProperty _toSkillId = null;

        protected override void OnEnable()
        {
            base.OnEnable();

            _changeSkillEvent = (FChangeSkillEvent)target;

            _fromSkillId = serializedObject.FindProperty("_fromSkillId");
            _toSkillId = serializedObject.FindProperty("_toSkillId");
        }

        public override void OnInspectorGUI()
        {
            base.OnInspectorGUI();

            serializedObject.Update();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("原技能ID:", EditorStyles.label, GUILayout.Width(140));
            _fromSkillId.stringValue = EditorGUILayout.TextField(_fromSkillId.stringValue, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("替换的新技能ID:", EditorStyles.label, GUILayout.Width(140));
            _toSkillId.stringValue = EditorGUILayout.TextField(_toSkillId.stringValue, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            serializedObject.ApplyModifiedProperties();
        }
    }
}