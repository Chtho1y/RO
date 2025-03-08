using LuaInterface;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.UI;

public enum StoryCMType
{
    Model,
    Left,
    Right,
}
public class SimpleStoryModule
{
    public List<IPlayableAssetDeal> storyPAs;
    public int endTime;
    public Action<SimpleStoryModule> OverEvent;
    public bool isOver;
}

public delegate void OnCurTimelineOver();

public class StoryMgr : SingletonMono<StoryMgr>
{
    private Camera LeftCM;
    private Camera RightCM;
    private Camera VideoCM;
    private TimelineMap curTLMap;

    private GameObject UIRoot;

    private GameObject LeftRTGo;
    private GameObject RightRTGo;
    private Text talkText;
    private Toggle toggleBtn;

    public string ModelLayerName = "Model";
    public string StoryLayerName = "Story";
    public string DefaultLayerName = "Default";

    private const string dlgCfgName = "DigContentCfg";
    private const string storyCfgName = "StoryCfg";

    bool autoDialogue = true;
    public bool AutoDialogue
    {
        set { autoDialogue = value; }
        get { return autoDialogue; }
    }

    bool isPause = false;
    public bool IsPause
    {
        set { isPause = value; }
        get { return isPause; }
    }

    int curTime;
    List<SimpleStoryModule> storyList;

    private GameObject storyRoot;
    public GameObject StoryRoot
    {
        get { return storyRoot; }
    }

    int rtWidth = 512;
    int rtHeight = 512;
    RenderTextureDescriptor rtDesc;
    private GameObject storyCMRoot;
    private GameObject modelCMGo;
    private Camera modelCM;
    private RawImage modelRI;
    private RenderTexture modelRT;
    private GameObject leftCMGo;
    private Camera leftCM;
    private RawImage leftRI;
    private RenderTexture leftRT;
    private GameObject rightCMGo;
    private Camera rightCM;
    private RenderTexture rightRT;
    private RawImage rightRI;

    [NoToLua]
    public override void InitMgr()
    {
        storyCMRoot = GameObject.Find("StoryCemara");
        if (storyCMRoot == null)
        {
            storyCMRoot = new GameObject("StoryCemara");
            InitStoryCMRoot();
        }
        else
        {
            modelCMGo = storyCMRoot.transform.Find("ModelCMGo").gameObject;
            modelCM = modelCMGo.GetComponent<Camera>();

            leftCMGo = storyCMRoot.transform.Find("LeftCMGo").gameObject;
            leftCM = leftCMGo.GetComponent<Camera>();

            rightCMGo = storyCMRoot.transform.Find("RightCMGo").gameObject;
            rightCM = rightCMGo.GetComponent<Camera>();
        }
        DontDestroyOnLoad(storyCMRoot);

        modelCMGo.SetActive(false);
        leftCMGo.SetActive(false);
        rightCMGo.SetActive(false);

        storyList = new List<SimpleStoryModule>();

        rtDesc = new RenderTextureDescriptor(rtWidth, rtHeight, RenderTextureFormat.ARGB32, 16);
    }
    [NoToLua]
    public void InitStoryUIRoot()
    {
        if (storyRoot == null)
        {
            storyRoot = UIMgr.Instance.UIRootTrans.Find("StoryUIRoot").gameObject;
            LeftRTGo = storyRoot.transform.Find("Root/LeftRT").gameObject;
            RightRTGo = storyRoot.transform.Find("Root/RightRT").gameObject;
            talkText = storyRoot.transform.Find("DialogBg/Text").GetComponent<Text>();
            toggleBtn = storyRoot.transform.Find("Toggle").GetComponent<Toggle>();
            leftRI = LeftRTGo.GetComponent<RawImage>();
            rightRI = RightRTGo.GetComponent<RawImage>();
        }

        storyRoot.SetActive(false);
    }
    [NoToLua]
    void InitStoryCMRoot()
    {
        modelCMGo = new GameObject("ModelCMGo");
        modelCMGo.transform.SetParent(storyCMRoot.transform);
        modelCM = modelCMGo.AddComponent<Camera>();
        modelCM.orthographic = true;
        modelCM.orthographicSize = 2f;
        modelCM.clearFlags = CameraClearFlags.SolidColor;
        modelCM.cullingMask = LayerMask.GetMask(ModelLayerName);

        leftCMGo = new GameObject("LeftCMGo");
        leftCMGo.transform.SetParent(storyCMRoot.transform);
        leftCM = leftCMGo.AddComponent<Camera>();
        leftCM.orthographic = true;
        leftCM.orthographicSize = 1.5f;
        leftCM.clearFlags = CameraClearFlags.SolidColor;
        leftCM.cullingMask = LayerMask.GetMask(StoryLayerName);

        rightCMGo = new GameObject("RightCMGo");
        rightCMGo.transform.SetParent(storyCMRoot.transform);
        rightCM = rightCMGo.AddComponent<Camera>();
        rightCM.orthographic = true;
        rightCM.orthographicSize = 1.5f;
        rightCM.clearFlags = CameraClearFlags.SolidColor;
        rightCM.cullingMask = LayerMask.GetMask(StoryLayerName);
    }

    public void SetModelRawImage(RawImage ri)
    {
        modelRI = ri;
    }
    [NoToLua]
    public void ResetSrotyCM(Transform target, RawImage ri, GameObject CMGo, Camera CM, RenderTexture rt, string layerName, StoryCMType type)
    {
        if (!CMGo.activeSelf)
            return;

        CMGo.SetActive(false);
        ChangeLayer(target, layerName);
        RenderTexture.ReleaseTemporary(rt);
        ri.texture = null;
        CM.targetTexture = null;
        CMGo.transform.position = Vector3.zero;

        if (type == StoryCMType.Left)
        {
            LeftRTGo.SetActive(false);
        }
        else if (type == StoryCMType.Right)
        {
            RightRTGo.SetActive(false);
        }
    }

    public void ResetSrotyCM(Transform target, StoryCMType type, string layerName)
    {
        switch (type)
        {
            case StoryCMType.Model:
                ResetSrotyCM(target, modelRI, modelCMGo, modelCM, modelRT, layerName, type);
                modelRI = null;
                break;
            case StoryCMType.Left:
                ResetSrotyCM(target, leftRI, leftCMGo, leftCM, leftRT, layerName, type);
                break;
            case StoryCMType.Right:
                ResetSrotyCM(target, rightRI, rightCMGo, rightCM, rightRT, layerName, type);
                break;
            default:
                break;
        }
    }
    [NoToLua]
    public void DisplaySrotyCM(RawImage ri, Transform target, GameObject CMGo, Camera CM, RenderTexture rt, string layerName, StoryCMType type)
    {
        if (type != StoryCMType.Model)
        {
            if (CMGo.activeSelf)
                return;
        }

        if (rt == null)
            rt = RenderTexture.GetTemporary(rtDesc);
        ChangeLayer(target, layerName);

        target.rotation = Quaternion.Euler(0, 0, 0);

        CMGo.SetActive(true);
        ri.texture = rt;
        CM.targetTexture = rt;
        Transform LookPoint = target.Find("look_point");
        if (LookPoint == null)
        {
            LookPoint = new GameObject("look_point").transform;
            LookPoint.SetParent(target);
            LookPoint.localPosition = new Vector3(0,1f,2.5f);
            LookPoint.rotation = Quaternion.Euler(0, 180, 0);
        }
        CMGo.transform.position = LookPoint.position;
        CMGo.transform.rotation = LookPoint.rotation;

        if (type == StoryCMType.Left)
        {
            LeftRTGo.SetActive(true);
        }
        else if(type == StoryCMType.Right)
        {
            RightRTGo.SetActive(true);
        }
    }

    public void DisplaySrotyCM(Transform target, StoryCMType type)
    {
        switch (type)
        {
            case StoryCMType.Model:
                DisplaySrotyCM(modelRI, target, modelCMGo, modelCM, modelRT, ModelLayerName, type);
                break;
            case StoryCMType.Left:
                DisplaySrotyCM(leftRI, target, leftCMGo, leftCM, leftRT, StoryLayerName, type);
                break;
            case StoryCMType.Right:
                DisplaySrotyCM(rightRI, target, rightCMGo, rightCM, rightRT, StoryLayerName, type);
                break;
            default:
                break;
        }
    }
    [NoToLua]
    public void StartStory(int id)
    {
        InitStoryUIRoot();

        if (storyRoot == null)
        {
            DebugHelper.LogError("StoryRoot isnt exist,please check!!!");
            return;
        }

        Dictionary<string, string> data = ConfigMgr.Instance.getLine(id, storyCfgName);
        if (data == null)
        {
            DebugHelper.LogError(id + " StoryData isnt exist,please check!!!");
            return;
        }

        if (data["type"].CompareTo("0") == 0)
        {
            //simple story
            PlaySimpleStory(data);
        }
        else
        {
            PlayComplexStory();
        }

        storyRoot.SetActive(true);
    }

    [NoToLua]
    public void DialogueEndPauseStatus()
    {
        if (!autoDialogue)
            isPause = true;
    }
    [NoToLua]
    private void Update()
    {
        if (storyList == null) return;

        if (storyList.Count == 0)
            return;

        if (isPause && !autoDialogue)
        {
            if (Input.GetMouseButtonUp(0))
            {
                isPause = false;
            }
            return;
        }

        curTime += 1;
        SimpleStoryModule curStory = storyList[0];
        if (curStory.isOver) return;

        for (int i = 0; i < curStory.storyPAs.Count;++i)
        {
            if (isPause && !autoDialogue)
            {
                return;
            }
            curStory.storyPAs[i].DealWithSimpleMode(curTime);
        }

        if (curTime >= curStory.endTime)
        {
            curStory.OverEvent(curStory);
        }
    }
    [NoToLua]
    void SimpleStoryOver(SimpleStoryModule module)
    {
        Debug.Log("sstory over");

        module.isOver = true;
        storyList.Remove(module);

        curTime = 0;

        if (storyList.Count == 0)
        {
            //total story is Over
            storyRoot.SetActive(false);
        }
    }
    [NoToLua]
    IPlayableAssetDeal AssembleActivitionPA(Dictionary<string, string> data)
    {
        ScriptPlayableAssetActivation scriptPlayableAssetActivation = new ScriptPlayableAssetActivation();
        scriptPlayableAssetActivation.masterId = (int)Double.Parse(data["npcId"]);
        scriptPlayableAssetActivation.location = (StoryLocation)(int)Double.Parse(data["slot"]);
        scriptPlayableAssetActivation.startTime = (int)Double.Parse(data["startTime"]);
        scriptPlayableAssetActivation.endTime = (int)Double.Parse(data["endTime"]);
        scriptPlayableAssetActivation.mgr = this;

        scriptPlayableAssetActivation.master = scriptPlayableAssetActivation.masterId > 0 ? ActorMgr.Instance.GetPreviewActorById(1, scriptPlayableAssetActivation.masterId) : ActorMgr.Instance.GetPreviewActorById(0, scriptPlayableAssetActivation.masterId);

        return scriptPlayableAssetActivation;
    }
    [NoToLua]
    IPlayableAssetDeal AssembleAnimationPA(Dictionary<string, string> data)
    {
        ScriptPlayableAssetAnimation scriptPlayableAssetAnimation = new ScriptPlayableAssetAnimation();
        scriptPlayableAssetAnimation.masterId = (int)Double.Parse(data["npcId"]);
        scriptPlayableAssetAnimation.location = (StoryLocation)(int)Double.Parse(data["slot"]);
        scriptPlayableAssetAnimation.animationName = data["aniName"].ToString();
        scriptPlayableAssetAnimation.startTime = (int)Double.Parse(data["startTime"]);
        scriptPlayableAssetAnimation.endTime = (int)Double.Parse(data["endTime"]);
        scriptPlayableAssetAnimation.mgr = this;

        GameObject master = scriptPlayableAssetAnimation.masterId > 0 ? ActorMgr.Instance.GetPreviewActorById(1, scriptPlayableAssetAnimation.masterId) : ActorMgr.Instance.GetPreviewActorById(0, scriptPlayableAssetAnimation.masterId);
        if (master != null)
        {
            scriptPlayableAssetAnimation.animator = master.GetComponent<Animator>();
        }

        return scriptPlayableAssetAnimation;
    }
    [NoToLua]
    IPlayableAssetDeal AssembleAudioPA(Dictionary<string, string> data)
    {
        ScriptPlayableAssetAudio scriptPlayableAssetAudio = new ScriptPlayableAssetAudio();
        scriptPlayableAssetAudio.audioName = data["audioName"].ToString();
        scriptPlayableAssetAudio.audioPath = data["audioPath"].ToString();
        scriptPlayableAssetAudio.startTime = (int)Double.Parse(data["startTime"]);
        scriptPlayableAssetAudio.endTime = (int)Double.Parse(data["endTime"]);
        scriptPlayableAssetAudio.mgr = this;

        return scriptPlayableAssetAudio;
    }
    [NoToLua]
    IPlayableAssetDeal AssembleStoryDialoguePA(Dictionary<string, string> data)
    {
        ScriptPlayableAssetStoryDialogue scriptPlayableAssetStory = new ScriptPlayableAssetStoryDialogue();
        scriptPlayableAssetStory.dlgId = (int)Double.Parse(data["dlgId"]);
        scriptPlayableAssetStory.startTime = (int)Double.Parse(data["startTime"]);
        scriptPlayableAssetStory.endTime = (int)Double.Parse(data["endTime"]);
        scriptPlayableAssetStory.mgr = this;

        scriptPlayableAssetStory.toggleBtn = toggleBtn;
        scriptPlayableAssetStory.talkText = talkText;

        return scriptPlayableAssetStory;
    }
    [NoToLua]
    public void ResetDialogueText()
    {
        talkText.text = "";
    }
    [NoToLua]
    public void PlayDialogueText(int dlgId)
    {
        talkText.text = ConfigMgr.Instance.getValue(dlgId, "content", dlgCfgName);
    }
    [NoToLua]
    IPlayableAssetDeal AssembleStoryPlayableAsset(int id, out int endTime)
    {
        Dictionary<string, string> data = ConfigMgr.Instance.getLine(id, "SStoryContentCfg");
        endTime = (int)Double.Parse(data["endTime"]);
        int aniType = (int)Double.Parse(data["aniType"]);

        IPlayableAssetDeal pa = null;
        switch(aniType)
        {
            case 0:
                //显示
                pa = AssembleActivitionPA(data);
                break;
            case 1:
                //动画
                pa = AssembleAnimationPA(data);
                break;
            case 2:
                //音效
                pa = AssembleAudioPA(data);
                break;
            case 3:
                //对话
                pa = AssembleStoryDialoguePA(data);
                break;
            default:
                break;
        }

        return pa;
    }
    [NoToLua]
    void PlaySimpleStory(Dictionary<string, string> data)
    {
        SimpleStoryModule sStoryModule = new SimpleStoryModule();
        sStoryModule.storyPAs = new List<IPlayableAssetDeal>();
        sStoryModule.endTime = 0;
        int endTime = 0;
        string[] storyIds = data["storyId"].Split(';');
        foreach (var id in storyIds)
        {
            IPlayableAssetDeal pa = AssembleStoryPlayableAsset((int)Double.Parse(id), out endTime); ;
            if (pa != null)
            {
                sStoryModule.storyPAs.Add(pa);
            }

            if (endTime > sStoryModule.endTime)
            {
                sStoryModule.endTime = endTime;
            }
        }

        sStoryModule.OverEvent = SimpleStoryOver;

        storyList.Add(sStoryModule);
    }
    [NoToLua]
    void PlayComplexStory()
    {
        TimelineManager.Instance.AddTimeline(curTLMap.asset);

        TimelineManager.Instance.MPlayableDirector.extrapolationMode = UnityEngine.Playables.DirectorWrapMode.Hold;

        foreach (var binding in curTLMap.bindingDic)
        {
            InitTLBindings(binding);
        }

        foreach (var track in curTLMap.clipDic)
        {
            InitTLClips(track);
        }

        TimelineManager.Instance.Play();
    }
    [NoToLua]
    void InitTLBindings(PlayableBindingDic binding)
    {
        if (binding.typeName.CompareTo("UnityEngine.GameObject") == 0)
        {
            GameObject obj = null;
            if (binding.objInfo.CompareTo("LeftRT") == 0)
            {
                obj = LeftRTGo;
            }
            else if (binding.objInfo.CompareTo("RightRT") == 0)
            {
                obj = RightRTGo;
            }
            else
            {
                /*obj = ModelMgr.Instance.GetModelByName(binding.objInfo);
                if (obj == null)
                {
                    Debug.Log(binding.objInfo + " isnt exist in scene");
                    return;
                }*/
            }
            TimelineManager.Instance.SetBinding(binding.trackName, obj);
        }
        else if (binding.typeName.CompareTo("UnityEngine.Animator") == 0)
        {
            /*GameObject obj = ModelMgr.Instance.GetModelByName(binding.objInfo);
            if (obj == null)
            {
                Debug.Log(binding.objInfo + " isnt exist in scene");
                return;
            }
            Animator animator = obj.GetComponent<Animator>();
            TimelineManager.Instance.SetBinding(binding.trackName, animator);*/
        }
    }
    [NoToLua]
    void InitTLClips(PlayableClipDic track)
    {
        for (int i = 0; i < track.clipNames.Count; ++i)
        {
            if (track.clipNames[i].CompareTo("ScriptPlayableAssetStoryDialogue") == 0)
            {
                var asset = TimelineManager.Instance.GetClip<ScriptPlayableAssetStoryDialogue>(track.trackName, track.clipNames[i]);
                asset.talkText = talkText;
                asset.toggleBtn = toggleBtn;

                asset.mgr = this;
            }
        }
    }
    [NoToLua]
    public void SetStoryCMAndRT(int actorId, StoryLocation location)
    {
        /*GameObject obj = ModelMgr.Instance.GetModelById(actorId);
        if (obj == null)
        {
            Debug.Log(actorId + " isnt exist in scene");
            return;
        }

        ChangeLayer(obj.transform, StoryLayerName);

        Transform point = obj.transform.Find("story_point");
        if (location == StoryLocation.Left)
        {
            LeftCM.transform.position = point.position;
            LeftCM.transform.rotation = point.rotation;
        }
        else
        {
            RightCM.transform.position = point.position;
            RightCM.transform.rotation = point.rotation;
        }*/
    }
    [NoToLua]
    public void BindParticle2Place(ParticleSystem particle, int actorId, string pointName, ParticleTLType location)
    {
        Transform point = null;
        if (location == ParticleTLType.NpcBody)
        {
            /*GameObject obj = ModelMgr.Instance.GetModelById(actorId);
            if (obj == null)
            {
                Debug.Log(actorId + " isnt exist in scene");
                return;
            }

            point = obj.transform.Find(pointName);
            if (point == null)
            {
                Debug.Log(actorId + " there is no point named " + pointName);
                return;
            }

            particle.transform.SetParent(point);
            particle.transform.localPosition = Vector3.zero;*/
        }
        else
        {
            /*Transform obj = ModelMgr.Instance.actorRoot.transform.Find(pointName);
            if (obj == null)
            {
                Debug.Log(pointName + " isnt exist in scene");
                return;
            }
            particle.transform.SetParent(point);
            particle.transform.localPosition = Vector3.zero;*/
        }
    }
    [NoToLua]
    public void ChangeLayer(Transform trans, string targetLayer)
    {
        if (LayerMask.NameToLayer(targetLayer) == -1)
        {
            Debug.Log("Layer中不存在,请手动添加LayerName");

            return;
        }
        //遍历更改所有子物体layer
        trans.gameObject.layer = LayerMask.NameToLayer(targetLayer);
        foreach (Transform child in trans)
        {
            ChangeLayer(child, targetLayer);
        }
    }
}
