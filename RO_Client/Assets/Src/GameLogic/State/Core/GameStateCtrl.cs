using UnityEngine;
using System.Collections;
using System.Reflection;
using System;

public class GameStateAttribute : AutoRegisterAttribute
{
}

public class GameStateCtrl : Singleton<GameStateCtrl>
{
    private StateMachine gameState = new StateMachine();

    public override void Init()
    {
        base.Init();
        gameState.RegisterStateByAttributes<GameStateAttribute>(typeof(GameStateAttribute).Assembly);
    }

    public override void UnInit()
    {
        gameState.Clear();

        gameState = null;

        base.UnInit();
    }

    public void GotoState(string name)
    {
        string str = string.Format("GameStateCtrl Goto State {0}", name);

        DebugHelper.Log(str);
        gameState.ChangeState(name);
    }

    public IState GetCurrentState()
    {
        return gameState.TopState();
    }

    public bool isBattleState
    {
        get { return (gameState.TopState() as BattleState) != null; }
    }

    public bool isLoadingState
    {
        get { return (gameState.TopState() as LoadingState) != null; }
    }

    public bool isLoginState
    {
        get { return (gameState.TopState() as LoginState) != null; }
    }

    public string currentStateName
    {
        get
        {
            var state = GetCurrentState();

            return state != null ? state.name : "unkown state";
        }
    }
}