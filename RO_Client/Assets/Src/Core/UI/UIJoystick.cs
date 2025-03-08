using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;

public class UIJoystick : UIBehaviour
{
    public class OnDragEvent : UnityEvent<Vector2, int> { }

    public Canvas canvas;
    public RectTransform scaleTrans;


    public float maxLenght = 500;
    public float walkToRunLength = 200;

    private GameObject m_ScaleGo;
    private bool m_LastVaildPointer = false;
    private bool m_VaildPointer = false;
    private Vector2 m_StartPos;
    private Vector2 m_EndPos;

    private OnDragEvent m_OnDragEvent = new OnDragEvent();

    public OnDragEvent onDragEvent
    {
        get { return m_OnDragEvent; }
    }

    protected override void Awake()
    {
        base.Awake();
        m_ScaleGo = scaleTrans.gameObject;
        m_ScaleGo.SetActive(false);
    }


    private void Update()
    {

#if !UNITY_EDITOR && (UNITY_ANDROID || UNITY_IOS)
        CalcTouchDeltaPos();
#else
        if (!CalcMouseDeltaPos())
            CalcKeyboardDeltaPos();
#endif

        if (m_LastVaildPointer != m_VaildPointer)
        {
            if (m_LastVaildPointer)
            {
                m_OnDragEvent.Invoke(Vector2.zero, 0);
            }
            m_ScaleGo.SetActive(m_VaildPointer);
            m_LastVaildPointer = m_VaildPointer;
        }

        if (!m_VaildPointer) return;

        var startPos = m_StartPos;
        var endPos = m_EndPos;
        RectTransformUtility.ScreenPointToLocalPointInRectangle((RectTransform)this.transform, m_StartPos, canvas.worldCamera, out startPos);
        RectTransformUtility.ScreenPointToLocalPointInRectangle((RectTransform)this.transform, m_EndPos, canvas.worldCamera, out endPos);

        var normal = endPos - startPos;
        float length = normal.magnitude;
        normal.Normalize();
        if (length > maxLenght)
        {
            length = maxLenght;
            endPos = startPos + normal * length;
            // startPos = endPos - normal * length;
            // m_StartPos = RectTransformUtility.WorldToScreenPoint(canvas.worldCamera, this.transform.TransformPoint(startPos));
        }

        scaleTrans.localPosition = startPos;
        scaleTrans.localRotation = Quaternion.FromToRotation(Vector3.up, normal);
        scaleTrans.SetSizeWithCurrentAnchors(RectTransform.Axis.Vertical, length);

        if (length <= Vector2.kEpsilon)
        {
            m_OnDragEvent.Invoke(normal, 0);
        }
        else
        {
            m_OnDragEvent.Invoke(normal, (length < walkToRunLength ? 1 : 2));
        }
    }

#if !UNITY_EDITOR && (UNITY_ANDROID || UNITY_IOS)
    private void CalcTouchDeltaPos()
    {
        if (Input.touchCount <= 0)
        {
            m_VaildPointer = false;
            return;
        }
        var touch = Input.GetTouch(0);
        if (touch.phase == TouchPhase.Began)
        {
            if (!EventSystem.current ||!EventSystem.current.IsPointerOverGameObject(touch.fingerId))
            {
                m_VaildPointer = true;
                m_StartPos = m_EndPos = touch.rawPosition;
            }
            return;
        }
        if (!m_VaildPointer)
        {
            return;
        }
        if (touch.phase == TouchPhase.Moved || touch.phase == TouchPhase.Stationary)
        {
            m_EndPos =  touch.position;
        }
        else
        {
            m_VaildPointer = false;
            m_StartPos = m_EndPos = Vector2.zero;
        }
    }
#else
    private bool CalcMouseDeltaPos()
    {
        if (Input.GetMouseButtonDown(0))
        {
            if (!EventSystem.current || !EventSystem.current.IsPointerOverGameObject())
            {
                m_StartPos = m_EndPos = Input.mousePosition;
                m_VaildPointer = true;
                return true;
            }
            return false;
        }
        if (!m_VaildPointer)
        {
            return false;
        }
        if (Input.GetMouseButtonUp(0))
        {
            m_VaildPointer = false;
            m_StartPos = m_EndPos = Vector2.zero;
            return true;
        }
        if (Input.GetMouseButton(0))
        {
            m_EndPos = Input.mousePosition;
            return true;
        }
        return false;
    }

    private void CalcKeyboardDeltaPos()
    {
        float horizontal = Input.GetAxis("Horizontal");
        float vertical = Input.GetAxis("Vertical");
        if (Mathf.Approximately(horizontal, 0) && Mathf.Approximately(vertical, 0))
        {
            m_VaildPointer = false;
            m_StartPos = m_EndPos = Vector2.zero;
            return;
        }
        m_VaildPointer = true;
        m_StartPos = new Vector2(Screen.width * 0.5f, Screen.height * 0.5f);
        m_EndPos = m_StartPos + new Vector2(horizontal, vertical) * maxLenght;
    }
#endif
}
