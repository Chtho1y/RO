using UnityEngine;
using System.Collections;

public class VersusBattleStatePreloading : VersusBattleState
{
    public static VersusBattleState Creator(VersusBattle battle)
    {
        return new VersusBattleStatePreloading(battle);
    }

    public VersusBattleStatePreloading(VersusBattle battle)
        : base(battle, VersusBattleStateType.Preloading)
    {
    }

    PreloadingStep mStep = PreloadingStep.None;
    public override void OnEnter()
    {
        mBattle.SetLoadSetting();
        LoadScene();
        PreDownProcessManager.Instance.StartLoad(mBattle.SceneName);
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
        mBattle.OnLoadComplete();
        ChangeState(VersusBattleStateType.Battle);
    }
}
