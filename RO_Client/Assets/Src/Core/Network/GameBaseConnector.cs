using System;
using UnityEngine;

#pragma warning disable 0618

public enum enDealConnectStatus
{
    Deal_Connect_Success,
    Deal_Reconect_Success,
    Deal_Connect_Fail,
    Deal_Connect_Error,
    Deal_Connect_Close,
}

public class ConnectorParam
{
    public string ip = "";
    public int port = 6629;

    public void SetVPort(int nPort)
    {
        port = nPort;
    }

    public void SetVip(string Vip)
    {
        ip = Vip;
    }

    public ConnectorParam(string ip, int port)
    {
        this.ip = ip;
        this.port = port;
    }
}

public class GameBaseConnector
{
    protected Connector mConnector = null;

    protected ConnectorParam mInitParam = null;

    protected bool bConnected = false;

    public static uint connectTimeout = 10;


    protected string mLastSuccessIp;
    protected int mLastSuccessPort;

    public ConnectorParam InitParam
    { get { return mInitParam; } }

    public bool Connected
    {
        get { return bConnected; }
    }

    public bool CreateConnector(ConnectorParam param)
    {
        DestroyConnector();
        if (null == param)
            return false;

        mInitParam = param;
        bConnected = false;
        mConnector = new Connector(mInitParam.ip, mInitParam.port);

        mConnector.ConnectEvent += onConnectEvent;
        mConnector.DisconnectEvent += onDisconnectEvent;
        mConnector.ReconnectEvent += onReconnectEvent;
        mConnector.ErrorEvent += onConnectError;
        mConnector.TimeoutEvent += onConnectTimeout;
        mConnector.ConnectFailedEvent += onConnectFailed;

        return mConnector.Connect(GameBaseConnector.connectTimeout);
    }

    public void DestroyConnector()
    {
        if (mConnector != null)
        {
            mConnector.ConnectEvent -= onConnectEvent;
            mConnector.DisconnectEvent -= onDisconnectEvent;
            mConnector.ReconnectEvent -= onReconnectEvent;
            mConnector.ErrorEvent -= onConnectError;
            mConnector.TimeoutEvent -= onConnectTimeout;
            mConnector.ConnectFailedEvent -= onConnectFailed;

            mConnector.Disconnect();
            mConnector = null;
            bConnected = false;
            Debug.Log("DestroyConnector");
        }

        OnDestroyConnector();
    }

    protected virtual void OnDestroyConnector()
    {

    }

    public void RestartConnector()
    {
        Debug.Log("Connector Restart");
        DestroyConnector();
        CreateConnector(mInitParam);
    }

    public void DisconnectConnector()
    {
        if (mConnector != null)
        {
            mConnector.Disconnect();
            bConnected = false;
        }
    }


    public virtual void DealConnectSucc(enDealConnectStatus status)
    {
        EventMgr.DispatchEvent<bool, bool>(new CoreEvent<bool, bool>(ECoreEventType.EID_GameServer_ConnectSuccess, true, false));
    }

    public virtual void DealConnectFail()
    {
        EventMgr.DispatchEvent<bool, bool>(new CoreEvent<bool, bool>(ECoreEventType.EID_GameServer_ConnectSuccess, false, false));
    }

    public virtual void DealConnectError()
    {
        EventMgr.DispatchEvent<bool, bool>(new CoreEvent<bool, bool>(ECoreEventType.EID_GameServer_ConnectSuccess, false, true));
    }

    public virtual void DealConnectClose()
    {
        EventMgr.DispatchEvent<bool, bool>(new CoreEvent<bool, bool>(ECoreEventType.EID_GameServer_ConnectSuccess, false, false));
    }

    public virtual void DealReconnectFail()
    {
        EventMgr.DispatchEvent<bool, bool>(new CoreEvent<bool, bool>(ECoreEventType.EID_GameServer_ConnectSuccess, false, true));
    }

    private void onConnectEvent()
    {
        if (mConnector == null) return;

        bConnected = true;
        DealConnectSucc(enDealConnectStatus.Deal_Connect_Success);
    }

    private void onDisconnectEvent()
    {
        bConnected = false;
        DealConnectClose();
    }

    private void onReconnectEvent()
    {
        if (mConnector == null)
            return;

        bConnected = true;
        DealConnectSucc(enDealConnectStatus.Deal_Reconect_Success);
    }

    private void onConnectError()
    {
        bConnected = false;
        DealConnectError();
    }

    private void onConnectTimeout()
    {
        bConnected = false;
        DealConnectFail();
    }

    private void onConnectFailed()
    {
        bConnected = false;
        DealConnectFail();
    }
}