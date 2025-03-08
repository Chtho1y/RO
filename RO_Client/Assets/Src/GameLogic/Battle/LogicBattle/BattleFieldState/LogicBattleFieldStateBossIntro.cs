using UnityEngine;
using System.Collections;

/// <summary>
/// Boss出场阶段
/// </summary>
public class LogicBattleFieldStateBossIntro : LogicBattleFieldState
{
    public static LogicBattleFieldStateBossIntro Creator(LogicBattleField field)
    {
        return new LogicBattleFieldStateBossIntro(field);
    }

    float uiShowTime = 0;
    float duration = 0;
    bool openUI = false;
    ulong bossId = 0;
    public LogicBattleFieldStateBossIntro(LogicBattleField field)
        : base(field, LogicBattleFieldStateType.BossIntro)
    {
    }

    public override void OnEnter()
    {
        ForceIdle();
        for (int idx =0; idx < mField.Fighters.Count; idx++)
        {
            if (mField.Fighters[idx].IsBoss)
            {
                bossId = mField.Fighters[idx].InstanceId;
                break;
            }
        }
        openUI = false;
        uiShowTime = mField.BattleInfo.ShowBossIntroUITime;
        duration = mField.BattleInfo.ShowBossIntroDuration;
        BattleMgr.Instance.EnterBossIntro();
    }

    public override void OnLeave()
    {
        BattleMgr.Instance.ExitBossIntro();
    }


    public override void Update(float deltaTime)
    {
        uiShowTime -= deltaTime;
        duration -= deltaTime;
        if(duration <=0)
        {
            ChangeState(LogicBattleFieldStateType.Fighting);
        }
        else
        {
            if (uiShowTime <= 0 && !openUI)
            {
                UIMgr.Instance.Open(UIPageIDs.PAGE_ID_BOSS_INTRO, bossId);
                openUI = true;
            }
            mField.Battle.FighterMgr.FixedUpdate(deltaTime);
        }
    }

    public override void OnDataChanged()
    {
       
    }

    void ForceIdle()
    {
        for (int idx = 0; idx < mField.TeamFighters.Count;idx++)
        {
            mField.TeamFighters[idx].ForceIdle();
        }
    }
}
