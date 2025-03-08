using System;
using System.IO;
using System.Net.Sockets;

class StateObject
{
    public uint CmdId = 0;

    public uint BuffLength = 0;

    public uint BodyLength = 0;

    public byte[] buffer = new byte[Connector.RECV_BUFF_SIZE];


    public MemoryStream stream;

    public MemoryStream swapStream = null;
    //是否收到包体
    public bool ReceiveBody = false;

    public long StreamLength
    {
        get { return stream.Length; }
    }

    public long StreamPosition
    {
        set
        {
            stream.Position = value;
        }
        get
        {
            return stream.Position;
        }
    }

    public StateObject()
    {
        stream = new MemoryStream();
        swapStream = new MemoryStream();
    }

    public void Write(byte[] buffer, int len)
    {
        stream.Seek(0, SeekOrigin.End);
        stream.Write(buffer, 0, len);
        stream.Seek(0, SeekOrigin.Begin);
    }

    public void Read(byte[] bytes, int offset, int count)
    {
        stream.Read(bytes, offset, count);
    }

    public void Reset()
    {
        int remain_len = (int)(stream.Length - stream.Position);

        swapStream.Position = 0;
        swapStream.SetLength(0);

        if (remain_len != 0)
        {
            swapStream.Write(stream.GetBuffer(), (int)stream.Position, remain_len);

            swapStream.Flush();
            swapStream.Seek(0, SeekOrigin.Begin);
        }

        stream.Position = 0;
        stream.SetLength(0);

        swapStream.WriteTo(stream);
        stream.Flush();
        stream.Seek(0, SeekOrigin.Begin);

        CmdId = 0;
        BodyLength = 0;
        BuffLength = 0;
        ReceiveBody = false;
    }

    public void Dispose()
    {
        stream.Dispose();
        stream = null;

        swapStream.Dispose();
        swapStream = null;

        CmdId = 0;
        BodyLength = 0;
        BuffLength = 0;
        ReceiveBody = false;
    }
}
