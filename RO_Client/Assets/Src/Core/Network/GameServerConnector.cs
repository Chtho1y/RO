using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;

public class GameServerConnector : GameBaseConnector
{
    private static int nBuffSize = 204800;
    private byte[] szSendBuffer = new byte[204800];

    public event NetConnectedEvent ConnectedEvent;
    public event NetDisconnectEvent DisconnectEvent;

    public delegate uint DelegateGetTryReconnect(uint curConnectTime, uint maxCount);
    public DelegateGetTryReconnect GetTryReconnect = null;

    public UInt32 curCltPkgSeq = 1;


    private ReconnectPolicy reconPolicy = new ReconnectPolicy();

    //发送给大厅服务器的消息队列
    List<NetPkg> mSendQueue = new List<NetPkg>();
    List<NetPkg> mConfirmQueue = new List<NetPkg>();

    ~GameServerConnector()
    {
        DestroyConnector();
        reconPolicy = null;
    }

    /// <summary>
    /// 初始化连接
    /// </summary>
    /// <param name="para"></param>
    /// <returns></returns>
    public bool Init(ConnectorParam para)
    {
        reconPolicy.SetConnector(this, onTryReconnect, onPolicyCompleted, 3);

        return CreateConnector(para);
    }

    public void CustomUpdate()
    {
        if (mConnector != null)
            mConnector.CustomUpdate();
    }

    public void StartReconnect()
    {
        reconPolicy.StartPolicy(enNetResult.Error, 3);
    }

    public void StopReconnect()
    {
        reconPolicy.StopPolicy();
    }

    public void Resume()
    {
        if (mConnector != null)
            mConnector.Resume();
    }

    public void Disconnect()
    {
        DestroyConnector();
        reconPolicy.StopPolicy();
        reconPolicy.SetConnector(null, null, null, 0);
    }

    protected override void OnDestroyConnector()
    {
        base.OnDestroyConnector();
        mRecvPkgList.Clear();
    }

    /// <summary>
    /// 清空连接上的数据收发
    /// </summary>
    public void CleanUp()
    {
        mSendQueue.Clear();
        mConfirmQueue.Clear();

        reconPolicy.StopPolicy();

        szSendBuffer.Initialize();

        curCltPkgSeq = 1;
    }


    /// <summary>
    /// 重置发送缓冲
    /// </summary>
    /// <param name="bResetSeq"></param>
    public void ResetSending(bool bResetSeq)
    {
        mSendQueue.Clear();
        mConfirmQueue.Clear();

        szSendBuffer.Initialize();

        if (bResetSeq)
        {
            curCltPkgSeq = 1;
        }
    }

    /// <summary>
    /// 投递消息
    /// </summary>
    /// <param name="msg"></param>
    public void PushSendMsg(NetPkg msg)
    {
        if (CanPushMsg(msg))
        {
            mSendQueue.Add(msg);
        }
    }

    /// <summary>
    /// 处理待发送的消息
    /// </summary>
    public void HandleSending()
    {
        if (bConnected)
        {
            for (int i = 0; bConnected && i < mSendQueue.Count;)
            {
                var msg = mSendQueue[i];

                if (SendPackage(msg))
                {
                    //DebugHelper.LogError(DebugHelper.Tag_BHY + " SendPkg:" + msg.Head.CmdId + " seq:" + msg.Head.SvrPkgSeq);
                    if(msg.Head.CmdId != NetworkMgr.c_pingCmdId && msg.Confirm)
                    {
                        mConfirmQueue.Add(msg);
                    }
                    mSendQueue.RemoveAt(i);
                    continue;
                }

                i++;
            }
        }
        else
        {
            // 仅当需要发消息时才重连
            reconPolicy.UpdatePolicy(false);
        }
    }

    public bool CanSendPing()
    {
        return Connected && mSendQueue.Count == 0 && curCltPkgSeq > 1;
    }

    public bool HasCmdIdAtConfirmQueue(UInt16 cmdId)
    {
        for (int i = mConfirmQueue.Count - 1; i >= 0; i--)
        {
            var msg = mConfirmQueue[i];
            if (msg != null && msg.Head.CmdId == cmdId)
            {
                return true;
            }
        }

        return false;
    }

    private bool CanPushMsg(NetPkg msg)
    {
        if (bConnected)
        {
            return true;
        }

        //这几个频繁拉取的协议如果断网就不要push进来浪费带宽: 心跳消息，断线重连消息
        return true;
    }

    /// <summary>
    /// 尝试重连，返回0表示没有重连次数限制
    /// </summary>
    /// <param name="nCount"></param>
    /// <param name="nMax"></param>
    /// <returns></returns>
    private uint onTryReconnect(uint nCount, uint nMax)
    {
        if (GetTryReconnect != null)
        {
            return GetTryReconnect(nCount, nMax);
        }
        else
        {
            return nCount;
        }
    }

    private void onPolicyCompleted()
    {
        DealReconnectFail();
    }

    private void SendConfirmMsg()
    {
        var tempList = new List<NetPkg>();
        for (int i = 0; i < mSendQueue.Count; ++i)
        {
            tempList.Add(mSendQueue[i]);
        }
        mSendQueue.Clear();

        for (int i = 0; i < mConfirmQueue.Count; ++i)
        {
            mSendQueue.Add(mConfirmQueue[i]);
        }
        mConfirmQueue.Clear();

        for (int i = 0; i < tempList.Count; ++i)
        {
            mSendQueue.Add(tempList[i]);
        }
        //DebugHelper.LogError(DebugHelper.Tag_BHY+" Send ConfirmCnt:"+mSendQueue.Count);
    }

    #region interface
    /// <summary>
    /// 发送协议包
    /// </summary>
    /// <param name="msg"></param>
    /// <returns></returns>
    private bool SendPackage(NetPkg msg)
    {
        if (!bConnected || mConnector == null)
        {
            return false;
        }

        msg.Head.SvrPkgSeq = curCltPkgSeq++;

        int nPackSize = 0;
        if (msg.pack(ref szSendBuffer, nBuffSize, ref nPackSize) == CommError.Type.COMM_NO_ERROR)
        {
            byte[] dataBuff = new byte[nPackSize];
            Array.Copy(szSendBuffer, dataBuff, nPackSize);

            return mConnector.WriteData(dataBuff);
        }
        else
        {
            Debug.LogError(string.Format("pack lobby msg fail msgid={0}", msg.Head.CmdId));
        }

        return false;
    }

    public bool ImmeSendPackage(NetPkg msg)
    {
        return SendPackage(msg);
    }

    public void PostRecvPackage(NetPkg msg)
    {
        if (msg != null && msg.Head != null)
        {
            if (msg.Head.CmdId == NetworkMgr.c_pingCmdAck) return;

            for(int idx = mConfirmQueue.Count -1; idx>=0;idx--)
            {
                var cMsg = mConfirmQueue[idx];
                if(cMsg.Head.SvrPkgSeq == msg.Head.SvrPkgSeq)
                {
                    mConfirmQueue.RemoveAt(idx);
                    break;
                }
            }
        }
    }


    List<NetPkg> mRecvPkgList = new List<NetPkg>();

    public List<NetPkg> RecvPackage()
    {
        if (bConnected && mConnector != null)
        {
            if (mConnector.ReadData(ref mRecvPkgList))
            {
                for (int idx = 0; idx < mRecvPkgList.Count; idx++)
                {
                    NetPkg msg = mRecvPkgList[idx];

                    if (msg.Head.CmdId == NetworkMgr.c_reconnectCmdAck)     //重新登录的消息ID
                    {
                        SendConfirmMsg();
                    }
                }
                return mRecvPkgList;
            }
        }

        return null;
    }
    #endregion

    #region override_base
    public override void DealConnectSucc(enDealConnectStatus status)
    {
        Debug.Log("Lobby connect success");

        StopReconnect();
        mLastSuccessIp = mInitParam.ip;
        mLastSuccessPort = mInitParam.port;

        base.DealConnectSucc(status);
    }


    public override void DealConnectFail()
    {
        if (NetworkMgr.Instance.IsLogin)
            StartReconnect();
        base.DealConnectFail();
    }

    public override void DealConnectClose()
    {
        base.DealConnectClose();
    }

    public override void DealConnectError()
    {
        if(NetworkMgr.Instance.IsLogin)
            StartReconnect();
        base.DealConnectError();
    }
    #endregion
}
