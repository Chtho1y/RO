using UnityEngine;
using UnityEditor;
using Flux;

namespace FluxEditor
{
    [CustomEditor(typeof(FTimeline))]
    public class FTimelineInspector : Editor
    {
        private FTimeline _timeline;


        private SerializedProperty _buffId = null;
        private SerializedProperty _buffName = null;
        private SerializedProperty _gender = null;
        private SerializedProperty _jobType = null;
        private SerializedProperty _jobStage = null;
        private SerializedProperty _jobBranch = null;

        string[] genderStrs = new string[] { "无", "女", "男", "所有" };
        int[] genderInts = new int[] { 0, 1, 2, 3 };

        string[] jobStrs = new string[] { "初心者", "剑士", "盗贼", "弓手", "法师", "服侍" };
        int[] jobInts = new int[] { 0, 1, 2, 3, 4, 5 };
     
        private void OnEnable()
        {
            _timeline = (FTimeline)target;

            _buffId = serializedObject.FindProperty("_buffId");
            _buffName = serializedObject.FindProperty("_buffName");
            _gender = serializedObject.FindProperty("_gender");
            _jobType = serializedObject.FindProperty("_jobType");
            _jobStage = serializedObject.FindProperty("_jobStage");
            _jobBranch = serializedObject.FindProperty("_jobBranch"); 
        }

        public override void OnInspectorGUI()
        {
           
            serializedObject.Update();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("buffid:", EditorStyles.label,GUILayout.Width(140));
            _buffId.intValue = EditorGUILayout.IntField(_buffId.intValue,GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("buffName:", EditorStyles.label,GUILayout.Width(140));
            _buffName.stringValue = EditorGUILayout.TextField(_buffName.stringValue,GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("性别:", EditorStyles.label, GUILayout.Width(140));
            _gender.intValue = EditorGUILayout.IntPopup(_gender.intValue,genderStrs,genderInts, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("所属职业:", EditorStyles.label, GUILayout.Width(140));
            _jobType.intValue = EditorGUILayout.IntPopup(_jobType.intValue, jobStrs, jobInts, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("职业转职阶段:", EditorStyles.label, GUILayout.Width(140));
            _jobStage.intValue = EditorGUILayout.IntField(_jobStage.intValue, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("职业转职分支:", EditorStyles.label, GUILayout.Width(140));
            _jobBranch.intValue = EditorGUILayout.IntField(_jobBranch.intValue, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            if (_timeline.Owner != null)
            {
                _timeline.Owner.name = "buff_" + _buffId.intValue+"_"+_gender.intValue+"_"+_jobType.intValue+"_"+_jobStage.intValue+"_"+_jobBranch.intValue;
            }

            serializedObject.ApplyModifiedProperties();

            base.OnInspectorGUI();
        }
    }
}