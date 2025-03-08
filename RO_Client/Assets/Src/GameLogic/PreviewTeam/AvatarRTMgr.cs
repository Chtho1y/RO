using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;

public class AvatarRTMgr : Singleton<AvatarRTMgr>
{
    private LuaTable mPreviewLuaTbl;
    private List<ActorAvatar> mActors;
    private bool bStartLoading = false;
    private bool bLoaded = false;

    public bool IsLoading
    {
        get { return bStartLoading && !bLoaded; }
    }

    public override void Init()
    {
        base.Init();
        mActors = new List<ActorAvatar>();
    }

    public override void UnInit()
    {
        base.UnInit();
    }


    List<ActorData> mNeedLoadActors = new List<ActorData>();
    public void LoadPreviewActors(ActorData[] actors, LuaTable luaTbl)
    {
        if (actors == null || actors.Length == 0) return;

        if (bStartLoading) return;

        mNeedLoadActors.Clear();
        mNeedLoadActors.AddRange(actors);
        if (mActors != null && mActors.Count > 0)
        {
            for(int idx = mActors.Count - 1; idx >= 0 ;idx--)
            {
                if(!NeedActor(actors,mActors[idx]))
                {
                    mActors[idx].Dispose();
                    mActors.RemoveAt(idx);
                }else
                {
                    mNeedLoadActors.Remove(mActors[idx].Data);
                }
            }
        }

        if(mNeedLoadActors.Count == 0)
        {
            for(int idx =0; idx < mActors.Count;idx++)
            {
                mActors[idx].IsVisible = true;
            }
            mPreviewLuaTbl = luaTbl;
            mPreviewLuaTbl.CallCS2Lua("OnLoadCompleted");
            return;
        }

        bStartLoading = true;
        bLoaded = false;
        mPreviewLuaTbl = luaTbl;

        for (int idx = 0; idx < mNeedLoadActors.Count; idx++)
        {
            ActorAvatar avatar = new ActorAvatar(mNeedLoadActors[idx]);
            mActors.Add(avatar);
            avatar.ParseLoad();
        }

        EventMgr.AddEventListener<bool>(ECoreEventType.EID_PREPARE_LOAD_OK, OnPrepareLoadOk);
        BattlePrepareManager.Instance.StartLoad();
    }

    private bool NeedActor(ActorData[] actors, ActorAvatar aa)
    {
        if (actors == null || actors.Length == 0) return false;

        for(int idx =0; idx < actors.Length;idx++)
        {
            if(actors[idx] == aa.Data)
            {
                return true;
            }
        }
        return false;
    }

    public RenderTexture GetActorRT(long id)
    {
        if (mActors == null) return null;

        for(int idx =0; idx < mActors.Count;idx++)
        {
            if(mActors[idx].Data.ID == id)
            {
                return mActors[idx].RT;
            }
        }

        return null;
    }

    public ActorAvatar FindActorByID(long id)
    {
        if (mActors == null) return null;

        for (int idx = 0; idx < mActors.Count; idx++)
        {
            if (mActors[idx].Data.ID == id)
            {
                return mActors[idx];
            }
        }

        return null;
    }

    public void PlayAnim(long id,string anim)
    {
        ActorAvatar actor = FindActorByID(id);
        if(actor != null)
        {
            actor.PlayAnim(anim);
        }
    }

    public void Hide()
    {
        if (mActors != null)
        {
            for (int idx = 0; idx < mActors.Count; idx++)
            {
                mActors[idx].IsVisible = false;
            }
        }

        if (!GameMgr.Instance.IsBadDevice)
        {
            GameMgr.Instance.DisableAntiAliasing();
        }

        mPreviewLuaTbl = null;
        bLoaded = false;
        bStartLoading = false;
    }

    public void Clear()
    {
        BattlePrepareManager.Instance.Clear();
        if (mActors != null)
        {
            for (int idx = 0; idx < mActors.Count; idx++)
            {
                mActors[idx].Dispose();
            }
            mActors.Clear();
        }

        if (!GameMgr.Instance.IsBadDevice)
        {
            GameMgr.Instance.DisableAntiAliasing();
        }

        mPreviewLuaTbl = null;
        bLoaded = false;
        bStartLoading = false;
    }


    public void RemoveActor(long id)
    {
        if (mActors == null) return;

        for(int idx = mActors.Count -1;idx>=0;idx--)
        {
            if(mActors[idx].Data.ID == id)
            {
                mActors[idx].Dispose();
                mActors.RemoveAt(idx);
                return;
            }
        }
    }

    private void OnPrepareLoadOk(CoreEvent<bool> ce)
    {
        if (ce.Data)
        {
            bLoaded = true;
            EventMgr.RemoveEventListener<bool>(ECoreEventType.EID_PREPARE_LOAD_OK, OnPrepareLoadOk);
            CreateActors();
            CreateActorsRT();

            if(mPreviewLuaTbl!=null)
            {
                mPreviewLuaTbl.CallCS2Lua("OnLoadCompleted");
            }
        }
    }

    private void CreateActors()
    {
        int initPosX = 1000;
        int initPosY = 0;
        int initPosZ = 0;
        for (int idx = 0; idx < mActors.Count; idx++)
        {
            mActors[idx].CreateGo(new Vector3(initPosX+idx*50,initPosY,initPosZ),null);
        }
    }

    private void CreateActorsRT()
    {
        if (!GameMgr.Instance.IsBadDevice)
        {
            GameMgr.Instance.EnableAntiAliasing();
        }
        for(int idx =0; idx < mActors.Count;idx++)
        {
            mActors[idx].GenerateRT();
        }
    }

}
