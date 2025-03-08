using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using LuaInterface;

//此类为测试用例类，正式发布不会执行
public class TestLuaTableConf : SingletonMono<TestLuaTableConf>
{
    public bool noDo = true;

    public void ParseLuaTableConf(LuaTable luaTable_)
    {
        LuaTable luaTable = luaTable_;
        LuaTable lt = (LuaTable)luaTable["Actor"];
        LuaTable lt1 = (LuaTable)luaTable["Building"];
        //第一种方式的解析
        for (int i = 1; i <= lt.Length; ++i)
        {
            LuaTable ltt = (LuaTable)lt[i];
            //string str1 = ltt["id"].ToString();
            //string str2 = ltt["pos"].ToString();
            //string str3 = ltt["dir"].ToString();
            //Vector3 vec1 = RYZUtil.ConverVector3Float(str2);
            //Vector3 vec2 = RYZUtil.ConverVector3Int(str3);
            //DebugHelper.Log(vec1);
            //DebugHelper.Log(vec2);
        }
        //第二种方式的解析
        for (int i = 1; i <= lt1.Length; ++i)
        {
            LuaTable ltt = (LuaTable)lt1[i];
            for (int j = 1; j <= ltt.Length; ++j)
            {
                //string str = ltt[j].ToString();
                //DebugHelper.Log(str);
            }
        }

        //使用另外一种方式获取lua配置文件信息
        if (noDo)
        {
            noDo = false;
            Test();            
        }
        
    }

    public void Test()
    {
        //LuaTable luaTable = LuaUtil.GetLuaTable2Func("TestPreAsset");
        //if(luaTable != null)
        //{
        //    ParseLuaTableConf(luaTable);
        //}
    }
}
