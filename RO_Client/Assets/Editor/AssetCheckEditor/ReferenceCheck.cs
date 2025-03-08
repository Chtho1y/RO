using UnityEngine;
using UnityEditor;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using System.IO;

/// <summary>
/// 检查项目中Missing的Component
/// 如果Component的某些引用丢失，打印报错信息，打印丢失引用GameObject的路径
/// </summary>
public class ReferenceCheck
{
    static string[] mAllFiles = null;
    static Queue<string> findFiles = new Queue<string>();


    [MenuItem("Assets/FindImageReferences")]
    public static void FindImageReferences()
    {
        findFiles.Clear();
        EditorSettings.serializationMode = SerializationMode.ForceText;
        string path = AssetDatabase.GetAssetPath(Selection.activeObject);
        PrefabAssetType assetType = PrefabUtility.GetPrefabAssetType(Selection.activeObject);
        if (assetType == PrefabAssetType.NotAPrefab)
        {
            mAllFiles = FileUtils.TraverseAllFiles(Application.dataPath, "*.*", "*.prefab*.unity*.mat*.asset");

            string[] prefabFiles = FileUtils.TraverseAllFiles(path, "*.*", "*.tga*.png*.jpg*.gif");
            for (int idx = 0; idx < prefabFiles.Length; idx++)
            {
                findFiles.Enqueue(prefabFiles[idx]);
            }
            NextFile();
        }
        else
        {
            if (!string.IsNullOrEmpty(path))
            {
                mAllFiles = FileUtils.TraverseAllFiles(Application.dataPath, "*.*", "*.prefab*.unity*.mat*.asset");

                Inner_FindReferences(path, true);
            }
        }
    }

    [MenuItem("Assets/FindMatReferences")]
    public static void FindMatReferences()
    {
        findFiles.Clear();
        EditorSettings.serializationMode = SerializationMode.ForceText;
        string path = AssetDatabase.GetAssetPath(Selection.activeObject);
        PrefabAssetType assetType = PrefabUtility.GetPrefabAssetType(Selection.activeObject);
        if (assetType == PrefabAssetType.NotAPrefab)
        {
            mAllFiles = FileUtils.TraverseAllFiles(Application.dataPath, "*.*", "*.prefab*.unity*.mat*.asset");

            string[] prefabFiles = FileUtils.TraverseAllFiles(path, "*.*", "*.mat");
            for (int idx = 0; idx < prefabFiles.Length; idx++)
            {
                findFiles.Enqueue(prefabFiles[idx]);
            }
            NextFile();
        }
        else
        {
            if (!string.IsNullOrEmpty(path))
            {
                mAllFiles = FileUtils.TraverseAllFiles(Application.dataPath, "*.*", "*.prefab*.unity*.mat*.asset");

                Inner_FindReferences(path, true);
            }
        }
    }

    [MenuItem("Assets/Find References")]
    public static void FindReferences()
    {
        findFiles.Clear();
        EditorSettings.serializationMode = SerializationMode.ForceText;
        string path = AssetDatabase.GetAssetPath(Selection.activeObject);
        PrefabAssetType assetType =  PrefabUtility.GetPrefabAssetType(Selection.activeObject);
        if(assetType == PrefabAssetType.NotAPrefab)
        {
            mAllFiles = FileUtils.TraverseAllFiles(Application.dataPath, "*.*", "*.prefab*.unity*.mat*.asset");

            string[] prefabFiles = FileUtils.TraverseAllFiles(path, "*.*", "*.prefab");
            for (int idx = 0; idx < prefabFiles.Length; idx++)
            {
                findFiles.Enqueue(prefabFiles[idx]);
            }
            NextFile();
        }
        else
        {
            if (!string.IsNullOrEmpty(path))
            {
                mAllFiles = FileUtils.TraverseAllFiles(Application.dataPath, "*.*", "*.prefab*.unity*.mat*.asset");

                Inner_FindReferences(path, true);
            }
        }
    }

    static bool Inner_FindReferences(string path, bool detail = false)
    {
        StringBuilder strBuilder = new StringBuilder();
        strBuilder.AppendLine(string.Format("查找文件:{0}", path));
        bool bFind = false;
        string guid = AssetDatabase.AssetPathToGUID(path);
        int startIndex = 0;
        EditorApplication.update = delegate ()
        {
            string file = mAllFiles[startIndex];
            bool isCancel = EditorUtility.DisplayCancelableProgressBar("匹配资源中", file, (float)startIndex / (float)mAllFiles.Length);
            if (File.Exists(file) && Regex.IsMatch(File.ReadAllText(file), guid))
            {
                bFind = true;
                strBuilder.AppendLine(file);
            }

            startIndex++;
            if (isCancel || startIndex >= mAllFiles.Length)
            {
                EditorUtility.ClearProgressBar();
                EditorApplication.update = null;
                startIndex = 0;
                if (!bFind)
                    Debug.Log(path+" 没有被使用过");
                else if (detail)
                    Debug.Log(strBuilder.ToString());

                if (!isCancel)
                {
                    NextFile();
                }
            }
        };

        return bFind;
    }

    static void NextFile()
    {
        if (findFiles.Count > 0)
        {
            string path = findFiles.Dequeue();
            Inner_FindReferences(path,true);
        }
    }
}
