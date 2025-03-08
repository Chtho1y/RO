using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using LuaInterface;

public class LuaUtil
{
    public static void LuaDoFile(LuaState ls_, string name_)
    {

        //ls_.DoString(string.Format("require '{0}'", name_));
        if (ls_ != null)
            ls_.DoFile(name_);
    }

    public static T LuaDoFile<T>(LuaState ls_, string name_)
    {

        //ls_.DoString(string.Format("require '{0}'", name_));
        if (ls_ != null)
            return ls_.DoFile<T>(name_);

        return default(T);
    }


    public static void LuaRequire(LuaState ls_, string name_)
    {
 
        if (ls_ != null)
            ls_.Require(name_);
    }


    public static void LuaDoString(LuaState ls_, string strContent_)
    {
        ls_.DoString(strContent_);
    }

    public static void CallCS2Lua(string strFunc_)
    {
        if (!LuaMgr.HasInstance())
            return;

        LuaFunction func = LuaMgr.Instance.luaState.GetFunction(strFunc_);
        if(func!=null)
        {
            func.Call();
            func.Dispose();
            func = null;
        }
    }

    public static void CallCS2Lua(string strFunc_, params object[] args_)
    {
        if (!LuaMgr.HasInstance())
            return;

        LuaFunction func = LuaMgr.Instance.luaState.GetFunction(strFunc_);
        func.Call(args_);
        func.Dispose();
        func = null;
    }

    public static void CallCS2Lua<T1>(string strFunc_,T1 arg1)
    {
        if (!LuaMgr.HasInstance())
            return;

        LuaFunction func = LuaMgr.Instance.luaState.GetFunction(strFunc_);
        func.Call<T1>(arg1);
        func.Dispose();
        func = null;
    }

    public static void CallCS2Lua<T1,T2>(string strFunc_, T1 arg1,T2 arg2)
    {
        if (!LuaMgr.HasInstance())
            return;

        LuaFunction func = LuaMgr.Instance.luaState.GetFunction(strFunc_);
        func.Call<T1,T2>(arg1,arg2);
        func.Dispose();
        func = null;
    }

    public static void CallCS2Lua<T1, T2,T3>(string strFunc_, T1 arg1, T2 arg2,T3 arg3)
    {
        if (!LuaMgr.HasInstance())
            return;

        LuaFunction func = LuaMgr.Instance.luaState.GetFunction(strFunc_);
        func.Call<T1, T2,T3>(arg1, arg2,arg3);
        func.Dispose();
        func = null;
    }

    public static void CallCS2Lua<T1, T2, T3,T4>(string strFunc_, T1 arg1, T2 arg2, T3 arg3,T4 arg4)
    {
        if (!LuaMgr.HasInstance())
            return;

        LuaFunction func = LuaMgr.Instance.luaState.GetFunction(strFunc_);
        func.Call<T1, T2, T3,T4>(arg1, arg2, arg3,arg4);
        func.Dispose();
        func = null;
    }

    public static void CallCS2Lua<T1, T2, T3, T4,T5>(string strFunc_, T1 arg1, T2 arg2, T3 arg3, T4 arg4,T5 arg5)
    {
        if (!LuaMgr.HasInstance())
            return;

        LuaFunction func = LuaMgr.Instance.luaState.GetFunction(strFunc_);
        func.Call<T1, T2, T3, T4,T5>(arg1, arg2, arg3, arg4,arg5);
        func.Dispose();
        func = null;
    }

    public static void CallCS2Lua<T1, T2, T3, T4, T5,T6>(string strFunc_, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5,T6 arg6)
    {
        if (!LuaMgr.HasInstance())
            return;

        LuaFunction func = LuaMgr.Instance.luaState.GetFunction(strFunc_);
        func.Call<T1, T2, T3, T4, T5,T6>(arg1, arg2, arg3, arg4, arg5,arg6);
        func.Dispose();
        func = null;
    }

    public static void CallCS2Lua<T1, T2, T3, T4, T5, T6,T7>(string strFunc_, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6,T7 arg7)
    {
        if (!LuaMgr.HasInstance())
            return;

        LuaFunction func = LuaMgr.Instance.luaState.GetFunction(strFunc_);
        func.Call<T1, T2, T3, T4, T5, T6,T7>(arg1, arg2, arg3, arg4, arg5, arg6,arg7);
        func.Dispose();
        func = null;
    }

    public static void CallCS2Lua<T1, T2, T3, T4, T5, T6, T7,T8>(string strFunc_, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7,T8 arg8)
    {
        if (!LuaMgr.HasInstance())
            return;

        LuaFunction func = LuaMgr.Instance.luaState.GetFunction(strFunc_);
        func.Call<T1, T2, T3, T4, T5, T6, T7,T8>(arg1, arg2, arg3, arg4, arg5, arg6, arg7,arg8);
        func.Dispose();
        func = null;
    }

    public static void CallCS2Lua<T1, T2, T3, T4, T5, T6, T7, T8,T9>(string strFunc_, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8,T9 arg9)
    {
        if (!LuaMgr.HasInstance())
            return;

        LuaFunction func = LuaMgr.Instance.luaState.GetFunction(strFunc_);
        func.Call<T1, T2, T3, T4, T5, T6, T7, T8,T9>(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8,arg9);
        func.Dispose();
        func = null;
    }

    //public static object[] CallCS2LuaObject(string strFunc_, params object[] args_)
    //{
    //    if (!LuaMgr.HasInstance())
    //        return null;

    //    LuaFunction func = LuaMgr.Instance.luaState.GetFunction(strFunc_);
    //    return func.Call(args_);
    //}

    public static int CallCS2LuaInt(string strFunc_, LuaTable args_)
    {
        if (!LuaMgr.HasInstance())
            return 0;

        int iValue = 0;
        LuaFunction func = LuaMgr.Instance.luaState.GetFunction(strFunc_);
        func.BeginPCall();
        func.Push(args_);
        func.PCall();
        iValue = (int)func.CheckNumber();    
        func.EndPCall();
        func.Dispose();
        func = null;
        return iValue;
    }

    public static LuaTable CallCS2LuaTable(string strFunc_, object args_)
    {
        if (!LuaMgr.HasInstance())
            return null;

        LuaFunction func = LuaMgr.Instance.luaState.GetFunction(strFunc_);
        LuaTable table = func.Invoke<object, LuaTable>(args_);
        return table;
    }

    public static string GetUILuaPath(string scriptname_,string directoryName_=null)
    {
        int iIdx = scriptname_.LastIndexOf('/');
        if (-1 == iIdx)
        if(directoryName_==null)
        {
              return scriptname_ + "/" + scriptname_;
        }
        else
        {
              return directoryName_ + "/" + scriptname_;
        }
          
        else
            return scriptname_;
    }

    public static string GetLuaScriptModuleName(string scriptname_ )
    {
        int iIdx = scriptname_.LastIndexOf('/');
        if (-1 == iIdx)
            return scriptname_ + ".";
        string strRet = scriptname_.Substring(iIdx + 1);
        return strRet + ".";
    }

    //测试lua层发送过来的数据对象的处理
    //tips: 此lua文件必须包含字段LuaType，用来区分是什么类型配置文件
    public static void ReceiveLuaTable(LuaTable luaTable_)
    {
        string strLuaType = luaTable_["LuaType"].ToString();
        switch(strLuaType)
        {
            case "PreAsset":
                TestLuaTableConf.Instance.ParseLuaTableConf(luaTable_);
                break;
            case "TestAsset":

                break;
        }
    }

    //通过函数，获得lua层函数内返回的table数据对象
    //tips: 此函数strFunc_，必须在LuaTableConf2CS.lua文件内已经定义，否则取出值为null
    //public static LuaTable GetLuaTable2Func(string strFunc_)
    //{
    //    var objLua = CallCS2LuaObject(LuaUtil.GetLuaScriptModuleName("LuaTableConf2CS") + strFunc_)[0];
    //    if(objLua != null)
    //    {
    //        return (LuaTable)objLua;
    //    }
    //    else
    //    {
    //        DebugHelper.Log("Error...GetLuaTable2Func!!!");
    //    }

    //    return null;
    //}

    //public static LuaTable LuaTable2FuncArgs(string strFunc_, params object[] args_)
    //{
    //    var objLua = CallCS2LuaObject(LuaUtil.GetLuaScriptModuleName("LuaTableConf2CS") + strFunc_, args_)[0];
    //    if (objLua != null)
    //    {
    //        return (LuaTable)objLua;
    //    }
    //    else
    //    {
    //        DebugHelper.Log("Error...GetLuaTable2Func!!!");
    //    }

    //    return null;
    //}

    public static void CallLuaTableConf2CS(string strFunc_, params object[] args_)
    {
        CallCS2Lua(LuaUtil.GetLuaScriptModuleName("LuaTableConf2CS") + strFunc_, args_);
    }

    //public static LuaTable GetLuaTable2FuncAgrs(string filePath_)
    //{
    //    var objLua = CallCS2LuaObject(LuaUtil.GetLuaScriptModuleName("LuaTableConf2CS") + "GeLuaOpera2LT", filePath_)[0];
    //    if (objLua != null)
    //    {
    //        return (LuaTable)objLua;
    //    }
    //    else
    //    {
    //        DebugHelper.Log("Error...GetLuaTable2Func!!!");
    //    }

    //    return null;
    //}
}
