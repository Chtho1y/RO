using UnityEngine;
using System.Collections.Generic;

//using StateMachine;

public class FighterManager
{
    #region Fields
    BaseBattle mBattle;
    List<Fighter> mTeamHeroFighters = new List<Fighter>();
    List<Fighter> mTeamPetFighters = new List<Fighter>();
    List<Fighter> mTeamFigters = new List<Fighter>();
    List<Fighter> mEnemyFighters = new List<Fighter>();
    List<Fighter> mAllFighters = new List<Fighter>();

    List<Fighter> mBattleFieldFighters = new List<Fighter>();
    List<Fighter> mCacheTeamFighters = new List<Fighter>();
    #endregion

    #region Properties
    public Fighter self = null;

    public BaseBattle Battle { get { return mBattle; } }

    public bool IsDisposed { get; private set; }

    public List<Fighter> AllFighters { get { return mAllFighters; } }

    public List<Fighter> TeamFighters { get { return mTeamFigters; } }

    public List<Fighter> TeamHeroFighters { get { return mTeamHeroFighters; } }

    public List<Fighter> TeamPetFighters { get { return mTeamPetFighters; } }

    public List<Fighter> EnemyFighters { get { return mEnemyFighters; } }

    public List<Fighter> BattleFieldFighters { get { return mBattleFieldFighters; } }

    public bool HasInitializedFighters { get; private set; }

    public Fighter LeftCaptain { get; private set; }

    public Fighter RightCaptain { get; private set; }

    public ActorData[] AssistActors { get; private set; }

    public int AssistValue { get; private set; }

    public Vector3 TeamFighterFocus
    {
        get
        {
            if (mBattle.IsPlayRecord && mBattle.Recorder.SwapReplay)
            {
                if (EnemyFighters.Count == 0)
                    return Vector3.zero;

                Vector3 min = Vector3.zero;
                Vector3 max = Vector3.zero;
                bool hasSet = false;
                foreach (var fighter in EnemyFighters)
                {
                    if (!fighter.IsSpawned || fighter.IsDisposed || !fighter.IsVisible)
                        continue;
                    if (!hasSet)
                    {
                        min = fighter.Ctrl.transform.position;
                        max = fighter.Ctrl.transform.position;
                        hasSet = true;
                    }
                    else
                    {
                        min = Vector3.Min(fighter.Ctrl.transform.position, min);
                        max = Vector3.Max(fighter.Ctrl.transform.position, max);
                    }
                }

                return 0.5f * (min + max) + Vector3.up * 1.0f;
            }
            else
            {
                if (TeamFighters.Count == 0)
                    return Vector3.zero;

                Vector3 min = Vector3.zero;
                Vector3 max = Vector3.zero;
                bool hasSet = false;
                for (int idx = 0; idx < TeamFighters.Count; idx++)
                {
                    Fighter f = TeamFighters[idx];
                    if (!hasSet)
                    {
                        min = f.Position;
                        max = f.Position;
                        hasSet = true;
                    }
                    else
                    {
                        min = Vector3.Min(f.Position, min);
                        max = Vector3.Max(f.Position, max);
                    }
                }

                return 0.5f * (min + max) + Vector3.up * 1.0f;
            }
        }
    }

    public Vector3 TeamFighterForward
    {
        get
        {
            if (mBattle.IsPlayRecord && mBattle.Recorder.SwapReplay)
            {
                if (EnemyFighters.Count == 0)
                    return Vector3.forward;
                return EnemyFighters[0].Ctrl != null ? EnemyFighters[0].Ctrl.transform.forward : EnemyFighters[0].Forward;
            }
            else
            {
                if (TeamFighters.Count == 0)
                    return Vector3.forward;
                return TeamFighters[0].Ctrl != null ? TeamFighters[0].Ctrl.transform.forward : TeamFighters[0].Forward;
            }   
        }
    }
    #endregion

    public FighterManager (BaseBattle battle)
	{
		mBattle = battle;
		IsDisposed = false;
	}

    FighterManager()
    {
        HasInitializedFighters = false;
    }
    
    public void SetPveMark()
    {
        for (int idx = 0; idx < mAllFighters.Count; idx++)
        {
            Fighter f = mAllFighters[idx];
            if(f.IsTeamMember)
            {
                f.AddPveMark();
            }
        }
    }


    public void InitializeCurrentSceneFighters ()
	{
		if (mBattle == null || HasInitializedFighters)
			return;

        List<ActorData> fighterInfos = mBattle.MyFighters;
		for (int i = 0; i < fighterInfos.Count; i++) {
            AddFighter(fighterInfos[i], eTeamType.Friend);
        }

        fighterInfos = mBattle.EnemyFighters;
        for (int i = 0; i < fighterInfos.Count; i++) {
            AddFighter(fighterInfos[i], eTeamType.Enemy);
        }

        
        //初始化召唤物
        for(int idx =0; idx < mAllFighters.Count;idx++)
        {
            Fighter f = mAllFighters[idx];
            if (f.Skills == null || f.Skills.Length == 0) continue;

            if (f.RageCloneBossId > 0)
            {
                ActorData ad = ActorData.CreateNpcPlayerActor(CommonUtil.CalcSummonNpcUniqueId(100,idx), f.RageCloneBossId, 1);
                ad.PositionValue = f.PositionValue;

                f.RageCloneBoss = Fighter.CreateFighter(this, ad, f.TeamSide, f);
                mAllFighters.Add(f.RageCloneBoss);
            }

            for (int jdx =0; jdx < f.Skills.Length;jdx++)
            {
                BaseSkill skill = f.Skills[jdx];
                if(skill != null  && skill.IsValid && (skill.SummonActors!=null || skill.SummonBosses!=null))
                {
                    if(skill.SummonActors!=null)
                    {
                        for (int i =0; i < skill.SummonActors.Count;i++)
                        {
                            ValType sa = skill.SummonActors[i];

                            ActorData ad = ActorData.CreateNpcPlayerActor(CommonUtil.CalcSummonNpcUniqueId(100, idx), sa.id, 1);
                            ad.PositionValue = sa.val;

                            Fighter summon = Fighter.CreateFighter(this, ad, f.TeamSide, f);
                            mAllFighters.Add(summon);
                            skill.AddSummonActor(summon);
                        }
                    }
                  
                    if(skill.SummonBosses!=null)
                    {
                        for(int i =0; i < skill.SummonBosses.Count;i++)
                        {
                            ValType sa = skill.SummonActors[i];

                            ActorData ad = ActorData.CreateNpcPlayerActor(CommonUtil.CalcSummonNpcUniqueId(100, idx), sa.id, 1);
                            ad.PositionValue = sa.val;

                            Fighter summon = Fighter.CreateFighter(this, ad, f.TeamSide, f);
                            mAllFighters.Add(summon);
                            skill.AddSummonActor(summon);
                        }
                    }
                }
            }
        }
        HasInitializedFighters = true;
	}

    public void InitFighters()
    {
        if (mBattle == null || HasInitializedFighters)
            return;

        if(mBattle.TeamActors!=null)
        {
            for (int idx = 0; idx < mBattle.TeamActors.Count;idx++)
            {
                AddFighter(mBattle.TeamActors[idx], eTeamType.Friend);
            }
        }

        if(mBattle.EnemyActors!=null)
        {
            for(int idx =0; idx < mBattle.EnemyActors.Count;idx++)
            {
                AddFighter(mBattle.EnemyActors[idx], eTeamType.Enemy);
            }
        }

        //初始化召唤物
        for (int idx = 0; idx < mAllFighters.Count; idx++)
        {
            Fighter f = mAllFighters[idx];
            if (f.Skills == null || f.Skills.Length == 0) continue;

            if(f.RageCloneBossId > 0)
            {
                ActorData ad = ActorData.CreateNpcPlayerActor(CommonUtil.CalcSummonNpcUniqueId(100, idx), f.RageCloneBossId, 1);
                ad.PositionValue = f.PositionValue;

                f.RageCloneBoss = Fighter.CreateFighter(this, ad, f.TeamSide, f);
                mAllFighters.Add(f.RageCloneBoss);
            }

            for (int jdx = 0; jdx < f.Skills.Length; jdx++)
            {
                BaseSkill skill = f.Skills[jdx];
                if (skill != null && skill.IsValid && (skill.SummonActors != null || skill.SummonBosses != null))
                {
                    if (skill.SummonActors != null)
                    {
                        for (int i = 0; i <  skill.SummonActors.Count;i++)
                        {
                            ValType sa = skill.SummonActors[i];
                            ActorData ad = ActorData.CreateNpcPlayerActor(CommonUtil.CalcSummonNpcUniqueId(100, idx), sa.id, 1);
                            ad.PositionValue = sa.val;

                            Fighter summon = Fighter.CreateFighter(this, ad, f.TeamSide, f);
                            mAllFighters.Add(summon);
                            skill.AddSummonActor(summon);
                        }
                    }

                    if (skill.SummonBosses != null)
                    {
                        for (int i = 0; i < skill.SummonBosses.Count;i++)
                        {
                            ValType sa = skill.SummonBosses[i];
                            ActorData ad = ActorData.CreateNpcPlayerActor(CommonUtil.CalcSummonNpcUniqueId(100, idx), sa.id, 1);
                            ad.PositionValue = sa.val;

                            Fighter summon = Fighter.CreateFighter(this, ad, f.TeamSide, f);
                            mAllFighters.Add(summon);
                            skill.AddSummonActor(summon);
                        }
                    }
                }
            }
        }

        HasInitializedFighters = true;
    }

    public void ParseLoad()
    {
        for(int idx =0; idx < mAllFighters.Count;idx++)
        {
            Fighter fighter = mAllFighters[idx];
            fighter.Ctrl.ParseLoad();
        }
    }

	public Fighter AddFighter (ActorData actor, eTeamType side)
	{
        Fighter fighter = GetFighterByID(actor.ID,side);
        if (fighter != null) return fighter;


        fighter = Fighter.CreateFighter (this, actor,side);
        if(fighter.IsTeamMember)
        {
            mTeamFigters.Add(fighter);
            if(fighter.IsPet)
            {
                mTeamPetFighters.Add(fighter);
            }
            else
            {
                mTeamHeroFighters.Add(fighter);
            }
        }
        else
        {
            mEnemyFighters.Add(fighter);
        }
		mAllFighters.Add (fighter);

		return fighter;
	}

	public void AddFighters (ActorData[] actors, eTeamType side)
	{
		for (int i = 0; i < actors.Length; i++) {
			AddFighter (actors [i], side);
        }
    }

    public void CacheTeamFighters()
    {
        mCacheTeamFighters.Clear();
        mCacheTeamFighters.AddRange(mTeamFigters);
        for(int idx =0; idx < mCacheTeamFighters.Count;idx++)
        {
            RemoveFighter(mCacheTeamFighters[idx]);
        }
    }

    public void RestoreTeamFighters()
    {
        for(int idx = mTeamFigters.Count-1;idx>=0;idx--)
        {
            Fighter f = mTeamFigters[idx];
            RemoveFighter(f);
            f.Destroy();
        }

        for(int idx =0; idx < mCacheTeamFighters.Count;idx++)
        {
            AddTeamFighter(mCacheTeamFighters[idx]);
        }
        mCacheTeamFighters.Clear();
    }

    private void AddTeamFighter(Fighter f)
    {
        if(!mTeamFigters.Contains(f))
            mTeamFigters.Add(f);
        
        if(!mAllFighters.Contains(f))
            mAllFighters.Add(f);

        if(f.IsPet)
        {
            if(!mTeamPetFighters.Contains(f))
                mTeamPetFighters.Add(f);
        }
        else
        {
            if(!mTeamHeroFighters.Contains(f))
                mTeamHeroFighters.Add(f);
        }
    }

	public void FixedUpdate (float deltaTime)
	{
#if PROFILE
        UnityEngine.Profiling.Profiler.BeginSample("FighterManager FixedUpdate1111");
#endif
        for (int i = 0; i < mBattleFieldFighters.Count; i++)
        {
            Fighter fighter = mBattleFieldFighters[i];
			if (fighter.IsSpawned && !fighter.IsDisposed && !fighter.IsDisposed) {
                fighter.FixedUpdate (deltaTime);
			}
		}
#if PROFILE
        UnityEngine.Profiling.Profiler.EndSample();
#endif

#if PROFILE
        UnityEngine.Profiling.Profiler.BeginSample("FighterManager FixedUpdate222222");
#endif
        if (mBattle.IsFighting)
        {
            for (int i = 0; i < mBattleFieldFighters.Count; i++)
            {
                Fighter fighter = mBattleFieldFighters[i];
                if (fighter.IsSpawned &&
                    !fighter.IsDisposed &&
                    fighter.IsAlive &&
                    fighter.AIEnable &&
                    !fighter.Actor.IsDisposed)
                {
                    fighter.AI.Update(deltaTime);
                }
            }
        }
#if PROFILE
        UnityEngine.Profiling.Profiler.EndSample();
#endif

	}

#if UNITY_EDITOR
    public void FixedUpdateByEditor(float deltaTime)
    {
        for (int i = 0; i < mAllFighters.Count; i++)
        {
            Fighter fighter = mAllFighters[i];
            if (fighter.IsSpawned && !fighter.IsDisposed)
            {
                fighter.FixedUpdate(deltaTime);
            }
        }

        for (int i = 0; i < mAllFighters.Count; i++)
        {
            Fighter fighter = mAllFighters[i];
            if (fighter.IsSpawned &&
                !fighter.IsDisposed &&
                fighter.IsAlive &&
                fighter.AIEnable &&
                !fighter.Actor.IsDisposed)
            {
                fighter.AI.Update(deltaTime);
            }
        }
    }
#endif
    public void Dispose ()
	{
		if (IsDisposed)
			return;

		try
		{
			for (int i = 0; i < mAllFighters.Count; i++)
			{
				var fighter = mAllFighters[i];
				if (fighter != null)
				{
                    fighter.Destroy();
                }
			}

            RemoveAllFighters();

            LeftCaptain = null;
			RightCaptain = null;

			HasInitializedFighters = false;

			mBattle = null;
		}
		catch (System.Exception e) {
			DebugHelper.Log ("error: {0}: {1}", e.Message, e.StackTrace);
		}

		IsDisposed = true;
	}

	public void OnFighterSpawned (Fighter fighter)
	{
	}

	public void OnFighterDie (Fighter fighter)
	{
	}

	public void OnFighterRelive (Fighter fighter)
	{
	}

	public List<Fighter> GetUnSpawnedFighters (int wave)
	{
		return mAllFighters.FindAll (a => !a.IsSpawned && a.TeamSide == eTeamType.Enemy);
	}

	public List<Fighter> GetAllLeftSortedFighters ()
	{
		List<Fighter> result = mAllFighters.FindAll (a => a.TeamSide == eTeamType.Friend);
		CommonUtil.SortList(result, (lhs, rhs) => rhs.PositionValue - lhs.PositionValue);
		return result;
	}

	public Fighter GetFighterByID (long id, eTeamType teamid, int idx = 0)
	{
		for (int i = 0; i < mAllFighters.Count; i++) {
			if (mAllFighters [i].TeamSide == teamid && mAllFighters [i].Id == id) {
				return mAllFighters [i];
			}
		}
        return null;
	}

    public Fighter GetFighterByBaseId(int baseId, eTeamType teamId)
    {
        for(int idx =0; idx < mAllFighters.Count;idx++)
        { 
            if(mAllFighters[idx].TeamSide == teamId && mAllFighters[idx].Actor.BaseId == baseId)
            {
                return mAllFighters[idx];
            }
        }
        return null;
    }

	public Fighter GetFighterByInstanceID (ulong instanceid)
	{
		for (int i = 0; i < mAllFighters.Count; i++) {
			if (mAllFighters [i].InstanceId == instanceid)
				return mAllFighters [i];
		}
		return null;
	}

    public Fighter GetTeamMemberById(long id)
    {
        for(int idx =0; idx < mTeamFigters.Count;idx++)
        {
            if (mTeamFigters[idx].Id == id)
                return mTeamFigters[idx];
        }
        return null;
    }

    public Fighter GetNpcByBaseId(int baseId)
    {
        for(int idx =0; idx < mAllFighters.Count; idx++)
        {
            Fighter fighter = mAllFighters[idx];
            if(fighter.Actor.IsNpc && fighter.Actor.BaseId == baseId)
            {
                return fighter;
            }
        }
        return null;
    }

    public void AddFighterToBattleField(Fighter fighter)
    {
        if (mBattleFieldFighters.Contains(fighter)) return;

        mBattleFieldFighters.Add(fighter);
    }

    public void RemoveFighterFromBattleField(Fighter fighter)
    {
        mBattleFieldFighters.Remove(fighter);
    }

    public void RemoveFighter(Fighter fighter)
    {
        mAllFighters.Remove(fighter);
        mTeamFigters.Remove(fighter);
        mTeamPetFighters.Remove(fighter);
        mTeamHeroFighters.Remove(fighter);
        mBattleFieldFighters.Remove(fighter);
        mEnemyFighters.Remove(fighter);
    }

    public void RemoveAllFighters()
    {
        mAllFighters.Clear();
        mTeamFigters.Clear();
        mBattleFieldFighters.Clear();
        mEnemyFighters.Clear();
        mTeamPetFighters.Clear();
        mTeamHeroFighters.Clear();
    }

    public bool HasTeamHero(long id)
    {
        for(int idx =0; idx < mTeamHeroFighters.Count;idx++)
        {
            if (mTeamHeroFighters[idx].Id == id) return true;
        }

        return false;
    }

    public bool HasPet(long id)
    {
        for(int idx =0; idx < mTeamPetFighters.Count;idx++)
        {
            if (mTeamPetFighters[idx].Id == id) return true;
        }

        return false;
    }


    public bool HasTeamMember(long id)
    {
        for (int idx = 0; idx < mTeamFigters.Count; idx++)
        {
            if (mTeamFigters[idx].Id == id) return true;
        }

        return false;
    }

    List<Fighter> tempList = new List<Fighter>();
    public void SortTeamFighters()
    {
        int tempCount = 0;
        for (int idx = (int)ProfessionType.Pro_Type_0; idx <= (int)ProfessionType.Pro_Type_Priest; idx++)
        {
            tempList.Clear();
            FindFightersByProfessionType(idx, ref tempList);
            for (int jdx = 0; jdx < tempList.Count; jdx++)
            {
                tempList[jdx].ReadyPosOrder = jdx + 1;
            }
            tempCount += tempList.Count;
            if (tempCount == TeamHeroFighters.Count) break;
        }

        tempList.Clear();
    }


    private void FindFightersByProfessionType(int proType, ref List<Fighter> list)
    {
        for (int idx = 0; idx < TeamHeroFighters.Count; idx++)
        {
            if (TeamHeroFighters[idx].Actor.Profession == (ProfessionType)proType)
            {
                list.Add(TeamHeroFighters[idx]);
            }
        }
    }
}
