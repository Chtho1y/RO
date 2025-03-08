using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 准备就位阶段
/// </summary>
public class LogicBattleFieldStateStart : LogicBattleFieldState
{
	public static LogicBattleFieldState Creator (LogicBattleField field)
	{
		return new LogicBattleFieldStateStart (field);
	}

    Vector3 destPos = Vector3.zero;
    float intervalSpace = 7;
    float leftTime = 1;
    bool bSwitchBossIntro = false;
    bool switchCam = false;

    public LogicBattleFieldStateStart (LogicBattleField field) 
        : base (field, LogicBattleFieldStateType.Start)
	{
	}

	public override void OnEnter ()
	{
        if (mField.killBoss)
        {
            if (mField.BattleInfo.ShowBossIntroType == (int)BossIntroType.Warning)
                BattleMgr.Instance.ShowBossWarning();
            else if (mField.BattleInfo.ShowBossIntroType == (int)BossIntroType.BossIntro)
                bSwitchBossIntro = true;

            if (!string.IsNullOrEmpty(mField.BattleInfo.BattleBgm))
            {                
                mField.playingBattleMusic = true;
                MusicMgr.Instance.PlayBGMusic(mField.BattleInfo.BattleBgm);
            }

            //BattleCamera.Instance.SetBlurEffectEnabled(true);
        }
        mField.Battle.MoveToNextBattleField(false);
    }

	public override void OnLeave ()
	{
    }

	public override void Update (float deltaTime)
	{
        if (mField.Battle.IsAllFightersReady())
        {
            if (bSwitchBossIntro)
            {
                ChangeState(LogicBattleFieldStateType.BossIntro);
            }
            else
            {
                //BattleMgr.Instance.SetBossBattleCamera();
                ChangeState(LogicBattleFieldStateType.Fighting);
            }  
        }
        else
        {
            mField.Battle.FighterMgr.FixedUpdate(deltaTime);
            mField.Battle.BattleScene.UpdateSceneTree(mField.TeamFighters[0].Position);
        }
    }

    public override void OnDataChanged()
    {

    }

    //void CheckSwitchCam()
    //{
    //    if (switchCam) return;

    //    if (mField.Battle.IsSelfReady())
    //    {
    //        if (!mField.killBoss) {
    //            BattleMgr.Instance.LookAtBattleFieldCenter();
    //        }
    //        switchCam = true;
    //    }
    //}
}
