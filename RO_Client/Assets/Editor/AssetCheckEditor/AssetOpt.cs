using UnityEngine;
using UnityEditor;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System;
using System.Xml;
using UnityEngine.UI;
using UnityEngine.Rendering;
using UnityEngine;

public class AssetOpt
{

    [MenuItem("Assets/设置PackingTag")]
    static void SetAtlasName()
    {
        UnityEngine.Object obj =  Selection.activeObject;

        string assetPath = AssetDatabase.GetAssetPath(obj);
        if(!Directory.Exists(assetPath))
        {
            return;
        }


        string packTagName = FileUtils.ExtractPureName(assetPath) + "Atlas";

        string[] files = FileUtils.TraverseAllFiles(assetPath,"*.png");
        for(int idx =0; idx < files.Length;idx++)
        {
            TextureImporter ai = (TextureImporter)AssetImporter.GetAtPath(files[idx]);
            if(ai!=null)
            {
                ai.spritePackingTag = packTagName;
                ai.SaveAndReimport();
            }
        }
    }


    static string[] exposeNodes = new string[] { "Base_Point", "Back_Point", "foot_point", "Foot_Point", "Head_Point", "Hit_Point", "LHand_Point", "LArm_Point", "RHand_Point", "RArm_Point", "ui_point", "look_point", "Weapon_Point","Weapon_Point1","Weapon_Point2","Weapon_Point3","Weapon_Point4","Weapon_Point5", "Add1_Point","Add1_Point1","Add1_Point2","Add1_Point3","Add1_Point4","Add1_Point5"};
    static List<string> nodes = new List<string>();

    [MenuItem("Assets/OptModel")]
    static void OptModelPrefab()
    {
        nodes.Clear();
        GameObject selectGo = Selection.activeGameObject;
        if (selectGo == null || PrefabUtility.GetPrefabAssetType(selectGo) != PrefabAssetType.Regular) return;


        nodes.AddRange(exposeNodes);

        string assetPath = AssetDatabase.GetAssetPath(selectGo);

        string[] deps = AssetDatabase.GetDependencies(assetPath);
        string fbxAssetPath = "";
        for(int idx =0; idx < deps.Length;idx++)
        {
            if(deps[idx].Contains(".FBX"))
            {
                fbxAssetPath = deps[idx];
                break;
            }
        }


        if (string.IsNullOrEmpty(fbxAssetPath)) return;

        string rootName = selectGo.name;
        GameObject oldGo = GameObject.Instantiate(selectGo);
        oldGo.name = rootName;
        
        for (int idx =0; idx < exposeNodes.Length;idx++)
        {
            Transform t = UnityEngineUtils.RecurisiveFindTransformChild(oldGo.transform, exposeNodes[idx]);
            if(t!=null && t.parent!=null && t.parent.name != rootName)
            {
                if (!nodes.Contains(t.parent.name))
                {
                    nodes.Add(t.parent.name);
                }
            }
        }

        List<string> exposeNames = new List<string>();
        ModelImporter mi = AssetImporter.GetAtPath(fbxAssetPath) as ModelImporter;
        string[] paths = mi.transformPaths;
        for (int idx = 0; idx < paths.Length; idx++)
        {
            if (IsExposeNode(paths[idx]))
            {
                exposeNames.Add(paths[idx]);
            }
        }
        mi.optimizeGameObjects = true;
        mi.extraExposedTransformPaths = exposeNames.ToArray();
        mi.SaveAndReimport();

        oldGo.name = rootName;
        GameObject fbxGo = AssetDatabase.LoadAssetAtPath<GameObject>(fbxAssetPath);
        GameObject newGo = GameObject.Instantiate(fbxGo);
        newGo.name = rootName;

        SkinnedMeshRenderer[] oldSmrs = oldGo.GetComponentsInChildren<SkinnedMeshRenderer>(true);
        SkinnedMeshRenderer[] smrs = newGo.GetComponentsInChildren<SkinnedMeshRenderer>(true);
        for(int idx =0; idx < oldSmrs.Length;idx++)
        {
            var smr = smrs[idx];
            var oldSmr = oldSmrs[idx];
            smr.sharedMaterials = oldSmr.sharedMaterials;
        }

        for(int idx =0; idx < exposeNodes.Length;idx++)
        {
            Transform t = UnityEngineUtils.RecurisiveFindTransformChild(oldGo.transform, exposeNodes[idx]);
            if(t!=null)
            {
                Transform t1 = UnityEngineUtils.RecurisiveFindTransformChild(newGo.transform, exposeNodes[idx]);
                if(t1!=null)
                {
                    if (t.parent != null)
                    {
                        Transform t1Parent = UnityEngineUtils.RecurisiveFindTransformChild(newGo.transform, t.parent.name);
                        if(t1Parent!=null)
                        {
                            t1.SetParent(t1Parent);
                            t1.localPosition = t.localPosition;
                            t1.localScale = t.localScale;
                            t1.localRotation = t.localRotation;
                        }
                    }     
                }
                else
                {
                    GameObject t1Go = new GameObject(t.name);
                    if (t.parent != null)
                    {
                        Transform t1Parent = UnityEngineUtils.RecurisiveFindTransformChild(newGo.transform, t.parent.name);
                        if (t1Parent != null)
                        {
                            t1Go.transform.SetParent(t1Parent);
                            t1Go.transform.localPosition = t.localPosition;
                            t1Go.transform.localScale = t.localScale;
                            t1Go.transform.localRotation = t.localRotation;
                        }
                    }
                    else
                    {
                        t1Go.transform.SetParent(newGo.transform);
                        t1Go.transform.localPosition = t.localPosition;
                        t1Go.transform.localScale = t.localScale;
                        t1Go.transform.localRotation = t.localRotation;
                    }
                }
            }
        }

        Animator oldCtrl = oldGo.GetComponent<Animator>();
        Animator newCtrl = newGo.GetComponent<Animator>();
        if(oldCtrl!=null && newCtrl!=null)
        {
            newCtrl.runtimeAnimatorController = oldCtrl.runtimeAnimatorController;
        }

        bool success = false;
        PrefabUtility.SaveAsPrefabAsset(newGo,assetPath,out success);

        GameObject.DestroyImmediate(oldGo);
        GameObject.DestroyImmediate(newGo);
    }

    [MenuItem("Assets/SaveRTToPNG")]
    static void SaveRTTOPng()
    {
        UnityEngine.Object selectRTGO = Selection.activeObject;
        if (selectRTGO == null) return;

        string path = Application.dataPath + "/test.png";
        RenderTexture rt = selectRTGO as RenderTexture;
        if(rt != null)
        {
            RenderTexture.active = rt;
            Texture2D newTexture = new Texture2D(rt.width, rt.height, TextureFormat.ARGB32, true);
            newTexture.ReadPixels(new Rect(0, 0, RenderTexture.active.width, RenderTexture.active.height), 0, 0);

            byte[] bytes = newTexture.EncodeToPNG();
            if (bytes != null && bytes.Length > 0)
            {
                File.WriteAllBytes(path, bytes);
                Debug.Log("Save Down");
            }
        }
    }

    //[MenuItem("Assets/ExposeNode")]
    static void ExposeFbxNode()
    {
        GameObject selectGo = Selection.activeGameObject;
        if (selectGo == null || PrefabUtility.GetPrefabAssetType(selectGo) != PrefabAssetType.Model) return;

        List<string> exposeNames = new List<string>();
        string modelPath = AssetDatabase.GetAssetPath(selectGo);
        ModelImporter mi = AssetImporter.GetAtPath(modelPath) as ModelImporter;
        string[] paths = mi.transformPaths;
        for(int idx =0; idx < paths.Length;idx++)
        {
            if(IsExposeNode(paths[idx]))
            {
                exposeNames.Add(paths[idx]);
            }
        }
        mi.optimizeGameObjects = true;
        mi.extraExposedTransformPaths = exposeNames.ToArray();
        mi.SaveAndReimport();
    }

    static bool IsExposeNode(string nodeName)
    {
        string pureName = FileUtils.ExtractPureName(nodeName);
        for (int idx =0; idx < nodes.Count;idx++)
        {
            if (pureName == nodes[idx]) return true;
        }

        return false;
    }


    [MenuItem("Assets/RO/清理Animator")]
    static void ClearGoAnimator()
    {
        GameObject selectPrefab = Selection.activeGameObject;
        if (selectPrefab == null) return;

        GameObject selectGo = PrefabUtility.InstantiatePrefab(selectPrefab) as GameObject;

        bool changed = false;
        var animators = selectGo.GetComponentsInChildren<Animator>(true);
        DebugHelper.LogError("LEN:" + animators.Length);
        for (int i = animators.Length-1; i >=0; i--)
        {
            animators[i].DestroyImmediate();
            changed = true;
        }

        if(changed)
            PrefabUtility.ReplacePrefab(selectGo, selectPrefab);

        GameObject.DestroyImmediate(selectGo);
    }

    [MenuItem("Tools/检查/查找使用某个shader的材质")]
    static void CheckMaterial()
    {
        string shaderName = "SpeedTree";
        StringBuilder strBuilder = new StringBuilder();
        string[] files = FileUtils.TraverseAllFiles("Assets", "*.mat");
        for(int idx =0; idx < files.Length;idx++)
        {
            string fileName = FileUtils.ExtractAssetRelativePath(files[idx]);
            Material mat = AssetDatabase.LoadAssetAtPath<Material>(fileName);
            if(mat != null && mat.shader.name == shaderName)
            {
                strBuilder.AppendLine(fileName);
            }
        }
        Debug.LogError(strBuilder.ToString());
    }

    [MenuItem("GameObject/统计场景Mesh", false, 23)]
    static void CheckSceneMesh()
    {
        GameObject selectPrefab = Selection.activeGameObject;
        if (selectPrefab == null) return;


        MeshFilter[] meshFilters = selectPrefab.GetComponentsInChildren<MeshFilter>();
        if (meshFilters == null) return;

        long tris = 0;
        long verts = 0;
        for (int idx =0; idx < meshFilters.Length;idx++)
        {
            MeshFilter mf = meshFilters[idx];
            if(mf.sharedMesh != null)
            {
                tris += mf.sharedMesh.triangles.Length / 3;
                verts += mf.sharedMesh.vertexCount;
            }
        }

        Debug.Log("场景 三角面：" + tris + " 顶点数:" + verts);
    }

    [MenuItem("Tools/优化/生成SVC")]
    static void PrintMatKeyword()
    {
        int startIndex = 0;
        List<GameObject> goList = new List<GameObject>();
        string[] effectPrefabs = FileUtils.TraverseAllFiles(Constants.EffectPath, "*.prefab");
        for (int idx = 0; idx < effectPrefabs.Length; idx++)
        {
            string fullPath = effectPrefabs[idx];
            string relativePath = FileUtils.ExtractAssetRelativePath(fullPath);
            GameObject prefab = AssetDatabase.LoadAssetAtPath<GameObject>(relativePath);
            if(prefab!=null)
            {
                GameObject go = GameObject.Instantiate(prefab);
                goList.Add(go);
            }
        }

        EditorApplication.update = delegate ()
        {
            startIndex++;
            if(startIndex == 10)
            {
                EditorApplication.update = null;
                for(int idx =0; idx < goList.Count;idx++)
                {
                    GameObject.DestroyImmediate(goList[idx]);
                }
                goList.Clear();
                Debug.Log("completed");
            }
        };
    }
}
