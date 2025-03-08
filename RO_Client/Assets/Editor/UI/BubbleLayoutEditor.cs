using UnityEditor;
using UnityEngine;
using UnityEngine.UI;
using UnityEditor.UI;

[CustomEditor(typeof(BubbleLayout), true)]
public class BubbleLayoutEditor : Editor
{
    public override void OnInspectorGUI()
    {
        EditorGUILayout.HelpBox("冒泡布局, 不影响当前对象, 为了使当前对象的 子对象变化 推送给 父对象", MessageType.Info);
    }
}
