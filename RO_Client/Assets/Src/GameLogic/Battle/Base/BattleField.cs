using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class BattleField : LogicField
{
    protected int mCurrentStateFrame = 0;
    protected int mBattleFrame = 0;
    protected List<Fighter> mFighters = new List<Fighter>();
    protected List<Fighter> mTeamFighters = new List<Fighter>();
    protected List<Fighter> mEnemyFighters = new List<Fighter>();
    protected List<ActorData> mTeamActors = new List<ActorData>();
    protected List<ActorData> mEnemyActors = new List<ActorData>();

    public List<Fighter> Fighters { get { return mFighters; } }

    public List<Fighter> TeamFighters { get { return mTeamFighters; } }

    public List<Fighter> EnemyFighters { get { return mEnemyFighters; } }

    public List<ActorData> TeamActors { get { return mTeamActors; } }

    public List<ActorData> EnemyActors { get { return mEnemyActors; } }

    public virtual int CurrentFieldState
    {
        get { return 0; }
    }

    public int CurrentStateFrame {  get { return mCurrentStateFrame; } }

    public int BattleFrame { get { return mBattleFrame; } }

    public float FightingTime { get; protected set; }

    //最大战斗时长
    public float MaxFightingTime { get; protected set; }

    public FightingResult Result { get; protected set; }

    public virtual bool IsFightingState { get { return false; } }

    public virtual LevelItem BattleInfo { get { return null; } }

    public bool IsWin
    {
        get { return Result == FightingResult.Win; }
    }

    public virtual float FloorY
    {
        get { return 0; }
    }

    public Vector3 FloorCenter { get { return Position; } }

    public virtual Vector3 FighterForward { get { return Vector3.zero; } }

    public virtual Vector3 FieldCenter { get; set; }

    public virtual Vector3 FieldFocus { get; }

    public virtual bool killBoss { get; set; }

    public virtual bool CanKillBoss { get { return false; } }

    public virtual bool IsIdleState { get { return false; } }

    public virtual string Name
    {
        get { return "BattleField"; }
    }

    //是否正在播放录像
    private bool mIsPlayingRecorder = false;
    public bool IsPlayingRecorder
    {
        get { return mIsPlayingRecorder; }
        set { mIsPlayingRecorder = value; }
    }

    private BaseBattle inBattle = null;

    public BattleField(BaseBattle battle, Vector3 pos, Vector3 size, Vector3 forward)
        :base(pos,size,forward)
    {
        this.inBattle = battle;
        this.mBattleFrame = 0;
    }

    public virtual void Update(float deltaTime)
    {
        mCurrentStateFrame++;
        mBattleFrame++;
        if (IsFightingState)
        {
            //FightingTime += deltaTime;            
            FightingTime = mCurrentStateFrame / Constants.frame_to_time;
            CheckBuffs(BuffTriggerType.Trigger_FixedTime);
        }   
    }

    //往战场中添加战斗人员
    public virtual void AddFighter(Fighter fighter)
    {
        if (!mFighters.Contains(fighter))
        {
            if (fighter.IsTeamMember)
            {
                mTeamFighters.Add(fighter);
                if (!mTeamActors.Contains(fighter.Actor))
                    mTeamActors.Add(fighter.Actor);
            }
            else
            {
                mEnemyFighters.Add(fighter);
                if (!mEnemyActors.Contains(fighter.Actor))
                    mEnemyActors.Add(fighter.Actor);
            }
            mFighters.Add(fighter);
            fighter.OnEnterField(this);
        }
    }

    //从战场中移除战斗人员
    public virtual void RemoveFighter(Fighter fighter)
    {
        if (mFighters.Contains(fighter))
        {
            if (fighter.IsTeamMember)
            {
                mTeamFighters.Remove(fighter);
                mTeamActors.Remove(fighter.Actor);
            }
            else
            {
                mEnemyFighters.Remove(fighter);
                mEnemyActors.Remove(fighter.Actor);
            }
            mFighters.Remove(fighter);
            fighter.OnLeaveField(this);
        }
    }

    public virtual void OnFighterDie(Fighter fighter)
    {

    }

    public virtual void OnFighterRelive(Fighter fighter)
    {
    }

    public virtual void GetFieldSummonPos(int posVal, out Vector3 pos, out Vector3 rot)
    {
        pos = Vector3.zero;
        rot = Vector3.zero;
    }

    public virtual void Dispose()
    {
        ClearFighter();
    }

    List<Fighter> tempList = new List<Fighter>();
    //给玩家落位进行排序
    public void SortTeamFighters()
    {
        int tempCount = 0;
        for (int idx = (int)ProfessionType.Pro_Type_0; idx <= (int)ProfessionType.Pro_Type_Priest; idx++)
        {
            tempList.Clear();
            FindFightersByProfessionType(eTeamType.Friend,idx, ref tempList);
            for (int jdx = 0; jdx < tempList.Count; jdx++)
            {
                tempList[jdx].ReadyPosOrder = jdx + 1;
            }
            tempCount += tempList.Count;
            if (tempCount == mTeamFighters.Count) break;
        }
    }

    public void SortEnemyFighters()
    {
        int tempCount = 0;
        for (int idx = (int)ProfessionType.Pro_Type_0; idx <= (int)ProfessionType.Pro_Type_Priest; idx++)
        {
            tempList.Clear();
            FindFightersByProfessionType(eTeamType.Enemy,idx, ref tempList);
            for (int jdx = 0; jdx < tempList.Count; jdx++)
            {
                tempList[jdx].ReadyPosOrder = jdx + 1;
            }
            tempCount += tempList.Count;
            if (tempCount == mTeamFighters.Count) break;
        }
    }

    private void FindFightersByProfessionType(eTeamType teamType,int proType, ref List<Fighter> list)
    {
        if(teamType == eTeamType.Friend)
        {
            for (int idx = 0; idx < mTeamFighters.Count; idx++)
            {
                if (mTeamFighters[idx].Actor.Profession == (ProfessionType)proType && mTeamFighters[idx].IsPlayer)
                {
                    list.Add(mTeamFighters[idx]);
                }
            }
        }
        else
        {
            for(int idx =0; idx < mEnemyFighters.Count;idx++)
            {
                if (mEnemyFighters[idx].Actor.Profession == (ProfessionType)proType && mEnemyFighters[idx].IsPlayer)
                {
                    list.Add(mEnemyFighters[idx]);
                }
            }
        }
   
    }

    public void ClearFighter()
    {
        mFighters.Clear();
        mEnemyFighters.Clear();
        mTeamFighters.Clear();
        mTeamActors.Clear();
        mEnemyActors.Clear();
    }

    public void OnFightingStart()
    {
        FightingTime = 0;
        for (int i = 0; i < Fighters.Count; i++)
        {
            if (inBattle.IsPlayRecord)
            {
                inBattle.Recorder.ProcessFrameRecord(BattleRecorder.RecordType.FighterStartFighting, Fighters[i]);
            }
            else
            {
                Fighters[i].OnFightingStart();
            }
        }

        CheckFightersPassiveSkill();
        //刷新被动 buff
        inBattle.FighterMgr.FixedUpdate(0.0f);
        CheckBuffs(BuffTriggerType.Trigger_Begin_Fighting);
        BattleMgr.Instance.OnFightingStart();
    }

    public void OnFightingEnd()
    {
        for (int idx = 0; idx < Fighters.Count; idx++)
        {
            Fighter fighter = Fighters[idx];
            if (!fighter.IsDisposed && fighter.IsSpawned)
                fighter.OnFightingEnd();
        }
    }

    public void CheckFightersPassiveSkill()
    {
        for(int idx =0; idx < Fighters.Count;idx++)
        {
            Fighters[idx].CheckPassiveSkill();
        }
    }

    public void CheckBuffs()
    {
        for (int idx = 0; idx < Fighters.Count; idx++)
        {
            Fighters[idx].ProcessTriggerBuff(Fighters[idx], BuffTriggerType.Trigger_Begin_Fighting);
        }
    }

    public void CheckBuffs(BuffTriggerType buffTriggerType)
    {
        for (int idx = 0; idx < Fighters.Count; idx++)
        {
            Fighters[idx].ProcessTriggerBuff(Fighters[idx], buffTriggerType);
        }
    }

    public virtual void DoPauseFight(bool pause)
    {

    }

    public void HideHeroNoPet()
    {
        if (mTeamFighters != null)
        {
            for (int idx = 0; idx < mTeamFighters.Count; idx++)
            {
                if (mTeamFighters[idx].IsPet)
                    continue;
                mTeamFighters[idx].Ctrl.SetLayer(LayerMask.NameToLayer(BattleCamera.HideLayerName));
            }
        }
    }

    public void CloseAiHeroNoPet()
    {
        if (mTeamFighters != null)
        {
            for (int idx = 0; idx < mTeamFighters.Count; idx++)
            {
                if (mTeamFighters[idx].IsPet)
                    continue;
                mTeamFighters[idx].AIEnable = false;
            }
        }
    }

    public void HideFighters()
    {
        if(mTeamFighters != null)
        {
            for(int idx = 0; idx < mTeamFighters.Count;idx++)
            {
                mTeamFighters[idx].Ctrl.SetLayer(LayerMask.NameToLayer(BattleCamera.HideLayerName));
            }
        }

        if(mEnemyFighters != null)
        {
            for(int idx =0; idx < mEnemyFighters.Count;idx++)
            {
                mEnemyFighters[idx].Ctrl.SetLayer(LayerMask.NameToLayer(BattleCamera.HideLayerName));
            }
        }
    }

    public void ShowFighters()
    {
        if (mTeamFighters != null)
        {
            for (int idx = 0; idx < mTeamFighters.Count; idx++)
            {
                mTeamFighters[idx].Ctrl.SetLayer(LayerMask.NameToLayer(BattleCamera.FighterLayerName));
            }
        }

        if (mEnemyFighters != null)
        {
            for (int idx = 0; idx < mEnemyFighters.Count; idx++)
            {
                mEnemyFighters[idx].Ctrl.SetLayer(LayerMask.NameToLayer(BattleCamera.FighterLayerName));
            }
        }
    }

    public virtual void PeaceEnd()
    {
    }

    #region 战斗结束判断
    public void CheckFightingResult(BaseBattle battle)
    {
        if (battle.EndCondList == null || battle.EndCondList.Count == 0) 
            return;

        for (int idx =0; idx < battle.EndCondList.Count;idx++)
        {
            var cond = battle.EndCondList[idx];
            FightingResult ret = CheckEndCondition(cond);
            if (ret != FightingResult.None)
            {
                Result = ret;
                return;
            }
        }
    }

    private FightingResult CheckEndCondition(BattleEndCondition con)
    {
        FightingResult ret = FightingResult.None;
        if (con.endType == Constants.EndBattle_By_UndeadCount)
        {
            int teamAliveCnt = 0, enemyAliveCnt = 0;
            CheckUndeadCount(ref teamAliveCnt, ref enemyAliveCnt);
            if(con.resultType == Constants.ResultType_Normal)
            {
                if (teamAliveCnt == 0)
                    ret = FightingResult.Failed;
                else if (enemyAliveCnt == 0)
                    ret = FightingResult.Win;
            }
            else if(con.resultType == Constants.ResultType_Special)
            {
                if(teamAliveCnt == 0 || enemyAliveCnt == 0)
                    ret = con.win ? FightingResult.Win : FightingResult.Failed;
            }
        }
        else if(con.endType == Constants.EndBattle_By_BattleTime)
        {
            if(CheckBattleTimeout())
            {
                if(con.resultType == Constants.ResultType_Normal)
                {
                    ret = FightingResult.Failed;
                }else if(con.resultType == Constants.ResultType_Special)
                {
                    ret = con.win ? FightingResult.Win : FightingResult.Failed;
                }
            }
        }
        else if(con.endType == Constants.EndBattle_By_TeamTotalDamage)
        {
            if(CheckTeamDamage(con.endVal))
            {
                if(con.resultType == Constants.ResultType_Normal)
                {
                    ret = FightingResult.Win;
                }else if(con.resultType == Constants.ResultType_Special)
                {
                    ret = con.win ? FightingResult.Win : FightingResult.Failed;
                }
            }
        }
        else if(con.endType == Constants.EndBattle_By_MainRoleDead)
        {
            if(CheckMainRoleDead())
            {
                if(con.resultType == Constants.ResultType_Normal)
                {
                    ret = FightingResult.Failed;
                }else if(con.resultType == Constants.ResultType_Special)
                {
                    ret = con.win ? FightingResult.Win : FightingResult.Failed;
                }
            }
        }
        else if(con.endType == Constants.EndBattle_By_BossDead)
        {
            if(CheckBossDead())
            {
                if(con.resultType == Constants.ResultType_Normal)
                {
                    ret = FightingResult.Win;
                }else if(con.resultType == Constants.ResultType_Special)
                {
                    ret = con.win ? FightingResult.Win : FightingResult.Failed;
                }
            }
        }
        else if(con.endType == Constants.EndBattle_By_PetDead)
        {
            if (CheckPetDead())
            {
                if (con.resultType == Constants.ResultType_Normal)
                {
                    ret = FightingResult.Win;
                }
                else if (con.resultType == Constants.ResultType_Special)
                {
                    ret = con.win ? FightingResult.Win : FightingResult.Failed;
                }
            }
        }
        return ret;
    }

    private void CheckUndeadCount(ref int teamAliveCount, ref int enemyAliveCount)
    {
        teamAliveCount = 0;
        enemyAliveCount = 0;
        for (int i = 0; i < mFighters.Count; i++)
        {
            Fighter fighter = mFighters[i];
            if (!fighter.IsSpawned || (!fighter.IsDisposed && fighter.IsAlive))
            {
                if (fighter.IsPet)//宠物不计入战斗结算条件
                    continue;
                if (fighter.TeamSide == 0)
                    teamAliveCount++;
                else
                    enemyAliveCount++;
            }
        }
    }

    private bool CheckBattleTimeout()
    {
        return FightingTime > MaxFightingTime;
    }

    private bool CheckTeamDamage(int damage)
    {
        int teamTotalDamage = 0;
        for (int i = 0; i < mEnemyFighters.Count; i++)
        {
            Fighter fighter = mEnemyFighters[i];
            teamTotalDamage += fighter.TotalTakeDamage;
        }

        return teamTotalDamage > damage;
    }

    private bool CheckMainRoleDead()
    {
        bool ret = false;
        for (int i = 0; i < mTeamFighters.Count; i++)
        {
            Fighter fighter = mTeamFighters[i];
            if(fighter.IsMainRole)
            {
                ret = fighter.IsSpawned && !fighter.IsAlive;
                break;
            }
        }
        return ret;
    }

    private bool CheckPetDead()
    {
        bool ret = false;
        for (int i = 0; i < mTeamFighters.Count; i++)
        {
            Fighter fighter = mTeamFighters[i];
            if (fighter.IsPet)
            {
                ret = fighter.IsSpawned && !fighter.IsAlive;
                break;
            }
        }
        return ret;
    }

    private bool CheckBossDead()
    {
        int deadBossCnt = 0;
        int bossCnt = 0;
        for (int i = 0; i < mEnemyFighters.Count; i++)
        {
            Fighter fighter = mEnemyFighters[i];
            if (fighter.IsBoss)
            {
                bossCnt++;
                if (fighter.IsSpawned && !fighter.IsAlive)
                    deadBossCnt++;
            }
        }
        return bossCnt == deadBossCnt;
    }
    #endregion
}
