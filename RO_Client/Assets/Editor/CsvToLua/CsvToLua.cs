using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;
using UnityEditor;
using System.Text;
using System;

public class CsvToLua : EditorWindow
{
    public static string CSV_PATH = "csv path";
    public static string LUA_PATH = "lua path";
    public static string START_LINE = "start line";

    public string tableDirectoryName;
    public string luaDirectoryName;
    public int startDataLine = 1;


    [MenuItem("Tools/CsvToLua")]
    static void Init()
    {
        CsvToLua window = (CsvToLua)GetWindow(typeof(CsvToLua));
        window.Show();
    }

    void OnEnable()
    {
        tableDirectoryName = EditorPrefs.GetString(CSV_PATH);
        luaDirectoryName = EditorPrefs.GetString(LUA_PATH);
        startDataLine = EditorPrefs.GetInt(START_LINE);
    }

    void OnDisable()
    {
        EditorPrefs.SetString(CSV_PATH, tableDirectoryName);
        EditorPrefs.SetString(LUA_PATH, luaDirectoryName);
        EditorPrefs.SetInt(START_LINE, startDataLine);
    }

    private void OnGUI()
    {
        GUILayout.Label("Base Settings", EditorStyles.boldLabel);

        EditorGUILayout.BeginHorizontal();
        tableDirectoryName = EditorGUILayout.TextField("TableDirectory Name", tableDirectoryName);
        if (GUILayout.Button("选择csv路径", GUILayout.Width(200)))
        {
            tableDirectoryName = GetFilePath();
        }
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.BeginHorizontal();
        luaDirectoryName = EditorGUILayout.TextField("LuaDirectory Name", luaDirectoryName);
        if (GUILayout.Button("选择到处table路径", GUILayout.Width(200)))
        {
            luaDirectoryName = GetFilePath();
        }
        EditorGUILayout.EndHorizontal();

        startDataLine = EditorGUILayout.IntField("StartDataLine", startDataLine);

        if (GUILayout.Button("CsvToLua"))
            Change();
    }

    public static string GetFilePath()
    {
        OpenDialogDir ofn2 = new OpenDialogDir();
        ofn2.pszDisplayName = new string(new char[2000]); ;     // 存放目录路径缓冲区    
        ofn2.lpszTitle = "Open Project";// 标题    
                                        //ofn2.ulFlags = BIF_NEWDIALOGSTYLE | BIF_EDITBOX; // 新的样式,带编辑框    
        IntPtr pidlPtr = DllOpenFileDialog.SHBrowseForFolder(ofn2);

        char[] charArray = new char[2000];
        for (int i = 0; i < 2000; i++)
            charArray[i] = '\0';

        DllOpenFileDialog.SHGetPathFromIDList(pidlPtr, charArray);
        string fullDirPath = new String(charArray);
        fullDirPath = fullDirPath.Substring(0, fullDirPath.IndexOf('\0'));
        return fullDirPath;
    }

    public void Change()
    {
        Debug.Log(tableDirectoryName);
        foreach (var item in Directory.GetFiles(tableDirectoryName))
        {
            if (item.Contains(".meta"))
                continue;

            CreatLuaTable(item);
        }
    }

    void CreatLuaTable(string filePath)
    {
        CreatDirectory();
        Save(GetSavePath(filePath), GetSaveContext(filePath));
    }

    void CreatDirectory()
    {
        string path = luaDirectoryName;
        if (!Directory.Exists(path))
        {
            Directory.CreateDirectory(path);
            AssetDatabase.Refresh();
        }
    }

    string GetSavePath(string filePath)
    {
        string fileName = GetFileName(filePath);
        return luaDirectoryName + "/" + fileName + ".lua";
    }

    string GetFileName(string filePath)
    {
        string targetPath = filePath.Replace(@"\", "/");
        string[] strs = targetPath.Split('/');
        targetPath = strs[strs.Length - 1];
        strs = targetPath.Split('.');
        string fileName = strs[0];

        return fileName;
    }

    string GetSaveContext(string filePath)
    {
        string fileName = GetFileName(filePath);

        List<string> context = GetContext(filePath);
        string[] propertyName = GetPropertyName(context[1]);
        string[] typeName = GetPropertyName(context[2]);

        StringBuilder sb = new StringBuilder();
        sb.Append("local " + fileName + " = {" + "\n");

        for (int i = startDataLine; i < context.Count; i++)
        {
            context[i] = context[i].Replace(" ", "");
            string[] details = context[i].Split(',');

            sb.Append("[" + details[0] + "]={" + "\n");

            for (int j = 0; j < propertyName.Length; j++)
            {
                sb.Append("['" + propertyName[j] + "']=");
                if (typeName[j].Equals("string"))
                    sb.Append("'" + details[j] + "'," + "\n");
                else if (typeName[j].Equals("bool"))
                {
                    sb.Append(details[j].ToLower() + "," + "\n");
                }
                else if (typeName[j].Equals("list"))
                {
                    if (details[j].IndexOf(';') > 0)
                    {
                        ParseTable(sb, details[j], ';');
                    }
                    else if (details[j].IndexOf(':') > 0 && details[j].IndexOf(';') < 0)
                    {
                        sb.Append("{");
                        ParseTable(sb, details[j], ':');
                        sb.Append("}");
                    }
                    else
                    {
                        sb.Append("{");
                        try
                        {
                            if (details[j].IndexOf('.') > 0)
                            {
                                Convert.ToDouble(details[j]);
                            }
                            else
                            {
                                Convert.ToInt32(details[j]);
                            }
                            sb.Append(details[j]);
                        }
                        catch
                        {
                            if (!string.IsNullOrEmpty(details[j]))
                                sb.Append("'" + details[j] + "'");
                        }
                        sb.Append("}");
                    }
                    sb.Append(",\n");
                }
                else if (typeName[j].Equals("enum"))
                {
                    sb.Append("Enum." + propertyName[j] + "." + details[j] + "," + "\n");
                }
                else
                {
                    string num = "0";
                    if (details[j] != "")
                    {
                        num = details[j];
                    }
                    sb.Append(num + "," + "\n");
                }
            }

            sb.Append("}," + "\n");
        }

        sb.Append("}" + "\n");
        sb.Append("return " + fileName);
        return sb.ToString();
    }

    void ParseTable(StringBuilder sb, string content, char split)
    {
        string[] strs = content.Split(split);
        sb.Append("{");
        for (int m = 0; m < strs.Length; ++m)
        {
            try
            {
                if (strs[m].IndexOf(':') > 0)
                {
                    ParseTable(sb, strs[m], ':');
                }
                else
                {
                    if (strs[m].IndexOf('.') > 0)
                    {
                        Convert.ToDouble(strs[m]);
                    }
                    else
                    {
                        Convert.ToInt32(strs[m]);
                    }
                    sb.Append(strs[m]);
                }
            }
            catch
            {
                if (!string.IsNullOrEmpty(strs[m]))
                    sb.Append("'" + strs[m] + "'");
            }
            if (m < strs.Length - 1)
            {
                sb.Append(",");
            }
        }
        sb.Append("}");
    }

    List<string> GetContext(string filePath)
    {
        StreamReader sr = new StreamReader(filePath);
        List<string> contexts = new List<string>();
        string line;
        while ((line = sr.ReadLine()) != null)
            contexts.Add(line);

        return contexts;
    }

    string[] GetPropertyName(string line)
    {
        string[] names = line.Split(',');
        return names;
    }

    void Save(string path, string information)
    {
        if (File.Exists(path))
            File.Delete(path);

        FileStream aFile = new FileStream(@"" + path, FileMode.OpenOrCreate, FileAccess.ReadWrite);
        StreamWriter sw = new StreamWriter(aFile);
        sw.Write(information);
        sw.Close();
        sw.Dispose();
        aFile.Close();
        aFile.Dispose();
        sw = null;
        aFile = null;

        AssetDatabase.Refresh();
    }
}