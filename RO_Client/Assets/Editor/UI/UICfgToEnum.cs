using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEngine;
using UnityEditor;
using LuaInterface;

public class UICfgToEnum : AssetPostprocessor
{
    private const string UICFGLUA_PATH = "Assets/Lua/Config/UICfg.lua";
    private const string ENUM_TARGET_PATH = "Assets/Lua/Enum/UIPageName.lua";

    public void OnPreprocessAsset()
    {
        if (assetPath == UICFGLUA_PATH)
        {
            WriteFile();
        }
    }

    private bool FormatEnum(ref StringBuilder stringBuilder)
    {
        bool success = false;
        try
        {
            if (Application.isPlaying)
            {
                var fieldInfo = typeof(LuaState).GetField("mainState", System.Reflection.BindingFlags.Static | System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.NonPublic);
                LuaState luaState = (LuaState)fieldInfo.GetValue(null);
                if (luaState != null)
                {
                    fieldInfo = typeof(LuaState).GetField("beStart", System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.NonPublic);
                    bool beStart = (bool)fieldInfo.GetValue(luaState);
                    if (beStart)
                    {
                        FormatEnumValue(luaState, ref stringBuilder);
                        success = true;
                    }
                }
            }
            else
            {
                using(LuaState luaState = new LuaState())
                {
                    luaState.Start();
                    FormatEnumValue(luaState, ref stringBuilder);
                    success = true;
                }
            }
        }
        catch(System.Exception e)
        {
            Debug.LogException(e);
        }
        return success;
    }

    private void FormatEnumValue(LuaState luaState, ref StringBuilder stringBuilder)
    {
        using(var luaTable = luaState.DoFile<LuaTable>(assetPath))
        {
            using(var luaDictTable = luaTable.ToDictTable<int, LuaTable>())
            {
                int min = 0;
                int max = 0;
                Dictionary<int, string> datas = new Dictionary<int, string>();
                foreach (var item in luaDictTable)
                {
                    int id = item.Key;
                    string name = (item.Value["name"]).ToString();
                    datas[id] = name;
                    if (min > id)
                    {
                        min = id;
                    }
                    if (max < id)
                    {
                        max = id;
                    }
                }
                int lastVaildId = min;
                for (int i = min; i <= max; i ++)
                {
                    if (datas.ContainsKey(i))
                    {
                        if ((lastVaildId + 1) != i)
                        {
                            stringBuilder.AppendLine();
                        }
                        stringBuilder.Append("\t");
                        stringBuilder.Append(datas[i]);
                        stringBuilder.Append(" = ");
                        stringBuilder.Append(i);
                        stringBuilder.AppendLine(",");
                        lastVaildId = i;
                    }
                }
            }
        }
    }

    private void WriteFile()
    {
        StringBuilder stringBuilder = new StringBuilder();
        stringBuilder.AppendLine("local UIPageName = {");
        bool success = FormatEnum(ref stringBuilder);
        if (success)
        {
            stringBuilder.AppendLine("}");
            stringBuilder.Append("return setmetatable(UIPageName, { __index = Enum.UIPageName })");
            try
            {
                bool needWrite = true;
                string newStr = stringBuilder.ToString();
                UTF8Encoding uTF8Encoding = new UTF8Encoding(false);
                if (File.Exists(ENUM_TARGET_PATH))
                {
                    string oldStr = File.ReadAllText(ENUM_TARGET_PATH, uTF8Encoding);
                    if (newStr == oldStr)
                    {
                        needWrite = false;
                    }
                }
                else
                {
                    var fs = File.Create(ENUM_TARGET_PATH);
                    fs.Dispose();
                }
                if (needWrite)
                {
                    File.WriteAllText(ENUM_TARGET_PATH, newStr, uTF8Encoding);
                }
            }
            catch(System.Exception e)
            {
                Debug.LogException(e);
            }
        }
    }
}
