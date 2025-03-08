using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//检测系统时间修改
public class SystemTimeAntiCheat : AntiCheatBase
{
    private int m_nLastServerTime = -1;
    private int m_nLastLocalTime = -1;
    private bool bIsBeCheat = false;
    protected override void OnInit()
    {
        Reset();
        TimerManager.Instance.EvtChangeTime += OnChangeServerTime;  //平均1分请求一次
    }

    protected override bool IsCheckAntiCheat()
    {
        //断网情况      
        bool bIsConnect = NetworkMgr.Instance.GetConnectStatus();
        if(!bIsConnect)
        {            
            Reset();
        }
        return bIsBeCheat;
    }

    protected override void OnAntiCheat()
    {
        //检测到非法运行速度 显示提示框
        Reset();
        LuaInterface.LuaState pLuaState = LuaMgr.GetMainState();
        if (null != pLuaState)
        {
            bool bIsConnect = NetworkMgr.Instance.GetConnectStatus();
            if (!bIsConnect)
                LuaMgr.GetMainState().DoString("ManagerContainer.LuaBattleMgr:ShowAntiCheatMsgBox(0)");
            else
                LuaMgr.GetMainState().DoString("ManagerContainer.LuaBattleMgr:SendAntiCheat(0)");
            BattleMgr.Instance.DoPauseFighting(true);
            if (Time.timeScale > GameMgr.Instance.GetGameSpeed())
            {
                Time.timeScale = GameMgr.Instance.GetGameSpeed();
            }
        }
        else
        {
            TimerManager.Instance.AddTimer(3000, 1, (nTime) =>
            {
                GameMgr.Instance.QuitGame();
            });
        }
        Debug.Log("非法速度");
    }

    protected override void OnDispos()
    {
        base.OnDispos();
        TimerManager.Instance.EvtChangeTime -= OnChangeServerTime;
    }

    private void Reset()
    {
        m_nLastServerTime = -1;
        m_nLastLocalTime = -1;
        bIsBeCheat = false;
    }

    private void OnChangeServerTime(int nServerTime)
    {
        int nLocalTime = (int)Time.realtimeSinceStartup;
        if (-1 == m_nLastServerTime)
        {
            m_nLastServerTime = nServerTime;
            m_nLastLocalTime = nLocalTime;
        }
       
        int nDeltaServerTime = nServerTime - m_nLastServerTime;
        int nDeltaLocalTime = nLocalTime - m_nLastLocalTime;
        int nDeltaTime = nDeltaLocalTime - nDeltaServerTime;

        if (bIsBeCheat)
            return;
        if(nDeltaServerTime < AntiCheatCfg.c_fDeltaServerTime)//排除網絡延遲較大的波動誤判
        {
            if (nDeltaTime >= AntiCheatCfg.c_nTimeSysteMaxDurationTime)//加速判断
            {
                bIsBeCheat = true;
            }
        }
        m_nLastServerTime = nServerTime;
        m_nLastLocalTime = nLocalTime;
    }
}
