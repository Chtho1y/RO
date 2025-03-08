
public class LogicBattleStateEnd : LogicBattleState
{
	public static LogicBattleState Creator (LogicBattle battle)
	{
		return new LogicBattleStateEnd (battle);
	}

	public LogicBattleStateEnd (LogicBattle battle) 
        : base (battle, LogicBattleStateType.End)
	{
	}

    float waitTime = 1.0f;
    bool notify = false;
    public override void OnEnter ()
	{
        //EventMgr.DispatchEvent<bool>(new CoreEvent<bool>(ECoreEventType.EID_BATTLE_NEXT_MAP, true));
    }

	public override void OnLeave ()
	{
	}

	public override void Update (float deltaTime)
	{
    }
}