using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class LogicBattleStateBattle : LogicBattleState
{
	public static LogicBattleState Creator (LogicBattle battle)
	{
		return new LogicBattleStateBattle (battle);
	}

	public LogicBattleStateBattle (LogicBattle battle) : base (battle, LogicBattleStateType.Battle)
	{
	}

    private float timeout = 10.0f;
	public override void OnEnter ()
	{
        BattleCamera.Instance.Initialize(mBattle);   
        MusicMgr.Instance.PlayBGMusic(mBattle.BgMusic);
        InitTeamFighterPos();
        mBattle.EnterNextBattle();
	}

	public override void OnLeave ()
	{
    }

	public override void Update (float deltaTime)
	{
		if (mBattle.CurrentBattleField != null)
        {
#if PROFILE
            UnityEngine.Profiling.Profiler.BeginSample("mBattle.CurrentBattleField update");
#endif           
            mBattle.CurrentBattleField.Update (deltaTime);
#if PROFILE
            UnityEngine.Profiling.Profiler.EndSample();
#endif
            if (mBattle.CurrentBattleField.CurrentState == LogicBattleFieldStateType.None)
            {
                if (mBattle.CurBattleField.IsPlayingRecorder)
                {
                    mBattle.ContinueCurrentBattle();
                }
                else
                {
                    if (mBattle.CurrentBattleField.Result == FightingResult.Win)
                    {
                        if (mBattle.CurLevelItem.HasPassed)
                        {
                            if (mBattle.BattleScene.HasNextBattle)
                            {
                                timeout -= deltaTime;
                                if (mBattle.ServerAckOk)
                                {
                                    mBattle.EnterNextBattle();
                                    mBattle.ServerAckOk = false;
                                    timeout = 10.0f;
                                }
                                else if (timeout <= 0)
                                {
                                    mBattle.ContinueCurrentBattle();
                                    timeout = 10.0f;
                                }
                            }
                            else
                            {
                                ChangeState(LogicBattleStateType.BattleWin);
                            }
                        }
                        else
                        {
                            mBattle.ContinueCurrentBattle();
                        }
                    }
                    else if (mBattle.CurrentBattleField.Result == FightingResult.Failed)
                    {
                        mBattle.ContinueCurrentBattle();
                    }
                    else if (mBattle.CurrentBattleField.Result == FightingResult.Peace)
                    {
                        if (mBattle.IsPlayRecord)
                        {
                            CreateReplayBattle();
                        }
                        else
                        {
                            mBattle.ContinueCurrentBattle();
                        }
                    }
                }
			}
		}
        else
        { 
			ChangeState (LogicBattleStateType.BattleWin);
        }
    }

    void InitTeamFighterPos()
    {
        if (mBattle.BattleScene.ActorBornPoint == null) return;

        mBattle.FighterMgr.SortTeamFighters();
        for(int idx =0; idx < mBattle.FighterMgr.TeamHeroFighters.Count; idx++)
        {
            Fighter fighter = mBattle.FighterMgr.TeamHeroFighters[idx];
            var pointCfg = mBattle.BattleScene.ActorBornPoint.GetBornPointPos(fighter.Actor.Profession, fighter.ReadyPosOrder);
            fighter.Spawn(pointCfg.heroPos, Vector3.forward, Quaternion.identity);
            if(fighter.Actor.HasPet)
            {
                Fighter pet = mBattle.FighterMgr.GetTeamMemberById(fighter.Actor.PetData.ID);
                pet.Spawn(pointCfg.petPos, Vector3.forward, Quaternion.identity);
                pet.OwnerId = fighter.Id;
                fighter.UsedPetId = pet.Id;
            }
        }
    }

    #region replay_battle_methods
    void CreateReplayBattle()
    {
        LoadReplayActors();
    }

    bool prepareResOk = false;
    bool fighterResOk = false;
    int curLoadCnt = 0;
    int totalLoadCnt = 0;
    bool bLoadedReplayActor = false;
    void LoadReplayActors()
    {
        if (bLoadedReplayActor) return;

        bLoadedReplayActor = true;
        BattleCamera.Instance.SetCameraMode(CameraMode.Camera_None);
        mBattle.FighterMgr.CacheTeamFighters();
        
        prepareResOk = false;
        fighterResOk = false;
        curLoadCnt = 0;
        totalLoadCnt = mBattle.Recorder.LeftActors.Count;

        EventMgr.AddEventListener<Fighter>(ECoreEventType.EID_FIGHTER_ASYNC_LOADED, OnFighterAsyncLoaded);
        EventMgr.AddEventListener<bool>(ECoreEventType.EID_PREPARE_LOAD_OK, OnPrepareLoadOk);
        
        List<ActorData> leftActors  = mBattle.Recorder.LeftActors;
        mBattle.FighterMgr.AddFighters(leftActors.ToArray(), eTeamType.Friend);

        for(int idx =0; idx < mBattle.FighterMgr.TeamHeroFighters.Count;idx++)
        {
            var f = mBattle.FighterMgr.TeamHeroFighters[idx];
            if(f.Actor.HasPet)
            {
                var pet = mBattle.FighterMgr.GetTeamMemberById(f.Actor.PetData.ID);
                pet.OwnerId = f.Id;
                f.UsedPetId = pet.Id;
            }
        }

        for(int idx =0; idx < leftActors.Count;idx++)
        {
            Fighter f = mBattle.FighterMgr.GetFighterByID(leftActors[idx].ID, eTeamType.Friend);
            if (f != null && f.Ctrl != null)
                f.Ctrl.AsyncLoad();
        }

        BattlePrepareManager.Instance.StartLoad();
    }

    void OnFighterAsyncLoaded(CoreEvent<Fighter> ce)
    {
        Fighter f = ce.Data;
        if (f.IsPlayer || f.IsPet)
        {
            curLoadCnt++;
            if (curLoadCnt == totalLoadCnt)
            {
                for(int idx=0; idx < mBattle.FighterMgr.TeamHeroFighters.Count;idx++)
                {
                    var hero = mBattle.FighterMgr.TeamHeroFighters[idx];
                    hero.Spawn(Vector3.zero, Vector3.forward, Quaternion.identity);
                    if(hero.Actor.HasPet)
                    {
                        var pet = mBattle.FighterMgr.GetTeamMemberById(hero.Actor.PetData.ID);
                        pet.Spawn(Vector3.zero, Vector3.forward, Quaternion.identity);
                    }
                }
                fighterResOk = true;
                EventMgr.RemoveEventListener<Fighter>(ECoreEventType.EID_FIGHTER_ASYNC_LOADED, OnFighterAsyncLoaded);
                CheckLoadOK();
            }
        }
    }

    void OnPrepareLoadOk(CoreEvent<bool> ce)
    {
        EventMgr.RemoveEventListener<bool>(ECoreEventType.EID_PREPARE_LOAD_OK, OnPrepareLoadOk);
        prepareResOk = true;
        CheckLoadOK();
    }

    void CheckLoadOK()
    {
        if (prepareResOk && fighterResOk)
        {
            int mapId = mBattle.Recorder.MapId;
            int levelId = mBattle.Recorder.LevelId;
            var sceneItem = new SceneItem(mapId);
            var levelItem = sceneItem.GetLevelItem(levelId);
            int levelIdx = sceneItem.GetLevelIndex(levelItem.LevelId);

            mBattle.BattleScene.CreateReplayBattle(levelIdx);
            if (mBattle.CurrentBattleField != null)
            {
                mBattle.CurrentBattleField.BeginReplay();
            }
            EventMgr.DispatchEvent<bool>(new CoreEvent<bool>(ECoreEventType.EID_REPLAY_BATTLE_LOADOK, true));
            bLoadedReplayActor = false;
        }
    }
    #endregion
}