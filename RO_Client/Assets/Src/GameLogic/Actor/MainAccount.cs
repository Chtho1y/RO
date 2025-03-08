using UnityEngine;
using System.Collections.Generic;
using System.Collections;
using System;
using System.Text;
using System.IO;
using LuaInterface;

//屏蔽不使用声明变量的警告
#pragma warning disable 0414

public class MainCharacter
{
    private int mCurMapId = 0;      //当前所在的地图ID
    public int CurMapId
    {
        get { return mCurMapId; }
        set { mCurMapId = value; }
    }

    private int mCurLevelId = 1;    //当前通关的关卡id
    public int CurLevelId
    {
        get { return mCurLevelId; }
        set { mCurLevelId = value; }
    }
        
    private bool mbDisposed = false;

    private HeroActorData mActorData = null;
    public HeroActorData Actor
    {
        get { return mActorData; }
    }

    private List<ActorData> mTeamActors = null;
    public List<ActorData> TeamActors
    {
        get { return mTeamActors; }
    }

    //战斗数据
    private HeroActorData mBattleActorData = null;
    public HeroActorData mBattleActor
    {
        get { return mBattleActorData; }
    }

    private List<ActorData> mBattleTeamActors = null;
    public List<ActorData> NormleBattleTeamActors
    {
        get {
            if (null == mBattleTeamActors)
                mBattleTeamActors = new List<ActorData>(TeamActors.Count);
            else
                mBattleTeamActors.Clear();
            for (int idx = 0; idx < TeamActors.Count; idx++)
            {
                JSONObject JsonActorData = TeamActors[idx].ToJson();
                ActorData actor = ActorData.CreateActorFromJson(JsonActorData);
                if (null != TeamActors[idx].PetData)
                {
                    JsonActorData = TeamActors[idx].PetData.ToJson();
                    ActorData pPetData = ActorData.CreateActorFromJson(JsonActorData);
                    actor.SetPet(pPetData);
                }
                if (TeamActors[idx].IsHero)
                {
                    actor.Name = TeamActors[idx].Name;
                }
                if (idx == 0)
                    mBattleActorData = actor as HeroActorData;
                mBattleTeamActors.Add(actor);
            }
            return mBattleTeamActors;
        }
    }

    bool offline = false;

    public MainCharacter()
	{
    }

    public void Clear()
    {
        if (null != mActorData)
        {
            mActorData = null;
        }
        if (mTeamActors != null)
        {
            mTeamActors.Clear();
            mTeamActors = null;
        }       
    }

    public void SetTeamActors(LuaTable teamParam)
    {
        if (offline) return;

        if (mTeamActors == null)
            mTeamActors = new List<ActorData>();
        else
            mTeamActors.Clear();

        if (teamParam == null) return;

        for (int i = 1; i <= teamParam.Length; ++i)
        {
            long uid = 0;
            long usedPetId = 0;
            int baseId = 0,level = 0;
            int petBaseId = 0,petLevel = 1;
            int headFrameId = 0;
            string strName = string.Empty;
            LuaTable ltt = (LuaTable)teamParam[i];
            if(ltt["uid"] != null)
                long.TryParse(ltt["uid"].ToString(), out uid);

            if (ltt["id"] != null)
                int.TryParse(ltt["id"].ToString(), out baseId);

            if (ltt["lv"] != null)
                int.TryParse(ltt["lv"].ToString(), out level);

            if (ltt["petId"] != null)
                long.TryParse(ltt["petId"].ToString(), out usedPetId);

            if (ltt["petBaseId"] != null)
                int.TryParse(ltt["petBaseId"].ToString(), out petBaseId);

            if (ltt["petLv"] != null)
                int.TryParse(ltt["petLv"].ToString(), out petLevel);

            if (ltt["Name"] != null)
                strName = ltt["Name"].ToString();

            if (ltt["headFrameId"] != null)
                int.TryParse(ltt["headFrameId"].ToString(), out headFrameId);

            if (uid == 0 || baseId == 0) continue;

            SkillParam[] skillParams = null;
            List<SkillParam> pSkillList = null;
            if (ltt["skills"] != null)
            {
                LuaTable skills = (LuaTable)ltt["skills"];
                pSkillList = ActorData.ParseSkillParam(skills);
                skillParams = pSkillList != null ? pSkillList.ToArray() : null;
                for(int t=0;t< pSkillList.Count;t++)
                {
                    Debug.Log(pSkillList[t].skillId.ToString());
                }
            }


            SkillParam[] petSkillParams = null;
            if(ltt["petSkills"] != null)
            {
                LuaTable petSkills = (LuaTable)ltt["petSkills"];
                List<SkillParam> temp = ActorData.ParseSkillParam(petSkills);
                petSkillParams = temp != null ? temp.ToArray() : null;
            }

            ActorData ad = null;
            if (i == 1)
            {
                int jobId = 0;
                int.TryParse(ltt["jobId"].ToString(), out jobId);
                if (mActorData == null)
                {
                    mActorData = ActorDataMgr.Instance.CreateMainRole(ltt);
                }
                else
                {
                    bool dirtyProfession = (jobId != mActorData.ProfessionId);
                    if(dirtyProfession)
                    {                      
                        mActorData.Initialize(baseId, level, skillParams);
                        if (null == BattleMgr.Instance.Battle)//不在战斗中 直接设置
                        {
                            mActorData.SetProfessionId(jobId);                            
                        }
                        else
                        {
                            BattleMgr.Instance.SetProfessionDirty(dirtyProfession, jobId);//标记后 设置
                        }
                    }          
                    else
                    {
                        BattleMgr.Instance.UpdateTeamSkills((int)mActorData.ID, pSkillList);
                    }
                }
                if(strName != string.Empty)
                {
                    mActorData.Name = strName;                   
                }
                mActorData.Level = level;
                mActorData.HeadFrameId = headFrameId;
                ad = mActorData;
            }
            else
            {
                if(ActorDataMgr.Instance.HasFellowActorData(baseId))
                {
                    FellowActorData fellowAD = ActorDataMgr.Instance.GetActorsByBaseId(baseId) as FellowActorData;
                    //fellowAD.Initialize(baseId, level, skillParams);                   
                    fellowAD.ID = uid > 0 ? uid : baseId;
                    ad = fellowAD;
                    BattleMgr.Instance.UpdateTeamSkills((int)ad.ID, pSkillList);
                }
                else
                {
                    ad = ActorDataMgr.Instance.CreateFellow(uid, baseId, level, skillParams);
                }

                bool isTransferred = false;
                if (ltt["isTransferred"] != null)
                    bool.TryParse(ltt["isTransferred"].ToString(), out isTransferred);

                ad.IsTransferred = isTransferred;
            }

            if (ltt["buffs"] != null)
            {
                List<BuffParam> buffs = ActorData.ParseBuffParam((LuaTable)ltt["buffs"]);
                ad.SetBuffs(buffs!=null?buffs.ToArray():null);
            }

            if(usedPetId  > 0)
            {
                PetActorData petData = ActorDataMgr.Instance.GetPetDataById(usedPetId);
                if(petData != null)
                {
                    ad.SetPet(petData);
                }
                else
                {
                    petData = ActorDataMgr.Instance.CreatePet(usedPetId, petBaseId, petLevel, null);
                    ad.SetPet(petData);
                }
            }
            else
            {
                ad.SetPet(null);
            }


            mTeamActors.Add(ad);
        }
    }

	public void Dispose()
	{
		if (mbDisposed)
			return;

        ActorDataMgr.Instance.Clear();
        Clear();

        mbDisposed = true;
	}
}

