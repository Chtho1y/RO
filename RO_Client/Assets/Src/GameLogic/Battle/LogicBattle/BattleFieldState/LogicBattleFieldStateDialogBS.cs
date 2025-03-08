using UnityEngine;
using System.Collections;

public class LogicBattleFieldStateDialogBS : LogicBattleFieldState
{
    public static LogicBattleFieldStateDialogBS Creator(LogicBattleField field)
    {
        return new LogicBattleFieldStateDialogBS(field);
    }

    public LogicBattleFieldStateDialogBS(LogicBattleField field)
       :base(field,LogicBattleFieldStateType.DialogBeforeSearch)
    {

    }

    int curDlgId = 0;
    bool dlgFinished = false;

    public override void OnEnter()
    {
        curDlgId = mField.BattleInfo.DlgId;
        if(curDlgId > 0)
        {
            dlgFinished = false;
            EventMgr.AddEventListener<int>(ECoreEventType.EID_Dialogue_Finished, onDialogueFinished);
            GameMgr.Instance.PlayDialog(curDlgId);
        }
        else
        {
            dlgFinished = true;
        }
    }

    public override void OnLeave()
    {
        if(curDlgId > 0)
        {
            EventMgr.RemoveEventListener<int>(ECoreEventType.EID_Dialogue_Finished, onDialogueFinished);
        }
    }

    public override void Update(float deltaTime)
    {
        if(dlgFinished)
        {
            ChangeState(LogicBattleFieldStateType.Search);
        }
        else
        {
            mField.Battle.FighterMgr.FixedUpdate(deltaTime);
        }
    }

    public override void OnDataChanged()
    {
        
    }

    private void onDialogueFinished(CoreEvent<int> ce)
    {
        int dlgId = ce.Data;
        if(dlgId == curDlgId)
        {
            dlgFinished = true;
        }
    }
}
