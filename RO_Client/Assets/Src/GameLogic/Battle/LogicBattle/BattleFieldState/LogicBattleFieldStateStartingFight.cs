
public class LogicBattleFieldStateStartingFight : LogicBattleFieldState
{
	public static bool disable_sync_script_by_test = false;

	const float starting_fight_time = 1;

	public static LogicBattleFieldState Creator (LogicBattleField field)
	{
		return new LogicBattleFieldStateStartingFight (field);
	}

	public LogicBattleFieldStateStartingFight (LogicBattleField field) 
        : base (field, LogicBattleFieldStateType.StartingFight)
	{
	}

	enum StartingState
	{
		None,
		Show_Boss_Intro,    //boss展示
		Show_Starting,  //开始战斗动画
	}

	StartingState mCurrentStartingState;
	float mCurrentStartingStateTime;

	public override void OnEnter ()
	{
        BattleMgr.Instance.SetBattleCamera();
        mCurrentStartingState = StartingState.None;
		mCurrentStartingStateTime = 0;
	}

	public override void OnLeave ()
	{
	}

	public override void Update (float deltaTime)
	{
        if (mCurrentStartingState == StartingState.None)
        {
            BattleMgr.Instance.ShowStartFighting();
            mCurrentStartingState = StartingState.Show_Starting;
            mCurrentStartingStateTime = 0;
        }
        else if (mCurrentStartingState == StartingState.Show_Boss_Intro)
        {
            BattleMgr.Instance.ShowStartFighting();
            mCurrentStartingState = StartingState.Show_Starting;
            mCurrentStartingStateTime = 0;
        }
        else if (mCurrentStartingState == StartingState.Show_Starting)
        {
            mCurrentStartingStateTime += deltaTime;
            if (mCurrentStartingStateTime >= 0.0f)
                NextState();
        }
        else
        { 
            NextState();
        }
    }

    public override void OnDataChanged()
    {

    }

    void NextState ()
	{
        ChangeState(LogicBattleFieldStateType.Fighting);
    }
}
