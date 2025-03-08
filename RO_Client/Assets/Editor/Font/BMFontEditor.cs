using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using System.Text.RegularExpressions;
using System.Xml;
using UnityEditor;
using UnityEngine;
using Debug = UnityEngine.Debug;

public class BMFontTools : EditorWindow
{
    private string configDirPath;
    private string configFlag = "# imported icon images";
    //字体文件的生成路径
    private string _fontDirPath;
    private Vector2 _scrollPos;
    private bool _showBMConfig;
    private bool _showBMInfo;
    private string _currentSelect = string.Empty;
    private struct FontInfo
    {
        //图片路径
        public string ImgPath;
        //字符
        public char charInfo;
    }
    private List<FontInfo> _fontInfoList = new List<FontInfo>();
    private List<string> _filesList;
    private List<string> _filesNameList;
    private void Awake()
    {
        configDirPath = Path.Combine(Application.dataPath, "../BMFont");
        _fontDirPath = Path.Combine(Application.dataPath, "Content/Fonts");
        _initConfigInfo();
    }

    private void _initConfigInfo()
    {
        _filesList = new List<string>(Directory.GetFiles(configDirPath, "*.bmfc"));
        _filesNameList = new List<string>();
        for (int i = 0; i < _filesList.Count; i++)
        {
            _filesNameList.Add(Path.GetFileNameWithoutExtension(_filesList[i]));
        }
    }

    [MenuItem("RO_Tool/BMFontTools", false, 13)]
    private static void MyBMFontTools()
    {
        BMFontTools bmFont = new BMFontTools();
        bmFont.Show();
    }

    private void _setBMFontConfigs()
    {
        _showBMConfig = EditorGUILayout.Foldout(_showBMConfig, "BMFont Configs");
        if (_showBMConfig)
        {
            for (int i = 0; i < _filesList.Count; i++)
            {
                GUILayout.BeginHorizontal();
                GUI.enabled = false;
                EditorGUILayout.TextField(_filesList[i], GUILayout.MaxWidth(400));
                GUI.enabled = true;
                EditorGUILayout.LabelField("FontName:", GUILayout.MaxWidth(80));
                _filesNameList[i] = EditorGUILayout.TextField(_filesNameList[i], GUILayout.MaxWidth(100));
                if (GUILayout.Button("Reset Name"))
                {
                    Regex regex = new Regex(@"/|\\|<|>|\*|\?");
                    if (!string.IsNullOrEmpty(_filesNameList[i]) && !regex.IsMatch(_filesNameList[i]))
                    {
                        string fileNameTemp = _filesList[i].Replace(Path.GetFileNameWithoutExtension(_filesList[i]), _filesNameList[i]);
                        if (File.Exists(fileNameTemp))
                        {
                            Debug.LogError("文件冲突，命名失败");
                        }
                        else
                        {
                            File.Move(_filesList[i], fileNameTemp);
                        }
                        _initConfigInfo();
                    }
                    else
                    {
                        Debug.LogError("文件名非法或为空，命名失败");
                    }
                }
                if (GUILayout.Button("Select"))
                {
                    _currentSelect = _filesList[i];
                    _fontInfoList = _analysisConfig(_currentSelect);
                }
                GUILayout.EndHorizontal();
            }
        }
        GUI.color = Color.green;
        EditorGUILayout.LabelField("CurrentSelect：", _currentSelect);
        GUI.color = Color.white;
        if (GUILayout.Button("New Font Config"))
        {
            File.WriteAllText(Path.Combine(configDirPath, string.Format("{0}.bmfc",
                DateTime.Now.ToString("yyyyMMddhhmmss"))), configFlag, Encoding.UTF8);
            _initConfigInfo();
        }
    }

    private void _setConfigInfo()
    {
        _showBMInfo = EditorGUILayout.Foldout(_showBMInfo, "BMFont Info");
        if (_showBMInfo && !string.IsNullOrEmpty(_currentSelect))
        {
            for (int i = 0; i < _fontInfoList.Count; i++)
            {
                EditorGUILayout.BeginHorizontal();
                if (GUILayout.Button("Select Img", GUILayout.MaxWidth(100)))
                {
                    string pathTemp = EditorUtility.OpenFilePanelWithFilters("选择图片",
                          string.Format("{0}\\GameMin\\UI\\UISprites", Application.dataPath.Replace('/', '\\')),
                         new string[] { "Image", "png" });
                    if (!string.IsNullOrEmpty(pathTemp))
                    {
                        FontInfo fontInfo = new FontInfo();
                        fontInfo.charInfo = _fontInfoList[i].charInfo;
                        fontInfo.ImgPath = _formatPath(pathTemp);
                        _fontInfoList[i] = fontInfo;
                    }
                }
                EditorGUILayout.LabelField("Char:", GUILayout.MaxWidth(55));

                FontInfo info = new FontInfo();
                if (!string.IsNullOrEmpty(_fontInfoList[i].charInfo.ToString()))
                {
                    string temp = EditorGUILayout.TextField(_fontInfoList[i].charInfo.ToString(), GUILayout.MaxWidth(30));
                    if (temp.Length == 1 && Regex.IsMatch(temp, "[\x20-\x7e]"))
                    {
                        info.charInfo = temp[0];
                        info.ImgPath = _fontInfoList[i].ImgPath;
                        _fontInfoList[i] = info;
                    }
                }

                EditorGUILayout.LabelField("ImgPath:", GUILayout.MaxWidth(55));
                GUI.enabled = false;
                EditorGUILayout.TextField(_fontInfoList[i].ImgPath);
                GUI.enabled = true;
                EditorGUILayout.EndHorizontal();
            }
            if (GUILayout.Button("Add"))
            {
                _fontInfoList.Add(new FontInfo());
            }
            if (GUILayout.Button("Save And Export Font"))
            {
                _saveFontAndExport();
            }
        }
    }

    private void _saveFontAndExport()
    {
        //保存配置文件
        string baseFontInfo = File.ReadAllText(configDirPath + "/BaseConfig.bmf");
        baseFontInfo += "\n";
        for (int i = 0; i < _fontInfoList.Count; i++)
        {
            if (string.IsNullOrEmpty(_fontInfoList[i].ImgPath) ||
                string.IsNullOrEmpty(_fontInfoList[i].charInfo.ToString()))
            {
                continue;
            }
            string info = string.Format("icon=\"{0}\",{1},0,0,0\n", _fontInfoList[i].ImgPath,
                (int)_fontInfoList[i].charInfo);
            baseFontInfo += info;
        }
        File.WriteAllText(_currentSelect, baseFontInfo);

        _exportFontInfo();

        AssetDatabase.Refresh();
    }

    private void _exportFontInfo()
    {
        string fileName = Path.GetFileNameWithoutExtension(_currentSelect);
        string targetDir = Path.Combine(_fontDirPath, fileName);
        if (!Directory.Exists(targetDir))
        {
            Directory.CreateDirectory(targetDir);
        }
        Process process = new Process();
        string batPath = Path.Combine(configDirPath, "BMFontGenerate.bat");
        process.StartInfo.FileName = batPath;
        process.StartInfo.WorkingDirectory = configDirPath;
        process.StartInfo.Arguments =
            string.Format("{0} {1}", _currentSelect, Path.Combine(_fontDirPath, targetDir + "/" + fileName));
        process.Start();
        process.WaitForExit();
        AssetDatabase.Refresh();
        _genFontInfo(targetDir, fileName);
    }

    private string _getAssetPath(string path)
    {
        string pathTemp = path.Replace("\\", "/");
        pathTemp = pathTemp.Replace(Application.dataPath, "Assets");
        return pathTemp;
    }

    private void _genFontInfo(string fontDirPath, string fileName)
    {
        string matPath = Path.Combine(fontDirPath, fileName + "_0.mat");
        Material mat = AssetDatabase.LoadAssetAtPath<Material>(_getAssetPath(matPath));
        if (mat == null)
        {
            mat = new Material(Shader.Find("UI/Default Font"));
            AssetDatabase.CreateAsset(mat, _getAssetPath(matPath));
        }
        string texturePath = Path.Combine(fontDirPath, fileName + "_0.png");
        Texture _fontTexture = AssetDatabase.LoadAssetAtPath<Texture>(_getAssetPath(texturePath));
        mat = AssetDatabase.LoadAssetAtPath<Material>(_getAssetPath(matPath));
        mat.SetTexture("_MainTex", _fontTexture);

        string fontPath = Path.Combine(fontDirPath, fileName + ".fontsettings");
        Font font = AssetDatabase.LoadAssetAtPath<Font>(_getAssetPath(fontPath));
        if (font == null)
        {
            font = new Font();
            AssetDatabase.CreateAsset(font, _getAssetPath(fontPath));
        }
        string fontConfigPath = Path.Combine(fontDirPath, fileName + ".fnt");
        List<CharacterInfo> chars = _getFontInfo(fontConfigPath, _fontTexture);
        font.material = mat;
        _serializeFont(font, chars, 1);
        File.Delete(fontConfigPath);
        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();
    }

    private List<CharacterInfo> _getFontInfo(string fontConfig, Texture texture)
    {
        XmlDocument xml = new XmlDocument();
        xml.Load(fontConfig);
        List<CharacterInfo> chtInfoList = new List<CharacterInfo>();
        XmlNode node = xml.SelectSingleNode("font/chars");
        foreach (XmlNode nd in node.ChildNodes)
        {
            XmlElement xe = (XmlElement)nd;
            int x = int.Parse(xe.GetAttribute("x"));
            int y = int.Parse(xe.GetAttribute("y"));
            int width = int.Parse(xe.GetAttribute("width"));
            int height = int.Parse(xe.GetAttribute("height"));
            int advance = int.Parse(xe.GetAttribute("xadvance"));
            CharacterInfo info = new CharacterInfo();
            info.glyphHeight = texture.height;
            info.glyphWidth = texture.width;
            info.index = int.Parse(xe.GetAttribute("id"));
            //这里注意下UV坐标系和从BMFont里得到的信息的坐标系是不一样的哦，前者左下角为（0,0），
            //右上角为（1,1）。而后者则是左上角上角为（0,0），右下角为（图宽，图高）
            info.uvTopLeft = new Vector2((float)x / texture.width, 1 - (float)y / texture.height);
            info.uvTopRight = new Vector2((float)(x + width) / texture.width, 1 - (float)y / texture.height);
            info.uvBottomLeft = new Vector2((float)x / texture.width, 1 - (float)(y + height) / texture.height);
            info.uvBottomRight = new Vector2((float)(x + width) / texture.width, 1 - (float)(y + height) / texture.height);

            info.minX = 0;
            info.minY = -height;
            info.maxX = width;
            info.maxY = 0;

            info.advance = advance;

            chtInfoList.Add(info);
        }
        return chtInfoList;
    }

    private static void _setLineHeight(SerializedObject font, float height)
    {
        font.FindProperty("m_LineSpacing").floatValue = height;
    }

    private static SerializedObject _serializeFont(Font font, List<CharacterInfo> chars, float lineHeight)
    {
        SerializedObject serializedFont = new SerializedObject(font);
        _setLineHeight(serializedFont, lineHeight);
        _serializeFontCharInfos(serializedFont, chars);
        serializedFont.ApplyModifiedProperties();
        return serializedFont;
    }

    private static void _serializeFontCharInfos(SerializedObject font, List<CharacterInfo> chars)
    {
        SerializedProperty charRects = font.FindProperty("m_CharacterRects");
        charRects.arraySize = chars.Count;
        for (int i = 0; i < chars.Count; ++i)
        {
            CharacterInfo info = chars[i];
            SerializedProperty prop = charRects.GetArrayElementAtIndex(i);
            SerializeCharInfo(prop, info);
        }
    }

    public static void SerializeCharInfo(SerializedProperty prop, CharacterInfo charInfo)
    {
        prop.FindPropertyRelative("index").intValue = charInfo.index;
        prop.FindPropertyRelative("uv").rectValue = charInfo.uv;
        prop.FindPropertyRelative("vert").rectValue = charInfo.vert;
        prop.FindPropertyRelative("advance").floatValue = charInfo.advance;
        prop.FindPropertyRelative("flipped").boolValue = false;
    }

    private void OnGUI()
    {
        _scrollPos = EditorGUILayout.BeginScrollView(_scrollPos);
        EditorGUILayout.BeginVertical();
        EditorGUILayout.BeginHorizontal();
        GUILayout.Label("Font Save Path:", GUILayout.MaxWidth(100));
        GUILayout.TextField(_fontDirPath);
        EditorGUILayout.EndHorizontal();
        _setBMFontConfigs();

        _setConfigInfo();

        EditorGUILayout.EndVertical();
        EditorGUILayout.EndScrollView();
    }

    private List<FontInfo> _analysisConfig(string configPath)
    {
        List<FontInfo> infoList = new List<FontInfo>();
        string[] fileInfo = File.ReadAllLines(configPath);
        bool isGetInfoFlag = false;
        for (int i = 0; i < fileInfo.Length; i++)
        {
            if (fileInfo[i].Contains(configFlag) || isGetInfoFlag)
            {
                if (!isGetInfoFlag)
                {
                    i++;
                    isGetInfoFlag = true;
                }
                if (i < fileInfo.Length && !string.IsNullOrEmpty(fileInfo[i]))
                {
                    infoList.Add(_getFontInfoByStr(fileInfo[i]));
                }
            }
        }
        return infoList;
    }

    private FontInfo _getFontInfoByStr(string str)
    {
        string[] strTemp = str.Split(',');
        FontInfo fontInfo = new FontInfo();
        string strPathTemp = string.Empty;
        for (int i = 0; i < strTemp.Length; i++)
        {
            if (_isOddDoubleQuota(strTemp[i]))
            {
                strPathTemp += strTemp[i] + ",";
                if (!_isOddDoubleQuota(strPathTemp))
                {
                    strPathTemp = strPathTemp.Substring(0, strPathTemp.Length - 1);
                    break;
                }
            }
            else
            {
                strPathTemp = strTemp[i];
                break;
            }
        }
        fontInfo.ImgPath = strPathTemp.Replace("icon=\"", string.Empty).Replace("\"", string.Empty);
        fontInfo.charInfo = (char)int.Parse(strTemp[strTemp.Length - 4]);
        return fontInfo;
    }

    private bool _isOddDoubleQuota(string str)
    {
        return _getDoubleQuotaCount(str) % 2 == 1;
    }

    private int _getDoubleQuotaCount(string str)
    {
        string[] strArray = str.Split('"');
        int doubleQuotaCount = strArray.Length - 1;
        doubleQuotaCount = doubleQuotaCount < 0 ? 0 : doubleQuotaCount;
        return doubleQuotaCount;
    }

    private string _formatPath(string path)
    {
        path = path.Replace("\\", "/");
        return path;
    }
}