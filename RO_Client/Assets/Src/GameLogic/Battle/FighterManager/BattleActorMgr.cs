using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class BattleActorMgr : Singleton<BattleActorMgr>
{
    private Dictionary<long, ActorData> npcActorList = new Dictionary<long, ActorData>();

    public override void Init()
    {
        base.Init();
    }

    public override void UnInit()
    {
        npcActorList.Clear();
        base.UnInit();
    }

    public ActorData GetNpcActorData(long uniqueId,int npcId)
    {
        ActorData data;
        if(!npcActorList.TryGetValue(uniqueId,out data))
        {
            data = ActorData.CreateNpcPlayerActor(uniqueId, npcId, 1);
            npcActorList.Add(uniqueId, data);
        }
        return data;
    }

    public void Clear()
    {
        npcActorList.Clear();
    }
}
