using UnityEngine;
using System.Collections;

public class TimeBattleStateBattle : TimeBattleState
{
    public static TimeBattleStateBattle Creator(TimeBattle battle)
    {
        return new TimeBattleStateBattle(battle);
    }

    public TimeBattleStateBattle(TimeBattle battle):
        base(battle,TimeBattleStateType.Battle)
    {

    }

    public override void OnEnter()
    {
        BattleCamera.Instance.Initialize(mBattle);
        MusicMgr.Instance.PlayBGMusic(mBattle.BgMusic);
        BattleMgr.Instance.SetBattleCamera();
        mBattle.Fight();
    }

    public override void Update(float deltaTime)
    {
        if (mBattle.CurBattleField != null)
        {
#if PROFILE
            UnityEngine.Profiling.Profiler.BeginSample("mBattle.CurrentBattleField update");
#endif
            mBattle.CurBattleField.Update(deltaTime);
#if PROFILE
            UnityEngine.Profiling.Profiler.EndSample();
#endif
            if (mBattle.CurBattleField.Result == FightingResult.Peace)
            {                
                ChangeState(TimeBattleStateType.End);
                BattleMgr.Instance.OnBattleForceStop(true);
                return;
            }
            if (mBattle.CurBattleField.IsIdleState)
            {
                if(mBattle.CurBattleField.Result == FightingResult.Win)
                {
                    ChangeState(TimeBattleStateType.BattleWin);
                }   
                else if(mBattle.CurBattleField.Result == FightingResult.Failed)
                {
                    ChangeState(TimeBattleStateType.BattleFailed);
                }
            }
        }
        else
        {
            ChangeState(TimeBattleStateType.End);
        }
    }

    public override void OnLeave()
    {
        
    }
}
