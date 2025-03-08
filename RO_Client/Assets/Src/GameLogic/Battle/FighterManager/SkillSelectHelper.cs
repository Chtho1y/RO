using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 选择目标处理
/// </summary>
public sealed class SkillSelectHelper
{
	public delegate bool CheckFighterCallback (Fighter fighter);

	public delegate int CompareFighterCallback (Fighter fighter1, Fighter fighter2, Target_Select_Rule rule);

    public static int CompareFighterByRules(Fighter selfFighter, Fighter fighter1, Fighter fighter2, int selectRule, CompareFighterCallback postComparer = null)
    {
        int result = CompareFighterByRule(selfFighter, fighter1, fighter2,(Target_Select_Rule)selectRule);
        if (result != 0)
            return result;

        if (postComparer != null)
            return postComparer(fighter1, fighter2, (Target_Select_Rule)selectRule);

        return 0;
    }

    public static bool CheckFighter (Fighter selfFighter,Fighter fighter, int selectRule)
	{
		if (fighter == null || fighter.IsDisposed || !fighter.IsAlive)
			return false;

		Target_Select_Rule rule = (Target_Select_Rule)selectRule;
		switch (rule) { 
            case Target_Select_Rule.Target_Select_Self:
                return selfFighter == fighter;
            default:
			    return true;
		}
	}

	public static int CompareFighterByRule (Fighter selfFighter, Fighter fighter1, Fighter fighter2, Target_Select_Rule rule)
	{
        if(rule == Target_Select_Rule.Target_Select_LeastBlood)
        {
            if (fighter1.Life < fighter2.Life) return 1;

            if (fighter1.Life > fighter2.Life) return -1;

            if (fighter1.MaxLife < fighter2.MaxLife) return 1;

            if (fighter1.MaxLife > fighter2.MaxLife) return -1;
        }
        else if(rule == Target_Select_Rule.Target_Select_MostLife)
        {
            if (fighter1.Life > fighter2.Life) return 1;

            if (fighter1.Life < fighter2.Life) return -1;

            if (fighter1.MaxLife > fighter2.MaxLife) return 1;

            if (fighter1.MaxLife < fighter2.MaxLife) return -1;
        }
        else if(rule == Target_Select_Rule.Target_Select_Most_NegativeBuff)
        {
            if (fighter1.NegativeBuffCnt > fighter2.NegativeBuffCnt) return 1;

            if (fighter1.NegativeBuffCnt < fighter2.NegativeBuffCnt) return -1;
        }
        else if(rule == Target_Select_Rule.Target_Select_Most_LeastLifePercent)
        {
            if (fighter1.Life/fighter1.MaxLife < fighter2.Life/fighter2.MaxLife) return 1;

            if (fighter1.Life / fighter1.MaxLife > fighter2.Life / fighter2.MaxLife) return -1;

            if (fighter1.Life < fighter2.Life) return 1;

            if (fighter1.Life > fighter2.Life) return -1;
        }
        else
        {
            //if (fighter1.IsFront && fighter2.IsBack) return 1;
            //if (fighter1.IsBack && fighter2.IsFront) return -1;
        }

        float d1 = Vector3.SqrMagnitude(selfFighter.Position - fighter1.Position) - (selfFighter.ModelSize + fighter1.ModelSize);
        float d2 = Vector3.SqrMagnitude(selfFighter.Position - fighter2.Position) - (selfFighter.ModelSize + fighter2.ModelSize);
        if (Mathf.Abs(d1 - d2) < 0.2f)
        {
            if (fighter1.Actor.Profession < fighter2.Actor.Profession) return 1;
            if (fighter1.Actor.Profession > fighter2.Actor.Profession) return -1;

            return fighter1.PositionValue < fighter2.PositionValue ? 1 : -1;
        }
        else 
        { 
            return d1 < d2 ? 1 : d1 > d2 ? -1 : 0;
        }
    }

    public static Fighter SelectTargetsByRules(Fighter selfFighter, List<Fighter> fighters, Target_Select_Rule rule, CheckFighterCallback preFilter = null, CompareFighterCallback postComparer = null)
    {
        if (fighters.Count == 0)
            return null;

        int selectRule = (int)rule;

        Fighter fighter = null;
        int idx = 0;
        while (idx < fighters.Count)
        {
            Fighter f = fighters[idx];
            if (f != null && !f.IsDisposed && f.IsAlive && (preFilter == null || preFilter(f)) && CheckFighter(selfFighter,f, selectRule))
            {
                fighter = f;
                break;
            }
            idx++;
        }

        if (fighter == null)
            return null;

        for (int i = idx + 1; i < fighters.Count; i++)
        {
            Fighter f = fighters[i];

            if (f == null || f.IsDisposed)
                continue;

            if (preFilter != null && !preFilter(f))
                continue;

            if (!CheckFighter(selfFighter,f, selectRule))
                continue;

            int compare = CompareFighterByRules(selfFighter, fighter, f, selectRule, postComparer);
            if (compare < 0)
                fighter = f;
        }

        return fighter;
    }

	static bool CheckTargetTeam (BaseSkill skill, Fighter caster, Fighter target)
	{
        return true;
	}

	public static bool IsSkillCanTargetSelf (BaseSkill skill)
	{
        return true;
	}

	public static bool CheckTargetSelectable (BaseSkill skill, Fighter caster, Fighter target)
	{
		return target.IsSpawned && !target.IsDisposed && target.IsAlive
			&& (target.IsFighting)
			&& (IsSkillCanTargetSelf(skill) || target != caster)
			&& CheckTargetTeam(skill, caster, target);
	}
}

