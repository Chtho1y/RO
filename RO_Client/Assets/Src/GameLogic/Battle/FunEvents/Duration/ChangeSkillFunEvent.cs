using UnityEngine;
using System.Collections;

public class ChangeSkillFunEvent : DurationFunctionEvent
{

    public static ChangeSkillFunEvent Creator(BuffFunctionData data)
    {
        return new ChangeSkillFunEvent(data);
    }

    public ChangeSkillFunEvent(BuffFunctionData data):base(data)
    {
        mType = Buff_Function_Type.ChangeSkill;
    }

    bool skillChanged = false;
    int[] fromSkills = null;
    int[] toSkills = null;
    bool bProcessSlowing = false;
    public override void Enter(Fighter fighter)
    {
        base.Enter(fighter);
        fromSkills = StringUtil.split2Int(HitInfo.AttackInfo.fromSkills, ';');
        toSkills = StringUtil.split2Int(HitInfo.AttackInfo.toSkills, ';');
        if (fromSkills == null || toSkills == null) return;

        if (HitInfo!=null && HitInfo.AttackInfo!=null && fromSkills.Length > 0 && toSkills.Length > 0 && fromSkills.Length == toSkills.Length)
        {
            for(int idx =0; idx < fromSkills.Length;idx++)
            {
               bool bOk = fighter.ChangeSkill(fromSkills[idx], toSkills[idx]);
               skillChanged |= bOk;
            }

            if (skillChanged && Data.buffType == BattleBuffType.Negative)
            {
                bProcessSlowing = true;
                fighter.ProcessSlow(true);
            }
        }
       
    }

    public override void Exit(Fighter fighter)
    {
        if(skillChanged)
        {
            for (int idx = 0; idx < fromSkills.Length; idx++)
            {
                skillChanged = fighter.ChangeSkill(toSkills[idx], fromSkills[idx]);
            }
        }
        if(bProcessSlowing)
        {
            fighter.ProcessSlow(false);
        }
        base.Exit(fighter);
    }
}
