using UnityEngine;
using System.Collections;

public class VersusBattleFieldStateEnd : VersusBattleFieldState
{
    public static VersusBattleFieldState Creator(VersusBattleField field)
    {
        return new VersusBattleFieldStateEnd(field);
    }

    public VersusBattleFieldStateEnd(VersusBattleField field)
        : base(field, VersusBattleFieldStateType.End)
    {
    }

    public override void OnEnter()
    {
        mField.Battle.EndStatistics();
    }

    public override void OnLeave()
    {
    }

    public override void Update(float deltaTime)
    {
        ChangeState(VersusBattleFieldStateType.None);
    }

    public override void OnDataChanged()
    {
    }
}