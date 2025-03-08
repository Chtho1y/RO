using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEditor;

public class GetScrollRectAlginPointTool
{
    [MenuItem("RO_Tool/UI/提取ScrollRect的对齐点", true)]
    private static bool CanUseTool()
    {
        GameObject activeGameObject = Selection.activeGameObject;
        if (!activeGameObject) return false;
        ScrollRect scrollRect = activeGameObject.GetComponent<ScrollRect>();
        if (!scrollRect) return false;
        return true;
    }

    [MenuItem("RO_Tool/UI/提取ScrollRect的对齐点")]
    private static void UseTool()
    {
        GameObject activeGameObject = Selection.activeGameObject;
        ScrollRect scrollRect = activeGameObject.GetComponent<ScrollRect>();
        Vector2 normalizedPosition = scrollRect.normalizedPosition;
        Vector2 viewPortSize = scrollRect.viewport.rect.size;
        Vector2 contentSize = scrollRect.content.rect.size;
        Vector2 vaildSize = contentSize - viewPortSize;
        Vector2 point = normalizedPosition * vaildSize;
        point = point - vaildSize * 0.5f;
        GUIUtility.systemCopyBuffer = point.x + ";" + point.y;
        Debug.LogError(point.x + ";" + point.y);
    }
}
