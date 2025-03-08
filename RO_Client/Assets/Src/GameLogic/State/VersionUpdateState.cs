using UnityEngine;
using System.Collections;

[GameStateAttribute]
public class VersionUpdateState : BaseState
{
    public override void OnStateEnter()
    {
        //DebugHelper.ConsoleLog("Enter State: VersionUpdateState");
        //ResourceLoader.GetInstance().LoadScene("EmptySceneWithCamera", null);

        ////判断网络连接
        //if (Application.internetReachability == NetworkReachability.NotReachable)
        //{
        //    CUIEventManager.GetInstance().AddUIEventListener(enUIEventID.CheckDevice_Quit, OnExitGame);
        //    CUIManager.GetInstance().OpenMessageBox(CTextManager.GetInstance().GetText("VersionUpdate_NetworkUnReachable"), enUIEventID.CheckDevice_Quit); /*"网络不可用*/
        //}
        //else
        //{
        //    //开始版本更新流程
        //    CVersionUpdateSystem.GetInstance().StartVersionUpdate(OnVersionUpdateComplete);
        //}
    }

    public override void OnStateLeave()
    {
        //DebugHelper.ConsoleLog("Exit State: VersionUpdateState");
    }

    private void OnVersionUpdateComplete()
    {
        //GameStateCtrl.GetInstance().GotoState("MovieState");
    }

    //private void OnExitGame(CUIEvent uiEvent)
    //{
    //    CUIEventManager.GetInstance().RemoveUIEventListener(enUIEventID.CheckDevice_Quit, OnExitGame);
    //    CVersionUpdateSystem.QuitApp();
    //}
}