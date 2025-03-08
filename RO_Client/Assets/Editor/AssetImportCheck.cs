using System.IO;
using UnityEngine;
using UnityEditor;

public class AssetImportCheck : AssetPostprocessor
{
    private const string JudgeDir = "Assets/Content";

    public void OnPreprocessAsset()
    {
        if (string.IsNullOrEmpty(assetPath)) return;
        //if (!assetPath.StartsWith(JudgeDir)) return;
        if (assetPath.Contains(" "))
        {
            if (assetPath.Contains(".dll") || assetPath.Contains(".cs")) return;

            // 在打包的.manifest文件中，空字符容易造成换行，导致assetsmapping.bytes文件中会遗漏需求资源
            Debug.LogError("路径中有空字符，注意修改" + assetPath);
        }

        if (assetPath.Contains("Gacha"))
        {
            return;
        }

        if (assetImporter is ModelImporter)
        {
            if (assetPath.Contains("Effects/Mesh"))
            {
                if (AssetDatabase.LoadAssetAtPath<Object>(assetPath) == null)
                {
                    var modelImporter = assetImporter as ModelImporter;
                    modelImporter.materialImportMode = ModelImporterMaterialImportMode.None;
                    modelImporter.importTangents = ModelImporterTangents.None;
                }
            }
            else if (assetPath.Contains("Particle/Mesh") ||
                assetPath.ToLower().Contains("terrain") ||
                assetPath.ToLower().Contains("raw_art/monster"))
            {
                var modelImporter = assetImporter as ModelImporter;
                modelImporter.materialImportMode = ModelImporterMaterialImportMode.None;
                modelImporter.importTangents = ModelImporterTangents.None;
            }
            else
            {
                var modelImporter = assetImporter as ModelImporter;
                modelImporter.materialImportMode = ModelImporterMaterialImportMode.None;
                modelImporter.isReadable = false;
                modelImporter.importTangents = ModelImporterTangents.None;
            }
        }
        else if (assetImporter is TextureImporter)
        {
            return;
        }
        else if (assetImporter is PluginImporter)
        {
            var pluginImporter = (assetImporter as PluginImporter);
            ImportBridgeDll(pluginImporter);
        }
        else
        {
            GameObject go = AssetDatabase.LoadAssetAtPath<GameObject>(assetPath);
            if (go != null && PrefabUtility.GetPrefabAssetType(go) == PrefabAssetType.Regular && assetPath.Contains("Assets/Content/Raw_Art"))
            {
                string fullPath = System.IO.Path.Combine(FileSystem.GetUserDocumentPath(), assetPath);
                File.Delete(fullPath);
            }
        }
    }

    public void OnPostprocessTexture(Texture2D tex)
    {
        if (string.IsNullOrEmpty(assetPath)) return;

        if (assetImporter is TextureImporter)
        {
            if (assetPath.Contains("_t4mctrl")
                || assetPath.Contains("T4M")
                || assetPath.Contains("Lightmap-")
                || assetPath.Contains("_alpha")
                || assetPath.Contains("_spec")
                || assetPath.Contains("Spine")
                || assetPath.Contains("Gacha")
                || assetPath.Contains("AppIcon")) return;

            var textureImporter = assetImporter as TextureImporter;
            textureImporter.isReadable = false;
            if (textureImporter.textureType == TextureImporterType.Default)
            {
                bool hasAlpha = textureImporter.DoesSourceTextureHaveAlpha();
                if (hasAlpha)
                {
                    textureImporter.alphaIsTransparency = true;
                }

                TextureImporterPlatformSettings setting = textureImporter.GetPlatformTextureSettings("iPhone");
                if (hasAlpha)
                {
                    setting.format = TextureImporterFormat.ASTC_6x6;

                }
                else
                {
                    setting.format = TextureImporterFormat.ASTC_6x6;
                }
                setting.overridden = true;
                textureImporter.SetPlatformTextureSettings(setting);

                setting = textureImporter.GetPlatformTextureSettings("Android");
                if (hasAlpha)
                {
                    setting.format = TextureImporterFormat.ETC2_RGBA8;
                }
                else
                {
                    setting.format = TextureImporterFormat.ETC2_RGB4;
                }
                setting.overridden = true;
                textureImporter.SetPlatformTextureSettings(setting);

                setting = textureImporter.GetPlatformTextureSettings("PC");
                if (hasAlpha)
                {
                    setting.format = TextureImporterFormat.DXT5;
                }
                else
                {
                    setting.format = TextureImporterFormat.DXT1;
                }
                setting.overridden = true;
                textureImporter.SetPlatformTextureSettings(setting);
            }
        }
    }


    private const string BridgeDllPath = "Assets/Plugins/Bridge/";
    public void ImportBridgeDll(PluginImporter pluginImporter)
    {
        string assetPath = pluginImporter.assetPath;
        if (!assetPath.StartsWith(BridgeDllPath))
        {
            return;
        }
        assetPath = assetPath.Replace(BridgeDllPath, "");
        string[] assetPathStr = assetPath.Split('/');
        if (assetPathStr.Length < 1) return;
        string dirPath = assetPathStr[0];
        if (string.IsNullOrEmpty(dirPath)) return;
        switch (dirPath)
        {
            case "Android":
                pluginImporter.SetCompatibleWithAnyPlatform(false);
                pluginImporter.SetCompatibleWithPlatform(BuildTarget.Android, true);
                break;
            case "iOS":
                pluginImporter.SetCompatibleWithAnyPlatform(false);
                pluginImporter.SetCompatibleWithPlatform(BuildTarget.iOS, true);
                break;
            case "Default":
                pluginImporter.SetCompatibleWithAnyPlatform(true);
                pluginImporter.SetExcludeFromAnyPlatform(BuildTarget.Android, true);
                pluginImporter.SetExcludeFromAnyPlatform(BuildTarget.iOS, true);
                break;
        }
    }
}
