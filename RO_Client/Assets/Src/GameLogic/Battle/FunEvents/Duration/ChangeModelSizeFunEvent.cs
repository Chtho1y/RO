using UnityEngine;
using System.Collections;

public class ChangeModelSizeFunEvent : DurationFunctionEvent
{
    private float m_fSaveScanle = 1.0f;
    public static ChangeModelSizeFunEvent Creator(BuffFunctionData data)
    {
        return new ChangeModelSizeFunEvent(data);
    }

    public ChangeModelSizeFunEvent(BuffFunctionData data):base(data)
    {
        mType = Buff_Function_Type.Body_Size_Change_Value;
    }

    public override void Enter(Fighter fighter)
    {
        m_fSaveScanle = fighter.Scale;
        if (fighter != null && fighter.IsAlive)
            fighter.Ctrl.StartScale(0.1f, (1+mData.value * 0.01f), mData.duration, 0.1f);

        //DebugHelper.LogError("changesize:" + Data.duration);
        base.Enter(fighter);
    }

    public override void Exit(Fighter fighter)
    {
        //DebugHelper.LogError("exit changesize:" + Data.duration);
        if (fighter != null && fighter.IsAlive)
            fighter.Ctrl.StartScale(0.1f, m_fSaveScanle, mData.duration, 0.1f);

        base.Exit(fighter);
    }
}
