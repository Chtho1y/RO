using System;
using UnityEngine;
using System.Collections;


[GameStateAttribute]
public class BattleState : BaseState
{
    SkinWeights m_originalBlendWeight;
    public override void OnStateEnter()
    {
        UIMgr.Instance.Close(UIPageIDs.PAGE_ID_LOADING);
    }

    public override void OnStateLeave()
    {
    }
}