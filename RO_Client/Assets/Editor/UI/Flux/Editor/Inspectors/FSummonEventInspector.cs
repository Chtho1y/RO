using UnityEngine;
using UnityEditor;
using Flux;

namespace FluxEditor
{
    [CustomEditor(typeof(FSummonEvent))]
    public class FSummonEventInspector : FEventInspector
    {
        private FSummonEvent _summonEvent = null;

        private SerializedProperty _npcId = null;
        private SerializedProperty _npcPos = null;

        string[] posStrs = new string[] { "0", "1", "2", "3", "4", "5", "6" };

        protected override void OnEnable()
        {
            base.OnEnable();

            _summonEvent = (FSummonEvent)target;

            _npcId = serializedObject.FindProperty("_npcId");
            _npcPos = serializedObject.FindProperty("_npcPos");
        }

        public override void OnInspectorGUI()
        {
            base.OnInspectorGUI();

            serializedObject.Update();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("召唤的怪物ID:", EditorStyles.label, GUILayout.Width(140));
            _npcId.intValue = EditorGUILayout.IntField(_npcId.intValue, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("怪物的站位:", EditorStyles.label, GUILayout.Width(140));
            _npcPos.intValue = EditorGUILayout.Popup(_npcPos.intValue, posStrs, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            serializedObject.ApplyModifiedProperties();
        }
    }
}