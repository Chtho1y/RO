using System.Collections.Generic;

public delegate void DelayTriggeredCallback<T> (T val);

public class FrameDelayInfo<T>
{
	public T mValue;
	public int mFrame;

	public FrameDelayInfo (T val, int frame)
	{
		mValue = val;
		mFrame = frame;
	}
}

public class TimeDelayInfo<T>
{
	public T mValue;
	public float mTime;
    public int nSeq;

	public TimeDelayInfo (T val, float time,int seq)
	{
		mValue = val;
		mTime = time;
        nSeq = seq;
    }
}

public class FrameDelayManager<T>
{
	List<FrameDelayInfo<T>> mList;
	DelayTriggeredCallback<T> mCallback;

	public FrameDelayManager (DelayTriggeredCallback<T> cb)
	{
		mList = new List<FrameDelayInfo<T>> ();
		mCallback = cb;
	}

	public void Update ()
	{
		for (int i = mList.Count - 1; i >= 0; i--) {
			mList [i].mFrame--;
			if (mList [i].mFrame <= 0) {				
				mCallback (mList [i].mValue);
				mList.RemoveAt (i);
			}
		}
	}

	public void Add (T val, int delayFrame)
	{
		if (delayFrame <= 0)
			mCallback (val);
		else
			mList.Insert (0, new FrameDelayInfo<T> (val, delayFrame));
	}

	public void Clear ()
	{
		mList.Clear ();
	}
}

public class TimeDelayManager<T>
{
	List<TimeDelayInfo<T>> mList;
	DelayTriggeredCallback<T> mCallback;

    public TimeDelayManager (DelayTriggeredCallback<T> cb)
	{
		mList = new List<TimeDelayInfo<T>> ();
		mCallback = cb;
	}

    public void Update (float deltaTime)
	{
		for (int i = mList.Count - 1; i >= 0; i--) {
			mList [i].mTime -= deltaTime;
			if (mList [i].mTime <= 0) {				
				mCallback (mList [i].mValue);
				mList.RemoveAt (i);
			}
		}
	}

	public void Add (T val, float delayTime)
	{
		if (delayTime <= 0)
			mCallback (val);
		else
			mList.Insert (0, new TimeDelayInfo<T> (val, delayTime, mList.Count+1));
	}

	public void Clear ()
	{
		mList.Clear ();
	}
}