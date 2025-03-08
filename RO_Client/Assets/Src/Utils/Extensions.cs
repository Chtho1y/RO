using LuaInterface;
public static partial class Extensions
{
    public static void CallCS2Lua(this LuaTable lua, string strFunc_)
    {
        if (!LuaMgr.HasInstance())
            return;

        if (lua != null)
        {
            LuaFunction tableFunc = lua.GetLuaFunction(strFunc_);
            tableFunc.Call(lua);
            tableFunc.Dispose();
            tableFunc = null;
        }
    }

    public static void CallCS2Lua<T1>(this LuaTable lua, string strFunc_, T1 arg1)
    {
        if (!LuaMgr.HasInstance())
            return;

        if (lua != null)
        {
            LuaFunction tableFunc = lua.GetLuaFunction(strFunc_);
            tableFunc.Call(lua, arg1);
            tableFunc.Dispose();
            tableFunc = null;
        }
    }

    public static void CallCS2Lua<T1, T2>(this LuaTable lua, string strFunc_, T1 arg1, T2 arg2)
    {
        if (!LuaMgr.HasInstance())
            return;

        if (lua != null)
        {
            LuaFunction tableFunc = lua.GetLuaFunction(strFunc_);
            tableFunc.Call(lua, arg1, arg2);
            tableFunc.Dispose();
            tableFunc = null;
        }
    }

    public static void CallCS2Lua<T1, T2, T3>(this LuaTable lua, string strFunc_, T1 arg1, T2 arg2, T3 arg3)
    {
        if (!LuaMgr.HasInstance())
            return;

        if (lua != null)
        {
            LuaFunction tableFunc = lua.GetLuaFunction(strFunc_);
            tableFunc.Call(lua, arg1, arg2, arg3);
            tableFunc.Dispose();
            tableFunc = null;
        }
    }

    public static void CallCS2Lua<T1, T2, T3, T4>(this LuaTable lua, string strFunc_, T1 arg1, T2 arg2, T3 arg3, T4 arg4)
    {
        if (!LuaMgr.HasInstance())
            return;

        if (lua != null)
        {
            LuaFunction tableFunc = lua.GetLuaFunction(strFunc_);
            tableFunc.Call(lua, arg1, arg2, arg3, arg4);
            tableFunc.Dispose();
            tableFunc = null;
        }
    }

    public static void CallCS2Lua<T1, T2, T3, T4, T5>(this LuaTable lua, string strFunc_, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5)
    {
        if (!LuaMgr.HasInstance())
            return;

        if (lua != null)
        {
            LuaFunction tableFunc = lua.GetLuaFunction(strFunc_);
            tableFunc.Call(lua, arg1, arg2, arg3, arg4, arg5);
            tableFunc.Dispose();
            tableFunc = null;
        }
    }

    public static void CallCS2Lua<T1, T2, T3, T4, T5, T6>(this LuaTable lua, string strFunc_, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6)
    {
        if (!LuaMgr.HasInstance())
            return;

        if (lua != null)
        {
            LuaFunction tableFunc = lua.GetLuaFunction(strFunc_);
            tableFunc.Call(lua, arg1, arg2, arg3, arg4, arg5, arg6);
            tableFunc.Dispose();
            tableFunc = null;
        }
    }

    public static void CallCS2Lua<T1, T2, T3, T4, T5, T6, T7>(this LuaTable lua, string strFunc_, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7)
    {
        if (!LuaMgr.HasInstance())
            return;

        if (lua != null)
        {
            LuaFunction tableFunc = lua.GetLuaFunction(strFunc_);
            tableFunc.Call(lua, arg1, arg2, arg3, arg4, arg5, arg6, arg7);
            tableFunc.Dispose();
            tableFunc = null;
        }
    }

    public static R1 InvokeCS2Lua<T1, T2, R1>(this LuaTable lua, string strFunc_, T1 arg1, T2 arg2)
    {
        if (!LuaMgr.HasInstance())
            return default(R1);

        if (lua != null)
        {
            LuaFunction tableFunc = lua.GetLuaFunction(strFunc_);
            R1 value = tableFunc.Invoke<LuaTable, T1, T2, R1>(lua, arg1, arg2);
            // tableFunc.Dispose();
            // tableFunc = null;
            return value;
        }
        return default(R1);
    }
}