using System;
using System.Net;
using System.Net.Sockets;
using System.Collections.Generic;
using System.Reflection;
using UnityEngine;
using LuaInterface;

public delegate void NetConnectedEvent(object sender);
public delegate void NetDisconnectEvent(object sender);
public delegate void NetMsgDelegate(NetPkg msg);
public delegate void NetConnectorEvent(string log);

public class NetworkMgr : Singleton<NetworkMgr>
{
    public const UInt16 c_RSA_Encrypt = 1;
    public const UInt16 c_AES_Encrypt = 2;
    public const UInt16 c_pingCmdId = 1000;
    public const UInt16 c_pingCmdAck = 1001;
    public const UInt16 c_reconnectCmdAck = 1005;

    public GameServerConnector gameSrv = new GameServerConnector();

    public int m_GameReconnetCount = 0;

    // 是否是联网模式
    private bool bOnlineMode = true;
    public bool isOnlineMode
    {
        get { return bOnlineMode; }
        set { bOnlineMode = value; }
    }

    // 上一次发送心跳的时间
    private float mLastHeartTime;
    private float mLastHeartTimeWait;
    private int mHeartAckWaitNum = 0;
    private int mHeartDelayTime = 9999;
    // 毫秒值
    public int heartDelayTime
    {
        get { return mHeartDelayTime; }
    }


    private int mReconnetCount;     //重连次数

    LuaFunction mLuaGameServerConnectedCb = null;

    LuaFunction receiveMessageFunc = null;
    public LuaFunction ReceiveMessageFunc
    {
        set { receiveMessageFunc = value; }
        get { return receiveMessageFunc; }
    }
    LuaFunction openReconnectionWndFunc = null;
    public LuaFunction OpenReconnectionWndFunc
    {
        set { openReconnectionWndFunc = value; }
        get { return openReconnectionWndFunc; }
    }
    LuaFunction luaNoitceFunc = null;
    public LuaFunction LuaNoitceFunc
    {
        set { luaNoitceFunc = value; }
        get { return luaNoitceFunc; }
    }

    //是否是登录状态
    private bool mIsLogin = false;
    public bool IsLogin
    {
        get { return mIsLogin; }
        set { mIsLogin = value; }
    }

    /// <summary>
    /// 网络模块初始化
    /// </summary>
    public override void Init()
    {
        isOnlineMode = true;
        EventMgr.AddEventListener<bool, bool>(ECoreEventType.EID_GameServer_ConnectSuccess, OnConnectRet);
    }

    void OnConnectRet(CoreEvent<bool, bool> ce)
    {
        bool ret = ce.Data;
        bool reconnect = ce.Data1;
        if (!ret)
        {
            mIsLogin = false;
            gameSrv.curCltPkgSeq = 1;
        }

        if (mLuaGameServerConnectedCb != null)
            mLuaGameServerConnectedCb.Call(this, ret, reconnect);
    }

    public void SetGameServerConnectedLuaFunc(LuaFunction func)
    {
        mLuaGameServerConnectedCb = func;
    }

    public bool ConnectServer(string host, int port)
    {
        Debug.Log(">>>>>>Connecting to server at: " + host + ":" + port);

        string ip = GetIp(host);
        if (string.IsNullOrEmpty(ip))
        {
            DebugHelper.LogError(host + " 没有配置IP");
            return false;
        }

        //mLuaGameServerConnectedCb = luaFunc_;
        ConnectorParam param = new ConnectorParam(ip, port);
        return ConnectServer(param);
    }

    private string GetIp(string m_Host)
    {
        if (StringUtil.isIpString(m_Host))
        {
            return m_Host;
        }

        IPAddress[] ips = null;
        int retryTime = 0;

        while (ips == null && retryTime < 3)
        {
            try
            {
                retryTime++;
                IPHostEntry hostEntry = Dns.GetHostEntry(m_Host);
                ips = hostEntry.AddressList;
            }
            catch (System.Net.Sockets.SocketException)
            {
                DebugHelper.LogError("GetHostEntry Failed");
            }

        }

        if (ips != null && ips.Length > 0)
            return ips[0].ToString();

        return "";
    }


    /// <summary>
    /// 连接服务器
    /// </summary>
    /// <returns>是否成功</returns>
    [NoToLua]
    public bool ConnectServer(ConnectorParam para)
    {
        mReconnetCount = 0;
        isOnlineMode = true;
        return gameSrv.Init(para);
    }

    /// <summary>
    /// 重置大厅连接的发送队列
    /// </summary>
    public void ResetSending()
    {
        gameSrv.ResetSending(true);
    }

    public bool GetConnectStatus()
    {
        return gameSrv.Connected;
    }

    public void Disconnect()
    {
        if (gameSrv != null)
        {
            gameSrv.DisconnectConnector();
            gameSrv.DealConnectFail();
        }
    }

    public void CloseGameServerConnect()
    {
        gameSrv.CleanUp();
        gameSrv.Disconnect();
        mReconnetCount = 0;
        mIsLogin = false;
    }

    public void SetAesKey(string aesKey)
    {
        SecurityLayer.Instance.SetAesKey(aesKey);
    }

    public bool SendMsg(byte[] msgBody, UInt16 cmdId, bool isShowAlert = false, bool bConfirm = false)
    {
        NetPkg msg = NetPkg.CreateNetReqPkg(cmdId, msgBody);
        return SendMsg(ref msg, bConfirm, isShowAlert);
    }

    //使用RSA加密发送消息
    public bool SendMsgWithRSA(byte[] msgBody, UInt16 cmdId, bool isShowAlert = false, bool bConfirm = false)
    {
        byte[] encodedMsgBody = SecurityLayer.Instance.RSAEncrypt(msgBody);
        NetPkg msg = NetPkg.CreateNetReqPkg(cmdId, encodedMsgBody);
        msg.Head.EncryptFlag = c_RSA_Encrypt;


        return SendMsg(ref msg, bConfirm, isShowAlert);
    }

    //使用AES加密发送消息
    public bool SendMsgWithAES(byte[] msgBody, UInt16 cmdId, bool isShowAlert = false, bool bConfirm = false)
    {
        byte[] encodedMsgBody = SecurityLayer.Instance.AESEncrypt(msgBody);
        NetPkg msg = NetPkg.CreateNetReqPkg(cmdId, encodedMsgBody);
        msg.Head.EncryptFlag = c_AES_Encrypt;

        return SendMsg(ref msg, bConfirm, isShowAlert);
    }

    [NoToLua]
    public bool SendMsg(ref NetPkg msg, bool bConfirm, bool isShowAlert = false)
    {
        if (isOnlineMode)
        {
            msg.Confirm = bConfirm;
            gameSrv.PushSendMsg(msg);

            return true;
        }

        return false;
    }

    /// <summary>
    /// 高频率调用网络收发
    /// </summary>
    public void Update()
    {
        if (isOnlineMode && gameSrv != null)
        {
            try
            {
                gameSrv.CustomUpdate();

                // 发送心跳包
                if (gameSrv.CanSendPing() && (Time.realtimeSinceStartup - mLastHeartTime >= 1.0f))
                {
                    mLastHeartTime = Time.realtimeSinceStartup;
                    if (mHeartAckWaitNum == 0)
                    {
                        mLastHeartTimeWait = Time.realtimeSinceStartup;
                    }
                    mHeartAckWaitNum++;
                    //todo 处理心跳消息的发送
                    SendPing();
                }

                gameSrv.HandleSending();

                HandleLobbyMsgRecv();
            }
            catch (Exception e)
            {
                DebugHelper.LogException(e);
                DebugHelper.LogError("NetworkMgr Update Error:" + e.Message);
            }
            if (mHeartAckWaitNum > 3)
            {
                mHeartAckWaitNum = 0;
                // 累计多次心跳未收到回包，说明链接到达不了服务器，断开链接, 并进入重连机制
                if (gameSrv != null)
                {
                    gameSrv.DisconnectConnector();
                    gameSrv.StartReconnect();
                }
            }
        }
    }

    private void SendPing()
    {
        NetPkg msg = NetPkg.CreateNetReqPkg(c_pingCmdId, null);
        gameSrv.ImmeSendPackage(msg);
    }

    private void HandleLobbyMsgRecv()
    {
        if (gameSrv != null)
        {
            List<NetPkg> msgList = gameSrv.RecvPackage();
            while (msgList != null && msgList.Count > 0)
            {
                for (int idx = 0; idx < msgList.Count; idx++)
                {
                    NetPkg msg = msgList[idx];

                    UInt16 msgId = msg.Head.CmdId;
                    OnProtocolLua(msg.Body.MsgData, msgId);
                    gameSrv.PostRecvPackage(msg);
                }

                msgList.Clear();
                msgList = gameSrv.RecvPackage();
            }
        }
    }

    public void OnProtocolLua(byte[] bodyInfo_, UInt16 msgId)
    {
        if (msgId == c_pingCmdAck)
        {
            mHeartAckWaitNum = 0;
            try
            {
                mHeartDelayTime = System.Convert.ToInt32((Time.realtimeSinceStartup - mLastHeartTimeWait) * 1000);
            }
            catch
            {
                mHeartDelayTime = 9999;
            }
            return;
        }

        if (ReceiveMessageFunc != null)
        {
            LuaByteBuffer luaByte = new LuaByteBuffer(bodyInfo_);
            ReceiveMessageFunc.Call(this, luaByte, msgId);
        }
        else
        {
            Debug.Log("LuaNetHandler InitIng : " + msgId);
        }
    }

    public void Resume()
    {
        if (isOnlineMode && gameSrv != null)
        {
            try
            {
                gameSrv.Resume();
            }
            catch (Exception e)
            {
                DebugHelper.LogError("NetworkMgr Update Error:" + e.Message);
            }
        }
    }

    public void StartReconnect()
    {
        if (gameSrv != null)
        {
            gameSrv.StartReconnect();
        }
    }

    public bool HasCmdIdAtConfirmQueue(UInt16 cmdId)
    {
        if (gameSrv != null)
        {
            return gameSrv.HasCmdIdAtConfirmQueue(cmdId);
        }
        return false;
    }
}