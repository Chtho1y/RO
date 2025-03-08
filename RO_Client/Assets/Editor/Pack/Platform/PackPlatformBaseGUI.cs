using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEditor;

namespace Pack
{
    public partial class PackPlatformBase
    {
        private FileReorderableList m_SplashScreenReorderableList;

        private static int[] s_ObscureOffsetValues = new int[]
        {
            0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
        };

        public void DrawGUI(bool editable, PackPlatformBase sourcePackPlatform)
        {
            PackGUI.BeginChangeLabelWidth(250);
            EditorGUI.BeginDisabledGroup(!editable);
            EditorGUILayout.BeginVertical();
            EditorGUILayout.BeginVertical(PackGUI.styles.box);
            EditorGUILayout.LabelField("基本信息", PackGUI.styles.boldLabel);
            EditorGUI.indentLevel += 1;
            EditorGUILayout.Space();
            PackGUI.DrawDelayedTextField("渠道名字", sourcePackPlatform.channelName, ref channelName, true);
            PackGUI.DrawDelayedTextField("游戏名字", sourcePackPlatform.appName, ref appName, true);
            PackGUI.DrawDelayedTextField("发布名字", sourcePackPlatform.distributeName, ref distributeName, true);
            PackGUI.DrawDelayedIntField("唯一名字(工具打包时使用名字)", "目前使用规则\n目标平台 * 10000000 + 渠道 * 1000 + 对应版本", sourcePackPlatform.channelUniqueId, ref channelUniqueId, true);
            PackGUI.DrawDelayedTextField("游戏bundleId", sourcePackPlatform.bundleId, ref bundleId, true);
            PackGUI.DrawVersionCodeField("App版本号", false, sourcePackPlatform.gameVersionCode, ref gameVersionCode);
            PackGUI.DrawVersionCodeField("Res版本号", false, sourcePackPlatform.resVersionCode, ref resVersionCode);
            PackGUI.DrawSelectFolderField("AppIcon的路径", Application.dataPath + PackConstant.AppIconSourcePath, sourcePackPlatform.iconRelativePath, ref iconRelativePath);
            EditorGUI.indentLevel -= 1;
            EditorGUILayout.EndVertical();

            if (HasPlatformGameGUI())
            {
                EditorGUILayout.Space();
                EditorGUILayout.BeginVertical(PackGUI.styles.box);
                EditorGUILayout.LabelField("游戏信息", PackGUI.styles.boldLabel);
                EditorGUI.indentLevel += 1;
                DrawPlatformGameGUI(editable, sourcePackPlatform);
                EditorGUI.indentLevel -= 1;
                EditorGUILayout.EndVertical();
            }

            if (HasPlatformSpecialGUI())
            {
                EditorGUILayout.Space();
                EditorGUILayout.BeginVertical(PackGUI.styles.box);
                EditorGUILayout.LabelField("其它信息", PackGUI.styles.boldLabel);
                EditorGUI.indentLevel += 1;
                DrawPlatformSpecialGUI(editable, sourcePackPlatform);
                EditorGUI.indentLevel -= 1;
                EditorGUILayout.EndVertical();
            }
            EditorGUILayout.Space();
            EditorGUILayout.BeginVertical(PackGUI.styles.box);
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("打包后的App路径", PackGUI.styles.boldLabel);
            PackGUI.BeginChangeEnabled(true);
            if (GUILayout.Button("打开文件夹", PackGUI.styles.miniButton, GUILayout.Width(110)))
            {
                string curAbsPath = GetBuildOutputPath();
                if (File.Exists(curAbsPath))
                {
                    EditorUtility.OpenWithDefaultApp(Path.GetDirectoryName(curAbsPath));
                }
                else if (Directory.Exists(curAbsPath))
                {
                    EditorUtility.OpenWithDefaultApp(curAbsPath);
                }
                else
                {
                    EditorUtility.DisplayDialog("提示", "还未编译过，无法找到该文件或文件夹", "好的");
                }
            }
            PackGUI.EndChangeEnabled();
            EditorGUILayout.EndHorizontal();
            EditorGUI.indentLevel += 1;
            EditorGUILayout.LabelField(GetBuildOutputPath(), PackGUI.styles.label);
            EditorGUILayout.Space();
            EditorGUI.indentLevel -= 1;
            EditorGUILayout.EndVertical();
            EditorGUILayout.Space();
            EditorGUILayout.EndVertical();
            PackGUI.EndAllChangeGUIBgColor();
            EditorGUI.EndDisabledGroup();
            PackGUI.EndAllChangeLabelWidth();
        }

        public virtual void DrawVersionCodeGUI(bool editable, PackPlatformBase sourcePackPlatform)
        {
            PackGUI.BeginChangeLabelWidth(220);
            PackGUI.BeginChangeEnabled(editable);
            EditorGUILayout.BeginVertical(PackGUI.styles.box);
            EditorGUILayout.LabelField(GetChannelUniqueName() + "      " + channelUniqueId, PackGUI.styles.boldLabel);
            EditorGUILayout.Space();
            EditorGUI.indentLevel += 1;
            PackGUI.DrawVersionCodeField("App版本号", false, sourcePackPlatform.gameVersionCode, ref gameVersionCode);
            PackGUI.DrawVersionCodeField("Res版本号", false, sourcePackPlatform.resVersionCode, ref resVersionCode);
            EditorGUI.indentLevel -= 1;
            EditorGUILayout.EndVertical();
            PackGUI.EndChangeEnabled();
            PackGUI.EndChangeLabelWidth();
        }

        protected virtual bool HasPlatformGameGUI()
        {
            return true;
        }

        protected virtual void DrawPlatformGameGUI(bool editable, PackPlatformBase sourcePackPlatform)
        {

        }

        protected virtual bool HasPlatformSpecialGUI()
        {
            return false;
        }

        protected virtual void DrawPlatformSpecialGUI(bool editable, PackPlatformBase sourcePackPlatform)
        {

        }


    }
}