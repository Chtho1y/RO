using UnityEngine;
using System.Collections;

public class Mark
{
    private MarkData mData;
    private Fighter mTarget;

    private bool bStop = false;
    private bool bStarted = false;

    private int mCurLayer = 0;
    private int mTotalFrame = 0;
    private int mLeftFrame = 0;
    private int mEffectInstId = 0;

    public bool Valid { get { return null == mData ? false : mData.Valid; } }

    public int Id { get { return null == mData ? 0 : mData.markId; } }

    public bool Stopped { get { return null == mData ? true : bStop; } }

    public int Layer { get { return mCurLayer; } }

    public Mark(int markId)
    {
        mData = new MarkData(markId);
        if(mData.Valid)
        {
            mTotalFrame = (int)(mData.duration * Constants.frame_to_time);
        }
    }
    
    ~Mark()
    {
        Dispose();
    }

    public SFloat GetFunValue(Buff_Function_Type funType)
    {
        if (mCurLayer == 0) return 0;

        SFloat val = 0;
        if(mData.funList != null)
        {
            for(int idx =0; idx < mData.funList.Count;idx++)
            {
                var fun = mData.funList[idx];
                if(fun.id == (int)funType)
                {
                    val += fun.val + (mCurLayer - 1) * GetFunIncVal(funType);
                }
            }
        }
        return val;
    }

    public SFloat GetFunPercent(Buff_Function_Type funType)
    {
        if (mCurLayer == 0) return 0;

        SFloat val = 0;
        if (mData.funList != null)
        {
            for (int idx = 0; idx < mData.funList.Count; idx++)
            {
                var fun = mData.funList[idx];
                if (fun.id == (int)funType)
                {
                    val += (fun.val * 0.01f) + (mCurLayer - 1) * GetFunIncPercent(funType);
                }
            }
        }
        return val;
    }


    private float GetFunIncVal(Buff_Function_Type funType)
    {
        if (mData.funIncList == null) return 0;

        for(int idx =0; idx < mData.funIncList.Count;idx++)
        {
            if(mData.funIncList[idx].id == (int)funType)
            {
                return mData.funIncList[idx].val;
            }
        }
        return 0;
    }

    private SFloat GetFunIncPercent(Buff_Function_Type funType)
    {
        if (mData.funIncList == null) return 0;

        for (int idx = 0; idx < mData.funIncList.Count; idx++)
        {
            if (mData.funIncList[idx].id == (int)funType)
            {
                return mData.funIncList[idx].val * 0.01f;
            }
        }
        return 0;
    }

    public void AddLayer(Fighter target,int layer)
    {
        mTarget = target;
        mCurLayer += layer;
        if(mCurLayer > mData.maxLayer)
        {
            mCurLayer = mData.maxLayer;
        }

        if(!bStarted)
        {
            Start();
        }
        else
        {
            mLeftFrame = mTotalFrame;
        }
        ShowIcon();
    }

    public void DecLayer(int layer)
    {
        mCurLayer -= layer;
        if(mCurLayer < 0)
        {
            mCurLayer = 0;
        }
        if(mCurLayer == 0)
        {
            Stop();
        }else
        {
            ShowIcon();
        }
    }

    private void ShowIcon()
    {
        if (!string.IsNullOrEmpty(mData.markIcon))
        {
            int layer = mData.maxLayer == 1 ? 0 : mCurLayer;
            if(mData.IsShow(MarkData.EnShowType.En_ShowBattle))
                mTarget.ShowBuffIcon(mData.markIcon, layer);
        }
    }

    public void Update(float deltaTime)
    {
        if (!bStarted) return;

        mLeftFrame -= 1;
        if(mLeftFrame <= 0)
        {
            Stop();
        }
    }

    public void  Start()
    {
        bStarted = true;
        bStop = false;
        mLeftFrame = mTotalFrame;
        if(mData.effectId > 0)
        {
            mEffectInstId = EffectManager.Instance.PlayEffect(mData.effectId, mTarget, mTarget);
        }
    }

    public void Stop()
    {
        if (mData != null && !string.IsNullOrEmpty(mData.markIcon))
        {
            if (mData.IsShow(MarkData.EnShowType.En_ShowBattle))
                mTarget.RemoveBuffIcon(mData.markIcon);
        }

        if (mEffectInstId > 0)
        {
            EffectManager.Instance.RemoveEffectByInstanceID(mEffectInstId);
            mEffectInstId = 0;
        }
        bStarted = false;
        bStop = true;
    }

    public void Dispose()
    {
        mData = null;
        mTarget = null;
    }
}
