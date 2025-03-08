using UnityEngine;
using System.Collections;

public enum SceneEventType
{
    Unmovable = 1,     //没有移动路线
    Movable = 2,       //需要布置移动路径的事件类型
}

public enum SceneMoveType
{
    PingPong = 1,       
    Circle = 2,     //循环
}

public class SceneEvent : MonoBehaviour
{
    [System.Serializable]
    public struct SceneEventMovePath
    {
        public Transform startPoint;    //起始点
        public Transform endPoint;      //结束点
        public float moveSpeed;     //移动速度
        public float pauseTime;     //停留时间
    }

    public int EventId;                             //事件ID
    public SceneEventType EventType = SceneEventType.Unmovable;                //事件类型
    public SceneMoveType MoveType = SceneMoveType.PingPong;
    public Transform EventTarget = null;            //事件对象
    public SceneEventMovePath[] MovePaths = null;   //事件移动路径
    public float showTime = 10;
    public int[] canUsePoints;

    float beginShowTime = 0;

    int curPathIdx = 0;
    SceneEventMovePath curMovePath;
    bool startMove = false;
    bool reverse = false;
    bool pause = false;
    float beginPauseTime = 0;
    bool start2End = true;
    Animator targetAnimator;

    private int mEventPointPos = -1;
    public int EventPointPos
    {
        get { return mEventPointPos; }
        set { mEventPointPos = value; }
    }

    public bool IsArrange
    {
        get { return mEventPointPos >= 0; }
    }

    // Use this for initialization
    void Start()
    {
        if(EventTarget!=null)
            targetAnimator = EventTarget.GetComponent<Animator>();
    }

    public void Show()
    {
        this.enabled = true;

        if (EventTarget == null) return;
        EventTarget.gameObject.SetActive(true);
        beginShowTime = Time.realtimeSinceStartup;
    }

    public void Hide()
    {
        this.enabled = false;

        if (EventTarget == null) return;
        EventTarget.gameObject.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {
        if (EventTarget == null) return;

        if (EventType != SceneEventType.Movable)
        {
            if((Time.realtimeSinceStartup - beginShowTime ) >= showTime)
            {
                Hide();
            }
            return;
        }

        if (MovePaths == null || MovePaths.Length == 0) return;

        if(curPathIdx < MovePaths.Length)
        {
            if (startMove)
            {
                MoveOnPath(Time.deltaTime);
            }
            else
            {
                MoveNextPath();
                startMove = true;
            }
        }
    }

    
    void MoveOnPath(float deltaTime)
    {
        if(pause)
        {
            if((Time.realtimeSinceStartup - beginPauseTime) >= curMovePath.pauseTime)
            {
                MoveNextPath();
            }
            return;
        }

        if (start2End)
        {
            Vector3 pos = Vector3.MoveTowards(EventTarget.position, curMovePath.endPoint.position, curMovePath.moveSpeed * deltaTime);
            EventTarget.position = pos;
            if (EventTarget.position.FEqual(curMovePath.endPoint.position))
            {
                pause = true;
                beginPauseTime = Time.realtimeSinceStartup;
            }
        }
        else
        {
            Vector3 pos = Vector3.MoveTowards(EventTarget.position, curMovePath.startPoint.position, curMovePath.moveSpeed * deltaTime);
            EventTarget.position = pos;
            if (EventTarget.position.FEqual(curMovePath.startPoint.position))
            {
                pause = true;
                beginPauseTime = Time.realtimeSinceStartup;
            }
        }

        if (pause)
        {
            if (targetAnimator != null && targetAnimator.GetCurrentAnimatorStateInfo(0).IsName("f_idle"))
            {
                targetAnimator.Play("f_idle");
            }
        }
    }

    void MoveNextPath()
    {
        if(targetAnimator!=null && targetAnimator.GetCurrentAnimatorStateInfo(0).IsName("f_run"))
        {
            targetAnimator.Play("f_run");
        }

        pause = false;
        curMovePath = MovePaths[curPathIdx];
        if (reverse)
        {
            start2End = false;
            EventTarget.position = curMovePath.endPoint.position;
            curPathIdx--;
            if(curPathIdx < 0)
            {
                curPathIdx = 0;
                reverse = false;
            }
            if (EventTarget != null)
            {
                EventTarget.LookAt(curMovePath.startPoint.position);
            }
        }
        else
        {
            EventTarget.position = curMovePath.startPoint.position;
            start2End = true;
            curPathIdx++;
            if(curPathIdx >= MovePaths.Length)
            {
                if(MoveType == SceneMoveType.PingPong)
                {
                    curPathIdx--;
                    reverse = true;
                }
                else
                {
                    curPathIdx = 0;
                    reverse = false;
                }
            }
            if (EventTarget != null)
            {
                EventTarget.LookAt(curMovePath.endPoint.position);
            }
        }
    }
}
