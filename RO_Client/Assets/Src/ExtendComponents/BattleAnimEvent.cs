using UnityEngine;
using System.Collections;

public class BattleAnimEvent : MonoBehaviour
{
    //打开boss显示信息界面
    public void ShowBossInfo(int bossId)
    {
        //UIMgr.Instance.Open(UIPageIDs.PAGE_ID_BOSS_INTRO);
    }

    //boss出场动画结束
    public void BossIntroEnd()
    {
       // BattleSystemNew.Instance.ShowBossIntroEnd = true;
    }
}
