using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;
using UnityEngine;

public class AssetsObscureUtil
{
    private const string c_ObscureKey = "AssetsObscureKey";
    private const string c_ObscureOffsetMin = "AssetsObscureOffsetMin";
    private const string c_ObscureOffsetValues = "AssetsObscureOffsetValues";
    private static string s_ObscureKey = string.Empty;
    private static uint s_ObscureOffsetMin = 0;
    private static int[] s_ObscureOffsetValues = null;

    public static string GetObscureKey()
    {
        return s_ObscureKey;
    }

    public static uint GetObscureOffsetMin()
    {
        return s_ObscureOffsetMin;
    }

    public static int[]  GetObscureOffsetValues()
    {
        return s_ObscureOffsetValues;
    }

    internal static void InitAssetsObscureConfig(ref Dictionary<string, string> assetsMappingDict)
    {
        string key = c_ObscureKey.ToLower();
        if (assetsMappingDict.ContainsKey(key))
        {
            s_ObscureKey = assetsMappingDict[key];
            assetsMappingDict.Remove(key);
        }
        key = c_ObscureOffsetMin.ToLower();
        if (assetsMappingDict.ContainsKey(key))
        {
            if (!uint.TryParse(assetsMappingDict[key], out s_ObscureOffsetMin))
            {
                s_ObscureOffsetMin = 0;
            }
            assetsMappingDict.Remove(key);
        }
        key = c_ObscureOffsetValues.ToLower();
        if (assetsMappingDict.ContainsKey(key))
        {
            string content = assetsMappingDict[key];
            if (!string.IsNullOrEmpty(content))
            {
                string[] values = content.Split('/');
                List<int> ls = new List<int>();
                for (int i = 0, iMax = values.Length; i < iMax; i++)
                {
                    int value;
                    if (int.TryParse(values[i], out value))
                    {
                        ls.Add(value);
                    }
                }
                if (ls.Count > 0)
                {
                    s_ObscureOffsetValues = ls.ToArray();
                }
            }
            assetsMappingDict.Remove(key);
        }
    }

    public static void WriteInfoData(ref StringBuilder stringBuilder)
    {
        if (stringBuilder == null) return;
        if (!string.IsNullOrEmpty(s_ObscureKey))
        {
            stringBuilder.Append(c_ObscureKey);
            stringBuilder.Append(",");
            stringBuilder.Append(s_ObscureKey);
            stringBuilder.Append("\r\n");
        }
        if (s_ObscureOffsetMin != 0)
        {
            stringBuilder.Append(c_ObscureOffsetMin);
            stringBuilder.Append(",");
            stringBuilder.Append(s_ObscureOffsetMin);
            stringBuilder.Append("\r\n");
        }
        if (s_ObscureOffsetValues != null && s_ObscureOffsetValues.Length > 0)
        {
            stringBuilder.Append(c_ObscureOffsetValues);
            stringBuilder.Append(",");
            for (int i = 0, iMax = s_ObscureOffsetValues.Length; i < iMax; i++)
            {
                if (i != 0)
                {
                    stringBuilder.Append("/");
                }
                stringBuilder.Append(s_ObscureOffsetValues[i]);
            }
            stringBuilder.Append("\r\n");
        }
    }

    public static bool IsObscure()
    {
        return !(string.IsNullOrEmpty(s_ObscureKey));
    }

    public static string GetABFileName(string abName)
    {
        if (IsObscure())
        {
            try
            {
                using(var md5 = new MD5CryptoServiceProvider())
                {
                    UTF8Encoding encoding = new UTF8Encoding(false);
                    byte[] bytes = encoding.GetBytes((abName + s_ObscureKey).ToLower());
                    bytes = md5.ComputeHash(bytes);
                    StringBuilder sb = new StringBuilder();
                    for (int i = 0; i < bytes.Length; i++)
                    {
                        sb.Append(bytes[i].ToString("x2"));
                    }
                    return sb.ToString();
                }
            }
            catch(Exception e)
            {
                Debug.LogException(e);
            }
        }
        return abName;
    }

    public static ulong GetABOffset(string abFileName)
    {
        if (IsObscure())
        {
            if (string.IsNullOrEmpty(abFileName))
            {
                return 0;
            }
            try
            {
                int length = abFileName.Length;
                if (length != 32)
                {
                    return 0;
                }
                if (s_ObscureOffsetValues == null) return 0;
                ulong offset = 0;
                for (int i = 0, iMax = s_ObscureOffsetValues.Length; i < iMax; i++)
                {
                    int pos = ConvertHexDigit(abFileName[s_ObscureOffsetValues[i]]);
                    if (pos < 0 || pos > 16)
                    {
                        return 0;
                    }
                    offset = offset + (uint)(pos * Mathf.Pow(16, i));
                }
                if (offset <= s_ObscureOffsetMin)
                {
                    offset = s_ObscureOffsetMin + offset;
                }
                return offset;
            }
            catch(Exception e)
            {
                Debug.LogException(e);
            }
        }
        return 0;
    }

    private static int ConvertHexDigit(char val)
	{
		if (val <= '9' && val >= '0')
		{
			return val - 48;
		}
		if (val >= 'a' && val <= 'f')
		{
			return val - 97 + 10;
		}
		if (val >= 'A' && val <= 'F')
		{
			return val - 65 + 10;
		}
		return 0;
	}

    public static string GetUniqueValue()
    {
        if (string.IsNullOrEmpty(s_ObscureKey))
        {
            return string.Empty;
        }
        string value = s_ObscureKey + s_ObscureOffsetMin;
        if (s_ObscureOffsetValues != null && s_ObscureOffsetValues.Length > 0)
        {
            for (int i = 0, iMax = s_ObscureOffsetValues.Length; i < iMax; i++)
            {
                value = value + s_ObscureOffsetValues[i];
            }
        }
        return value;
    }
}
