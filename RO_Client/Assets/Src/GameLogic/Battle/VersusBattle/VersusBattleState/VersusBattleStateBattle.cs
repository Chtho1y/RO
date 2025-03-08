using UnityEngine;
using System.Collections;

public class VersusBattleStateBattle : VersusBattleState
{
    public static VersusBattleState Creator(VersusBattle battle)
    {
        return new VersusBattleStateBattle(battle);
    }

    public VersusBattleStateBattle(VersusBattle battle)
        : base(battle, VersusBattleStateType.Battle)
    {
    }

    public override void OnEnter()
    {
        BattleCamera.Instance.Initialize(mBattle);
        MusicMgr.Instance.PlayBGMusic(mBattle.BgMusic);
        mBattle.CreateTeamFighters();
        mBattle.CreateEnemyFighters();
        BattleMgr.Instance.SetBattleCamera();
        mBattle.StartVersus();
    }

    public override void OnLeave()
    {
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

            if (mBattle.CurBattleField.IsIdleState)
            {
                if (mBattle.CurBattleField.IsWin)
                {
                    ChangeState(VersusBattleStateType.BattleWin);
                }
                else
                {
                    ChangeState(VersusBattleStateType.BattleFailed);
                }
            }
        }
        else
        {
            ChangeState(VersusBattleStateType.End);
        }
    }
}
