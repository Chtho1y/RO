using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AntiCheatMgr : Singleton<AntiCheatMgr>
{
    private AntiCheatBase[] m_ArrayAnti = null;

    private AntiCheatBase Create(EnAntiCheatType enAntiType)
    {
        switch(enAntiType)
        {
            case EnAntiCheatType.enScaleTime:
                return new ScaleTimeAntiCheat();
            case EnAntiCheatType.enSystemTime:
                return new SystemTimeAntiCheat();
            default:
                return new AntiCheatBase();
        }
    }

    public AntiCheatBase GetOrCreateAnti(EnAntiCheatType enAntiType)
    {
        if (null == m_ArrayAnti)
            m_ArrayAnti = new AntiCheatBase[(int)EnAntiCheatType.enDefault];
        if (null == m_ArrayAnti[(int)enAntiType])
            m_ArrayAnti[(int)enAntiType] = Create(enAntiType);
        return m_ArrayAnti[(int)enAntiType];
    }

    public void Update()
    {
        if (null == m_ArrayAnti)
            return;

        for(int i=0;i< m_ArrayAnti.Length;i++)
        {
            if (null == m_ArrayAnti[i])
                continue;
            m_ArrayAnti[i].Update();
        }
    }
    
    public void Dispose()
    {
        if (null == m_ArrayAnti)
            return;
        for (int i = 0; i < m_ArrayAnti.Length; i++)
        {
            if (null == m_ArrayAnti[i])
                continue;
            m_ArrayAnti[i].Dispose();
            m_ArrayAnti[i] = null;
        }
        m_ArrayAnti = null;
    }
}