using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using System.Collections.Generic;
using LuaInterface;
using System;

public class UIMgr : SingletonMono<UIMgr>
{
    public readonly int mUIStackCountLimit = 5;

    public static int SCREEN_WIDTH = 1080;
    public static int SCREEN_HEIGHT = 1920;

    private const int c_DefaultScreenWidth = 1080;
    private const int c_DefaultScreenHeight = 1920;

    private Dictionary<int, UIBase.UIPageCreator> mUIPageCreators = new Dictionary<int, UIBase.UIPageCreator>();

    private RuntimeAnimatorController[] mCommAnimatorCtrllers = null;

    private GameObject mUIRoot = null;
    private Transform mUIRootTrans = null;
    public Transform UIRootTrans
    {
        get { return mUIRootTrans; }
    }

    private GameObject mBattleUIRoot = null;
    private Transform mBattleUIRootTrans;
    public Transform UIBattleRootTrans
    {
        get { return mBattleUIRootTrans; }
    }

    private Transform mMainFunPage = null;
    public Transform MainFunPage
    {
        get { return mMainFunPage; }
    }

    private Dictionary<int, UIBase> mUIPagePool = new Dictionary<int, UIBase>();

    private List<int> mOpenedTotalList = new List<int>();

    private Stack<UIBase> mUIPageStack = new Stack<UIBase>();
    private List<UIBase> mRemovedPages = new List<UIBase>();
    private List<UIBase> mHidePages = new List<UIBase>();
    private List<int> mHideTmpPages = new List<int>();

    private UIBase mCurrentPage = null;
    private bool isOpening = false;          //是否正在打开界面
    private bool isDragingCam = false;      //正在拖动相机
    private bool bInitScreenWid = false;

    private Transform mLaunchImgGo = null;
    private Transform mClickEffectTrans = null;
    private GameObject mClickEffectGo = null;
    [NoToLua]
    public Transform ClickEffectTrans
    {
        get { return mClickEffectTrans; }
    }

    private Canvas mCanv = null;

    private LuaFunction mClickLuaFun;

    private Vector3 mClickMousePos = Vector3.zero;

    public Vector3 ClickMousePos
    {
        get { return mClickMousePos; }
    }

    public UIBase CurrentPage
    {
        get { return mCurrentPage; }
    }

    public int PageCnt
    {
        get { return mUIPageStack.Count; }
    }

    public int PageOrderingSort
    {
        get
        {
            int order = 1;
            Stack<UIBase>.Enumerator iter = mUIPageStack.GetEnumerator();
            while (iter.MoveNext())
            {
                var page = iter.Current;
                if (page.SortingOrder > order)
                {
                    order = page.SortingOrder;
                }
            }
            iter.Dispose();
            return order;
        }
    }

    public bool IsUIOpening
    {
        get { return isOpening; }
    }

    public override void InitMgr()
    {
        base.InitMgr();
        Init();

        ResgisterEvents();
    }

    public void SetClickLuaFun(LuaFunction func)
    {
        mClickLuaFun = func;
    }

    public void ShowSplash()
    {
        if (mLaunchImgGo != null)
        {
            mLaunchImgGo.gameObject.SetActive(true);
        }
    }

    protected override void Dispose()
    {
        mClickLuaFun = null;
        UnRegisterEvents();

        DisposeInputMask();
        base.Dispose();
    }

    void Init()
    {
        DontDestroyOnLoad(this.gameObject);
        mUIRoot = GameObject.Find("UIRoot");
        mBattleUIRoot = GameObject.Find("BattleUIRoot");
        if (mUIRoot == null)
        {
            mUIRoot = new GameObject("UIRoot");
            InitRoot();
        }
        else
        {
            InitRoot();
        }
    }

    void InitRoot()
    {
        float matchWidthOrHeight = 0;
        Vector2 referenceResolution = new Vector2(c_DefaultScreenWidth, c_DefaultScreenHeight);
        SafeRectCheck safeRectCheck = SafeRectCheck.Instance;
        if (safeRectCheck)
        {
            int screenWidth = Screen.width;
            int screenHeight = Screen.height;
            Rect safeArea = safeRectCheck.safeArea;
            float scaleW = c_DefaultScreenWidth / safeArea.width;
            float scaleH = c_DefaultScreenHeight / safeArea.height;
            // 扩展分辨率到非安全区域外，这样安全区域的分辨率才为设计分辨率
            if (scaleW >= scaleH)
            {
                matchWidthOrHeight = 0;
                referenceResolution.x = screenWidth * scaleW;
            }
            else
            {
                matchWidthOrHeight = 1;
                referenceResolution.y = screenHeight * scaleH;
            }
        }
        else
        {
            int screenWidth = Screen.width;
            int screenHeight = Screen.height;
            float scaleW = c_DefaultScreenWidth / screenWidth;
            float scaleH = c_DefaultScreenHeight / screenHeight;
            matchWidthOrHeight = ((scaleW >= scaleH) ? 0 : 1);
        }


        mLaunchImgGo = mUIRoot.transform.Find("LaunchImg");
        mClickEffectTrans = mUIRoot.transform.Find("ClickEffect");
        if (mClickEffectTrans != null)
        {
            mClickEffectGo = mClickEffectTrans.gameObject;
            mClickEffectGo.SetActive(false);
        }
        DontDestroyOnLoad(mUIRoot);
        DontDestroyOnLoad(mBattleUIRoot);

        mUIRootTrans = mUIRoot.transform;
        // mUIRootTrans.localPosition = Vector3.zero;
        // mUIRootTrans.localScale = Vector3.one;

        mMainFunPage = mUIRootTrans.Find("UIMainFunctionUIButton");

        mCanv = mUIRoot.GetComponent<Canvas>();
        if (mCanv == null)
        {
            mCanv = mUIRoot.AddComponent<Canvas>();
            mCanv.renderMode = RenderMode.ScreenSpaceOverlay;
        }

        SafeAreaCanvasScaler scaler = mUIRoot.GetComponent<SafeAreaCanvasScaler>();
        if (scaler == null)
        {
            scaler = mUIRoot.AddComponent<SafeAreaCanvasScaler>();
        }
        scaler.uiScaleMode = CanvasScaler.ScaleMode.ScaleWithScreenSize;
        scaler.screenMatchMode = CanvasScaler.ScreenMatchMode.MatchWidthOrHeight;
        scaler.referenceResolution = referenceResolution;
        scaler.matchWidthOrHeight = matchWidthOrHeight;
        scaler.ImmediatelyUpdate();

        if (mBattleUIRoot != null)
        {
            scaler = mBattleUIRoot.GetComponent<SafeAreaCanvasScaler>();
            if (scaler == null)
            {
                scaler = mBattleUIRoot.AddComponent<SafeAreaCanvasScaler>();
            }
            scaler.uiScaleMode = CanvasScaler.ScaleMode.ScaleWithScreenSize;
            scaler.screenMatchMode = CanvasScaler.ScreenMatchMode.MatchWidthOrHeight;
            scaler.referenceResolution = referenceResolution;
            scaler.matchWidthOrHeight = matchWidthOrHeight;
            mBattleUIRootTrans = mBattleUIRoot.transform;
            scaler.ImmediatelyUpdate();
        }

        GraphicRaycaster gr = mUIRoot.GetComponent<GraphicRaycaster>();
        if (gr == null)
        {
            mUIRoot.AddComponent<GraphicRaycaster>();
        }
        mUIRoot.layer = LayerMask.NameToLayer("UI");

        // StartCoroutine(CheckScreen());
        RectTransform mUIRootRT = mUIRoot.GetComponent<RectTransform>();
        SCREEN_WIDTH = (int)mUIRootRT.rect.width;
        SCREEN_HEIGHT = (int)mUIRootRT.rect.height;
    }

    IEnumerator CheckScreen()
    {
        if (bInitScreenWid) yield break;

        yield return new WaitForSeconds(0.1f);

        RectTransform mUIRootRT = mUIRoot.GetComponent<RectTransform>();
        SCREEN_WIDTH = (int)mUIRootRT.rect.width;
        SCREEN_HEIGHT = (int)mUIRootRT.rect.height;

        bInitScreenWid = true;

        //DebugHelper.LogError("SCREEN_WIDTH:" + SCREEN_WIDTH + " SCREEN_HEIGHT:" + SCREEN_HEIGHT);
    }

    void ResgisterEvents()
    {
        EventMgr.AddEventListener<int>(ECoreEventType.EID_UI_LoadFail, OnUILoadFail);
        EventMgr.AddEventListener<int>(ECoreEventType.EID_UI_LoadSuccess, OnUILoadSucess);
        EventMgr.AddEventListener<bool>(ECoreEventType.EID_DragCamera, OnDragCamera);
        EventMgr.AddEventListener<int>(ECoreEventType.EID_UI_CLOSE, OnUIClose);
        EventMgr.AddEventListener<int>(ECoreEventType.EID_UI_SHOW, OnUIShow);

        SafeRectCheck safeRectCheck = SafeRectCheck.Instance;
        if (safeRectCheck)
            safeRectCheck.onChangedCanvas.AddListener(Init);
    }

    void UnRegisterEvents()
    {
        EventMgr.RemoveEventListener<int>(ECoreEventType.EID_UI_LoadFail, OnUILoadFail);
        EventMgr.RemoveEventListener<int>(ECoreEventType.EID_UI_LoadSuccess, OnUILoadSucess);
        EventMgr.RemoveEventListener<bool>(ECoreEventType.EID_DragCamera, OnDragCamera);
        EventMgr.RemoveEventListener<int>(ECoreEventType.EID_UI_CLOSE, OnUIClose);
        EventMgr.RemoveEventListener<int>(ECoreEventType.EID_UI_SHOW, OnUIShow);

        SafeRectCheck safeRectCheck = SafeRectCheck.Instance;
        if (safeRectCheck)
            safeRectCheck.onChangedCanvas.RemoveListener(Init);
    }

    public void RegisterPage(int pageId, UIBase.UIPageCreator creator)
    {
        if (mUIPageCreators.ContainsKey(pageId)) return;

        mUIPageCreators.Add(pageId, creator);
    }

    private void Update()
    {
        if (mRemovedPages.Count > 0)
        {
            bool canClear = true;
            bool needGC = false;
            for (int idx = 0; idx < mRemovedPages.Count; idx++)
            {
                if (mRemovedPages[idx].IsPageAnimation)
                {
                    canClear = false;
                }
                else
                {
                    if (!mRemovedPages[idx].NeedCache)
                        needGC = true;

                    mRemovedPages[idx].Dispose();
                }
            }
            if (canClear)
                mRemovedPages.Clear();

            if (needGC)
            {
                MemoryUtil.ReleaseMemory();
            }
        }
    }

    void OnUILoadFail(CoreEvent<int> ce)
    {
        isOpening = false;
    }

    void OnUILoadSucess(CoreEvent<int> ce)
    {
        isOpening = false;

        int pageId = ce.Data;

        UIBase page = GetPage(pageId);
        if (page == null)
            return;

        mUIPageStack.Push(page);

        if (mLaunchImgGo != null)
        {
            mLaunchImgGo.gameObject.SetActive(false);
        }

        ResetPageLayerSameType(page.MUIType);
    }

    bool IsInForceGuide(int pageId)
    {
        if (pageId == 164) return false;

        UIBase page = GetPage(164);
        if (page == null)
            return false;

        if (page.IsShowed)
            return true;

        return false;
    }

    void OnUIClose(CoreEvent<int> ce)
    {
        CheckSceneCameraEnable();

        //重置layer
        ResetPageLayerSameType(ce.Data);
    }

    void ResetPageLayerSameType(int type)
    {
        int ordering = 0;
        UIBase[] uiBases = mUIPageStack.ToArray();
        for (int i = uiBases.Length - 1; i >= 0; i--)
        {
            var page = uiBases[i];
            if (page.MUIType == type)
            {
                ordering += 5;
                if (page.SortingOrder != (ordering + page.initSortingOrder))
                {
                    page.SortingOrder = (ordering + page.initSortingOrder);
                }
            }
        }
    }

    void OnUIShow(CoreEvent<int> ce)
    {
        int pageId = ce.Data;

        UIBase page = GetPage(pageId);
        if (page == null)
            return;

        if (page.MUIType == 0 || page.MUIType == 2)
        {
            ShowUIChangeTotalSortList(page.MUIType, page.PageId);
        }

        CheckSceneCameraEnable();
    }

    public LuaUIBase[] GetCurUIStack()
    {
        UIBase[] array1 = mUIPageStack.ToArray() as UIBase[];
        LuaUIBase[] array = new LuaUIBase[array1.Length];
        for (int i = 0; i < array1.Length; ++i)
        {
            array[i] = (LuaUIBase)array1[i];
        }
        return array;
    }

    void OnDragCamera(CoreEvent<bool> ce)
    {

    }

    void RemovePageFromStack(int pageId)
    {
        UIBase[] temps = mUIPageStack.ToArray();
        bool bfound = false;
        for (int i = 0; i < temps.Length; ++i)
        {
            if (temps[i] && temps[i].PageId == pageId)
            {
                bfound = true;
            }
        }

        if (bfound)
        {
            mUIPageStack.Clear();
            for (int i = temps.Length - 1; i >= 0; --i)
            {
                if (temps[i] != null && temps[i].PageId != pageId)
                    mUIPageStack.Push(temps[i]);
            }
        }

        temps = null;
    }

    public void Open(int pageID, object param = null)
    {
        if (!CanOpen()) return;

        DebugHelper.LogWarning("open pageId:" + pageID);

        UIBase.UIPageCreator creator;
        if (!mUIPageCreators.ContainsKey(pageID))
        {
            DebugHelper.LogError("Page has not register:" + pageID);
            return;
        }

        if (mCurrentPage != null && mCurrentPage.PageId == pageID)
        {
            mCurrentPage.Show();
            return;
        }
        else
        {
            creator = mUIPageCreators[pageID];
            UIBase page = creator();

            mUIPagePool.Add(pageID, page);
            isOpening = true;
            page.Open(null, param);

            this.mCurrentPage = page;
        }
    }

    bool IsTotlePageInAnimation()
    {
        foreach (var entity in mUIPagePool)
        {
            var page = entity.Value;
            if (page.MUIType == 0 && page.IsPageAnimation)
            {
                return true;
            }
        }
        return false;
    }

    public bool HasExistPageByUIType(int uiType)
    {
        foreach (var p in mUIPagePool)
        {
            if (p.Value != null && p.Value.MUIType == uiType)
            {
                return true;
            }
        }

        return false;
    }

    public void LuaOpenUI(LuaTable pageData, LuaTable luaView, int initSortingOrder, object param, int sourceUIId, bool needOutAnim = true)
    {
        //DebugHelper.LogError("LuaOpenUI---------------------------------");
        if (!CanOpen()) return;

        int pageID = Convert.ToInt32(pageData["id"]);

        //DebugHelper.LogError("open pageId:" + pageID);

        if (mCurrentPage != null && mCurrentPage.PageId == pageID)
        {
            mCurrentPage.Show(param);
            return;
        }
        else
        {
            try
            {
                string name = (string)pageData["name"];
                UI_ANIM inAni = (UI_ANIM)Convert.ToInt32(pageData["page_anim_in_type"]);
                UI_ANIM outAni = (UI_ANIM)Convert.ToInt32(pageData["page_anim_out_type"]);
                string resPath = (string)pageData["res_path"];
                string childPaths = (string)pageData["childPaths"];
                bool needPersistent = (bool)pageData["need_persistent"];
                bool bShowTopBtn = (bool)pageData["top_btn_display_state"];
                int uiType = Convert.ToInt32(pageData["type"]);
                bool battleMainPage = false;
                bool.TryParse(pageData["battle_main_page"].ToString(), out battleMainPage);

                bool needCache = true;
                if (!bool.TryParse(pageData["need_cache"].ToString(), out needCache))
                {
                    needCache = true;
                }

                if (uiType == 0)
                {
                    if (IsTotlePageInAnimation())
                    {
                        return;
                    }
                }

                UIBase page = GetPage(pageID);
                if (page != null)
                {
                    Show(pageID, param, needOutAnim);
                    return;
                }

                page = GetPageFromRemoveList(pageID);
                if (page != null)
                {
                    page.Dispose();
                    //mUIPagePool.Add(pageID, page);
                    //Show(pageID, param, needOutAnim);
                    //return;
                }


                LuaUIBase page1 = Instance.gameObject.AddComponent<LuaUIBase>();
                page1.PageId = pageID;
                page1.PageAnimInType = inAni;
                page1.PageAnimOutType = outAni;
                page1.StrAssetBundle = resPath;
                page1.ChildPaths = childPaths;
                page1.MLuaTable = luaView;
                page1.MPersistentStatus = needPersistent;
                page1.MUIType = uiType;
                page1.initSortingOrder = initSortingOrder;
                page1.MPageName = name;
                page1.MSourceUIID = sourceUIId;
                page1.IsBattleMainPage = battleMainPage;
                page1.NeedCache = needCache;
                page1.ShowTopBtn = bShowTopBtn;
                /*if (page1.MSourceUIID == 0 && mCurrentPage != null)
                {
                    page1.MSourceUIID = mCurrentPage.PageId;
                }*/

                mUIPagePool.Add(pageID, page1);
                isOpening = true;
                page1.Open(null, param);

                mCurrentPage = page1;
            }
            catch (System.Exception e)
            {
                DebugHelper.LogError(e.Message);
            }
        }
    }

    public void ShowUIChangeTotalSortList(int uiType, int pageId)
    {
        if (mOpenedTotalList.Contains(pageId))
        {
            return;
        }

        if (uiType == 0)
        {
            if (mOpenedTotalList.Count > 0)
            {
                mOpenedTotalList[0] = pageId;

                if (mOpenedTotalList.Count > 2)
                {
                    Close(mOpenedTotalList[2]);
                    mOpenedTotalList.RemoveAt(2);
                }
                if (mOpenedTotalList.Count > 1)
                {
                    Close(mOpenedTotalList[1]);
                    mOpenedTotalList.RemoveAt(1);
                }
            }
            else
                mOpenedTotalList.Add(pageId);
        }
        else
        {
            if (mOpenedTotalList.Count > 3)
            {
                Close(mOpenedTotalList[1]);
                mOpenedTotalList[1] = mOpenedTotalList[2];
                mOpenedTotalList[2] = pageId;
            }
            else
            {
                mOpenedTotalList.Add(pageId);
                if (mOpenedTotalList.Count > 2)
                    Hide(mOpenedTotalList[mOpenedTotalList.Count - 2]);
            }
        }
    }

    public void CloseUIChangeTotalSortList(UIBase page)
    {
        if (mOpenedTotalList.Count == 0) return;

        int idx = mOpenedTotalList.IndexOf(page.PageId);
        if (idx < 0)
            return;

        mOpenedTotalList.RemoveAt(idx);
        if (mOpenedTotalList.Count > 0)
            Show(mOpenedTotalList[idx - 1]);
    }

    public void Close(int pageId, bool igoreCheckCamera = false, bool needOutAnim = true)
    {
        //DebugHelper.Log("Close Page:" + pageId);
        UIBase page = GetPage(pageId);
        if (page == null) return;

        if (page.MPersistentStatus)
        {
            Hide(page.PageId, needOutAnim);
            return;
        }

        RemovePageFromStack(pageId);
        mUIPagePool.Remove(pageId);
        mRemovedPages.Add(page);

        /*if (mUIPageStack.Count > 0)
        {
            mCurrentPage = mUIPageStack.Peek();
            mCurrentPage.BackIn();
        }*/
        page.Close(needOutAnim);

        /*if (mUIPageStack.Count > 0)
        {
            mCurrentPage = mUIPageStack.Peek();
        }*/
        if (page.MUIType == 2)
        {
            CloseUIChangeTotalSortList(page);
        }
        else
        {
            if (mUIPageStack.Count > 0)
            {
                mCurrentPage = mUIPageStack.Peek();
            }
        }
    }

    public void Show(int pageId, object param = null, bool needOutAnim = true)
    {
        UIBase page = GetPage(pageId);

        if (page != null)
        {
            if (page.MUIType == 0 || page.MUIType == 2)
            {
                ShowUIChangeTotalSortList(page.MUIType, pageId);
            }
        }

        if (page != null)
        {
            for (int idx = mHidePages.Count - 1; idx >= 0; idx--)
            {
                if (mHidePages[idx].PageId == pageId)
                {
                    mHidePages.RemoveAt(idx);
                    mUIPageStack.Push(page);
                    break;
                }
            }
            mCurrentPage = page;
            page.Show(param, needOutAnim);
        }
    }

    public void Hide(int pageId, bool needOutAnim = true)
    {
        UIBase page = GetPage(pageId);
        if (page != null)
        {
            if (!page.IsHide)
            {
                page.Hide(false);
                RemovePageFromStack(pageId);
                if (!mHidePages.Contains(page))
                    mHidePages.Add(page);


                if (mUIPageStack.Count > 0)
                {
                    mCurrentPage = mUIPageStack.Peek();
                    mCurrentPage.BackIn();
                }
            }
        }
    }

    public bool CanOpen()
    {
        /*if (IsUIOpening)
        {
            return false;
        }*/

        if (isDragingCam)
        {
            return false;
        }

        return true;
    }

    public bool PageInHideStack(UIBase page)
    {
        return mHidePages.Contains(page);
    }

    public UIBase GetPageFromRemoveList(int pageId)
    {
        UIBase page = null;
        for (int i = 0; i < mRemovedPages.Count; ++i)
        {
            if (mRemovedPages[i].PageId == pageId)
            {
                page = mRemovedPages[i];
                mRemovedPages.RemoveAt(i);
                break;
            }
        }
        return page;
    }

    [NoToLua]
    public int GetNextPageOrderingSort(UIBase curPage)
    {
        int ordering = 0;
        UIBase[] uiBases = mUIPageStack.ToArray();
        for (int i = uiBases.Length - 1; i >= 0; i--)
        {
            var page = uiBases[i];
            if (page.PageUniqueID != curPage.PageUniqueID && page.MUIType == curPage.MUIType)
            {
                ordering += 5;
                // 重新设置，避免SortingOrder无限增长
                if (page.SortingOrder != (ordering + page.initSortingOrder))
                {
                    page.SortingOrder = (ordering + page.initSortingOrder);
                }
            }
        }
        // Stack<UIBase>.Enumerator iter = mUIPageStack.GetEnumerator();
        // while (iter.MoveNext())
        // {
        //     var page = iter.Current;
        //     if (page.PageUniqueID != curPage.PageUniqueID && page.MUIType == curPage.MUIType)
        //     {
        //         ordering += 5;
        //         // 重新设置，避免SortingOrder无限增长
        //         if (page.SortingOrder != (ordering + page.initSortingOrder))
        //         {
        //             page.SortingOrder = (ordering + page.initSortingOrder);
        //         }
        //     }
        // }
        // iter.Dispose();
        ordering += 5;

        return ordering;
    }

    public int GetNextPageOrderingSort(int type, int pageId)
    {
        int ordering = 0;
        Stack<UIBase>.Enumerator iter = mUIPageStack.GetEnumerator();
        while (iter.MoveNext())
        {
            var page = iter.Current;
            if (page.SortingOrder > ordering && page.PageId != pageId && page.MUIType == type)
            {
                ordering += 5;
            }
        }
        iter.Dispose();
        ordering += 6;

        return ordering;
    }

    public RuntimeAnimatorController GetAnimatorController(UI_ANIM animType)
    {
        if (mCommAnimatorCtrllers == null)
            return null;

        RuntimeAnimatorController anim = null;
        /*switch (animType)
        {
            case UI_ANIM.FADEIN:
                anim = mCommAnimatorCtrllers[0];
                break;
            case UI_ANIM.FADEOUT:
                anim = mCommAnimatorCtrllers[1];
                break;
            case UI_ANIM.LEFTIN:
                anim = mCommAnimatorCtrllers[2];
                break;
            case UI_ANIM.TOPIN:
                anim = mCommAnimatorCtrllers[3];
                break;
            case UI_ANIM.SCALEIN:
                anim = mCommAnimatorCtrllers[4];
                break;
            case UI_ANIM.RIGHTOUT:
                anim = mCommAnimatorCtrllers[5];
                break;
        }*/

        return anim;
    }

    public UIBase GetPage(int pageId)
    {
        UIBase page;
        mUIPagePool.TryGetValue(pageId, out page);
        return page;
    }

    [NoToLua]
    public void CheckSceneCameraEnable()
    {
        if (!HasBattleMainPage() && HasOpenOtherScreenPage())
        {
            BattleCamera.Instance.DisableBattleCam();
        }
        else
        {
            if (BattleMgr.Instance.IsPlayingComingCamera()) return;

            BattleCamera.Instance.EnableBattleCam();
        }
    }

    private bool HasOpenOtherScreenPage()
    {
        if (mUIPageStack.Count == 0) return false;


        Stack<UIBase>.Enumerator iter = mUIPageStack.GetEnumerator();
        while (iter.MoveNext())
        {
            var page = iter.Current;
            if ((page.MUIType == 0 || page.MUIType == 2) && page.CanvasEnabled && !page.IsPageAnimation && !page.IsBattleMainPage)
            {
                return true;
            }
        }
        return false;
    }

    public bool HasBattleMainPage()
    {
        Stack<UIBase>.Enumerator iter = mUIPageStack.GetEnumerator();
        while (iter.MoveNext())
        {
            var page = iter.Current;
            if (page.IsBattleMainPage)
            {
                return true;
            }
        }
        return false;
    }

    public int GetCurrentBattlePageId()
    {
        Stack<UIBase>.Enumerator iter = mUIPageStack.GetEnumerator();
        while (iter.MoveNext())
        {
            var page = iter.Current;
            if (page.IsBattleMainPage && page.MUIType == 0)
            {
                return page.PageId;
            }
        }
        return 0;
    }

    public void ClosePageByMUIType(int muiType)
    {
        UIBase[] temps = mUIPageStack.ToArray();
        for (int i = 0, iMax = temps.Length; i < iMax; i++)
        {
            UIBase uiBase = temps[i];
            if (uiBase == null) continue;
            if (uiBase.MUIType == muiType)
            {
                Close(uiBase.PageId, (uiBase.MUIType == 7));
            }
        }
    }

    public void CloseAllPage()
    {
        CloseAllPagesExceptId(0);
    }

    public void CloseAllPagesExceptIdAndPersistentWnd(int pageId)
    {
        mOpenedTotalList.Clear();

        mHideTmpPages.Clear();

        foreach (var p in mUIPagePool)
        {
            if (p.Value != null && p.Value.PageId != pageId && !p.Value.MPersistentStatus && p.Value.MUIType >= 0 && p.Value.MUIType < 5)
            {
                mHideTmpPages.Add(p.Key);
                RemovePageFromStack(p.Value.PageId);
                p.Value.Close();
                mRemovedPages.Add(p.Value);
            }
        }

        for (int i = 0; i < mHideTmpPages.Count; ++i)
        {
            mUIPagePool.Remove(mHideTmpPages[i]);
        }

        //CheckSceneCameraEnable();

        UIBase page = GetPage(pageId);
        if (page && page.MUIType == 0)
        {
            mOpenedTotalList.Add(pageId);
        }
    }

    public void CloseAllPagesExceptId(int pageId)
    {
        mOpenedTotalList.Clear();

        UIBase page = GetPage(pageId);

        foreach (var p in mUIPagePool)
        {
            if (p.Value != null && p.Value.PageId != pageId)
                p.Value.Dispose();
        }
        mUIPagePool.Clear();

        for (int idx = 0; idx < mRemovedPages.Count; idx++)
        {
            mRemovedPages[idx].Dispose();
        }
        mRemovedPages.Clear();

        mUIPageStack.Clear();
        mHidePages.Clear();

        mCurrentPage = null;

        if (page != null)
        {
            mUIPagePool.Add(page.PageId, page);
            Show(pageId);
        }
    }

    public bool HasOpenPage(int pageId)
    {
        UIBase page = GetPage(pageId);
        return page != null && page.CanvasEnabled;
    }

    public void ForceRebuildLayout(float lastVal, RectTransform rect)
    {
        StartCoroutine(UpdateLayout(lastVal, rect));
    }

    [NoToLua]
    IEnumerator UpdateLayout(float lastVal, RectTransform rect)
    {
        yield return new WaitForEndOfFrame();
        LayoutRebuilder.ForceRebuildLayoutImmediate(rect);
        yield return new WaitForEndOfFrame();
        int waitTime = 0;
        LayoutGroup layout = rect.GetComponent<LayoutGroup>();
        while (layout.preferredHeight == lastVal)
        {
            waitTime++;
            LayoutRebuilder.ForceRebuildLayoutImmediate(rect);
            yield return new WaitForEndOfFrame();
            if (waitTime == 5) break;
        }
    }

    public void ForceRebuildLayoutImmediate(RectTransform rect)
    {
        LayoutRebuilder.ForceRebuildLayoutImmediate(rect);
    }

    private GameObject m_InputMaskGo;
    private Canvas m_InputMaskCanvas;

    public void OpenInputMask(int sortingOrder)
    {
        if (!m_InputMaskGo)
        {
            m_InputMaskGo = new GameObject("InputMaskGo");
            m_InputMaskGo.AddComponent<UIRaycastNoDraw>().raycastTarget = false;
            RectTransform rectTransform = m_InputMaskGo.GetComponent<RectTransform>();
            rectTransform.SetParent(mUIRootTrans, false);
            rectTransform.localRotation = Quaternion.identity;
            rectTransform.localScale = Vector3.one;
            rectTransform.anchorMin = new Vector2(0, 0);
            rectTransform.anchorMax = new Vector2(1.0f, 1.0f);
            rectTransform.pivot = new Vector2(0.5f, 0.5f);
            rectTransform.anchoredPosition3D = Vector3.zero;
            rectTransform.sizeDelta = Vector2.zero;
        }
        m_InputMaskGo.SetActive(true);
        if (!m_InputMaskCanvas)
        {
            m_InputMaskCanvas = m_InputMaskGo.GetComponent<Canvas>();
            if (!m_InputMaskCanvas)
            {
                m_InputMaskCanvas = m_InputMaskGo.AddComponent<Canvas>();
                m_InputMaskCanvas.overrideSorting = true;
                m_InputMaskGo.AddComponent<GraphicRaycaster>();
            }
        }
        m_InputMaskCanvas.sortingOrder = sortingOrder;
    }

    public void CloseInputMask()
    {
        if (m_InputMaskGo)
            m_InputMaskGo.SetActive(false);
    }

    public void ShowClickEffect(Vector2 pos)
    {
        if (mClickEffectGo != null)
        {
            Vector2 _pos = Vector2.one;
            RectTransformUtility.ScreenPointToLocalPointInRectangle(mUIRootTrans as RectTransform,
                        pos, CameraMgr.Instance.UICamera, out _pos);

            mClickEffectGo.SetActive(false);
            mClickEffectGo.SetActive(true);
            mClickEffectGo.transform.localPosition = _pos;
            mClickMousePos = new Vector3(_pos.x, _pos.y, 0);
            if (mClickLuaFun != null)
            {
                mClickLuaFun.Call();
            }
        }
    }

    private void DisposeInputMask()
    {
        m_InputMaskCanvas = null;
        if (m_InputMaskGo)
        {
            GameObject.Destroy(m_InputMaskGo);
            m_InputMaskGo = null;
        }
    }

    public void RestoreBattleUIVisible()
    {
        if (BattleFlyWordMgr.Instance != null && BattleFlyWordMgr.Instance.HudRoot != null)
            BattleFlyWordMgr.Instance.HudRoot.SetActive(true);
    }

    public Vector2 ScreenPointToLocalPointInRectangle(RectTransform rectTrans, Vector2 screenPoint)
    {
        Vector2 worldPoint = Vector2.zero;
        RectTransformUtility.ScreenPointToLocalPointInRectangle(rectTrans, screenPoint, CameraMgr.Instance.UICamera, out worldPoint);
        return worldPoint;
    }
}
