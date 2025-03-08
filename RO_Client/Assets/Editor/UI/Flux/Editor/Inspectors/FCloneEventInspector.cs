using UnityEngine;
using UnityEditor;
using Flux;

namespace FluxEditor
{
    [CustomEditor(typeof(FCloneEvent))]
    public class FCloneEventInspector : FEventInspector
    {
        private FCloneEvent _cloneEvent = null;

        private SerializedProperty _npcId = null;
        private SerializedProperty _npcPos = null;
        private SerializedProperty _bornEffectId = null;
        private SerializedProperty _bornEffectPrefab = null;
        private SerializedProperty _bornPos = null;
        private SerializedProperty _bornRot = null;

        string[] posStrs = new string[] { "0", "1", "2", "3", "4", "5", "6" };

        protected override void OnEnable()
        {
            base.OnEnable();

            _cloneEvent = (FCloneEvent)target;

            _npcId = serializedObject.FindProperty("_npcId");
            _npcPos = serializedObject.FindProperty("_npcPos");
            _bornEffectId = serializedObject.FindProperty("_bornEffectId");
            _bornEffectPrefab = serializedObject.FindProperty("_bornEffectPrefab");
            _bornPos = serializedObject.FindProperty("_bornPos");
            _bornRot = serializedObject.FindProperty("_bornRot");
        }

        public override void OnInspectorGUI()
        {
            base.OnInspectorGUI();
            serializedObject.Update();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("NPC ID:", EditorStyles.label, GUILayout.Width(140));
            _npcId.intValue = EditorGUILayout.IntField(_npcId.intValue, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("怪物的站位:", EditorStyles.label, GUILayout.Width(140));
            _npcPos.intValue = EditorGUILayout.Popup(_npcPos.intValue, posStrs, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("出生特效ID:", EditorStyles.label, GUILayout.Width(140));
            _bornEffectId.intValue = EditorGUILayout.IntField(_bornEffectId.intValue, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("出生特效:", EditorStyles.label, GUILayout.Width(140));
            _bornEffectPrefab.objectReferenceValue = EditorGUILayout.ObjectField(_bornEffectPrefab.objectReferenceValue, typeof(GameObject), false, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("出生位置:", EditorStyles.label, GUILayout.Width(140));
            _bornPos.vector3Value = EditorGUILayout.Vector3Field("",_bornPos.vector3Value, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("出生时旋转值:", EditorStyles.label, GUILayout.Width(140));
            _bornRot.vector3Value = EditorGUILayout.Vector3Field("", _bornRot.vector3Value, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            serializedObject.ApplyModifiedProperties();
        }
    }
}