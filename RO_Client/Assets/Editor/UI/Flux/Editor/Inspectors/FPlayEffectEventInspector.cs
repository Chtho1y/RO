using UnityEngine;
using UnityEditor;
using Flux;


namespace FluxEditor
{
    [CustomEditor(typeof(FPlayEffectEvent))]
    public class FPlayEffectEventInspector : FEventInspector
    {
        private FPlayEffectEvent _effectEvent = null;

        private SerializedProperty _effectId = null;
        private SerializedProperty _effectPrefab = null;
        private SerializedProperty _effectLink = null;

        private int effectLinkIdx = -1;

        protected override void OnEnable()
        {
            base.OnEnable();

            _effectEvent = (FPlayEffectEvent)target;

            _effectId = serializedObject.FindProperty("_effectId");
            _effectPrefab = serializedObject.FindProperty("_effectPrefab");
            _effectLink = serializedObject.FindProperty("_effectLink");

            for(int idx =0; idx < linkPoints.Length;idx++)
            {
                if(linkPoints[idx] == _effectLink.stringValue)
                {
                    effectLinkIdx = idx;
                    break;
                }
            }
        }

        public override void OnInspectorGUI()
        {
            base.OnInspectorGUI();

            serializedObject.Update();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("特效ID:", EditorStyles.label, GUILayout.Width(140));
            _effectId.intValue = EditorGUILayout.IntField(_effectId.intValue, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("特效预设:", EditorStyles.label, GUILayout.Width(140));
            _effectPrefab.objectReferenceValue = EditorGUILayout.ObjectField(_effectPrefab.objectReferenceValue, typeof(GameObject), false, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("挂载点:", EditorStyles.label, GUILayout.Width(140));
            effectLinkIdx = EditorGUILayout.Popup(effectLinkIdx, linkPoints, GUILayout.Width(300));
            if (effectLinkIdx >= 0)
                _effectLink.stringValue = linkPoints[effectLinkIdx];
            EditorGUILayout.EndHorizontal();

            serializedObject.ApplyModifiedProperties();
        }
    }
}