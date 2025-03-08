using System;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEditor;
using UnityEditorInternal;

namespace Pack
{
    public class DirectoryReorderableList
    {
        private ReorderableList m_ReorderableList;
        private List<string> m_Paths;
        private List<string> m_SrcPaths;
        private List<string> m_NeedFulPaths;
        private string m_RootPath;

        public DirectoryReorderableList(List<string> paths, List<string> srcPaths, List<string> needfulPaths, string rootPath)
        {
            SetParams(paths, srcPaths, needfulPaths, rootPath);
        }


        public void SetParams(List<string> paths, List<string> srcPaths, List<string> needfulPaths, string rootPath)
        {
            m_Paths = paths;
            m_SrcPaths = srcPaths;
            m_NeedFulPaths = needfulPaths;
            m_RootPath = rootPath;

            if (m_ReorderableList == null)
            {
                m_ReorderableList = new ReorderableList(m_Paths, typeof(string), true, true, true, true);
                m_ReorderableList.drawHeaderCallback = OnDrawHeaderCallback;
                m_ReorderableList.drawElementCallback = OnDrawElementCallback;
                m_ReorderableList.drawNoneElementCallback = OnDrawNoneElementCallback;
                m_ReorderableList.onCanAddCallback = OnCanAddCallback;
                m_ReorderableList.onAddDropdownCallback = OnAddDropdownCallback;
                m_ReorderableList.onCanRemoveCallback = OnCanRemoveCallback;
                m_ReorderableList.onRemoveCallback = OnRemoveCallback;
                m_ReorderableList.onChangedCallback = OnChangedCallback;
                m_ReorderableList.headerHeight = PackGUI.styles.reorderableListHeadBg.fixedHeight;
                m_ReorderableList.elementHeight = 24;
            }
            else
            {
                m_ReorderableList.list = paths;
            }
        }

        public float GetHeight()
        {
            return m_ReorderableList.GetHeight();
        }

        public void DoList(Rect rect)
        {
            m_ReorderableList.DoList(rect);
        }


        private void OnDrawHeaderCallback(Rect rect)
        {
            if (Event.current.type == EventType.Repaint)
            {
                Rect headerRect = rect;
                headerRect.y -= 1;
                headerRect.height += 2;
                headerRect.xMax += 6;
                headerRect.xMin -= 6;
                PackGUI.styles.reorderableListHeadBg.Draw(headerRect, false, false, false, false);
            }
            Rect labelRect = rect;
            labelRect.y += (labelRect.height - PackGUI.styles.label.fixedHeight) * 0.5f;
            EditorGUI.LabelField(labelRect, EditorGUIUtility.TrTempContent("从上到下依次覆盖"), PackGUI.styles.label);

            Vector2 size = PackGUI.styles.miniButton.CalcSize(EditorGUIUtility.TrTempContent("打开文件夹"));
            Rect btnRect = rect;
            btnRect.x += btnRect.width - size.x;
            btnRect.width = size.x;
            btnRect.y += (btnRect.height - size.y) * 0.5f;
            PackGUI.BeginChangeEnabled(true);
            if (GUI.Button(btnRect, "打开文件夹", PackGUI.styles.miniButton))
            {
                EditorUtility.OpenWithDefaultApp(Path.GetFullPath(m_RootPath));
            }
            PackGUI.EndChangeEnabled();
        }

        private void OnDrawNoneElementCallback(Rect rect)
        {
            EditorGUI.LabelField(rect, "列表是空的", PackGUI.styles.label);
        }

        private void OnDrawElementCallback(Rect rect, int index, bool isActive, bool isFocused)
        {
            Vector2 size = PackGUI.styles.miniButton.CalcSize(EditorGUIUtility.TrTempContent("打开文件夹"));
            Rect labelRect = rect;
            labelRect.width = labelRect.width - size.x;
            bool changed = true;
            if (m_SrcPaths != null)
            {
                if (index < m_SrcPaths.Count)
                {
                    changed = (m_SrcPaths[index] != m_Paths[index]);
                }
            }
            if (changed) PackGUI.BeginChangeGUIColor(Color.red);
            EditorGUI.LabelField(labelRect, m_Paths[index], PackGUI.styles.label);
            if (changed) PackGUI.EndChangeGUIColor();
            Rect btnRect = rect;
            btnRect.x += btnRect.width - size.x;
            btnRect.width = size.x;
            PackGUI.BeginChangeEnabled(true);
            if (GUI.Button(btnRect, "打开文件夹", PackGUI.styles.miniButton))
            {
                EditorUtility.OpenWithDefaultApp(Path.GetFullPath(m_RootPath + m_Paths[index]));
            }
            PackGUI.EndChangeEnabled();
        }

        private bool OnCanAddCallback(ReorderableList list)
        {
            List<string> lhs = GetRelativePath(m_RootPath);
            return !ArrayUtility.ArrayEquals(lhs.ToArray(), m_Paths.ToArray());
        }

        private bool OnCanRemoveCallback(ReorderableList list)
        {
            return m_NeedFulPaths == null || !m_NeedFulPaths.Contains(m_Paths[list.index]);
        }

        private void OnRemoveCallback(ReorderableList list)
        {
            m_Paths.RemoveAt(list.index);
        }

        private void OnAddDropdownCallback(Rect buttonRect, ReorderableList list)
        {
            List<string> ls = GetRelativePath(m_RootPath);
            GenericMenu menu = new GenericMenu();
            for (int i = 0, iMax = ls.Count; i < iMax; i++)
            {
                if (m_Paths.Contains(ls[i]))
                {
                    menu.AddDisabledItem(EditorGUIUtility.TrTextContent(ls[i]), true);
                }
                else
                {
                    menu.AddItem(EditorGUIUtility.TrTextContent(ls[i]), false, AddPluginsAndroid, ls[i]);
                }
            }
            menu.DropDown(buttonRect);
        }

        private void AddPluginsAndroid(object value)
        {
            m_Paths.Add((string)value);
        }

        private void OnChangedCallback(ReorderableList list)
        {
            if (m_NeedFulPaths == null) return;
            for (int i = m_NeedFulPaths.Count - 1; i >= 0; i--)
            {
                m_Paths.Remove(m_NeedFulPaths[i]);
                m_Paths.Insert(0, m_NeedFulPaths[i]);
            }
        }

        private List<string> GetRelativePath(string rootPath)
        {
            rootPath = Path.GetFullPath(rootPath);
            List<string> ls = new List<string>();
            foreach (var item in Directory.GetDirectories(rootPath))
            {
                string path = Path.GetFullPath(item);
                path = path.Substring(rootPath.Length, path.Length - rootPath.Length);
                path = path.Replace('\\', '/');
                ls.Add(path);
            }
            return ls;
        }
    }
}