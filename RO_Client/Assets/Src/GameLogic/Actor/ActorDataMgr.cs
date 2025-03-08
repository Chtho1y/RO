using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;

public class ActorDataMgr : Singleton<ActorDataMgr>
{
    private List<ActorData> mActors = null;

    private List<PetActorData> mPetActors = null;

    public override void Init()
    {
        base.Init();
        mActors = new List<ActorData>();
    }

    public override void UnInit()
    {
        base.UnInit();

        Clear();
    }

    public void Clear()
    {
        if (mActors != null)
        {
            mActors.Clear();
        }

        if (mPetActors != null)
        {
            mPetActors.Clear();
        }
    }

    public void ResetData()
    {
        if(mActors != null)
        {
            for(int idx =0; idx < mActors.Count;idx++)
            {
                mActors[idx].SetDropBuffs(null);
            }
        }

        if(mPetActors != null)
        {
            for(int idx =0; idx < mPetActors.Count;idx++)
            {
                mPetActors[idx].SetDropBuffs(null);
            }
        }
    }

    public Dictionary<int, float> GetIncreaseSecondAttrVal(int id, int strVal, int agiVal, int intVal, int vitVal, int dexVal, int lukVal)
    {
        ActorData actorData = GetActorsById(id);
        if (actorData != null)
        {
            int[] vals = new int[] { strVal, agiVal, intVal, vitVal, dexVal, lukVal };
            return actorData.GetPreviewAttr(vals);
        }
        return null;
    }

    public Dictionary<int, float> GetRoleIncreaseSecondAttrVal(int id, int strVal, int agiVal, int intVal, int vitVal, int dexVal, int lukVal)
    {
        int[] vals = new int[] { strVal, agiVal, intVal, vitVal, dexVal, lukVal };
        ActorData actorData = GetActorsById(id);
        if (actorData != null)
        {
            return actorData.GetPreviewAttr(vals);
        }
        return null;
    }

    public Dictionary<int, float> GetLvUpLocalPreviewSecondAttrVal(int id, int lv)
    {
        ActorData actorData = GetActorsById(id);
        if (actorData != null)
        {
            return actorData.GetPreviewLvUpLocalAttr(lv);
        }
        return null;
    }

    public Dictionary<int, float> GetLvUpPreviewSecondAttrVal(int id, int lv)
    {
        ActorData actorData = GetActorsById(id);
        if (actorData != null)
        {
            return actorData.GetPreviewLvUpAttr(lv);
        }
        return null;
    }

    public HeroActorData GetHeroActorData(int baseId)
    {
        return GameMgr.Instance.CharacterInfo.Actor;
    }

    public FellowActorData GetFellowActorData(int uid,int baseId)
    {
        FellowActorData fellow = null;
        ActorData actor = GetActorsByBaseId(baseId);
        if(actor == null)
        {
            fellow = CreateFellow(uid, baseId, 1, null);
        }
        else
        {
            fellow = actor as FellowActorData;
        }
        return fellow;
    }

    public PetActorData GetPetActorData(long uid,int baseId)
    {
        PetActorData pet = GetPetDataById(uid);
        if(pet == null)
        {
            pet = CreatePet(uid, baseId, 1, null);
        }
        return pet;
    }

    public ActorData GetActorData(bool role,int baseId)
    {
        if(role)
        {
            return GetHeroActorData(baseId);
        }
        else
        {
            return GetActorsByBaseId(baseId);
        }
    }

    public bool HasFellowActorData(int baseId)
    {
        return GetActorsByBaseId(baseId) != null;
    }

    public int GetFellowActorDataCountByUid(int uid)
    {
        int count = 0;
        for (int idx = mActors.Count - 1; idx >= 0; idx--)
        {
            if (mActors[idx].ID == uid)
            {
                count += 1;
            }
        }

        return count;
    }

    public void DeleteFellowActorData(int baseId)
    {
        for(int idx = mActors.Count - 1; idx >= 0;idx--)
        {
            if(mActors[idx].BaseId == baseId)
            {
                mActors[idx].Dispose();
                mActors.RemoveAt(idx);
                return;
            }
        }
    }

    public void DeleteActorDataById(long uid)
    {
        for (int idx = mActors.Count - 1; idx >= 0; idx--)
        {
            if (mActors[idx].ID == uid)
            {
                mActors[idx].Dispose();
                mActors.RemoveAt(idx);
            }
        }
    }

    public void RefreshFellowActorData(long uid,int baseId)
    {
        if (mActors == null) return;

        for (int idx = mActors.Count - 1; idx >=0; idx--)
        {
            if (mActors[idx].ID == uid && mActors[idx].BaseId != baseId)
            {
                mActors[idx].Dispose();
                mActors.RemoveAt(idx);
            }
        }

    }

    public bool HasPetActorData(long uid)
    {
        return GetPetDataById(uid) != null;
    }

    public HeroActorData CreateMainRole(LuaTable roleParam)
    {
        HeroActorData hero = ActorData.CreatePlayerActor(roleParam) as HeroActorData;
        mActors.Add(hero);
        return hero;
    }

    public FellowActorData CreateFellow(long uid,int baseId,int level, SkillParam[] skillParams)
    {
        FellowActorData fellow = ActorData.CreateFellowActor(uid, baseId, level, skillParams) as FellowActorData;
        mActors.Add(fellow);
        return fellow;
    }

    public PetActorData CreatePet(long uid,int baseId,int level,SkillParam[] skillParams)
    {
        PetActorData pet = ActorData.CreatePetActor(uid, baseId, level, skillParams) as PetActorData;
        if (mPetActors == null)
            mPetActors = new List<PetActorData>();

        mPetActors.Add(pet);
        return pet;
    }

    //boss战变身宠物
    public PetActorData CreatePetBossActor(long uid, int baseId, int level)
    {
        PetActorData pet = ActorData.CreatePetBossActor(uid, baseId, level) as PetActorData;
        if (mPetActors == null)
            mPetActors = new List<PetActorData>();

        mPetActors.Add(pet);
        return pet;
    }

    public ActorData CreateNpc(int uid,int baseId,int pos,int level)
    {
        ActorData npc = ActorData.CreateNpcPlayerActor(uid, baseId, level);
        npc.PositionValue = pos;
        return npc;
    }

    public ActorData GetActorsById(long uid)
    {
        if (mActors == null) return null;

        for(int idx = mActors.Count -1; idx >= 0; idx --)
        {
            if (mActors[idx].ID == uid) return mActors[idx];
        }

        return null;
    }

    public ActorData GetActorsById(long uid,int baseId)
    {
        if (mActors == null) return null;

        for (int idx = 0; idx < mActors.Count; idx++)
        {
            if (mActors[idx].ID == uid && mActors[idx].BaseId == baseId) return mActors[idx];
        }


        return null;
    }

    public ActorData GetActorsByBaseId(int baseId)
    {
        if (mActors == null) return null;

        for (int idx = 0; idx < mActors.Count; idx++)
        {
            if (mActors[idx].BaseId == baseId) return mActors[idx];
        }

        return null;
    }

    public PetActorData GetPetDataById(long uid)
    {
        if (mPetActors == null) return null;

        for(int idx =0; idx < mPetActors.Count;idx++)
        {
            if (mPetActors[idx].ID == uid)
                return mPetActors[idx];
        }

        return null;
    }

    public void DeletePetActorData(int uid)
    {
        if (mPetActors == null) return;

        for (int idx = mPetActors.Count - 1; idx >= 0; idx--)
        {
            if (mPetActors[idx].ID == uid)
            {
                mPetActors[idx].Dispose();
                mPetActors.RemoveAt(idx);
                return;
            }
        }
    }
}
