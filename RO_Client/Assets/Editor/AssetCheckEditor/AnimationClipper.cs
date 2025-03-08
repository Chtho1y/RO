using UnityEditor;
using UnityEngine;
using System.IO;
using System.Collections.Generic;

public class AnimationClipper : EditorWindow
{
    private static AnimationClipper _window = null;

    [MenuItem("Tools/优化/动作/动画剪裁")]
    public static void ClipAnimation()
    {
        _window = EditorWindow.GetWindow<AnimationClipper>(false, "AnimationClipWindow", true);
        _window.Show();
    }

    public void OnGUI()
    {
        if (GUILayout.Button("开始剪裁"))
        {
            foreach(var obj in Selection.objects)
            {
                if(obj.GetType() == typeof(AnimationClip))
                {
                    ClipAnimationCurveData((AnimationClip)obj);
                    EditorUtility.SetDirty(obj);
                }
                else
                {
                    var path = AssetDatabase.GetAssetPath(obj);
                    if(Directory.Exists(path))
                    {
                        ClipAnimationsInDirectory(path);
                    }
                }
            }

            AssetDatabase.SaveAssets();
        }
    }

    private static void ClipAnimationsInDirectory(string path)
    {
        string pathDir = FileUtils.ExtractAssetRelativePath(path);
        var files = Directory.GetFiles(pathDir, "*.anim", SearchOption.AllDirectories);
        foreach (var file in files)
        {
            string fileName = FileUtils.ExtractAssetRelativePath(file);
            var clip = (AnimationClip)AssetDatabase.LoadAssetAtPath(fileName, typeof(AnimationClip));
            if (null != clip)
            {
                ClipAnimationCurveData((AnimationClip)clip);
                EditorUtility.SetDirty(clip);
            }
        }
    }

    public static bool ClipAnimationCurveData(AnimationClip clip)
    {
        if (clip == null)
        {
            return false;
        }

        EditorCurveBinding[] curveBindings = AnimationUtility.GetCurveBindings(clip);

        if (curveBindings == null)
        {
            return false;
        }

        AnimationCurve[] curves = new AnimationCurve[curveBindings.Length];
        for (int idx =0; idx < curveBindings.Length;idx++)
        {
            AnimationCurve curve = AnimationUtility.GetEditorCurve(clip, curveBindings[idx]);
            curves[idx] = curve;
        }

        // 清除原来所有的数据  
        clip.ClearCurves();

        float len = clip.length;
        for (int idx = 0; idx < curveBindings.Length; idx++)
        {
            EditorCurveBinding ecb = curveBindings[idx];
            AnimationCurve curve = curves[idx];

            // 进行过滤  
            if (IsFilterCurveData(curveBindings[idx].propertyName, curve))
            {
                continue;
            }

            // 将数据存回去  
            clip.SetCurve(ecb.path, ecb.type, ecb.propertyName, curve);
        }

        curves = null;

        return true;
    }

    public static bool IsFilterCurveData(string propertyName, AnimationCurve curve)
    {
        if (propertyName.Contains("Position"))
        {
            return IsNoEffectCurvy(curve, 0);
        }

        if (propertyName.Contains("Scale"))
        {
            return IsNoEffectCurvy(curve, 1, true);
        }

        if (propertyName.Contains("Rotation"))
        {
            return IsNoEffectCurvy(curve, 0, true);
        }

        return false;
    }

    public static bool IsNoEffectCurvy(AnimationCurve curve, float identity, bool reserveIdentity = false)
    {
        if(curve.keys == null || curve.keys.Length == 0)
        {
            return true;
        }

        var keys = new List<Keyframe>(curve.keys);

        // 减去多余的帧
        for(int i = 0; i < keys.Count;)
        {
            if(i - 1 < 0)
            {
                i++;
                continue;
            }

            if(i + 1 >= keys.Count)
            {
                i++;
                continue;
            }

            // 如果一帧的前一帧和后一帧都和当前帧相等，那么可以删除自己
            if (IsKeyFrameEqual(keys[i-1], keys[i]) && IsKeyFrameEqual(keys[i], keys[i+1]))
            {
                keys.RemoveAt(i);
                continue;
            }

            i++;
        }

        // 如果只剩下2帧了，那么这两帧肯定是相等的，根据参数判断是否整个曲线都去掉
        if(keys.Count <= 2)
        {
            if (Mathf.Abs(keys[0].value - identity) < 0.001f && !reserveIdentity)
            {
                return true;
            }
        }

        curve.keys = keys.ToArray();

        return false;
    }

    private static bool IsKeyFrameEqual(Keyframe frame1, Keyframe frame2)
    {
        if (Mathf.Abs(frame1.value - frame2.value) > 0.001f)
        {
            return false;
        }

        if (Mathf.Abs(frame1.inTangent - frame2.inTangent) > 0.001f)
        {
            return false;
        }

        if (Mathf.Abs(frame1.outTangent - frame2.outTangent) > 0.001f)
        {
            return false;
        }

        if (Mathf.Abs(frame1.tangentMode - frame2.tangentMode) > 0.001f)
        {
            return false;
        }

        return true;
    }
}
