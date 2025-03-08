using UnityEngine;
using System.Collections;

public class CameraMgr : SingletonMono<CameraMgr>
{
    private GameObject UICameraGo;
    private Camera mUICamera;
    public Camera UICamera
    {
        get { return mUICamera; }
    }

    public Camera mainCamera = null;

    private bool bInited = false;

    public override void InitMgr()
    {
        base.InitMgr();

        if (bInited) return;

        UICameraGo = GameObject.Find("UICamera");
        DontDestroyOnLoad(UICameraGo);
        mUICamera = UICameraGo.GetComponent<Camera>();

        bInited = true;
        EventMgr.DispatchEvent(new CoreEvent<int>(ECoreEventType.EID_CameraMgrInited, 1));
    }

    protected override void Dispose()
    {
        base.Dispose();
    }
}
