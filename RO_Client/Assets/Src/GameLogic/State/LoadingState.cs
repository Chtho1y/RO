using UnityEngine;
using System.Collections;

[GameStateAttribute]
public class LoadingState : BaseState
{
    // 这样做的目的是为了解决游戏从战斗状态退回大厅状态还会依然音乐一些战斗bank资源的情况
    // 这样每个LevelBank的卸载将会发生在下一个levelbank要加载时
    // 这是一个折衷
    // 直到找到更好的解决方法时为止        
    private string LastLevelBank;

    public override void OnStateEnter()
    {
        UIMgr.Instance.CloseAllPage();
        UIMgr.Instance.Open(UIPageIDs.PAGE_ID_LOADING);  
    }

    public override void OnStateLeave()
    {
    }
}
