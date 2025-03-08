using System;
using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEngine;

public class RefTool : EditorWindow
{
    [MenuItem("Tools/检查/检查MissingReference资源")]
    public static void FindMissing()
    {
        Find();
        foreach (var item in refPaths)
        {
            Debug.Log(item);
        }
    }

    private enum PrefabErrorType
    {
        None = 0,
        Waring = 1,
        Error = 2,
    }




    private static Dictionary<UnityEngine.Object, List<UnityEngine.Object>> prefabs = new Dictionary<UnityEngine.Object, List<UnityEngine.Object>>();
    private static Dictionary<UnityEngine.Object, string> refPaths = new Dictionary<UnityEngine.Object, string>();
    private static void Find()
    {
        prefabs.Clear();
        string[] allassetpaths = AssetDatabase.GetAllAssetPaths();
        EditorUtility.DisplayProgressBar("统计", "统计所有的Prefab", 0);
        //获取所有资源路径 
        var gos = allassetpaths
            .Where(a => a.EndsWith("prefab"))//筛选 是以prefab为后缀的 预设体资源 
            .Select(a => AssetDatabase.LoadAssetAtPath<UnityEngine.Object>(a));//加载这个预设体
                                                                               //gos拿到的是所有加载好的预设体 
        int index = 0, count = gos.Count();
        foreach (var item in gos)
        {
            GameObject go = item as GameObject;
            if (go)
            {
                PrefabErrorType prefabErrorType = PrefabErrorType.None;
                string path = AssetDatabase.GetAssetPath(go);
                EditorUtility.DisplayProgressBar("检查", path, (float)index / count);
                Component[] cps = go.GetComponentsInChildren<Component>(true);//获取这个物体身上所有的组件 
                foreach (var cp in cps)//遍历每一个组件 
                {
                    if (!cp)
                    {
                        if (!prefabs.ContainsKey(go))
                        {
                            prefabs.Add(go, new List<UnityEngine.Object>() { cp });
                        }
                        else
                        {
                            prefabs[go].Add(cp);
                        }
                        continue;
                    }
                    SerializedObject so = new SerializedObject(cp);//生成一个组件对应的S俄日阿里则对Object对象 用于遍历这个组件的所有属性 
                    var iter = so.GetIterator();//拿到迭代器 
                    while (iter.NextVisible(true))//如果有下一个属性 
                    { //如果这个属性类型是引用类型的 
                        if (iter.propertyType == SerializedPropertyType.ObjectReference)
                        { //引用对象是null 并且 引用ID不是0 说明丢失了引用 
                            if (iter.objectReferenceValue == null && iter.objectReferenceInstanceIDValue != 0)
                            {
                                if (!refPaths.ContainsKey(cp)) refPaths.Add(cp, iter.propertyPath);
                                else refPaths[cp] += " | " + iter.propertyPath;
                                if (prefabs.ContainsKey(go))
                                {
                                    if (!prefabs[go].Contains(cp)) prefabs[go].Add(cp);
                                }
                                else
                                {
                                    prefabs.Add(go, new List<UnityEngine.Object>() { cp });
                                }
                            }
                        }
                    }
                    if ((cp is Transform))
                    {
                        if (prefabErrorType != PrefabErrorType.Error)
                        {
                            if (PrefabUtility.IsPartOfPrefabInstance(cp))
                            {
                                if (!PrefabUtility.GetCorrespondingObjectFromSource(cp))
                                {
                                    if (cp.name == "Missing Prefab (Dummy)")
                                    {
                                        prefabErrorType = PrefabErrorType.Error;
                                    }
                                    if (prefabErrorType == PrefabErrorType.None)
                                    {
                                        prefabErrorType = PrefabErrorType.Waring;
                                    }
                                }
                            }
                        }
                    }
                }
                if (prefabErrorType == PrefabErrorType.Error)
                {
                    Debug.LogError(path + " has Missing Prefab (Dummy) !!!", go);
                }
                else if (prefabErrorType == PrefabErrorType.Waring)
                {
                    Debug.LogWarning(path + " has Missing Prefab !!!", go);
                }
                EditorUtility.DisplayProgressBar("检查", path, (float)(index + 1) / count);
            }
            index = index + 1;
        }
        EditorUtility.ClearProgressBar();
        EditorUtility.DisplayDialog("", "就绪", "OK");
    }
}
