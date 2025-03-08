using UnityEngine;
using System.Collections;

public class BossBattleFieldStateDialogBI : BossBattleFieldState
{
    public static BossBattleFieldState Creator(BossBattleField field)
    {
        return new BossBattleFieldStateDialogBI(field);
    }

    public BossBattleFieldStateDialogBI(BossBattleField field)
        : base(field, BossBattleFieldStateType.DialogBeforeInterlude)
    {

    }

    public override void OnEnter()
    {
        
    }

    public override void Update(float deltaTime)
    {
        
    }

    public override void OnLeave()
    {
        
    }

    public override void OnDataChanged()
    {
        
    }
}
