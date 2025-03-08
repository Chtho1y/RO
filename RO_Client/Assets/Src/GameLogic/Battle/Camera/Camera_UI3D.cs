using UnityEngine;
using System.Collections;

public class Camera_UI3D : Singleton<Camera_UI3D>
{
    private Camera mCamera;
    private Canvas3D mCanvas;

    public override void Init()
    {
        EventMgr.AddEventListener<bool>(ECoreEventType.EID_BATTLE_SWITCH_MAP, OnSwitchMap);
        EventMgr.AddEventListener<bool>(ECoreEventType.EID_SHOW_BATTLE_SCENE, OnShowBattleScene);
    }

    public override void UnInit()
    {
        base.UnInit();

        EventMgr.RemoveEventListener<bool>(ECoreEventType.EID_BATTLE_SWITCH_MAP, OnSwitchMap);
        EventMgr.RemoveEventListener<bool>(ECoreEventType.EID_SHOW_BATTLE_SCENE, OnShowBattleScene);
    }

    public Camera GetCurrentCamera()
    {
        return mCamera;
    }

    public void SetCameraEnabled(bool enabled)
    {
        if (mCamera != null)
            mCamera.enabled = enabled;
    }

    public Canvas3DImpl GetCurrentCanvas()
    {

        return Canvas3DImpl.GetInstance();
    }

    private void OnSwitchMap(CoreEvent<bool> ce)
    {
        if (mCamera != null)
        {
            GameObject.Destroy(mCamera.gameObject);
            mCamera = null;
        }
    }

    private void OnShowBattleScene(CoreEvent<bool> ce)
    {
        if (mCamera != null)
        {
            mCamera.enabled = ce.Data;
        }
    }

    public void Reset()
    {
        GameObject cameraObj = new GameObject("Camera_UI3D");
        cameraObj.transform.SetParent(BattleCamera.Instance.CamContainer.transform);
        mCamera = cameraObj.AddComponent<Camera>();

        mCamera.CopyFrom(BattleCamera.Instance.RealCamera);

        //mCamera.orthographic = true;

        //mCamera.orthographicSize = 8;

        mCamera.cullingMask = LayerMask.GetMask("3DUI");

        mCamera.depth = mCamera.depth + 1;

        mCamera.clearFlags = CameraClearFlags.Nothing;
        cameraObj.tag = "Untagged";

        mCanvas = cameraObj.AddComponent<Canvas3D>();

        cameraObj.transform.localPosition = new Vector3(8.822f, 4.267f, -6);
        cameraObj.transform.localScale = Vector3.one;
        cameraObj.transform.localRotation = Quaternion.Euler(36.2f,-57,0);
    }

    public void Clear()
    {
        mCamera = null;
        mCanvas = null;
    }
}
