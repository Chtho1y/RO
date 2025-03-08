using UnityEngine;
using System.Runtime.InteropServices;

public enum eNetType
{
    NetType_None = 0,       //没有联网
    NetType_4G = 1,         //4G网络状态
    NetType_WIFI = 2,       //WIFI状态
    NetType_Other = 3,     //其他网络状态
}

public class DeviceInfo
{
    public enum eDeviceState
    {
        BAD_DEVICE = 1,         //性能差的设备
        NORMAL_DEVICE = 2,      //性能一般的设备
        GOOD_DEVICE = 3         //性能好的设备
    }

    /// <summary>
    /// 设备性能状态
    /// </summary>
    public static eDeviceState m_DeviceState = eDeviceState.GOOD_DEVICE;

    /// <summary>
    /// 设备内存大小
    /// </summary>
    public static int m_DeviceMem = 0;

    /// <summary>
    /// CPU类型
    /// </summary>
    public static string m_CpuType = "";

    //显卡型号
    public static string m_GraphicType = "";

    public static string m_deviceId = "";

    static int m_OrgBrightness = 0;

    /// <summary>
    /// 当前屏幕亮度
    /// </summary>
    static int m_CurrentBrightness = 100;

    /// <summary>
    /// 设备详细信息
    /// </summary>
    public static string s_DeviceDetailStr = "";


    /// <summary>
    /// 判断是否为好设备
    /// </summary>
    public static bool IsGoodDevice
    {
        get { return m_DeviceState == eDeviceState.GOOD_DEVICE; }
    }

    /// <summary>
    /// 获取网络状态: 0: 表示没有联网; 1:表示当前为WIFI状态；2：表示状态为2G状态； 3：表示当前为3G状态
    /// </summary>
    /// <returns></returns>
    public static eNetType GetNetType()
    {
        eNetType netType = (eNetType)Application.internetReachability;
        return netType;
    }


    /// <summary>
    /// 获取设备信息并按照信息进行设备级别划分
    /// 低端机配置：内存 2G， 显存：512M
    /// 中端机配置: 内存 3G， 显存：1G
    /// 高端机配置: 内存大于3G， 显存大于1G
    /// </summary>
    public static void GetDeviceState()
    {
        string m_DeviceName = SystemInfo.deviceModel;
        string m_GraphicName = SystemInfo.graphicsDeviceName;
        int m_DeviceVMem = SystemInfo.graphicsMemorySize;
        m_DeviceMem = SystemInfo.systemMemorySize;
        m_deviceId = SystemInfo.deviceUniqueIdentifier;


        s_DeviceDetailStr = string.Format("设备信息: Name={0}, 显卡={1}, 内存={2}M, 显存={3}M, 分辨率={4} * {5}",
                        m_deviceId,
                        m_GraphicName,
                        m_DeviceMem,
                        m_DeviceVMem,
                        Screen.width,
                        Screen.height);
        Debug.Log(s_DeviceDetailStr);

        string deviceInfo = string.Format("supportsComputeShaders = {0},supportsInstancing={1},supports32bitsIndexBuffer ={2},supportedRenderTargetCount ={3},supportsMultisampledTextures={4}, maxTextureSize={5},supportsVertexPrograms={6}"
                                         ,SystemInfo.supportsComputeShaders
                                         ,SystemInfo.supportsInstancing
                                         ,SystemInfo.supports32bitsIndexBuffer
                                         ,SystemInfo.supportedRenderTargetCount
                                         ,SystemInfo.supportsMultisampledTextures
                                         ,SystemInfo.maxTextureSize
                                         ,SystemInfo.supportsVertexPrograms);

        Debug.Log(deviceInfo);
#if UNITY_ANDROID && !UNITY_EDITOR
        //根据设备信息进行分类
        if(m_DeviceMem>=4000 && m_DeviceVMem>=1024)
        {
            m_DeviceState = eDeviceState.GOOD_DEVICE;
        }else if(m_DeviceMem>=3000 && m_DeviceVMem>512)
        {
            m_DeviceState = eDeviceState.NORMAL_DEVICE;
        }else
        {
            m_DeviceState = eDeviceState.BAD_DEVICE;
        }

        if(m_DeviceState != eDeviceState.BAD_DEVICE)
        {
            int graphicLevel = 0;       //0:底，1中，2高
            if (m_GraphicName.Contains("Mali"))
            {
                if (m_GraphicName.Contains("Mali-G"))
                {
                    string versionStr = m_GraphicName.Replace("Mali-G", "");
                    if (!string.IsNullOrEmpty(versionStr))
                    {
                        int ver = 0;
                        if (int.TryParse(versionStr, out ver))
                        {
                            if (ver <= 51)
                            {
                                graphicLevel = 0;
                            }
                            else if (ver <= 71)
                            {
                                graphicLevel = 1;
                            }
                            else
                            {
                                graphicLevel = 2;
                            }
                        }
                        else
                        {
                            graphicLevel = -1;
                        }
                    }
                }
                else if (m_GraphicName.Contains("Mali-T"))
                {
                    string versionStr = m_GraphicName.Replace("Mali-T", "");
                    if (!string.IsNullOrEmpty(versionStr))
                    {
                        int ver = 0;
                        if (int.TryParse(versionStr, out ver))
                        {
                            if (ver <= 760)
                            {
                                graphicLevel = 0;
                            }
                            else if (ver <= 880)
                            {
                                graphicLevel = 1;
                            }
                            else
                            {
                                graphicLevel = 2;
                            }
                        }
                        else
                        {
                            graphicLevel = -1;
                        }
                    }
                }
            }
            else if (m_GraphicName.Contains("Adreno"))
            {
                string versionStr = m_GraphicName.Replace("Adreno (TM) ", "");
                if (!string.IsNullOrEmpty(versionStr))
                {
                    int ver = 0;
                    if (int.TryParse(versionStr, out ver))
                    {
                        if (ver <= 506)
                        {
                            graphicLevel = 0;
                        }
                        else if (ver <= 610)
                        {
                            graphicLevel = 1;
                        }
                        else
                        {
                            graphicLevel = 2;
                        }
                    }
                    else
                    {
                        graphicLevel = -1;
                    }
                }
            }

            if (graphicLevel == 0)
            {
                m_DeviceState = DeviceInfo.eDeviceState.BAD_DEVICE;
            }else if(graphicLevel == 1)
            {
                m_DeviceState = DeviceInfo.eDeviceState.NORMAL_DEVICE;
            }
        }

        if (DeviceInfo.m_DeviceState == DeviceInfo.eDeviceState.BAD_DEVICE
            || DeviceInfo.m_DeviceState == DeviceInfo.eDeviceState.NORMAL_DEVICE)
        {
            float ratio = 0.7f;
            if(Screen.width > 1080)
            {
                ratio = 0.5f;
            }
            int wid = (int)(Screen.width * ratio);
            int hei = (int)(Screen.height * ratio);
            int newW = 0,newH;
            FindNearestResolution(wid,hei,out newW,out newH);

            Screen.SetResolution(newW, newH, true);
            Debug.LogError("newW:" + newW + " newH:" + newH);
        }
#elif UNITY_IOS && !UNITY_EDITOR
        UnityEngine.iOS.DeviceGeneration iosGen = UnityEngine.iOS.Device.generation;
        if (iosGen >= UnityEngine.iOS.DeviceGeneration.iPhoneXS || 
            iosGen == UnityEngine.iOS.DeviceGeneration.iPad5Gen)
            DeviceInfo.m_DeviceState = DeviceInfo.eDeviceState.GOOD_DEVICE;
        else if (iosGen == UnityEngine.iOS.DeviceGeneration.iPhone7Plus || 
                iosGen == UnityEngine.iOS.DeviceGeneration.iPhone8Plus ||
                iosGen == UnityEngine.iOS.DeviceGeneration.iPhone8Plus ||
                iosGen == UnityEngine.iOS.DeviceGeneration.iPadPro10Inch2Gen)
            DeviceInfo.m_DeviceState = DeviceInfo.eDeviceState.NORMAL_DEVICE;
        else
            DeviceInfo.m_DeviceState = DeviceInfo.eDeviceState.BAD_DEVICE;
        if (DeviceInfo.m_DeviceState == DeviceInfo.eDeviceState.BAD_DEVICE
            || DeviceInfo.m_DeviceState == DeviceInfo.eDeviceState.NORMAL_DEVICE)
        {
            float ratio = 0.7f;
            if(Screen.width > 1080)
            {
                ratio = 0.5f;
            }
            int wid = (int)(Screen.width * ratio);
            int hei = (int)(Screen.height * ratio);
            int newW = 0,newH;
            FindNearestResolution(wid,hei,out newW,out newH);
            Screen.SetResolution(newW, newH, true);
            Debug.LogError("newW:" + newW + " newH:" + newH);
        }
#endif
        m_CurrentBrightness = m_OrgBrightness = GetBrightness();
    }

    public static void FindNearestResolution(int wid,int hei, out int oWid, out int oHei)
    {
        oWid = wid;
        oHei = hei;

        for (int idx=0; idx < Screen.resolutions.Length;idx++)
        {
            Resolution res = Screen.resolutions[idx];
            if(hei >= res.height)
            {
                oWid = res.width;
                oHei = res.height;
            }
        }
    }

    /// <summary>
    /// 还原为原始的屏幕亮度
    /// </summary>
    public static void RestoreBrightness()
    {
        SetBrightness(m_OrgBrightness);
    }

    /// <summary>
    /// 使屏幕变暗
    /// </summary>
    public static bool Dimming()
    {
        if (m_OrgBrightness <= 30)
            return false;

        SetBrightness(30);
        return true;
    }

    /// <summary>
    /// 设置屏幕亮度值：数值[0~100]
    /// </summary>
    /// <param name="val">屏幕亮度数值</param>
    static void SetBrightness(int val)
    {
        return;
    }

    /// <summary>
    /// 获取屏幕当前亮度
    /// </summary>
    /// <returns></returns>
    static int GetBrightness()
    {
		return 100;
    }

}
