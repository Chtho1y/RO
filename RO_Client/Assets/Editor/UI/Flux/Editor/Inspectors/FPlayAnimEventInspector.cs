using UnityEngine;
using UnityEditor;
using Flux;


namespace FluxEditor
{
    [CustomEditor(typeof(FPlayAnimEvent))]
    public class FPlayAnimEventInspector : FEventInspector
    {
        private FPlayAnimEvent _animEvent;

        private SerializedProperty _animName = null;
        private SerializedProperty _animSpeed = null;

        private string[] animClipNames = null;
        private int animIdx = -1;

        protected override void OnEnable()
        {
            base.OnEnable();

            _animEvent = (FPlayAnimEvent)target;

            _animName = serializedObject.FindProperty("_animName");
            _animSpeed = serializedObject.FindProperty("_animSpeed");

            if (_animEvent.animator != null)
            {
                RuntimeAnimatorController ctrl = _animEvent.animator.runtimeAnimatorController;

                UnityEditor.Animations.AnimatorController ac = ctrl as UnityEditor.Animations.AnimatorController;

                animClipNames = new string[ac.layers[0].stateMachine.states.Length];
                for (int i = 0; i < animClipNames.Length; i++)
                {
                    animClipNames[i] = ac.layers[0].stateMachine.states[i].state.name;
                }

                if (animClipNames != null)
                {
                    for (int i = 0; i < animClipNames.Length; i++)
                    {
                        if (_animEvent.AnimName == animClipNames[i])
                        {
                            animIdx = i;
                            break;
                        }
                    }
                }
            }
        }

        public override void OnInspectorGUI()
        {
            base.OnInspectorGUI();

            serializedObject.Update();

            if (animClipNames != null)
            {
                EditorGUILayout.BeginHorizontal();
                GUILayout.Label("引导动作", EditorStyles.label, GUILayout.Width(140));

                animIdx = EditorGUILayout.Popup(animIdx, animClipNames,GUILayout.Width(300));
                if (animIdx >= 0)
                {
                    _animName.stringValue = animClipNames[animIdx];
                }
                EditorGUILayout.EndHorizontal();

                EditorGUILayout.BeginHorizontal();

                GUILayout.Label("动作播放速度", EditorStyles.label, GUILayout.Width(140));
                _animSpeed.intValue = EditorGUILayout.IntField("", _animSpeed.intValue, GUILayout.Width(300));

                EditorGUILayout.EndHorizontal();
            }

            serializedObject.ApplyModifiedProperties();
        }
    }
}