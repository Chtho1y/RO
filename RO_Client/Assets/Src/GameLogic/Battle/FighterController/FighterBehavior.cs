
using UnityEngine;
using System.Collections;

public class FighterBehavior : StateMachineBehaviour
{
    protected FighterGoCtrl fighterCtrl;

    public override void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        base.OnStateEnter(animator, stateInfo, layerIndex);
        if (fighterCtrl == null)
        {
            if(animator.transform.parent!=null)
                fighterCtrl = animator.transform.parent.GetComponent<FighterGoCtrl>();
        }

        animator.speed = 1;
    }

    public override void OnStateUpdate(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        base.OnStateUpdate(animator, stateInfo, layerIndex);
    }

    public override void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        base.OnStateExit(animator, stateInfo, layerIndex);
    }
}
