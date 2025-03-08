using UnityEngine;
using System.Collections;

public class LogicBattleStatePreloading : LogicBattleState
{
	public static LogicBattleState Creator (LogicBattle battle)
	{
		return new LogicBattleStatePreloading (battle);
	}

	public LogicBattleStatePreloading (LogicBattle battle) 
        : base (battle, LogicBattleStateType.Preloading)
	{
	}

	PreloadingStep mStep = PreloadingStep.None;

	public override void OnEnter ()
	{
        mBattle.SetLoadSetting();
        LoadScene();
        var mMapItem = new MapItemData(mBattle.SceneId, mBattle.CurSceneItem.LevelItems);
        PreDownProcessManager.Instance.StartLoad(mMapItem.levelname);
    }

	public override void OnLeave ()
	{
        mBattle.RestoreLoadSetting();
	}

	public override void Update (float deltaTime)
	{
        if(mStep == PreloadingStep.LoadingScene)
        {
            if (mBattle.BattleScene.IsLoaded)
            {
                PreDownProcessManager.Instance.Clear();
                LoadRole();
            }
            else
            {
                PreDownProcessManager.Instance.updateLoadStatus();
            }
        }
        else if (mStep == PreloadingStep.LoadingRoleAssets)
        {
            if(!BattleMgr.Instance.LoadingRoleModel)
            {
                LoadFlyWord();
            }
		}else if(mStep == PreloadingStep.LoadingFlywordAssets)
        {
            if (BattleFlyWordMgr.Instance.Loaded)
                LoadPrepareAssets();
        }else if(mStep == PreloadingStep.LoadingPrepareAssets)
        {
            if (!BattlePrepareManager.Instance.IsLoading)
                InstantiateGo();
        }else if(mStep == PreloadingStep.LoadingInstantiate)
        {
            OpenScreen();
        }
        else if (mStep == PreloadingStep.OpeningScreen) {
            EndLoad();
        }
	}

    void LoadScene()
    {
        mStep = PreloadingStep.LoadingScene;
        mBattle.BattleScene.StartLoad();
    }

	void LoadRole ()
	{
        mBattle.NotifyLoadProgress(0.2f);
        mStep = PreloadingStep.LoadingRoleAssets;
        BattleMgr.Instance.LoadRole(); 
    }

    void LoadFlyWord()
    {
        mBattle.NotifyLoadProgress(0.3f);
        mStep = PreloadingStep.LoadingFlywordAssets;
        BattleFlyWordMgr.Instance.StartLoad();
    }

    void LoadPrepareAssets()
    {
        mBattle.NotifyLoadProgress(0.4f);
        mStep = PreloadingStep.LoadingPrepareAssets;
        BattlePrepareManager.Instance.StartLoad();
    }

    void InstantiateGo()
    {
        mStep = PreloadingStep.LoadingInstantiate;
    }

    void OpenScreen ()
	{
		mStep = PreloadingStep.OpeningScreen;
    }

    void EndLoad()
    {
        mBattle.OnLoadComplete();
        ChangeState(LogicBattleStateType.Battle);
    }
}