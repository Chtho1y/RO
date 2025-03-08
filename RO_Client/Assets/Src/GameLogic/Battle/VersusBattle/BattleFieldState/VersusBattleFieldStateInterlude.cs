using UnityEngine;
using System.Collections;

public class VersusBattleFieldStateInterlude : VersusBattleFieldState
{
    public static VersusBattleFieldState Creator(VersusBattleField field)
    {
        return new VersusBattleFieldStateInterlude(field);
    }

    public VersusBattleFieldStateInterlude(VersusBattleField field)
        :base(field, VersusBattleFieldStateType.Interlude)
    {

    }

    public override void OnEnter()
    {
        BattleMgr.Instance.PerformStartCamera(mField.battleInfo.CamCfgList,true);
    }

    public override void OnLeave()
    {
        
    }

    public override void Update(float deltaTime)
    {
        mField.Battle.FighterMgr.FixedUpdate(deltaTime);
        UpdateTriggers();

        if (BattleMgr.Instance.IsCameraDoingStart)
            return;

        ChangeState(VersusBattleFieldStateType.StartingFight);
    }

    public override void OnDataChanged()
    {
        
    }

    void UpdateTriggers()
    {
        //if (mField.Battle.BattleScene.SceneTriggers != null)
        //    foreach (var t in mField.Battle.BattleScene.SceneTriggers)
        //        foreach (var fighter in mField.Battle.FighterMgr.Fighters)
        //            t.TryTriggerFighter(fighter);
    }

}
