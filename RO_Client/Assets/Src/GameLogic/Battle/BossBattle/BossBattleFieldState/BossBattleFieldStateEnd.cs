using UnityEngine;
using System.Collections;

public class BossBattleFieldStateEnd : BossBattleFieldState
{
    public static BossBattleFieldState Creator(BossBattleField field)
    {
        return new BossBattleFieldStateEnd(field);
    }

    public BossBattleFieldStateEnd(BossBattleField field)
        : base(field, BossBattleFieldStateType.End)
    {
    }

    public override void OnEnter()
    {
    }

    public override void OnLeave()
    {
    }

    public override void Update(float deltaTime)
    {
        ChangeState(BossBattleFieldStateType.None);
    }

    public override void OnDataChanged()
    {

    }
}