using System;
using System.Collections.Generic;
using UnityEngine;

public static class EventMgr
{
    public delegate void CoreEventDelegate<T, T1>(CoreEvent<T, T1> e);
    public delegate void CoreEventDelegate<T>(CoreEvent<T> e);
    public delegate void LuaCoreEventDelegate<T>(LuaCoreEvent<T> e);
    public delegate void LuaCoreEventDelegate(LuaCoreEvent e);

    static readonly Dictionary<int, Delegate> m_Delegates = new Dictionary<int, Delegate>();
    static readonly Dictionary<string, Delegate> m_LuaDelegates = new Dictionary<string, Delegate>();

    public static void AddEventListener<T>(int type, CoreEventDelegate<T> listener)
    {
        Delegate d;
        if (m_Delegates.TryGetValue(type, out d))
        {
            m_Delegates[type] = Delegate.Combine(d, listener);
        }
        else
        {
            m_Delegates[type] = listener;
        }
    }

    public static void AddEventListener<T,T1>(int type, CoreEventDelegate<T,T1> listener)
    {
        Delegate d;
        if (m_Delegates.TryGetValue(type, out d))
        {
            m_Delegates[type] = Delegate.Combine(d, listener);
        }
        else
        {
            m_Delegates[type] = listener;
        }
    }

    public static void RemoveEventListener<T>(int type, CoreEventDelegate<T> listener)
    {
        Delegate d;
        if (m_Delegates.TryGetValue(type, out d))
        {
            Delegate currentDel = Delegate.Remove(d, listener);

            if (currentDel == null)
            {
                m_Delegates.Remove(type);
            }
            else
            {
                m_Delegates[type] = currentDel;
            }
        }
    }

    public static void RemoveEventListener<T,T1>(int type, CoreEventDelegate<T, T1> listener)
    {
        Delegate d;
        if (m_Delegates.TryGetValue(type, out d))
        {
            Delegate currentDel = Delegate.Remove(d, listener);

            if (currentDel == null)
            {
                m_Delegates.Remove(type);
            }
            else
            {
                m_Delegates[type] = currentDel;
            }
        }
    }


    public static void AddLuaEventListenerArgs<T>(string luaFunction, LuaCoreEventDelegate<T> listener)
    {
        Delegate d;
        if (m_LuaDelegates.TryGetValue(luaFunction, out d))
        {
            m_LuaDelegates[luaFunction] = Delegate.Combine(d, listener);
        }
        else
        {
            m_LuaDelegates[luaFunction] = listener;
        }
    }

    public static void RemoveLuaEventListenerArgs<T>(string luaFunction, LuaCoreEventDelegate<T> listener)
    {
        Delegate d;
        if (m_LuaDelegates.TryGetValue(luaFunction, out d))
        {
            Delegate currentDel = Delegate.Remove(d, listener);
            if (currentDel == null)
            {
                m_LuaDelegates.Remove(luaFunction);
            }
            else
            {
                m_LuaDelegates[luaFunction] = currentDel;
            }
        }
    }


    public static void AddLuaEventListener(string luaFunction, LuaCoreEventDelegate listener)
    {
        Delegate d;
        if (m_LuaDelegates.TryGetValue(luaFunction, out d))
        {
            m_LuaDelegates[luaFunction] = Delegate.Combine(d, listener);
        }
        else
        {
            m_LuaDelegates[luaFunction] = listener;
        }
    }

    public static void RemoveLuaEventListener(string luaFunction, LuaCoreEventDelegate listener)
    {
        Delegate d;
        if (m_LuaDelegates.TryGetValue(luaFunction, out d))
        {
            Delegate currentDel = Delegate.Remove(d, listener);

            if (currentDel == null)
            {
                m_LuaDelegates.Remove(luaFunction);
            }
            else
            {
                m_LuaDelegates[luaFunction] = currentDel;
            }
        }
    }

    public static void RemoveLuaEventListener<T>(int type)
    {
        if (m_Delegates.ContainsKey(type))
        {
            m_Delegates.Remove(type);
        }
    }

    public static void DispatchEvent<T>(CoreEvent<T> e)
    {
        if (e == null)
        {
            throw new ArgumentNullException("e");
        }

        Delegate d;
        if (m_Delegates.TryGetValue(e.EventType, out d))
        {
            CoreEventDelegate<T> callback = d as CoreEventDelegate<T>;
            if (callback != null)
            {
                callback(e);
            }
        }
    }

    public static void DispatchEvent<T,T1>(CoreEvent<T,T1> e)
    {
        if (e == null)
        {
            throw new ArgumentNullException("e");
        }

        Delegate d;
        if (m_Delegates.TryGetValue(e.EventType, out d))
        {
            CoreEventDelegate<T, T1> callback = d as CoreEventDelegate<T, T1>;
            if (callback != null)
            {
                callback(e);
            }
        }
    }

    public static void LuaDispatchEvent<T>(LuaCoreEvent<T> e)
    {
        if (e == null)
        {
            throw new ArgumentNullException("e");
        }

        Delegate d;
        if (m_LuaDelegates.TryGetValue(e.Func, out d))
        {
            LuaCoreEventDelegate<T> callback = d as LuaCoreEventDelegate<T>;
            if (callback != null)
            {
                callback(e);
            }
        }
    }


    public static void LuaDispatchEvent(LuaCoreEvent e)
    {
        if (e == null)
        {
            throw new ArgumentNullException("e");
        }

        Delegate d;
        if (m_LuaDelegates.TryGetValue(e.Func, out d))
        {
            LuaCoreEventDelegate callback = d as LuaCoreEventDelegate;
            if (callback != null)
            {
                callback(e);
            }
        }
    }
}

public class CoreEvent<T,T1>
{
    int m_EventType;
    public int EventType
    {
        get { return m_EventType; }
    }
    T m_Data;
    public T Data
    {
        get { return m_Data; }
    }

    T1 m_Data1;
    public T1 Data1
    {
        get { return m_Data1; }
    }
    
    public CoreEvent(int type, T data,T1 data1)
    {
        m_EventType = type;
        m_Data = data;
        m_Data1 = data1;
    }
}

public class CoreEvent<T>
{
    int m_EventType;
    public int EventType
    {
        get { return m_EventType; }
    }
    T m_Data;
    public T Data
    {
        get { return m_Data; }
    }

    object mParam = null;
    public object Param
    {
        get { return mParam; }
        set { mParam = value; }
    }

    object mParam2 = null;
    public object Param2
    {
        get { return mParam2; }
        set { mParam2 = value; }
    }

    public CoreEvent(int type, T data)
    {
        m_EventType = type;
        m_Data = data;
    }

    public void SetData(T data)
    {
        m_Data = data;
    }
}

public class LuaCoreEvent<T>
{
    string m_Func;
    public string Func
    {
        get { return m_Func; }
    }
    T m_Data;
    public T Data
    {
        get { return m_Data; }
    }

    public LuaCoreEvent(string luaFunc, T data)
    {
        m_Func = luaFunc;
        m_Data = data;
    }
}

public class LuaCoreEvent
{
    string m_Func;
    public string Func
    {
        get { return m_Func; }
    }
    public LuaCoreEvent(string luaFunc)
    {
        m_Func = luaFunc;
    }
}
