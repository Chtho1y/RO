using System;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public enum UI_ANIM {
    NO,
    MOVE_IN,
    MOVE_OUT,
    SCALE_IN,
    SCALE_OUT,
}

public abstract class UIBase : MonoBase {
    public delegate UIBase UIPageCreator ();

    public delegate void PointListener (GameObject point);
    public delegate void PointListenerNoParam ();
    public delegate void ButtonListener (Button btn);
    public delegate void ButtonListenerWithParam (Button btn, params object[] param);

    public delegate void ToggleListener (bool b);
    public delegate void ToggleListenerWithParams (Toggle tog, params object[] param);
    public delegate void DialogCallback (int btn);
   
    [HideInInspector]
    public int ParentId {
        set { m_parentId = value; }
        get { return m_parentId; }
    }

    [SerializeField]
    private int m_parentId;

    [HideInInspector]
    public bool NeedParentKeep {
        set { m_needParentKeep = value; }
        get { return m_needParentKeep; }
    }

    [SerializeField]
    private bool m_needParentKeep;


    private bool mIsBattleMainPage = false;
    [HideInInspector]
    public bool IsBattleMainPage
    {
        get { return mIsBattleMainPage; }
        set { mIsBattleMainPage = value; }
    }

    private bool mIsClosed = false;
   
    #region fields
    private static int s_sequence = 0;

    private bool bInited = false;
    public bool Inited
    {
        get { return bInited; }
    }

    Canvas[] mChildCanvasList = null;
    private Canvas mCanvas = null;
    protected CanvasGroup mCanvasGroup = null;

    private GameObject mRootPage = null;
    private Transform mPageBodyTrans = null;
    private GameObject mPageBody = null;
    private int mPageId = 0;

    public UIAnimationListener animListener;

    private UIAnimationEvent[] mAnimtionEvents;

    private Dictionary<string, GameObject> mChildGoes = null;

    public int PageId {
        get { return mPageId; }
        set { mPageId = value; }
    }

    private int mPageUniqueID = 0;
    public int PageUniqueID {
        get { return mPageUniqueID; }
    }

    private string mPageName;
    public string MPageName {
        get { return mPageName; }
        set { mPageName = value; }
    }

    private int mSourceUIID;
    public int MSourceUIID {
        get { return mSourceUIID; }
        set { mSourceUIID = value; }
    }

    private bool bShowTopBtn;
    public bool ShowTopBtn
    {
        get { return bShowTopBtn; }
        set { bShowTopBtn = value; }
    }

    private bool mOutList;
    public bool MOutList
    {
        get { return mOutList; }
        set { mOutList = value; }
    }

    public bool IsActive {
        get {
            if (mPageBody == null)
                return false;
            return mPageBody.activeSelf;
        }
    }

    protected object m_Data;
    public object Data {
        get { return m_Data; }
    }

    protected UI_ANIM mAnimInType = UI_ANIM.NO;
    protected UI_ANIM mAnimOutType = UI_ANIM.NO;
    private bool mIsPageAnimation = false;
    private bool mIsPageEnabled = false; //save enabled state when page is animation.
    protected bool mIsNotify = false;
    protected bool mIsTop = false;
    protected bool mIsEnabled = true;

    protected bool mIsDisposed = false;
    protected bool mIsOpened = false;
    protected bool mIsShowed = false;
    protected bool mIsHide = false;
    protected bool bNeedCache = true;

    public bool IsHide
    {
        get { return mIsHide; }
    }

    public bool NeedCache
    {
        get { return bNeedCache; }
        set { bNeedCache = value; }
    }
    //protected UIData mUIData;

    private bool mCanPlaySound = true;
    public bool CanPlaySound { get { return mCanPlaySound; } set { mCanPlaySound = value; } }

    private int mUIType = 0;
    public int MUIType {
        set { mUIType = value; }
        get { return mUIType; }
    }

    private bool mPersistentStatus = false;
    public bool MPersistentStatus {
        set { mPersistentStatus = value; }
        get { return mPersistentStatus; }
    }

    protected int mShowLoadingActionId = 0;

    protected struct CanvasStatus {
        public Canvas m_canvas;
        public bool m_bOriginalEnabled;

        public CanvasStatus (Canvas c, bool s) {
            m_canvas = c;
            m_bOriginalEnabled = s;
        }
    };
    protected List<CanvasStatus> m_ChildCanvasStatus = null;

    private EUIPageType mPageType = EUIPageType.Null;
    public EUIPageType PageType {
        get { return mPageType; }
        set { mPageType = value; }
    }

    public int initSortingOrder;

    public int SortingOrder {
        get {
            return mCanvas != null ? mCanvas.sortingOrder : 0;
        }
        set {
            if (mCanvas == null)
                return;
            mCanvas.sortingOrder = value;
        }
    }

    public GameObject PageBody {
        get { return mPageBody; }
    }

    public Transform PageTrans {
        get { return mPageBodyTrans; }
    }

    private string mAssetBundle;
    public string StrAssetBundle {
        get {
            return mAssetBundle;
        }
        set {
            if(mAssetBundle!=value)
            {
                mAssetBundle = value;
            }
        }
    }

    private string[] mChildAssetNames = null;

    private string mChildPaths;
    public string ChildPaths
    {
        get { return mChildPaths; }
        set
        {
            if(mChildPaths != value)
            {
                mChildPaths = value;
                if (!string.IsNullOrEmpty(mChildPaths))
                    mChildAssetNames = mChildPaths.Split(';');
                else
                    mChildAssetNames = null;
            }
        }
    }

    public bool IsEnabled {
        get { return mIsEnabled; }
        set { mIsEnabled = value; }
    }

    public bool IsDisposed {
        get { return mIsDisposed; }
    }

    public bool IsOpened {
        get { return mIsOpened; }
    }

    public UI_ANIM PageAnimInType {
        get { return mAnimInType; }
        set { mAnimInType = value; }
    }

    public UI_ANIM PageAnimOutType {
        get { return mAnimOutType; }
        set { mAnimOutType = value; }
    }

    public bool IsPageAnimation {
        get { return mIsPageAnimation; }
    }

    public bool CanvasEnabled {
        get { return mCanvas != null ? mCanvas.enabled : false; }
        set {
            if (mCanvas == null) return;

            if (mCanvas.enabled != value) {
                mCanvas.overrideSorting = true;
                mCanvas.enabled = value;

                if (mChildCanvasList != null) {
                    for (int idx = 0; idx < mChildCanvasList.Length; idx++)
                    {
                        if (mChildCanvasList[idx])
                            mChildCanvasList[idx].enabled = value;
                    }
                }
            }
        }
    }

    public bool IsShowed {
        get { return mIsShowed; }
    }

    public Canvas UICanvas {
        get { return mCanvas; }
    }

    List<Selectable> mAddListenerComList = new List<Selectable> ();
    Dictionary<Selectable, UIPlaySound> mBtnClickSoundHolderDict = new Dictionary<Selectable, UIPlaySound>();

    int interTime = 500;
    int timerSeq;
    bool UIEventStatus = false;
    #endregion

    private void Awake () {
        mPageUniqueID = ++s_sequence;
    }

    [NoToLua]
    public virtual void Open (UIData uidata, object param) {
        DisableGroupInteraction ();

        //mUIData = uidata;
        //mPageId = mUIData.PageID;
        m_Data = param;
        bInited = false;
        mIsShowed = true;
        mIsDisposed = false;
        mIsOpened = true;
        mIsHide = false;
        mIsClosed = false;

        OnAwake ();
        if (mPageBody == null) 
        {
            LoadUIAssets ();
        } 
        else 
        {
            //!Move To Top Level
            mPageBodyTrans.SetAsLastSibling ();
            if (!mIsTop && UIMgr.Instance.MainFunPage != null) {
                UIMgr.Instance.MainFunPage.GetComponent<RectTransform> ().SetAsLastSibling ();
            }
            FillContent ();
            PageAnimationIn();
        }
    }

    [NoToLua]
    public void EnableGroupInteraction () {
        StartCoroutine (DelayCanvasGroupInteraction (0.0f));
    }

    [NoToLua]
    public void DisableGroupInteraction () {
        if (mCanvasGroup != null)
            mCanvasGroup.interactable = false;
    }

    IEnumerator DelayCanvasGroupInteraction (float time) {
        yield return new WaitForSeconds (time);

        if (mCanvasGroup != null) mCanvasGroup.interactable = true;
    }

    protected void CreatePageBody () 
    {
        if (string.IsNullOrEmpty (mPageName))
            mPageName = GetType ().Name;

        mPageBody = new GameObject (mPageName);

        mCanvas = mPageBody.AddComponent<Canvas> ();

        mPageBody.AddComponent<GraphicRaycaster> ();
        mCanvasGroup = mPageBody.AddComponent<CanvasGroup> ();
        DisableGroupInteraction ();

        SortingOrder = initSortingOrder;

        CanvasEnabled = true;

        animListener = mPageBody.AddComponent<UIAnimationListener>();
        animListener.ListenerPage = this;
        mPageBody.layer = LayerMask.NameToLayer ("UI");

        mPageBodyTrans = mPageBody.transform;
        mPageBodyTrans.SetParent (UIMgr.Instance.UIRootTrans);

        RectTransform rectTrans = mPageBody.GetComponent<RectTransform> ();
        if (rectTrans != null) {
            RectTransform rootRTrans = UIMgr.Instance.UIRootTrans.GetComponent<RectTransform> ();
            rectTrans.localPosition = Vector3.zero;
            rectTrans.localScale = Vector3.one;

            rectTrans.anchorMin = new Vector2 (0, 0);
            rectTrans.anchorMax = new Vector2 (1.0f, 1.0f);
            rectTrans.pivot = new Vector2 (0.5f, 0.5f);
            rectTrans.anchoredPosition = Vector2.zero;
            rectTrans.sizeDelta = Vector2.zero;
        }
        if (!mIsTop && UIMgr.Instance.MainFunPage != null) {
            UIMgr.Instance.MainFunPage.GetComponent<RectTransform> ().SetAsLastSibling ();
        }

        mCanvas.overrideSorting = true;
        //SortingOrder += UIMgr.Instance.GetNextPageOrderingSort (this);
    }
    
    private void ResetPageBody(GameObject bodyGO)
    {
        if (string.IsNullOrEmpty(mPageName))
            mPageName = GetType().Name;

        mPageBody = bodyGO;
        mCanvas = mPageBody.GetComponent<Canvas>();
        mCanvasGroup = mPageBody.GetComponent<CanvasGroup>();
        DisableGroupInteraction();

        SortingOrder = initSortingOrder;
        CanvasEnabled = true;

        animListener = mPageBody.GetComponent<UIAnimationListener>();
        if (animListener == null)
        {
            animListener = mPageBody.AddComponent<UIAnimationListener>();
        }

        animListener.ListenerPage = this;
        mPageBodyTrans = mPageBody.transform;

        if (!mIsTop && UIMgr.Instance.MainFunPage != null)
        {
            UIMgr.Instance.MainFunPage.GetComponent<RectTransform>().SetAsLastSibling();
        }

        mCanvas.overrideSorting = true;
        //SortingOrder += UIMgr.Instance.GetNextPageOrderingSort(this);
        mPageBody.SetActive(true);
        //CommonUtil.SetGameObjectLayer(mPageBody, "UI");
    }

    protected void LoadUIAssets () 
    {
        if (mAssetBundle != null && !string.IsNullOrEmpty(mAssetBundle)) 
        {
            GameObject pageGo = ResourceMgr.Instance.GetUIGoFromPool(Constants.UIPath, mAssetBundle + "_body");

            List<string> assetNames = new List<string>();
            assetNames.Add(mAssetBundle);
            if (mChildAssetNames != null)
            {
                for (int idx = 0; idx < mChildAssetNames.Length; idx++)
                    assetNames.Add(mChildAssetNames[idx]);
            }

            if (pageGo == null)
            {
                CreatePageBody();
                ResourceMgr.Instance.GetGoesFromPool(Constants.UIPath, assetNames.ToArray(), OnLoadRes);
            }
            else
            {
                ResetPageBody(pageGo);
                mRootPage = pageGo.transform.Find("Root").gameObject;
                mAnimtionEvents = mPageBody.GetComponentsInChildren<UIAnimationEvent>(true);
                if (mAnimtionEvents != null)
                {
                    foreach(var animationEvent in mAnimtionEvents)
                    {
                        animationEvent.BasePage = this;
                    }
                }

                for (int idx = 1; idx < assetNames.Count; idx++)
                {
                    if (mChildGoes == null)
                        mChildGoes = new Dictionary<string, GameObject>();

                    var subGo = pageGo.transform.Find("Part" + idx).gameObject;
                    mChildGoes.Add(assetNames[idx], subGo);
                }

                StartInitialize();
                PageAnimationIn();
            }
        }
        else 
        {
            EventMgr.DispatchEvent<int> (new CoreEvent<int> (ECoreEventType.EID_UI_LoadFail, mPageId));
        }
    }

    private void OnLoadRes (List<GameObject> uiGoes,string path,string[] assetNames) 
    {
        if (uiGoes == null || uiGoes.Count == 0) {
            EventMgr.DispatchEvent<int> (new CoreEvent<int> (ECoreEventType.EID_UI_LoadFail, mPageId));
            Hide ();
            return;
        }

        mRootPage = uiGoes[0];
        mRootPage.name = "Root";
        mRootPage.SetActive(true);

        for(int idx = 0;idx < uiGoes.Count;idx++)
        {
            CommonUtil.SetGameObjectLayer(uiGoes[idx], "UI");
            RectTransform rectTrans = uiGoes[idx].GetComponent<RectTransform>();
            rectTrans.SetParent(mPageBodyTrans, false);
            rectTrans.localScale = Vector3.one;
            if(idx == 0)
            {
                rectTrans.anchorMin = new Vector2(0, 0);
                rectTrans.anchorMax = new Vector2(1.0f, 1.0f);
                rectTrans.pivot = new Vector2(0.5f, 0.5f);
                rectTrans.anchoredPosition3D = Vector3.zero;
                rectTrans.sizeDelta = Vector2.zero;
            }
            else
            {
                if (mChildGoes == null)
                    mChildGoes = new Dictionary<string, GameObject>();

                mChildGoes.Add(assetNames[idx], uiGoes[idx]);
                uiGoes[idx].name = "Part" + idx;
            }
        }

        //已经关闭
        if (mIsDisposed || mIsClosed)
        {
            //ResourceMgr.Instance.RecycleGO(Constants.UIPath, mMainAssetBundle, mRootPage);
            for(int idx =0; idx < assetNames.Length;idx++)
            {
                ResourceMgr.Instance.RecycleGO(Constants.UIPath, assetNames[idx], uiGoes[idx]);
            }
            mRootPage = null;
            return;
        }

        mAnimtionEvents = mPageBody.GetComponentsInChildren<UIAnimationEvent>(true);
        if (mAnimtionEvents != null)
        {
            foreach (var animationEvent in mAnimtionEvents)
            {
                animationEvent.BasePage = this;
            }
        }

        StartInitialize ();
        PageAnimationIn();
    }

    public GameObject GetRoot () 
    {
        return mRootPage;
    }

    void StartInitialize () 
    {  
        EnableGroupInteraction ();
        mChildCanvasList = mPageBody.GetComponentsInChildren<Canvas> ();

        if (mChildCanvasList != null)
        {
            for (int idx = 0; idx < mChildCanvasList.Length; idx++)
                mChildCanvasList[idx].enabled = true;
        }

        EventMgr.DispatchEvent<int>(new CoreEvent<int>(ECoreEventType.EID_UI_LoadSuccess, mPageId));

        InitializePage();
    }

    public GameObject FindElementGo (string name) {
        if (mPageBodyTrans == null) return null;

        GameObject go = null;
        Transform trans = mPageBodyTrans.Find (name);
        if (trans != null) go = trans.gameObject;

        return go;
    }

    public GameObject FindElementGo (GameObject go, string name) {
        if (go == null) return null;

        GameObject cgo = null;

        Transform trans = go.transform.Find (name);
        if (trans != null) cgo = trans.gameObject;

        return cgo;
    }

    public T FindElement<T> (string name) {
        return FindElement<T> (mPageBody, name);
    }

    public T FindElement<T> (GameObject go, string name) {
        if (go == null) return default (T);

        Transform trans = go.transform.Find (name);
        if (trans == null) return default (T);

        return trans.GetComponent<T> ();
    }
    #region 虚函数

    [NoToLua]
    public virtual void InitializePage () {
        bInited = true;

        FillContent ();

        AddEventListener ();
        AddUIEventListener ();
    }

    [NoToLua]
    public virtual void OnOpenAnimEnd () {
        mIsPageAnimation = false;
        IsEnabled = mIsPageEnabled;

        if (!IsOpened) {
            CanvasEnabled = false;
        }

        OnPageInEnd();

        EventMgr.DispatchEvent<int>(new CoreEvent<int>(ECoreEventType.EID_UI_SHOW, mPageId));
    }

    [NoToLua]
    public virtual void OnCloseAnimEnd()
    {
        mIsPageAnimation = false;
        IsEnabled = mIsPageEnabled;

        CanvasEnabled = false;

        OnPageOutEnd();

        EventMgr.DispatchEvent<int>(new CoreEvent<int>(ECoreEventType.EID_UI_CLOSE, mUIType));
    }

    public virtual void Show (object param = null, bool needOutAnim = true) {
        m_Data = param;

        EnableGroupInteraction ();
        if (!bInited)
        {
            return;
        }

        if (!mIsOpened) {
            mIsOpened = true;

            EventMgr.DispatchEvent<int> (new CoreEvent<int> (ECoreEventType.EID_UI_SHOW, mPageId));
        }

        if (!mIsShowed) {
            if (!UIMgr.Instance.PageInHideStack (this)) {
                //SortingOrder += UIMgr.Instance.GetNextPageOrderingSort(this);
            }

            CanvasEnabled = true;
            //mPageBody.SetActive (true);
            mIsShowed = true;
            mIsHide = false;

            PageAnimationIn (needOutAnim);
        }

        OnShow ();
        //EventMgr.DispatchEvent<int, bool> (new CoreEvent<int, bool> (ECoreEventType.EID_UI_VISIBLE, mPageId, true));
    }

    public virtual void Hide (bool needOutAnim = true) {
        if (!mIsShowed) return;

        OnHide();
        PageAnimationOut(needOutAnim);

        if (!IsPageAnimation) {
            //mPageBody.SetActive (false);
            CanvasEnabled = false;
        }

        mIsShowed = false;
        mIsHide = true;
        //EventMgr.DispatchEvent<int, bool> (new CoreEvent<int, bool> (ECoreEventType.EID_UI_VISIBLE, mPageId, false));
    }

    public virtual void Close (bool needOutAnim = true) {
        if (mIsClosed) return;

        RemoveEventListener();
        OnClose();

        PageAnimationOut(needOutAnim);

        mIsShowed = false;
        mIsOpened = false;
        mIsHide = false;
        mIsClosed = true;
    }

    public virtual void Dispose () {
        if (mIsDisposed) return;

        TimerManager.Instance.RemoveTimer(timerSeq);
        for (int idx = 0; idx < mAddListenerComList.Count; idx++)
        {
            Button btn = mAddListenerComList[idx] as Button;
            if (btn != null)
            {
                btn.onClick.RemoveAllListeners();
                continue;
            }

            Toggle tog = mAddListenerComList[idx] as Toggle;
            if (tog != null)
            {
                tog.onValueChanged.RemoveAllListeners();
                continue;
            }

            Slider slider = mAddListenerComList[idx] as Slider;
            if (slider != null)
            {
                slider.onValueChanged.RemoveAllListeners();
                continue;
            }

            InputField input = mAddListenerComList[idx] as InputField;
            if (input != null)
            {
                input.onValueChanged.RemoveAllListeners();
                continue;
            }

            TMP_InputField tInput = mAddListenerComList[idx] as TMP_InputField;
            if (tInput != null)
            {
                tInput.onValueChanged.RemoveAllListeners();
                continue;
            }

            Dropdown dropDown = mAddListenerComList[idx] as Dropdown;
            if (dropDown != null)
            {
                dropDown.onValueChanged.RemoveAllListeners();
                continue;
            }
        }
        mAddListenerComList.Clear();
        mBtnClickSoundHolderDict.Clear();

        Close();       
        OnDispose ();
        CanvasEnabled = false;

        if(mRootPage!=null && bNeedCache)
        {
            if (mPageBody != null)
            {
                ResourceMgr.Instance.RecycleUIGO(Constants.UIPath, mAssetBundle + "_body", mPageBody);
            }
        }
        else
        {
            ResourceMgr.Instance.RemoveLoadedResource(Constants.UIPath, mAssetBundle);
            if(mChildAssetNames != null)
            {
                for(int idx =0; idx < mChildAssetNames.Length;idx++)
                {
                    ResourceMgr.Instance.RemoveLoadedResource(Constants.UIPath, mChildAssetNames[idx]);
                }
            }

            GameObject.Destroy(mPageBody);
        }
        if (mAnimtionEvents != null)
        {
            foreach (var animationEvent in mAnimtionEvents)
            {
                animationEvent.BasePage = null;
            }
        }
        if(animListener != null)
        {
            animListener.ListenerPage = null;
        }
        
        mPageBody = null;
        mPageBodyTrans = null;
        mRootPage = null;
        mAnimtionEvents = null;
        mChildCanvasList = null;
        animListener = null;

        m_Data = null;
        mCanvas = null;
        mCanvasGroup = null;
        mIsDisposed = true;

        Destroy (this);
    }

    public virtual void BackIn () {
        OnBackIn ();
    }
    #endregion

    #region inner_methods
    void PageAnimationIn (bool needOutAnim = true) {
        if (!UIMgr.Instance) return;

        //已经关闭
        if (mIsDisposed || mIsClosed)
        {
            return;
        }

        if (mIsPageAnimation) {
            StartCoroutine (checkAnimationState ());
            return;
        }

        if (mRootPage != null)
        {
            mRootPage.SetActive(true);
        }

        mIsPageAnimation = false;
        if (needOutAnim)
        {
            Animator anim = null;
            Transform uiAnimator = mPageBody.transform.Find("Root/UIAnimator");
            if (uiAnimator != null)
            {
                if (mAnimInType != UI_ANIM.NO)
                {
                    anim = uiAnimator.GetComponent<Animator>();
                }

                if (anim != null)
                {
                    switch (mAnimInType)
                    {
                        case UI_ANIM.MOVE_IN:
                        case UI_ANIM.MOVE_OUT:
                        case UI_ANIM.SCALE_IN:
                        case UI_ANIM.SCALE_OUT:
                            {
                                string name = GetAniName(mAnimInType);
                                if (anim != null)
                                {
                                    anim.Play(name, 0, 0);
                                    anim.updateMode = AnimatorUpdateMode.Normal;
                                    mIsPageAnimation = true;
                                }
                            }
                            break;
                    }
                }
            }
        }

        if (mIsPageAnimation)
        {
            mIsPageEnabled = IsEnabled;
            IsEnabled = false;
        }
        else
        {
            OnOpenAnimEnd();
        }
    }

    [NoToLua]
    public string GetAniName(UI_ANIM animType)
    {
        string animName = null;
        switch (animType)
        {
            case UI_ANIM.MOVE_IN:
                animName = "UIMoveInRight";
                break;
            case UI_ANIM.MOVE_OUT:
                animName = "UIMoveOutLeft";
                break;
            case UI_ANIM.SCALE_IN:
                animName = "UIWindowIn";
                break;
            case UI_ANIM.SCALE_OUT:
                animName = "UIWindowOut";
                break;
        }

        return animName;
    }

    void PageAnimationOut (bool needOutAnim = true) {
        if (!UIMgr.Instance) return;

        mIsPageAnimation = false;
        if (needOutAnim)
        {
            Animator anim = null;
            Transform uiAnimator = mPageBody.transform.Find("Root/UIAnimator");
            if (uiAnimator != null)
            {
                if (mAnimOutType != UI_ANIM.NO)
                {
                    anim = uiAnimator.GetComponent<Animator>();
                }

                if (anim != null)
                {
                    switch (mAnimOutType)
                    {
                        case UI_ANIM.MOVE_IN:
                        case UI_ANIM.MOVE_OUT:
                        case UI_ANIM.SCALE_IN:
                        case UI_ANIM.SCALE_OUT:
                            {
                                string name = GetAniName(mAnimOutType);
                                if (anim != null)
                                {
                                    anim.Play(name, 0, 0);
                                    anim.updateMode = AnimatorUpdateMode.Normal;
                                    mIsPageAnimation = true;
                                }
                            }
                            break;
                    }
                }
            }
        }
       
        if (mIsPageAnimation) {
            mIsPageEnabled = IsEnabled;
            IsEnabled = false;
        } else {
            OnCloseAnimEnd();
        }
        StartCoroutine (DelayDisablePage ());
    }

    IEnumerator checkAnimationState () {
        while (mIsPageAnimation) yield return 0;

        PageAnimationIn ();
    }

    IEnumerator DelayDisablePage () {
        if (this.PageBody != null) {
            if (mCanvasGroup != null) {
                float time = 0;
                while (mCanvasGroup.alpha != 0) {
                    yield return new WaitForEndOfFrame ();
                    if (!PageBody)
                        yield break;
                    time += Time.deltaTime;
                    if (time > 2) {
                        yield break;
                    }
                }
                if (mRootPage != null) {
                    mRootPage.SetActive(false);
                }
            }
        }
    }
    #endregion

    #region 外部需要重构的 abstract 方法.
    protected abstract void OnAwake ();

    protected abstract void AddEventListener ();

    protected abstract void FillContent ();

    protected abstract void RemoveEventListener ();

    protected abstract void AddUIEventListener ();

    protected abstract void OnBaseHide();

    protected abstract void OnHide ();

    protected abstract void OnBaseShow();
    protected abstract void OnShow ();

    protected abstract void OnBaseClose();
    protected abstract void OnClose ();

    protected abstract void OnBaseDispose();
    protected abstract void OnDispose ();

    protected abstract void OnBackIn ();

    protected abstract void OnPageOutEnd();

    protected abstract void OnPageInEnd();

    public abstract void OnSubCloseAnimEnd(string path);
    #endregion

    #region events

    void ResetUIEventStatus (int seq) {
        UIEventStatus = false;
        timerSeq = -1;
    }

    public void AddButtonExitListener (Button btn, LuaTable table, LuaFunction listener, params object[] param) {
        if (btn != null) {
            mAddListenerComList.Add (btn);
            UIEventTriggerListener eventTrigger = UIEventTriggerListener.Get (btn.gameObject);
            eventTrigger.onPointerExit = new UnityEngine.Events.UnityAction (() => {
                listener.Call (table, btn, param);
            });
        }
    }

    public void AddButtonEventListener (Button btn, ButtonListener listener) {
        if (btn != null) {
            mAddListenerComList.Add (btn);
            btn.onClick.AddListener (new UnityEngine.Events.UnityAction (() => {
                if (BattleMgr.Instance.IsRotatingCam) return;

                if (UIEventStatus) return;

                UIEventStatus = true;
                timerSeq = TimerManager.Instance.AddTimer (interTime, 1, ResetUIEventStatus);

                ClickButton (btn);
                listener (btn);
            }));
        }
    }
    public void AddButtonEventListener (Button btn, LuaFunction listener) {
        if (btn != null) {
            mAddListenerComList.Add (btn);
            btn.onClick.AddListener (new UnityEngine.Events.UnityAction (() => {
                if (BattleMgr.Instance.IsRotatingCam) return;

                if (UIEventStatus) return;

                UIEventStatus = true;
                timerSeq = TimerManager.Instance.AddTimer (interTime, 1, ResetUIEventStatus);

                ClickButton (btn);
                listener.Call (btn);
            }));
        }
    }

    public void AddButtonEventListener (Button btn, LuaTable table, LuaFunction listener) {
        if (btn != null) {
            mAddListenerComList.Add (btn);
            btn.onClick.AddListener (new UnityEngine.Events.UnityAction (() => {
                if (BattleMgr.Instance.IsRotatingCam) return;

                if (UIEventStatus) return;

                UIEventStatus = true;
                timerSeq = TimerManager.Instance.AddTimer (interTime, 1, ResetUIEventStatus);

                ClickButton (btn);
                listener.Call (table, btn);
            }));
        }
    }

    public void AddButtonEventListener (Button btn, ButtonListenerWithParam listener, params object[] param) {
        if (btn != null) {
            mAddListenerComList.Add (btn);
            btn.onClick.AddListener (new UnityEngine.Events.UnityAction (() => {
                if (BattleMgr.Instance.IsRotatingCam) return;

                if (UIEventStatus) return;

                UIEventStatus = true;
                timerSeq = TimerManager.Instance.AddTimer (interTime, 1, ResetUIEventStatus);

                ClickButton (btn);
                listener (btn, param);
            }));
        }
    }

    public void AddButtonEventListener (Button btn, LuaTable table, LuaFunction listener, params object[] param) {
        if (btn != null) {
            mAddListenerComList.Add (btn);
            btn.onClick.AddListener (new UnityEngine.Events.UnityAction (() => {
                if (BattleMgr.Instance.IsRotatingCam) return;

                if (UIEventStatus) return;

                UIEventStatus = true;
                timerSeq = TimerManager.Instance.AddTimer (interTime, 1, ResetUIEventStatus);

                ClickButton (btn);
                listener.Call (table, btn, param);
            }));
        }
    }

    public void AddButtonUniqueEventListener (Button btn, LuaTable table, LuaFunction listener, params object[] param) {
        if (btn != null) {
            mAddListenerComList.Add (btn);
            btn.onClick.RemoveAllListeners ();
            btn.onClick.AddListener (new UnityEngine.Events.UnityAction (() => {
                if (BattleMgr.Instance.IsRotatingCam) return;

                ClickButton (btn);
                listener.Call (table, btn, param);
            }));
        }
    }

    public void AddToggleEventListener (Toggle tog, ToggleListener listener) {
        if (tog != null) {
            mAddListenerComList.Add (tog);
            tog.onValueChanged.AddListener (new UnityEngine.Events.UnityAction<bool> ((b) => {
                if (BattleMgr.Instance.IsRotatingCam) return;

                if (b)
                    ClickToggle (tog);
                listener (b);
            }));
        }
    }

    public void AddToggleEventListener (Toggle tog, LuaFunction listener) {
        if (tog != null) {
            mAddListenerComList.Add (tog);
            tog.onValueChanged.AddListener (new UnityEngine.Events.UnityAction<bool> ((b) => {
                if (BattleMgr.Instance.IsRotatingCam) return;

                if (b && !tog.isOn)
                {
                    ClickToggle(tog);
                }
                listener.Call (b);
            }));
        }
    }

    public void AddToggleEventListener (Toggle tog, ToggleListenerWithParams listener, params object[] param) {
        if (tog != null) {
            mAddListenerComList.Add (tog);
            tog.onValueChanged.AddListener (new UnityEngine.Events.UnityAction<bool> ((b) => {
                if (BattleMgr.Instance.IsRotatingCam) return;

                if (b)
                    ClickToggle (tog);
                listener (tog, param);
            }));
        }
    }

    public void AddToggleEventListener (Toggle tog, LuaTable luaTbl, LuaFunction listener, object param) {
        if (tog != null) {
            mAddListenerComList.Add (tog);
            tog.onValueChanged.AddListener (new UnityEngine.Events.UnityAction<bool> ((b) => {
                if (BattleMgr.Instance.IsRotatingCam) return;

                if (b && !tog.isOn) {
                    ClickToggle (tog);
                }
                listener.Call (luaTbl, tog, param, b);
            }));
        }
    }

    public void AddToggleUniqueEventListener(Toggle tog, LuaTable luaTbl, LuaFunction listener, params object[] param)
    {
        if (tog != null)
        {
            mAddListenerComList.Add(tog);
            tog.onValueChanged.RemoveAllListeners();
            tog.onValueChanged.AddListener(new UnityEngine.Events.UnityAction<bool>((b) => {
                if (BattleMgr.Instance.IsRotatingCam) return;

                if (b && !tog.isOn)
                {
                    ClickToggle(tog);
                }
                listener.Call(luaTbl, tog, param, b);
            }));
        }
    }

    public void AddToggleEventListener (Toggle tog, LuaFunction listener, params object[] param) {
        if (tog != null) {
            mAddListenerComList.Add (tog);
            tog.onValueChanged.AddListener (new UnityEngine.Events.UnityAction<bool> ((b) => {
                if (BattleMgr.Instance.IsRotatingCam) return;

                if (b && !tog.isOn)
                {
                    ClickToggle(tog);
                }
                listener.Call (tog, param, b);
            }));
        }
    }

    public void AddSliderEventListener (Slider slider, LuaTable luaTbl, LuaFunction listener, params object[] param) {
        if (slider != null) {
            mAddListenerComList.Add (slider);
            slider.onValueChanged.AddListener (new UnityEngine.Events.UnityAction<float> ((b) => {
                if (BattleMgr.Instance.IsRotatingCam) return;

                listener.Call (luaTbl, slider, b, param);
            }));
        }
    }

    public void AddSliderUniqueEventListener(Slider slider, LuaTable luaTbl, LuaFunction listener, params object[] param) {
        if (slider != null) {
            mAddListenerComList.Add (slider);
            slider.onValueChanged.RemoveAllListeners();
            slider.onValueChanged.AddListener (new UnityEngine.Events.UnityAction<float> ((b) => {
                if (BattleMgr.Instance.IsRotatingCam) return;

                listener.Call (luaTbl, slider, b, param);
            }));
        }
    }
    public void AddInputFileEventListener (InputField inputField, LuaFunction listener) {
        if (inputField != null) {
            mAddListenerComList.Add (inputField);
            inputField.onValueChanged.AddListener (new UnityEngine.Events.UnityAction<string> ((str) => {
                if (BattleMgr.Instance.IsRotatingCam) return;

                listener.Call (inputField, str);
            }));
        }
    }

    public void AddTMPInputFileEventListener(TMP_InputField inputField, LuaFunction listener)
    {
        if (inputField != null)
        {
            mAddListenerComList.Add(inputField);
            inputField.onValueChanged.AddListener(new UnityEngine.Events.UnityAction<string>((str) => {
                listener.Call(inputField, str);
            }));
        }
    }

    public void AddDropdownEventListener (Dropdown dropdown, LuaFunction listener) {
        if (dropdown != null) {
            mAddListenerComList.Add (dropdown);
            dropdown.onValueChanged.AddListener (new UnityEngine.Events.UnityAction<int> ((value) => {
                if (BattleMgr.Instance.IsRotatingCam) return;

                listener.Call (dropdown, value);
            }));
        }
    }

    public void AddUIEventHandlerClickListener (UIEventHandler handler, LuaFunction listener) {
        if (handler == null) return;
        handler.onClick.AddListener (new UnityEngine.Events.UnityAction<GameObject> ((value) => {
            if (BattleMgr.Instance.IsRotatingCam) return;

            listener.Call (value);
        }));
    }

    public void AddScrollRectValueChangeListener (ScrollRect scrollRect, LuaTable luaTbl, LuaFunction listener) {
        if (scrollRect == null) return;
        scrollRect.onValueChanged.AddListener (new UnityEngine.Events.UnityAction<Vector2> ((value) => {
            if (BattleMgr.Instance.IsRotatingCam) return;

            listener.Call (luaTbl, scrollRect, value);
        }));
    }

    public void InvokeToggle (Toggle tog, bool isOn) {
        if (tog != null) tog.onValueChanged.Invoke (isOn);
    }

    public GameObject FindChildGo(string childName)
    {
        if (mChildGoes == null) return null;

        GameObject go;
        mChildGoes.TryGetValue(childName, out go);
        return go;
    }

    void ClickButton (Button btn) {
        //处理点击button的通用行为
        if (btn != null)
        {
            UIPlaySound holder = null;
            if (!mBtnClickSoundHolderDict.TryGetValue(btn, out holder))
            {
                holder = btn.gameObject.GetComponent<UIPlaySound>();
                mBtnClickSoundHolderDict.Add(btn, holder);
            }

            if (holder != null)
            {
                holder.OnClick();
            }
            else
            {
                MusicMgr.Instance.PlayUISound(UIPlaySound.CommonClickSound, false);
            } 
        }
        else
        {
            MusicMgr.Instance.PlayUISound(UIPlaySound.CommonClickSound, false);
        }
    }

    void ClickToggle (Toggle tog) 
    {
        //处理点击button的通用行为
        if (tog != null)
        {
            UIPlaySound holder = null;
            if (!mBtnClickSoundHolderDict.TryGetValue(tog, out holder))
            {
                holder = tog.gameObject.GetComponent<UIPlaySound>();
                mBtnClickSoundHolderDict.Add(tog, holder);
            }

            if (holder != null)
            {
                holder.OnClick();
            }
            else
            {
                MusicMgr.Instance.PlayUISound(UIPlaySound.CommonClickSound, false);
            }
        }
        else
        {
            MusicMgr.Instance.PlayUISound(UIPlaySound.CommonClickSound, false);
        }
    }
    #endregion
}