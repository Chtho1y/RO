using UnityEngine;
using System.Collections;

public class EffectQuality : MonoBehaviour
{
    public bool isLowQuality = false;
    public bool isMiddleQuality = false;

    private void Awake()
    {
        if(!isMiddleQuality && DeviceInfo.m_DeviceState!=DeviceInfo.eDeviceState.GOOD_DEVICE)
        {
            GameObject.Destroy(this.gameObject);
        }else if(!isLowQuality && DeviceInfo.m_DeviceState == DeviceInfo.eDeviceState.BAD_DEVICE)
        {
            GameObject.Destroy(this.gameObject);
        }
    }
}
