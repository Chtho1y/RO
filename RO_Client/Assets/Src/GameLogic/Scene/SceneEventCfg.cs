using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public enum SceneEventPointType
{
    Fixed = 1,          //固定不可随机点
    Random = 2,         //随机点位置
}

public class SceneEventCfg : MonoBehaviour
{
    [System.Serializable]
    public struct SceneEventPoint
    {
        public Transform point;
        public SceneEventPointType pointType;
        public int eventId;
        public int showRate;
    }

    public SceneEventPoint[] sceneEventPoints = null;

    public SceneEvent[] sceneEvents = null;

    public int AvaliablePointNum = 1;
    HashSet<int> mArrangedPoints = new HashSet<int>();
   
    // Use this for initialization
    void Start()
    {
        DisableAllEvents();
        SetSceneEvent();
    }

    List<SceneEvent> randomEvents = new List<SceneEvent>();
    public void SetSceneEvent()
    {
        if (sceneEvents == null || sceneEventPoints == null) return;

        ResetData();

        for (int idx =0; idx < sceneEventPoints.Length;idx++)
        {
            if(sceneEventPoints[idx].pointType == SceneEventPointType.Fixed)
            {
                SceneEvent se = GetEvent(sceneEventPoints[idx].eventId);
                if(se!=null)
                {
                    se.transform.SetParent(sceneEventPoints[idx].point);
                    se.transform.localPosition = Vector3.zero;
                    int rand = Random.Range(1, 100);
                    if (rand < sceneEventPoints[idx].showRate)
                        se.Show();
                    else
                        se.Hide();
                    se.EventPointPos = idx;
                    mArrangedPoints.Add(idx);
                }
            }
        }

        randomEvents.Clear();
        for(int idx =0; idx < sceneEvents.Length;idx++)
        {
            if(!sceneEvents[idx].IsArrange)
                randomEvents.Add(sceneEvents[idx]);
        }
        
        int cnt = AvaliablePointNum;
        while(cnt >0)
        {
            if (randomEvents.Count == 0) break;

            if (!ExistIdlePoint()) break;

            int eIdx = Random.Range(0, randomEvents.Count);
            SceneEvent se = randomEvents[eIdx];
            randomEvents.RemoveAt(eIdx);

            int idlePointIdx = GetRandleIdlePoint(se.canUsePoints);
            se.transform.SetParent(sceneEventPoints[idlePointIdx].point);
            se.transform.localPosition = Vector3.zero;
            se.EventPointPos = idlePointIdx;
            se.Show();
            mArrangedPoints.Add(idlePointIdx);
            cnt--;
        }
    }

    private void ResetData()
    {
        mArrangedPoints.Clear();
        for(int idx = 0;idx < sceneEvents.Length;idx++)
        {
            sceneEvents[idx].Hide();
            sceneEvents[idx].EventPointPos = -1;
        }
    }

    SceneEvent GetEvent(int eventId)
    {
        if (sceneEvents == null) return null;

        for(int idx = 0; idx < sceneEvents.Length;idx++)
        {
            if (sceneEvents[idx].EventId == eventId) return sceneEvents[idx];
        }

        return null;
    }

    void DisableAllEvents()
    {
        if(sceneEvents!=null)
        {
            for (int idx = 0; idx < sceneEvents.Length; idx++)
            {
                sceneEvents[idx].enabled = false;
                if(sceneEvents[idx].EventTarget!=null)
                    sceneEvents[idx].EventTarget.gameObject.SetActive(true);
            }    
        }
    }

    bool ExistIdlePoint()
    {
        if (sceneEventPoints == null) return false;

        return mArrangedPoints.Count < sceneEventPoints.Length;
    }

    List<int> temp = new List<int>();
    int GetRandleIdlePoint(int[] canUsePoints)
    {
        temp.Clear();
        int cnt = sceneEventPoints.Length;

        for (int idx = 0; idx < cnt; idx++)
        {
            if (mArrangedPoints.Contains(idx)) continue;

            temp.Add(idx);
        }

        int randomIdx = Random.Range(0, temp.Count);
        int result = temp[randomIdx];
        return result;
    }

#if UNITY_EDITOR
    private void OnDrawGizmos()
    {
        if(sceneEventPoints!=null)
        {
            
            for (int idx =0; idx < sceneEventPoints.Length;idx++)
            {
                SceneEventPoint p = sceneEventPoints[idx];
                if(p.point!=null)
                {
                    if (p.pointType == SceneEventPointType.Fixed)
                    {
                        Gizmos.color = Color.red;
                        Gizmos.DrawSphere(p.point.position, 0.5f);
                    }
                    else {
                        Gizmos.color = Color.green;
                        Gizmos.DrawSphere(p.point.position, 0.5f);
                    }
                }
            }
        }

        if(sceneEvents!=null)
        {
            for(int idx =0; idx <sceneEvents.Length;idx++)
            {
                SceneEvent se = sceneEvents[idx];
                if(se!=null)
                {
                    if(se.EventType == SceneEventType.Unmovable)
                    {
                        Gizmos.color = Color.gray;
                        Gizmos.DrawSphere(se.transform.position, 0.5f);
                    }
                    else
                    {
                        if(se.MovePaths!=null)
                        {
                            Gizmos.color = Color.yellow;
                            for (int jdx = 0; jdx < se.MovePaths.Length;jdx++)
                            {
                                var path = se.MovePaths[jdx];
                                Gizmos.DrawLine(path.startPoint.position, path.endPoint.position);
                            }
                        }
                    }
                }
            }
        }
    }
#endif
}
