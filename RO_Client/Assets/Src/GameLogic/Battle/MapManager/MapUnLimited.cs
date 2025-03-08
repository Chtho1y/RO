using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MapUnLimited : MonoBehaviour
{
    public Transform runWayPrefab;
    public Transform groudPrefab;
    public Transform[] extendPrefabs;
    public float runWayDistance = 148;
    public float groundDistance = 150;


    List<Queue<Transform>> runWayList;
    List<Queue<Transform>> groundList;

    bool bInited = false;
    int InitialCol = 2;
    int InitialRow = 5;
    Transform mCurShowExtendPrefab = null;

    void Start()
    {
        InitQueue();
        //EventMgr.AddEventListener<string>(ECoreEventType.EID_SHOW_SCENE_GO, OnShowSceneGo);
        //EventMgr.AddEventListener<bool>(ECoreEventType.EID_RESTORE_SCENE, OnRestoreScene);
    }

    private void OnDestroy()
    {
        //EventMgr.RemoveEventListener<string>(ECoreEventType.EID_SHOW_SCENE_GO, OnShowSceneGo);
        //EventMgr.RemoveEventListener<bool>(ECoreEventType.EID_RESTORE_SCENE, OnRestoreScene);
    }


    void Update()
    {
        if (!bInited) return;

        for(int i =0; i < runWayList.Count;i++)
        {
            Queue<Transform> queue = runWayList[i];
            float dist = (queue.Count / 2) * runWayDistance;
            if (transform.position.z - queue.Peek().position.z >= dist)
            {
                Transform runway = queue.Dequeue();
                Transform last = queue.ToArray()[queue.Count - 1];
                runway.position = new Vector3(last.position.x, last.position.y, last.position.z + runWayDistance);
                queue.Enqueue(runway);
                SceneEventCfg sceneEventCfg = runway.GetComponent<SceneEventCfg>();
                if (sceneEventCfg != null)
                {
                    sceneEventCfg.SetSceneEvent();
                }
            }
        }

        if (groundList != null && groundList.Count > 0)
        {
            for(int i = 0; i < groundList.Count;i++)
            {
                Queue<Transform> queue = groundList[i];
                float dist = (queue.Count / 2) * runWayDistance;
                if (transform.position.z - queue.Peek().position.z >= dist)
                {
                    Transform ground = queue.Dequeue();
                    Transform last = queue.ToArray()[queue.Count - 1];
                    ground.position = new Vector3(last.position.x, last.position.y, last.position.z + runWayDistance);
                    queue.Enqueue(ground);
                }
            }
        }
    }

    void InitQueue()
    {
        if (!bInited)
        {
            PrefabLightmapData lmData = runWayPrefab.GetComponent<PrefabLightmapData>();
            if (lmData != null)
            {
                lmData.SetUpLightmap();
            }

            runWayList = new List<Queue<Transform>>();
            
            for(int c = 0; c < InitialCol;c++)
            {
                Queue<Transform> queue = new Queue<Transform>();
                for (int i = 0; i < InitialRow; i++)
                {
                    Transform runway = (Transform)Transform.Instantiate(runWayPrefab, new Vector3(c * runWayDistance, runWayPrefab.localPosition.y, runWayDistance * (i - InitialRow/2)), Quaternion.identity);
                    PrefabLightmapData lightmapData = runway.GetComponent<PrefabLightmapData>();
                    if (lightmapData != null)
                    {
                        lightmapData.SetUpLightmap();
                    }
                    queue.Enqueue(runway);
                    SceneEventCfg sceneEventCfg = runway.GetComponent<SceneEventCfg>();
                    if (sceneEventCfg != null)
                    {
                        sceneEventCfg.SetSceneEvent();
                    }                
                }
                runWayList.Add(queue);
            }

            runWayPrefab.gameObject.SetActive(false);


            if (groudPrefab!=null)
            {
                groundList = new List<Queue<Transform>>();
                for (int c = 0; c < InitialCol; c++)
                {
                    Queue<Transform> queue = new Queue<Transform>();
                    for (int i = 0; i < InitialRow; i++)
                    {
                        Transform ground = (Transform)Transform.Instantiate(groudPrefab, new Vector3(c * runWayDistance, groudPrefab.localPosition.y, runWayDistance * (i - InitialRow / 2)), Quaternion.identity);
                        PrefabLightmapData lightmapData = ground.GetComponent<PrefabLightmapData>();
                        if (lightmapData != null)
                        {
                            lightmapData.SetUpLightmap();
                        }
                        queue.Enqueue(ground);
                    }
                    groundList.Add(queue);
                }

                groudPrefab.gameObject.SetActive(false);
            }
            bInited = true;
        }
    }

    void OnShowSceneGo(CoreEvent<string> ce)
    {
        if (extendPrefabs == null) return;

        Transform trans = GetTrans(ce.Data);
        if (trans == null) return;


        mCurShowExtendPrefab = trans;

        Transform locWay = null;
        if (runWayList.Count > 0)
        {
            for(int idx =0; idx < runWayList.Count;idx++)
            {
                Queue<Transform> queue = runWayList[idx];
                IEnumerator iter = queue.GetEnumerator();
                while (iter.MoveNext())
                {
                    Transform t = iter.Current as Transform;
                    if (t != null)
                        t.gameObject.SetActive(false);
                    
                    if(transform.position.z>= t.position.z && transform.position.z <= t.position.z + runWayDistance && idx == 0)
                    {
                        locWay = t;
                    }
                }
            }

        }

        if(groundList!=null)
        {
            for(int idx =0; idx < groundList.Count;idx++)
            {
                Queue<Transform> queue = groundList[idx];
                IEnumerator iter = queue.GetEnumerator();
                while (iter.MoveNext())
                {
                    Transform t = iter.Current as Transform;
                    if (t != null)
                        t.gameObject.SetActive(false);
                }
            }
        }
        
        mCurShowExtendPrefab.gameObject.SetActive(true);
        mCurShowExtendPrefab.position = locWay.position;
        SyncPosWithCamPos com = mCurShowExtendPrefab.GetComponentInChildren<SyncPosWithCamPos>(true);
        if(com!=null)
        {
            Vector3 pos = com.transform.position;
            pos.z = BattleCamera.Instance.CamPosition.z - com.width * 0.5f;
            com.transform.position = pos;
        }
        //BattleCamera.Instance.FadeIn();  
    }

    void OnRestoreScene(CoreEvent<bool> ce)
    {
        if (mCurShowExtendPrefab == null) return;

        if (runWayList.Count > 0)
        {
            for(int idx =0; idx < runWayList.Count;idx++)
            {
                Queue<Transform> queue = runWayList[idx];
                IEnumerator iter = queue.GetEnumerator();
                while (iter.MoveNext())
                {
                    Transform t = iter.Current as Transform;
                    if (t != null)
                        t.gameObject.SetActive(true);
                }
            }
        }

        if (groundList !=null && groundList.Count > 0)
        {
            for(int idx =0; idx < groundList.Count;idx++)
            {
                Queue<Transform> queue = groundList[idx];
                IEnumerator iter = queue.GetEnumerator();
                while (iter.MoveNext())
                {
                    Transform t = iter.Current as Transform;
                    if (t != null)
                        t.gameObject.SetActive(true);
                }
            }
        }
        mCurShowExtendPrefab.gameObject.SetActive(false);
    }

    Transform GetTrans(string name)
    {
        if (extendPrefabs == null) return null;

        for(int idx =0; idx < extendPrefabs.Length;idx++)
        {
            if (extendPrefabs[idx].name == name)
                return extendPrefabs[idx];
        }

        return null;
    }
}
