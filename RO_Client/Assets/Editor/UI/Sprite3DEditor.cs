using UnityEngine;
using UnityEditor;
using System.Collections;
[CustomEditor(typeof(Sprite3D))]
public class Sprite3DEditor : Editor
{
    public override void OnInspectorGUI()
    {
        serializedObject.Update();
        Sprite3D sprite = (Sprite3D)target;
        EditorGUILayout.BeginVertical();

        //sprite.GenerateMesh();

        sprite.useAtlas = EditorGUILayout.Toggle("使用手动生成的Atlas", sprite.useAtlas);

        if(sprite.useAtlas)
        {
            sprite.atlas = (AtlasInfo)EditorGUILayout.ObjectField("Atlas", sprite.atlas, typeof(AtlasInfo), false);
            sprite.spriteName = EditorGUILayout.TextField("SpriteName", sprite.spriteName);
        }
        else
        {
            sprite.texture = (Texture2D)EditorGUILayout.ObjectField("Texture", sprite.texture, typeof(Texture2D), false);
            sprite.autoAtlasTag = EditorGUILayout.TextField("Tag", sprite.autoAtlasTag);
            sprite.compress = EditorGUILayout.Toggle("Compress Texture", sprite.compress);
            sprite.padding = Mathf.Max(EditorGUILayout.IntField("Padding", sprite.padding), 0);
        }

        sprite.alignVertical = (Sprite3D.EnumVertical)EditorGUILayout.EnumPopup("Align Vertical", sprite.alignVertical);
        sprite.alignHoriontal = (Sprite3D.EnumHoriontal)EditorGUILayout.EnumPopup("Align Horiontal", sprite.alignHoriontal);

        sprite.width = EditorGUILayout.FloatField("Width", sprite.width);
        sprite.height = EditorGUILayout.FloatField("Height", sprite.height);

        sprite.color = EditorGUILayout.ColorField("Color", sprite.color);
        sprite.depth = EditorGUILayout.FloatField("Depth", sprite.depth);

        sprite.fillType = (Sprite3D.EnumFillType)EditorGUILayout.EnumPopup("Fill Type", sprite.fillType);
        sprite.PhaseType = (Sprite3D.RadialPhaseType)EditorGUILayout.EnumPopup("Phase Type", sprite.PhaseType);
        sprite.fillAmount = EditorGUILayout.Slider("Slice", sprite.fillAmount, 0, 1);

        if(sprite.fillType == Sprite3D.EnumFillType.Radial360)
        {
            sprite.segments = (uint)Mathf.Max(10, EditorGUILayout.IntField("Segments", (int)sprite.segments));
        }

        EditorGUILayout.EndVertical();
    }
}