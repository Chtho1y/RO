using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 寻找敌人阶段
/// </summary>
public class LogicBattleFieldStateSearch : LogicBattleFieldState
{
    public static LogicBattleFieldStateSearch Creator(LogicBattleField field)
    {
        return new LogicBattleFieldStateSearch(field);
    }

    bool switchCam = false;
    float waitingTime = 0.1f;
    bool hasSpawnedBoss = false;
    bool bMoveTo = false;

    float changeCamDist = 20;
    public LogicBattleFieldStateSearch(LogicBattleField field)
        : base(field, LogicBattleFieldStateType.Search)
    {

    }

    public override void OnEnter()
    {
        waitingTime = 0.1f;
        switchCam = false;
        hasSpawnedBoss = false;

        BattleMgr.Instance.OnBeginSearch();
        BattleMgr.Instance.SyncTeamData();  
        if (!mField.killBoss)
        {
            mField.Battle.BattleScene.SetEffectVisible(false);
            mField.SpawnMonster();
            if (!BattleMgr.Instance.IsLoadingBattleAssets)
                mField.Battle.MoveToNextBattleField(false);
        }
        else
        {
            mField.RecordSpawnCfg();
        }
    }

    public override void OnLeave()
    {
        
    }

    public override void Update(float deltaTime)
    {
        if (mField.killBoss && !BattleMgr.Instance.IsLoadingBattleAssets)
        {
            if(!hasSpawnedBoss)
            {
                mField.Battle.InitRecorder();
                mField.RemoveMonsters();
                mField.SpawnBoss();
                mField.Battle.ReadyTransfer();
                hasSpawnedBoss = true;
            }

            waitingTime -= deltaTime;
            if (waitingTime <= 0)
            {
                mField.Battle.GoToTransferPoint();
                ChangeState(LogicBattleFieldStateType.Start);
            }
            return;
        }

        if (!BattleMgr.Instance.IsLoadingBattleAssets)
        {
            if(!bMoveTo)
            {
                mField.Battle.MoveToNextBattleField(false);
                bMoveTo = true;
            }

            CheckSwitchCam();

            if (mField.Battle.IsAllFightersReady())
            {
                ChangeState(LogicBattleFieldStateType.Fighting);
            }
            else
            {
                mField.Battle.FighterMgr.FixedUpdate(deltaTime);
                mField.Battle.BattleScene.UpdateSceneTree(mField.TeamFighters[0].Position);
            }
        }
        else
        {
            mField.Battle.FighterMgr.FixedUpdate(deltaTime);
        }
        
    }

    public override void OnDataChanged()
    {
    }

    void CheckSwitchCam()
    {
        if (switchCam) return;
        if (0 == mField.Battle.FighterMgr.TeamFighters.Count) return;

        Fighter f = mField.Battle.FighterMgr.TeamFighters[0];
        float dist = Vector3.Distance(f.DestPosition, f.Position);
        if(dist <= changeCamDist)
        {
            BattleCamera.Instance.SetBattleAuto(mField.Battle.BattleScene.ActorBornPoint.transform.forward);
            switchCam = true;
        }

        //if (mField.Battle.IsSelfReady()) { 
        //    BattleMgr.Instance.LookAtBattleFieldCenter();
        //    switchCam = true;
        //}
    }
}
