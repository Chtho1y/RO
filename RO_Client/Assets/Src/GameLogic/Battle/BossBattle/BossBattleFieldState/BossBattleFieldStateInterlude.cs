using UnityEngine;
using System.Collections;

public class BossBattleFieldStateInterlude : BossBattleFieldState
{
    public static BossBattleFieldState Creator(BossBattleField field)
    {
        return new BossBattleFieldStateInterlude(field);
    }

    public BossBattleFieldStateInterlude(BossBattleField field)
        :base(field,BossBattleFieldStateType.Interlude)
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
