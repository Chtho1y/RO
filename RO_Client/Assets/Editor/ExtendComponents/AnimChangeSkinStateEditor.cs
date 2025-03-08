using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEditor;
using UnityEditor.Animations;
using UnityEditorInternal;
using AnimatorController = UnityEditor.Animations.AnimatorController;
using LuaInterface;

[CustomEditor(typeof(AnimChangeSkinState))]
public class AnimChangeSkinStateEditor : Editor
{
    private SerializedProperty m_Script;
    private SerializedProperty m_SkinSlotTypes;
    private SerializedProperty m_RoleAvatarIds;

    private int m_ArraySize = 0;
    private ReorderableList m_ReorderableList;

    private Dictionary<int, string> m_SkinSlotTypeNames = new Dictionary<int, string>()
    {
        [1] = "头上",
        [2] = "头中",
        [3] = "头下",
        [4] = "衣服",
        [5] = "左手",
        [6] = "右手",
        [7] = "背部",
        [8] = "发型",
        [9] = "瞳孔",
        [100] = "头发颜色",
        [101] = "脸型",
    };

    private const string c_RoleAvatarCfgPath = "Assets/Lua/Config/RoleAvatarCfg.lua";
    private Dictionary<int, string> m_AvatarIdMap = new Dictionary<int, string>();
    private void OnEnable() {
        m_Script = serializedObject.FindProperty("m_Script");
        m_SkinSlotTypes = serializedObject.FindProperty("m_SkinSlotTypes");
        m_RoleAvatarIds = serializedObject.FindProperty("m_RoleAvatarIds");
        if (Application.isPlaying) return;
        m_AvatarIdMap.Clear();
        using (LuaState luaState = new LuaState())
        {
            try
            {   
                luaState.Start();
                using (LuaTable luaTable = luaState.DoFile<LuaTable>(c_RoleAvatarCfgPath))
                {
                    try
                    {
                        using (LuaDictTable<int, LuaTable> luaDictTable = luaTable.ToDictTable<int, LuaTable>())
                        {
                            try
                            {
                                foreach (var item in luaDictTable)
                                {
                                    int id = item.Key;
                                    string name = item.Value["AvatarPrefab"].ToString();
                                    if (!string.IsNullOrEmpty(name))
                                    {
                                        if (m_AvatarIdMap.ContainsKey(id))
                                        {
                                            Debug.LogError(c_RoleAvatarCfgPath + " 存在相同的Id " + id);
                                        }
                                        else
                                        {
                                            m_AvatarIdMap.Add(id, name);
                                        }
                                    }
                                }
                            }
                            catch (System.Exception e)
                            {
                                Debug.LogException(e);
                            }
                        }
                    }
                    catch (System.Exception e)
                    {
                        Debug.LogException(e);
                    }
                }
            }
            catch (System.Exception e)
            {
                Debug.LogException(e);
            }
        }

        // 检查错误数据
        SerializedObjectUpdate();
        for (int j = m_SkinSlotTypes.arraySize - 1; j >= 0; j--)
        {
            int skinSlotType = m_SkinSlotTypes.GetArrayElementAtIndex(j).intValue;
            if (!m_SkinSlotTypeNames.ContainsKey(skinSlotType))
            {
                m_SkinSlotTypes.DeleteArrayElementAtIndex(j);
                m_RoleAvatarIds.DeleteArrayElementAtIndex(j);
            }
        }
        SerializedObjectApply();

        int arraySize1 = m_SkinSlotTypes.arraySize;
        int arraySize2 = m_RoleAvatarIds.arraySize;
        m_ArraySize = Mathf.Min(arraySize1, arraySize2, m_SkinSlotTypeNames.Count);

        m_ReorderableList = new ReorderableList(serializedObject, m_SkinSlotTypes);
        m_ReorderableList.drawHeaderCallback = ReorderableListHeaderCallback;
        m_ReorderableList.drawElementCallback = ReorderableListElementCallback;
        m_ReorderableList.onCanAddCallback = ReorderableListCanAddCallback;
        m_ReorderableList.onAddDropdownCallback = ReorderableListAddDropdownCallback;
        m_ReorderableList.onRemoveCallback = ReorderableListRemoveCallback;
    }

    public override void OnInspectorGUI()
    {
        SerializedObjectUpdate();
        bool defaultEnable = GUI.enabled;
        GUI.enabled = false;
        EditorGUILayout.PropertyField(m_Script);
        GUI.enabled = defaultEnable;
        if (Application.isPlaying)
        {
            EditorGUILayout.Space();
            EditorGUILayout.HelpBox("目前只能在非播放模式下编辑", MessageType.Warning);
            EditorGUILayout.Space();
        }
        else
        {
            m_ReorderableList.DoLayoutList();
        }

        SerializedObjectApply();
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

    public void ReorderableListHeaderCallback(Rect rect)
    {
        EditorGUI.LabelField(rect, "修改角色皮肤列表");
    }

    public void ReorderableListElementCallback(Rect rect, int index, bool isActive, bool isFocused)
    {
        int skinSlotType = m_SkinSlotTypes.GetArrayElementAtIndex(index).intValue;
        int avatarId = m_RoleAvatarIds.GetArrayElementAtIndex(index).intValue;
        Rect rect1 = new Rect(rect.x, rect.y, 50, rect.height);
        Rect rect2 = new Rect(rect.x + 50, rect.y, 50, rect.height);
        Rect rect3 = new Rect(rect.x + 105, rect.y, rect.width - 105, rect.height);
        EditorGUI.LabelField(rect1, m_SkinSlotTypeNames[skinSlotType]);
        int avatarIdTemp = EditorGUI.DelayedIntField(rect2, avatarId);
        if (avatarIdTemp != avatarId)
        {
            avatarId = avatarIdTemp;
            m_RoleAvatarIds.GetArrayElementAtIndex(index).intValue = avatarId;
        }
        if (m_AvatarIdMap.ContainsKey(avatarId))
        {
            EditorGUI.LabelField(rect3, m_AvatarIdMap[avatarId]);
        }
        else
        {
            if (avatarId == 0)
            {
                EditorGUI.LabelField(rect3, "重置默认值");
            }
            else if (avatarId == 99999)
            {
                EditorGUI.LabelField(rect3, "隐藏");
            }
            else
            {
                EditorGUI.LabelField(rect3, "当配置中无法找到资源, 也会隐藏");
            }
        }

        Event evt = Event.current;
        if (evt.type == EventType.DragUpdated)
        {
            if (rect.Contains(evt.mousePosition))
            {
                DragAndDrop.visualMode = DragAndDropVisualMode.Copy;
            }
        }
        else if (evt.type == EventType.DragPerform)
        {
            if (rect.Contains(evt.mousePosition))
            {
                DragAndDrop.AcceptDrag();
                if (DragAndDrop.objectReferences != null && DragAndDrop.objectReferences.Length > 0)
                {
                    GameObject go = DragAndDrop.objectReferences[0] as GameObject;
                    if (go)
                    {
                        string path = AssetDatabase.GetAssetPath(go);
                        if (!string.IsNullOrEmpty(path))
                        {
                            path = path.Replace("\\", "/");
                            path = path.Replace(".prefab", "");
                            string name = path.Replace(Constants.ModelPath + "/", "");
                            if (!string.IsNullOrEmpty(name))
                            {
                                int id = 0;
                                foreach (var item in m_AvatarIdMap)
                                {
                                    if (item.Value == name)
                                    {
                                        id = item.Key;
                                        Debug.LogError(id);
                                        break;
                                    }
                                }
                                if (id != 0)
                                {
                                    avatarId = id;
                                    m_RoleAvatarIds.GetArrayElementAtIndex(index).intValue = id;
                                }
                            }
                        }
                    }
                }
            }
        }
        else if (evt.type == EventType.MouseDown)
        {
            if (rect.Contains(evt.mousePosition))
            {
                if (m_AvatarIdMap.ContainsKey(avatarId))
                {
                    string path = Constants.ModelPath + "/" + m_AvatarIdMap[avatarId] + ".prefab";
                    GameObject go = AssetDatabase.LoadAssetAtPath<GameObject>(path);
                    if (go) EditorGUIUtility.PingObject(go);
                }
            }
        }
    }

    public bool ReorderableListCanAddCallback(ReorderableList list)
    {
        return m_SkinSlotTypeNames.Count > list.count;
    }

	public void ReorderableListAddDropdownCallback(Rect buttonRect, ReorderableList list)
    {
        GenericMenu genericMenu = new GenericMenu();
        int[] arr = new int[m_SkinSlotTypeNames.Count];
        m_SkinSlotTypeNames.Keys.CopyTo(arr, 0);
        bool isContain = false;
        for (int i = 0; i < arr.Length; i++)
        {
            isContain = false;
            for (int j = m_SkinSlotTypes.arraySize - 1; j >= 0; j--)
            {
                if (arr[i] == m_SkinSlotTypes.GetArrayElementAtIndex(j).intValue)
                {
                    isContain = true;
                    break;
                }
            }
            if (isContain) continue;
            genericMenu.AddItem(EditorGUIUtility.TrTextContent(m_SkinSlotTypeNames[arr[i]]), false, (skinSlotType) =>
            {
                SerializedObjectUpdate();
                m_SkinSlotTypes.arraySize++;
                m_RoleAvatarIds.arraySize++;
				list.index = m_SkinSlotTypes.arraySize - 1;
                m_SkinSlotTypes.GetArrayElementAtIndex(list.index).intValue = (int)skinSlotType;
                SerializedObjectApply();
            }, arr[i]);
        }
        genericMenu.ShowAsContext();
    }

    public void ReorderableListRemoveCallback(ReorderableList list)
    {
        int index = list.index;
        m_SkinSlotTypes.DeleteArrayElementAtIndex(index);
        m_RoleAvatarIds.DeleteArrayElementAtIndex(index);
    }
}
