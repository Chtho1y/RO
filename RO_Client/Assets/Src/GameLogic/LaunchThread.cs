using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading;
using UnityEngine;

public class LaunchThread : Singleton<LaunchThread>
{
    public enum AsyncLaunchState
    {
        None,
        ConfigInit,
        LuaInit,
    }


    private Thread m_Thread = null;
    private Action m_AsyncAction = null;
    private Action m_UpdateAction = null;
    private Action m_CompleteAction = null;
    private int m_TimerSeqId = 0;
    private AsyncLaunchState m_AsyncLaunchState = AsyncLaunchState.None;

    ~LaunchThread()
    {
        Dispose();
    }

    public override void UnInit()
    {
        Dispose();
    }

    private void Dispose()
    {
        Stop();
        m_AsyncAction = null;
        m_UpdateAction = null;
        m_CompleteAction = null;
    }

    public bool Start(AsyncLaunchState asyncLaunchState, Action asyncAction, Action completeAction, Action updateAction)
    {
        if (m_Thread != null && m_Thread.IsAlive)
        {
            DebugHelper.LogError("The async thread is busy");
            return false;
        }
        Stop();
        m_AsyncLaunchState = asyncLaunchState;
        m_AsyncAction = asyncAction;
        m_UpdateAction = updateAction;
        m_CompleteAction = completeAction;
        m_TimerSeqId = TimerManager.Instance.AddTimer(0, -1, UpdateTimer);
        m_Thread = new Thread(ThreadProc);
        m_Thread.Start();
        return true;
    }

    public void Stop(AsyncLaunchState asyncLaunchState)
    {
        if (m_AsyncLaunchState != asyncLaunchState)
        {
            return;
        }
        Stop();
    }

    public void Stop()
    {
        try
        {
            if (m_Thread != null)
            {
                m_Thread.Abort();
                m_Thread.Join();
            }
            m_Thread = null;
            m_AsyncLaunchState = AsyncLaunchState.None;
            StopTimer();
        }
        catch (System.Threading.ThreadAbortException e)
        {
            DebugHelper.LogWarning(e.Message);
        }
        catch(Exception e)
        {
            DebugHelper.LogException(e);
        }
    }

    private void UpdateTimer(int timerSeqId)
    {
        try
        {
            if (m_UpdateAction != null)
                m_UpdateAction();
            if (m_Thread == null || !m_Thread.IsAlive)
            {
                Stop();
                if (m_CompleteAction != null)
                {
                    m_CompleteAction();
                    m_CompleteAction = null;
                }
            }
        }
        catch (System.Threading.ThreadAbortException e)
        {
            DebugHelper.LogWarning(e.Message);
        }
        catch(Exception e)
        {
            DebugHelper.LogException(e);
        }
    }

    private void StopTimer()
    {
        if (TimerManager.Instance != null)
        {
            TimerManager.Instance.RemoveTimer(m_TimerSeqId);
        }
    }

    private void ThreadProc()
    {
        try
        {
            if (m_AsyncAction != null)
                m_AsyncAction();
        }
        catch (System.Threading.ThreadAbortException e)
        {
            DebugHelper.LogWarning(e.Message);
        }
        catch(Exception e)
        {
            DebugHelper.LogException(e);
        }
        
        m_AsyncAction = null;
    }


}
