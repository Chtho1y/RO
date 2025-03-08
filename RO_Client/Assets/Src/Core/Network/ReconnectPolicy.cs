using System;
using UnityEngine;

public delegate uint tryReconnectDelegate(uint nCount, uint nMax);

/// <summary>
/// 网络重连策略
/// </summary>
public class ReconnectPolicy
{

    private GameBaseConnector connector = null;
    private tryReconnectDelegate callback = null;
    private Action policyCompleted = null;

    private bool sessionStopped = false;
    private float reconnectTime = 0;
    private uint reconnectCount = 4;
    private uint tryCount = 0;
    private uint connectTimeout = 10; //超时，单位秒
    public bool shouldReconnect = false;


    public void SetConnector(GameBaseConnector inConnector, tryReconnectDelegate inEvent, Action inPolicyCompleted, uint tryMax)
    {
        sessionStopped = false;
        shouldReconnect = false;
        connector = inConnector;
        callback = inEvent;
        policyCompleted = inPolicyCompleted;
        reconnectCount = tryMax;
        Debug.Log(string.Format("connector:{0}, tryMax:{1}", inConnector != null ? inConnector.ToString() : "", tryMax));
    }

    public void StopPolicy()
    {
        sessionStopped = false;
        shouldReconnect = false;
        reconnectTime = connectTimeout;
        tryCount = 0;
    }

    public void StartPolicy(enNetResult result, int timeWait)
    {
        switch (result)
        {
            case enNetResult.Success:
                {
                    shouldReconnect = false;
                    sessionStopped = false;
                }
                break;
            case enNetResult.ConnectFailed:
            case enNetResult.Timeout:
            case enNetResult.Error:
                {
                    shouldReconnect = true;
                    sessionStopped = true;
                    reconnectTime = (tryCount == 0 ? 0 : timeWait);
                }
                break;

            default:
                {
                    shouldReconnect = true;
                    sessionStopped = true;
                    reconnectTime = (tryCount == 0 ? 0 : timeWait);
                }
                break;
        }
    }


    public void UpdatePolicy(bool bForce)
    {
        if (!shouldReconnect)
        {
            return;
        }
        if (connector != null && !connector.Connected)
        {
            if (bForce)
            {
                reconnectTime = connectTimeout;
                tryCount = reconnectCount;

                if (sessionStopped)
                {
                    connector.RestartConnector();
                }
                else
                {
                    connector.RestartConnector();
                }
            }
            else
            {
                reconnectTime -= Time.unscaledDeltaTime;

                if (reconnectTime < 0)
                {
                    tryCount++;
                    reconnectTime = connectTimeout;

                    var testCount = tryCount;
                    if (callback != null)
                    {
                        testCount = callback(testCount, reconnectCount);
                    }

                    if (testCount > reconnectCount)
                    {
                        StopPolicy();
                        if (policyCompleted != null)
                        {
                            policyCompleted();
                        }
                        return;
                    }

                    tryCount = testCount;

                    if (sessionStopped)
                    {
                        connector.RestartConnector();
                    }
                    else
                    {
                        connector.RestartConnector();
                    }
                }
            }
        }
    }
}
