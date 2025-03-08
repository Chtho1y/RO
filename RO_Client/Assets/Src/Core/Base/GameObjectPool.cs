using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameObjectPool<T> where T : class, new()
{
    private Stack<T> m_GOStack;
    private int m_iMaxRecycledItem = 5;
    private float mLastUsedTime = 0f;
    
    public int Count
    {
        get { return m_GOStack.Count; }
    }

    public GameObjectPool()
    {
        m_GOStack = new Stack<T>();
        mLastUsedTime = Time.time + 20f;
    }

    public void SetMaxCacheNum(int num)
    {
        this.m_iMaxRecycledItem = num;
    }

    public T Spawn()
    {
        if (m_GOStack.Count > 0)
        {
            T t = m_GOStack.Pop();
            mLastUsedTime = Time.time + 20f;
            return t;
        }
        return null;
    }

    public void Recycle(T obj)
    {
        if (obj != null)
        {
            if (m_GOStack.Count > m_iMaxRecycledItem)
            {
                GameObject.Destroy(obj as GameObject);
                return;
            }
            m_GOStack.Push(obj);
        }       
    }

    public void Dispose()
    {
        if(m_GOStack.Count > 0)
        {
            while(true)
            {
                T t = Spawn();
                if (t != null)
                {
                    GameObject.Destroy(t as GameObject);
                }
                else
                    return;
            }           
        }
    }

    public bool NeedRelease()
    {
        return mLastUsedTime > Time.time;
    }
}