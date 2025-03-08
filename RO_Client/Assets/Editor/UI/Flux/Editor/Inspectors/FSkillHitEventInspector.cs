using UnityEngine;
using UnityEditor;
using Flux;

namespace FluxEditor
{
    [CustomEditor(typeof(FSkillHitEvent))]
    public class FSkillHitEventInspector : FEventInspector
    {
        private FSkillHitEvent _skillHitEvent = null;

        private SerializedProperty _moveType = null;
        private SerializedProperty _initSpeed = null;
        private SerializedProperty _acceleration = null;
        private SerializedProperty _moveDistance = null;
        private SerializedProperty _triggerBuffId = null;
        private SerializedProperty _triggerBuffRate = null;


        private SerializedProperty _hitEffectId = null;
        private SerializedProperty _hitEffectPrefab = null;
        private SerializedProperty _hitEffectLink = null;


        int[] moveTypes = new int[] { 0, 1, 5 };
        string[] moveTypeStrs = new string[] { "无", "击退", "击飞" };
        private int effectLinkIdx = -1;


        protected override void OnEnable()
        {
            base.OnEnable();

            _skillHitEvent = (FSkillHitEvent)target;
            _moveType = serializedObject.FindProperty("_moveType");
            _initSpeed = serializedObject.FindProperty("_initSpeed");
            _acceleration = serializedObject.FindProperty("_acceleration");
            _moveDistance = serializedObject.FindProperty("_moveDistance");
            _triggerBuffId = serializedObject.FindProperty("_triggerBuffId");
            _triggerBuffRate = serializedObject.FindProperty("_triggerBuffRate");


            _hitEffectId = serializedObject.FindProperty("_hitEffectId");
            _hitEffectPrefab = serializedObject.FindProperty("_hitEffectPrefab");
            _hitEffectLink = serializedObject.FindProperty("_hitEffectLink");


            for (int idx = 0; idx < linkPoints.Length; idx++)
            {
                if (linkPoints[idx] == _hitEffectLink.stringValue)
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
            GUILayout.Label("命中特效id:", EditorStyles.label, GUILayout.Width(140));
            _hitEffectId.intValue = EditorGUILayout.IntField(_hitEffectId.intValue, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("命中特效预设:", EditorStyles.label, GUILayout.Width(140));
            _hitEffectPrefab.objectReferenceValue = EditorGUILayout.ObjectField(_hitEffectPrefab.objectReferenceValue, typeof(GameObject), false, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("挂载点:", EditorStyles.label, GUILayout.Width(140));
            effectLinkIdx = EditorGUILayout.Popup(effectLinkIdx, linkPoints, GUILayout.Width(300));
            if (effectLinkIdx >= 0)
                _hitEffectLink.stringValue = linkPoints[effectLinkIdx];
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("击中目标效果:", EditorStyles.label, GUILayout.Width(140));
            _moveType.intValue = EditorGUILayout.IntPopup(_moveType.intValue, moveTypeStrs, moveTypes);
            EditorGUILayout.EndHorizontal();

            if (_moveType.intValue == (int)FighterMoveType.Beat_Back)
            {
                EditorGUILayout.BeginHorizontal();
                GUILayout.Label("击退初速度:", EditorStyles.label, GUILayout.Width(140));
                _initSpeed.floatValue = EditorGUILayout.FloatField(_initSpeed.floatValue);
                EditorGUILayout.EndHorizontal();

                EditorGUILayout.BeginHorizontal();
                GUILayout.Label("击退加速度:", EditorStyles.label, GUILayout.Width(140));
                _acceleration.floatValue = EditorGUILayout.FloatField(_acceleration.floatValue);
                EditorGUILayout.EndHorizontal();

                EditorGUILayout.BeginHorizontal();
                GUILayout.Label("击退距离:", EditorStyles.label, GUILayout.Width(140));
                _moveDistance.floatValue = EditorGUILayout.FloatField(_moveDistance.floatValue);
                EditorGUILayout.EndHorizontal();
            }
            else if (_moveType.intValue == (int)FighterMoveType.Beat_Fly)
            {
                EditorGUILayout.BeginHorizontal();
                GUILayout.Label("挑飞初速度:", EditorStyles.label, GUILayout.Width(140));
                _initSpeed.floatValue = EditorGUILayout.FloatField(_initSpeed.floatValue);
                EditorGUILayout.EndHorizontal();

                EditorGUILayout.BeginHorizontal();
                GUILayout.Label("挑飞加速度:", EditorStyles.label, GUILayout.Width(140));
                _acceleration.floatValue = EditorGUILayout.FloatField(_acceleration.floatValue);
                EditorGUILayout.EndHorizontal();

                EditorGUILayout.BeginHorizontal();
                GUILayout.Label("挑飞高度:", EditorStyles.label, GUILayout.Width(140));
                _moveDistance.floatValue = EditorGUILayout.FloatField(_moveDistance.floatValue);
                EditorGUILayout.EndHorizontal();
            }

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("触发buffID:", EditorStyles.label, GUILayout.Width(140));
            _triggerBuffId.intValue = EditorGUILayout.IntField(_triggerBuffId.intValue);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("触发buff概率:", EditorStyles.label, GUILayout.Width(140));
            _triggerBuffRate.intValue = EditorGUILayout.IntField(_triggerBuffRate.intValue);
            EditorGUILayout.EndHorizontal();

            serializedObject.ApplyModifiedProperties();
        }
    }
}