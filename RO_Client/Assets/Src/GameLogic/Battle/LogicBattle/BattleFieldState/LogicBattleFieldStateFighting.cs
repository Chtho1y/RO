using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class LogicBattleFieldStateFighting : LogicBattleFieldState
{
	public static LogicBattleFieldState Creator (LogicBattleField field)
	{
		return new LogicBattleFieldStateFighting (field);
	}

	public LogicBattleFieldStateFighting (LogicBattleField field) 
        : base (field, LogicBattleFieldStateType.Fighting)
	{
	}

    float bossRangBeginTime = 0;
    bool notifyShowBossLeftTime = false;
    Fighter boss = null;


    public override void OnEnter ()
	{
        mField.Battle.StartOutput();
        //if (BattleMgr.Instance.Battle.IsPlayRecord || BattleMgr.Instance.Battle.IsKillingBoss)
        //    DebugHelper.LogError("挑战 mapId:" + mField.BattleInfo.MapId + " levelId:" + mField.BattleInfo.LevelId);

        if (mField.killBoss)
        {
            bossRangBeginTime = GlobalConfig.Instance.GetConfigIntValue(GlobalConfig.c_enter_bossrage_time_configid);
            if (!string.IsNullOrEmpty(mField.BattleInfo.BattleBgm) && !mField.playingBattleMusic)
            {
                mField.playingBattleMusic = true;
                MusicMgr.Instance.PlayBGMusic(mField.BattleInfo.BattleBgm);
            }
            mField.Battle.FighterMgr.SetPveMark();
        }

        List<Fighter> fighters = mField.Fighters;
        for (int i = 0; i < fighters.Count; i++)
        {
            if (mField.Battle.IsPlayRecord)
            {
                mField.Battle.Recorder.ProcessFrameRecord(BattleRecorder.RecordType.FighterStartFighting, fighters[i]);
            }
            else
            {
                fighters[i].OnFightingStart();
                if (fighters[i].IsBoss)
                {
                    boss = fighters[i];
                }
            }
        }

        mField.CheckFightersPassiveSkill();
        //刷新被动 buff
        mField.Battle.FighterMgr.FixedUpdate(0.0f);
        mField.CheckBuffs(BuffTriggerType.Trigger_Begin_Fighting);
        BattleMgr.Instance.OnFightingStart();
	}

	public override void OnLeave ()
	{
        if(BattleMgr.Instance.Battle.IsPlayRecord)
        {
            BattleMgr.Instance.OnReplayEnd();
        }

        mField.Battle.EndOutput();
        for (int idx =0; idx < mField.Fighters.Count;idx++)
        {
            Fighter fighter = mField.Fighters[idx];
            if (!fighter.IsDisposed && fighter.IsSpawned)
                fighter.OnFightingEnd();
        }

        if (!string.IsNullOrEmpty(mField.BattleInfo.BattleBgm))
        {
            mField.playingBattleMusic = false;
            if (mField.killBoss)
            {
                MusicMgr.Instance.PlayBGMusic(mField.Battle.BgMusic);
            }
        }
        //录像错误框
        if(mField.Battle.IsPlayRecord)
            CloseErrorMsgBox();
    }

	public override void Update (float deltaTime)
	{
        if (mField.killBoss)
        {
            if(!mField.Battle.IsPlayRecord)
            {
                if (!notifyShowBossLeftTime)
                {
                    if (mField.FightingTime >= (bossRangBeginTime - 10))
                    {
                        EventMgr.DispatchEvent<bool>(new CoreEvent<bool>(ECoreEventType.EID_BEGIN_BOSS_RAGE_TIME, true));
                        EventMgr.DispatchEvent<int>(new CoreEvent<int>(ECoreEventType.EID_SHOW_BOSS_RAGE_LEFTTIME, 10));
                        notifyShowBossLeftTime = true;
                    }
                }

                if (mField.FightingTime >= bossRangBeginTime && boss != null && !boss.StateData.IsRageStatus)
                {
                    boss.OnEnterRage();
                }else if(notifyShowBossLeftTime)
                {
                    if(boss.IsAlive)
                    {
                        int leftTime = (int)(bossRangBeginTime - mField.FightingTime);
                        EventMgr.DispatchEvent<int>(new CoreEvent<int>(ECoreEventType.EID_SHOW_BOSS_RAGE_LEFTTIME, leftTime));
                    }
                }
            }    
        }
        else
        {
            if(BattleMgr.Instance.Battle.ChallengeBoss)
            {
                mField.PeaceEnd();
                //ChangeState(LogicBattleFieldStateType.End);  //注释代码，PeaceEnd()已经包含状态切换
                return;
            }
        }

        mField.Battle.FighterMgr.FixedUpdate (deltaTime);

        if (mField.Result == FightingResult.None)
            mField.CheckFightingResult(mField.Battle);

		switch (mField.Result)
        {
		    case FightingResult.Win:
			    ChangeState (LogicBattleFieldStateType.Win);
			    break;
		    case FightingResult.Failed:
			    ChangeState (LogicBattleFieldStateType.Failed);
			    break;
            case FightingResult.Peace:
                ChangeState(LogicBattleFieldStateType.End);
                break;
        }
	}

    public override void OnDataChanged()
    {

    }

    bool CheckIsWinOnTimeout()
	{
        return false;
	}

    private void CloseErrorMsgBox()
    {
        LuaInterface.LuaState pLuaState = LuaMgr.GetMainState();
        if (null != pLuaState)
        {            
            string strLuaClose = "ManagerContainer.LuaBattleMgr:CloseErrorQuitBattleMsgBox()";
            LuaMgr.GetMainState().DoString(strLuaClose); 
        }
    }
}
