using UnityEngine;
using UnityEditor;
using System.Collections.Generic;
using System.Reflection;
using WXB;

public class CreateAnim
{
    [MenuItem("Assets/CheckFileName")]
    static void CheckFileName()
    {
        string assetPath = AssetDatabase.GetAssetPath(Selection.activeObject);
        HashSet<string> guilds = new HashSet<string>(AssetDatabase.FindAssets("", new string[] { assetPath }));
        foreach (string guid in guilds)
        {
            string ap = AssetDatabase.GUIDToAssetPath(guid);
            //if (ap.EndsWith("_.png"))
            //{
            //    Debug.LogFormat(ap);
            //}

            if (string.IsNullOrEmpty(ap) || !ap.EndsWith(".png", true, null))
                continue;

            int pos = ap.LastIndexOf('/');
            if (!ap.Substring(pos + 1).StartsWith("anim_"))
                continue;

            int pos_ = ap.LastIndexOf('_');
            if (pos_ == -1)
                continue;

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            sb.Append(ap.Substring(0, pos_ + 1));
            int m = pos_ + 1;
            int e = ap.LastIndexOf('.') - 1;
            for (; m < e; ++m)
            {
                if (ap[m] != '0')
                    break;
            }

            sb.Append(ap.Substring(m, ap.Length - m));
            //Debug.LogFormat("{0}->{1}", ap.Substring(7), sb.ToString().Substring(7));
            AssetDatabase.CopyAsset(ap, sb.ToString());
            AssetDatabase.DeleteAsset(ap);
        }
    }


    [MenuItem("Assets/更新动画数据")]
    static void UpdateAnim()
    {

        EditorConfigCSV csvCfg = new EditorConfigCSV();

        string assetPath = AssetDatabase.GetAssetPath(Selection.activeObject);

        HashSet<string> guids = new HashSet<string>(AssetDatabase.FindAssets("", new string[] { assetPath }));

        Dictionary<string, Sprite> sprites = new Dictionary<string, Sprite>();
        foreach (string guid in guids)
        {
            Object[] objs = AssetDatabase.LoadAllAssetRepresentationsAtPath(AssetDatabase.GUIDToAssetPath(guid));
            foreach (Object o in objs)
            {
                if (o is Sprite)
                    sprites.Add(o.name, o as Sprite);
            }
        }

        Dictionary<string, Cartoon> Cartoons = new Dictionary<string, Cartoon>();
        List<Sprite> tempss = new List<Sprite>();
        for (int i = 0; i < 1000; ++i)
        {
            string animName = string.Format("anim_{0}_", i);
            for (int j = 0; j < 100; ++j)
            {
                string frameName = animName + j;
                Sprite s = null;
                if (sprites.TryGetValue(frameName, out s))
                    tempss.Add(s);
             }

            if (tempss.Count != 0)
            {
                string content = csvCfg.GetValue((i + 1).ToString(), "FrameTime", "EmojiCfg");
                if (string.IsNullOrEmpty(content))
                {
                    continue;
                }
                string[] array = content.Split(';');
                Cartoon c = new Cartoon();
                c.name = i.ToString();

                c.content = content;
                c.sprites = tempss.ToArray();

                string width = csvCfg.GetValue((i + 1).ToString(), "Width", "EmojiCfg");
                string height = csvCfg.GetValue((i + 1).ToString(), "Height", "EmojiCfg");
                int width1 = 0;
                int height1 = 0;
                int.TryParse(width, out width1);
                int.TryParse(height, out height1);

                c.width = width1;
                c.height = height1;

                string xOffset = csvCfg.GetValue((i + 1).ToString(), "XOffset", "EmojiCfg");
                string yOffset = csvCfg.GetValue((i + 1).ToString(), "YOffset", "EmojiCfg");

                int xOffset1 = 0;
                int yOffset1 = 0;
                int.TryParse(xOffset, out xOffset1);
                int.TryParse(yOffset, out yOffset1);

                c.xOffset = xOffset1;
                c.yOffset = yOffset1;

                Cartoons.Add(i.ToString(), c);

                tempss.Clear();
            }
        }

        List<Cartoon> cartoons = new List<Cartoon>(Cartoons.Values);
        cartoons.Sort((Cartoon x, Cartoon y) =>
        {
            return int.Parse(x.name).CompareTo(int.Parse(y.name));
        });

        string path = Constants.UICommonPath + "/SymbolTextInit.prefab";
        SymbolTextInit sti = AssetDatabase.LoadAssetAtPath<SymbolTextInit>(path);
        sti.cartoons = cartoons.ToArray();
        EditorUtility.SetDirty(sti);
        AssetDatabase.SaveAssets();
        Debug.Log("emoji update over");

        csvCfg = null;
    }
}
