using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using UnityEngine;
using UnityEditor;

namespace Pack
{
    public class PackGUI
    {
        public const float kSingleLineHeight = 24f;
        public const float kIndentPerLevel = 15;
        public static string kIntFieldFormatString = "#######0";

        public static float indent => EditorGUI.indentLevel * kIndentPerLevel;

        public static readonly int s_MutliSelectField = "MutliSelectField".GetHashCode();
        public static readonly int s_DelayedTextFieldHash = "DelayedEditorTextField".GetHashCode();
        public static readonly int s_ButtonGridHash = "ButtonGrid".GetHashCode();
        public static readonly int s_SliderHash = "EditorSlider".GetHashCode();
        private static Stack<Color> s_ChangeGUIBgColorStack = new Stack<Color>();

        public static void BeginChangeGUIBgColor(Color color)
        {
            s_ChangeGUIBgColorStack.Push(GUI.backgroundColor);
            GUI.backgroundColor = color;
        }

        public static void EndChangeGUIBgColor()
        {
            if (s_ChangeGUIBgColorStack.Count > 0)
                GUI.backgroundColor = s_ChangeGUIBgColorStack.Pop();
        }

        public static void EndAllChangeGUIBgColor()
        {
            while (s_ChangeGUIBgColorStack.Count > 0)
            {
                GUI.backgroundColor = s_ChangeGUIBgColorStack.Pop();
            }
        }

        public static void BeginDiffValue()
        {
            PackGUI.BeginChangeGUIBgColor(Color.red);
        }

        public static void EndDiffValue()
        {
            PackGUI.EndChangeGUIBgColor();
        }

        private static Stack<Color> s_ChangeGUIColorStack = new Stack<Color>();

        public static void BeginChangeGUIColor(Color color)
        {
            s_ChangeGUIColorStack.Push(GUI.color);
            GUI.color = color;
        }

        public static void EndChangeGUIColor()
        {
            if (s_ChangeGUIColorStack.Count > 0)
                GUI.color = s_ChangeGUIColorStack.Pop();
        }

        public static void EndAllChangeGUIColor()
        {
            while (s_ChangeGUIColorStack.Count > 0)
            {
                GUI.color = s_ChangeGUIColorStack.Pop();
            }
        }

        private static Stack<bool> s_ChangeEnabledStack = new Stack<bool>();

        public static void BeginChangeEnabled(bool enabled)
        {
            s_ChangeEnabledStack.Push(GUI.enabled);
            GUI.enabled = enabled;
        }

        public static void EndChangeEnabled()
        {
            if (s_ChangeEnabledStack.Count > 0)
                GUI.enabled = s_ChangeEnabledStack.Pop();
        }

        public static void EndAllChangeEnabled()
        {
            while (s_ChangeEnabledStack.Count > 0)
            {
                GUI.enabled = s_ChangeEnabledStack.Pop();
            }
        }

        private static Stack<float> s_ChangeLabelWidthStack = new Stack<float>();

        public static void BeginChangeLabelWidth(float labelWidth)
        {
            s_ChangeLabelWidthStack.Push(EditorGUIUtility.labelWidth);
            EditorGUIUtility.labelWidth = labelWidth;
        }

        public static void EndChangeLabelWidth()
        {
            if (s_ChangeLabelWidthStack.Count > 0)
                EditorGUIUtility.labelWidth = s_ChangeLabelWidthStack.Pop();
        }

        public static void EndAllChangeLabelWidth()
        {
            while (s_ChangeLabelWidthStack.Count > 0)
            {
                EditorGUIUtility.labelWidth = s_ChangeLabelWidthStack.Pop();
            }
        }

        public static void DrawLabelField(string label, string content)
        {
            Rect totalPosition = EditorGUILayout.GetControlRect(true, PackGUI.kSingleLineHeight, PackGUI.styles.label);
            int id = GUIUtility.GetControlID(PackGUI.s_DelayedTextFieldHash, FocusType.Keyboard, totalPosition);
            Rect labelPosition = new Rect(totalPosition.x + PackGUI.indent, totalPosition.y, EditorGUIUtility.labelWidth - PackGUI.indent, PackGUI.kSingleLineHeight);
            Rect fieldPosition = new Rect(totalPosition.x + EditorGUIUtility.labelWidth, totalPosition.y, totalPosition.width - EditorGUIUtility.labelWidth, totalPosition.height);
            EditorGUI.HandlePrefixLabel(totalPosition, labelPosition, EditorGUIUtility.TrTempContent(label), id, PackGUI.styles.label);
            EditorGUI.HandlePrefixLabel(totalPosition, fieldPosition, EditorGUIUtility.TrTempContent(content), id, PackGUI.styles.label);
        }

        public static void DrawDelayedIntField(string label, string tooltip, string srcVal, ref string val, bool abs = false)
        {
            Rect totalPosition = EditorGUILayout.GetControlRect(true, PackGUI.kSingleLineHeight, PackGUI.styles.textField);
            int id = GUIUtility.GetControlID(PackGUI.s_DelayedTextFieldHash, FocusType.Keyboard, totalPosition);
            Rect labelPosition = new Rect(totalPosition.x + PackGUI.indent, totalPosition.y, EditorGUIUtility.labelWidth - PackGUI.indent, PackGUI.kSingleLineHeight);
            Rect fieldPosition = new Rect(totalPosition.x + EditorGUIUtility.labelWidth, totalPosition.y, totalPosition.width - EditorGUIUtility.labelWidth - 100, totalPosition.height);
            Rect resetPosition = new Rect(totalPosition.x + totalPosition.width - 90, totalPosition.y, 80, totalPosition.height);
            EditorGUI.HandlePrefixLabel(totalPosition, labelPosition, EditorGUIUtility.TrTextContent(label, tooltip), id, PackGUI.styles.label);
            bool changed = (srcVal != val);
            if (changed) BeginDiffValue();
            string temp = EditorGUI.DelayedTextField(fieldPosition, GUIContent.none, id, val, PackGUI.styles.textField);
            if (changed) EndDiffValue();
            int newVal;
            if (ExpressionEvaluator.Evaluate(temp, out newVal))
            {
                if (abs && newVal < 0) newVal = 0;
                val = newVal.ToString();
            }
            if (changed)
            {
                if (GUI.Button(resetPosition, EditorGUIUtility.TrTextContent("重置默认", srcVal), PackGUI.styles.miniButton))
                {
                    val = srcVal;
                }
            }
        }

        public static void DrawDelayedIntField(string label, string tooltip, uint srcVal, ref uint val, bool abs = false)
        {
            Rect totalPosition = EditorGUILayout.GetControlRect(true, PackGUI.kSingleLineHeight, PackGUI.styles.textField);
            int id = GUIUtility.GetControlID(PackGUI.s_DelayedTextFieldHash, FocusType.Keyboard, totalPosition);
            Rect labelPosition = new Rect(totalPosition.x + PackGUI.indent, totalPosition.y, EditorGUIUtility.labelWidth - PackGUI.indent, PackGUI.kSingleLineHeight);
            Rect fieldPosition = new Rect(totalPosition.x + EditorGUIUtility.labelWidth, totalPosition.y, totalPosition.width - EditorGUIUtility.labelWidth - 100, totalPosition.height);
            Rect resetPosition = new Rect(totalPosition.x + totalPosition.width - 90, totalPosition.y, 80, totalPosition.height);
            EditorGUI.HandlePrefixLabel(totalPosition, labelPosition, EditorGUIUtility.TrTextContent(label, tooltip), id, PackGUI.styles.label);
            bool changed = (srcVal != val);
            if (changed) BeginDiffValue();
            string temp = EditorGUI.DelayedTextField(fieldPosition, GUIContent.none, id, val.ToString(), PackGUI.styles.textField);
            if (changed) EndDiffValue();
            int newVal;
            if (ExpressionEvaluator.Evaluate(temp, out newVal))
            {
                if (abs && newVal < 0) newVal = 0;
                val = (uint)newVal;
            }
            if (changed)
            {
                if (GUI.Button(resetPosition, EditorGUIUtility.TrTextContent("重置默认", srcVal.ToString()), PackGUI.styles.miniButton))
                {
                    val = srcVal;
                }
            }
        }



        public static void DrawDelayedTextField(string label, string srcContent, ref string content, bool notNull = false)
        {
            DrawDelayedTextField(label, null, srcContent, ref content, notNull);
        }

        public static void DrawDelayedTextField(string label, string tooltip, string srcContent, ref string content, bool notNull = false)
        {
            Rect totalPosition = EditorGUILayout.GetControlRect(true, PackGUI.kSingleLineHeight, PackGUI.styles.textField);
            int id = GUIUtility.GetControlID(PackGUI.s_DelayedTextFieldHash, FocusType.Keyboard, totalPosition);
            Rect labelPosition = new Rect(totalPosition.x + PackGUI.indent, totalPosition.y, EditorGUIUtility.labelWidth - PackGUI.indent, PackGUI.kSingleLineHeight);
            Rect fieldPosition = new Rect(totalPosition.x + EditorGUIUtility.labelWidth, totalPosition.y, totalPosition.width - EditorGUIUtility.labelWidth - 100, totalPosition.height);
            Rect resetPosition = new Rect(totalPosition.x + totalPosition.width - 90, totalPosition.y, 80, totalPosition.height);
            EditorGUI.HandlePrefixLabel(totalPosition, labelPosition, EditorGUIUtility.TrTextContent(label, tooltip), id, PackGUI.styles.label);
            bool changed = (srcContent != content);
            if (changed) BeginDiffValue();
            string temp = EditorGUI.DelayedTextField(fieldPosition, GUIContent.none, id, content, PackGUI.styles.textField);
            if (changed) EndDiffValue();
            if (notNull)
            {
                if (!string.IsNullOrEmpty(temp))
                {
                    content = temp;
                }
            }
            else
            {
                content = temp;
            }
            if (changed)
            {
                if (GUI.Button(resetPosition, EditorGUIUtility.TrTextContent("重置默认", srcContent), PackGUI.styles.miniButton))
                {
                    content = srcContent;
                }
            }
        }

        public static void DrawIntSlider(string label, uint leftValue, uint rightValue, uint srcContent, ref uint content)
        {
            DrawIntSlider(label, null, leftValue, rightValue, srcContent, ref content);
        }

        public static void DrawIntSlider(string label, string tooltip, uint leftValue, uint rightValue, uint srcContent, ref uint content)
        {
            int contentTemp = (int)content;
            DrawIntSlider(label, tooltip, (int)leftValue, (int)rightValue, (int)srcContent, ref contentTemp);
            content = (uint)contentTemp;
        }

        public static void DrawIntSlider(string label, int leftValue, int rightValue, int srcContent, ref int content)
        {
            DrawIntSlider(label, null, leftValue, rightValue, srcContent, ref content);
        }

        public static void DrawIntSlider(string label, string tooltip, int leftValue, int rightValue, int srcContent, ref int content)
        {
            Rect totalPosition = EditorGUILayout.GetControlRect(true, PackGUI.kSingleLineHeight, PackGUI.styles.textField);
            int id = GUIUtility.GetControlID(PackGUI.s_SliderHash, FocusType.Keyboard, totalPosition);
            Rect labelPosition = new Rect(totalPosition.x + PackGUI.indent, totalPosition.y, EditorGUIUtility.labelWidth - PackGUI.indent, PackGUI.kSingleLineHeight);
            Rect fieldPosition = new Rect(totalPosition.x + EditorGUIUtility.labelWidth + PackGUI.indent, totalPosition.y, totalPosition.width - EditorGUIUtility.labelWidth - 100 - PackGUI.indent, totalPosition.height);
            Rect resetPosition = new Rect(totalPosition.x + totalPosition.width - 90, totalPosition.y, 80, totalPosition.height);
            EditorGUI.HandlePrefixLabel(totalPosition, labelPosition, EditorGUIUtility.TrTextContent(label, tooltip), id, PackGUI.styles.label);
            bool changed = (srcContent != content);
            if (changed) BeginDiffValue();
            Rect dragZoneRect = new Rect(fieldPosition.x, fieldPosition.y, fieldPosition.width - 100, fieldPosition.height);
            content = Mathf.RoundToInt((float)doSliderMethodInfo.Invoke(null, new object[] 
            {
                fieldPosition, dragZoneRect, id, content, leftValue, rightValue,
                kIntFieldFormatString, leftValue, rightValue, 1f,
                PackGUI.styles.textField, PackGUI.styles.horizontalSlider, PackGUI.styles.horizontalSliderThumb, null, PackGUI.styles.horizontalSliderThumb
            }));
            if (changed) EndDiffValue();
            if (changed)
            {
                if (GUI.Button(resetPosition, EditorGUIUtility.TrTextContent("重置默认", srcContent.ToString()), PackGUI.styles.miniButton))
                {
                    content = srcContent;
                }
            }
        }
        
        private static MethodInfo s_DoSliderMethodInfo = null;
        private static MethodInfo doSliderMethodInfo
        {
            get
            {
                if (s_DoSliderMethodInfo == null)
                {
                    BindingFlags bindingFlags = (BindingFlags.Static | BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
                    s_DoSliderMethodInfo = typeof(EditorGUI).GetMethod("DoSlider", bindingFlags, null, 
                                        new Type[] { 
                                            typeof(Rect), typeof(Rect), typeof(int),
                                            typeof(float), typeof(float), typeof(float),
                                            typeof(string),
                                            typeof(float), typeof(float), typeof(float),
                                            typeof(GUIStyle), typeof(GUIStyle), typeof(GUIStyle), typeof(Texture2D), typeof(GUIStyle)
                                        }, null);
                }
                return s_DoSliderMethodInfo;
            }
        }

        public static void DrawMutliSelectField<T>(string label, T[] canSelectItems, T[] srcSelectedItems, ref T[] selectedItems, T[] noEnableValues, int maxSelectNum = -1, bool isSort = true)
        {
            DrawMutliSelectField<T>(label, null, canSelectItems, srcSelectedItems, ref selectedItems, noEnableValues, maxSelectNum, isSort);
        }

        public static void DrawMutliSelectField<T>(string label, string tooltip, T[] canSelectItems, T[] srcSelectedItems, ref T[] selectedItems, T[] noEnableValues, int maxSelectNum = -1, bool isSort = true)
        {
            Rect totalPosition = EditorGUILayout.GetControlRect(false, PackGUI.kSingleLineHeight, PackGUI.styles.popup);
            var id = GUIUtility.GetControlID(PackGUI.s_MutliSelectField, FocusType.Keyboard, totalPosition);
            Rect labelPosition = new Rect(totalPosition.x + PackGUI.indent, totalPosition.y, EditorGUIUtility.labelWidth - PackGUI.indent, PackGUI.kSingleLineHeight);
            Rect fieldPosition = new Rect(totalPosition.x + PackGUI.indent + EditorGUIUtility.labelWidth, totalPosition.y, totalPosition.width - EditorGUIUtility.labelWidth - 100 - PackGUI.indent, totalPosition.height);
            Rect resetPosition = new Rect(totalPosition.x + totalPosition.width - 90, totalPosition.y, 80, totalPosition.height);
            EditorGUI.HandlePrefixLabel(totalPosition, labelPosition, EditorGUIUtility.TrTextContent(label, tooltip), id, PackGUI.styles.label);
            bool changed = !ArrayUtility.ArrayEquals(srcSelectedItems, selectedItems);
            if (changed) BeginDiffValue();
            selectedItems = MutliSelectFieldGUI.DoMutliSelectFieldShowValue(fieldPosition, id, canSelectItems, selectedItems, noEnableValues, maxSelectNum, isSort, PackGUI.styles.popup);
            if (changed) EndDiffValue();
            if (changed)
            {
                if (GUI.Button(resetPosition, EditorGUIUtility.TrTextContent("重置默认", string.Join(";", srcSelectedItems)), PackGUI.styles.miniButton))
                {
                    ArrayUtility.Clear(ref selectedItems);
                    ArrayUtility.AddRange(ref selectedItems, srcSelectedItems);
                }
            }
        }

        public static void DrawVersionCodeField(string label, bool shortFormat, VersionCode srcVersionCode, ref VersionCode versionCode)
        {
            Rect totalPosition = EditorGUILayout.GetControlRect(false, PackGUI.kSingleLineHeight, PackGUI.styles.popup);
            totalPosition.height = PackGUI.kSingleLineHeight;
            Rect labelPosition = new Rect(totalPosition.x + PackGUI.indent, totalPosition.y, EditorGUIUtility.labelWidth - PackGUI.indent, PackGUI.kSingleLineHeight);
            EditorGUI.HandlePrefixLabel(totalPosition, labelPosition, EditorGUIUtility.TrTempContent(label + "(" + versionCode.ToString() + ")"), 0, PackGUI.styles.label);
            Rect fieldPosition = new Rect(totalPosition.x + PackGUI.indent + EditorGUIUtility.labelWidth, totalPosition.y, totalPosition.width - EditorGUIUtility.labelWidth - 100 - PackGUI.indent, totalPosition.height);
            Rect offsetPosition = fieldPosition;
            offsetPosition.width = (fieldPosition.width - 30) * 0.25f;
            DrawUintField(offsetPosition, 0, "major", srcVersionCode.major, ref versionCode.major);
            DrawUintField(offsetPosition, 1, "minor", srcVersionCode.minor, ref versionCode.minor);
            DrawUintField(offsetPosition, 2, "release", srcVersionCode.release, ref versionCode.release);
            if (!shortFormat) DrawUintField(offsetPosition, 3, "patch", srcVersionCode.patch, ref versionCode.patch);
            Rect resetPosition = new Rect(totalPosition.x + totalPosition.width - 90, totalPosition.y, 80, totalPosition.height);
            if (srcVersionCode != versionCode)
            {
                if (GUI.Button(resetPosition, EditorGUIUtility.TrTextContent("重置默认", srcVersionCode.ToString(shortFormat)), PackGUI.styles.miniButton))
                {
                    versionCode = srcVersionCode;
                }
            }
        }

        public static void DrawUintField(Rect position, int offsetLine, string label, uint srcValue, ref uint value)
        {
            position.x = position.x + (position.width + 10) * offsetLine;
            Vector2 size = PackGUI.styles.label.CalcSize(EditorGUIUtility.TrTempContent(label));
            float labelWidth = size.x;
            Rect labelPosition = new Rect(position.x, position.y, labelWidth, PackGUI.kSingleLineHeight);
            Rect fieldPosition = new Rect(position.x + labelWidth, position.y, position.width - labelWidth, position.height);
            var id = GUIUtility.GetControlID(PackGUI.s_MutliSelectField, FocusType.Keyboard, position);
            EditorGUI.HandlePrefixLabel(position, labelPosition, EditorGUIUtility.TrTempContent(label), id, PackGUI.styles.label);
            bool changed = srcValue != value;
            if (changed) PackGUI.BeginDiffValue();
            int intVal = EditorGUI.IntField(fieldPosition, (int)value, PackGUI.styles.numberField);
            if (intVal < 0) intVal = 0;
            value = (uint)intVal;
            if (changed) PackGUI.EndDiffValue();
        }

        public static void DrawSelectFolderField(string label, string rootPath, string srcPath, ref string curPath)
        {
            Rect totalPosition = EditorGUILayout.GetControlRect(true, PackGUI.kSingleLineHeight, PackGUI.styles.textField);
            int id = GUIUtility.GetControlID(PackGUI.s_DelayedTextFieldHash, FocusType.Keyboard, totalPosition);
            Rect labelPosition = new Rect(totalPosition.x + PackGUI.indent, totalPosition.y, EditorGUIUtility.labelWidth - PackGUI.indent, PackGUI.kSingleLineHeight);
            Rect fieldPosition = new Rect(totalPosition.x + PackGUI.indent + EditorGUIUtility.labelWidth, totalPosition.y, totalPosition.width - EditorGUIUtility.labelWidth - 220 - PackGUI.indent, totalPosition.height);
            Rect openPosition = new Rect(totalPosition.x + totalPosition.width - 210, totalPosition.y, 110, totalPosition.height);
            Rect resetPosition = new Rect(totalPosition.x + totalPosition.width - 90, totalPosition.y, 80, totalPosition.height);
            EditorGUI.HandlePrefixLabel(totalPosition, labelPosition, EditorGUIUtility.TrTempContent(label), id, PackGUI.styles.label);
            bool changed = srcPath != curPath;
            if (changed) BeginDiffValue();
            if (GUI.Button(fieldPosition, curPath, PackGUI.styles.miniButton))
            {
                rootPath = Path.GetFullPath(rootPath);
                rootPath = rootPath.Replace('\\', '/');
                if (!Directory.Exists(rootPath))
                {
                    Directory.CreateDirectory(rootPath);
                }
                string curAbsPath = Path.Combine(rootPath, curPath);
                curAbsPath = Path.GetFullPath(rootPath);
                curAbsPath = curAbsPath.Replace('\\', '/');
                if (!Directory.Exists(curAbsPath))
                {
                    Directory.CreateDirectory(curAbsPath);
                }
                string tempPath = EditorUtility.OpenFolderPanel("选择一个文件夹", rootPath, curPath);
                if (!string.IsNullOrEmpty(tempPath))
                {
                    if (tempPath.StartsWith(rootPath))
                    {
                        curPath = tempPath.Substring(rootPath.Length, tempPath.Length - rootPath.Length);
                    }
                }
            }
            if (changed) EndDiffValue();
            PackGUI.BeginChangeEnabled(true);
            if (GUI.Button(openPosition, EditorGUIUtility.TrTextContent("打开文件夹"), PackGUI.styles.miniButton))
            {
                string curAbsPath = Path.Combine(rootPath, curPath);
                EditorUtility.OpenWithDefaultApp(curAbsPath);
            }
            PackGUI.EndChangeEnabled();
            if (changed)
            {
                if (GUI.Button(resetPosition, EditorGUIUtility.TrTextContent("重置默认", srcPath), PackGUI.styles.miniButton))
                {
                    curPath = srcPath;
                }
            }
        }

        public static void DrawSelectFileFieldWithFilters(string label, string directory, string[] filters, string srcFileName, ref string curFileName)
        {
            Rect totalPosition = EditorGUILayout.GetControlRect(true, PackGUI.kSingleLineHeight, PackGUI.styles.textField);
            int id = GUIUtility.GetControlID(PackGUI.s_DelayedTextFieldHash, FocusType.Keyboard, totalPosition);
            Rect labelPosition = new Rect(totalPosition.x + PackGUI.indent, totalPosition.y, EditorGUIUtility.labelWidth - PackGUI.indent, PackGUI.kSingleLineHeight);
            Rect fieldPosition = new Rect(totalPosition.x + PackGUI.indent + EditorGUIUtility.labelWidth, totalPosition.y, totalPosition.width - EditorGUIUtility.labelWidth - 220 - PackGUI.indent, totalPosition.height);
            Rect openPosition = new Rect(totalPosition.x + totalPosition.width - 210, totalPosition.y, 110, totalPosition.height);
            Rect resetPosition = new Rect(totalPosition.x + totalPosition.width - 90, totalPosition.y, 80, totalPosition.height);
            EditorGUI.HandlePrefixLabel(totalPosition, labelPosition, EditorGUIUtility.TrTempContent(label), id, PackGUI.styles.label);
            bool changed = srcFileName != curFileName;
            if (changed) PackGUI.BeginDiffValue();
            if (GUI.Button(fieldPosition, curFileName, PackGUI.styles.miniButton))
            {
                directory = Path.GetFullPath(directory);
                directory = directory.Replace('\\', '/');
                if (!Directory.Exists(directory))
                {
                    Directory.CreateDirectory(directory);
                }
                string tempPath = EditorUtility.OpenFilePanelWithFilters("选择一个文件", directory, filters);
                if (!string.IsNullOrEmpty(tempPath))
                {
                    if (tempPath.StartsWith(directory))
                    {
                        curFileName = tempPath.Substring(directory.Length, tempPath.Length - directory.Length);
                    }
                }
            }
            if (changed) PackGUI.EndDiffValue();
            PackGUI.BeginChangeEnabled(true);
            if (GUI.Button(openPosition, EditorGUIUtility.TrTextContent("打开文件"), PackGUI.styles.miniButton))
            {
                string curAbsPath = Path.Combine(directory, curFileName);
                EditorUtility.OpenWithDefaultApp(curAbsPath);
            }
            PackGUI.EndChangeEnabled();
            if (changed)
            {
                if (GUI.Button(resetPosition, EditorGUIUtility.TrTextContent("重置默认", srcFileName), PackGUI.styles.miniButton))
                {
                    curFileName = srcFileName;
                }
            }
        }

        public static void DrawToggleField(string label, bool srcContent, ref bool content)
        {
            DrawToggleField(label, null, srcContent, ref content);
        }

        public static void DrawToggleField(string label, string tooltip, bool srcContent, ref bool content)
        {
            Rect totalPosition = EditorGUILayout.GetControlRect(true, PackGUI.kSingleLineHeight, PackGUI.styles.textField);
            int id = GUIUtility.GetControlID(PackGUI.s_DelayedTextFieldHash, FocusType.Keyboard, totalPosition);
            Rect labelPosition = new Rect(totalPosition.x + PackGUI.indent, totalPosition.y, EditorGUIUtility.labelWidth - PackGUI.indent, PackGUI.kSingleLineHeight);
            Rect fieldPosition = new Rect(totalPosition.x + EditorGUIUtility.labelWidth, totalPosition.y, totalPosition.width - EditorGUIUtility.labelWidth - 100, totalPosition.height);
            Rect resetPosition = new Rect(totalPosition.x + totalPosition.width - 90, totalPosition.y, 80, totalPosition.height);
            EditorGUI.HandlePrefixLabel(totalPosition, labelPosition, EditorGUIUtility.TrTextContent(label, tooltip), id, PackGUI.styles.label);
            bool changed = (srcContent != content);
            if (changed) BeginDiffValue();
            content = EditorGUI.Toggle(fieldPosition, content, PackGUI.styles.toggle);
            if (changed) EndDiffValue();
            if (changed)
            {
                if (GUI.Button(resetPosition, EditorGUIUtility.TrTextContent("重置默认", srcContent.ToString()), PackGUI.styles.miniButton))
                {
                    content = srcContent;
                }
            }
        }





        private static Styles s_Styles;
        public static Styles styles
        {
            get
            {
                if (s_Styles == null)
                {
                    s_Styles = new Styles();
                }
                return s_Styles;
            }
        }

        public class Styles
        {
            public GUIStyle label;
            public GUIStyle miniLabel;
            public GUIStyle largeLabel;
            public GUIStyle boldLabel;
            public GUIStyle miniBoldLabel;
            public GUIStyle textField;
            public GUIStyle miniButton;
            public GUIStyle popup;
            public GUIStyle toolbar;
            public GUIStyle toolbarButton;
            public GUIStyle miniButtonLeft;
            public GUIStyle miniButtonMid;
            public GUIStyle miniButtonRight;
            public GUIStyle helpBox;
            public GUIStyle numberField;
            public GUIStyle box;
            public GUIStyle toggle;
            public GUIStyle horizontalSlider;
            public GUIStyle horizontalSliderThumb;

            

            public GUIStyle reorderableListHeadBg;

            public Styles()
            {
                Font font = Font.CreateDynamicFontFromOSFont(new string[] { "Fira Code Retina", "华文楷体", }, 16);

                label = UnifyGUIStyle(EditorStyles.label, font);
                miniLabel = UnifyGUIStyle(EditorStyles.miniLabel, font);
                largeLabel = UnifyGUIStyle(EditorStyles.largeLabel, font);
                boldLabel = UnifyGUIStyle(EditorStyles.boldLabel, font);
                boldLabel.fontStyle = FontStyle.Bold;
                miniBoldLabel = UnifyGUIStyle(EditorStyles.miniBoldLabel, font);
                miniBoldLabel.fontStyle = FontStyle.Bold;
                textField = UnifyGUIStyle(EditorStyles.textField, font);
                miniButton = UnifyGUIStyle(EditorStyles.miniButton, font);
                popup = UnifyGUIStyle(EditorStyles.popup, font);
                toolbar = UnifyGUIStyle(EditorStyles.toolbar, font);
                toolbarButton = UnifyGUIStyle(EditorStyles.toolbarButton, font);
                miniButtonLeft = UnifyGUIStyle(EditorStyles.miniButtonLeft, font);
                miniButtonMid = UnifyGUIStyle(EditorStyles.miniButtonMid, font);
                miniButtonRight = UnifyGUIStyle(EditorStyles.miniButtonRight, font);
                helpBox = UnifyGUIStyle(EditorStyles.helpBox, font);
                helpBox.fixedHeight = 42;
                numberField = UnifyGUIStyle(EditorStyles.numberField, font);
                box = new GUIStyle(GUI.skin.box);
                toggle = new GUIStyle(EditorStyles.toggle);
                horizontalSlider = new GUIStyle(GUI.skin.horizontalSlider);
                // horizontalSlider.fixedHeight = 14;
                horizontalSliderThumb = new GUIStyle(GUI.skin.horizontalSliderThumb);
                // horizontalSliderThumb.fixedWidth = 14;
                // horizontalSliderThumb.fixedHeight = 14;

                reorderableListHeadBg = new GUIStyle("RL Header");
                reorderableListHeadBg.fixedHeight = 28;
                reorderableListHeadBg.fontSize = 16;
                if (font) reorderableListHeadBg.font = font;
            }

            private GUIStyle UnifyGUIStyle(GUIStyle srcGUIStyle, Font font)
            {
                GUIStyle gUIStyle = new GUIStyle(srcGUIStyle);
                gUIStyle.fixedHeight = 22;
                gUIStyle.fontSize = 16;
                if (font) gUIStyle.font = font;
                return gUIStyle;
            }
        }
    }
}