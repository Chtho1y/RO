using System;
using System.Linq;
using UnityEngine;
using UnityEditor;
using UnityEditor.Sprites;
using System.Collections.Generic;

// DefaultPackerPolicy will pack rectangles no matter what Sprite mesh type is unless their packing tag contains "[TIGHT]".
class GameSpritePackerPolicy : UnityEditor.Sprites.IPackerPolicy
{
    private static int MAX_SIZE = 1024;
    private static int SRPITE_MAX_SIZE = 256;
    protected class Entry
    {
        public Sprite sprite;
        public AtlasSettings settings;
        public string atlasName;
        public SpritePackingMode packingMode;
        public int anisoLevel;
    }

    private const uint kDefaultPaddingPower = 2; // Good for base and two mip levels.

    public virtual int GetVersion() { return 1; }

    protected virtual string TagPrefix { get { return "[TIGHT]"; } }
    protected virtual bool AllowTightWhenTagged { get { return true; } }

    public bool AllowSequentialPacking { get { return true; } }

    public void OnGroupAtlases(BuildTarget target, PackerJob job, int[] textureImporterInstanceIDs)
    {
        List<Entry> entries = new List<Entry>();

        foreach (int instanceID in textureImporterInstanceIDs)
        {
            TextureImporter ti = EditorUtility.InstanceIDToObject(instanceID) as TextureImporter;
            TextureImporterSettings tis = new TextureImporterSettings();
            ti.ReadTextureSettings(tis);

            Sprite[] sprites = AssetDatabase.LoadAllAssetRepresentationsAtPath(ti.assetPath).Select(x => x as Sprite).Where(x => x != null).ToArray();
            foreach (Sprite sprite in sprites)
            {
                string packTag = ti.spritePackingTag;
                string[] split = packTag.Split('_');
                int size = MAX_SIZE;
                if (split.Length >= 2)
                {
                    int tmp = size;
                    if (int.TryParse(split[1], out tmp))
                    {
                        if (tmp >= 64)
                        {
                            size = tmp;
                        }
                    }
                }

                int clrFlag = 0;
                if (split.Length >= 3)
                {
                    int tmp = clrFlag;
                    if (int.TryParse(split[2], out tmp))
                    {
                        clrFlag = tmp;
                    }
                }

                int forceFlag = 0;
                if(split.Length >= 4)
                {
                    int.TryParse(split[3], out forceFlag);
                }

                if(forceFlag == 0 && (sprite.rect.width > SRPITE_MAX_SIZE || sprite.rect.height > SRPITE_MAX_SIZE))
                {
                    continue;
                }

                Entry entry = new Entry();
                entry.sprite = sprite;
                if (clrFlag == 16)
                {
#if UNITY_STANDALONE
                    entry.settings.format = TextureFormat.ARGB4444; //ins.desiredFormat;
#else
                    entry.settings.format = TextureFormat.RGBA4444; //ins.desiredFormat;
#endif 
                }else if(clrFlag  == 32)
                {
                    entry.settings.format = TextureFormat.ARGB32;
                }
                else
                {
#if UNITY_STANDALONE
                    entry.settings.format = TextureFormat.DXT5; //ins.desiredFormat;
#elif UNITY_IOS
                    entry.settings.format = TextureFormat.ASTC_RGBA_6x6; //ins.desiredFormat;
#elif UNITY_ANDROID
                    entry.settings.format = TextureFormat.ETC2_RGBA8; //ins.desiredFormat;
#endif
                }

                //entry.settings.usageMode = ins.usageMode;
                entry.settings.colorSpace = ColorSpace.Linear; // ins.colorSpace;
                entry.settings.compressionQuality = (int) UnityEditor.TextureCompressionQuality.Normal; //ins.compressionQuality;
                entry.settings.filterMode = Enum.IsDefined(typeof(FilterMode), ti.filterMode) ? ti.filterMode : FilterMode.Bilinear;
                entry.settings.maxWidth = size;
                entry.settings.maxHeight = size;
                entry.settings.generateMipMaps = ti.mipmapEnabled;
                if (ti.mipmapEnabled)
                    entry.settings.paddingPower = kDefaultPaddingPower;
                string atlasName = ParseAtlasName(ti.spritePackingTag);
                atlasName = atlasName.Replace("{FileName}", sprite.name);
                entry.atlasName = atlasName;
                entry.packingMode = GetPackingMode(ti.spritePackingTag, tis.spriteMeshType);
                entry.anisoLevel = ti.anisoLevel;

                entries.Add(entry);
            }

            Resources.UnloadAsset(ti);
        }

        // First split sprites into groups based on atlas name
        var atlasGroups =
            from e in entries
            group e by e.atlasName;
        foreach (var atlasGroup in atlasGroups)
        {
            int page = 0;
            // Then split those groups into smaller groups based on texture settings
            var settingsGroups =
                from t in atlasGroup
                group t by t.settings;
            foreach (var settingsGroup in settingsGroups)
            {
                string atlasName = atlasGroup.Key;
                if (settingsGroups.Count() > 1)
                    atlasName += string.Format(" (Group {0})", page);

                AtlasSettings settings = settingsGroup.Key;
                settings.anisoLevel = 1;
                // Use the highest aniso level from all entries in this atlas
                if (settings.generateMipMaps)
                    foreach (Entry entry in settingsGroup)
                        if (entry.anisoLevel > settings.anisoLevel)
                            settings.anisoLevel = entry.anisoLevel;

                job.AddAtlas(atlasName, settings);
                foreach (Entry entry in settingsGroup)
                {
                    job.AssignToAtlas(atlasName, entry.sprite, entry.packingMode, SpritePackingRotation.None);
                }

                ++page;
            }
        }
    }

    protected bool IsTagPrefixed(string packingTag)
    {
        packingTag = packingTag.Trim();
        if (packingTag.Length < TagPrefix.Length)
            return false;
        return (packingTag.Substring(0, TagPrefix.Length) == TagPrefix);
    }

    private string ParseAtlasName(string packingTag)
    {
        string name = packingTag.Trim();
        if (IsTagPrefixed(name))
            name = name.Substring(TagPrefix.Length).Trim();
        return (name.Length == 0) ? "(unnamed)" : name;
    }

    private SpritePackingMode GetPackingMode(string packingTag, SpriteMeshType meshType)
    {
        if (meshType == SpriteMeshType.Tight)
            if (IsTagPrefixed(packingTag) == AllowTightWhenTagged)
                return SpritePackingMode.Tight;
        return SpritePackingMode.Rectangle;
    }
}


