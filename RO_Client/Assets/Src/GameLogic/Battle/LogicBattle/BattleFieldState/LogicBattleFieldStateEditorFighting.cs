using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class LogicBattleFieldStateEditorFighting : LogicBattleFieldState
{
    public static LogicBattleFieldState Creator(LogicBattleField field)
    {
        return new LogicBattleFieldStateEditorFighting(field);
    }

    public LogicBattleFieldStateEditorFighting(LogicBattleField field)
        : base(field, LogicBattleFieldStateType.EditorFighting)
    {
    }

    public override void OnEnter()
    {
        List<Fighter> fighters = mField.Fighters;
        for (int i = 0; i < fighters.Count; i++)
        {
            fighters[i].OnFightingStart();
        }
    }

    public override void Update(float deltaTime)
    {
    }

    public override void OnLeave()
    {
        for (int idx = 0; idx < mField.Fighters.Count; idx++)
        {
            Fighter fighter = mField.Fighters[idx];
            if (!fighter.IsDisposed && fighter.IsSpawned)
                fighter.OnFightingEnd();
        }
    }

    public override void OnDataChanged()
    {

    }
}
