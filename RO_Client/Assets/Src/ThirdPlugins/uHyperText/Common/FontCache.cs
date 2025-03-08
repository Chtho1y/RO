using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace WXB
{
    public static class FontCache
    {
        static CharacterInfo s_Info;

        // 存储 (font, size, style) -> 行高 的缓存
        private static Dictionary<long, int> FontLineHeight = new Dictionary<long, int>();

        // 一个全局或静态的 TextGenerator，用于计算文本布局
        private static TextGenerator sCachedTextGenerator = new TextGenerator();

        /// <summary>
        /// 获取指定字体、字号、样式的行高
        /// </summary>
        /// <param name="font">字体</param>
        /// <param name="size">字号</param>
        /// <param name="fs">字体样式</param>
        /// <returns>行高（像素值）</returns>
        public static int GetLineHeight(Font font, int size, FontStyle fs)
        {
            // 如果 font 为 null 或 size 不合法，可直接返回一个默认值
            if (font == null || size <= 0)
            {
                // 这里返回一个 fallback 值，也可直接返回 0
                return 16;
            }

            // 生成唯一 key (font instance ID, size, style)
            long key = (long)(((ulong)fs) | (((ulong)size) << 24) | (((ulong)font.GetInstanceID()) << 32));

            // 如果已缓存过行高，直接返回
            if (FontLineHeight.TryGetValue(key, out int cachedLineHeight))
            {
                return cachedLineHeight;
            }

            // 准备 TextGenerationSettings
            var settings = new TextGenerationSettings
            {
                generationExtents = new Vector2(1000, 1000),
                fontSize = size,
                fontStyle = fs,
                textAnchor = TextAnchor.LowerLeft,
                lineSpacing = 1f,
                alignByGeometry = false,
                scaleFactor = 1f,
                font = font,
                resizeTextForBestFit = false,
                updateBounds = false,
                horizontalOverflow = HorizontalWrapMode.Overflow,
                verticalOverflow = VerticalWrapMode.Truncate
            };

            // 生成两行文字，以计算行高
            const string text = "a\na";

            // 调用 Populate
            bool success = sCachedTextGenerator.Populate(text, settings);
            if (!success)
            {
                // Populate 失败，返回一个默认行高或 size
                // 也可根据需求打印日志、抛异常等
                int fallback = size;
                FontLineHeight[key] = fallback;
                return fallback;
            }

            // 访问顶点列表
            IList<UIVertex> verts = sCachedTextGenerator.verts;
            int vCount = verts.Count;

            // 根据 Unity 版本做不同处理
            int lineHeight = size; // 先给一个默认值，避免下面取不到
#if UNITY_2019
            // 在 Unity 2019 中，通常第一行顶点用到 [0..3], 第二行 [4..7]
            // 如果总顶点 < 5，则说明生成不足，使用默认值
            if (vCount >= 5){ lineHeight = (int)(verts[0].position.y - verts[4].position.y); }  
#else
            // 在其他版本中，Unity 可能每行用 4 个顶点，第二行从 [8] 开始
            if (vCount >= 9)
            {
                lineHeight = (int)(verts[0].position.y - verts[8].position.y);
            }
#endif

            // 缓存结果
            FontLineHeight[key] = lineHeight;
            return lineHeight;
        }

        static Dictionary<long, int> FontAdvances = new Dictionary<long, int>();

        static public int GetAdvance(Font font, int size, FontStyle fs, char ch)
        {
            long key = (long)(((ulong)((uint)ch)) | (((ulong)fs) << 16) | (((ulong)size) << 24) | (((ulong)font.GetInstanceID()) << 32));
            int advance = 0;
            if (FontAdvances.TryGetValue(key, out advance))
                return advance;

            for (int i = 0; i < 2; ++i)
            {
                if (font.GetCharacterInfo(ch, out s_Info, size, fs))
                {
                    advance = (short)(s_Info.advance);
                    FontAdvances.Add(key, advance);
                    return advance;
                }
                else
                {
                    font.RequestCharactersInTexture(new string(ch, 1), size, fs);
                }
            }

            FontAdvances.Add(key, 0);
            return 0;
        }
    }
}