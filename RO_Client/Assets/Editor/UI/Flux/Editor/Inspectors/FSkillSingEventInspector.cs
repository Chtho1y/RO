using UnityEngine;
using UnityEditor;
using Flux;

namespace FluxEditor
{
    [CustomEditor(typeof(FSkillSingEvent))]
    public class FSkillSingEventInspector : FEventInspector
    {
        private FSkillSingEvent _skillSingEvent = null;

        private SerializedProperty _effectId = null;
        private SerializedProperty _startOffset = null;
        private SerializedProperty _effectPrefab = null;
        private SerializedProperty _effectLink = null;

        private string[] animClipNames = null;

        private int animIdx = -1;
        private int effectLinkIdx = -1;

        protected override void OnEnable()
        {
            base.OnEnable();

            _skillSingEvent = (FSkillSingEvent)target;

            _startOffset = serializedObject.FindProperty("_startOffset");
            _effectPrefab = serializedObject.FindProperty("_effectPrefab");
            _effectLink = serializedObject.FindProperty("_effectLink");
            _effectId = serializedObject.FindProperty("_effectId");

            if (_skillSingEvent.animator!=null)
            {
                RuntimeAnimatorController ctrl = _skillSingEvent.animator.runtimeAnimatorController;

                UnityEditor.Animations.AnimatorController ac = ctrl as UnityEditor.Animations.AnimatorController;

                animClipNames = new string[ac.layers[0].stateMachine.states.Length];
                for (int i = 0; i < animClipNames.Length; i++)
                {
                    animClipNames[i] = ac.layers[0].stateMachine.states[i].state.name;
                }

                if(animClipNames!=null)
                {
                    for (int i = 0; i < animClipNames.Length; i++)
                    {
                        if (_skillSingEvent._animName == animClipNames[i])
                        {
                            animIdx = i;
                            break;
                        }
                    }
                }
            }

            for (int idx = 0; idx < linkPoints.Length; idx++)
            {
                if (linkPoints[idx] == _effectLink.stringValue)
                {
                    effectLinkIdx = idx;
                    break;
                }
            }
        }

        public override void OnInspectorGUI()
        {
            AudioClip currentClip = _skillSingEvent.AudioClip;

            base.OnInspectorGUI();

           
            serializedObject.Update();
            _startOffset.intValue = Mathf.Clamp(_startOffset.intValue, 0, int.MaxValue);
            EditorGUI.BeginChangeCheck();
            EditorGUILayout.IntSlider(_startOffset, 0, int.MaxValue);
            if (EditorGUI.EndChangeCheck())
            {
                if (FSequenceEditorWindow.instance != null)
                    FSequenceEditorWindow.instance.Repaint();
            }


            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("吟唱特效ID:", EditorStyles.label, GUILayout.Width(140));
            _effectId.intValue = EditorGUILayout.IntField(_effectId.intValue, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("吟唱特效预设:", EditorStyles.label, GUILayout.Width(140));
            _effectPrefab.objectReferenceValue = EditorGUILayout.ObjectField(_effectPrefab.objectReferenceValue, typeof(GameObject), false, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("挂载点:", EditorStyles.label, GUILayout.Width(140));
            effectLinkIdx = EditorGUILayout.Popup(effectLinkIdx, linkPoints, GUILayout.Width(300));
            if (effectLinkIdx >= 0)
                _effectLink.stringValue = linkPoints[effectLinkIdx];
            EditorGUILayout.EndHorizontal();

            serializedObject.ApplyModifiedProperties();

            if(animClipNames!=null)
            {
                EditorGUILayout.BeginHorizontal();
                GUILayout.Label("吟唱动作", EditorStyles.label, GUILayout.Width(140));

                animIdx = EditorGUILayout.Popup(animIdx, animClipNames);
                if (animIdx >= 0)
                {
                    _skillSingEvent._animName = animClipNames[animIdx];
                }
                EditorGUILayout.EndHorizontal();
            }
        }
    }
}