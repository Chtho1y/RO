// This DOES go in the Editor folder (UnityEditor)
using System;
using UnityEditor;
using UnityEngine;

[CustomPropertyDrawer(typeof(FriendlyName))]
public class PropertyTooltipDrawer : PropertyDrawer
{
    private string GetDisplay(SerializedProperty property, FriendlyName attr, GUIContent label )
    {
        if( attr.friendlyName == null || attr.friendlyName.Length <= 0 )
        {
            return label.text;
        }

        return attr.friendlyName;
    }

    public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
    {
        FriendlyName friendlyNameAttr = attribute as FriendlyName;

        if (property.propertyType == SerializedPropertyType.AnimationCurve)
        {
            property.animationCurveValue = EditorGUI.CurveField(position, new GUIContent(GetDisplay(property, friendlyNameAttr, label)), property.animationCurveValue);
        }
        else if (property.propertyType == SerializedPropertyType.Boolean)
        {
            property.boolValue = EditorGUI.Toggle(position, new GUIContent(GetDisplay(property, friendlyNameAttr, label)), property.boolValue);
        }
        else if (property.propertyType == SerializedPropertyType.Bounds)
        {
            property.boundsValue = EditorGUI.BoundsField(position, new GUIContent(GetDisplay(property, friendlyNameAttr, label)), property.boundsValue);
        }
        else if (property.propertyType == SerializedPropertyType.Color)
        {
            property.colorValue = EditorGUI.ColorField(position, new GUIContent(GetDisplay(property, friendlyNameAttr, label)),
                property.colorValue);
        }
        else if (property.propertyType == SerializedPropertyType.Float)
        {
            property.floatValue = EditorGUI.FloatField(position,
                new GUIContent(GetDisplay(property, friendlyNameAttr, label)), property.floatValue);
        }
        else if (property.propertyType == SerializedPropertyType.Integer)
        {
            property.intValue = EditorGUI.IntField(position, new GUIContent(GetDisplay(property, friendlyNameAttr, label)), property.intValue);
        }
        else if (property.propertyType == SerializedPropertyType.Rect)
        {
            property.rectValue = EditorGUI.RectField(position, new GUIContent(GetDisplay(property, friendlyNameAttr, label)),
                property.rectValue);
        }
        else if (property.propertyType == SerializedPropertyType.String)
        {
            property.stringValue = EditorGUI.TextField(position,
                new GUIContent(GetDisplay(property, friendlyNameAttr, label)), property.stringValue);
        }
        else if( property.propertyType == SerializedPropertyType.Vector2 )
        {
            property.vector2Value = EditorGUI.Vector2Field(position,
                new GUIContent(GetDisplay(property, friendlyNameAttr, label)), property.vector2Value);
        }
        else if (property.propertyType == SerializedPropertyType.Vector3)
        {
            property.vector3Value = EditorGUI.Vector3Field(position,
                new GUIContent(GetDisplay(property, friendlyNameAttr, label)), property.vector3Value);
        }
        else if (property.propertyType == SerializedPropertyType.Vector4)
        {
            property.vector4Value = EditorGUI.Vector4Field(position,
                GetDisplay(property, friendlyNameAttr, label), property.vector4Value);
        }        
    }
}