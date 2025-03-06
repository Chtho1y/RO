using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;

public class AroundSphereMove : MonoBehaviour
{
    [SerializeField]
    private Vector3 m_ShakeDir = Vector3.zero;
    [SerializeField]
    private float m_ShakeSpeed = 0f;

    [SerializeField]
    private float m_MoveRadius = 0f;
    [SerializeField]
    private float m_MoveAngleSpeed = 0f;
    [SerializeField]
    private float m_SelfRotateSpeed = 0f;
    [SerializeField]
    private  Quaternion m_OffsetAngle = Quaternion.identity;  //初始角度
    [SerializeField]
    private  float m_SelfScale = 1;                   //初始大小
    [SerializeField]
    private  float m_SelfHeight = 0;                  //初始高度偏移



    public Vector3 shakeDir
    {
        get { return m_ShakeDir; }
        set
        {
            if (m_ShakeDir == value) return;
            m_ShakeDir = value;
        }
    }

    public float shakeSpeed
    {
        get { return m_ShakeSpeed; }
        set
        {
            if (m_ShakeSpeed == value) return;
            m_ShakeSpeed = value;
        }
    }

    public float moveRadius
    {
        get { return m_MoveRadius; }
        set
        {
            if (m_MoveRadius == value) return;
            m_MoveRadius = value;
            m_NeedReset = true;
        }
    }
    public float moveAngleSpeed
    {
        get { return m_MoveAngleSpeed; }
        set
        {
            if (m_MoveAngleSpeed == value) return;
            m_MoveAngleSpeed = value;
        }
    }

    public float selfRotateSpeed
    {
        get { return m_SelfRotateSpeed; }
        set
        {
            if (m_SelfRotateSpeed == value) return;
            m_SelfRotateSpeed = value;
            m_NeedReset = true;
        }
    }

    public float OffsetHeight
    {
        get { return m_SelfHeight; }
        set
        {
            if (m_SelfHeight == value) return;
            m_SelfHeight = value;
        }
    }
    public float Scale
    {
        get { return m_SelfScale; }
        set
        {
            if (m_SelfScale == value) return;
            m_SelfScale = value;
            m_NeedReset = true;
        }
    }
    public Quaternion OffsetAngle
    {
        get { return m_OffsetAngle; }
        set
        {
            if (m_OffsetAngle == value) return;
            m_OffsetAngle = value;
            m_NeedReset = true;
        }
    }

    private bool m_NeedReset = true;                 
    private float m_Angle = 0f;
    private Transform m_Transform;
    private Transform m_ParentTransform;
    private Vector3 m_StartPos;
    private Vector3 m_EndPos;
    private float m_ShakeOffset = 0;
    private int m_ShakeSign = 1;
    private float m_MoveAngleOffset = 0f;

    private void Awake()
    {
        m_Transform = transform;
    }

    private void OnDestroy()
    {
        
    }

    private void Update()
    {
        if (m_NeedReset)
        {
            m_NeedReset = false;
            ResetTransform();
        }

        float deltaTime = Time.deltaTime;
        Vector3 pos = Vector3.zero;
        if (!Mathf.Approximately(m_ShakeSpeed, 0f) && m_ShakeDir != Vector3.zero)
        {
            m_ShakeOffset = m_ShakeOffset + m_ShakeSign * deltaTime * m_ShakeSpeed;
            if (m_ShakeOffset >= 1)
            {
                m_ShakeOffset = 1;
                m_ShakeSign = -m_ShakeSign;
            }
            else if (m_ShakeOffset <= -1)
            {
                m_ShakeOffset = -1;
                m_ShakeSign = -m_ShakeSign;
            }
            pos = Vector3.LerpUnclamped(Vector3.zero, m_ShakeDir, m_ShakeOffset);
        }

        if (m_MoveRadius > 0f && !Mathf.Approximately(m_MoveAngleSpeed, 0f))
        {
            m_MoveAngleOffset = m_MoveAngleOffset + deltaTime * m_MoveAngleSpeed;
            pos = pos + Vector3.SlerpUnclamped(m_StartPos, m_EndPos, m_MoveAngleOffset);
        }

        if (!Mathf.Approximately(m_SelfRotateSpeed, 0))
        {
            m_Angle = m_Angle + deltaTime * m_SelfRotateSpeed;
            m_Transform.rotation = m_OffsetAngle * Quaternion.Euler(0, m_Angle, 0);
        }
        
        if (m_ParentTransform)
            pos = pos + m_ParentTransform.position;
        m_Transform.position = pos + Vector3.up * m_SelfHeight;
    }

    void ResetTransform()
    {
        Vector3 pos = Vector3.zero;
        if (m_MoveRadius > 0)
        {
            Vector3 forward = Vector3.forward;
            m_StartPos = forward * m_MoveRadius;
            m_EndPos = -m_StartPos;
            pos = m_StartPos;
        }
        m_Transform.localScale = Vector3.one * m_SelfScale;
        m_ParentTransform = m_Transform.parent;
        if (m_ParentTransform)
            pos = pos + m_ParentTransform.position;
        m_Transform.position = pos + Vector3.up * m_SelfHeight;
        m_Transform.rotation = m_OffsetAngle;
        m_Angle = 0f;
    }
}