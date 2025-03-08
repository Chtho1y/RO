using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimChangeSkinState : StateMachineBehaviour
{
    private const int c_DefaultValue = 0;
    [HideInInspector][SerializeField]
    private int[] m_SkinSlotTypes;
    [HideInInspector][SerializeField]
    private int[] m_RoleAvatarIds;

    private AnimControlSkin animControlSkin;

    override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        if (!animControlSkin)
            animControlSkin = animator.GetComponent<AnimControlSkin>();
        if (animControlSkin)
        {
            animControlSkin.ChangeSkins(m_SkinSlotTypes, m_RoleAvatarIds);
        }
    }

    override public void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        if (!animControlSkin)
            animControlSkin = animator.GetComponent<AnimControlSkin>();
        if (animControlSkin)
        {
            int length = m_SkinSlotTypes.Length;
            int[] defaultRoleAvatarIds = new int[length];
            for (length = length - 1; length >=0; length--)
            {
                defaultRoleAvatarIds[length] = c_DefaultValue;
            }
            animControlSkin.ChangeSkins(m_SkinSlotTypes, defaultRoleAvatarIds);
        }
    }
}
