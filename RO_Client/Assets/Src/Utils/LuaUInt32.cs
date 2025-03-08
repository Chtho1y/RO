using System;
using UnityEngine;

public class LuaUInt32
{
    public static byte[] FromString(string str)
    {
        str = str.Replace("#", "");
        UInt32 v;
        UInt32.TryParse(str, out v);
        Debug.Log(v);
        return BitConverter.GetBytes(v);
    }
    
    public static UInt32 BytesToUInt32(byte[] v)
    {
        return BitConverter.ToUInt32(v, 0);
    }
}