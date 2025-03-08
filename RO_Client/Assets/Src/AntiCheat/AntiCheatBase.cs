using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//检测外挂 非法
public class AntiCheatBase
{
    //检测间隔
    protected float m_fAntiDeltaTime = 0.0f;
    //上一次检测时间
    protected float m_fAntiLastTime = AntiCheatCfg.c_fErrorTime;
    //是否启用
    private bool m_bIsUseed = true;

    public void Init(float fAntiDeltaTime)
    {
        m_fAntiDeltaTime = fAntiDeltaTime;
        m_fAntiLastTime = AntiCheatCfg.c_fErrorTime;
#if UNITY_EDITOR
        m_bIsUseed = false;//editor 平台关闭
#endif
        OnInit();
    }

    public void SetEnable(bool bIsUse)
    {
        m_bIsUseed = bIsUse;
    }

    public void Update()
    {
        if (m_bIsUseed)
        {
            float fCurTime = Time.realtimeSinceStartup;
            if(m_fAntiLastTime == AntiCheatCfg.c_fErrorTime)
            {
                m_fAntiLastTime = Time.realtimeSinceStartup;
            }
            float fDeltaTime = fCurTime - m_fAntiLastTime;
            if (fDeltaTime >= m_fAntiDeltaTime)
            {
                m_fAntiLastTime = fCurTime;
                CheckAntiCheat();
            }   
        }   
    }

    public void Dispose()
    {
        OnDispos();
    }

    private void CheckAntiCheat()
    {
        bool bIsCheat = IsCheckAntiCheat();
        if (bIsCheat)
            OnAntiCheat();
    }

    //初始化
    protected virtual void OnInit()
    {

    }

    //是否使用外挂判断
    protected virtual bool IsCheckAntiCheat()
    {
        return false;
    }

    //检测到外挂后 处理
    protected virtual void OnAntiCheat()
    {

    }

    //销毁
    protected virtual void OnDispos()
    {

    }
}