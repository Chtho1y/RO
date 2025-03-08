using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 所有CCoroutine返回yield指令对象的基类
/// </summary>
public class CCoroutineYieldBase
{

}

/// <summary>
/// 排他性的yield，在这个yield到下个yield完成之前，不允许其他的协程执行
/// </summary>
public class CHoldForSecond : CCoroutineYieldBase
{
    public float m_interval = -1;

    /// <summary>
    /// 间隔时间
    /// </summary>
    /// <param name="timeoutTime">间隔时间，yield return之后至少要过这么久才又会调用过来，单位秒，在这段时间内主线程sleep等待</param>
    public CHoldForSecond(float interval = 0f)
    {
        m_interval = interval;
    }
}

/// <summary>
/// 排他性的yield，在这个yield到下个yield完成之前，不允许其他的协程执行
/// </summary>
public class CWaitForSecond : CCoroutineYieldBase
{
    public float m_interval = -1;

    /// <summary>
    /// 间隔时间
    /// </summary>
    /// <param name="timeoutTime">间隔时间，yield return之后至少要过这么久才又会调用过来，单位秒，在这段时间内主线程继续开始循环</param>
    public CWaitForSecond(float interval = -1)
    {
        m_interval = interval;
    }
}

/// <summary>
/// 排他性的yield，在这个yield到下个yield完成之前，不允许其他的协程执行
/// </summary>
public class CWaitForNextFrame : CCoroutineYieldBase
{

}

/// <summary>
/// 之所以CCorourtineManager还需要用这个Monobehaviour去调用，就是由于如果CCorourtineManager直接是Monobehaviour，会自带
/// StartCoroutine方法，而那个是我们的类不希望开发人员去调用的
/// </summary>
public class ____CCorourtineManagerMonobehaviour : SingletonMono<____CCorourtineManagerMonobehaviour>
{
    public CCoroutineManager s_smartCoroutine = null;


    void Update()
    {
        if (null != s_smartCoroutine)
        {
            s_smartCoroutine.Update();
        }
    }
}

/// <summary>
/// 代表一个协程任务
/// </summary>
public class CCoroutine
{
    public IEnumerator iter = null;

    public CCoroutine(IEnumerator it)
    {
        iter = it;
    }

    public void Stop()
    {
        iter = null;
    }
}


/// <summary>
/// 智能协程，能够很好利用每一帧的时间来做事，又尽量不卡渲染，用于平滑Loading时候的动画
/// </summary>
public class CCoroutineManager : Singleton<CCoroutineManager>
{
    private System.DateTime m_lastFrameTime;
    private System.DateTime m_waitTillTime;
    private long m_lastTimeUpdateBeginTime = 0;
    private LinkedList<CCoroutine> m_execlusiveCoroutineList = new LinkedList<CCoroutine>();

    private int m_frameRate = 0;
    private double m_deltaMillSecondsPerFrame = 0;
    int sleepTime = 0;
    int WaitTime = 0;

    public override void Init()
    {
        ____CCorourtineManagerMonobehaviour.Instance.s_smartCoroutine = this;

        m_lastFrameTime = System.DateTime.Now;
        m_waitTillTime = System.DateTime.Now;
        m_frameRate = 30;
        m_deltaMillSecondsPerFrame = standardDeltaTime * 1;
    }

    private double standardDeltaTime
    {
        get
        {
            return 1000f / 30f;
        }
    }


    public void Update()
    {
        //WaitFormSeconds的时间还没到
        if (System.DateTime.Now <= m_waitTillTime)
        {
            return;
        }

        //ReEvaluateTimeCost();

        m_lastFrameTime = System.DateTime.Now;
        while ((System.DateTime.Now - m_lastFrameTime).TotalMilliseconds < m_deltaMillSecondsPerFrame
            && m_execlusiveCoroutineList.Count > 0)
        {
            LinkedListNode<CCoroutine> node = m_execlusiveCoroutineList.Last;
            var coroutine = node.Value.iter;
            if (!coroutine.MoveNext())
            {
                //协程已经执行完
                m_execlusiveCoroutineList.Remove(node);
                continue;
            }
            object handle = coroutine.Current;
            if (handle == null)
            {
                //协程已经执行完
                m_execlusiveCoroutineList.Remove(node);
                continue;
            }
            if (handle is CCoroutine)
            {
                continue;
            }
            if (handle is CHoldForSecond)
            {
                ProcessHoldForSeconds(handle as CHoldForSecond);
            }
            else if (handle is CWaitForSecond)
            {
                ProcessWaitForSeconds(handle as CWaitForSecond);
                break;
            }
            else if (handle is CWaitForNextFrame)
            {
                break;
            }
            else
            {
                DebugHelper.LogError("CCoroutine不支持" + handle.GetType() + "类型的yield return指令，请明确您需要做什么");
            }
        }
        m_lastFrameTime = System.DateTime.Now;
    }

    /// <summary>
    /// 重新评估m_deltaTimePerFrame是否合理，是否把帧之间的时间利用得当
    /// </summary>
    private System.DateTime m_lastEvaluateTime = System.DateTime.Now;
    private bool m_evaluateStart = false;
    private void ReEvaluateTimeCost()
    {
        if (m_evaluateStart == false)
        {
            m_lastEvaluateTime = System.DateTime.Now;
            m_evaluateStart = true;
            return;
        }

        System.DateTime evaluateTime = System.DateTime.Now;
        double diff = (evaluateTime - m_lastEvaluateTime).TotalMilliseconds;
        m_lastEvaluateTime = evaluateTime;
        if (diff > standardDeltaTime)
        {
            m_deltaMillSecondsPerFrame = System.Math.Max(standardDeltaTime * 0.3f, m_deltaMillSecondsPerFrame - (diff - standardDeltaTime));
        }
        else if (m_deltaMillSecondsPerFrame < standardDeltaTime * 0.75f)
        {
            m_deltaMillSecondsPerFrame += 1;   //如果用于loading的时间太短，就尝试开始增加
        }
    }

    private void ProcessHoldForSeconds(CHoldForSecond handle)
    {
        if (handle.m_interval > 0)
        {
            sleepTime += (int)(handle.m_interval * 1000);
            System.Threading.Thread.Sleep((int)(handle.m_interval * 1000f));
        }
    }

    private void ProcessWaitForSeconds(CWaitForSecond handle)
    {
        if (handle.m_interval > 0)
        {
            WaitTime += (int)(handle.m_interval * 1000);
            m_waitTillTime = System.DateTime.Now.AddSeconds(handle.m_interval);
        }
    }

    /// <summary>
    /// 开始协程
    /// </summary>
    /// <param name="coroutine"></param>
    public CCoroutine StartCoroutine(IEnumerator coroutine)
    {
        CCoroutine cor = new CCoroutine(coroutine);
        m_execlusiveCoroutineList.AddLast(cor);
        return cor;
    }

    /// <summary>
    /// 停止一个协程
    /// </summary>
    /// <param name="c"></param>
    public void StopCoroutine(CCoroutine c, bool stopChild = true)
    {
        if (c != null)
        {
            c.Stop();

            bool foundChild = false;
            var iter = m_execlusiveCoroutineList.GetEnumerator();
            while (iter.MoveNext())
            {
                if (iter.Current == c)
                {
                    foundChild = true;
                    break;
                }
            }

            if (!stopChild)
            {
                if (foundChild)
                {
                    m_execlusiveCoroutineList.Remove(iter.Current);
                }
                return;
            }
            else
            {
                if (foundChild)
                {
                    CCoroutine last = m_execlusiveCoroutineList.Last.Value;
                    while (last != c)
                    {
                        m_execlusiveCoroutineList.RemoveLast();
                        last = m_execlusiveCoroutineList.Last.Value;
                    }
                    m_execlusiveCoroutineList.RemoveLast();
                }
            }
        }

    }
}
