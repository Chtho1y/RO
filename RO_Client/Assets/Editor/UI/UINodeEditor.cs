using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEngine.UI;

[CustomEditor(typeof(UINode))]
[CanEditMultipleObjects]
public class UINodeEditor : Editor
{
    struct UINodeEditorSetting
    {
        public string[] keys;
        public string[] values;
        public UINodeEditorSetting(string[] keys, string[] values)
        {
            this.keys = keys;
            this.values = values;
        }
    }
    static List<UINodeEditorSetting> UINodeEditorSettings = new List<UINodeEditorSetting>
    {
        //new UINodeEditorSetting(new string[2]{ typeof(Button).FullName, typeof(Image).FullName }, new string[1]{ typeof(Image).FullName }),
        new UINodeEditorSetting(new string[1]{ typeof(Text).FullName }, new string[1]{ typeof(Text).FullName }),
        new UINodeEditorSetting(new string[1]{ typeof(Button).FullName }, new string[1]{ typeof(Button).FullName }),
        new UINodeEditorSetting(new string[1]{ typeof(Toggle).FullName }, new string[1]{ typeof(Toggle).FullName }),
        new UINodeEditorSetting(new string[1]{ typeof(Slider).FullName }, new string[1]{ typeof(Slider).FullName }),
        new UINodeEditorSetting(new string[1]{ typeof(Scrollbar).FullName }, new string[1]{ typeof(Scrollbar).FullName }),
        new UINodeEditorSetting(new string[1]{ typeof(Dropdown).FullName }, new string[1]{ typeof(Dropdown).FullName }),
        new UINodeEditorSetting(new string[1]{ typeof(InputField).FullName }, new string[1]{ typeof(InputField).FullName }),
    };

    void OnEnable()
    {
    }

    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();

        serializedObject.Update();

        List<UINode> nodes = new List<UINode>();

        UnityEngine.Object[] targetObjects = serializedObject.targetObjects;

        foreach (UnityEngine.Object targetObject in targetObjects)
        {
            UINode uiNode = targetObject as UINode;
            if (uiNode == null)
            {
                continue;
            }
            if (uiNode.keys == null)
            {
                uiNode.keys = new List<string>();
            }

            if (uiNode.values == null)
            {
                uiNode.values = new List<bool>();
            }

            //check
            Component[] components = uiNode.gameObject.GetComponents<Component>();
            for (int i = uiNode.keys.Count - 1; i >= 0; i--)
            {
                string key = uiNode.keys[i];
                bool b = false;
                foreach (var component in components)
                {
                    if (component.GetType().FullName == key)
                    {
                        b = true;
                        break;
                    }
                }
                if (!b)
                {
                    uiNode.keys.RemoveAt(i);
                    uiNode.values.RemoveAt(i);
                }
            }
            List<string> addComp = new List<string>();
            foreach (var component in components)
            {
                bool b = false;
                for (int i = 0; i < uiNode.keys.Count; i++)
                {
                    string key = uiNode.keys[i];
                    if (component.GetType().FullName == key)
                    {
                        b = true;
                        break;
                    }
                }
                if (!b)
                {
                    addComp.Add(component.GetType().FullName);
                    //设置默认
                    uiNode.keys.Add(component.GetType().FullName);
                    uiNode.values.Add(false);
                }
            }
            if (addComp.Count > 0)
            {
                foreach (var settings in UINodeEditorSettings)
                {
                    bool b = true;
                    foreach (var key in settings.keys)
                    {
                        bool tmpB = false;
                        foreach (var addC in addComp)
                        {
                            if (addC == key)
                            {
                                tmpB = true;
                                break;
                            }
                        }
                        if (!tmpB)
                        {
                            b = false;
                            break;
                        }
                    }
                    if (b)
                    {
                        foreach (var value in settings.values)
                        {
                            uiNode.SetValue(value, true);
                        }
                    }
                }
            }

            nodes.Add(uiNode);
        }
        Dictionary<string, bool> keyValues = new Dictionary<string, bool>();
        Color tmp = GUI.color;
        foreach (var firstNode in nodes)
        {

            for (int i = 0; i < firstNode.keys.Count; i++)
            {
                string key = firstNode.keys[i];

                if (key == "UINode")
                {
                    continue;
                }
                bool currB = firstNode.values[i];
                bool b = true;
                bool bSame = true;
                foreach (var node in nodes)
                {
                    bool value;
                    if (!node.GetValue(key, out value))
                    {
                        b = false;
                        break;
                    }
                    else
                    {
                        if (value != currB)
                        {
                            bSame = false;
                        }
                    }
                }
                if (b)
                {

                    if (!bSame)
                    {
                        GUI.color = Color.red;
                        currB = false;
                    }
                    string name = key;
                    int indexOf = name.LastIndexOf(".");
                    if (indexOf != -1)
                    {
                        name = name.Substring(indexOf + 1, name.Length - indexOf - 1);
                    }
                    bool toggle = EditorGUILayout.Toggle(name, currB);
                    if (currB != toggle)
                    {
                        keyValues[key] = toggle;
                    }

                    if (!bSame)
                        GUI.color = tmp;
                }
            }
            break;
        }
        GUI.color = tmp;

        foreach (var key in keyValues.Keys)
        {
            foreach (var n in nodes)
            {
                n.SetValue(key, keyValues[key]);
            }
        }
        //EditorUtility.SetDirty(target);
        serializedObject.ApplyModifiedProperties();
    }
}
