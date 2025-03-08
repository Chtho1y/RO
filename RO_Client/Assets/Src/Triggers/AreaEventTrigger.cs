using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;

[AddComponentMenu("Trigger/Trigger_General")]
public class AreaEventTrigger : FuncRegion,ITrigger
{
    //触发时机
    public enum EActTiming
    {
        Init,
        Enter, // first one enters
        Leave, // last one leaves
        Update,

        EnterDura,
    }

    public enum ActionWhenFull
    {
        DoNothing,
        Destroy,
    }

    [Serializable]
    public struct STimingAction
    {
        public EActTiming Timing;

        public string HelperName;
        public int HelperIndex;
        //public TextAsset ActionFile;
        public string ActionName;
    }

    public struct STriggerContext
    {
        public Fighter fighter;
        public int token;
        public float updateTimer;

        public STriggerContext(Fighter actor
            , int token
            , float inUpdateInterval)
        {
            this.fighter = actor;
            this.token = token;
            updateTimer = inUpdateInterval;
        }
    }

    [FriendlyName("ID")]
    public int ID = 0;

    [FriendlyName("容量")]
    public int Capacity = 10;

    //[FriendlyName("满载动作")]
    public ActionWhenFull actionWhenFull = ActionWhenFull.DoNothing;

    [FriendlyName("存活时间【秒】")]
    public float AliveTicks; // total

    [FriendlyName("触发次数")]
    public int TriggerTimes; // total

    [FriendlyName("触发完毕后失效")]
    public bool bDeactivateSelf = true;

    [FriendlyName("探测频率【秒】")]
    public float UpdateInterval;

    [FriendlyName("轮询式探测")]
    public bool bSimpleUpdate = false;

    [FriendlyName("只有非满血才能触发")]
    public bool OnlyEffectNotFullHpOrMpActor = false;
    private Dictionary<long, int> _inActorsCache = null;

    [FriendlyName("进入时音效")]
    public string EnterSound = null;

    [FriendlyName("离开时音效")]
    public string LeaveSound = null;

    public GameObject[] NextTriggerList = new GameObject[0];


    [HideInInspector, NonSerialized]
    public Dictionary<long, STriggerContext> _inActors = new Dictionary<long, STriggerContext>();

    private int _testToken = 0;
    private Fighter[] _actorTestCache;
    private long[] _actorTormvCache;
    private int m_triggeredCount;
    private int m_updateTimer;
    [HideInInspector, NonSerialized]
    public bool bDoDeactivating;
    private bool m_bShaped = false;
    private int m_collidedCnt = 0;

    public int InActorCount { get { return _inActors.Count; } }

    public TriggerActionWrapper[] TriggerActions = new TriggerActionWrapper[0];

    [HideInInspector, NonSerialized]
    public TriggerActionWrapper PresetActWrapper = null;

    private TriggerActionWrapper[] m_internalActList = new TriggerActionWrapper[0];

    public GameObject GetTriggerObj()
    {
        return gameObject;
    }

    void Awake()
    {
        _actorTormvCache = new long[Capacity];

        m_updateTimer = (int)(UpdateInterval * 1000);
        BuildTriggerWrapper();
        BuildInternalWrappers();
    }

    private void Update()
    {
        UpdateLogic(Time.deltaTime);
    }

    void OnDestroy()
    {
        _inActorsCache = null;
        foreach (TriggerActionWrapper taw in m_internalActList)
        {
            if (taw != null)
            {
                taw.Destroy();
            }
        }
    }

    protected virtual void BuildTriggerWrapper()
    {

    }

    private void BuildInternalWrappers()
    {
        if (PresetActWrapper != null)
        {
            m_internalActList = AddElement(m_internalActList, PresetActWrapper);
        }

        if (TriggerActions.Length > 0)
        {
            m_internalActList = AppendElements(m_internalActList, TriggerActions);
        }

        foreach (TriggerActionWrapper taw in m_internalActList)
        {
            if (taw == null)
            {
                continue;
            }

            if (taw.GetActionInternal() == null)
            {
                taw.Init(ID);
            }
        }
    }

    public override void UpdateLogic(float delta)
    {
        if (!isStartup)
        {
            return;
        }

        if (bSimpleUpdate)
        {
            UpdateLogicSimple(delta);
        }

        if (AliveTicks > 0)
        {
            AliveTicks -= delta;
            if (AliveTicks <= 0)
            {
                AliveTicks = 0;
                DoSelfDeactivating();
            }
        }
    }

    private void UpdateLogicSimple(float delta)
    {
        if (TriggerTimes > 0 && m_triggeredCount >= TriggerTimes)
        {
            return;
        }

        int iDelta = (int)(delta * 1000);

        m_updateTimer -= iDelta;
        if (m_updateTimer <= 0)
        {
            m_updateTimer =(int)(UpdateInterval * 1000);

            for (int i = 0; i < Capacity; ++i)
            {
                Fighter curAct = _actorTestCache[i];
                DoActorUpdate(ref curAct);
            }

            if (++m_triggeredCount >= TriggerTimes && TriggerTimes > 0)
            {
                bDoDeactivating = bDeactivateSelf;
            }
        }
    }

    public void DoSelfDeactivating()
    {
        bDoDeactivating = false;

        int toRmvNum = 0;
        var etr = _inActors.GetEnumerator();
        while (etr.MoveNext())
        {
            _actorTormvCache[toRmvNum++] = etr.Current.Key;
        }
        for (int i = 0; i < toRmvNum; ++i)
        {
            long toRmvObjId = _actorTormvCache[i];
            Fighter refHdl = _inActors[toRmvObjId].fighter;
            #region 这两行时序不能随意调换
            DoActorLeave(ref refHdl);
            _inActors.Remove(toRmvObjId);
            #endregion 这两行时序不能随意调换
        }

        DeactivateSelf();

        ActivateNext();
    }

    private void DeactivateSelf()
    {
        gameObject.SetActive(false);
    }

    private void ActivateNext()
    {
        foreach (GameObject nextGo in NextTriggerList)
        {
            if (nextGo != null)
            {
                nextGo.SetActive(true);
            }
        }
    }

    protected virtual void DoActorEnter(ref Fighter inActor)
    {
        MusicMgr.Instance.PlayFightSound(EnterSound);

        DoActorEnterShared(ref inActor);
    }

    protected virtual void DoActorLeave(ref Fighter inActor)
    {
        DoActorLeaveShared(ref inActor);

        if (inActor == null)
            return;

        if (!string.IsNullOrEmpty(LeaveSound))
        {
            MusicMgr.Instance.PlayFightSound(LeaveSound);
        }
    }

    protected void DoActorEnterShared(ref Fighter inActor)
    {
        foreach (TriggerActionWrapper taw in m_internalActList)
        {
            if (taw != null)
            {
                taw.TriggerEnter(inActor, this);
            }
        }
    }

    protected void DoActorLeaveShared(ref Fighter inActor)
    {
        foreach (TriggerActionWrapper taw in m_internalActList)
        {
            if (taw != null)
            {
                taw.TriggerLeave(inActor, this);
            }
        }
    }

    protected virtual void DoActorUpdate(ref Fighter inActor)
    {
        DoActorUpdateShared(ref inActor);
    }

    protected void DoActorUpdateShared(ref Fighter inActor)
    {
        foreach (TriggerActionWrapper taw in m_internalActList)
        {
            if (taw != null)
            {
                taw.TriggerUpdate(inActor, this);
            }
        }
    }

    public override void Startup()
    {
        base.Startup();

        //_thisActor = ActorHelper.GetActorRoot(sourceActor);

        OnTriggerStart();
    }

    public override void Stop()
    {
        base.Stop();

        int count = m_internalActList.Length;
        for (int i = 0; i < count; ++i)
        {
            var taw = m_internalActList[i];
            if (taw != null)
            {
                taw.Stop();
            }
        }
    }

    protected void OnCoolingDown()
    {
        foreach (TriggerActionWrapper taw in m_internalActList)
        {
            if (taw != null)
            {
                taw.OnCoolDown(this);
            }
        }
    }
    protected void OnTriggerStart()
    {
        foreach (TriggerActionWrapper taw in m_internalActList)
        {
            if (taw != null)
            {
                taw.OnTriggerStart(this);
            }
        }
    }

    public void onActorDestroy(ref Fighter f)
    {
        if (f!=null)
        {
            long id = f.Id;
            if (null != _inActors && _inActors.ContainsKey(id))
            {
                DoActorLeave(ref f);
                _inActors.Remove(id);
            }
            if (null != _inActorsCache && _inActorsCache.ContainsKey(id))
            {
                _inActorsCache.Remove(id);
            }
        }
        else
        {
            DebugHelper.LogError("onActorDestroy#prm.src == null!");
        }
    }

    public static T[] AddElement<T>(T[] elements, T element)
    {
        List<T> elementsList = new List<T>(elements);
        elementsList.Add(element);
        return LinqS.ToArray(elementsList);
    }

    public static T[] AppendElements<T>(T[] elements, T[] appendElements)
    {
        List<T> elementsList = new List<T>(elements);
        if (appendElements != null)
        {
            elementsList.AddRange(appendElements);
        }
        return LinqS.ToArray(elementsList);
    }
}
