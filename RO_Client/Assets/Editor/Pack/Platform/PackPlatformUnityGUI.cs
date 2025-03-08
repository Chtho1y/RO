using System.IO;
using UnityEngine;
using UnityEditor;

namespace Pack
{
    public partial class PackPlatformUnity
    {
        private FileReorderableList m_SplashScreenReorderableList;

        private static int[] s_ObscureOffsetValues = new int[]
        {
            0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
        };

        protected override void DrawPlatformGameGUI(bool editable, PackPlatformBase sourcePackPlatform)
        {
            base.DrawPlatformGameGUI(editable, sourcePackPlatform);
            PackPlatformUnity sourcePackPlatformUnity = sourcePackPlatform as PackPlatformUnity;
            PackGUI.DrawMutliSelectField("编译宏", PackConstant.AllDefineSymbols, sourcePackPlatformUnity.defineSymbols, ref defineSymbols, PackConstant.NeedFulDefineSymbols, -1);
            if (m_SplashScreenReorderableList == null)
            {
                m_SplashScreenReorderableList = new FileReorderableList("从上到下依次显示", splashScreenRelativeFiles, sourcePackPlatformUnity.splashScreenRelativeFiles, null, Application.dataPath + PackConstant.PluginAndroidSrcPath, ".png");
            }
            else
            {
                m_SplashScreenReorderableList.SetParams(splashScreenRelativeFiles, sourcePackPlatformUnity.splashScreenRelativeFiles, null, Application.dataPath + PackConstant.PluginAndroidSrcPath, ".png");
            }
            float height = m_SplashScreenReorderableList.GetHeight();
            Rect totalPosition = EditorGUILayout.GetControlRect(true, height, PackGUI.styles.label);
            Rect labelPosition = new Rect(totalPosition.x + PackGUI.indent, totalPosition.y, EditorGUIUtility.labelWidth - PackGUI.indent, PackGUI.kSingleLineHeight);
            int id = GUIUtility.GetControlID(PackGUI.s_DelayedTextFieldHash, FocusType.Keyboard, labelPosition);
            EditorGUI.HandlePrefixLabel(totalPosition, labelPosition, EditorGUIUtility.TrTextContent("Android目录替换", PackConstant.PluginAndroidDestPath), id, PackGUI.styles.label);
            Rect fieldPosition = new Rect(totalPosition.x + PackGUI.indent + EditorGUIUtility.labelWidth, totalPosition.y, totalPosition.width - PackGUI.indent - EditorGUIUtility.labelWidth - 100, height);
            Rect resetPosition = new Rect(totalPosition.x + totalPosition.width - 90, totalPosition.y, 80, PackGUI.kSingleLineHeight);
            m_SplashScreenReorderableList.DoList(fieldPosition);
            if (!ArrayUtility.ArrayEquals(sourcePackPlatformUnity.splashScreenRelativeFiles.ToArray(), splashScreenRelativeFiles.ToArray()))
            {
                if (GUI.Button(resetPosition, EditorGUIUtility.TrTextContent("重置默认", string.Join(";", sourcePackPlatformUnity.splashScreenRelativeFiles)), PackGUI.styles.miniButton))
                {
                    splashScreenRelativeFiles.Clear();
                    splashScreenRelativeFiles.AddRange(sourcePackPlatformUnity.splashScreenRelativeFiles);
                }
            }
            PackGUI.DrawSelectFileFieldWithFilters("Logo的路径", Application.dataPath + PackConstant.LogoSourcePath, PackConstant.PngFilters, sourcePackPlatformUnity.logo1RelativePath, ref logo1RelativePath);
            PackGUI.DrawSelectFolderField("Login的路径", Application.dataPath + PackConstant.LoginSourcePath, sourcePackPlatformUnity.loginRelativePath, ref loginRelativePath);
            PackGUI.DrawSelectFolderField("修改游戏资源的路径", Application.dataPath + PackConstant.GameAssetsSourcePath, sourcePackPlatformUnity.gameAssetsPath, ref gameAssetsPath);
            PackGUI.DrawDelayedTextField("sdk验证Url", sourcePackPlatformUnity.sdkVerifyUrl, ref sdkVerifyUrl, true);
            PackGUI.DrawDelayedTextField("服务器列Url", sourcePackPlatformUnity.serverListUrl, ref serverListUrl, true);
            PackGUI.DrawDelayedTextField("公告Url", sourcePackPlatformUnity.notifyUrl, ref notifyUrl, true);
            PackGUI.DrawDelayedTextField("特殊信息Url(logo显示状态)", sourcePackPlatformUnity.specialInfoUrl, ref specialInfoUrl, true);
            PackGUI.DrawDelayedTextField("专属客服信息Url", sourcePackPlatformUnity.customerServiceInfoUrl, ref customerServiceInfoUrl, true);
            PackGUI.DrawToggleField("特殊功能屏蔽", "对应功能\n兑换码", sourcePackPlatformUnity.specialFuncShield, ref specialFuncShield);

            EditorGUILayout.Space();
            EditorGUILayout.BeginVertical(PackGUI.styles.box);
            EditorGUILayout.LabelField("资源混淆", PackGUI.styles.boldLabel);
            EditorGUI.indentLevel += 1;
            EditorGUILayout.Space();
            PackGUI.DrawDelayedTextField("资源混淆key", "不混淆，则值设置为空内容", sourcePackPlatformUnity.obscureKey, ref obscureKey);
            PackGUI.DrawIntSlider("资源默认混淆长度", "避免填充数据过多\n导致最终文件过大\n目前设定0 ~ 0xFFF", 0, 0xFFF, sourcePackPlatformUnity.obscureOffsetMin, ref obscureOffsetMin);
            PackGUI.DrawMutliSelectField("资源混淆长度计算取MD5位值", "避免填充数据过多\n导致最终文件过大\n目前设定最多选3位", s_ObscureOffsetValues, sourcePackPlatformUnity.obscureOffsetValues, ref obscureOffsetValues, null, 3, false);
            EditorGUI.indentLevel -= 1;
            EditorGUILayout.EndVertical();
        }
    }
}
