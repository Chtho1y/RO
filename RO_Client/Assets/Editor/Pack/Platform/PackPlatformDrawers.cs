using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;


namespace Pack
{
    [CustomPropertyDrawer(typeof(PackPlatformBase))]
    public class PackPlatformBaseDrawers : PropertyDrawer
    {


        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            position = DrawChildPropertyField(position, property, "channelUniqueName", "渠道唯一名字", "唯一名字（只能使用数字，英文，英文符号）");
            position = DrawChildPropertyField(position, property, "channelName", "渠道名字");
            position = DrawChildPropertyField(position, property, "appName", "游戏名");
            position = DrawChildPropertyField(position, property, "buildTarget", "目标编译平台");
            position = DrawChildPropertyField(position, property, "bundleId");

            // position = DrawChildPropertyField(position, property, "defineSymbols", "编译宏");
            // position = DrawChildPropertyField(position, property, "platformName", "目标包名");
            // position = DrawChildPropertyField(position, property, "platformName", "目标包名");
            // position = DrawChildPropertyField(position, property, "platformName", "目标包名");
        }

        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            return base.GetPropertyHeight(property, label);
        }

        protected Rect DrawDefineSymbolsPropertyField(Rect position, SerializedProperty property, string name, string title = "", string tooltip = "")
        {
            SerializedProperty platformName = property.FindPropertyRelative(name);
            if (platformName != null)
            {
                // EditorGUI.BeginProperty(position, EditorGUIUtility.TrTextContent((string.IsNullOrEmpty(title) ? name : title), tooltip), platformName);
                // EditorGUI.BeginChangeCheck();
                // if (EditorGUI.EndChangeCheck())
                //     m_Property.constantMax.floatValue = newConstantMax;
                // EditorGUI.PropertyField(position, platformName, EditorGUIUtility.TrTextContent((string.IsNullOrEmpty(title) ? name : title), tooltip));
                position = OffsetLineHeight(position);
            }
            return position;
        }

        protected Rect DrawChildPropertyField(Rect position, SerializedProperty property, string name, string title = "", string tooltip = "")
        {
            SerializedProperty platformName = property.FindPropertyRelative(name);
            if (platformName != null)
            {
                EditorGUI.PropertyField(position, platformName, EditorGUIUtility.TrTextContent((string.IsNullOrEmpty(title) ? name : title), tooltip));
                position = OffsetLineHeight(position);
            }
            return position;
        }

        protected Rect OffsetLineHeight(Rect position)
        {
            position.y += 16;
            position.height = position.height - 16;
            return position;
        }
    }

    [CustomPropertyDrawer(typeof(PackPlatformPC))]
    public class PackPlatformPCDrawers : PackPlatformBaseDrawers
    {
    }

    [CustomPropertyDrawer(typeof(PackPlatformAndroid))]
    public class PackPlatformAndroidDrawers : PackPlatformBaseDrawers
    {
    }

    [CustomPropertyDrawer(typeof(PackPlatformPC))]
    public class PackPlatformiOSDrawers : PackPlatformBaseDrawers
    {
    }
}