/*
 * -------------------------------------------------------------------------------
 * FileName : ContentSizeLimitEditor.cs
 * Created : 2019-02-23 16:19
 * Author : wboy
 * Mail : mrtop@126.com
 * Compiler : Visual Studio Code And Unity3d
 * Description : 
 *
 * -------------------------------------------------------------------------------
 */


using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;

[CustomEditor(typeof(ContentSizeLimit), true)]
[CanEditMultipleObjects]
public class ContentSizeLimitEditor : Editor {

	private SerializedProperty m_MaxWidth;

	private SerializedProperty m_MaxHeight;

	protected virtual void OnEnable()
	{
		m_MaxWidth = base.serializedObject.FindProperty("m_MaxWidth");
		m_MaxHeight = base.serializedObject.FindProperty("m_MaxHeight");
	}

	/// <summary>
	///   <para>See: Editor.OnInspectorGUI.</para>
	/// </summary>
	public override void OnInspectorGUI()
	{
		base.serializedObject.Update();
		LayoutElementField(m_MaxWidth, delegate(RectTransform t)
		{
			Rect rect2 = t.rect;
			return rect2.width;
		});
		LayoutElementField(m_MaxHeight, delegate(RectTransform t)
		{
			Rect rect2 = t.rect;
			return rect2.height;
		});
		base.serializedObject.ApplyModifiedProperties();
	}

	private void LayoutElementField(SerializedProperty property, float defaultValue)
	{
		LayoutElementField(property, (RectTransform _) => defaultValue);
	}

	private void LayoutElementField(SerializedProperty property, Func<RectTransform, float> defaultValue)
	{
		Rect controlRect = EditorGUILayout.GetControlRect();
		GUIContent label = EditorGUI.BeginProperty(controlRect, null, property);
		Rect val = EditorGUI.PrefixLabel(controlRect, label);
		Rect position = val;
		position.width = 16f;
		Rect position2 = val;
		position2.xMin = (position2.xMin + 16f);
		EditorGUI.BeginChangeCheck();
		bool flag = EditorGUI.ToggleLeft(position, GUIContent.none, property.floatValue >= 0f);
		if (EditorGUI.EndChangeCheck())
		{
			property.floatValue = ((!flag) ? -1f : defaultValue((base.target as ContentSizeLimit).transform as RectTransform));
		}
		if (!property.hasMultipleDifferentValues && property.floatValue >= 0f)
		{
			EditorGUIUtility.labelWidth = 4f;
			EditorGUI.BeginChangeCheck();
			float num = EditorGUI.FloatField(position2, new GUIContent(" "), property.floatValue);
			if (EditorGUI.EndChangeCheck())
			{
				property.floatValue = Mathf.Max(0f, num);
			}
			EditorGUIUtility.labelWidth = 0f;
		}
		EditorGUI.EndProperty();
	}
}
