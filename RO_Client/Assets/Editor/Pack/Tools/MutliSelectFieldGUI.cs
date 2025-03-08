using System;
using System.Collections.Generic;
using System.Reflection;
using UnityEngine;
using UnityEditor;

namespace Pack
{
    public static class MutliSelectFieldGUI
    {
        private class MutliSelectCallbackInfo
        {
            // The global shared popup state
            public static MutliSelectCallbackInfo m_Instance;

            // Name of the command event sent from the popup menu to OnGUI when user has changed selection
            private const string kMutliMenuChangedMessage = "CustomMutliMenuChanged";

            // The control ID of the popup menu that is currently displayed.
            // Used to pass selection changes back again
            private readonly int m_ControlID;

            // New mask value
            private int m_NewMask;

            // Which view should we send it to.
            private readonly object m_SourceView;
            private MethodInfo m_SendEventMethodInfo;

            public MutliSelectCallbackInfo(int controlID)
            {
                m_ControlID = controlID;
                var types = typeof(Editor).Assembly.GetTypes();
                foreach (var type in types)
                {
                    if (type.Name == "GUIView")
                    {
                        BindingFlags bindingFlags = (BindingFlags.Static | BindingFlags.Public | BindingFlags.NonPublic);
                        m_SourceView = type.GetProperty("current", bindingFlags).GetValue(null);
                        bindingFlags = (BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic);
                        m_SendEventMethodInfo = type.GetMethod("SendEvent", bindingFlags, null, new Type[] { typeof(Event) }, null);
                        break;
                    }
                }
            }

            public static T[] GetSelectedValueForControl<T>(int controlID, T[] canSelectValues, T[] selectedValues, int maxSelectNum, bool isSort)
            {
                var evt = Event.current;

                if (evt.type == EventType.ExecuteCommand && evt.commandName == kMutliMenuChangedMessage)
                {
                    if (m_Instance == null)
                    {
                        Debug.LogError("Mask menu has no instance");
                        return selectedValues;
                    }
                    if (m_Instance.m_ControlID == controlID)
                    {
                        if (m_Instance.m_NewMask == 0)
                        {
                            if (selectedValues.Length > 0)
                            {
                                ArrayUtility.Clear(ref selectedValues);
                                GUI.changed = true;
                            }
                        }
                        else if (m_Instance.m_NewMask == 1)
                        {
                            if (!ArrayUtility.ArrayEquals(canSelectValues, selectedValues))
                            {
                                ArrayUtility.Clear(ref selectedValues);
                                if (maxSelectNum >= 0 && maxSelectNum < canSelectValues.Length)
                                {
                                    for (int i = 0; i < maxSelectNum; i++)
                                    {
                                        ArrayUtility.Add(ref selectedValues, canSelectValues[i]);
                                    }
                                }
                                else
                                {
                                    ArrayUtility.AddRange(ref selectedValues, canSelectValues);
                                }
                                GUI.changed = true;
                            }
                        }
                        else
                        {
                            T value = canSelectValues[m_Instance.m_NewMask - 2];
                            if (ArrayUtility.Contains(selectedValues, value))
                            {
                                ArrayUtility.Remove(ref selectedValues, value);
                                GUI.changed = true;
                            }
                            else
                            {
                                if (maxSelectNum < 0 || selectedValues.Length < maxSelectNum)
                                {
                                    int index = m_Instance.m_NewMask - 2;
                                    if (isSort)
                                    {
                                        for (int i = 0, iMax = selectedValues.Length; i < iMax; i++)
                                        {
                                            if (index < ArrayUtility.FindIndex(canSelectValues, (x) => x.Equals(selectedValues[i])))
                                            {
                                                ArrayUtility.Insert(ref selectedValues, i, value);
                                                break;
                                            }
                                        }
                                    }
                                    if (!ArrayUtility.Contains(selectedValues, value))
                                    {
                                        ArrayUtility.Add(ref selectedValues, value);
                                    }
                                }
                                GUI.changed = true;
                            }
                        }

                        m_Instance = null;
                        evt.Use();
                    }
                }
                return selectedValues;
            }

            public void SetMaskValueDelegate(object userData, string[] options, int selected)
            {
                m_NewMask = selected;

                if (m_SourceView != null)
                    m_SendEventMethodInfo.Invoke(m_SourceView, new object[] { EditorGUIUtility.CommandEvent(kMutliMenuChangedMessage) });
            }
        }

        public static T[] DoMutliSelectField<T>(Rect position, int controlID, T[] canSelectValues, T[] selectedValues, T[] noEnableValues, int maxSelectNum, bool isSort, GUIStyle style)
        {
            selectedValues = MutliSelectCallbackInfo.GetSelectedValueForControl(controlID, canSelectValues, selectedValues, maxSelectNum, isSort);
            var selectedFlags = new List<int>();
            var fullFlagNames = new List<string> { "Nothing", "Everything" };
            List<bool> enables = new List<bool>();
            bool hasNoEnable = false;
            for (var i = 0; i < canSelectValues.Length; i++)
            {
                if (noEnableValues != null && ArrayUtility.Contains(noEnableValues, canSelectValues[i]))
                {
                    enables.Add(false);
                    hasNoEnable = true;
                    selectedFlags.Add(i + 2);
                }
                else
                {
                    enables.Add(true);
                    if ((ArrayUtility.Contains(selectedValues, canSelectValues[i])))
                    {
                        selectedFlags.Add(i + 2);
                    }
                }
                fullFlagNames.Add(canSelectValues[i].ToString());
            }
            enables.Insert(0, (maxSelectNum >= 0 ? false : true));
            enables.Insert(0, !hasNoEnable);

            GUIContent buttonContent = s_MixedValueContent;
            if (!EditorGUI.showMixedValue)
            {
                switch (selectedFlags.Count)
                {
                    case 0:
                        buttonContent = EditorGUIUtility.TrTempContent("Nothing");
                        selectedFlags.Add(0);
                        break;
                    case 1:
                        buttonContent = new GUIContent(fullFlagNames[selectedFlags[0]]);
                        break;
                    default:
                        if (selectedFlags.Count >= canSelectValues.Length)
                        {
                            buttonContent = EditorGUIUtility.TrTempContent("Everything");
                            selectedFlags.Add(1);
                        }
                        else
                            buttonContent = EditorGUIUtility.TrTempContent("Mixed ...");
                        break;
                }
            }
            Event evt = Event.current;
            if (evt.type == EventType.Repaint)
            {
                style.Draw(position, buttonContent, controlID, false);
            }
            else if ((evt.type == EventType.MouseDown && position.Contains(evt.mousePosition)) || MainActionKeyForControl(evt, controlID))
            {
                MutliSelectCallbackInfo.m_Instance = new MutliSelectCallbackInfo(controlID);
                evt.Use();
                displayCustomMenuMethodInfo.Invoke(null, new object[]{position, fullFlagNames.ToArray(),
                // Only show selections if we are not multi-editing
                enables.ToArray(),
                EditorGUI.showMixedValue ? new int[] { } : selectedFlags.ToArray(),
                // optionMaskValues is from the pool so use a clone of the values for the current control
                (EditorUtility.SelectMenuItemFunction)MutliSelectCallbackInfo.m_Instance.SetMaskValueDelegate, selectedValues
                });
                EditorGUIUtility.keyboardControl = controlID;
            }
            return selectedValues;
        }

        public static T[] DoMutliSelectFieldShowValue<T>(Rect position, int controlID, T[] canSelectValues, T[] selectedValues, T[] noEnableValues, int maxSelectNum, bool isSort, GUIStyle style)
        {
            if (canSelectValues == null)
            {
                canSelectValues = new T[0];
            }
            if (selectedValues == null)
            {
                selectedValues = new T[0];
            }
            selectedValues = MutliSelectCallbackInfo.GetSelectedValueForControl(controlID, canSelectValues, selectedValues, maxSelectNum, isSort);
            var selectedFlags = new List<int>();
            var fullFlagNames = new List<string> { "Nothing", "Everything" };
            List<bool> enables = new List<bool>();
            bool hasNoEnable = false;
            for (var i = 0; i < canSelectValues.Length; i++)
            {
                if (noEnableValues != null && ArrayUtility.Contains(noEnableValues, canSelectValues[i]))
                {
                    enables.Add(false);
                    hasNoEnable = true;
                    selectedFlags.Add(i + 2);
                }
                else
                {
                    enables.Add(true);
                    if ((ArrayUtility.Contains(selectedValues, canSelectValues[i])))
                    {
                        selectedFlags.Add(i + 2);
                    }
                }
                fullFlagNames.Add(canSelectValues[i].ToString());
            }
            enables.Insert(0, (maxSelectNum >= 0 ? false : true));
            enables.Insert(0, !hasNoEnable);

            GUIContent buttonContent = s_MixedValueContent;
            if (!EditorGUI.showMixedValue)
            {
                switch (selectedFlags.Count)
                {
                    case 0:
                        buttonContent = EditorGUIUtility.TrTempContent("(Null)");
                        selectedFlags.Add(0);
                        break;
                    case 1:
                        buttonContent = new GUIContent(fullFlagNames[selectedFlags[0]]);
                        break;
                    default:
                        if (selectedFlags.Count >= canSelectValues.Length)
                        {
                            buttonContent = EditorGUIUtility.TrTempContent(string.Join(";", selectedValues));
                            selectedFlags.Add(1);
                        }
                        else
                            buttonContent = EditorGUIUtility.TrTempContent(string.Join(";", selectedValues));
                        break;
                }
            }

            Event evt = Event.current;
            if (evt.type == EventType.Repaint)
            {
                style.Draw(position, buttonContent, controlID, false);
            }
            else if ((evt.type == EventType.MouseDown && position.Contains(evt.mousePosition)) || MainActionKeyForControl(evt, controlID))
            {
                MutliSelectCallbackInfo.m_Instance = new MutliSelectCallbackInfo(controlID);
                evt.Use();
                displayCustomMenuMethodInfo.Invoke(null, new object[]{position, fullFlagNames.ToArray(),
                // Only show selections if we are not multi-editing
                enables.ToArray(),
                EditorGUI.showMixedValue ? new int[] { } : selectedFlags.ToArray(),
                // optionMaskValues is from the pool so use a clone of the values for the current control
                (EditorUtility.SelectMenuItemFunction)MutliSelectCallbackInfo.m_Instance.SetMaskValueDelegate, selectedValues
                });
                EditorGUIUtility.keyboardControl = controlID;
            }
            return selectedValues;
        }



        internal static bool MainActionKeyForControl(UnityEngine.Event evt, int controlId)
        {
            if (EditorGUIUtility.keyboardControl != controlId)
                return false;

            bool anyModifiers = (evt.alt || evt.shift || evt.command || evt.control);

            // Block window maximize (on OSX ML, we need to show the menu as part of the KeyCode event, so we can't do the usual check)
            if (evt.type == EventType.KeyDown && evt.character == ' ' && !anyModifiers)
            {
                evt.Use();
                return false;
            }

            // Space or return is action key
            return evt.type == EventType.KeyDown &&
                (evt.keyCode == KeyCode.Space || evt.keyCode == KeyCode.Return || evt.keyCode == KeyCode.KeypadEnter) &&
                !anyModifiers;
        }

        private static MethodInfo s_DisplayCustomMenuMethodInfo = null;
        private static MethodInfo displayCustomMenuMethodInfo
        {
            get
            {
                if (s_DisplayCustomMenuMethodInfo == null)
                {
                    BindingFlags bindingFlags = (BindingFlags.Static | BindingFlags.Public | BindingFlags.NonPublic);
                    s_DisplayCustomMenuMethodInfo = typeof(EditorUtility).GetMethod("DisplayCustomMenu", bindingFlags, null, new Type[] { typeof(Rect), typeof(string[]), typeof(bool[]), typeof(int[]), typeof(EditorUtility.SelectMenuItemFunction), typeof(object) }, null);
                }
                return s_DisplayCustomMenuMethodInfo;
            }
        }
        private static readonly GUIContent s_MixedValueContent = EditorGUIUtility.TrTextContent("\u2014", "Mixed Values");
    }
}