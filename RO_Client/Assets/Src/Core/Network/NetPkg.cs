
using System;
using System.Net;
using UnityEngine;
using System.Diagnostics;
using System.IO;

public class NetPkgHead
{
    private UInt16 mPkgLen;          //包总的大小 = 包头 + 包体
    private UInt16 mCmdId;           //消息ID
    private UInt32 mSvrPkgSeq;      //发送的序列号
    private UInt16 mEncryptFlag = 0;      //加密标志位：0-不加密，1-RSA,2-AES

    public UInt16 PkgLen
    {
        get { return mPkgLen; }
        set { mPkgLen = value; }
    }

    public UInt16 CmdId
    {
        get { return mCmdId; }
        set { mCmdId = value; }
    }

    public UInt32 SvrPkgSeq
    {
        get { return mSvrPkgSeq; }
        set { mSvrPkgSeq = value; }
    }

    public UInt16 EncryptFlag
    {
        get { return mEncryptFlag; }
        set { mEncryptFlag = value; }
    }

    public static UInt16 HeadLength
    {
        get { return sizeof(UInt16) * 3 + sizeof(UInt32); }
    }

    public NetPkgHead()
    {

    }

    public NetPkgHead(int cmdId)
    {
        this.mCmdId = (UInt16)cmdId;
    }

    public CommError.Type pack(ref byte[] buffer, int size, ref int usedSize)
    {
        if (null == buffer || 0 == buffer.GetLength(0) || (size > buffer.GetLength(0)))
        {
            return CommError.Type.COMM_ERR_INVALID_BUFFER_PARAMETER;
        }

        CommWriteBuf destBuf = new CommWriteBuf(ref buffer, size, usedSize);
        CommError.Type ret = pack(ref destBuf);
        if (ret == CommError.Type.COMM_NO_ERROR)
        {
            buffer = destBuf.getBeginPtr();

            usedSize = destBuf.getUsedSize();
        }

        return ret;
    }

    public CommError.Type pack(ref CommWriteBuf destBuf)
    {
        CommError.Type ret = CommError.Type.COMM_NO_ERROR;

        /* pack member: this.pkg_len */
        {
            ret = destBuf.writeUInt16(this.mPkgLen);
            if (CommError.Type.COMM_NO_ERROR != ret)
            {
                return ret;
            }
        }

        /* pack member: this.cmd_id */
        {
            ret = destBuf.writeUInt16(this.mCmdId);
            if (CommError.Type.COMM_NO_ERROR != ret)
            {
                return ret;
            }
        }

        /* pack member: this.mSvrPkgSeq */
        {
            ret = destBuf.writeUInt32(this.mSvrPkgSeq);
            if (CommError.Type.COMM_NO_ERROR != ret)
            {
                return ret;
            }
        }

        /* pack member: this.mEncryptFlag */
        {
            ret = destBuf.writeUInt16(this.mEncryptFlag);
            if (CommError.Type.COMM_NO_ERROR != ret)
            {
                return ret;
            }
        }

        return ret;
    }


    public CommError.Type unpack(ref byte[] buffer, int size, ref int usedSize)
    {
        if (null == buffer || 0 == buffer.GetLength(0) || size > buffer.GetLength(0))
        {
            return CommError.Type.COMM_ERR_INVALID_BUFFER_PARAMETER;
        }

        CommReadBuf srcBuf = new CommReadBuf(ref buffer, size, usedSize);
        CommError.Type ret = unpack(ref srcBuf);

        usedSize = srcBuf.getUsedSize();

        srcBuf = null;

        return ret;
    }

    public CommError.Type unpack(ref CommReadBuf srcBuf)
    {
        CommError.Type ret = CommError.Type.COMM_NO_ERROR;

        /* unpack member: this.pkg_len */
        {
            ret = srcBuf.readUInt16(ref this.mPkgLen);
            if (CommError.Type.COMM_NO_ERROR != ret)
            {
                return ret;
            }
        }

        /* unpack member: this.cmd_id */
        {
            ret = srcBuf.readUInt16(ref this.mCmdId);
            if (CommError.Type.COMM_NO_ERROR != ret)
            {
                return ret;
            }
        }

        /* unpack member: this.mSvrPkgSeq */
        {
            ret = srcBuf.readUInt32(ref this.mSvrPkgSeq);
            if (CommError.Type.COMM_NO_ERROR != ret)
            {
                return ret;
            }
        }

        /* unpack member: this.mEncryptFlag */
        {
            ret = srcBuf.readUInt16(ref this.mEncryptFlag);
            if (CommError.Type.COMM_NO_ERROR != ret)
            {
                return ret;
            }
        }

        return ret;
    }
}

public class NetPkgBody
{
    //包体内容
    private byte[] mMsgData = null;

    public byte[] MsgData
    {
        get { return mMsgData; }
    }

    public NetPkgBody()
    {
        this.mMsgData = null;
    }

    public void CopyBuffData(byte[] buf)
    {
        if (buf == null) return;

        CopyBuffData(buf, (uint)buf.Length);
    }

    public void CopyBuffData(byte[] buf,uint len)
    {
        if (buf == null) return;

        if (mMsgData == null)
        {
            mMsgData = new byte[len];
        }
        else if (mMsgData.Length < len)
        {
            mMsgData = new byte[len];
        }

        Array.Clear(mMsgData, 0, mMsgData.Length);
        Array.Copy(buf, mMsgData, len);
    }

    public void InitMessage(int packLen)
    {
        mMsgData = null;

        mMsgData = new byte[packLen];
    }


    public CommError.Type pack(ref byte[] buffer, int size, ref int usedSize)
    {
        if (null == buffer || 0 == buffer.GetLength(0) || (size > buffer.GetLength(0)))
        {
            return CommError.Type.COMM_ERR_INVALID_BUFFER_PARAMETER;
        }

        int nLen = 0;
        if (mMsgData != null)
        {
            nLen = (int)mMsgData.Length;
        }

        CommWriteBuf destBuf = new CommWriteBuf(ref buffer, size, usedSize);
        CommError.Type ret = pack(ref destBuf, mMsgData, nLen);
        if (ret == CommError.Type.COMM_NO_ERROR)
        {
            buffer = destBuf.getBeginPtr();

            usedSize = destBuf.getUsedSize();
        }
        return ret;
    }

    public CommError.Type pack(ref CommWriteBuf destBuf, byte[] data, int len)
    {
        CommError.Type ret = CommError.Type.COMM_NO_ERROR;

        if(data == null || len == 0)
        {
            return ret;
        }

        /*pack member mMsg data*/
        ret = destBuf.writeByteArrar(data, len);
        if (CommError.Type.COMM_NO_ERROR != ret)
        {
            return ret;
        }

        return ret;
    }

    public CommError.Type unpack(ref byte[] buffer, int size, ref int usedSize)
    {
        if (null == buffer || 0 == buffer.GetLength(0) || size > buffer.GetLength(0))
        {
            return CommError.Type.COMM_ERR_INVALID_BUFFER_PARAMETER;
        }

        if (null == this.mMsgData)
        {
            return CommError.Type.COMM_ERR_USE_HAVE_NOT_INIT_VARIABLE_ARRAY;
        }

        CommReadBuf srcBuf = new CommReadBuf(ref buffer, size, usedSize);
        CommError.Type ret = unpack(ref srcBuf);

        usedSize = srcBuf.getUsedSize();

        srcBuf = null;

        return ret;
    }

    public CommError.Type unpack(ref CommReadBuf srcBuf)
    {
        CommError.Type ret = CommError.Type.COMM_NO_ERROR;

        /* unpack member: this.mMsgData */
        {
            ret = srcBuf.readByteArray(ref this.mMsgData, mMsgData.Length);
            if (CommError.Type.COMM_NO_ERROR != ret)
            {
                return ret;
            }
        }

        return ret;
    }
}

public class NetPkg
{
    /// <summary>
    /// 消息包头
    /// </summary>
    public NetPkgHead Head = null;

    public NetPkgBody Body = null;

    private bool bConfirm = false;
    public bool Confirm
    {
        get { return bConfirm; }
        set { bConfirm = value; }
    }


    /// <summary>
    /// 创建网络发送消息包
    /// </summary>
    /// <param name="cmdId"></param>
    /// <param name="msg"></param>
    /// <returns></returns>
    public static NetPkg CreateNetReqPkg(UInt16 cmdId, byte[] buf)
    {
        NetPkg reqPkg = new NetPkg(cmdId, buf);
        return reqPkg;
    }


    /// <summary>
    /// 创建接收消息包
    /// </summary>
    /// <returns></returns>
    public static NetPkg CreateNetRevPkg()
    {
        NetPkg reqPkg = new NetPkg(0, null);
        return reqPkg;
    }


    protected NetPkg(UInt16 cmdId, byte[] msg)
    {
        if (Head == null && cmdId > 0)
            Head = new NetPkgHead(cmdId);

        if (Body == null)
            Body = new NetPkgBody();
        Body.CopyBuffData(msg);
    }

    /// <summary>
    /// 序列号
    /// </summary>
    /// <param name="buffer"></param>
    /// <param name="size"></param>
    /// <param name="usedSize"></param>
    /// <returns></returns>
    public CommError.Type pack(ref byte[] buffer, int size, ref int usedSize)
    {
        CommError.Type ret = CommError.Type.COMM_NO_ERROR;

        if (Head == null) Head = new NetPkgHead();

        int start = usedSize;
        ret = Head.pack(ref buffer, size, ref usedSize);
        if (ret != CommError.Type.COMM_NO_ERROR) return ret;

        if (null == Body) return CommError.Type.COMM_ERR_ARGUMENT_NULL_EXCEPTION;

        ret = Body.pack(ref buffer, size, ref usedSize);

        if (ret != CommError.Type.COMM_NO_ERROR) return ret;

        int pack_len = usedSize - start - NetPkgHead.HeadLength;       
        Head.PkgLen = (UInt16)pack_len;

        Head.pack(ref buffer, size, ref start);

        return ret;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="buffer"></param>
    /// <param name="size"></param>
    /// <param name="usedSize"></param>
    /// <returns></returns>
    public CommError.Type unpack(ref byte[] buffer, int size, ref int usedSize)
    {
        CommError.Type ret = CommError.Type.COMM_NO_ERROR;

        if (Head == null) Head = new NetPkgHead();

        ret = Head.unpack(ref buffer, size, ref usedSize);
        if (ret != CommError.Type.COMM_NO_ERROR) return ret;

        if (size < Head.PkgLen) return CommError.Type.COMM_ERR_SHORT_BUF_FOR_READ;

        Body.InitMessage((int)Head.PkgLen);
        ret = Body.unpack(ref buffer, size, ref usedSize);
        if (ret != CommError.Type.COMM_NO_ERROR) return ret;

        if(Head.EncryptFlag == NetworkMgr.c_RSA_Encrypt)
        {
            byte[] decryptBuf = SecurityLayer.Instance.RSADecrypt(Body.MsgData);
            Body.CopyBuffData(decryptBuf);
        }
        else if(Head.EncryptFlag == NetworkMgr.c_AES_Encrypt)
        {
            byte[] decryptBuf = SecurityLayer.Instance.AESDecrypt(Body.MsgData);
            Body.CopyBuffData(decryptBuf);
        }
        
        return ret;
    }
}
