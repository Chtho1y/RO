using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;

public class SkillHitRange
{
	LogicTransformHitType mHitType;
	Vector3 mCenter;
	Vector3 mForward;
	Vector3 mSize;
	List<Fighter> mTempHitFighterList;

	bool mIsValid = false;

	public Vector3 Center { get { return mCenter; } }

	public Vector3 Forward { get { return mForward; } }

	public Vector3 Size { get { return mSize; } }

	public void Set (Fighter caster, Fighter target, SkillActionAttackInfo attackInfo, Bullet bullet = null)
	{
		mIsValid = false;

		Vector3 boundDir = Vector3.forward;
		Vector3 boundPos = new Vector3 (0, attackInfo.rangeOffsetY, attackInfo.rangeOffsetX);
		Vector3 boundSize = new Vector3 (attackInfo.rangeX + target.ModelSize, attackInfo.rangeY+target.ModelSize, target.ModelSize);
		if (attackInfo.rangeType == SkillRangeType.RangeType_Caster)
        {
			boundPos = caster.TransformPoint (boundPos);
			boundDir = caster.Forward;
		}
        else if (attackInfo.rangeType == SkillRangeType.RangeType_Target)
        {
			if (target != null) {
				boundPos = target.TransformPoint (boundPos);
				boundDir = target.Forward;
			} else
				return;
		}
        else if (attackInfo.rangeType == SkillRangeType.RangeType_Position)
        {
			boundDir = caster.Forward;
			boundPos = caster.TransformPoint (boundPos + Vector3.forward * attackInfo.skill.GetSkillDist((int)caster.ProfType));
		}
        else if (attackInfo.rangeType == SkillRangeType.RangeType_Bullet)
        {
			if (bullet != null) {
				boundDir = bullet.Forward;
				boundPos = bullet.TransformPoint (boundPos);
			} else
				return;
		} else
			return;

		if (attackInfo.normalizeRangeDir && caster.CurrentBattleField != null)
        {
			if (Vector3.Dot (boundDir, caster.CurrentBattleField.Forward) < 0)
				boundDir = -caster.CurrentBattleField.Forward;
			else
				boundDir = caster.CurrentBattleField.Forward;
		}
		mHitType = LogicTransformHitType.Box;
		mCenter = boundPos;
		mSize = boundSize;
		mForward = boundDir;
		mIsValid = true;
	}

	public bool CheckHitFighter (Fighter fighter, Nullable<Vector3> centerPos= null,string linkName = "")
	{
        Vector3 pos = fighter.Position;
        if(!string.IsNullOrEmpty(linkName))
        {
            pos = fighter.Ctrl.GetPosByLink(linkName);
        }

        Vector3 cPos = mCenter;
        if(centerPos!=null)
        {
            cPos = centerPos.Value;
        }
		return mIsValid && fighter.CheckHitBoxUnscrict(pos, cPos, mForward, mSize);
	}

	public void SortFightersByCenterDistance (List<Fighter> fighters)
	{

		CommonUtil.SortList(fighters, (a, b)=>
			{
				float ld = Vector3.SqrMagnitude(a.Position - mCenter);
				float rd = Vector3.SqrMagnitude(b.Position - mCenter);
				return ld < rd ? -1 : (ld > rd ? 1 : 0);
			});
	}


	public List<Fighter> GetSkillHitFighters (Fighter caster, BaseSkill skill, List<Fighter> checkList, bool isBulletHit = false, List<Fighter> exceptList = null)
	{
		if (mTempHitFighterList == null)
			mTempHitFighterList = new List<Fighter> ();
		mTempHitFighterList.Clear ();

        //int maxCount = skill.SkillDataInfo.maxTargetNumber;
        int maxCount = 1;
		if (exceptList != null)
			maxCount -= exceptList.Count;
		if (maxCount <= 0)
			return mTempHitFighterList;
		
		for (int i = 0; i < checkList.Count; i++) {
            Fighter f = checkList[i];
            if (SkillSelectHelper.CheckTargetSelectable (skill, caster, f)
			    && CheckHitFighter (f)
			    && (exceptList == null || !exceptList.Contains (f)))
				mTempHitFighterList.Add (f);
		}

		if (isBulletHit || mTempHitFighterList.Count > maxCount)
			SortFightersByCenterDistance (mTempHitFighterList);
		
		if (mTempHitFighterList.Count > maxCount)
			mTempHitFighterList = mTempHitFighterList.GetRange (0, maxCount);
		
		return mTempHitFighterList;
	}
}

