using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class VersusBattleFieldStateStart : VersusBattleFieldState
{
    public static VersusBattleFieldState Creator(VersusBattleField field)
    {
        return new VersusBattleFieldStateStart(field);
    }

    public VersusBattleFieldStateStart(VersusBattleField field)
        : base(field, VersusBattleFieldStateType.Start)
    {
    }

    public override void OnEnter()
    {
        mField.Battle.SetSpawnedFighterPosition();
    }

    public override void OnLeave()
    {
    }

    public override void Update(float deltaTime)
    {
        if (mField.Battle.IsAllFightersReady())
        {
            ChangeState(VersusBattleFieldStateType.Interlude);
        }
        else
        {
            mField.Battle.FighterMgr.FixedUpdate(deltaTime);
        }
    }

    public override void OnDataChanged()
    {

    }
}
