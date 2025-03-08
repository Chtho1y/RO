using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

namespace Pack
{
    public partial class PackPlatformWeiDuan
    {
        protected override void DrawPlatformGameGUI(bool editable, PackPlatformBase sourcePackPlatform)
        {
            base.DrawPlatformGameGUI(editable, sourcePackPlatform);
            EditorGUI.indentLevel += 1;
            EditorGUILayout.Space();
            EditorGUILayout.BeginVertical(PackGUI.styles.box);
            PackGUI.BeginChangeGUIColor(Color.yellow);
            EditorGUILayout.LabelField("该平台包不能在Unity中编译，请使用编译工具 ！！!", PackGUI.styles.boldLabel);
            PackGUI.EndChangeGUIColor();
            EditorGUILayout.Space();
            EditorGUILayout.EndVertical();
            EditorGUI.indentLevel -= 1;
        }
    }
}