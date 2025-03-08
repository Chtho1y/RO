using System;
using System.Collections.Generic;

public struct SkillStatistics
{
	public string skillIcon;
	public int skillType;
	public int skillId;
	public int skillLevel;

	public int cnt;
	public int breakCnt;

	public int damage;
	public int heal;
	public int absorb;

	public int critCnt;
	public int beBlockCnt;
	public int beDodgeCnt;
	public int bePerfectDodgeCnt;

	public int createdCnt;

	public List<float> castingTimeList;


	public void Casting(float castingTime)
	{
		if (castingTimeList == null)
			castingTimeList = new List<float>();

		castingTimeList.Add(castingTime);
		cnt++;
	}

	public void AddCreateCnt()
	{
		createdCnt++;
	}

	public void ResetCreateCnt()
	{
		createdCnt = 0;
	}


}

public class FighterStatistics
{
	public ulong fighterInstId;
	public long fighterId;
	public long usedPetId;

	public string actorName;
	public string jobIcon;
	public string headIcon;
	public int level;

	public int damage = 0;		//输出
	public int heal = 0;		//治疗
	public int hurt = 0;        //受伤
	public int addSp = 0;

    public int reflectdamage = 0; //反弹伤害
    public int basedamage = 0; //基础输出
    public int naturedamage = 0;//元素输出
    public int petdamage = 0;   //宠物输出

    public float basedamagePercent = 0; //基础输出比例
    public float naturedamagePercent = 0;//元素输出比例
    public float petdamagePercent = 0;   //宠物输出比例

    public float damagePercent = 0;
	public float healPercent = 0;
	public float hurtPercent = 0;
	public float heroDamagePercent = 0;
	public float heroHealPercent = 0;
	public float heroHurtPercent = 0;

	public int critCnt = 0;
	public int blockCnt = 0;
	public int dodgeCnt = 0;
	public int beCritCnt = 0;
	public int beBlockCnt = 0;
	public int beDodgeCnt = 0;
	public int buffCnt = 0;

	public SkillStatistics[] skillStatistics;

	private int mBeginFrame = 0;

	private bool mDirty = false;
	public bool Dirty
	{
		get { return mDirty; }
		set { mDirty = value; }
	}

	public FighterStatistics(Fighter fighter, int frameCnt)
	{
		actorName = fighter.Name;
		jobIcon = fighter.Actor.ProfessionIcon;
		headIcon = fighter.Actor.HeadIcon;
		level = fighter.Actor.Level;

		mBeginFrame = frameCnt;
		fighterInstId = fighter.InstanceId;
		fighterId = fighter.Id;
		usedPetId = fighter.UsedPetId;
		skillStatistics = new SkillStatistics[5];
		for (int i = 0; i < skillStatistics.Length; i++) 
		{ 
			skillStatistics[i].skillType = i;
		}
	}

	public void StatHitInfo(SkillHitFighterInfo hitInfo)
	{
		if (hitInfo.Caster != null && hitInfo.Caster.InstanceId == fighterInstId)
		{
			if(hitInfo.Skill != null && hitInfo.Skill.SkillTypeID>=0 && hitInfo.Skill.SkillTypeID < skillStatistics.Length)
			{
				int skillType = hitInfo.Skill.SkillTypeID;
				if (hitInfo.IsImmunity)
					skillStatistics[skillType].beBlockCnt++;
				else if (hitInfo.IsDodge)
					skillStatistics[skillType].beDodgeCnt++;
				else if (hitInfo.IsPerfectDodge)
					skillStatistics[skillType].bePerfectDodgeCnt++;
				else
				{
					if (hitInfo.IsCrit)
					{
						critCnt++;
						skillStatistics[skillType].critCnt++;
					}

					if (hitInfo.Damage > 0)
					{
						int hitDamage = UnityEngine.Mathf.RoundToInt(hitInfo.Damage);
						damage += hitDamage;
                        basedamage += UnityEngine.Mathf.RoundToInt(hitInfo.BaseDamge);
                        naturedamage += UnityEngine.Mathf.RoundToInt(hitInfo.NatureDamge);
                        skillStatistics[skillType].damage += hitDamage;
					}
				}
			}
			else
			{
				if (hitInfo.Damage > 0)
				{
					int hitDamage = UnityEngine.Mathf.RoundToInt(hitInfo.Damage);
					damage += hitDamage;
                    basedamage += UnityEngine.Mathf.RoundToInt(hitInfo.BaseDamge);
                    naturedamage += UnityEngine.Mathf.RoundToInt(hitInfo.NatureDamge);
                }
			}

			mDirty = true;
		}
	}

	public void StatOtherDamage(Fighter f, int dmg)
	{
		if (f != null && f.InstanceId == fighterInstId && dmg > 0)
		{
			damage += dmg;
			mDirty = true;
		}
	}

	public void StatReflectInfo(Fighter f,int reflectDamage)
	{
		if(f != null && f.InstanceId == fighterInstId && reflectDamage > 0)
		{
			damage += reflectDamage;
            reflectdamage += reflectDamage;
            mDirty = true;
		}
	}

	public void StatBeHitInfo(SkillHitFighterInfo hitInfo)
	{
		if (hitInfo.Target != null  &&  hitInfo.Target.InstanceId == fighterInstId)
		{
			if (hitInfo.IsImmunity)
				blockCnt++;
			else if (hitInfo.IsDodge)
				dodgeCnt++;
			else if (hitInfo.IsCrit)
				beCritCnt++;

			if(hitInfo.Attack > 0)
			{
				hurt += (int)hitInfo.Attack;
			}

			mDirty = true;
		}
	}

	public void StatReflectHurtInfo(Fighter f,int reflectHurt)
	{
		if (reflectHurt == 0) return;

		if(f != null && f.InstanceId == fighterInstId)
		{
			hurt += reflectHurt;
		}
		mDirty = true;
	}

	public void StatHealInfo(Fighter f,int healHp)
	{
		if(f != null && f.InstanceId == fighterInstId)
		{
			heal += healHp;
			mDirty = true;
		}
	}

	public void StatBuffInfo(Fighter f, bool negative)
	{
		if(f!=null && f.InstanceId == fighterInstId)
		{
			buffCnt++;
			mDirty = true;
		}
	}

	public void StatSPInfo(Fighter f, int sp)
	{
		if(f.InstanceId == fighterInstId)
		{
			addSp += sp;
			mDirty = true;
		}
	}

	public void OnEnterSkill (Fighter fighter, int skillType,string skillIcon,int skillId,int skillLevel)
	{
		skillStatistics[skillType].skillIcon = skillIcon;
		skillStatistics[skillType].skillId = skillId;
		skillStatistics[skillType].skillLevel = skillLevel;
		skillStatistics[skillType].Casting((BattleMgr.Instance.Battle.CurBattleField.BattleFrame - mBeginFrame)/Constants.frame_to_time);
		mDirty = true;
	}

	public void OnBreakSkill (Fighter fighter, int skillType)
	{
		//skillStatistics [skillType].breakCnt++;
	}
}

public class BattleStatistics
{
	private List<FighterStatistics> mEnemyPetStatistics;
	private List<FighterStatistics> mFriendPetStatistics;
	private List<FighterStatistics> mEnemyStatistics;
	private List<FighterStatistics> mFriendStatistics;
	private float mBeginTime;
	private float mEndTime = 0;
	private int mBeginFrame = 0;
	private int mEndFrame = 0;
	private float factorA = 0;
	private float factorB = 0;
	private float factorC = 0;
	private bool bStarted = false;
	public float BeginTime
	{
		get { return mBeginTime; }
	}

	public float EndTime
	{
		get { return mEndFrame / Constants.frame_to_time; }
	}

	public List<FighterStatistics> FriendStatistics
	{
		get { return mFriendStatistics; }
	}

	public List<FighterStatistics> EnemyStatistics
	{
		get { return mEnemyStatistics; }
	}

	public bool Exist
	{
		get { return mFriendStatistics!=null &&  mFriendStatistics.Count > 0; }
	}


	public float PassedTime
	{
		get
        {
            if (null == BattleMgr.Instance.Battle)
                return 0;
            if (null == BattleMgr.Instance.Battle.CurBattleField)
                return 0;            
            return (BattleMgr.Instance.Battle.CurBattleField.BattleFrame - mBeginFrame)/Constants.frame_to_time;
        }
	}

	public BattleStatistics()
	{
		factorB = GlobalConfig.Instance.GetConfigFloatValue(190);
		factorA = GlobalConfig.Instance.GetConfigFloatValue(191);
		factorC = GlobalConfig.Instance.GetConfigFloatValue(192);
	}

	public void Start()
	{
		bStarted = true;
		Clear();
		mBeginFrame = BattleMgr.Instance.Battle.CurBattleField.BattleFrame;
	}

	public void End()
	{
		if(bStarted)
		{
			var battle = BattleMgr.Instance.Battle;
			mEndFrame = battle.CurBattleField.BattleFrame - mBeginFrame;
			bStarted = false;
		}
	}

	public void Clear()
	{
		mEndFrame = 0;
		if (mEnemyStatistics != null)
		{
			mEnemyStatistics.Clear();
		}

		if(mFriendStatistics!=null)
		{
			mFriendStatistics.Clear();
		}

		if(mEnemyPetStatistics != null)
		{
			mEnemyPetStatistics.Clear();
		}

		if(mFriendPetStatistics != null)
		{
			mFriendPetStatistics.Clear();
		}
	}

	public FighterStatistics GetFighterStatistics (Fighter fighter)
	{
		if (bStarted == false) return null;

		if (fighter == null) return null;

		if(fighter.TeamSide == eTeamType.Friend)
		{
			if(fighter.IsPet)
			{
				if(mFriendPetStatistics == null)
					mFriendPetStatistics = new List<FighterStatistics>();

				for (int idx = 0; idx < mFriendPetStatistics.Count; idx++)
				{
					if (mFriendPetStatistics[idx].fighterInstId == fighter.InstanceId)
					{
						return mFriendPetStatistics[idx];
					}
				}

				FighterStatistics statistics = new FighterStatistics(fighter, mBeginFrame);
				mFriendPetStatistics.Add(statistics);
				return statistics;
			}
			else
			{
				if (mFriendStatistics == null)
					mFriendStatistics = new List<FighterStatistics>();

				for (int idx = 0; idx < mFriendStatistics.Count; idx++)
				{
					if (mFriendStatistics[idx].fighterInstId == fighter.InstanceId)
					{
						return mFriendStatistics[idx];
					}
				}

				FighterStatistics statistics = new FighterStatistics(fighter, mBeginFrame);
				mFriendStatistics.Add(statistics);
				return statistics;
			}
		}else if(fighter.TeamSide == eTeamType.Enemy)
		{
			if(fighter.IsPet)
			{
				if (mEnemyPetStatistics == null)
					mEnemyPetStatistics = new List<FighterStatistics>();

				for (int idx = 0; idx < mEnemyPetStatistics.Count; idx++)
				{
					if (mEnemyPetStatistics[idx].fighterInstId == fighter.InstanceId)
					{
						return mEnemyPetStatistics[idx];
					}
				}

				FighterStatistics statistics = new FighterStatistics(fighter, mBeginFrame);
				mEnemyPetStatistics.Add(statistics);
				return statistics;
			}
			else
			{
				if (mEnemyStatistics == null)
					mEnemyStatistics = new List<FighterStatistics>();

				for (int idx = 0; idx < mEnemyStatistics.Count; idx++)
				{
					if (mEnemyStatistics[idx].fighterInstId == fighter.InstanceId)
					{
						return mEnemyStatistics[idx];
					}
				}

				FighterStatistics statistics = new FighterStatistics(fighter, mBeginFrame);
				mEnemyStatistics.Add(statistics);
				return statistics;
			}
		}

		return null;
	}

	public void AnalyzeData()
	{
		if (bStarted == false) return;

		bool notify = false;
		if(mEnemyStatistics != null)
		{
			float totalDamage = 0;
			float totalHeal = 0;
			float totalHurt = 0;
			float totalBuffCnt = 0;
			float totalSp = 0;
			for(int idx =0; idx < mEnemyStatistics.Count;idx++)
			{
				var enemy = mEnemyStatistics[idx];
                if (null == enemy)
                    continue;
                totalDamage += enemy.reflectdamage + enemy.basedamage + enemy.naturedamage;
                totalHeal += enemy.heal;
				totalHurt += enemy.hurt;
				totalBuffCnt += enemy.buffCnt;
				totalSp += enemy.addSp;
			}

			if(mEnemyPetStatistics != null)
			{
				for (int idx = 0; idx < mEnemyPetStatistics.Count; idx++)
				{
					var pet = mEnemyPetStatistics[idx];
                    if (null == pet)
                        continue;
                    totalDamage += pet.reflectdamage + pet.basedamage + pet.naturedamage;
                    totalHeal += pet.heal;
					totalHurt += pet.hurt;
					totalBuffCnt += pet.buffCnt;
					totalSp += pet.addSp;
				}
			}

			float avgPercent = 1.0f / mEnemyStatistics.Count;
			for (int idx = 0; idx < mEnemyStatistics.Count;idx++)
			{
				var enemy = mEnemyStatistics[idx];
                if (null == enemy)
                    continue;

				if(enemy.usedPetId> 0)
				{
					var petStat = GetPetStatistics(enemy.usedPetId, eTeamType.Enemy);
                    int pethurt = 0;
                    int petreflectdamage = 0;
                    int petbasedamage = 0;
                    int petnaturedamage = 0;
                    int petheal = 0;
                    int petbuffCnt = 0;
                    int petaddSp = 0;
                    if (null != petStat)
                    {
                        pethurt = petStat.hurt;
                        petreflectdamage = petStat.reflectdamage;
                        petbasedamage = petStat.basedamage;
                        petnaturedamage = petStat.naturedamage;
                        petheal = petStat.heal;
                        petbuffCnt = petStat.buffCnt;
                        petaddSp = petStat.addSp;
                    }
                    enemy.petdamage = petreflectdamage + petbasedamage + petnaturedamage;
                    enemy.damage = enemy.reflectdamage + enemy.basedamage + enemy.naturedamage;

                    enemy.damagePercent = totalDamage > 0 ? (enemy.damage + enemy.petdamage) / totalDamage : 0;
                    enemy.hurtPercent = totalHurt > 0 ? (enemy.hurt + pethurt) / totalHurt : 0;

					enemy.heroDamagePercent = totalDamage > 0 ? enemy.damage / totalDamage : 0;
					enemy.heroHurtPercent = totalHurt > 0 ? enemy.hurt / totalHurt : 0;


					float percent1 = totalHeal > 0 ? (enemy.heal + petheal) / totalHeal : avgPercent;
					float percent2 = totalBuffCnt > 0 ? (enemy.buffCnt + petbuffCnt) / totalBuffCnt : avgPercent;
					float percent3 = totalSp > 0 ? (enemy.addSp + petaddSp) / totalSp : avgPercent;
					enemy.healPercent = factorA * percent1 + factorB * percent2 + factorC * percent3;

					float percent4 = totalHeal > 0 ? enemy.heal / totalHeal : avgPercent;
					float percent5 = totalBuffCnt > 0 ? enemy.buffCnt / totalBuffCnt : avgPercent;
					float percent6 = totalSp > 0 ? enemy.addSp / totalSp : avgPercent;
					enemy.heroHealPercent = factorA * percent4 + factorB * percent5 + factorC * percent6;
				}
				else
				{
                    enemy.petdamage = 0;
                    enemy.damage = enemy.reflectdamage + enemy.basedamage + enemy.naturedamage;
                    enemy.damagePercent = totalDamage > 0 ? enemy.damage / totalDamage : 0;
					enemy.hurtPercent = totalHurt > 0 ? enemy.hurt / totalHurt : 0;
					enemy.heroDamagePercent = enemy.damagePercent;
					enemy.heroHurtPercent = enemy.hurtPercent;

					float percent1 = totalHeal > 0 ? enemy.heal / totalHeal : avgPercent;
					float percent2 = totalBuffCnt > 0 ? enemy.buffCnt / totalBuffCnt : avgPercent;
					float percent3 = totalSp > 0 ? enemy.addSp / totalSp : avgPercent;

					enemy.healPercent = factorA * percent1 + factorB * percent2 + factorC * percent3;
					enemy.heroHealPercent = enemy.healPercent;
				}
				

				if (enemy.Dirty)
				{
					notify = true;
					enemy.Dirty = false;
				}
			}
		}

		if(mFriendStatistics != null)
		{
			float totalDamage = 0;
			float totalHeal = 0;
			float totalHurt = 0;
			float totalBuffCnt = 0;
			float totalSp = 0;
			for (int idx = 0; idx < mFriendStatistics.Count; idx++)
			{
				var friend = mFriendStatistics[idx];
                if (null == friend)
                    continue;
                totalDamage += friend.reflectdamage + friend.basedamage + friend.naturedamage;
                totalHeal += friend.heal;
				totalHurt += friend.hurt;
				totalBuffCnt += friend.buffCnt;
				totalSp += friend.addSp;
			}

			if (mFriendPetStatistics != null)
			{
				for (int idx = 0; idx < mFriendPetStatistics.Count; idx++) 
				{
					var pet = mFriendPetStatistics[idx];
                    if (null == pet)
                        continue;
                    totalDamage += pet.reflectdamage + pet.basedamage + pet.naturedamage;
                    totalHeal += pet.heal;
					totalHurt += pet.hurt;
					totalBuffCnt += pet.buffCnt;
					totalSp += pet.addSp;
				}
			}

			float avgPercent = 1.0f / mFriendStatistics.Count;
			for (int idx = 0; idx < mFriendStatistics.Count; idx++)
			{
				var friend = mFriendStatistics[idx];
                if (null == friend)
                    continue;
                if (friend.usedPetId > 0)
				{
					var petStat = GetPetStatistics(friend.usedPetId, eTeamType.Friend);
                    int pethurt = 0;
                    int petreflectdamage = 0;
                    int petbasedamage = 0;
                    int petnaturedamage = 0;
                    int petheal = 0;
                    int petbuffCnt = 0;
                    int petaddSp = 0;
                    if (null != petStat)
                    {
                        pethurt = petStat.hurt;
                        petreflectdamage = petStat.reflectdamage;
                        petbasedamage = petStat.basedamage;
                        petnaturedamage = petStat.naturedamage;
                        petheal = petStat.heal;
                        petbuffCnt = petStat.buffCnt;
                        petaddSp = petStat.addSp;
                    }
                    friend.petdamage = petreflectdamage + petbasedamage + petnaturedamage;
                    friend.damage = friend.reflectdamage + friend.basedamage + friend.naturedamage;

                    friend.damagePercent = totalDamage > 0 ? (friend.damage + friend.petdamage) / totalDamage : 0;
                    friend.hurtPercent = totalHurt > 0 ? (friend.hurt + pethurt) / totalHurt : 0;

					friend.heroDamagePercent = totalDamage > 0 ? friend.damage / totalDamage : 0;
					friend.heroHurtPercent = totalHurt > 0 ? friend.hurt / totalHurt : 0;


					float percent1 = totalHeal > 0 ? (friend.heal + petheal) / totalHeal : avgPercent;
					float percent2 = totalBuffCnt > 0 ? (friend.buffCnt + petbuffCnt) / totalBuffCnt : avgPercent;
					float percent3 = totalSp > 0 ? (friend.addSp + petaddSp) / totalSp : avgPercent;
					friend.healPercent = factorA * percent1 + factorB * percent2 + factorC * percent3;

					float percent4 = totalHeal > 0 ? friend.heal / totalHeal : avgPercent;
					float percent5 = totalBuffCnt > 0 ? friend.buffCnt / totalBuffCnt : avgPercent;
					float percent6 = totalSp > 0 ? friend.addSp / totalSp : avgPercent;
					friend.heroHealPercent = factorA * percent4 + factorB * percent5 + factorC * percent6;
				}
				else
				{
                    friend.petdamage = 0;
                    friend.damage = friend.reflectdamage + friend.basedamage + friend.naturedamage;
                    friend.damagePercent = totalDamage > 0 ? friend.damage / totalDamage : 0;
					friend.hurtPercent = totalHurt > 0 ? friend.hurt / totalHurt : 0;
					friend.heroDamagePercent = friend.damagePercent;
					friend.heroHurtPercent = friend.hurtPercent;

					float percent1 = totalHeal > 0 ? friend.heal / totalHeal : avgPercent;
					float percent2 = totalBuffCnt > 0 ? friend.buffCnt / totalBuffCnt : avgPercent;
					float percent3 = totalSp > 0 ? friend.addSp / totalSp : avgPercent;

					friend.healPercent = factorA * percent1 + factorB * percent2 + factorC * percent3;
					friend.heroHealPercent = friend.healPercent;
				}

				if (friend.Dirty)
				{
					notify = true;
					friend.Dirty = false;
				}
			}
		}

        //自身输出比例设置
        int nMaxDamge = 0;
        if (null != mEnemyStatistics)
        {
            for (int idx = 0; idx < mEnemyStatistics.Count; idx++)
            {
                var enemy = mEnemyStatistics[idx];
                if (null == enemy)
                    continue;
                nMaxDamge = Math.Max(nMaxDamge, enemy.basedamage + enemy.reflectdamage);
                nMaxDamge = Math.Max(nMaxDamge, enemy.naturedamage);
                nMaxDamge = Math.Max(nMaxDamge, enemy.petdamage);
            }
            for (int idx = 0; idx < mEnemyStatistics.Count; idx++)
            {
                var enemy = mEnemyStatistics[idx];
                if (null == enemy)
                    continue;
                enemy.basedamagePercent = nMaxDamge > 0 ? ((float)(enemy.basedamage + enemy.reflectdamage) / nMaxDamge) : nMaxDamge;
                enemy.naturedamagePercent = nMaxDamge > 0 ? ((float)(enemy.naturedamage) / nMaxDamge) : nMaxDamge;
                enemy.petdamagePercent = nMaxDamge > 0 ? ((float)(enemy.petdamage) / nMaxDamge) : nMaxDamge;
            }
        }
             
        if (null != mFriendStatistics)
        {
            nMaxDamge = 0;
            for (int idx = 0; idx < mFriendStatistics.Count; idx++)
            {
                var friend = mFriendStatistics[idx];
                if (null == friend)
                    continue;
                nMaxDamge = Math.Max(nMaxDamge, friend.basedamage + friend.reflectdamage);
                nMaxDamge = Math.Max(nMaxDamge, friend.naturedamage);
                nMaxDamge = Math.Max(nMaxDamge, friend.petdamage);               
            }
            
            for (int idx = 0; idx < mFriendStatistics.Count; idx++)
            {
                var friend = mFriendStatistics[idx];
                if (null == friend)
                    continue;
                friend.basedamagePercent = nMaxDamge > 0 ? ((float)(friend.basedamage+ friend.reflectdamage) / nMaxDamge) : nMaxDamge;
                friend.naturedamagePercent = nMaxDamge > 0 ? ((float)(friend.naturedamage) / nMaxDamge) : nMaxDamge;
                friend.petdamagePercent = nMaxDamge > 0 ? ((float)(friend.petdamage) / nMaxDamge) : nMaxDamge;
            }          
        }        

        if (notify)
        {
            BattleMgr.Instance.RefreshStatistics();
        }
	}

	private FighterStatistics GetPetStatistics(long petId, eTeamType teamType)
	{
		if(teamType == eTeamType.Friend)
		{
			if (mFriendPetStatistics == null) return null;
			
			for(int idx =0; idx < mFriendPetStatistics.Count;idx++)
			{
				if (mFriendPetStatistics[idx].fighterId == petId)
					return mFriendPetStatistics[idx];
			}
		}
		else
		{
			if (mEnemyPetStatistics == null) return null;

			for(int idx =0; idx < mEnemyPetStatistics.Count;idx++)
			{
				if (mEnemyPetStatistics[idx].fighterId == petId)
					return mEnemyPetStatistics[idx];
			}
		}
		return null;
	}
}
