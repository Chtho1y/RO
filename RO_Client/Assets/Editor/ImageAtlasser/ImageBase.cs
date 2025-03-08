using UnityEngine;
using UnityEditor;
using System.IO;
using System.Collections.Generic;

#region Image Class

[System.Serializable]
public sealed class ImageAtlasBase
{
    [SerializeField]
    private Texture2D m_image;
    [SerializeField]
    private Texture2D m_rotatedImage;
    public Texture2D image
    {
        get
        {
            return m_attr.isRotated ? m_rotatedImage : m_image;
        }
    }

    [SerializeField]
    private ImageAttributes m_attr;
    public ImageAttributes attr
    {
        get
        {
            return m_attr;
        }
    }

    public ImageAtlasBase(Texture2D image, ImageAttributes attr)
        : this(image, attr, true)
    {

    }

    public void Dispose()
    {
        if (string.IsNullOrEmpty(AssetDatabase.GetAssetPath(m_image)))
            Editor.DestroyImmediate(m_image);
        if (string.IsNullOrEmpty(AssetDatabase.GetAssetPath(m_rotatedImage)))
            Editor.DestroyImmediate(m_rotatedImage);
    }

    public ImageAtlasBase(Texture2D image, ImageAttributes attr, bool startDefault)
    {
        m_attr = attr;

        if (m_attr.isRotated)
        {
            m_rotatedImage = image;
            GenerateDefaultImage();

            m_rotatedImage.name = m_image.name = m_attr.name;

            if (startDefault)
                m_attr.ChangeOrientation();
        }
        else
        {
            m_image = image;
            GenerateRotatedImage();

            m_image.name = m_rotatedImage.name = m_attr.name;
        }
    }

    public void LoadNewImage(Texture2D image)
    {
        if (m_attr.isRotated)
        {
            m_rotatedImage = image;
            GenerateDefaultImage();

            m_rotatedImage.name = m_image.name = m_attr.name;
            m_attr.ChangeOrientation();
        }
        else
        {
            m_image = image;
            GenerateRotatedImage();

            m_image.name = m_rotatedImage.name = m_attr.name;
        }
    }

    public void ChangeRotation()
    {
        m_attr.isRotated = !m_attr.isRotated;
    }

    public void SetDefaultOrientation()
    {
        if (m_attr.isRotated)
            m_attr.ChangeOrientation();
    }

    private void GenerateDefaultImage()
    {
        m_image = new Texture2D(m_rotatedImage.height, m_rotatedImage.width);
        for (int y = 0; y < m_rotatedImage.height; y++)
            for (int x = 0; x < m_rotatedImage.width; x++)
                m_image.SetPixel(y, x, m_rotatedImage.GetPixel(x, m_rotatedImage.height - y));
        m_image.Apply();
    }

    private void GenerateRotatedImage()
    {
        m_rotatedImage = new Texture2D(m_image.height, m_image.width);
        for (int y = 0; y < m_image.height; y++)
            for (int x = 0; x < m_image.width; x++)
                m_rotatedImage.SetPixel(y, x, m_image.GetPixel(m_image.width - x - 1, y));
        m_rotatedImage.Apply();
    }
}

#endregion

#region ImageAttributes Class

[System.Serializable]
public sealed class ImageAttributes
{
    public string name;
    public Rect position;
    public bool isRotated;
    public bool canBeRotated = true;

    private ImageAttributes()
        : this("texture", new Rect(), false)
    {

    }
    public ImageAttributes(string name, Rect position, bool isRotated)
        : this(name, position, isRotated, true)
    {

    }
    public ImageAttributes(string name, Rect position, bool isRotated, bool canBeRotated)
    {
        if (string.IsNullOrEmpty(name))
            this.name = "no_name_image";
        else
            this.name = name;
        this.position = position;
        this.isRotated = isRotated;
        this.canBeRotated = canBeRotated;
    }

    public void ChangeOrientation()
    {
        isRotated = !isRotated;
        position = new Rect(position.x, position.y, position.height, position.width);
    }
}

#endregion

#region ImageAtlas Static Class

public static class ImageAtlas
{
    public static ImageAtlasBase[] GetParts(Texture2D atlas, TextAsset codings, TextureImporter importer, bool readFromText)
    {
        ImageAtlasBase[] parts;

        if (readFromText || importer.spritesheet.Length == 0)
        {
            string[] lines = codings.text.Split('\n');
            parts = new ImageAtlasBase[lines.Length];

            for (int i = 0; i < parts.Length; i++)
            {
                ImageAttributes attr = DecodeLine(lines[i]);
                Texture2D image = new Texture2D(
                    (int)attr.position.width,
                    (int)attr.position.height,
                    TextureFormat.RGBA32,
                    false
                    );
                image.SetPixels(
                    atlas.GetPixels(
                    (int)attr.position.x,
                    (int)atlas.height - (int)attr.position.y - (int)attr.position.height,
                    (int)attr.position.width,
                    (int)attr.position.height
                    ));
                image.Apply();
                parts[i] = new ImageAtlasBase(image, attr);
            }
        }
        else
        {
            SpriteMetaData[] sprites = importer.spritesheet;
            parts = new ImageAtlasBase[sprites.Length];

            for (int i = 0; i < sprites.Length; i++)
            {
                ImageAttributes attr = new ImageAttributes(
                    sprites[i].name,
                    new Rect(
                        sprites[i].rect.x,
                        atlas.height - sprites[i].rect.y - sprites[i].rect.height,
                        sprites[i].rect.width,
                        sprites[i].rect.height),
                        false
                        );
                Texture2D image = new Texture2D(
                    (int)attr.position.width,
                    (int)attr.position.height,
                    TextureFormat.RGBA32,
                    false
                    );
                image.SetPixels(
                    atlas.GetPixels(
                    (int)attr.position.x,
                    (int)sprites[i].rect.y,
                    (int)attr.position.width,
                    (int)attr.position.height
                    ));
                image.Apply();
                parts[i] = new ImageAtlasBase(image, attr);
            }
        }

        return parts;
    }

    public static string EncodeLine(ImageAttributes attr)
    {
        string[] ckBegin = new string[]
        {
            " --",
            " x-",
            " y-",
            " w-",
            " h-",
            " r-",
            " xx-",
            " yy-",
            " aa-"
        };
        string[] ckEnd = new string[]
        {
            "-- ",
            "-x ",
            "-y ",
            "-w ",
            "-h ",
            "-r ",
            "-xx ",
            "-yy ",
            "-aa "
        };
        return
            ckBegin[0] + attr.name + ckEnd[0] +
            ckBegin[1] + (int)attr.position.x + ckEnd[1] +
            ckBegin[2] + (int)attr.position.y + ckEnd[2] +
            ckBegin[3] + (int)attr.position.width + ckEnd[3] +
            ckBegin[4] + (int)attr.position.height + ckEnd[4] +
            ckBegin[5] + (attr.isRotated ? 1 : 0).ToString() + ckEnd[5];
    }

    private static ImageAttributes DecodeLine(string codings)
    {
        string[] ckBegin = new string[]
        {
            " --",
            " x-",
            " y-",
            " w-",
            " h-",
            " r-",
            " xx-",
            " yy-",
            " aa-"
        };
        string[] ckEnd = new string[]
        {
            "-- ",
            "-x ",
            "-y ",
            "-w ",
            "-h ",
            "-r ",
            "-xx ",
            "-yy ",
            "-aa "
        };
        string name = GetValue(codings, ckBegin[0], ckEnd[0]);
        Rect position = new Rect(
            float.Parse(GetValue(codings, ckBegin[1], ckEnd[1])),
            float.Parse(GetValue(codings, ckBegin[2], ckEnd[2])),
            float.Parse(GetValue(codings, ckBegin[3], ckEnd[3])),
            float.Parse(GetValue(codings, ckBegin[4], ckEnd[4]))
            );
        bool isRotated = int.Parse(GetValue(codings, ckBegin[5], ckEnd[5])) == 1;
        return new ImageAttributes(name, position, isRotated);
    }

    private static string GetValue(string codings, string begin, string end)
    {
        int startIndex = codings.IndexOf(begin) + begin.Length;
        return codings.Substring(startIndex, (codings.IndexOf(end) - startIndex));
    }

    #region Atlassing Methods

    public static void PackParts(ref List<ImageAtlasBase> parts,
        out int usedMethod, out int usedSize, int spacing, out Vector2 atlasSize)
    {
        atlasSize = Vector2.zero;
        usedMethod = 0;
        usedSize = 32;

        if (parts == null || parts.Count == 0)
            return;

        Rect[] rects;
        int[] methods =
        {
            0,
            1,
            2,
            3,
            4,
            5,
            6,
            7
        };

        int[] sizes =
        {
            32,
            64,
            128,
            256,
            512,
            1024,
            2048,
            4096
        };

        float bestMag = -1;
        Vector2 currSize;

        for (int method = 1; method < methods.Length; method++)
        {
            for (int size = 0; size < sizes.Length; size++)
            {
                parts.SetDefaultOrientation();

                rects = GetPackRects(ref parts, method, sizes[size], spacing, out currSize);
                if (rects == null)
                    continue;

                float currSizeMagnitude = (currSize.x + currSize.y) * 0.5f;

                if (usedMethod == 0)
                {
                    usedMethod = method;
                    usedSize = size;
                    bestMag = currSizeMagnitude;
                }
                else if (currSizeMagnitude < bestMag)
                {
                    usedMethod = method;
                    usedSize = size;
                    bestMag = currSizeMagnitude;
                }
            }
        }

        parts.SetDefaultOrientation();

        usedSize = sizes[usedSize];
        rects = GetPackRects(ref parts, usedMethod, usedSize, spacing, out atlasSize);

        if (rects != null)
            for (int i = 0; i < rects.Length; i++)
                parts[i].attr.position = rects[i];
        else
            Debug.Log("Either something went wrong or textures don\'t fit in the package!");
    }

    public static void PackParts(ref List<ImageAtlasBase> parts, int method, int maxSize, int spacing, out Vector2 atlasSize)
    {
        atlasSize = Vector2.zero;

        if (parts == null || parts.Count == 0)
            return;

        Rect[] rects = null;
        if (method == 0)
            return;

        parts.SetDefaultOrientation();

        rects = GetPackRects(ref parts, method, maxSize, spacing, out atlasSize);

        if (rects != null)
            for (int i = 0; i < rects.Length; i++)
                parts[i].attr.position = rects[i];
        else
            Debug.Log("Either something went wrong or textures don\'t fit in the package!");
    }

    private static Rect[] GetPackRects(ref List<ImageAtlasBase> parts, int method, int size, int spacing, out Vector2 atlasSize)
    {
        switch (method)
        {
            case 1:
                return Pack_MethodA(GetContainedElements(parts), size, spacing, out atlasSize);
            case 2:
                return Pack_MethodB(GetContainedElements(parts), size, spacing, out atlasSize);
            default:
                return Pack_MethodC(GetContainedElements(parts), size, method - 3, spacing, out atlasSize);
        }
    }

    private static ImageAtlasBase[] GetContainedElements(List<ImageAtlasBase> parts)
    {
        List<ImageAtlasBase> containedParts = new List<ImageAtlasBase>();
        for (int i = 0; i < parts.Count; i++)
            if (parts[i].image)
                containedParts.Add(parts[i]);
        return containedParts.ToArray();
    }

    #endregion

    #region Pack Methods

    private static Rect[] Pack_MethodA(ImageAtlasBase[] parts, int size, int spacing, out Vector2 atlasSize)
    {
        int columnPosition = 0;
        int x = 0;
        int y = 0;
        List<Rect> positions = new List<Rect>();
        atlasSize = Vector2.zero;

        for (int i = 0; i < parts.Length; i++)
        {
            int width = parts[i].image.width;
            int height = parts[i].image.height;
            if (y + height + spacing <= size && x + width + spacing <= size)
            {
                positions.Add(new Rect(x, y, width, height));
                y += height + spacing;
                if (columnPosition < x + width + spacing)
                    columnPosition = x + width + spacing;
            }
            else if (columnPosition + width <= size)
            {
                x = columnPosition;
                positions.Add(new Rect(x, 0, width, height));
                y = height + spacing;
                columnPosition = x + width + spacing;
            }
            else return null;
        }

        for (int i = 0; i < positions.Count; i++)
        {
            if (positions[i].xMax > atlasSize.x)
                atlasSize.x = (int)positions[i].xMax;
            if (positions[i].yMax > atlasSize.y)
                atlasSize.y = (int)positions[i].yMax;
        }

        return positions.ToArray();
    }

    private static Rect[] Pack_MethodB(ImageAtlasBase[] parts, int size, int spacing, out Vector2 atlasSize)
    {
        CygonRectanglePacker packer = new CygonRectanglePacker(size, size);
        Rect[] positions = new Rect[parts.Length];
        atlasSize = Vector2.zero;

        for (int i = 0; i < parts.Length; i++)
        {
            Vector2 point;
            if (!packer.TryPack(parts[i].image.width + spacing, parts[i].image.height + spacing, out point))
                return null;
            else
                positions[i] = new Rect(point.x, point.y, parts[i].image.width, parts[i].image.height);
        }

        for (int i = 0; i < positions.Length; i++)
        {
            if (positions[i].xMax > atlasSize.x)
                atlasSize.x = (int)positions[i].xMax;
            if (positions[i].yMax > atlasSize.y)
                atlasSize.y = (int)positions[i].yMax;
        }

        return positions;
    }

    private static Rect[] Pack_MethodC(ImageAtlasBase[] parts, int size, int method, int spacing, out Vector2 atlasSize)
    {
        Rect[] positions = new Rect[parts.Length];
        atlasSize = Vector2.zero;

        MaximalRectanglesBinPack bin = new MaximalRectanglesBinPack();
        bin.Init(size, size);

        for (int i = 0; i < parts.Length; i++)
        {
            int texWidth = parts[i].image.width;
            int texHeight = parts[i].image.height;

            MaximalRectanglesBinPack.FreeRectChoiceHeuristic heuristic;
            switch (method)
            {
                case 0:
                    heuristic = MaximalRectanglesBinPack.FreeRectChoiceHeuristic.RectBottomLeftRule;
                    break;
                case 1:
                    heuristic = MaximalRectanglesBinPack.FreeRectChoiceHeuristic.RectBestShortSideFit;
                    break;
                case 2:
                    heuristic = MaximalRectanglesBinPack.FreeRectChoiceHeuristic.RectBestLongSideFit;
                    break;
                case 3:
                    heuristic = MaximalRectanglesBinPack.FreeRectChoiceHeuristic.RectBestAreaFit;
                    break;
                default:
                    heuristic = MaximalRectanglesBinPack.FreeRectChoiceHeuristic.RectContactPointRule;
                    break;
            }
            positions[i] = bin.Insert(texWidth + spacing, texHeight + spacing, heuristic, parts[i].attr.canBeRotated);
            positions[i].width -= spacing;
            positions[i].height -= spacing;
            if (positions[i].height <= 0)
                return null;

            if (texWidth != texHeight &&
                positions[i].width == texHeight &&
                positions[i].height == texWidth)
                parts[i].ChangeRotation();
        }

        for (int i = 0; i < positions.Length; i++)
        {
            if (positions[i].xMax > atlasSize.x)
                atlasSize.x = (int)positions[i].xMax;
            if (positions[i].yMax > atlasSize.y)
                atlasSize.y = (int)positions[i].yMax;
        }

        return positions;
    }

    #region Maximal Rectangles Bin Pack

    private class MaximalRectanglesBinPack
    {
        #region Variables

        private int binWidth;
        private int binHeight;
        private List<Rect> usedRectangles = new List<Rect>();
        private List<Rect> freeRectangles = new List<Rect>();

        #endregion

        #region Constructors

        public MaximalRectanglesBinPack() : this(0, 0) { }
        public MaximalRectanglesBinPack(int width, int height)
        {
            Init(width, height);
        }

        #endregion

        public void Init(int width, int height)
        {
            binWidth = width;
            binHeight = height;

            Rect n = new Rect(0, 0, width, height);

            usedRectangles.Clear();

            freeRectangles.Clear();
            freeRectangles.Add(n);
        }

        public enum FreeRectChoiceHeuristic
        {
            RectBestShortSideFit,
            RectBestLongSideFit,
            RectBestAreaFit,
            RectBottomLeftRule,
            RectContactPointRule
        };

        #region Insert

        public void Insert(List<Rect> rects, out List<Rect> dst, FreeRectChoiceHeuristic method, bool canBeRotated)
        {
            dst = new List<Rect>();

            while (rects.Count > 0)
            {
                int bestScore1 = int.MaxValue;
                int bestScore2 = int.MaxValue;
                int bestRectIndex = -1;
                Rect bestNode = new Rect();

                for (int index = 0; index < rects.Count; index++)
                {
                    int score1;
                    int score2;
                    Rect newNode = ScoreRect((int)rects[index].width, (int)rects[index].height, method, out score1, out score2, canBeRotated);

                    if (score1 < bestScore1 || (score1 == bestScore1 && score2 < bestScore2))
                    {
                        bestScore1 = score1;
                        bestScore2 = score2;
                        bestNode = newNode;
                        bestRectIndex = index;
                    }
                }

                if (bestRectIndex == -1)
                    return;

                PlaceRect(bestNode);
                rects.Remove(rects[bestRectIndex]);
            }
        }
        public Rect Insert(int width, int height, FreeRectChoiceHeuristic method, bool canBeRotated)
        {
            Rect newNode = new Rect();
            int score1;
            int score2;

            switch (method)
            {
                case FreeRectChoiceHeuristic.RectBestShortSideFit:
                    newNode = FindPositionForNewNodeBestShortSideFit(width, height, out score1, out score2, canBeRotated);
                    break;
                case FreeRectChoiceHeuristic.RectBottomLeftRule:
                    newNode = FindPositionForNewNodeBottomLeft(width, height, out score2, out score1, canBeRotated);
                    break;
                case FreeRectChoiceHeuristic.RectContactPointRule:
                    newNode = FindPositionForNewNodeContactPoint(width, height, out score1, canBeRotated);
                    break;
                case FreeRectChoiceHeuristic.RectBestLongSideFit:
                    newNode = FindPositionForNewNodeBestLongSideFit(width, height, out score1, out score2, canBeRotated);
                    break;
                case FreeRectChoiceHeuristic.RectBestAreaFit:
                    newNode = FindPositionForNewNodeBestAreaFit(width, height, out score1, out score2, canBeRotated);
                    break;
            }

            if (newNode.height == 0)
                return newNode;

            int numRectanglesToProcess = freeRectangles.Count;
            for (int index = 0; index < numRectanglesToProcess; index++)
                if (SplitFreeNode(freeRectangles[index], newNode))
                {
                    freeRectangles.Remove(freeRectangles[index]);
                    index--;
                    numRectanglesToProcess--;
                }

            PruneFreeList();

            usedRectangles.Add(newNode);
            return newNode;
        }

        #endregion

        public float Occupancy()
        {
            ulong usedSurfaceArea = 0;
            for (int index = 0; index < usedRectangles.Count; index++)
                usedSurfaceArea += (ulong)(usedRectangles[index].width * usedRectangles[index].height);
            return (float)usedSurfaceArea / (binWidth * binHeight);
        }

        private Rect ScoreRect(int width, int height, FreeRectChoiceHeuristic method, out int score1, out int score2, bool canBeRotated)
        {
            Rect newNode = new Rect();
            score1 = int.MaxValue;
            score2 = int.MaxValue;

            switch (method)
            {
                case FreeRectChoiceHeuristic.RectBestShortSideFit:
                    newNode = FindPositionForNewNodeBestShortSideFit(width, height, out score1, out score2, canBeRotated);
                    break;
                case FreeRectChoiceHeuristic.RectBottomLeftRule:
                    newNode = FindPositionForNewNodeBottomLeft(width, height, out score2, out score1, canBeRotated);
                    break;
                case FreeRectChoiceHeuristic.RectContactPointRule:
                    newNode = FindPositionForNewNodeContactPoint(width, height, out score1, canBeRotated);
                    score1 = -score1;
                    break;
                case FreeRectChoiceHeuristic.RectBestLongSideFit:
                    newNode = FindPositionForNewNodeBestLongSideFit(width, height, out score2, out score1, canBeRotated);
                    break;
                case FreeRectChoiceHeuristic.RectBestAreaFit:
                    newNode = FindPositionForNewNodeBestAreaFit(width, height, out score1, out score2, canBeRotated);
                    break;
            }

            if (newNode.height == 0)
            {
                score1 = int.MaxValue;
                score2 = int.MaxValue;
            }

            return newNode;
        }

        private void PlaceRect(Rect node)
        {
            int numRectanglesToProcess = freeRectangles.Count;
            for (int index = 0; index < numRectanglesToProcess; index++)
                if (SplitFreeNode(freeRectangles[index], node))
                {
                    freeRectangles.Remove(freeRectangles[index]);
                    index--;
                    numRectanglesToProcess--;
                }

            PruneFreeList();
            usedRectangles.Add(node);
        }

        private int CommonIntervalLength(int i1start, int i1end, int i2start, int i2end)
        {
            if (i1end < i2start || i2end < i1start)
                return 0;
            return Mathf.Min(i1end, i2end) - Mathf.Max(i1start, i2start);
        }

        private int ContactPointScoreNode(int x, int y, int width, int height)
        {
            int score = 0;

            if (x == 0 || x + width == binWidth)
                score += height;
            if (y == 0 || y + height == binHeight)
                score += width;

            for (int index = 0; index < usedRectangles.Count; index++)
            {
                if (usedRectangles[index].x == x + width || usedRectangles[index].x + usedRectangles[index].width == x)
                    score += CommonIntervalLength((int)usedRectangles[index].y, (int)(usedRectangles[index].y + usedRectangles[index].height), y, y + height);
                if (usedRectangles[index].y == y + height || usedRectangles[index].y + usedRectangles[index].height == y)
                    score += CommonIntervalLength((int)usedRectangles[index].x, (int)(usedRectangles[index].x + usedRectangles[index].width), x, x + width);
            }

            return score;
        }

        #region FindPositionForNewNode Methods

        private Rect FindPositionForNewNodeBottomLeft(int width, int height, out int bestX, out int bestY, bool canBeRotated)
        {
            Rect bestNode = new Rect();

            bestY = int.MaxValue;
            bestX = int.MaxValue; // Not sure

            for (int index = 0; index < freeRectangles.Count; index++)
            {
                if (freeRectangles[index].width >= width && freeRectangles[index].height >= height)
                {
                    int topSideY = (int)freeRectangles[index].y + height;
                    if (topSideY < bestY || (topSideY == bestY && freeRectangles[index].x < bestX))
                    {
                        bestNode.x = freeRectangles[index].x;
                        bestNode.y = freeRectangles[index].y;
                        bestNode.width = width;
                        bestNode.height = height;
                        bestY = topSideY;
                        bestX = (int)freeRectangles[index].x;
                    }
                }

                if (canBeRotated)
                    if (freeRectangles[index].width >= height && freeRectangles[index].height >= width)
                    {
                        int topSideY = (int)freeRectangles[index].y + width;
                        if (topSideY < bestY || (topSideY == bestY && freeRectangles[index].x < bestX))
                        {
                            bestNode.x = freeRectangles[index].x;
                            bestNode.y = freeRectangles[index].y;
                            bestNode.width = height;
                            bestNode.height = width;
                            bestY = topSideY;
                            bestX = (int)freeRectangles[index].x;
                        }
                    }
            }
            return bestNode;
        }

        private Rect FindPositionForNewNodeBestShortSideFit(int width, int height, out int bestShortSideFit, out int bestLongSideFit, bool canBeRotated)
        {
            Rect bestNode = new Rect();

            bestShortSideFit = int.MaxValue;
            bestLongSideFit = int.MaxValue; // Not sure

            for (int index = 0; index < freeRectangles.Count; index++)
            {
                if (freeRectangles[index].width >= width && freeRectangles[index].height >= height)
                {
                    int leftoverHoriz = Mathf.Abs((int)freeRectangles[index].width - width);
                    int leftoverVert = Mathf.Abs((int)freeRectangles[index].height - height);
                    int shortSideFit = Mathf.Min(leftoverHoriz, leftoverVert);
                    int longSideFit = Mathf.Max(leftoverHoriz, leftoverVert);

                    if (shortSideFit < bestShortSideFit || (shortSideFit == bestShortSideFit && longSideFit < bestLongSideFit))
                    {
                        bestNode.x = freeRectangles[index].x;
                        bestNode.y = freeRectangles[index].y;
                        bestNode.width = width;
                        bestNode.height = height;
                        bestShortSideFit = shortSideFit;
                        bestLongSideFit = longSideFit;
                    }
                }

                if (canBeRotated)
                    if (freeRectangles[index].width >= height && freeRectangles[index].height >= width)
                    {
                        int flippedLeftoverHoriz = Mathf.Abs((int)freeRectangles[index].width - height);
                        int flippedLeftoverVert = Mathf.Abs((int)freeRectangles[index].height - width);
                        int flippedShortSideFit = Mathf.Min(flippedLeftoverHoriz, flippedLeftoverVert);
                        int flippedLongSideFit = Mathf.Max(flippedLeftoverHoriz, flippedLeftoverVert);

                        if (flippedShortSideFit < bestShortSideFit || (flippedShortSideFit == bestShortSideFit && flippedLongSideFit < bestLongSideFit))
                        {
                            bestNode.x = freeRectangles[index].x;
                            bestNode.y = freeRectangles[index].y;
                            bestNode.width = height;
                            bestNode.height = width;
                            bestShortSideFit = flippedShortSideFit;
                            bestLongSideFit = flippedLongSideFit;
                        }
                    }
            }
            return bestNode;
        }

        private Rect FindPositionForNewNodeBestLongSideFit(int width, int height, out int bestShortSideFit, out int bestLongSideFit, bool canBeRotated)
        {
            Rect bestNode = new Rect();

            bestLongSideFit = int.MaxValue;
            bestShortSideFit = int.MaxValue; // Not sure

            for (int index = 0; index < freeRectangles.Count; index++)
            {
                if (freeRectangles[index].width >= width && freeRectangles[index].height >= height)
                {
                    int leftoverHoriz = Mathf.Abs((int)freeRectangles[index].width - width);
                    int leftoverVert = Mathf.Abs((int)freeRectangles[index].height - height);
                    int shortSideFit = Mathf.Min(leftoverHoriz, leftoverVert);
                    int longSideFit = Mathf.Max(leftoverHoriz, leftoverVert);

                    if (longSideFit < bestLongSideFit || (longSideFit == bestLongSideFit && shortSideFit < bestShortSideFit))
                    {
                        bestNode.x = freeRectangles[index].x;
                        bestNode.y = freeRectangles[index].y;
                        bestNode.width = width;
                        bestNode.height = height;
                        bestShortSideFit = shortSideFit;
                        bestLongSideFit = longSideFit;
                    }
                }

                if (canBeRotated)
                    if (freeRectangles[index].width >= height && freeRectangles[index].height >= width)
                    {
                        int leftoverHoriz = Mathf.Abs((int)freeRectangles[index].width - height);
                        int leftoverVert = Mathf.Abs((int)freeRectangles[index].height - width);
                        int shortSideFit = Mathf.Min(leftoverHoriz, leftoverVert);
                        int longSideFit = Mathf.Max(leftoverHoriz, leftoverVert);

                        if (longSideFit < bestLongSideFit || (longSideFit == bestLongSideFit && shortSideFit < bestShortSideFit))
                        {
                            bestNode.x = freeRectangles[index].x;
                            bestNode.y = freeRectangles[index].y;
                            bestNode.width = height;
                            bestNode.height = width;
                            bestShortSideFit = shortSideFit;
                            bestLongSideFit = longSideFit;
                        }
                    }
            }
            return bestNode;
        }

        private Rect FindPositionForNewNodeBestAreaFit(int width, int height, out int bestAreaFit, out int bestShortSideFit, bool canBeRotated)
        {
            Rect bestNode = new Rect();

            bestAreaFit = int.MaxValue;
            bestShortSideFit = int.MaxValue; // Not sure

            for (int index = 0; index < freeRectangles.Count; index++)
            {
                int areaFit = (int)freeRectangles[index].width * (int)freeRectangles[index].height - width * height;

                if (freeRectangles[index].width >= width && freeRectangles[index].height >= height)
                {
                    int leftoverHoriz = Mathf.Abs((int)freeRectangles[index].width - width);
                    int leftoverVert = Mathf.Abs((int)freeRectangles[index].height - height);
                    int shortSideFit = Mathf.Min(leftoverHoriz, leftoverVert);

                    if (areaFit < bestAreaFit || (areaFit == bestAreaFit && shortSideFit < bestShortSideFit))
                    {
                        bestNode.x = freeRectangles[index].x;
                        bestNode.y = freeRectangles[index].y;
                        bestNode.width = width;
                        bestNode.height = height;
                        bestShortSideFit = shortSideFit;
                        bestAreaFit = areaFit;
                    }
                }

                if (canBeRotated)
                    if (freeRectangles[index].width >= height && freeRectangles[index].height >= width)
                    {
                        int leftoverHoriz = Mathf.Abs((int)freeRectangles[index].width - height);
                        int leftoverVert = Mathf.Abs((int)freeRectangles[index].height - width);
                        int shortSideFit = Mathf.Min(leftoverHoriz, leftoverVert);

                        if (areaFit < bestAreaFit || (areaFit == bestAreaFit && shortSideFit < bestShortSideFit))
                        {
                            bestNode.x = freeRectangles[index].x;
                            bestNode.y = freeRectangles[index].y;
                            bestNode.width = height;
                            bestNode.height = width;
                            bestShortSideFit = shortSideFit;
                            bestAreaFit = areaFit;
                        }
                    }
            }
            return bestNode;
        }

        private Rect FindPositionForNewNodeContactPoint(int width, int height, out int bestContactScore, bool canBeRotated)
        {
            Rect bestNode = new Rect();

            bestContactScore = -1;

            for (int index = 0; index < freeRectangles.Count; index++)
            {
                if (freeRectangles[index].width >= width && freeRectangles[index].height >= height)
                {
                    int score = ContactPointScoreNode((int)freeRectangles[index].x, (int)freeRectangles[index].y, width, height);
                    if (score > bestContactScore)
                    {
                        bestNode.x = freeRectangles[index].x;
                        bestNode.y = freeRectangles[index].y;
                        bestNode.width = width;
                        bestNode.height = height;
                        bestContactScore = score;
                    }
                }

                if (canBeRotated)
                    if (freeRectangles[index].width >= height && freeRectangles[index].height >= width)
                    {
                        int score = ContactPointScoreNode((int)freeRectangles[index].x, (int)freeRectangles[index].y, height, width);
                        if (score > bestContactScore)
                        {
                            bestNode.x = freeRectangles[index].x;
                            bestNode.y = freeRectangles[index].y;
                            bestNode.width = height;
                            bestNode.height = width;
                            bestContactScore = score;
                        }
                    }
            }
            return bestNode;
        }

        #endregion

        private bool SplitFreeNode(Rect freeNode, Rect usedNode)
        {
            if (usedNode.x >= freeNode.x + freeNode.width || usedNode.x + usedNode.width <= freeNode.x ||
                usedNode.y >= freeNode.y + freeNode.height || usedNode.y + usedNode.height <= freeNode.y)
                return false;

            if (usedNode.x < freeNode.x + freeNode.width && usedNode.x + usedNode.width > freeNode.x)
            {
                if (usedNode.y > freeNode.y && usedNode.y < freeNode.y + freeNode.height)
                {
                    Rect newNode = freeNode;
                    newNode.height = usedNode.y - newNode.y;
                    freeRectangles.Add(newNode);
                }

                if (usedNode.y + usedNode.height < freeNode.y + freeNode.height)
                {
                    Rect newNode = freeNode;
                    newNode.y = usedNode.y + usedNode.height;
                    newNode.height = freeNode.y + freeNode.height - (usedNode.y + usedNode.height);
                    freeRectangles.Add(newNode);
                }
            }

            if (usedNode.y < freeNode.y + freeNode.height && usedNode.y + usedNode.height > freeNode.y)
            {
                if (usedNode.x > freeNode.x && usedNode.x < freeNode.x + freeNode.width)
                {
                    Rect newNode = freeNode;
                    newNode.width = usedNode.x - newNode.x;
                    freeRectangles.Add(newNode);
                }

                if (usedNode.x + usedNode.width < freeNode.x + freeNode.width)
                {
                    Rect newNode = freeNode;
                    newNode.x = usedNode.x + usedNode.width;
                    newNode.width = freeNode.x + freeNode.width - (usedNode.x + usedNode.width);
                    freeRectangles.Add(newNode);
                }
            }

            return true;
        }

        private bool IsContainedIn(Rect a, Rect b)
        {
            return a.x >= b.x && a.y >= b.y &&
                a.x + a.width <= b.x + b.width &&
                a.y + a.height <= b.y + b.height;
        }

        private void PruneFreeList()
        {
            for (int index = 0; index < freeRectangles.Count; index++)
                for (int i = index + 1; i < freeRectangles.Count; i++)
                {
                    if (IsContainedIn(freeRectangles[index], freeRectangles[i]))
                    {
                        freeRectangles.Remove(freeRectangles[index]);
                        index--;
                        break;
                    }

                    if (IsContainedIn(freeRectangles[i], freeRectangles[index]))
                    {
                        freeRectangles.Remove(freeRectangles[i]);
                        i--;
                    }
                }
        }
    }

    #endregion

    #region OutOfSpaceException

#if !NO_SERIALIZATION
    [System.Serializable]
#endif
    public class OutOfSpaceException : System.Exception
    {
        /// <summary>Initializes the exception</summary>
        public OutOfSpaceException() { }

        /// <summary>Initializes the exception with an error message</summary>
        /// <param name="message">Error message describing the cause of the exception</param>
        public OutOfSpaceException(string message) : base(message) { }

        /// <summary>Initializes the exception as a followup exception</summary>
        /// <param name="message">Error message describing the cause of the exception</param>
        /// <param name="inner">Preceding exception that has caused this exception</param>
        public OutOfSpaceException(string message, System.Exception inner) : base(message, inner) { }

#if !NO_SERIALIZATION
        /// <summary>Initializes the exception from its serialized state</summary>
        /// <param name="info">Contains the serialized fields of the exception</param>
        /// <param name="context">Additional environmental informations</param>
        protected OutOfSpaceException(
          System.Runtime.Serialization.SerializationInfo info,
          System.Runtime.Serialization.StreamingContext context
        ) :
            base(info, context) { }
#endif
    }

    #endregion

    #region RectanglePacker

    public abstract class RectanglePacker
    {
        /// <summary>Initializes a new rectangle packer</summary>
        /// <param name="packingAreaWidth">Width of the packing area</param>
        /// <param name="packingAreaHeight">Height of the packing area</param>
        protected RectanglePacker(int packingAreaWidth, int packingAreaHeight)
        {
            this.packingAreaWidth = packingAreaWidth;
            this.packingAreaHeight = packingAreaHeight;
        }

        /// <summary>Allocates space for a rectangle in the packing area</summary>
        /// <param name="rectangleWidth">Width of the rectangle to allocate</param>
        /// <param name="rectangleHeight">Height of the rectangle to allocate</param>
        /// <returns>The location at which the rectangle has been placed</returns>
        public virtual Vector2 Pack(int rectangleWidth, int rectangleHeight)
        {
            Vector2 point;

            if (!TryPack(rectangleWidth, rectangleHeight, out point))
                throw new OutOfSpaceException("Rectangle does not fit in packing area");

            return point;
        }

        /// <summary>Tries to allocate space for a rectangle in the packing area</summary>
        /// <param name="rectangleWidth">Width of the rectangle to allocate</param>
        /// <param name="rectangleHeight">Height of the rectangle to allocate</param>
        /// <param name="placement">Output parameter receiving the rectangle's placement</param>
        /// <returns>True if space for the rectangle could be allocated</returns>
        public abstract bool TryPack(
          int rectangleWidth, int rectangleHeight, out Vector2 placement
        );

        /// <summary>Maximum width the packing area is allowed to have</summary>
        protected int PackingAreaWidth
        {
            get { return this.packingAreaWidth; }
        }

        /// <summary>Maximum height the packing area is allowed to have</summary>
        protected int PackingAreaHeight
        {
            get { return this.packingAreaHeight; }
        }

        /// <summary>Maximum allowed width of the packing area</summary>
        private int packingAreaWidth;
        /// <summary>Maximum allowed height of the packing area</summary>
        private int packingAreaHeight;
    }

    #endregion

    #region Cygon Packer

    public class CygonRectanglePacker : RectanglePacker
    {
        #region class SliceStartComparer
        /// <summary>Compares the starting position of height slices</summary>
        private class SliceStartComparer : IComparer<Vector2>
        {
            /// <summary>Provides a default instance for the anchor rank comparer</summary>
            public static SliceStartComparer Default = new SliceStartComparer();

            /// <summary>Compares the starting position of two height slices</summary>
            /// <param name="left">Left slice start that will be compared</param>
            /// <param name="right">Right slice start that will be compared</param>
            /// <returns>The relation of the two slice starts ranks to each other</returns>
            public int Compare(Vector2 left, Vector2 right)
            {
                return (int)left.x - (int)right.x;
            }
        }
        #endregion

        /// <summary>Initializes a new rectangle packer</summary>
        /// <param name="packingAreaWidth">Maximum width of the packing area</param>
        /// <param name="packingAreaHeight">Maximum height of the packing area</param>
        public CygonRectanglePacker(int packingAreaWidth, int packingAreaHeight) :
            base(packingAreaWidth, packingAreaHeight)
        {
            this.heightSlices = new List<Vector2>();

            // At the beginning, the packing area is a single slice of height 0
            this.heightSlices.Add(new Vector2(0, 0));
        }

        /// <summary>Tries to allocate space for a rectangle in the packing area</summary>
        /// <param name="rectangleWidth">Width of the rectangle to allocate</param>
        /// <param name="rectangleHeight">Height of the rectangle to allocate</param>
        /// <param name="placement">Output parameter receiving the rectangle's placement</param>
        /// <returns>True if space for the rectangle could be allocated</returns>
        public override bool TryPack(
          int rectangleWidth, int rectangleHeight, out Vector2 placement
        )
        {
            // If the rectangle is larger than the packing area in any dimension,
            // it will never fit!
            if (
              (rectangleWidth > PackingAreaWidth) || (rectangleHeight > PackingAreaHeight)
            )
            {
                placement = Vector2.zero;
                return false;
            }

            // Determine the placement for the new rectangle
            bool fits = tryFindBestPlacement(rectangleWidth, rectangleHeight, out placement);

            // If a place for the rectangle could be found, update the height slice table to
            // mark the region of the rectangle as being taken.
            if (fits)
                integrateRectangle((int)placement.x, rectangleWidth, (int)placement.y + rectangleHeight);

            return fits;
        }

        /// <summary>Finds the best position for a rectangle of the given dimensions</summary>
        /// <param name="rectangleWidth">Width of the rectangle to find a position for</param>
        /// <param name="rectangleHeight">Height of the rectangle to find a position for</param>
        /// <param name="placement">Receives the best placement found for the rectangle</param>
        /// <returns>True if a valid placement for the rectangle could be found</returns>
        private bool tryFindBestPlacement(
          int rectangleWidth, int rectangleHeight, out Vector2 placement
        )
        {
            int bestSliceIndex = -1; // Slice index where the best placement was found
            int bestSliceY = 0; // Y position of the best placement found
            int bestScore = PackingAreaHeight; // lower == better!

            // This is the counter for the currently checked position. The search works by
            // skipping from slice to slice, determining the suitability of the location for the
            // placement of the rectangle.
            int leftSliceIndex = 0;

            // Determine the slice in which the right end of the rectangle is located when
            // the rectangle is placed at the far left of the packing area.
            int rightSliceIndex = this.heightSlices.BinarySearch(
              new Vector2(rectangleWidth, 0), SliceStartComparer.Default
            );
            if (rightSliceIndex < 0)
                rightSliceIndex = ~rightSliceIndex;

            while (rightSliceIndex <= this.heightSlices.Count)
            {

                // Determine the highest slice within the slices covered by the rectangle at
                // its current placement. We cannot put the rectangle any lower than this without
                // overlapping the other rectangles.
                int highest = (int)this.heightSlices[leftSliceIndex].y;
                for (int index = leftSliceIndex + 1; index < rightSliceIndex; ++index)
                    if (this.heightSlices[index].y > highest)
                        highest = (int)this.heightSlices[index].y;

                // Only process this position if it doesn't leave the packing area
                if ((highest + rectangleHeight <= PackingAreaHeight))
                {
                    int score = highest;

                    if (score < bestScore)
                    {
                        bestSliceIndex = leftSliceIndex;
                        bestSliceY = highest;
                        bestScore = score;
                    }
                }

                // Advance the starting slice to the next slice start
                ++leftSliceIndex;
                if (leftSliceIndex >= this.heightSlices.Count)
                    break;

                // Advance the ending slice until we're on the proper slice again, given the new
                // starting position of the rectangle.
                int rightRectangleEnd = (int)this.heightSlices[leftSliceIndex].x + rectangleWidth;
                for (; rightSliceIndex <= this.heightSlices.Count; ++rightSliceIndex)
                {
                    int rightSliceStart;
                    if (rightSliceIndex == this.heightSlices.Count)
                        rightSliceStart = PackingAreaWidth;
                    else
                        rightSliceStart = (int)this.heightSlices[rightSliceIndex].x;

                    // Is this the slice we're looking for?
                    if (rightSliceStart > rightRectangleEnd)
                        break;
                }

                // If we crossed the end of the slice array, the rectangle's right end has left
                // the packing area, and thus, our search ends.
                if (rightSliceIndex > this.heightSlices.Count)
                    break;

            } // while rightSliceIndex <= this.heightSlices.Count

            // Return the best placement we found for this rectangle. If the rectangle
            // didn't fit anywhere, the slice index will still have its initialization value
            // of -1 and we can report that no placement could be found.
            if (bestSliceIndex == -1)
            {
                placement = Vector2.zero;
                return false;
            }
            else
            {
                placement = new Vector2(this.heightSlices[bestSliceIndex].x, bestSliceY);
                return true;
            }
        }

        /// <summary>Integrates a new rectangle into the height slice table</summary>
        /// <param name="left">Position of the rectangle's left side</param>
        /// <param name="width">Width of the rectangle</param>
        /// <param name="bottom">Position of the rectangle's lower side</param>
        private void integrateRectangle(int left, int width, int bottom)
        {

            // Find the first slice that is touched by the rectangle
            int startSlice = this.heightSlices.BinarySearch(
              new Vector2(left, 0), SliceStartComparer.Default
            );
            int firstSliceOriginalHeight;

            // Since the placement algorithm always places rectangles on the slices,
            // the binary search should never some up with a miss!
            //if (startSlice >= 0)
            //    Debug.Log("Slice starts within another slice");
            //Debug.Assert(
            //  startSlice >= 0, "Slice starts within another slice"
            //);

            // We scored a direct hit, so we can replace the slice we have hit
            firstSliceOriginalHeight = (int)this.heightSlices[startSlice].y;
            this.heightSlices[startSlice] = new Vector2(left, bottom);

            int right = left + width;
            ++startSlice;

            // Special case, the rectangle started on the last slice, so we cannot
            // use the start slice + 1 for the binary search and the possibly already
            // modified start slice height now only remains in our temporary
            // firstSliceOriginalHeight variable
            if (startSlice >= this.heightSlices.Count)
            {

                // If the slice ends within the last slice (usual case, unless it has the
                // exact same width the packing area has), add another slice to return to
                // the original height at the end of the rectangle.
                if (right < PackingAreaWidth)
                    this.heightSlices.Add(new Vector2(right, firstSliceOriginalHeight));

            }
            else
            { // The rectangle doesn't start on the last slice

                int endSlice = this.heightSlices.BinarySearch(
                  startSlice, this.heightSlices.Count - startSlice,
                  new Vector2(right, 0), SliceStartComparer.Default
                );

                // Another direct hit on the final slice's end?
                if (endSlice > 0)
                {

                    this.heightSlices.RemoveRange(startSlice, endSlice - startSlice);

                }
                else
                { // No direct hit, rectangle ends inside another slice

                    // Make index from negative BinarySearch() result
                    endSlice = ~endSlice;

                    // Find out to which height we need to return at the right end of
                    // the rectangle
                    int returnHeight;
                    if (endSlice == startSlice)
                        returnHeight = firstSliceOriginalHeight;
                    else
                        returnHeight = (int)this.heightSlices[endSlice - 1].y;

                    // Remove all slices covered by the rectangle and begin a new slice at its end
                    // to return back to the height of the slice on which the rectangle ends.
                    this.heightSlices.RemoveRange(startSlice, endSlice - startSlice);
                    if (right < PackingAreaWidth)
                        this.heightSlices.Insert(startSlice, new Vector2(right, returnHeight));

                } // if endSlice > 0

            } // if startSlice >= this.heightSlices.Count

        }

        /// <summary>Stores the height silhouette of the rectangles</summary>
        private List<Vector2> heightSlices;
    }

    #endregion

    #endregion

    #region Alphanumeric Comparator Fast

    public class AlphanumComparatorFast : IComparer<FileInfo>
    {
        //public int Compare(object x, object y)
        public int Compare(FileInfo x, FileInfo y)
        {
            //string s1 = x as string;
            string s1 = x.Name;
            if (s1 == null)
            {
                return 0;
            }
            //string s2 = y as string;
            string s2 = y.Name;
            if (s2 == null)
            {
                return 0;
            }

            int len1 = s1.Length;
            int len2 = s2.Length;
            int marker1 = 0;
            int marker2 = 0;

            // Walk through two the strings with two markers.
            while (marker1 < len1 && marker2 < len2)
            {
                char ch1 = s1[marker1];
                char ch2 = s2[marker2];

                // Some buffers we can build up characters in for each chunk.
                char[] space1 = new char[len1];
                int loc1 = 0;
                char[] space2 = new char[len2];
                int loc2 = 0;

                // Walk through all following characters that are digits or
                // characters in BOTH strings starting at the appropriate marker.
                // Collect char arrays.
                do
                {
                    space1[loc1++] = ch1;
                    marker1++;

                    if (marker1 < len1)
                    {
                        ch1 = s1[marker1];
                    }
                    else
                    {
                        break;
                    }
                } while (char.IsDigit(ch1) == char.IsDigit(space1[0]));

                do
                {
                    space2[loc2++] = ch2;
                    marker2++;

                    if (marker2 < len2)
                    {
                        ch2 = s2[marker2];
                    }
                    else
                    {
                        break;
                    }
                } while (char.IsDigit(ch2) == char.IsDigit(space2[0]));

                // If we have collected numbers, compare them numerically.
                // Otherwise, if we have strings, compare them alphabetically.
                string str1 = new string(space1);
                string str2 = new string(space2);

                int result;

                if (char.IsDigit(space1[0]) && char.IsDigit(space2[0]))
                {
                    int thisNumericChunk = int.Parse(str1);
                    int thatNumericChunk = int.Parse(str2);
                    result = thisNumericChunk.CompareTo(thatNumericChunk);
                }
                else
                {
                    result = str1.CompareTo(str2);
                }

                if (result != 0)
                {
                    return result;
                }
            }
            return len1 - len2;
        }
    }

    #endregion
}

#endregion

public static class ImageAtlasBaseExtensions
{
    public static void Dispose(this List<ImageAtlasBase> images)
    {
        for (int i = 0; i < images.Count; i++)
            images[i].Dispose();
        images.Clear();
    }

    public static void SetDefaultOrientation(this List<ImageAtlasBase> images)
    {
        for (int i = 0; i < images.Count; i++)
            images[i].SetDefaultOrientation();
    }
}