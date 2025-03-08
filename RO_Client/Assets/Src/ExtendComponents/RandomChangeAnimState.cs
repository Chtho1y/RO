using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandomChangeAnimState : StateMachineBehaviour
{
    public float min;
    public float max;
    public int[] stateHashNames;

    private float m_ChangeAnim;
    private bool m_Changing = false;

    // OnStateEnter is called when a transition starts and the state machine starts to evaluate this state
    override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        m_ChangeAnim = Time.realtimeSinceStartup + Random.Range(min, max);
        m_Changing = true;
    }

    // OnStateUpdate is called on each Update frame between OnStateEnter and OnStateExit callbacks
    override public void OnStateUpdate(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        if (m_Changing && m_ChangeAnim <= Time.realtimeSinceStartup)
        {
            int index = Random.Range(0, stateHashNames.Length);
            animator.CrossFade(stateHashNames[index], 0.2f);
            m_Changing = false;
        }
    }

    // OnStateExit is called when a transition ends and the state machine finishes evaluating this state
    override public void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {

    }

    // OnStateMove is called right after Animator.OnAnimatorMove()
    //override public void OnStateMove(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
    //    // Implement code that processes and affects root motion
    //}

    // OnStateIK is called right after Animator.OnAnimatorIK()
    //override public void OnStateIK(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
    //    // Implement code that sets up animation IK (inverse kinematics)
    //}
}
