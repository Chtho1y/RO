using System;
using System.Net.Sockets;

public interface ISocketHandler
{
    /// <summary>
    /// socket连接
    /// </summary>
    void OnConnect();

    /// <summary>
    /// 重新连接
    /// </summary>
    void OnReconnect();

    /// <summary>
    /// 断开连接
    /// </summary>
    void OnDisconnect();

    /// <summary>
    /// 连接超时
    /// </summary>
    void OnTimeout();

    /// <summary>
    /// 连接失败
    /// </summary>
    void OnConnectFailed();


    void OnError();

    void OnException(SocketException se);
}
