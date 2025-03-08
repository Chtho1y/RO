using UnityEngine;
using UnityEditor;
using Flux;

namespace FluxEditor
{
    [CustomEditor(typeof(FSkillDelayHurtEvent))]
    public class FSkillDelayHurtEventInspector : FEventInspector
    {
        private FSkillDelayHurtEvent _delayHurtEvent = null;

        private SerializedProperty _hitEffectId = null;
        private SerializedProperty _hitEffectPrefab = null;
        private SerializedProperty _hitEffectLink = null;
        private SerializedProperty _hurtDelayFrame = null;
        private SerializedProperty _delayHurtInterval = null;
        private SerializedProperty _delayHurtCount = null;

        private int hitEffectLinkIdx = -1;

        protected override void OnEnable()
        {
            base.OnEnable();

            _delayHurtEvent = (FSkillDelayHurtEvent)target;

            _hitEffectId = serializedObject.FindProperty("_hitEffectId");
            _hitEffectPrefab = serializedObject.FindProperty("_hitEffectPrefab");
            _hitEffectLink = serializedObject.FindProperty("_hitEffectLink");
            _hurtDelayFrame = serializedObject.FindProperty("_hurtDelayFrame");
            _delayHurtInterval = serializedObject.FindProperty("_delayHurtInterval");
            _delayHurtCount = serializedObject.FindProperty("_delayHurtCount");

            for (int idx = 0; idx < linkPoints.Length; idx++)
            {
                if (linkPoints[idx] == _hitEffectLink.stringValue)
                {
                    hitEffectLinkIdx = idx;
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
            _hitEffectId.intValue = EditorGUILayout.IntField(_hitEffectId.intValue, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("特效预设:", EditorStyles.label, GUILayout.Width(140));
            _hitEffectPrefab.objectReferenceValue = EditorGUILayout.ObjectField(_hitEffectPrefab.objectReferenceValue, typeof(GameObject), false, GUILayout.Width(300));

            GUILayout.Label("挂载点:", EditorStyles.label, GUILayout.Width(140));
            hitEffectLinkIdx = EditorGUILayout.Popup(hitEffectLinkIdx, linkPoints, GUILayout.Width(300));
            if (hitEffectLinkIdx >= 0)
                _hitEffectLink.stringValue = linkPoints[hitEffectLinkIdx];
            EditorGUILayout.EndHorizontal();


            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("延迟帧数:", EditorStyles.label, GUILayout.Width(140));
            _hurtDelayFrame.intValue = EditorGUILayout.IntField(_hurtDelayFrame.intValue, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("伤害次数:", EditorStyles.label, GUILayout.Width(140));
            _delayHurtCount.intValue = EditorGUILayout.IntField(_delayHurtCount.intValue, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("伤害间隔:", EditorStyles.label, GUILayout.Width(140));
            _delayHurtInterval.intValue = EditorGUILayout.IntField(_delayHurtInterval.intValue, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            serializedObject.ApplyModifiedProperties();
        }
    }
}