using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using UnityEngine;
using UnityEditor;
using UnityEditor.Animations;
using UnityEditorInternal;
using AnimatorController = UnityEditor.Animations.AnimatorController;

[CustomEditor(typeof(RandomChangeAnimState))]
[CanEditMultipleObjects]
public class RandomChangeAnimStateEditor : Editor
{
    private SerializedProperty m_ScriptSp;
    private SerializedProperty m_MinSp;
    private SerializedProperty m_MaxSp;
    private SerializedProperty m_StateHashNamesSp;

    private AnimatorController m_AnimatorController;
    private Dictionary<int, string> m_StateNameMap = new Dictionary<int, string>();
    private int selectLayerIndex = 0;
    private ReorderableList m_ReorderableList;
    private BindingFlags m_BindingFlags = BindingFlags.NonPublic | BindingFlags.Public | BindingFlags.Static | BindingFlags.Instance;

    private void OnEnable() {
        foreach(var itemType in typeof(UnityEditor.Graphs.GraphGUI).Assembly.GetTypes())
        {
            if (itemType.Name == "AnimatorControllerTool")
            {
                var toolFieldInfo = itemType.GetField("tool", m_BindingFlags);
                var animatorControllerPropertyInfo = itemType.GetProperty("animatorController", m_BindingFlags);
                var selectLayerIndexPropertyInfo = itemType.GetProperty("selectedLayerIndex", m_BindingFlags);
                var tool = toolFieldInfo.GetValue(null);
                if (tool != null)
                {
                    m_AnimatorController = (AnimatorController)animatorControllerPropertyInfo.GetValue(tool);
                    int.TryParse(selectLayerIndexPropertyInfo.GetValue(tool).ToString(), out selectLayerIndex);
                }
                break;
            }
        }

        m_ScriptSp = serializedObject.FindProperty("m_Script");
        m_MinSp = serializedObject.FindProperty("min");
        m_MaxSp = serializedObject.FindProperty("max");
        m_StateHashNamesSp = serializedObject.FindProperty("stateHashNames");

        m_ReorderableList = new ReorderableList(serializedObject, m_StateHashNamesSp);
        m_ReorderableList.drawHeaderCallback = ReorderableListHeaderCallback;
        m_ReorderableList.drawElementCallback = ReorderableListElementCallbackDelegate;
        m_ReorderableList.onCanAddCallback = ReorderableListCanAddCallback;
        m_ReorderableList.onAddDropdownCallback = ReorderableListAddDropdownCallback;
    }

    private void SerializedObjectUpdate()
    {
        serializedObject.Update();
    }

    private void SerializedObjectApply()
    {
        if (serializedObject.ApplyModifiedProperties())
        {
            foreach (var item in targets)
            {
                EditorUtility.SetDirty(item);
            }
        }
    }

    public override void OnInspectorGUI()
    {
        if (!m_AnimatorController)
        {
            EditorGUILayout.HelpBox("无法找到AnimatorController, 请通知程序", MessageType.Error);
            return;
        }
        SerializedObjectUpdate();
        
        bool defaultEnable = GUI.enabled;
        GUI.enabled = false;
        EditorGUILayout.PropertyField(m_ScriptSp);
        GUI.enabled = defaultEnable;

        EditorGUILayout.LabelField("随机时间区间", EditorStyles.boldLabel);
        EditorGUI.indentLevel++;

        float min = m_MinSp.floatValue;
        float max = m_MaxSp.floatValue;
        min = EditorGUILayout.FloatField("最小值", min);
        max = EditorGUILayout.FloatField("最大值", max);
        m_MinSp.floatValue = Mathf.Max(0, Mathf.Min(min, max));
        m_MaxSp.floatValue = Mathf.Max(min, max);

        EditorGUI.indentLevel--;

        m_StateNameMap.Clear();
        foreach (var layer in m_AnimatorController.layers)
        {
            CollectStateName(layer.stateMachine, ref m_StateNameMap);
        }

        for (int i = m_StateHashNamesSp.arraySize - 1; i >= 0; i--)
        {
            int hashName = m_StateHashNamesSp.GetArrayElementAtIndex(i).intValue;
            if (!m_StateNameMap.ContainsKey(hashName))
            {
                m_StateHashNamesSp.DeleteArrayElementAtIndex(i);
            }
        }

        m_ReorderableList.DoLayoutList();

        SerializedObjectApply();
    }


    public void ReorderableListHeaderCallback(Rect rect)
    {
        EditorGUI.LabelField(rect, "随机切换动画状态列表");
    }

    public void ReorderableListElementCallbackDelegate(Rect rect, int index, bool isActive, bool isFocused)
    {
        int hashName = m_StateHashNamesSp.GetArrayElementAtIndex(index).intValue;
        EditorGUI.LabelField(rect, m_StateNameMap[hashName]);
    }

    public bool ReorderableListCanAddCallback(ReorderableList list)
    {
        return m_StateNameMap.Count > list.count;
    }

	public void ReorderableListAddDropdownCallback(Rect buttonRect, ReorderableList list)
    {
        GenericMenu genericMenu = new GenericMenu();
        int[] arr = new int[m_StateNameMap.Count];
        m_StateNameMap.Keys.CopyTo(arr, 0);
        bool isContain = false;
        for (int i = 0; i < arr.Length; i++)
        {
            isContain = false;
            for (int j = m_StateHashNamesSp.arraySize - 1; j >= 0; j--)
            {
                if (arr[i] == m_StateHashNamesSp.GetArrayElementAtIndex(j).intValue)
                {
                    isContain = true;
                    break;
                }
            }
            if (isContain) continue;
            genericMenu.AddItem(EditorGUIUtility.TrTextContent(m_StateNameMap[arr[i]]), false, (hashName) =>
            {
                SerializedObjectUpdate();
                m_StateHashNamesSp.arraySize++;
				list.index = list.serializedProperty.arraySize - 1;
                m_StateHashNamesSp.GetArrayElementAtIndex(list.index).intValue = (int)hashName;
                SerializedObjectApply();
            }, arr[i]);
        }
        genericMenu.ShowAsContext();
    }

    private void CollectStateName(AnimatorStateMachine animatorStateMachine, ref Dictionary<int, string> stateNameMap)
    {
        string name = animatorStateMachine.name;
        if (!string.IsNullOrEmpty(name))
        {
            int hashName = Animator.StringToHash(name);
            if (!stateNameMap.ContainsKey(hashName))
            {
                stateNameMap.Add(hashName, name);
            }
        }
        foreach (var item in animatorStateMachine.states)
        {
            if (!stateNameMap.ContainsKey(item.state.nameHash))
            {
                stateNameMap.Add(item.state.nameHash, item.state.name);
            }
        }
        foreach (var item in animatorStateMachine.stateMachines)
        {
            CollectStateName(item.stateMachine, ref stateNameMap);
        }
    }
}
