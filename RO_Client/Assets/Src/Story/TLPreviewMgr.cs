using System.Collections.Generic;

public class TLPreviewMgr:SingletonMono<TLPreviewMgr>
{
    public int previewStoryId;

    public List<PreviewNpcActor> previewNpcActorsList;
    public List<PreviewNpcActor> previewHeroActorsList;

    private void Start()
    {
        RegisterEvents();

        MusicMgr.Instance.InitMgr();
        AssetsMgr.Instance.InitMgr();
        ConfigMgr.CreateInstance();

        TimelineManager.Instance.InitMgr();
    }

    private void Update()
    {
        ResourceMgr.Instance.Update();
    }

    protected override void Dispose()
    {
        base.Dispose();
        UnRegisterEvents();
    }

    void OnConfigMgrInited(CoreEvent<int> ce)
    {
        int result = ce.Data;
        if (result == 1)
        {
            UIMgr.Instance.InitMgr();
            ModelMgr.Instance.InitMgr();
            ActorMgr.Instance.InitMgr();
            StoryMgr.Instance.InitMgr();
            CameraMgr.Instance.InitMgr();
        }
        else
        {
            DebugHelper.LogError("加载配置文件出错,请check!!!");
        }
    }

    void OnCameraMgrInited(CoreEvent<int> ce)
    {
        int result = ce.Data;
        if (result == 1)
        {
            
        }
        else
        {
            DebugHelper.LogError("Camera 初始化失败，请check!!!");
        }
    }

    private void RegisterEvents()
    {
        EventMgr.AddEventListener<int>(ECoreEventType.EID_CameraMgrInited, OnCameraMgrInited);
        EventMgr.AddEventListener<int>(ECoreEventType.EID_ConfigMgrInit, OnConfigMgrInited);
    }

    private void UnRegisterEvents()
    {
        EventMgr.RemoveEventListener<int>(ECoreEventType.EID_CameraMgrInited, OnCameraMgrInited);
        EventMgr.RemoveEventListener<int>(ECoreEventType.EID_ConfigMgrInit, OnConfigMgrInited);
    }

    public void StartTest()
    {
        ActorMgr.Instance.previewHeroActorsList = previewHeroActorsList;
        ActorMgr.Instance.previewNpcActorsList = previewNpcActorsList;

        StoryMgr.Instance.StartStory(previewStoryId);
    }
}