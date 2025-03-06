using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class CustomWater : MonoBehaviour
{
    private Camera mCam;
    public Camera Cam
    {
        get
        {
            if (mCam == null)
            {
                mCam = Camera.main;
            }
            return mCam;
        }
    }

    private void OnEnable()
    {
        if (Cam != null)
        {
            Cam.depthTextureMode |= DepthTextureMode.Depth;
        }
    }

    private void OnDisable()
    {
        if (Cam != null)
        {
            Cam.depthTextureMode &= ~DepthTextureMode.Depth;
        }
    }
}
