using System;
using System.Collections.Generic;
using UnityEngine;
using System.Net.Sockets;

public enum enNetResult
{
    Success = 0,
    Error,
    ConnectFailed,
    NetworkException,
    Timeout,
    InvalidArgument,
    LengthError,
    Unknown,
    Empty,
}

public class Connector : ISocketHandler
{
    public const int RECV_BUFF_SIZE = 1024 * 1024;
    private readonly int BODY_MAX_LENGTH = 128 * 1024;

    private SocketConn mSocketConn = null;
    public Action ConnectEvent = null;
    public Action ReconnectEvent = null;
    public Action DisconnectEvent = null;
    public Action ErrorEvent = null;
    public Action ConnectFailedEvent = null;
    public Action TimeoutEvent = null;

    private string ip;  //IP地址
    private int port; //端口
    private float m_fConnectTimeout = 5;

    private StateObject mStateObject = null;
    private byte[] mRecvBuffer = new byte[RECV_BUFF_SIZE];
    private byte[] mHeadBytes = new byte[NetPkgHead.HeadLength];
    private NetPkgHead mHead = null;

    public bool Connected { get; private set; }

    public Connector(string ip, int port)
    {
        this.ip = ip;
        this.port = port;

        Connected = false;

        mSocketConn = new SocketConn("tcp");
        mSocketConn.RegHandler(this);
    }

    public void CustomUpdate()
    {
        if (mSocketConn != null)
            mSocketConn.CustomUpdate();
    }

    public void Resume()
    {
        if (mSocketConn != null)
            mSocketConn.Resume();
    }

    public bool WriteData(byte[] data, int len)
    {
        try
        {
            if (data == null) return false;

            if (mSocketConn == null || mSocketConn.Sock == null || mSocketConn.State != enSocketState.Connected)
                return false;

            try
            {
                if (!mSocketConn.Sock.Poll(1, SelectMode.SelectWrite)) return false;
                mSocketConn.Sock.Send(data, 0, len, SocketFlags.None);
                return true;
            }
            catch (SocketException se)
            {
                Debug.LogError("Socket Send Exception: " + se.Message);
                OnError();
            }

        }
        catch (System.Exception ex)
        {
            Debug.LogError("Tcp Write Data Error: " + ex.Message);
        }

        return false;
    }

    public bool WriteData(byte[] data)
    {
        return WriteData(data, data.Length);
    }

    public bool ReadData(ref List<NetPkg> pkgList)
    {
        try
        {
            if (mSocketConn == null || 
                mSocketConn.Sock == null || 
                mSocketConn.State != enSocketState.Connected)
            {
                return false;
            }

            int recvSize = 0;
            try
            {
                if (!mSocketConn.Sock.Poll(1, SelectMode.SelectRead)) return false;
                recvSize = mSocketConn.Sock.Receive(mRecvBuffer, 0, RECV_BUFF_SIZE, SocketFlags.None);
            }
            catch (SocketException ex)
            {
                Debug.LogError(ex.Message);
                OnError();
                return false;
            }

            if (recvSize <= 0)
            {
                return false;
            }

            //收到的字节长度以及数据处理
            int ret = received(mRecvBuffer, recvSize, ref pkgList);
            if (ret == 0)
            {
                return true;
            }

        }
        catch (Exception e)
        {
            Debug.LogError(e.Message);
        }
        return false;
    }

    private int received(byte[] buffer, int bytesRead, ref List<NetPkg> pkgList)
    {
        mStateObject.Write(buffer, bytesRead);

        while (true)
        {
            int len = (int)mStateObject.stream.Length;

            if (len == 0)
            {
                break;
            }

            if ((mStateObject.ReceiveBody &&
                len < (mStateObject.BuffLength)) ||
                (!mStateObject.ReceiveBody && len < NetPkgHead.HeadLength))
            {
                DebugHelper.LogWarning(string.Format("[ GeminiRPC.dataReceived ]parsed all data.cmdid:{2} remain length:{0}, BuffLength:{1}", len, mStateObject.BuffLength, mStateObject.CmdId));
                return 1;
            }

            if ((!mStateObject.ReceiveBody) && (len >= NetPkgHead.HeadLength))
            {
                long origPos = mStateObject.stream.Position;
                mStateObject.stream.Position = 0;
                ResetBytes();
                mStateObject.stream.Read(mHeadBytes, 0, (int)NetPkgHead.HeadLength);
                mStateObject.stream.Position = origPos;

                if (mHead == null)
                    mHead = new NetPkgHead();

                int temp = 0;
                CommError.Type ret = mHead.unpack(ref mHeadBytes, (int)NetPkgHead.HeadLength, ref temp);
                if (ret == CommError.Type.COMM_NO_ERROR)
                {
                    mStateObject.BodyLength = mHead.PkgLen;
                    mStateObject.BuffLength = (uint)mHead.PkgLen + NetPkgHead.HeadLength;
                    mStateObject.CmdId = mHead.CmdId;
                }
                else
                {
                    DebugHelper.LogError(string.Format("[ GeminiRPC.dataReceived ]unpack pkg head failed：{0},{1}", ret, temp));
                }

                mStateObject.ReceiveBody = true;

                if (mStateObject.BodyLength >= BODY_MAX_LENGTH)
                {
                    DebugHelper.LogError(string.Format("[ GeminiRPC.receivedHeader ]huge message, body length:{0}.", mStateObject.BodyLength));
                    return -1;
                }
            }

            if ((mStateObject.ReceiveBody) && (len >= mStateObject.BuffLength))
            {
                if (mStateObject.buffer.Length < mStateObject.BuffLength)
                {
                    mStateObject.buffer = new byte[mStateObject.BuffLength + 1024 - mStateObject.BuffLength % 1024];
                }

                byte[] data_bytes = mStateObject.buffer;

                mStateObject.stream.Position = 0;
                mStateObject.stream.Read(data_bytes, 0, (int)mStateObject.BuffLength);

                int buffLen = (int)mStateObject.BuffLength;

                int parseSize = 0;
                NetPkg msg = NetPkg.CreateNetRevPkg();
                CommError.Type ret = msg.unpack(ref data_bytes, buffLen, ref parseSize);
                if (ret == CommError.Type.COMM_NO_ERROR)
                {
                    pkgList.Add(msg);
                }
                else
                {
                    DebugHelper.LogError(string.Format("unpack socket buffer error,ret:{0}", (int)ret));
                    DebugHelper.LogError(string.Format("unpack socket buffer error,CmdId:{0} totoal len={1}", mStateObject.CmdId, buffLen));
                }

                mStateObject.Reset();
            }
        }
        return 0;
    }

    private void ResetBytes()
    {
        for (int idx = 0; idx < mHeadBytes.Length; idx++)
            mHeadBytes[idx] = 0;
    }

    public bool Connect()
    {
        if (mSocketConn == null) return false;

        if (mStateObject != null)
        {
            mStateObject.Dispose();
            mStateObject = null;
        }

        mStateObject = new StateObject();

        mHead = new NetPkgHead();

        return mSocketConn.Connect(this.ip, this.port, m_fConnectTimeout);
    }

    public bool Connect(float timeout)
    {
        m_fConnectTimeout = timeout;

        return Connect();
    }

    public bool Reconnect()
    {
        if (mSocketConn == null) return false;

        return mSocketConn.Reconnect();
    }

    public enNetResult Reconnect(float timeout)
    {
        return enNetResult.Empty;
    }

    public void Disconnect()
    {
        if (mSocketConn != null)
        {
            mSocketConn.Disconnect();
        }
    }

    public void OnConnect()
    {
        Connected = true;

        if (ConnectEvent != null)
            ConnectEvent();
    }

    public void OnReconnect()
    {
        Connected = true;

        if (ReconnectEvent != null)
            ReconnectEvent();
    }

    public void OnDisconnect()
    {
        Connected = false;

        if (DisconnectEvent != null)
            DisconnectEvent();
    }

    public void OnTimeout()
    {
        Debug.Log("Connect Timeout");

        if (TimeoutEvent != null)
            TimeoutEvent();
    }

    public void OnError()
    {
        Connected = false;

        Debug.LogError("Connect Error");

        if (ErrorEvent != null)
            ErrorEvent();
    }

    public void OnConnectFailed()
    {
        Connected = false;

        if (ConnectFailedEvent != null)
            ConnectFailedEvent();
    }

    public void OnException(System.Net.Sockets.SocketException se)
    {
        Debug.LogError(se.Message);
        mSocketConn.Disconnect();
    }
}
