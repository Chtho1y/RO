using UnityEngine;
using System.Collections;

public class TimeBattleStatePreloading : TimeBattleState
{
    public static TimeBattleStatePreloading Creator(TimeBattle battle)
    {
        return new TimeBattleStatePreloading(battle);
    }

    public TimeBattleStatePreloading(TimeBattle battle):
        base(battle,TimeBattleStateType.Preloading)
    {

    }

    PreloadingStep mStep = PreloadingStep.None;
    public override void OnEnter()
    {
        mBattle.SetLoadSetting();
        LoadScene();
        PreDownProcessManager.Instance.StartLoad(mBattle.SceneName);
    }

    public override void Update(float deltaTime)
    {
        if (mStep == PreloadingStep.LoadingScene)
        {
            if (mBattle.BattleScene.IsLoaded)
            {
                PreDownProcessManager.Instance.Clear();
                LoadFlyWord();
            }
            else
            {
                PreDownProcessManager.Instance.updateLoadStatus();
            }
        }
        else if (mStep == PreloadingStep.LoadingFlywordAssets)
        {
            if (BattleFlyWordMgr.Instance.Loaded)
                LoadPrepareAssets();
        }
        else if (mStep == PreloadingStep.LoadingPrepareAssets)
        {
            if (!BattlePrepareManager.Instance.IsLoading)
                InstantiateGo();
        }
        else if (mStep == PreloadingStep.LoadingInstantiate)
        {
            OpenScreen();
        }
        else if (mStep == PreloadingStep.OpeningScreen)
        {
            EndLoad();
        }
    }

    public override void OnLeave()
    {
        mBattle.RestoreLoadSetting();
    }

    void LoadScene()
    {
        mStep = PreloadingStep.LoadingScene;
        mBattle.BattleScene.StartLoad();
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

    void OpenScreen()
    {
        mStep = PreloadingStep.OpeningScreen;
    }

    void EndLoad()
    {
        mBattle.SpawnActors();
        mBattle.OnLoadComplete();
        ChangeState(TimeBattleStateType.Battle);
    }
}
