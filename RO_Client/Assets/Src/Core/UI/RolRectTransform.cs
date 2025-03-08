using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using LuaInterface;

public class RangeSpeed
{
    public float m_fStart;
    public float m_fEnd;

    public float m_fClampStartTime;
    public float m_fClampEndTime;

    public RangeSpeed(float fStart, float fEnd, float fClampStartTime, float fClampEndTime)
    {
        m_fStart = fStart;
        m_fEnd = fEnd;
        m_fClampStartTime = fClampStartTime;
        m_fClampEndTime = fClampEndTime;
    }

    public bool IsConstansTime(float fRunTime)
    {
        if (fRunTime >= m_fClampStartTime)
            return true;
        return false;
    }

    public bool IsOverTime(float fRunTime)
    {
        if (fRunTime > m_fClampEndTime)
            return true;
        return false;
    }

    public float GetV()
    {
        return (m_fEnd + m_fStart) * 0.5f;
    }

    public float GetA()
    {
        return (m_fEnd - m_fStart) / (m_fClampEndTime - m_fClampStartTime);
    }

    public float GetDis(float fTime)
    {
        if (fTime <= m_fClampStartTime)
            return 0;
        float fEndTime = m_fClampEndTime - m_fClampStartTime;
        fTime = fTime - m_fClampStartTime;
        if (fTime >= fEndTime)
            fTime = fEndTime;      
        float fDis = m_fStart * fTime + (0.5f * GetA() * fTime * fTime);
        return fDis;
    }
}

public class RolRectTransform : MonoBehaviour
{
    private float fZAngleSpeed = 0.0f;
    private List<RangeSpeed> mArrayRangeSpeeds = null;
    float fRunTime = 0.0f;
    private float fMaxSpeed = 45;
    private bool IsRun = false;
    private int nStopIndex = 0;
    private int nCurIndex = -1;
    private float fStartAngle = 0;

    
    public System.Action<int> mSelectAction = null;
    public System.Action<int> mFinishAction = null;

    void Start()
    {
        mArrayRangeSpeeds = new List<RangeSpeed>();
    }
   
    void LateUpdate()
    {
        if (IsRun)
        {
            if (fRunTime < 0)
                fRunTime = 0;
            fRunTime += Time.deltaTime;
        }
        else
        {
            fRunTime = -1;
            fZAngleSpeed = 0.0f;
            nCurIndex = -1;
            return;
        }

        float fZangle = 0;
        for (int i = 0; i < mArrayRangeSpeeds.Count; i++)
        {           
            fZangle += mArrayRangeSpeeds[i].GetDis(fRunTime);
        }        
        bool bIsFinished = false;
        if (mArrayRangeSpeeds.Count > 1)
            bIsFinished = mArrayRangeSpeeds[mArrayRangeSpeeds.Count - 1].IsOverTime(fRunTime);

        RectTransform Trans = GetComponent<RectTransform>();
        Trans.localRotation = Quaternion.Euler(0.0f, 0.0f, fStartAngle - fZangle);

        Dispatch();

        if (bIsFinished && IsInArea(nStopIndex))
        {
            IsRun = false;               
            //nStopIndex += 1;
            //nStopIndex = (nStopIndex + 8) % 8;
            DispatchFinished();
        }
    }

    public void SetMaxSpeed(float fAngle)
    {
        fMaxSpeed = fAngle;
    }

    public void ClearNewRangeSpeed()
    {
        mArrayRangeSpeeds.Clear();
    }

    public void AddNewRangeSpeed(float StartSpeed, float EndSpeed, float fStartTime, float fEndTime)
    {
        mArrayRangeSpeeds.Add(new RangeSpeed(StartSpeed, EndSpeed, fStartTime, fEndTime));        
    }

    public void Reset()
    {
        fRunTime = 0.0f;
        fZAngleSpeed = 0.0f;
        nCurIndex = -1;
    }

    public void Run(int nCount)
    {
        IsRun = true;
        Reset();
        CalStopTime();
    }

    public void CalStopTime()
    {
        float fStopAngle = nStopIndex * 360 / 8;
        RectTransform Trans = GetComponent<RectTransform>();
        fStartAngle = Trans.localRotation.eulerAngles.z;

        float fAngle = 0;
        for (int i = 0; i < mArrayRangeSpeeds.Count; i++)
        {
            RangeSpeed RangeSpeed = mArrayRangeSpeeds[i];
            float fA = RangeSpeed.GetDis(RangeSpeed.m_fClampEndTime);
            fAngle += Mathf.Abs(fA);
        }
        float AddAngle = (fAngle - fStartAngle + 360) % 360;
        if (AddAngle > fStopAngle)
        {
            AddAngle = 360 - Mathf.Abs(AddAngle - fStopAngle);
        }
        else
        {
            AddAngle = fStopAngle - AddAngle;
        }
        int LastIndex = mArrayRangeSpeeds.Count - 1;
        RangeSpeed RangeSpeed11 = mArrayRangeSpeeds[LastIndex];
        float fA11 = RangeSpeed11.GetDis(RangeSpeed11.m_fClampEndTime);
        float fAngle11 = Mathf.Abs(fA11);
        float fTime = (fAngle11 + AddAngle) / mArrayRangeSpeeds[LastIndex].GetV();
        mArrayRangeSpeeds[LastIndex].m_fClampEndTime = fTime + mArrayRangeSpeeds[LastIndex].m_fClampStartTime;
    }

    public void Stop()
    {
        if (IsRun)
        {
            IsRun = false;
        }
        fRunTime = -1;
        fZAngleSpeed = 0.0f;
        nCurIndex = -1;
    }

    public void SetAngle(float x, float y, float z)
    {
        //指针指向原点
        RectTransform Trans = GetComponent<RectTransform>();
        Trans.localRotation = Quaternion.Euler(x, y, z);
    }

    public void SetStopIndex(int nIndex)
    {
        nStopIndex = nIndex;
    }

    private void DispatchFinished()
    {
        if (null != mFinishAction)
        {
            mFinishAction(nStopIndex);
        }
    }

    private void Dispatch()
    {
        int nSelectIndex = CheckSelect();
        if (nSelectIndex != nCurIndex && nSelectIndex != -1)
        {
            nCurIndex = nSelectIndex;
            if (null != mSelectAction)
            {
                mSelectAction(nCurIndex);
            }
        }
    }

    private int CheckSelect()
    {
        RectTransform Trans = GetComponent<RectTransform>();
        float fCurAngle = 360.0f - Trans.rotation.eulerAngles.z;

        float fMax = fCurAngle + 45 * 0.5f;
        float fMin = fCurAngle - 45 * 0.5f;

        int nSelect = -1;
        for (int i = 0; i < 8; i++)
        {
            float fAngle = 360.0f / 8 * i;
            if(i == 0)
            {               
                float fAZeroMin = 360 - 45 * 0.5f;
                float fZeroMax = 45 * 0.5f;
                if (fCurAngle >= fAZeroMin || fCurAngle < fZeroMax)
                {
                    nSelect = i;
                    break;
                }                
            }
            if (fAngle < fMax && fAngle >= fMin)
            {
                nSelect = i;
                break;
            }
        }
        return nSelect;
    }

    private bool IsInArea(int nIndex)
    {
        nIndex = nIndex < 0 ? 0 : nIndex;
        nIndex = nIndex > 7 ? 7 : nIndex;
        float fAngle = 360.0f / 8 * nIndex;
        RectTransform Trans = GetComponent<RectTransform>();

        float fMax = fAngle + 45 * 0.5f;
        float fMix = fAngle - 45 * 0.5f;
        
        float fCurAngle = 360.0f - Trans.rotation.eulerAngles.z;

        if(nIndex == 0)
        {
            fMix = 360 - 45 * 0.5f;
            fMax = 45 * 0.5f;
            if (fCurAngle >= fMix || fCurAngle < fMax)
                return true;
            else
                return false;
        }      

        if (fCurAngle <= fMax && fCurAngle > fMix)
                return true;
          
        return false;
    }
}
