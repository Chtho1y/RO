using UnityEngine;
using System.Collections.Generic;


/// <summary>
/// PreDownload集成入原游戏的进度条加载
/// </summary>
public class PreDownProcessManager : Singleton<PreDownProcessManager>
{
    private bool mIsLoading = false;
	public bool IsLoading { get { return mIsLoading; } }

    private float m_webRequestProcess = 0.0f;  //是否关闭 进度条功能

    public float fWebReqProcess
    {
        get { return m_webRequestProcess; }
        set
        {
            if (m_webRequestProcess == value) return;
            m_webRequestProcess = value;
        }
    }
    public override void Init()
    {
        base.Init();
    }

    public override void UnInit()
    {
        base.UnInit();
    }
 
    public void StartLoad(string sceneName = "")
    {
        mIsLoading = true;
    }

    //清理数据
	public void Clear ()
	{
        mIsLoading = false;
    }

    public void updateLoadStatus()
    {
        if(mIsLoading)
        {
            float loadingProgress = 0.2f * m_webRequestProcess;
            if (m_webRequestProcess >= 1.0f)
                return;
            EventMgr.DispatchEvent<float>(new CoreEvent<float>(ECoreEventType.EID_LOAD_PROGRESS, loadingProgress));

        }
    }
}
