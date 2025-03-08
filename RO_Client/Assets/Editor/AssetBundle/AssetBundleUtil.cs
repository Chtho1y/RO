using UnityEngine;
using UnityEditor;
using System.Collections.Generic;
using System.IO;
using System.Text;

public class AssetBundleUtil : EditorWindow
{
    public const string TAG = "AssetBundleUtil";

    static string shaderABName = "shader.unity3d";

    static string matABName = "mat.unity3d";

    static string s_TempAssetBundlePath = Application.dataPath + "/../assetbundle";

    static string s_ManifestFileExtension = ".manifest";

    static BuildAssetBundleOptions buildOptions = BuildAssetBundleOptions.DeterministicAssetBundle | BuildAssetBundleOptions.ChunkBasedCompression;

    #region 处理模块assetbundle
    static void ProcessShaders(HashSet<string> resHash)
    {
        string[] fileList = FileUtils.TraverseAllFiles(Constants.ShaderDir, "*.shader");
        for(int idx =0; idx < fileList.Length; idx++)
        {
            string fullPath = fileList[idx];
            string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);
            if (!resHash.Contains(relativePath))
            {
                resHash.Add(relativePath);

                string abName = FileUtils.RemoveExtension(FileUtils.ExtractPureName(relativePath));
                AssetImporter assetImporter = AssetImporter.GetAtPath(relativePath);
                assetImporter.assetBundleName = shaderABName;
            }
        }

        fileList = FileUtils.TraverseAllFiles(Constants.ShaderDir, "*.shadervariants");
        if(fileList != null)
        {
            for(int idx =0; idx < fileList.Length;idx++)
            {
                string fullPath = fileList[idx];
                string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);
                if (!resHash.Contains(relativePath))
                {
                    resHash.Add(relativePath);

                    string abName = FileUtils.RemoveExtension(FileUtils.ExtractPureName(relativePath));
                    AssetImporter assetImporter = AssetImporter.GetAtPath(relativePath);
                    assetImporter.assetBundleName = shaderABName;
                }
            }
        }
    }

    static void ProcessMaterials(HashSet<string> resHash)
    {
        string[] fileList = FileUtils.TraverseAllFiles(Constants.CommonMaterialDir, "*.mat");
        for (int idx = 0; idx < fileList.Length; idx++)
        {
            string fullPath = fileList[idx];
            string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);
            if (!resHash.Contains(relativePath))
            {
                resHash.Add(relativePath);

                string abName = FileUtils.RemoveExtension(FileUtils.ExtractPureName(relativePath));
                AssetImporter assetImporter = AssetImporter.GetAtPath(relativePath);
                assetImporter.assetBundleName = "commonmat.unity3d";
            }
        }
    }

    static void ProcessFont(HashSet<string> resHash)
    {
        string[] fileList = FileUtils.TraverseFiles(Constants.FontDir, "*.*");
        for (int idx =0; idx < fileList.Length; idx++)
        {
            string fullPath = fileList[idx];
            string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);

            if (relativePath.Contains(".meta")) continue;

            if (!resHash.Contains(relativePath))
            {
                resHash.Add(relativePath);

                string abName = FileUtils.RemoveExtension(FileUtils.ExtractPureName(relativePath));
                AssetImporter assetImporter = AssetImporter.GetAtPath(relativePath);
                assetImporter.assetBundleName = "font.unity3d";
            }
        }


        string[] dirList = Directory.GetDirectories(Constants.FontDir);
        for(int idx =0; idx < dirList.Length; idx++)
        {
            string fullPath = dirList[idx];
            string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);

            string abName = relativePath.Replace("Assets/", "").Replace("/", "_")+".unity3d";
            string[] files = FileUtils.TraverseFiles(relativePath,"*.*");
            for(int jdx = 0; jdx < files.Length;jdx++)
            {
                string filePathName = files[jdx];
                if (filePathName.Contains(".meta")) continue;

                string fileRelativePath = FileUtils.ExtractAssetRelativePath(filePathName);

                SetABName(resHash, fileRelativePath, abName);
            }
        }
    }

    static void ProcessConfig(HashSet<string> resHash)
    {
        string[] files = FileUtils.TraverseAllFiles(Constants.CsvConfig, "*.csv");
        for(int idx =0; idx < files.Length; idx++)
        {
            string fullPath = files[idx];
            string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);
           
            SetABName(resHash, relativePath, "config.unity3d");
        }

        files = FileUtils.TraverseAllFiles(Constants.XmlConfig, "*.xml");
        for (int idx = 0; idx < files.Length; idx++)
        {
            string fullPath = files[idx];
            string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);

            SetABName(resHash, relativePath, "xml.unity3d");
        }
    }

    static void ProcessAudio(HashSet<string> resHash)
    {
        ProcessBGM(resHash);
        ProcessUIAudio(resHash);
        ProcessFight(resHash);
    }

    static void ProcessBGM(HashSet<string> resHash)
    {
        string[] files = FileUtils.TraverseAllFiles(Constants.BGMAudioPath, "*.ogg");
        for(int idx =0; idx < files.Length;idx++)
        {
            string fullPath = files[idx];
            string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);
            string abName = FileUtils.RemoveExtension(FileUtils.ExtractPureName(relativePath)) + ".unity3d";

            SetABName(resHash, relativePath, abName);
        }

    }

    static void ProcessUIAudio(HashSet<string> resHash)
    {
        string[] files = FileUtils.TraverseAllFiles(Constants.UIAudioPath, "*.ogg");
        string abName = "UI_Audio.unity3d";
        for (int idx = 0; idx < files.Length; idx++)
        {
            string fullPath = files[idx];
            string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);

            SetABName(resHash, relativePath, abName);
        }
    }

    static void ProcessFight(HashSet<string> resHash)
    {
        string[] files = FileUtils.TraverseAllFiles(Constants.FightAudioPath, "*.ogg");
        string abName = "Fight_Audio.unity3d";
        for (int idx = 0; idx < files.Length; idx++)
        {
            string fullPath = files[idx];
            string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);

            SetABName(resHash, relativePath, abName);
        }
    }

    static void ProcessIcons(HashSet<string> resHash)
    {
        string[] dirs = Directory.GetDirectories(Constants.IconDir, "*", SearchOption.AllDirectories);
        for (int idx = 0; idx < dirs.Length; idx++)
        {
            string dirName = dirs[idx];
            string abName = FileUtils.ExtractPureName(dirName) + "_icons.unity3d";
            AssetDatabase.RemoveAssetBundleName(abName, true);


            string[] files = FileUtils.TraverseAllFiles(dirName, "*.png");
            for (int jdx = 0; jdx < files.Length; jdx++)
            {
                string fullPath = files[jdx];
                string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);

                SetABName(resHash, relativePath, abName);

                string[] dependencyAssets = AssetDatabase.GetDependencies(relativePath);
                for (int kdx = 0; kdx < dependencyAssets.Length; kdx++)
                {
                    string dependencyAssetName = dependencyAssets[kdx];
                    string fileType = dependencyAssetName.Substring(dependencyAssetName.LastIndexOf('.') + 1);
                    fileType = fileType.ToLower();
                    if (fileType == "shader")
                    {
                        SetABName(resHash, dependencyAssetName, shaderABName);
                    }
                    else if(fileType == "mat")
                    {
                        SetABName(resHash, dependencyAssetName,matABName);
                    }
                    else if (fileType != "cs")
                    {
                        SetABName(resHash, dependencyAssetName, abName);
                    }
                }
            }
        }
    }

    static  void ProcessAnimator(HashSet<string> resHash)
    {
        string[] dirs = Directory.GetDirectories(Constants.AnimatorPath, "*", SearchOption.AllDirectories);
        for (int i = 0; i < dirs.Length; i++)
        {
            string dirName = dirs[i];

            string[] files = FileUtils.TraverseAllFiles(dirName, "*.controller");
            for (int idx = 0; idx < files.Length; idx++)
            {
                string fullPath = files[idx];
                string fileName = FileUtils.ExtractPureName(fullPath);
                string[] tempList = fileName.Split('_'); 
                string abName = tempList[0] + "_animator.unity3d";

                string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);

                SetABName(resHash, relativePath, abName);

                string[] dependencyAssets = AssetDatabase.GetDependencies(relativePath);
                for (int jdx = 0; jdx < dependencyAssets.Length; jdx++)
                {
                    string dependencyAssetName = dependencyAssets[jdx];
                    string fileType = dependencyAssetName.Substring(dependencyAssetName.LastIndexOf('.') + 1);
                    fileType = fileType.ToLower();
                    if (fileType == "shader")
                    {
                        SetABName(resHash, dependencyAssetName, shaderABName);
                    }
                    else if (fileType == "mat")
                    {
                        SetABName(resHash, dependencyAssetName, matABName);
                    }
                    else if (fileType != "cs")
                    {
                        SetABName(resHash, dependencyAssetName, abName);
                    }
                }
            }
        }
    }

    static void ProcessActor(HashSet<string> resHash)
    {
        string[] dirs = Directory.GetDirectories(Constants.ModelPath, "*", SearchOption.AllDirectories);
        for (int i = 0; i < dirs.Length; i++)
        {
            string dirName = dirs[i];

            string abName = FileUtils.ExtractPureName(dirName) + ".unity3d";
            string textureABName = FileUtils.ExtractPureName(dirName) + "_texture.unity3d";
            string fbxABName = FileUtils.ExtractPureName(dirName) + "_model.unity3d";

            string[] files = FileUtils.TraverseAllFiles(dirName, "*.prefab");
            for (int idx = 0; idx < files.Length; idx++)
            {
                string fullPath = files[idx];
                string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);

                SetABName(resHash, relativePath, abName);

                string[] dependencyAssets = AssetDatabase.GetDependencies(relativePath);
                for (int jdx = 0; jdx < dependencyAssets.Length; jdx++)
                {
                    string dependencyAssetName = dependencyAssets[jdx];
                    string fileType = dependencyAssetName.Substring(dependencyAssetName.LastIndexOf('.') + 1);
                    fileType = fileType.ToLower();
                    if (fileType == "shader")
                    {
                        SetABName(resHash, dependencyAssetName, shaderABName);
                    }
                    else if (fileType == "mat")
                    {
                        SetABName(resHash, dependencyAssetName, matABName);
                    }else if(fileType == "jpg" || fileType == "png" || fileType == "tga" || fileType == "tif" || fileType == "psd")
                    {
                        SetABName(resHash, dependencyAssetName, textureABName);
                    }
                    else if (fileType == "fbx")
                    {
                        SetABName(resHash, dependencyAssetName, fbxABName);
                    }
                    else if (fileType != "cs")
                    {
                        SetABName(resHash, dependencyAssetName, abName);
                    }
                }
            }
        }
    }

    static void ProcessCamera(HashSet<string> resHash)
    {
        string[] files = FileUtils.TraverseAllFiles("Assets/Content/Prefabs/Camera", "*.prefab");
        for (int idx = 0; idx < files.Length; idx++)
        {
            string fullPath = files[idx];
            string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);

            string abName = "prefab_camera.unity3d";

            SetABName(resHash, relativePath, abName);

            string[] dependencyAssets = AssetDatabase.GetDependencies(relativePath);
            for (int jdx = 0; jdx < dependencyAssets.Length; jdx++)
            {
                string dependencyAssetName = dependencyAssets[jdx];
                string fileType = dependencyAssetName.Substring(dependencyAssetName.LastIndexOf('.') + 1);
                fileType = fileType.ToLower();
                if (fileType == "shader")
                {
                    SetABName(resHash, dependencyAssetName, shaderABName);
                }
                else if (fileType == "mat")
                {
                    SetABName(resHash, dependencyAssetName, matABName);
                }
                else if (fileType != "cs")
                {
                    SetABName(resHash, dependencyAssetName, abName);
                }
            }
        }
    }

    static void ProcessMonster(HashSet<string> resHash)
    {
        string[] files = FileUtils.TraverseAllFiles(Constants.MonsterPath, "*.prefab");
        for(int idx = 0; idx < files.Length;idx++)
        {
            string fullPath = files[idx];
            string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);

            //string abName = FileUtils.ExtractPureName(FileUtils.RemoveExtension(relativePath)) + ".unity3d";
            string abName = "monster.unity3d";

            SetABName(resHash, relativePath, abName);

            string[] dependencyAssets = AssetDatabase.GetDependencies(relativePath);
            for(int jdx = 0; jdx < dependencyAssets.Length; jdx++)
            {
                string dependencyAssetName = dependencyAssets[jdx];
                string fileType = dependencyAssetName.Substring(dependencyAssetName.LastIndexOf('.') + 1);
                fileType = fileType.ToLower();
                if(fileType  == "shader")
                {
                    SetABName(resHash, dependencyAssetName, shaderABName);
                }
                else if (fileType == "mat")
                {
                    SetABName(resHash, dependencyAssetName, matABName);
                }
                else if(fileType != "cs")
                {
                    SetABName(resHash, dependencyAssetName, abName);
                }
            }
        }
    }

    static void ProcessPartner(HashSet<string> resHash)
    {
        string[] files = FileUtils.TraverseAllFiles(Constants.ModelPath+ "/Parter", "*.prefab");
        for (int idx = 0; idx < files.Length; idx++)
        {
            string fullPath = files[idx];
            string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);

            //string abName = FileUtils.ExtractPureName(FileUtils.RemoveExtension(relativePath)) + ".unity3d";
            string abName = "partner.unity3d";

            SetABName(resHash, relativePath, abName);

            string[] dependencyAssets = AssetDatabase.GetDependencies(relativePath);
            for (int jdx = 0; jdx < dependencyAssets.Length; jdx++)
            {
                string dependencyAssetName = dependencyAssets[jdx];
                string fileType = dependencyAssetName.Substring(dependencyAssetName.LastIndexOf('.') + 1);
                fileType = fileType.ToLower();
                if (fileType == "shader")
                {
                    SetABName(resHash, dependencyAssetName, shaderABName);
                }
                else if (fileType == "mat")
                {
                    SetABName(resHash, dependencyAssetName, matABName);
                }
                else if (fileType != "cs")
                {
                    SetABName(resHash, dependencyAssetName, abName);
                }
            }
        }
    }

    static void ProcessHero(HashSet<string> resHash)
    {
        string[] files = FileUtils.TraverseAllFiles(Constants.HeroPath, "*.prefab");
        for (int idx = 0; idx < files.Length; idx++)
        {
            string fullPath = files[idx];
            string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);

            //string abName = FileUtils.ExtractPureName(FileUtils.RemoveExtension(relativePath)) + ".unity3d";
            string abName = "hero.unity3d";

            SetABName(resHash, relativePath, abName);

            string[] dependencyAssets = AssetDatabase.GetDependencies(relativePath);
            for (int jdx = 0; jdx < dependencyAssets.Length; jdx++)
            {
                string dependencyAssetName = dependencyAssets[jdx];
                string fileType = dependencyAssetName.Substring(dependencyAssetName.LastIndexOf('.') + 1);
                fileType = fileType.ToLower();
                if (fileType == "shader")
                {            
                    SetABName(resHash, dependencyAssetName, shaderABName);
                }
                else if (fileType == "mat")
                {
                    SetABName(resHash, dependencyAssetName, matABName);
                }
                else if (fileType != "cs")
                {
                    SetABName(resHash, dependencyAssetName, abName);
                }
            }
        }
    }

    static void ProcessEffect(HashSet<string> resHash)
    {
        string effectTextureABName = "effect_texture.unity3d";
        string effectAnimABName = "effect_dep.unity3d";
        string abName = "effect.unity3d";


        string[] dirs = Directory.GetDirectories(Constants.EffectPath, "*", SearchOption.AllDirectories);
        for(int idx =0; idx < dirs.Length; idx++)
        {
            string dirName = dirs[idx];
            string[] fileList = FileUtils.TraverseAllFiles(dirName, "*.prefab");

            for (int jdx =0; jdx < fileList.Length;jdx++)
            {
                string fullPath = fileList[jdx];
                string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);
         
                SetABName(resHash, relativePath, abName);

                string[] dependencyAssets = AssetDatabase.GetDependencies(relativePath);
                for (int kdx = 0; kdx < dependencyAssets.Length; kdx++)
                {
                    string dependencyAssetName = dependencyAssets[kdx];
                    string fileType = dependencyAssetName.Substring(dependencyAssetName.LastIndexOf('.') + 1);
                    fileType = fileType.ToLower();       
                    if (fileType == "shader")
                    {
                        SetABName(resHash, dependencyAssetName, shaderABName);
                    }
                    else if (fileType == "mat")
                    {
                        SetABName(resHash, dependencyAssetName, matABName);
                    }
                    else if (fileType == "jpg" || fileType == "png" || fileType == "tga" || fileType == "tif" || fileType == "psd")
                    {
                        SetABName(resHash, dependencyAssetName, effectTextureABName);
                    }
                    else if (fileType != "cs")
                    {
                        SetABName(resHash, dependencyAssetName, effectAnimABName);
                    }
                }
            }
        }
    }

    static void ProcessUI(HashSet<string> resHash)
    {
        Process3DUIPrefab(resHash);
        ProcessUIPrefab(resHash);
    }

    static void Process3DUIPrefab(HashSet<string> resHash)
    {
        string[] dirs = Directory.GetDirectories(Constants.UI3DPath, "*", SearchOption.AllDirectories);
        for(int idx =0; idx < dirs.Length;idx++)
        {
            string dirName = dirs[idx];

            string abName = FileUtils.ExtractPureName(dirName) + "_3duiprefab.unity3d";
            string textureABName = FileUtils.ExtractPureName(dirName) + "_3duiprefab_texture.unity3d";
            AssetDatabase.RemoveAssetBundleName(abName, true);

            string[] files = FileUtils.TraverseAllFiles(dirName, "*.prefab");
            for(int jdx =0; jdx < files.Length;jdx++)
            {
                string fullPath = files[jdx];
                string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);

                SetABName(resHash, relativePath, abName);

                string[] dependencyAssets = AssetDatabase.GetDependencies(relativePath);
                for (int kdx = 0; kdx < dependencyAssets.Length; kdx++)
                {
                    string dependencyAssetName = dependencyAssets[kdx];
                    string fileType = dependencyAssetName.Substring(dependencyAssetName.LastIndexOf('.') + 1);
                    fileType = fileType.ToLower();
                    if (fileType == "shader")
                    {
                        SetABName(resHash, dependencyAssetName, shaderABName);
                    }
                    else if (fileType == "mat")
                    {
                        SetABName(resHash, dependencyAssetName, matABName);
                    }
                    else if (fileType == "jpg" || fileType == "png" || fileType == "tga" || fileType == "tif" || fileType == "psd")
                    {
                        SetABName(resHash, dependencyAssetName, textureABName);
                    }
                    else if (fileType != "cs")
                    {
                        SetABName(resHash, dependencyAssetName, abName);
                    }
                }
            }
        }
    }

    static void ProcessUIPrefab(HashSet<string> resHash)
    {
        string[] dirs = Directory.GetDirectories(Constants.UIPath, "*", SearchOption.AllDirectories);
        for(int idx =0; idx < dirs.Length;idx++)
        {
            string dirName = dirs[idx];
            string dirRelativeName =  FileUtils.ExtractAssetRelativePath(dirName);
            string abName = "";
            if (dirRelativeName == Constants.UICommonPath)
            {
                abName = "prefabsuicommon.unity3d";
            }
            else
            {
                abName = FileUtils.ExtractPureName(dirName) + "_uiprefab.unity3d";
            }
            AssetDatabase.RemoveAssetBundleName(abName, true);


            string[] files = FileUtils.TraverseAllFiles(dirName,"*.prefab");
            for (int jdx = 0; jdx < files.Length; jdx++)
            {
                string fullPath = files[jdx];
                string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);

                SetABName(resHash, relativePath, abName);

                string[] dependencyAssets = AssetDatabase.GetDependencies(relativePath);
                for (int kdx = 0; kdx < dependencyAssets.Length; kdx++)
                {
                    string dependencyAssetName = dependencyAssets[kdx];
                    string fileType = dependencyAssetName.Substring(dependencyAssetName.LastIndexOf('.') + 1);
                    fileType = fileType.ToLower();
                    if (fileType == "shader")
                    {
                        SetABName(resHash, dependencyAssetName, shaderABName);
                    }
                    else if (fileType == "mat")
                    {
                        SetABName(resHash, dependencyAssetName, matABName);
                    }
                    else if (fileType == "jpg" || fileType == "png" || fileType == "tga" || fileType == "tif" || fileType == "psd")
                    {
                        string parent;
                        FileUtils.ExtractParent(dependencyAssetName, out parent);
                        parent = FileUtils.ExtractPureName(parent);
                        string uiTextureABName = "UITexture_" + parent + ".unity3d";
                        SetABName(resHash, dependencyAssetName, uiTextureABName);
                    }
                    else if (fileType != "cs")
                    {
                        SetABName(resHash, dependencyAssetName, abName);
                    }
                }
            }
        }
    }

    static void ProcessScene(HashSet<string> resHash)
    {
        string[] fileList = Directory.GetFiles(Constants.ScenePath, "*.unity", SearchOption.AllDirectories);
        for(int idx =0; idx < fileList.Length; idx++)
        {
            string fullPath = fileList[idx];
            if (fullPath.Contains("UIScene") || fullPath.Contains("meta") || fullPath.Contains("SceneCG") || 
                fullPath.Replace('\\', '/').Contains("Scene/Other") || fullPath.Contains("WasteAsset") || fullPath.Contains("Building"))
                continue;

            if (fullPath.Contains("game.unity") || fullPath.Contains("Loading.unity"))
            {
                continue;
            }

            string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);

            string abName = FileUtils.RemoveExtension(FileUtils.ExtractPureName(relativePath)) + ".unity3d";

            if (!resHash.Contains(relativePath))
            {
                resHash.Add(relativePath);
                AssetImporter assetImporter = AssetImporter.GetAtPath(relativePath);
                assetImporter.assetBundleName = abName;
            }

            string scenePrefabABName = FileUtils.RemoveExtension(FileUtils.ExtractPureName(relativePath)) + "_prefab.unity3d";
            string sceneTextureABName = FileUtils.RemoveExtension(FileUtils.ExtractPureName(relativePath)) + "_texture.unity3d";
            string sceneOtherABName = FileUtils.RemoveExtension(FileUtils.ExtractPureName(relativePath)) + "_other.unity3d";
            string lightmapABName = FileUtils.RemoveExtension(FileUtils.ExtractPureName(relativePath)) + "_lm.unity3d";

            string[] dependencyAssets = AssetDatabase.GetDependencies(relativePath);
            for (int kdx = 0; kdx < dependencyAssets.Length; kdx++)
            {
                string dependencyAssetName = dependencyAssets[kdx];
                if (dependencyAssetName.Contains("Lightmap-") || 
                    dependencyAssetName.Contains("LightingData") || 
                    dependencyAssetName.Contains("ReflectionProbe"))
                {
                    SetABName(resHash, dependencyAssetName, lightmapABName);
                }else if(dependencyAssetName.Contains("PostProcessing") && !dependencyAssetName.Contains(".cs"))
                {
                    if(dependencyAssetName.Contains(".shader"))
                    {
                        SetABName(resHash, dependencyAssetName, shaderABName);
                    }
                    else
                    {
                        SetABName(resHash, dependencyAssetName, "PostProcessing.unity3d");
                    }
                }
                else
                {
                    string fileType = dependencyAssetName.Substring(dependencyAssetName.LastIndexOf('.') + 1);
                    fileType = fileType.ToLower();
                    if (fileType == "shader")
                    {
                        SetABName(resHash, dependencyAssetName, shaderABName);
                    }
                    else if (fileType == "mat")
                    {
                        SetABName(resHash, dependencyAssetName, matABName);
                    }
                    else if (fileType == "prefab")
                    {
                        if(dependencyAssetName.Contains("Scenes/Scene_common"))
                        {
                            string sCommonAb = "scene_common_prefab.unity3d";
                            SetABName(resHash, dependencyAssetName, sCommonAb);
                        }
                        else
                        {
                            SetABName(resHash, dependencyAssetName, scenePrefabABName);
                        }
                        
                    }
                    else if (fileType == "png" || fileType == "tga" || fileType == "jpg" || fileType == "tif" || fileType == "psd")
                    {
                        if(dependencyAssetName.Contains("Scenes/Scene_common"))
                        {
                            string sCommonAb = "scene_common_texture.unity3d";
                            SetABName(resHash, dependencyAssetName, sCommonAb);
                        }
                        else
                        {
                            SetABName(resHash, dependencyAssetName, sceneTextureABName);
                        }
                    }
                    else if (fileType != "cs")
                    {
                        if (dependencyAssetName.Contains("Scenes/Scene_common"))
                        {
                            string sCommonAb = "scene_common_other.unity3d";
                            SetABName(resHash, dependencyAssetName, sCommonAb);
                        }
                        else
                        {
                            SetABName(resHash, dependencyAssetName, sceneOtherABName);
                        }
                    }
                }  
            }
        }
    }

    static void SetABName(HashSet<string> resHash, string assetPath,string abName,bool print = false)
    {
        if (abName.Equals(shaderABName) && assetPath.Contains("/Resources/"))
        {
            //Debug.Log(assetPath);
            return;
        }

        if (!resHash.Contains(assetPath))
        {
            resHash.Add(assetPath);

            AssetImporter aiter = AssetImporter.GetAtPath(assetPath);
            aiter.assetBundleName = abName;
        }
        else
        {
            if (print) {
                AssetImporter aiter = AssetImporter.GetAtPath(assetPath);
                DebugHelper.LogError(assetPath + " exist:"+ aiter.assetBundleName + " not exist:"+abName);
            }
        }
    }

    #region lua_method
    static void CopyLua()
    {
        //EditorUtility.DisplayProgressBar("Copy Lua", "Copy Config...", 0);
        //CopyLuaAsset(Constants.LuaConfigDir);

        EditorUtility.DisplayProgressBar("Copy Lua", "Copy Lua...", 0.1f);
        CopyLuaAsset(Constants.LuaDir);

        EditorUtility.DisplayProgressBar("Copy Lua", "Copy Logic...", 0.2f);
        CopyLuaAsset(Constants.LuaLogicDir);

        CopyLuaAsset(Constants.LuaPbDir);
        //EditorUtility.DisplayProgressBar("Copy Lua", "Copy Opera...", 0.3f);
        //CopyLuaAsset(Constants.LuaOpera);

        //EditorUtility.DisplayProgressBar("Copy Lua", "Copy Battle...", 0.4f);
        //CopyLuaAsset(Constants.LuaBattle);

        EditorUtility.DisplayProgressBar("Copy Lua", "Copy PubSec...", 0.5f);
        CopyLuaAsset(Constants.PubSec);

        EditorUtility.DisplayProgressBar("Copy Lua", "Process AssetBundleCfg...", 0.6f);
        ProcessConfigAndLua();

        EditorUtility.ClearProgressBar();
    }

    static void CopyLuaAsset(string dir)
    {
        string path = Application.dataPath;
        path = Path.Combine(path.Replace("Assets", ""), dir);
        List<string> files = FileSystem.getAllFilesPathEX(path);
        foreach (string fileName in files)
        {
            string destName = fileName.Insert(fileName.IndexOf("Assets/") + 7, "Content/");
            string destFolder = Path.GetDirectoryName(destName);
            if (!Directory.Exists(destFolder))
            {
                Directory.CreateDirectory(destFolder);
            }
            else
            {
                if (File.Exists(destName + ".txt"))
                {
                    File.Delete(destName + ".txt");
                }
            }

            File.Copy(fileName, destName + ".txt");

            if (dir.CompareTo(Constants.LuaLogicDir) == 0 && destName.Contains("_Generate"))
            {
                string[] lines = FileSystem.ReadFileLines(destName + ".txt");
                List<string> contents = new List<string>(lines);
                for (var i = contents.Count - 1; i >= 0; --i)
                {
                    if (contents[i].StartsWith("---@") || contents[i].Equals(""))
                    {
                        contents.RemoveAt(i);
                    }
                }
                File.WriteAllLines(destName + ".txt", contents.ToArray());
            }
        }
        AssetDatabase.Refresh();
    }

    static void ProcessConfigAndLua()
    {
        //string luaCfgABName = Constants.LuaConfigDir.Replace("Assets", "").Replace("Content", "").Replace("/", "").ToLower();
        string luaABName = Constants.LuaDir.Replace("Assets", "").Replace("Content", "").Replace("/", "").ToLower();
        string luaLogicABName = Constants.LuaLogicDir.Replace("Assets", "").Replace("Content", "").Replace("/", "").ToLower();
        string luaPbABName = Constants.LuaPbDir.Replace("Assets", "").Replace("Content", "").Replace("/", "").ToLower();
        //string luaOperaABName = Constants.LuaOpera.Replace("Assets", "").Replace("Content", "").Replace("/", "").ToLower();
        //string luaBattleABName = Constants.LuaBattle.Replace("Assets", "").Replace("Content", "").Replace("/", "").ToLower();
        string pubSecABName = Constants.PubSec.Replace("Assets", "").Replace("Content", "").Replace("/", "").ToLower();

        //AssetDatabase.RemoveAssetBundleName("config", true);
        //AssetDatabase.RemoveAssetBundleName(luaCfgABName, true);
        AssetDatabase.RemoveAssetBundleName(luaABName, true);
        AssetDatabase.RemoveAssetBundleName(luaLogicABName, true);
        AssetDatabase.RemoveAssetBundleName(luaPbABName, true);
        //AssetDatabase.RemoveAssetBundleName(luaOperaABName, true);
        //AssetDatabase.RemoveAssetBundleName(luaBattleABName, true);
        AssetDatabase.RemoveAssetBundleName(pubSecABName, true);

        //ProcessConfigAndLua(Constants.CsvConfig, "config");
        //ProcessConfigAndLua(Constants.ABLuaConfigDir, luaCfgABName);
        ProcessConfigAndLua(Constants.ABLuaPbDir, luaPbABName);
        ProcessConfigAndLua(Constants.ABLuaDir, luaABName);
        ProcessConfigAndLua(Constants.ABLuaLogicDir, luaLogicABName);
        //ProcessConfigAndLua(Constants.ABLuaOpera, luaOperaABName);
        //ProcessConfigAndLua(Constants.ABLuaBattle, luaBattleABName);
        ProcessConfigAndLua(Constants.ABPubsec, pubSecABName);
    }

    static void ProcessConfigAndLua(string dir, string abName)
    {
        List<string> fileList = FileSystem.getAllFilesPathEX(dir);
        for (int idx = 0; idx < fileList.Count; idx++)
        {
            string fullPath = fileList[idx];
            string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);
            if (relativePath.Contains("/Pb/") && dir!= Constants.ABLuaPbDir) continue;

            AssetImporter assetImporter = AssetImporter.GetAtPath(relativePath);
            assetImporter.assetBundleName = abName + ".unity3d";
        }
    }
    #endregion

    #endregion
    
    [MenuItem("Assets/CheckSceneDep")]
    static void ParseScene()
    {
        if (Selection.activeObject == null) return;

        string fullPath = AssetDatabase.GetAssetPath(Selection.activeObject);
        string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);
        string[] dependencyAssets = AssetDatabase.GetDependencies(relativePath);
        for (int kdx = 0; kdx < dependencyAssets.Length; kdx++)
        {
            if(!dependencyAssets[kdx].Contains(".cs"))
                Debug.LogError(dependencyAssets[kdx]);
        }
    }

    [MenuItem("AssetBundle/RemoveAssetBundle")]
    public static void RemoveUnusedAssetBundleName()
    {
        string[] abNames = AssetDatabase.GetAllAssetBundleNames();
        for(int idx =0; idx < abNames.Length; idx++)
        {
            AssetDatabase.RemoveAssetBundleName(abNames[idx], true);
        }
        AssetDatabase.Refresh();
        AssetDatabase.RemoveUnusedAssetBundleNames();
    }

    [MenuItem("AssetBundle/CleanUnusedAB")]
    public static void CleanUnusedAB()
    {
        string[] abNames = AssetDatabase.GetAllAssetBundleNames();
        string[] files = Directory.GetFiles(s_TempAssetBundlePath);
        for(int idx =0; idx < files.Length;idx++)
        {
            string filePath = files[idx];
            if (Path.GetExtension(filePath) == ".manifest") continue;

            string fileName = FileUtils.ExtractPureName(filePath);
            bool find = false;

            for(int jdx =0; jdx < abNames.Length; jdx++)
            {
                if(fileName == abNames[jdx])
                {
                    find = true;
                    break;
                }
            }
            if (!find)
            {
                File.Delete(filePath);
            }
        }
    }

    [MenuItem("AssetBundle/PrintAssetBundleName")]
    static void PrintAssetBundleName()
    {
        StringBuilder strBuilder = new StringBuilder();
        string[] abNames = AssetDatabase.GetAllAssetBundleNames();
        for (int idx = 0; idx < abNames.Length; idx++)
        {
            strBuilder.AppendLine(abNames[idx]);
        }
        Debug.Log(strBuilder.ToString());
    }

    /**
    [MenuItem("AssetBundle/GenAssetBundleConfig")]
    public static void GetAssetBundleConfig()
    {
        AssetDatabase.RemoveUnusedAssetBundleNames();

        HashSet<string> resHash = new HashSet<string>();


        EditorUtility.DisplayProgressBar("Generate Bundle Config", "Create Shader AssetBundle Config...", 0.1f);
        ProcessShaders(resHash);

        EditorUtility.DisplayProgressBar("Generate Bundle Config", "Create Font AssetBundle Config...", 0.2f);
        ProcessFont(resHash);

        EditorUtility.DisplayProgressBar("Generate Bundle Config", "Create Materials AssetBundle Config...", 0.2f);
        ProcessMaterials(resHash);

        EditorUtility.DisplayProgressBar("Generate Bundle Config", "Create Config AssetBundle Config...", 0.3f);
        ProcessConfig(resHash);

        EditorUtility.DisplayProgressBar("Generate Bundle Audio", "Create Config AssetBundle Config...", 0.35f);
        ProcessAudio(resHash);

        EditorUtility.DisplayProgressBar("Generate Bundle Config", "Create Icons AssetBundle Config...", 0.4f);
        ProcessIcons(resHash);

        ProcessCamera(resHash);

        EditorUtility.DisplayProgressBar("Generate Bundle Config", "Create Actor AssetBundle Config...", 0.5f);
        ProcessAnimator(resHash);
        ProcessActor(resHash);

        EditorUtility.DisplayProgressBar("Generate Bundle Config", "Create Fx AssetBundle Config...", 0.6f);
        ProcessEffect(resHash);

        EditorUtility.DisplayProgressBar("Generate Bundle Config", "Create UI AssetBundle Config...", 0.7f);
        ProcessUI(resHash);

        EditorUtility.DisplayProgressBar("Generate Bundle Config", "Create Scene AssetBundle Config...", 0.8f);
        ProcessScene(resHash);

        EditorUtility.DisplayProgressBar("Generate Bundle Config", "Create The First AssetBundle Config...", 1f);
        EditorUtility.ClearProgressBar();
    }

    [MenuItem("AssetBundle/Build All AssetBundles")]
    public static void BuildAllAssetBundles()
    {

        string assetBundlePath = BundleBuilderZ.GetAssetbundlesPath();

        AssetDatabase.Refresh();
        if (!Directory.Exists(assetBundlePath))
            Directory.CreateDirectory(assetBundlePath);

        if (!Directory.Exists(s_TempAssetBundlePath))
            Directory.CreateDirectory(s_TempAssetBundlePath);


        CleanUnusedAB();
        CopyLua();

        try
        {
            AssetBundleManifest abm = BuildPipeline.BuildAssetBundles(s_TempAssetBundlePath, buildOptions, EditorUserBuildSettings.activeBuildTarget);
            if (abm)
            {
                DebugHelper.Log("<color=green>================ Build All Assetbundles Success================</color>");
            }
            else
            {
                DebugHelper.Log("<color=green>================ Build All Assetbundles Fail================</color>");
            }

            GetAllAssetsNameInAssetBundle(abm);

            foreach (string file in Directory.GetFiles(s_TempAssetBundlePath))
            {
                if (Path.GetExtension(file) != ".manifest")
                {
                    string fileName = Path.GetFileName(file);
                    string des = Path.Combine(assetBundlePath, fileName);

                    if (File.Exists(des))
                        File.Delete(des);
                    File.Copy(file, des);
                }
            }
            BundleBuilderZ.BundleBuidlerCopyToStreamingAssets();
        }catch(System.Exception e)
        {
            Debug.LogError(e.Message);
        }
    }
    /**/

    public static void GetAllAssetsNameInAssetBundle(AssetBundleManifest abm, VersionCode resVersionCode)
    {
        GetAllAssetsNameAndCRC(abm.GetAllAssetBundles(), resVersionCode);
    }

    static void GetAllAssetsNameAndCRC(string[] abNames, VersionCode resVersionCode)
    {
        Dictionary<string, List<string>> dicSet = new Dictionary<string, List<string>>();

        //Get all assets names in assetbundle
        int SkipCheck = 2;
        for (int i = 0; i < abNames.Length; i++)
        {
            string abName = abNames[i];

            if (string.IsNullOrEmpty(abName))
                continue;

            string abPath = s_TempAssetBundlePath + "/" + abName + s_ManifestFileExtension;
            if (SkipCheck > 0 && ((abName + s_ManifestFileExtension) == s_TempAssetBundlePath || abName == "assetsmapping"))
            {
                SkipCheck--;
                continue;
            }

            string[] assetNames = GetAssetsNamesExcludeFileExtension(abPath);
            for (int j = 0; j < assetNames.Length; j++)
            {
                string assetName = assetNames[j];
                if (dicSet.ContainsKey(assetName))
                {
                    if (dicSet[assetName].Contains(abName))
                    {
                        Debug.LogError(string.Format("资源名重复！AssetName: {0} in AssetBundle: {1}", assetName, abName));
                    }
                    else
                    {
                        dicSet[assetName].Add(abName);
                    }
                }
                else
                {
                    dicSet.Add(assetName, new List<string>());
                    dicSet[assetName].Add(abName);
                }
            }
        }

        foreach (KeyValuePair<string, List<string>> kv in dicSet)
        {
            if (kv.Value.Count > 1)
            {
                string strAbList = "";
                foreach (string ab in kv.Value)
                {
                    if (strAbList.Length == 0)
                        strAbList += ab;
                    else
                        strAbList += (", " + ab);
                }
                Debug.LogWarning(string.Format("资源{0}被打包到多个assetbundle中：{1}", kv.Key, strAbList));
            }
        }

        StringBuilder sb = new StringBuilder();
        sb.Append("resversioncode");
        sb.Append(",");
        sb.Append(resVersionCode.ToString());
        sb.Append("\r\n");
        AssetsObscureUtil.WriteInfoData(ref sb);
        foreach(var p in dicSet)
        {
            string assetName = p.Key;
            List<string> abList = p.Value;
            if(abList.Count == 0)
            {
                Debug.LogError(assetName + " 为什么没有在AB包中");
                continue;
            }
            sb.Append(assetName);
            sb.Append(",");
            sb.Append(abList[0]);
            sb.Append("\r\n");
        }

        //Create a text file
        UTF8Encoding encoding = new UTF8Encoding(false);
        byte[] bytes = encoding.GetBytes(sb.ToString());
        using (var fs = File.Open(s_TempAssetBundlePath + "/assetsmapping.bytes", FileMode.OpenOrCreate, FileAccess.ReadWrite))
        {
            fs.Write(bytes, 0, bytes.Length);
        }
    }

    static string[] GetAssetsNamesExcludeFileExtension(string path)
    {
        bool isAsset = false;
        List<string> abNames = new List<string>();

        string[] allLines = File.ReadAllLines(path);

        for (int i = 0; i < allLines.Length; i++)
        {
            if (allLines[i] == "Assets:")
            {
                isAsset = true;
                continue;
            }
            if (isAsset)
            {
                if (allLines[i][0] == '-')
                {
                    string assetName = allLines[i].Replace("- ", "").Trim();
                    abNames.Add(assetName);
                }
                else
                    break;
            }
        }
        return abNames.ToArray();
    }

    #region Jenkins
    public static void BuildApp(bool debug = false)
    {
        AssetBundleConstant.IsDebug = debug;
        BundleBuilderZ.DisableScene();
        BundleBuilderZ.BuildApp(debug);
        if(!debug)
            BundleBuilderZ.EnableScene();
    }

    public static void SwitchIosPlatform()
    {
        EditorUserBuildSettings.SwitchActiveBuildTarget(BuildTargetGroup.iOS, BuildTarget.iOS);
    }

    public static void SwitchAndroidPlatform()
    {
        EditorUserBuildSettings.SwitchActiveBuildTarget(BuildTargetGroup.Android, BuildTarget.Android);
    }
    #endregion
}