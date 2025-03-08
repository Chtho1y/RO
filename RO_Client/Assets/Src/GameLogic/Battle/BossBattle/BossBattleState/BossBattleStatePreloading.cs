using UnityEngine;
using System.Collections;

public class BossBattleStatePreloading : BossBattleState
{
    public static BossBattleStatePreloading Creator(BossBattle battle)
    {
        return new BossBattleStatePreloading(battle);
    }

    public BossBattleStatePreloading(BossBattle battle) :
        base(battle, BossBattleStateType.Preloading)
    {

    }

    PreloadingStep mStep = PreloadingStep.None;
    public override void OnEnter()
    {
        mBattle.SetLoadSetting();
        LoadScene();
        PreDownProcessManager.Instance.StartLoad(mBattle.LevelName);
    }

    public override void OnLeave()
    {
        mBattle.RestoreLoadSetting();
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
        mBattle.CalcTransferPoint();
        mBattle.OnLoadComplete();
        ChangeState(BossBattleStateType.Battle);
    }
}
