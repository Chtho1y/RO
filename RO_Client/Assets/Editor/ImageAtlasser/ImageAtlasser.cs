using UnityEngine;
using UnityEditor;
using System.IO;
using System.Linq;
using System.Collections;
using System.Collections.Generic;

public class ImageAtlasser : EditorWindow
{
    #region Variables & Properties

    // Editor Window Variables
    private static Vector2 pos = new Vector2(100, 100);
    private Rect windowRectangle = new Rect(210, 0, 0, 0);
    private Vector2 scrollPosition1 = Vector2.zero;
    private Vector2 scrollPosition2 = Vector2.zero;
    private bool atlasPreview = false;
    private string atlasWindowName = "Atlas";
    private GUIContent calcContent = new GUIContent("Atlas");

    // Atlas Settings Variables
    private bool autoArrange = true;
    private Vector2 atlasSize = Vector2.one;
    new private int maxSize = 256;
    private string[] maxSizeKeys =
    {
        "32",
        "64",
        "128",
        "256",
        "512",
        "1024",
        "2048",
        "4096"
    };
    private int[] maxSizeValues =
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
    private int packMethod = 0;
    private string[] packMethodKeys =
    {
        "---",
        "1",
        "2",
        "3 (Rotational)",
        "4 (Rotational)",
        "5 (Rotational)",
        "6 (Rotational)",
        "7 (Rotational)",
    };
    private int[] packMethodValues =
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
    private int spacing = 1;

    // Import Variables
    private Texture2D atlasImage;
    private TextAsset importCodings;
    private Object importDirectory;
    private string importDirectoryStr = string.Empty;
    private bool subDirectories = true;
    private bool replaceImages = true;
    private bool readFromText = true;

    // Export Variables
    private string exportPath = string.Empty;

    // Atlas Drawer Variables
    private Texture2D[] systemImages;
    private Color atlasBackgroundCol = Color.white;
    private string imageNameFilter = string.Empty;
    private bool isMasked = false;

    // Atlas Variables
    private List<ImageAtlasBase> parts = new List<ImageAtlasBase>();

    #endregion

    [MenuItem("RO_Tool/Image Atlasser")]
    static void Init()
    {
        ImageAtlasser window = EditorWindow.GetWindow<ImageAtlasser>("Image Atlasser");
        window.position = new Rect(pos.x, pos.y, 1024, 600);
        window.Show();
    }

    void OnEnable()
    {
        systemImages = new Texture2D[]
        {
            AssetDatabase.LoadAssetAtPath("Assets/Image Atlasser/Editor/icons/bg.jpg", typeof(Texture2D)) as Texture2D,
            AssetDatabase.LoadAssetAtPath("Assets/Image Atlasser/Editor/icons/mask.jpg", typeof(Texture2D)) as Texture2D
        };

        if (Selection.objects.Length > 0)
        {
            importDirectory = Selection.objects[0];
            string assetPath = AssetDatabase.GetAssetPath(importDirectory);
            importDirectoryStr = Directory.Exists(assetPath) ? assetPath : assetPath.Remove(assetPath.LastIndexOf('/') + 1, assetPath.Length - assetPath.LastIndexOf('/') - 1);
        }
    }

    void OnDestroy()
    {
        parts.Dispose();
        pos = new Vector2(position.x, position.y);
    }

    void OnGUI()
    {
        GUILayout.BeginVertical(GUILayout.Width(200));

        GUI.skin.label.fontSize = 15;
        GUI.skin.label.fontStyle = FontStyle.Bold;
        GUIX.LabelCentered("Import Settings", 200);
        GUI.skin.label.fontStyle = FontStyle.Normal;
        GUI.skin.label.fontSize = 11;

        ImportSettings();

        GUILayout.Space(5);
        GUIX.Line();
        GUILayout.Space(5);

        GUI.skin.label.fontSize = 15;
        GUI.skin.label.fontStyle = FontStyle.Bold;
        GUIX.LabelCentered("Pack Settings", 200);
        GUI.skin.label.fontStyle = FontStyle.Normal;
        GUI.skin.label.fontSize = 11;

        PackSettings();

        GUILayout.Space(5);
        GUIX.Line();
        GUILayout.Space(5);

        GUI.skin.label.fontSize = 15;
        GUI.skin.label.fontStyle = FontStyle.Bold;
        GUIX.LabelCentered("Extract Buttons", 200);
        GUI.skin.label.fontStyle = FontStyle.Normal;
        GUI.skin.label.fontSize = 11;

        ExportButtons();

        GUILayout.EndVertical();

        windowRectangle.width = position.width - windowRectangle.x;
        windowRectangle.height = position.height;

        BeginWindows();
        if (atlasPreview)
            GUI.Window(0, windowRectangle, DrawAtlas, string.Empty);
        else
            GUI.Window(0, windowRectangle, DrawParts, string.Empty);
        EndWindows();

        Vector2 elementPosition = new Vector2(windowRectangle.x + 2, 0);

        atlasWindowName = "Atlas [" +
            atlasSize.x + "x" +
            atlasSize.y + "]";

        //atlasWindowName = "Atlas [" +
        //    atlasSize.x + "x" +
        //    atlasSize.y + "] - [" +
        //    string.Format("{0:0.000}", (atlasSize.x + atlasSize.y) * 0.5f) +
        //    "]";

        GUI.skin.label.fontStyle = FontStyle.Bold;
        if (atlasPreview)
        {
            calcContent.text = atlasWindowName;
            float strWidth = GUI.skin.label.CalcSize(calcContent).x;
            GUI.Label(new Rect(elementPosition.x, elementPosition.y, strWidth, 16), atlasWindowName);
            elementPosition.x += strWidth + 10;
        }
        else
        {
            GUI.Label(new Rect(elementPosition.x, elementPosition.y, 48, 16), "Parts");
            elementPosition.x += 48;
        }
        GUI.skin.label.fontStyle = FontStyle.Normal;

        GUI.Label(new Rect(elementPosition.x, elementPosition.y, 98, 16), "| [Atlas preview ");
        elementPosition.x += 98;
        atlasPreview = GUI.Toggle(new Rect(elementPosition.x, elementPosition.y, 23, 16), atlasPreview, "]");

        elementPosition.x += 25;
        GUI.Label(new Rect(elementPosition.x, elementPosition.y, 55, 16), "[Masked ");
        elementPosition.x += 55;
        isMasked = GUI.Toggle(new Rect(elementPosition.x, elementPosition.y, 23, 16), isMasked, "]");

        elementPosition.x += 25;
        GUI.Label(new Rect(elementPosition.x, elementPosition.y, 200, 16), "[Toggle Rotate All ");
        elementPosition.x += 110;
        if (GUI.Button(new Rect(elementPosition.x, elementPosition.y, 60, 16), "Change") && parts.Count > 0)
        {
            bool rotated = parts[0].attr.canBeRotated;
            for (int i = 0; i < parts.Count; i++)
                parts[i].attr.canBeRotated = !rotated;
        }
        elementPosition.x += 60;
        GUI.Label(new Rect(elementPosition.x, elementPosition.y, 10, 16), "]");

        elementPosition.x = position.width - 210;
        GUI.Label(new Rect(elementPosition.x, elementPosition.y, 115, 16), "Search Image Part");
        imageNameFilter = GUI.TextField(new Rect(elementPosition.x + 117, elementPosition.y, 90, 15), imageNameFilter);
    }

    #region Import Settings

    private void ImportSettings()
    {
        // [max width: 200]
        // label field: 200
        // texture field: 200
        // toggle: 182 + 16
        // button: 200

        GUILayout.Label("Import directory", GUILayout.Width(200));
        EditorGUI.indentLevel = 1;
        importDirectory = EditorGUILayout.ObjectField(importDirectory, typeof(Object), false, GUILayout.Width(200));
        EditorGUI.indentLevel = 0;

        GUILayout.BeginHorizontal();
        GUILayout.Label("Search sub-directories", GUILayout.Width(182));
        subDirectories = EditorGUILayout.Toggle(subDirectories, GUILayout.Width(16));
        GUILayout.EndHorizontal();

        GUILayout.BeginHorizontal();
        GUILayout.Label("Replace imported parts", GUILayout.Width(182));
        replaceImages = EditorGUILayout.Toggle(replaceImages, GUILayout.Width(16));
        GUILayout.EndHorizontal();

        if (GUILayout.Button("Import Parts", GUILayout.Width(200), GUILayout.Height(25)) && importDirectory)
        {
            string assetPath = AssetDatabase.GetAssetPath(importDirectory);
            importDirectoryStr = Directory.Exists(assetPath) ? assetPath : assetPath.Remove(assetPath.LastIndexOf('/') + 1, assetPath.Length - assetPath.LastIndexOf('/') - 1);
            if (ImportParts(importDirectoryStr))
                Pack();
        }

        GUILayout.Space(5);
        GUIX.LineDotted();
        GUILayout.Space(5);

        GUILayout.Label("Atlas Image", GUILayout.Width(200));
        EditorGUI.indentLevel = 1;
        atlasImage = EditorGUILayout.ObjectField((Texture2D)atlasImage, typeof(Texture2D), false, GUILayout.Width(200)) as Texture2D;
        EditorGUI.indentLevel = 0;

        GUILayout.Label("Atlas Codings", GUILayout.Width(200));
        EditorGUI.indentLevel = 1;
        importCodings = EditorGUILayout.ObjectField((TextAsset)importCodings, typeof(TextAsset), false, GUILayout.Width(200)) as TextAsset;
        EditorGUI.indentLevel = 0;

        GUILayout.BeginHorizontal();
        GUILayout.Label("Read from Text", GUILayout.Width(182));
        readFromText = EditorGUILayout.Toggle(readFromText, GUILayout.Width(16));
        GUILayout.EndHorizontal();

        if (GUILayout.Button("Import Atlas to Default", GUILayout.Width(200), GUILayout.Height(25)))
            ImportAtlas();
    }

    #endregion

    #region Pack Settings

    private void PackSettings()
    {
        // [max width: 200]
        // label field: 200
        // enam field: 200
        // toggle: 182 + 16
        // button: 200

        GUILayout.BeginHorizontal();
        GUILayout.Label("Auto Arrange", GUILayout.Width(182));
        autoArrange = EditorGUILayout.Toggle(autoArrange, GUILayout.Width(16));
        GUILayout.EndHorizontal();

        if (autoArrange)
            GUI.enabled = false;
        EditorGUI.indentLevel = 1;

        GUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("Pack Method", GUILayout.Width(105));
        int prevPackMethod = packMethod;
        packMethod = EditorGUILayout.IntPopup(packMethod, packMethodKeys, packMethodValues, GUILayout.Width(95));
        GUILayout.EndHorizontal();

        GUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("Size", GUILayout.Width(105));
        int prevMaxSize = maxSize;
        maxSize = EditorGUILayout.IntPopup(maxSize, maxSizeKeys, maxSizeValues, GUILayout.Width(95));
        GUILayout.EndHorizontal();

        EditorGUI.indentLevel = 0;
        GUI.enabled = true;

        if (prevPackMethod != packMethod && packMethod > 0 && parts.Count > 0)
            Pack();

        if (prevMaxSize != maxSize && parts.Count > 0)
            Pack();

        if (GUILayout.Button("Pack", GUILayout.Height(25)) && parts.Count > 0)
            Pack();
    }

    #endregion

    #region Export Buttons

    private void ExportButtons()
    {
        if (GUILayout.Button("Export Atlas", GUILayout.Width(200), GUILayout.Height(25)) && parts.Count > 0)
        {
            exportPath = EditorUtility.SaveFilePanel("Export Atlas to...", Application.dataPath + "/", "Atlas image", string.Empty);
            if (!string.IsNullOrEmpty(exportPath))
                ExportAtlas();
        }

        if (GUILayout.Button("Export Parts", GUILayout.Width(200), GUILayout.Height(25)) && parts.Count > 0)
        {
            string exportPathFolder = EditorUtility.SaveFolderPanel("Export Parts to...", Application.dataPath, "Atlas parts");
            if (!string.IsNullOrEmpty(exportPathFolder))
            {
                for (int i = 0; i < parts.Count; i++)
                    File.WriteAllBytes(exportPathFolder + "/" + parts[i].attr.name + ".png", parts[i].image.EncodeToPNG());
                AssetDatabase.Refresh();
                Debug.Log("OK(!): Image parts have been successfully exported to " + exportPathFolder);
            }
        }
    }

    #endregion

    #region Draw Parts

    private void DrawParts(int winID)
    {
        int horizontalCount = (int)(windowRectangle.width / 105f);

        int activeElementCount = 0;
        for (int i = 0; i < parts.Count; i++)
            if (string.IsNullOrEmpty(imageNameFilter) || parts[i].attr.name.Contains(imageNameFilter))
                activeElementCount++;
        if (horizontalCount == 0)
            return;
        int windowGridHeight = activeElementCount / horizontalCount;
        if ((float)windowGridHeight >= (float)activeElementCount / (float)horizontalCount)
            windowGridHeight--;

        scrollPosition2 = GUI.BeginScrollView(
            new Rect(0, 18, windowRectangle.width - 9, windowRectangle.height - 22),
            scrollPosition2, new Rect(0, 0, 0, windowGridHeight * 125 + 125));

        GUI.skin.label.fontStyle = FontStyle.Bold;
        for (int i = 0, activeIndex = 1, xIndex = 0, yIndex = 0; i < parts.Count; i++)
            if (string.IsNullOrEmpty(imageNameFilter) || parts[i].attr.name.Contains(imageNameFilter))
            {
                if (horizontalCount == 0)
                    horizontalCount = 1;
                xIndex = activeIndex % horizontalCount;
                if (xIndex == 0)
                    xIndex = horizontalCount;
                xIndex--;

                yIndex = activeIndex / horizontalCount;
                if ((float)yIndex >= (float)activeIndex / (float)horizontalCount)
                    yIndex--;

                GUILayout.BeginArea(new Rect(5 + 100 * xIndex, 125 * yIndex, 100, 120));

                GUILayout.BeginHorizontal();
                GUILayout.FlexibleSpace();
                GUILayout.Label(": " + parts[i].attr.name + " :");
                GUILayout.FlexibleSpace();
                GUILayout.EndHorizontal();

                GUILayout.BeginHorizontal();
                GUILayout.FlexibleSpace();
                Rect partRect = GUILayoutUtility.GetRect(95, 50);
                GUI.DrawTexture(partRect, parts[i].image);
                GUILayout.FlexibleSpace();
                GUILayout.EndHorizontal();

                GUILayout.BeginHorizontal();
                GUILayout.FlexibleSpace();
                GUILayout.BeginVertical();
                GUILayout.BeginHorizontal();
                EditorGUILayout.LabelField("Rotate?", GUILayout.Width(78), GUILayout.Height(14));
                parts[i].attr.canBeRotated = EditorGUILayout.Toggle(parts[i].attr.canBeRotated);
                GUILayout.EndHorizontal();
                GUI.color = Color.red;
                if (GUILayout.Button("Remove", GUILayout.Height(25)))
                {
                    ImageAtlasBase image = parts[i];
                    parts.RemoveAt(i);
                    image.Dispose();
                }
                GUI.color = Color.white;
                GUILayout.EndVertical();
                GUILayout.FlexibleSpace();
                GUILayout.EndHorizontal();

                GUILayout.EndArea();

                activeIndex++;
            }
        GUI.skin.label.fontStyle = FontStyle.Normal;

        GUI.EndScrollView(true);
    }

    #endregion

    #region Draw Atlas

    public void DrawAtlas(int winID)
    {
        if (parts.Count == 0)
            return;

        scrollPosition1 = GUILayout.BeginScrollView(scrollPosition1, GUILayout.Width(windowRectangle.width - 12), GUILayout.Height(windowRectangle.height - 28));

        GUILayout.Box("", GUILayout.Width(atlasSize.x - 0.5f), GUILayout.Height(atlasSize.y - 0.5f));

        GUI.color = atlasBackgroundCol;
        GUI.DrawTexture(new Rect(5, 5, atlasSize.x - 0.5f, atlasSize.y - 0.5f),
            systemImages[0]);
        GUI.color = Color.white;

        for (int i = 0; i < parts.Count; i++)
            if (string.IsNullOrEmpty(imageNameFilter) || parts[i].attr.name.Contains(imageNameFilter))
                GUI.DrawTexture(
                       new Rect(
                           parts[i].attr.position.x + 5,
                           parts[i].attr.position.y + 5,
                           parts[i].attr.position.width,
                           parts[i].attr.position.height),
                       !isMasked ? parts[i].image : systemImages[1]);

        GUILayout.EndScrollView();
    }

    #endregion

    #region Import Export Pack Methods

    private bool ImportParts(string path)
    {
        DirectoryInfo importDirectory = new DirectoryInfo(path);

        List<FileInfo> fileInfos = GetImageFilesFromDirectory(importDirectory);
        if (replaceImages)
            parts.Dispose();

        for (int i = 0; i < fileInfos.Count; i++)
        {
            string fullName = fileInfos[i].FullName.Replace('\\', '/');
            string pathDirectory = fullName.Remove(0, fullName.IndexOf("Assets/"));
            Texture2D image = (Texture2D)AssetDatabase.LoadAssetAtPath(pathDirectory, typeof(Texture2D));
            if ((AssetImporter.GetAtPath(pathDirectory) as TextureImporter).isReadable)
            {
                ImageAttributes attr = new ImageAttributes(fileInfos[i].Name.Remove(fileInfos[i].Name.IndexOf('.')), new Rect(), false);
                parts.Add(new ImageAtlasBase(image, attr, false));
            }
        }

        if (parts.Count > 0)
            Debug.Log("OK(!): Imported [" + parts.Count + "] parts out of [" + fileInfos.Count + "]");
        else
        {
            Debug.LogWarning("Warning: No parts have been imported");
            if (fileInfos.Count > 0)
                Debug.Log("Tip: Images must have \"Read/Write Enabled\" flag in order to be imported!");
        }

        return parts.Count > 0;
    }

    private void ImportAtlas()
    {
        TextureImporter importer;

        if (atlasImage == null)
        {
            Debug.LogError("Error(!): Atlas image is not yet assigned.");
            return;
        }
        else
        {
            importer = AssetImporter.GetAtPath(AssetDatabase.GetAssetPath(atlasImage)) as TextureImporter;

            if (!importer.isReadable)
            {
                Debug.LogError("Error(!): Atlas image must have \"Read/Write Enabled\" flag in order to be imported!");
                return;
            }

            if (readFromText && importCodings == null)
            {
                Debug.LogError("Error(!): \"Read from text\" is enabled but no codings file is yet assigned.");
                return;
            }
        }

        if (replaceImages)
            parts.Dispose();
        parts.AddRange(ImageAtlas.GetParts(atlasImage, importCodings, importer, readFromText));
        maxSize = atlasImage.width > atlasImage.height ? atlasImage.width : atlasImage.height;
        atlasSize = new Vector2(atlasImage.width, atlasImage.height);

        if (parts.Count > 0)
            Debug.Log("OK(!): Image parts have been successfully imported!");
        else
            Debug.LogWarning("Warning(!): Something must have gone wrong. No image parts have been imported.");
    }


    int GetPotValue(float size)
    {
        int value = 1;
        while(value < size)
        {
            value *= 2;
        }
        return value;
    }

    private void ExportAtlas()
    {
        if (atlasSize == Vector2.zero || atlasSize == Vector2.one)
        {
            Debug.LogError("Error(!): Atlas creation failed.");
            return;
        }
        atlasSize.Set(GetPotValue(atlasSize.x), GetPotValue((int)atlasSize.y));
        Texture2D atlas = new Texture2D((int)(atlasSize.x), ((int)atlasSize.y), TextureFormat.RGBA32, false);
        string codings = string.Empty;

        Color clear = Color.clear;
        for (int y = 0; y < atlasSize.y; y++)
            for (int x = 0; x < atlasSize.x; x++)
                atlas.SetPixel(x, y, clear);
        atlas.Apply();

        for (int i = 0; i < parts.Count; i++)
        {
            Rect position = new Rect(
                parts[i].attr.position.x,
                parts[i].attr.position.y,
                parts[i].attr.position.width,
                parts[i].attr.position.height);

            atlas.SetPixels(
                (int)position.x,
                (int)(atlasSize.y - (position.y + parts[i].image.height)),
                (int)parts[i].image.width,
                (int)parts[i].image.height,
                parts[i].image.GetPixels()
                );

            codings += ImageAtlas.EncodeLine(parts[i].attr);

            if (i + 1 < parts.Count)
                codings += '\n';
        }
        atlas.Apply();

        if (codings[codings.Length - 1] == '\n')
            codings = codings.Remove(codings.Length - 1);

        if (exportPath.Contains(".png"))
            exportPath = exportPath.Replace(".png", "");

        File.WriteAllBytes(exportPath + ".png", atlas.EncodeToPNG());
        File.WriteAllText(exportPath + ".txt", codings);
        AssetDatabase.Refresh();

        AtlasInfo atlasInfo = new AtlasInfo();
        atlasInfo.texture = (Texture2D)AssetDatabase.LoadAssetAtPath(exportPath.Remove(0, exportPath.IndexOf("Assets/")) + ".png", typeof(Texture));
        atlasInfo.uvDetails = new AtlasInfo.UVDetail[parts.Count];
        SpriteMetaData[] spriteData = new SpriteMetaData[parts.Count];
        for (int i = 0; i < spriteData.Length; i++)
        {
            spriteData[i] = new SpriteMetaData();
            spriteData[i].name = parts[i].attr.name;
            spriteData[i].alignment = 0;
            spriteData[i].rect = new Rect(
                parts[i].attr.position.x,
                atlas.height - parts[i].attr.position.y - parts[i].attr.position.height,
                parts[i].attr.position.width,
                parts[i].attr.position.height
                );
            atlasInfo.uvDetails[i] = new AtlasInfo.UVDetail();
            atlasInfo.uvDetails[i].Name = parts[i].attr.name;
            atlasInfo.uvDetails[i].rotate = parts[i].attr.isRotated;
            if(atlasInfo.uvDetails[i].rotate)
            {
                atlasInfo.uvDetails[i].uvTL = new Vector2((parts[i].attr.position.x + parts[i].attr.position.width) / atlas.width, (atlas.height - parts[i].attr.position.y) / atlas.height);
                atlasInfo.uvDetails[i].uvTR = new Vector2((parts[i].attr.position.x + parts[i].attr.position.width) / atlas.width, (atlas.height - parts[i].attr.position.y - parts[i].attr.position.height) / atlas.height);
                atlasInfo.uvDetails[i].uvBL = new Vector2(parts[i].attr.position.x / atlas.width, (atlas.height - parts[i].attr.position.y) / atlas.height);
                atlasInfo.uvDetails[i].uvBR = new Vector2(parts[i].attr.position.x / atlas.width, (atlas.height - parts[i].attr.position.y - parts[i].attr.position.height) / atlas.height);
                atlasInfo.uvDetails[i].height = parts[i].image.width;
                atlasInfo.uvDetails[i].width = parts[i].image.height;
            }
            else
            {
                atlasInfo.uvDetails[i].uvTL = new Vector2(parts[i].attr.position.x / atlas.width, (atlas.height - parts[i].attr.position.y) / atlas.height);
                atlasInfo.uvDetails[i].uvTR = new Vector2((parts[i].attr.position.x + parts[i].attr.position .width)/ atlas.width, (atlas.height - parts[i].attr.position.y) / atlas.height);
                atlasInfo.uvDetails[i].uvBL = new Vector2(parts[i].attr.position.x / atlas.width, (atlas.height - parts[i].attr.position.y - parts[i].attr.position.height) / atlas.height);
                atlasInfo.uvDetails[i].uvBR = new Vector2((parts[i].attr.position.x + parts[i].attr.position.width) / atlas.width, (atlas.height - parts[i].attr.position.y - parts[i].attr.position.height) / atlas.height);
                atlasInfo.uvDetails[i].width = parts[i].image.width;
                atlasInfo.uvDetails[i].height = parts[i].image.height;
            }
        }

        string localAtlasPath = exportPath.Remove(0, exportPath.IndexOf("Assets/")) + ".png";
        TextureImporter importer = AssetImporter.GetAtPath(localAtlasPath) as TextureImporter;
        importer.textureType = TextureImporterType.Sprite;
        importer.npotScale = TextureImporterNPOTScale.None;
        importer.spriteImportMode = SpriteImportMode.Multiple;
        importer.spritePackingTag = string.Empty;
        importer.spritePixelsToUnits = 100;
        importer.spritesheet = spriteData;
        importer.filterMode = FilterMode.Bilinear;
        importer.maxTextureSize = maxSize;
        importer.textureFormat = TextureImporterFormat.AutomaticTruecolor;

        AssetDatabase.ImportAsset(localAtlasPath);
        DestroyImmediate(atlas);

        string atlasInfoPath = exportPath.Remove(0, exportPath.IndexOf("Assets/")) + ".asset";
        AssetDatabase.CreateAsset(atlasInfo, atlasInfoPath);

        AssetDatabase.Refresh();

        Debug.Log("OK(!): Atlas image have been successfully exported to " + localAtlasPath);
    }

    private List<FileInfo> GetImageFilesFromDirectory(DirectoryInfo importDirectory)
    {
        string[] files = Directory.GetFiles(importDirectory.FullName, "*.*", (subDirectories) ? SearchOption.AllDirectories : SearchOption.TopDirectoryOnly)
            .Where(s => s.ToLower().EndsWith(".png") || s.ToLower().EndsWith(".tga") || s.ToLower().EndsWith(".jpg") ||
                    s.ToLower().EndsWith(".psd") || s.ToLower().EndsWith(".dds")).ToArray();
        List<FileInfo> fileList = new List<FileInfo>();
        foreach (string p in files)
            fileList.Add(new FileInfo(p));

        ImageAtlas.AlphanumComparatorFast comparison = new ImageAtlas.AlphanumComparatorFast();
        fileList.Sort(comparison);

        return new List<FileInfo>(fileList);
    }

    private void Pack()
    {
        if (autoArrange)
            ImageAtlas.PackParts(ref parts, out packMethod, out maxSize, spacing, out atlasSize);
        else
            ImageAtlas.PackParts(ref parts, packMethod, maxSize, spacing, out atlasSize);
        Debug.Log("Last Action: Pack");
    }

    #endregion

    #region GUILayout Overloads

    private static class GUIX
    {
        public static void LabelCentered(string label, int width)
        {
            EditorGUILayout.BeginHorizontal(GUILayout.Width(width));
            GUILayout.FlexibleSpace();
            GUILayout.Label(label);
            GUILayout.FlexibleSpace();
            EditorGUILayout.EndHorizontal();
        }

        public static void Line()
        {
            EditorGUILayout.BeginHorizontal();
            GUILayout.FlexibleSpace();
            GUILayout.Box("", GUILayout.Height(3), GUILayout.Width(100));
            GUILayout.FlexibleSpace();
            EditorGUILayout.EndHorizontal();
        }

        public static void LineDotted()
        {
            EditorGUILayout.BeginHorizontal();
            GUILayout.FlexibleSpace();
            GUILayout.Box("", GUILayout.Height(3), GUILayout.Width(15));
            GUILayout.Space(5);
            GUILayout.Box("", GUILayout.Height(3), GUILayout.Width(15));
            GUILayout.Space(5);
            GUILayout.Box("", GUILayout.Height(3), GUILayout.Width(15));
            GUILayout.Space(5);
            GUILayout.Box("", GUILayout.Height(3), GUILayout.Width(15));
            GUILayout.Space(5);
            GUILayout.Box("", GUILayout.Height(3), GUILayout.Width(15));
            GUILayout.Space(5);
            GUILayout.Box("", GUILayout.Height(3), GUILayout.Width(15));
            GUILayout.FlexibleSpace();
            EditorGUILayout.EndHorizontal();
        }
    }

    #endregion
}