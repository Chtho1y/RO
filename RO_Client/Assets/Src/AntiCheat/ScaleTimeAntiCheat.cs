using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//检测Time.ScaleTime修改
public class ScaleTimeAntiCheat : AntiCheatBase
{
    protected override bool IsCheckAntiCheat()
    {
        if (Time.timeScale > AntiCheatCfg.c_fTimeScaleMaxValidTime)
        {
            Time.timeScale = AntiCheatCfg.c_fTimeScaleNorlValidTime;
            return true;
        }
        else
        {
            if (Time.timeScale > GameMgr.Instance.GetGameSpeed())
            {
                Time.timeScale = GameMgr.Instance.GetGameSpeed();
                return true;
            }
        }
       
        return false;
    }

    protected override void OnAntiCheat()
    {
        //检测到非法运行速度 显示提示框
        LuaInterface.LuaState pLuaState = LuaMgr.GetMainState();
        if (null != pLuaState)
        {
            bool bIsConnect = NetworkMgr.Instance.GetConnectStatus();
            if (!bIsConnect)
                LuaMgr.GetMainState().DoString("ManagerContainer.LuaBattleMgr:ShowAntiCheatMsgBox(1)");
            else
                LuaMgr.GetMainState().DoString("ManagerContainer.LuaBattleMgr:SendAntiCheat(1)");
            BattleMgr.Instance.DoPauseFighting(true);
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
}