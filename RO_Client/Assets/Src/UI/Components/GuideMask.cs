using LuaInterface;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[ExecuteInEditMode]
public class GuideMask : MonoBehaviour
{
    public bool startMask = false;
    public float defaultDiameter = 10000;
    public float maskTime = .3f;
    public Transform target;
    public Camera camera;

    private Vector4 center;
    private Material material;
    private Vector2 rectSize;
    private Vector2 curSize = Vector2.zero;
    private Vector2 tmpSize;
    private float curHeight = 0f;
    private float curTime = 0;
    bool isClose = false;

    Image image;

    RectTransform maskRect;
    LuaTable guideView;
    LuaFunction maskCompeletedCB;

    void Awake()
    {
        QualitySettings.vSyncCount = 0;
        Application.targetFrameRate = 60;

        image = GetComponent<Image>();

        material = Object.Instantiate(image.material);
        image.material = material;
    }

    private void OnDestroy()
    {
        GameObject.Destroy(material);
        material = null;
    }

    public void Init(LuaTable view, LuaFunction callback, RectTransform mask)
    {
        if (camera == null)
        {
            camera = CameraMgr.Instance.UICamera;
        }

        guideView = view;
        maskCompeletedCB = callback;
        maskRect = mask;
    }

    public void SetDefaultState(bool defaultState)
    {
        material.SetInt("_DefaultState", defaultState ? 1 : 0);
    }

    public void SetTargetInfoClose(Vector3 worldPos, Vector2 size, float maskTime)
    {
        isClose = true;

        this.maskTime = maskTime;
        rectSize = size * 0.5f;

        Vector3 position = camera.WorldToScreenPoint(worldPos);
        position = camera.ScreenToViewportPoint(position);
        position.x = (position.x - .5f) * UIMgr.SCREEN_WIDTH;
        position.y = (position.y - .5f) * UIMgr.SCREEN_HEIGHT;

        center = new Vector4(position.x, position.y, 0f, 0f);
        material.SetVector("_Center", center);

        curSize.x = defaultDiameter;
        curSize.y = defaultDiameter;
        material.SetVector("_RectSize", curSize);

        material.SetInt("_IsClose", isClose ? 1 :0);

        material.SetInt("_DefaultState", 0);

        image.SetMaterialDirty();

        curTime = 0;
        startMask = true;
    }

    public void SetTargetInfoOpen(Vector3 worldPos, Vector2 size, float maskTime)
    {
        isClose = false;

        this.maskTime = maskTime;
        rectSize = size*0.5f;

        Vector3 position = camera.WorldToScreenPoint(worldPos);
        position = camera.ScreenToViewportPoint(position);
        position.x = (position.x - .5f) * UIMgr.SCREEN_WIDTH;
        position.y = (position.y - .5f) * UIMgr.SCREEN_HEIGHT;

        center = new Vector4(position.x, position.y, 0f, 0f);
        material.SetVector("_Center", center);

        curSize = rectSize;
        material.SetVector("_RectSize", curSize);

        material.SetInt("_IsClose", isClose ? 1 : 0);

        material.SetInt("_DefaultState", 0);

        image.SetMaterialDirty();

        curTime = 0;
        startMask = true;
    }

    void Update()
    {
        if (!startMask) return;

        curTime += Time.deltaTime;
        float process = (float)curTime / maskTime;

        tmpSize.x = isClose ? Mathf.Lerp(curSize.x, rectSize.x, process) : Mathf.Lerp(curSize.x, defaultDiameter, process);
        tmpSize.y = isClose ? Mathf.Lerp(curSize.y, rectSize.y, process) : Mathf.Lerp(curSize.y, defaultDiameter, process);

        if (maskRect)
        {
            maskRect.sizeDelta = tmpSize;
        }

        material.SetVector("_RectSize", tmpSize);

        image.SetMaterialDirty();

        if (process >= 1 && startMask)
        {
            startMask = false;
            if (maskCompeletedCB != null)
            {
                if (guideView != null)
                    maskCompeletedCB.Call(guideView, isClose);
                else
                    maskCompeletedCB.Call(isClose);
            }
        }
    }

    public void Dispose()
    {
        guideView = null;
        maskCompeletedCB = null;
        maskRect = null;
    }
}