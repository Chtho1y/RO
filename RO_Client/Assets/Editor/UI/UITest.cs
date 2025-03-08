using UnityEditor;
using UnityEngine;
using UIExtensions;
using DG.Tweening;


public class UITest
{
    [MenuItem("Assets/test")]
    public static void Test()
    {
        GameObject go = Selection.activeGameObject;
        string path = AssetDatabase.GetAssetPath(go);
        Debug.Log(path);
        go.transform.DOScale(0, 1).SetEase(Ease.InExpo);
    }
}