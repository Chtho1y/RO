using UnityEngine;
using System.Collections;

public class BossBattleStateBattle : BossBattleState
{

    public static BossBattleStateBattle Creator(BossBattle battle)
    {
        return new BossBattleStateBattle(battle);
    }

    public BossBattleStateBattle(BossBattle battle) :
        base(battle, BossBattleStateType.Battle)
    {
    }

    public override void OnEnter()
    {
        BattleCamera.Instance.Initialize(mBattle);
        MusicMgr.Instance.PlayBGMusic(mBattle.BgMusic);
        BattleMgr.Instance.SetBattleCamera();
        mBattle.BeginFight();
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

            if(mBattle.CurBattleField.IsIdleState)
            {
                if (mBattle.CurBattleField.IsWin)
                {
                    ChangeState(BossBattleStateType.BattleWin);
                }
                else
                {
                    ChangeState(BossBattleStateType.BattleFailed);
                }
            }
        }
        else
        {
            ChangeState(BossBattleStateType.End);
        }
    }
}
