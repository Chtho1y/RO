using UnityEngine;
using System.Collections;

public class FighterAttackBehavior : FighterBehavior
{
    public override void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        base.OnStateEnter(animator, stateInfo, layerIndex);
        //if (fighterCtrl != null)
        //{
        //    animator.SetFloat("moveSpeed", fighterCtrl.AnimSpeed);
        //}
    }
}
