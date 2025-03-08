using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class MarkMgr
{
    Fighter mFighter;
    List<Mark> mMarkList;

    public List<Mark> MarkList
    {
        get { return mMarkList; }
    }

    public MarkMgr(Fighter f)
    {
        mFighter = f;
        mMarkList = new List<Mark>();
    }

    public SFloat GetFunValue(Buff_Function_Type funType)
    {
        if (mMarkList == null) return 0;

        SFloat totalVal = 0;
        for(int idx =0; idx < mMarkList.Count;idx++)
        {
            totalVal += mMarkList[idx].GetFunValue(funType);
        }

        return totalVal;
    }

    public SFloat GetFunPercent(Buff_Function_Type funType)
    {
        if (mMarkList == null) return 0;

        SFloat totalVal = 0;
        for (int idx = 0; idx < mMarkList.Count; idx++)
        {
            totalVal += mMarkList[idx].GetFunPercent(funType);
        }

        return totalVal;
    }

    public Mark AddMark(int markId,int layer)
    {
        Mark mark = GetMark(markId);
        if(mark == null)
        {
            mark = new Mark(markId);
            mMarkList.Add(mark);
        }
        mark.AddLayer(mFighter, layer);
        return mark;
    }

    public void ClearMark(int markId, int layer)
    {
        Mark mark = GetMark(markId);
        if(mark != null)
        {
            mark.DecLayer(layer);
        }
    }

    public Mark GetMark(int markId)
    {
        for(int idx =0; idx < mMarkList.Count;idx++)
        {
            if(mMarkList[idx].Id == markId)
            {
                return mMarkList[idx];
            }
        }

        return null;
    }

    public bool HasMark(int markId)
    {
        Mark mark = GetMark(markId);
        return mark != null && !mark.Stopped;
    }

    public bool HasNLayerMark(int markId,int layer)
    {
        Mark mark = GetMark(markId);
        return mark != null && !mark.Stopped && mark.Layer >= layer;
    }

    public void Update(float deltaTime)
    {
        for(int idx = mMarkList.Count - 1; idx >= 0; idx--)
        {
            mMarkList[idx].Update(deltaTime);
        }

        for(int idx = mMarkList.Count - 1; idx >= 0; idx--)
        {
            if(mMarkList[idx].Stopped)
            {
                mMarkList.RemoveAt(idx);
            }
        }
    }

    public void Clear()
    {
        for (int idx = mMarkList.Count - 1; idx >= 0; idx--)
            mMarkList[idx].Stop();

        mMarkList.Clear();
    }

    public void Dispose()
    {
        Clear();
        mFighter = null;
    }

    public void OnFightingEnd()
    {
        Clear();
    }
}
