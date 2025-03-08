using UnityEngine;
using System.Collections;

[GameStateAttribute]
public class LoginState : BaseState
{
    public override void OnStateEnter()
    {
        UIMgr.Instance.Open(UIPageIDs.PAGE_ID_LOGIN);
        MusicMgr.Instance.PlayBGMusic("bgm_login");
        DebugHelper.Log("LoginScene begin load");
    }

    private void OnLoginSceneCompleted()
    {      
    }

    public override void OnStateLeave()
    {
        UIMgr.Instance.Close(UIPageIDs.PAGE_ID_LOGIN);
        base.OnStateLeave();

    }
}
