using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class LogicBattleFieldStateEnd : LogicBattleFieldState
{
	public static LogicBattleFieldState Creator (LogicBattleField field)
	{
		return new LogicBattleFieldStateEnd (field);
	}

	public LogicBattleFieldStateEnd (LogicBattleField field) 
        : base (field, LogicBattleFieldStateType.End)
	{
	}

    private BattleEndInfo mEndInfo;

    bool isPlayRecord = false;
	float mWaitTime = 0;
	FighterManager mFighterMgr;
    const int m_relive_delay_time_cfgid = 31;
	public override void OnEnter ()
	{
        switch (mField.Result)
        {
            case FightingResult.Failed:
                BattleMgr.Instance.OnBattleFailed(mField.killBoss);
                break;
            case FightingResult.Win:
                BattleMgr.Instance.OnBattleWin(mField.killBoss);
                break;
            case FightingResult.Peace:
                BattleMgr.Instance.OnBattleForceStop(mField.killBoss);
                break;
        }
        mWaitTime = mField.killBoss ? GlobalConfig.Instance.GetConfigFloatValue(m_relive_delay_time_cfgid) : GlobalConfig.Instance.GetConfigFloatValue(52);
        mFighterMgr = mField.Battle.FighterMgr;
        mField.Battle.NeedBackToLastPos = mField.killBoss;
        mField.Battle.BackToPos = mField.PreSpawnPos;
        isPlayRecord = mField.Battle.IsPlayRecord;

        mEndInfo = new BattleEndInfo();
        mEndInfo.IsPlayRecord = isPlayRecord;

        mField.Battle.EndStatistics();

        if (mField.killBoss) {
            mField.Battle.Factors = null;
            mField.Battle.BattleScene.RestoreSkyboxMat();
            EventMgr.DispatchEvent<bool>(new CoreEvent<bool>(ECoreEventType.EID_RESTORE_SCENE, true));
        }
        else {
            FadeOut();
            mField.DropItems();
        }

        ReliveFighters(); //复活我方 清空敌方
        if (mField.HasTeamMemberDead()) 
            BattleMgr.Instance.PlayCameraReliveEffect();

        if (mField.Battle.Recorder != null)
        {
            mField.Battle.CloseRecorder();
        }

        if(isPlayRecord)
        {
            mWaitTime = 0;
        }
    }

    void ReliveFighters()
    {
        List<Fighter> fighters = mField.Fighters;
        for (int idx = fighters.Count - 1; idx >= 0; idx--)
        {
            Fighter fighter = fighters[idx];
            if (fighter.IsTeamMember)
            {
                if (!fighter.IsAlive)
                {
                    fighter.Relive(100);
                }
                else
                {
                    fighter.ResetLife();
                    fighter.ForceIdle();
                }
            }
            else
            {
                if (fighter.IsDisposed && fighter.Ctrl != null)
                    fighter.Ctrl.OnDisposed(true);
                else if (fighter.IsSpawned && !fighter.IsDisposed)
                    fighter.Dispose();
            }

        }
    }

    void FadeOut()
    {
        List<Fighter> fighters = mField.Fighters;
        for (int idx = fighters.Count - 1; idx >= 0; idx--)
        {
            Fighter fighter = fighters[idx];
            if (fighter.Actor.IsNpc)
            {
                if (fighter.IsSpawned && !fighter.IsAlive)
                    fighter.Ctrl.FadeOut(mWaitTime);
            }
        }
    }

	public override void OnLeave ()
	{
        Dispose();
        mField.ClearFighter();
        mField.Battle.PreviousFightingTime = mField.FightingTime;
        BattleMgr.Instance.OnBattleEnd(0,mEndInfo); //传递mEndInfo 防止在等待中 原值修改
        if (isPlayRecord)
        {
            mField.Battle.FighterMgr.RestoreTeamFighters();
        }
    }

	public override void Update (float deltaTime)
	{		
		mWaitTime -= deltaTime;
		if (mWaitTime <= 0)
			ChangeState (LogicBattleFieldStateType.None);
	}

    public override void OnDataChanged()
    {

    }

    void Dispose()
    {   //刪除存活的敌方
        List<Fighter> fighters = mField.Fighters;
        for (int i = fighters.Count - 1; i >= 0; i--)
        {
            Fighter fighter = fighters[i];
            if (fighter.IsTeamMember)//如果非正常失败 角色没有死亡 会被删除 后续无法复活
                continue;
            if (fighter.IsAlive)
            {
                fighter.Dispose();
            }
        }
    }
}
