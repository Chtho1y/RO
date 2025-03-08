using UnityEngine;
using System.Collections.Generic;

public class FighterBuffManager
{
	Fighter mFighter;
	readonly List<BattleBuff> mBuffList;
    public List<BattleBuff> BuffList { get { return mBuffList; } }

    public FighterBuffManager (Fighter fighter)
	{
		mFighter = fighter;
		mBuffList = new List<BattleBuff> ();
	}

    public BattleBuff AddBuff(BaseSkill skill, BuffData buffData)
    {
        if (buffData == null) return null;

        //if (skill != null)
        //{
        //    float rate = skill.GetBuffRate(buffData);
        //    if (rate < 1 && mBattle.RandomValue(true) > rate)
        //        return;
        //}

        //同一帧中不能叠加同样的buff
        BattleBuff buff = GetBuff(buffData.buffID);
        if (buff != null && buff.CastFrameCnt == Time.frameCount) return null;

        BattleBuff newBuff = new BattleBuff(buffData, mFighter,skill);
        newBuff.Start();
        mBuffList.Add(newBuff);
        return newBuff;
    }

    public BattleBuff GetBuff(int buffId)
    {
        for(int idx =0; idx < mBuffList.Count;idx++)
        {
            if (mBuffList[idx].BuffId == buffId) return mBuffList[idx];
        }
        return null;
    }

    public bool HasEnhanceBuff()
    {
        if (mBuffList == null) return false;

        for(int idx = mBuffList.Count -1; idx>=0;idx--)
        {
            if (mBuffList[idx].IsEnhance) return true;
        }

        return false;
    }


    public void Update (float deltaTime)
	{
        for (int i = mBuffList.Count - 1; i >= 0; i--)
        {
            mBuffList[i].Update(deltaTime);
        }

		for (int i = mBuffList.Count - 1; i >= 0; i--)
        { 
			if (mBuffList [i].HasBeenStop) {
				mBuffList.RemoveAt (i);
			}
        }
	}

	public void OnFightingEnd ()
	{
        Clear();
    }

	public void Clear ()
	{
		for (int i = mBuffList.Count - 1; i >= 0; i--)
			mBuffList [i].Stop ();
	}

	public void Dispose()
	{
		Clear ();
		mFighter = null;
	}
}

