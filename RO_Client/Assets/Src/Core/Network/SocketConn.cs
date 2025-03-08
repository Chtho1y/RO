using System;
using System.Net;
using System.Net.Sockets;
using System.Collections.Generic;
using UnityEngine;

public enum enSocketState
{
    Connecting,     //建立连接中
    Reconnecting,   //重新连接中
    Connected,      //连接成功
    Disconnecting,  //断开连接中
    Disconnected,   //连接断开
    ConnectedTimeout,   //连接超时
    ConnectedError,     //连接出错
}

public class SocketConn
{
    string mName;

    string mLastIP;
    int mLastPort;

    Socket mSocket;

    enSocketState mPreSocketState;
    enSocketState mSocketState;
    ISocketHandler iHandler;

    float m_fConnectTimeout = 5f;
    float m_fBeginConnectTime = -1;
    bool m_bConnectExcept = false;

    string m_sConnectHost;
    int m_iConnectPort;

    int mConnectedFrameCount = 0;


    public enSocketState State { get { return mSocketState; } }
    public Socket Sock { get { return mSocket; } }

    public SocketConn(string name = "")
    {
        mName = name;
        mPreSocketState = enSocketState.Disconnected;
        mSocketState = enSocketState.Disconnected;
        mConnectedFrameCount = 0;
        m_bConnectExcept = false;
    }

    public void RegHandler(ISocketHandler handler)
    {
        iHandler = handler;
    }

    public void Resume()
    {
        mSocketState = enSocketState.ConnectedError;
        iHandler.OnError();
    }

    public void CustomUpdate()
    {
        if (m_fBeginConnectTime > 0 && Time.realtimeSinceStartup - m_fBeginConnectTime > m_fConnectTimeout)
        {
            Timeout();
            return;
        }

        if (m_bConnectExcept)
        {
            Disconnect();
        }

        if (mSocketState != enSocketState.Connected)
        {
            return;
        }


        if (mConnectedFrameCount == 1)
        {
            mConnectedFrameCount++;
            if (iHandler != null)
            {
                if (mPreSocketState == enSocketState.Reconnecting)
                    iHandler.OnReconnect();
                else
                    iHandler.OnConnect();
            }
        }

        try
        {
            //检测网络是否出错
            if (mSocket != null && mSocket.Poll(1, SelectMode.SelectError))
            {
                if (iHandler != null)
                {
                    try {
                        mSocketState = enSocketState.ConnectedError;
                        iHandler.OnError(); 
                    }
                    catch (SocketException se) 
                    { 
                        iHandler.OnException(se);
                    }
                }
            } 
        }
        catch (System.Exception ex)
        {
            Debug.LogError("socket exception: " + ex.Message);
        }
    }

    public bool Connect(string host, int port, float timeout = 1f)
    {
        if (mSocketState != enSocketState.Disconnected)
            Disconnect();

        mPreSocketState = mSocketState;
        mSocketState = enSocketState.Connecting;
        m_fConnectTimeout = timeout;
        mConnectedFrameCount = 0;

        String newServerIp = "";
        AddressFamily newAddressFamily = AddressFamily.InterNetwork;
        if (!IPv6SupportMidleware.GetValidServerIpInfo(host, out newServerIp, out newAddressFamily))
        {
            Debug.LogError("IPv6SupportMidleware is Fail " + host);
            Disconnect();
            return false;
        }
        try
        {
            mSocket = new Socket(newAddressFamily, SocketType.Stream, ProtocolType.Tcp);
            IPAddress addr = IPAddress.Parse(newServerIp);
            IPEndPoint endpoint = new IPEndPoint(addr, port);

            Debug.LogWarning("Begin connect to Socket AddressFamily :" + newAddressFamily.ToString() + "ServerIp:" + newServerIp + ", Port:" + port);
            mSocket.NoDelay = true;
            mSocket.BeginConnect(endpoint, new AsyncCallback(EndConnect), new KeyValuePair<string, int>(host, port));
            m_fBeginConnectTime = Time.realtimeSinceStartup;

            return true;
        }
        catch (SocketException e)
        {
            Debug.LogError(e.Message);
            Disconnect();
        }

        return false;
    }

    public bool Reconnect()
    {
        if (string.IsNullOrEmpty(mLastIP))
            throw new Exception("cannot reconnect, last EndPoint is null");

        if (mSocketState != enSocketState.Disconnected)
        {
            Disconnect();
            return false;
        }

        mPreSocketState = mSocketState;
        mSocketState = enSocketState.Reconnecting;
        mConnectedFrameCount = 0;

        String newServerIp = "";
        AddressFamily newAddressFamily = AddressFamily.InterNetwork;
        if (!IPv6SupportMidleware.GetValidServerIpInfo(mLastIP, out newServerIp, out newAddressFamily))
        {
            Debug.LogError("IPv6SupportMidleware is Fail " + mLastIP);
            Disconnect();
            return false;
        }
        try
        {
            mSocket = new Socket(newAddressFamily, SocketType.Stream, ProtocolType.Tcp);
            mSocket.NoDelay = true;
            Debug.LogWarning("Begin connect to Socket AddressFamily :" + newAddressFamily.ToString() + "ServerIp:" + newServerIp + ", Port:" + mLastPort);
            mSocket.BeginConnect(newServerIp, mLastPort, new AsyncCallback(EndConnect), new KeyValuePair<string, int>(newServerIp, mLastPort));
            m_fBeginConnectTime = Time.realtimeSinceStartup;
            return true;
        }
        catch (SocketException e)
        {
            Debug.LogError(e.Message);
            Disconnect();
        }
        return false;
    }

    void EndConnect(IAsyncResult async)
    {
        Debug.Log("Connect AsyncCallback!");
        try
        {
            mSocket.EndConnect(async);


            if (mSocketState != enSocketState.Reconnecting)
            {
                KeyValuePair<string, int> pair = (KeyValuePair<string, int>)async.AsyncState;
                mLastIP = pair.Key;
                mLastPort = pair.Value;
            }

            mConnectedFrameCount = 1;
            mPreSocketState = mSocketState;
            mSocketState = enSocketState.Connected;
        }
        catch (SocketException e)
        {
            if (!e.NativeErrorCode.Equals(10035))
            {
                Debug.LogError(e.Message);
                // 当前是异步线程，等待主线程参数判定回调
                m_bConnectExcept = true;
            }
        }
        m_fBeginConnectTime = -1f;
    }

    public void Disconnect(bool ignoreEvent = false)
    {
        Debug.Log("Disconnect");
        if (mSocket != null)
        {
            mPreSocketState = mSocketState;
            mSocketState = enSocketState.Disconnecting;
            try { mSocket.Shutdown(SocketShutdown.Both); }
            catch (SocketException) { }
            finally
            {
                mSocket.Close(0);
                mSocket = null;
            }
        }

        if (!ignoreEvent)
        {
            if (iHandler != null)
            {
                iHandler.OnDisconnect();
            }
        }
        mPreSocketState = mSocketState;
        mSocketState = enSocketState.Disconnected;
        m_fBeginConnectTime = -1f;
        mConnectedFrameCount = 0;
        m_bConnectExcept = false;
    }


    private void Timeout()
    {
        if (iHandler != null)
        {
            iHandler.OnTimeout();
        }

        mPreSocketState = mSocketState;
        mSocketState = enSocketState.ConnectedTimeout;
        m_fBeginConnectTime = -1f;
    }
}
