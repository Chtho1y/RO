using System;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public struct PreviewNpcActor
{
    public int id;
    public GameObject go;
}
public class ActorMgr : SingletonMono<ActorMgr>
{
    private GameObject actorRoot;
    public GameObject ActorRoot
    {
        get { return ActorRoot; }
    }

    //story preview
    public List<PreviewNpcActor> previewNpcActorsList;
    public List<PreviewNpcActor> previewHeroActorsList;

    private Dictionary<int, GameObject> heroActorDic;
    private Dictionary<int, GameObject> npcActorDic;

    public override void InitMgr()
    {
        actorRoot = GameObject.Find("ActorRoot");
        if (actorRoot == null)
        {
            actorRoot = new GameObject("ActorRoot");
        }

        heroActorDic = new Dictionary<int, GameObject>();
        npcActorDic = new Dictionary<int, GameObject>();
    }

    GameObject GetPreviewActor(List<PreviewNpcActor> list, int id)
    {
        foreach(var actor in list)
        {
            if (actor.id == id)
            {
                return actor.go;
            }
        }
        return null;
    }
    public GameObject GetPreviewActorById(int type, int id)
    {
        GameObject actor = null;
        if (type == 0)
        {
            //actor = GetPreviewActor(previewHeroActorsList, id);
            actor = previewHeroActorsList[0].go;
        }
        else
        {
            actor = GetPreviewActor(previewNpcActorsList, id);
        }
        if (actor == null)
        {
            DebugHelper.LogError(id + " actor is null");
        }
        return actor;
    }
}