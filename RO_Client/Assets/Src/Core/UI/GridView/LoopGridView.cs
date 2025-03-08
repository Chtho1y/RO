using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;

namespace SuperScrollView
{

    [System.Serializable]
    public class GridViewItemPrefabConfData
    {
        public GameObject mItemPrefab = null;
        public int mInitCreateCount = 0;
    }


    public class LoopGridViewInitParam
    {
        // all the default values
        public float mSmoothDumpRate = 0.3f;
        public float mSnapFinishThreshold = 0.01f;
        public float mSnapVecThreshold = 145;

        public static LoopGridViewInitParam CopyDefaultInitParam()
        {
            return new LoopGridViewInitParam();
        }
    }


    public class LoopGridViewSettingParam
    {
        public object mItemSize = null;
        public object mPadding = null;
        public object mItemPadding = null;
        public object mGridFixedType = null;
        public object mFixedRowOrColumnCount = null;
    }


    public class LoopGridView : MonoBehaviour, IBeginDragHandler, IEndDragHandler, IDragHandler
    {
        class SnapData
        {
            public SnapStatus mSnapStatus = SnapStatus.NoTargetSet;
            public RowColumnPair mSnapTarget;
            public Vector2 mSnapNeedMoveDir;
            public float mTargetSnapVal = 0;
            public float mCurSnapVal = 0;
            public bool mIsForceSnapTo = false;
            public void Clear()
            {
                mSnapStatus = SnapStatus.NoTargetSet;
                mIsForceSnapTo = false;
            }
        }
        class ItemRangeData
        {
            public int mMaxRow;
            public int mMinRow;
            public int mMaxColumn;
            public int mMinColumn;
            public Vector2 mCheckedPosition;
        }

        Dictionary<string, GridItemPool> mItemPoolDict = new Dictionary<string, GridItemPool>();
        List<GridItemPool> mItemPoolList = new List<GridItemPool>();
        [SerializeField]
        List<GridViewItemPrefabConfData> mItemPrefabDataList = new List<GridViewItemPrefabConfData>();

        [SerializeField]
        private GridItemArrangeType mArrangeType = GridItemArrangeType.TopLeftToBottomRight;
        public GridItemArrangeType ArrangeType { get { return mArrangeType; } set { mArrangeType = value; } }

        [SerializeField]
        private bool mNeedReverse = false;
        public bool NeedReverse { get { return mNeedReverse; } set { mNeedReverse = value; } }

        RectTransform mContainerTrans;
        ScrollRect mScrollRect = null;
        RectTransform mScrollRectTransform = null;
        RectTransform mViewPortRectTransform = null;
        int mItemTotalCount = 0;
        int mRealItemTotalCount = 0;
        [SerializeField]
        int mKeepFillShow = -1;
        [SerializeField]
        int mFixedRowOrColumnCount = 0;
        bool mRefreshRawOrColumn = false;
        int mRealFixedRowOrColumnCount = 0;
        Vector2 mItemAlginOffset = Vector2.zero;
        [SerializeField]
        RectOffset mPadding = new RectOffset();
        [SerializeField]
        Vector2 mItemPadding = Vector2.zero;
        [SerializeField]
        Vector2 mItemSize = Vector2.zero;
        [SerializeField]
        Vector2 mItemRecycleDistance = new Vector2(50, 50);
        Vector2 mItemSizeWithPadding = Vector2.zero;
        Vector2 mStartPadding;
        Vector2 mEndPadding;
        System.Func<LoopGridView, int, int, int, LoopGridViewItem> mOnGetItemByRowColumn;
        System.Action<LoopGridView, int, int, int, LoopGridViewItem> mOnRecycleItem;

        List<GridItemGroup> mItemGroupObjPool = new List<GridItemGroup>();

        //if GridFixedType is GridFixedType.ColumnCountFixed, then the GridItemGroup is one row of the GridView
        //if GridFixedType is GridFixedType.RowCountFixed, then the GridItemGroup is one column of the GridView
        //so mItemGroupList is current all shown rows or columns
        List<GridItemGroup> mItemGroupList = new List<GridItemGroup>();

        bool mIsDraging = false;
        int mRowCount = 0;
        int mColumnCount = 0;
        public System.Action<LoopGridView> mOnBeginDragAction = null;
        public System.Action<LoopGridView> mOnDragingAction = null;
        public System.Action<LoopGridView> mOnEndDragAction = null;
        float mSmoothDumpVel = 0;
        float mSmoothDumpRate = 0.3f;
        float mSnapFinishThreshold = 0.1f;
        float mSnapVecThreshold = 145;
        [SerializeField]
        bool mItemSnapEnable = false;
        [SerializeField]
        GridFixedType mGridFixedType = GridFixedType.ColumnCountFixed;
        public System.Action<LoopGridView, LoopGridViewItem> mOnSnapItemFinished = null;
        //in this callback, use CurSnapNearestItemRowColumn to get cur snaped item row column.
        public System.Action<LoopGridView> mOnSnapNearestChanged = null;
        int mLeftSnapUpdateExtraCount = 1;
        [SerializeField]
        Vector2 mViewPortSnapPivot = Vector2.zero;
        [SerializeField]
        Vector2 mItemSnapPivot = Vector2.zero;
        SnapData mCurSnapData = new SnapData();
        Vector3 mLastSnapCheckPos = Vector3.zero;
        bool mListViewInited = false;
        int mListUpdateCheckFrameCount = 0;
        ItemRangeData mCurFrameItemRangeData = new ItemRangeData();
        int mNeedCheckContentPosLeftCount = 1;
        ClickEventListener mScrollBarClickEventListener1 = null;
        ClickEventListener mScrollBarClickEventListener2 = null;

        [SerializeField]
        private int mSortStartIdx = -1;

        RowColumnPair mCurSnapNearestItemRowColumn;

        public List<GridViewItemPrefabConfData> ItemPrefabDataList
        {
            get
            {
                return mItemPrefabDataList;
            }
        }

        public int ItemTotalCount
        {
            get
            {
                return mItemTotalCount;
            }
        }

        public int RealItemTotalCount
        {
            get
            {
                return mRealItemTotalCount;
            }
        }

        public RectTransform ContainerTrans
        {
            get
            {
                return mContainerTrans;
            }
        }

        public float ViewPortWidth
        {
            get { return mViewPortRectTransform.rect.width; }
        }

        public float ViewPortHeight
        {
            get { return mViewPortRectTransform.rect.height; }
        }

        public ScrollRect ScrollRect
        {
            get
            {
                return mScrollRect;
            }
        }

        public bool IsDraging
        {
            get
            {
                return mIsDraging;
            }
        }

        public bool ItemSnapEnable
        {
            get { return mItemSnapEnable; }
            set { mItemSnapEnable = value; }
        }

        public Vector2 ItemSnapPivot
        {
            get { return mItemSnapPivot; }
            set { mItemSnapPivot = value; }
        }

        public Vector2 ViewPortSnapPivot
        {
            get { return mViewPortSnapPivot; }
            set { mViewPortSnapPivot = value; }
        }

        public Vector2 ItemSize
        {
            get
            {
                return mItemSize;
            }
            set
            {
                SetItemSize(value);
            }
        }

        public Vector2 ItemPadding
        {
            get
            {
                return mItemPadding;
            }
            set
            {
                SetItemPadding(value);
            }
        }

        public Vector2 ItemSizeWithPadding
        {
            get
            {
                return mItemSizeWithPadding;
            }
        }
        public RectOffset Padding
        {
            get
            {
                return mPadding;
            }
            set
            {
                SetPadding(value);
            }
        }


        public GridViewItemPrefabConfData GetItemPrefabConfData(string prefabName)
        {
            foreach (GridViewItemPrefabConfData data in mItemPrefabDataList)
            {
                if (data.mItemPrefab == null)
                {
                    Debug.LogError("A item prefab is null ");
                    continue;
                }
                if (prefabName == data.mItemPrefab.name)
                {
                    return data;
                }

            }
            return null;
        }

        /*
        LoopGridView method is to initiate the LoopGridView component. There are 4 parameters:
        itemTotalCount: the total item count in the GridView, this parameter must be set a value >=0 , then the ItemIndex can be from 0 to itemTotalCount -1.
        onGetItemByRowColumn: when a item is getting in the ScrollRect viewport, and this Action will be called with the item' index and the row and column index as the parameters, to let you create the item and update its content.
        settingParam: You can use this parameter to override the values in the Inspector Setting
        */

        public void InitGridView(int itemTotalCount,
            System.Func<LoopGridView, int, int, int, LoopGridViewItem> onGetItemByRowColumn,
            System.Action<LoopGridView, int, int, int, LoopGridViewItem> onRecycleItem,
            LoopGridViewSettingParam settingParam = null,
            LoopGridViewInitParam initParam = null)
        {
            if (mListViewInited == true)
            {
                Debug.LogError("LoopGridView.InitListView method can be called only once.");
                return;
            }
            mListViewInited = true;
            if (itemTotalCount < 0)
            {
                Debug.LogError("itemTotalCount is  < 0");
                itemTotalCount = 0;
            }
            if (settingParam != null)
            {
                UpdateFromSettingParam(settingParam);
            }
            if (initParam != null)
            {
                mSmoothDumpRate = initParam.mSmoothDumpRate;
                mSnapFinishThreshold = initParam.mSnapFinishThreshold;
                mSnapVecThreshold = initParam.mSnapVecThreshold;
            }
            mScrollRect = gameObject.GetComponent<ScrollRect>();
            if (mScrollRect == null)
            {
                Debug.LogError("ListView Init Failed! ScrollRect component not found!");
                return;
            }
            mCurSnapData.Clear();
            mScrollRectTransform = mScrollRect.GetComponent<RectTransform>();
            mContainerTrans = mScrollRect.content;
            mViewPortRectTransform = mScrollRect.viewport;
            if (mViewPortRectTransform == null)
            {
                mViewPortRectTransform = mScrollRectTransform;
            }
            if (mScrollRect.horizontalScrollbarVisibility == ScrollRect.ScrollbarVisibility.AutoHideAndExpandViewport && mScrollRect.horizontalScrollbar != null)
            {
                Debug.LogError("ScrollRect.horizontalScrollbarVisibility cannot be set to AutoHideAndExpandViewport");
            }
            if (mScrollRect.verticalScrollbarVisibility == ScrollRect.ScrollbarVisibility.AutoHideAndExpandViewport && mScrollRect.verticalScrollbar != null)
            {
                Debug.LogError("ScrollRect.verticalScrollbarVisibility cannot be set to AutoHideAndExpandViewport");
            }
            SetScrollbarListener();
            AdjustViewPortPivot();
            AdjustContainerAnchorAndPivot();
            InitItemPool();
            mOnGetItemByRowColumn = onGetItemByRowColumn;
            mOnRecycleItem = onRecycleItem;
            mNeedCheckContentPosLeftCount = 4;
            mCurSnapData.Clear();
            mItemTotalCount = itemTotalCount;
            UpdateAllGridSetting();

        }


        /*
        This method may use to set the item total count of the GridView at runtime. 
        this parameter must be set a value >=0 , and the ItemIndex can be from 0 to itemCount -1.  
        If resetPos is set false, then the ScrollRect’s content position will not changed after this method finished.
        */
        public void SetListItemCount(int itemCount, bool resetPos = true)
        {
            if (itemCount < 0)
            {
                return;
            }
            if (itemCount == mItemTotalCount)
            {
                return;
            }
            mCurSnapData.Clear();
            mItemTotalCount = itemCount;
            UpdateKeepFillShowItem();
            UpdateColumnRowCount();
            UpdateContentSize();
            ForceToCheckContentPos();
            if (mRealItemTotalCount == 0)
            {
                RecycleAllItem();
                ClearAllTmpRecycledItem();
                return;
            }
            VaildAndSetContainerPos();
            UpdateGridViewContent();
            ClearAllTmpRecycledItem();
            if (resetPos)
            {
                MovePanelToItemByRowColumn(0, 0, 0, 0);
                return;
            }
        }

        /// <summary>
        /// 单纯刷新数据，如果需要刷新显示，需要手动调用其它方法
        /// ClearSnapData();  -- 清除当前滚动
        /// MovePanelToItemByRowColumn(0, 0, 0, 0); -- 移动到定位目标
        /// RecycleAllItem(); -- 回收当前显示
        /// UpdateGridViewContent(); -- 刷新当前显示
        /// 这样可以避免Item重复刷新
        /// </summary>
        /// <param name="itemCount"></param>
        private void RefreshListItemCount(int itemCount)
        {
            if (itemCount < 0)
            {
                return;
            }
            if (itemCount == mItemTotalCount)
            {
                return;
            }
            mItemTotalCount = itemCount;
            UpdateKeepFillShowItem();
            UpdateColumnRowCount();
            UpdateContentSize();
            ForceToCheckContentPos();
            if (mRealItemTotalCount == 0)
            {
                RecycleAllItem();
                ClearAllTmpRecycledItem();
                return;
            }
        }

        public void RefreshListByIndex(int itemCount, int itemIndex = -1, float offsetX = 0, float offsetY = 0)
        {
            RefreshListItemCount(itemCount);
            mCurSnapData.Clear();
            if (mRealItemTotalCount == 0) return;
            if (itemIndex >= 0)
            {
                MovePanelToItemByIndex(itemIndex, offsetX, offsetY);
            }
            else
            {
                VaildAndSetContainerPos();
            }
            RecycleAllItem();
            UpdateGridViewContent();
            ClearAllTmpRecycledItem();
        }

        public void RefreshListByRowColumn(int itemCount, int row = -1, int column = -1, float offsetX = 0, float offsetY = 0)
        {
            RefreshListItemCount(itemCount);
            mCurSnapData.Clear();
            if (mRealItemTotalCount == 0) return;
            if (row >= 0 && column >= 0)
            {
                MovePanelToItemByRowColumn(row, column, offsetX, offsetY);
            }
            else
            {
                VaildAndSetContainerPos();
            }
            RecycleAllItem();
            UpdateGridViewContent();
            ClearAllTmpRecycledItem();
        }

        //fetch or create a new item form the item pool.
        public LoopGridViewItem NewListViewItem(string itemPrefabName)
        {
            GridItemPool pool = null;
            if (mItemPoolDict.TryGetValue(itemPrefabName, out pool) == false)
            {
                return null;
            }
            LoopGridViewItem item = pool.GetItem();
            RectTransform rf = item.GetComponent<RectTransform>();
            rf.SetParent(mContainerTrans);
            rf.localScale = Vector3.one;
            rf.anchoredPosition3D = Vector3.zero;
            rf.localEulerAngles = Vector3.zero;
            item.ParentGridView = this;
            return item;
        }


        /*
        To update a item by itemIndex.if the itemIndex-th item is not visible, then this method will do nothing.
        Otherwise this method will call RefreshItemByRowColumn to do real work.
        */
        public void RefreshItemByItemIndex(int itemIndex)
        {
            if (itemIndex < 0 || itemIndex >= mRealItemTotalCount)
            {
                return;
            }
            int count = mItemGroupList.Count;
            if (count == 0)
            {
                return;
            }
            RowColumnPair val = GetRowColumnByItemIndex(itemIndex);
            RefreshItemByRowColumn(val.mRow, val.mColumn);
        }


        /*
        To update a item by (row,column).if the item is not visible, then this method will do nothing.
        Otherwise this method will call mOnGetItemByRowColumn(row,column) to get a new updated item. 
        */
        public void RefreshItemByRowColumn(int row, int column)
        {
            int count = mItemGroupList.Count;
            if (count == 0)
            {
                return;
            }
            if (mGridFixedType == GridFixedType.ColumnCountFixed)
            {
                GridItemGroup group = GetShownGroup(row);
                if (group == null)
                {
                    return;
                }
                LoopGridViewItem curItem = group.GetItemByColumn(column);
                if (curItem == null)
                {
                    return;
                }
                LoopGridViewItem newItem = GetNewItemByRowColumn(row, column);
                if (newItem == null)
                {
                    return;
                }
                Vector3 pos = curItem.CachedRectTransform.anchoredPosition3D;
                group.ReplaceItem(curItem, newItem);
                if (mSortStartIdx >= 0)
                {
                    newItem.CachedRectTransform.SetSiblingIndex(curItem.CachedRectTransform.GetSiblingIndex());
                }
                RecycleItemTmp(curItem);
                newItem.CachedRectTransform.anchoredPosition3D = pos;
                ClearAllTmpRecycledItem();
            }
            else
            {
                GridItemGroup group = GetShownGroup(column);
                if (group == null)
                {
                    return;
                }
                LoopGridViewItem curItem = group.GetItemByRow(row);
                if (curItem == null)
                {
                    return;
                }
                LoopGridViewItem newItem = GetNewItemByRowColumn(row, column);
                if (newItem == null)
                {
                    return;
                }
                Vector3 pos = curItem.CachedRectTransform.anchoredPosition3D;
                group.ReplaceItem(curItem, newItem);
                if (mSortStartIdx >= 0)
                {
                    newItem.CachedRectTransform.SetSiblingIndex(curItem.CachedRectTransform.GetSiblingIndex());
                }
                RecycleItemTmp(curItem);
                newItem.CachedRectTransform.anchoredPosition3D = pos;
                ClearAllTmpRecycledItem();
            }
        }

        //Clear current snap target and then the GridView will auto snap to the CurSnapNearestItem.
        public void ClearSnapData()
        {
            mCurSnapData.Clear();
        }

        //set cur snap target
        public void SetSnapTargetItemRowColumn(int row, int column)
        {
            if (row < 0)
            {
                row = 0;
            }
            if (column < 0)
            {
                column = 0;
            }
            mCurSnapData.mSnapTarget.mRow = row;
            mCurSnapData.mSnapTarget.mColumn = column;
            mCurSnapData.mSnapStatus = SnapStatus.TargetHasSet;
            mCurSnapData.mIsForceSnapTo = true;
        }

        //Get the nearest item row and column with the viewport snap point.
        public RowColumnPair CurSnapNearestItemRowColumn
        {
            get { return mCurSnapNearestItemRowColumn; }
        }


        //force to update the mCurSnapNearestItemRowColumn value
        public void ForceSnapUpdateCheck()
        {
            if (mLeftSnapUpdateExtraCount <= 0)
            {
                mLeftSnapUpdateExtraCount = 1;
            }
        }

        //force to refresh the mCurFrameItemRangeData that what items should be shown in viewport.
        public void ForceToCheckContentPos()
        {
            if (mNeedCheckContentPosLeftCount <= 0)
            {
                mNeedCheckContentPosLeftCount = 1;
            }
        }

        /*
        This method will move the panel's position to ( the position of itemIndex'th item + offset ).
        */
        public void MovePanelToItemByIndex(int itemIndex, float offsetX = 0, float offsetY = 0)
        {
            if (mRealItemTotalCount == 0)
            {
                return;
            }
            if (itemIndex >= mRealItemTotalCount)
            {
                itemIndex = mRealItemTotalCount - 1;
            }
            if (itemIndex < 0)
            {
                itemIndex = 0;
            }
            RowColumnPair val = GetRowColumnByItemIndex(itemIndex);
            MovePanelToItemByRowColumn(val.mRow, val.mColumn, offsetX, offsetY);
        }

        /*
        This method will move the panel's position to ( the position of (row,column) item + offset ).
        */
        public void MovePanelToItemByRowColumn(int row, int column, float offsetX = 0, float offsetY = 0)
        {
            mScrollRect.StopMovement();
            mCurSnapData.Clear();
            if (mRealItemTotalCount == 0)
            {
                return;
            }
            Vector2 itemPos = GetItemPos(row, column);
            Vector3 pos = mContainerTrans.anchoredPosition3D;
            if (mScrollRect.horizontal)
            {
                float maxCanMoveX = Mathf.Max(ContainerTrans.rect.width - ViewPortWidth, 0);
                if (maxCanMoveX > 0)
                {
                    float x = -itemPos.x + offsetX + mStartPadding.x + mItemAlginOffset.x;
                    x = Mathf.Min(Mathf.Abs(x), maxCanMoveX) * Mathf.Sign(x);
                    pos.x = x;
                }
            }
            if (mScrollRect.vertical)
            {
                float maxCanMoveY = Mathf.Max(ContainerTrans.rect.height - ViewPortHeight, 0);
                if (maxCanMoveY > 0)
                {
                    float y = -itemPos.y + offsetY - mStartPadding.y - mItemAlginOffset.y;
                    y = Mathf.Min(Mathf.Abs(y), maxCanMoveY) * Mathf.Sign(y);
                    pos.y = y;
                }
            }
            if (pos != mContainerTrans.anchoredPosition3D)
            {
                mContainerTrans.anchoredPosition3D = pos;
            }
            VaildAndSetContainerPos();
            ForceToCheckContentPos();
        }

        //update all visible items.
        public void RefreshAllShownItem()
        {
            int count = mItemGroupList.Count;
            if (count == 0)
            {
                return;
            }
            ForceToCheckContentPos();
            RecycleAllItem();
            UpdateGridViewContent();
        }


        public virtual void OnBeginDrag(PointerEventData eventData)
        {
            if (eventData.button != PointerEventData.InputButton.Left)
            {
                return;
            }
            mCurSnapData.Clear();
            mIsDraging = true;
            if (mOnBeginDragAction != null)
            {
                mOnBeginDragAction(this);
            }
        }

        public virtual void OnEndDrag(PointerEventData eventData)
        {
            if (eventData.button != PointerEventData.InputButton.Left)
            {
                return;
            }
            mIsDraging = false;
            ForceSnapUpdateCheck();
            if (mOnEndDragAction != null)
            {
                mOnEndDragAction(this);
            }
        }

        public virtual void OnDrag(PointerEventData eventData)
        {
            if (eventData.button != PointerEventData.InputButton.Left)
            {
                return;
            }
            if (mOnDragingAction != null)
            {
                mOnDragingAction(this);
            }
        }


        public int GetItemIndexByRowColumn(int row, int column)
        {
            if (mGridFixedType == GridFixedType.ColumnCountFixed)
            {
                return row * mRealFixedRowOrColumnCount + column;
            }
            else
            {
                return column * mRealFixedRowOrColumnCount + row;
            }
        }


        public RowColumnPair GetRowColumnByItemIndex(int itemIndex)
        {
            if (itemIndex < 0)
            {
                itemIndex = 0;
            }
            if (mGridFixedType == GridFixedType.ColumnCountFixed)
            {
                int row = itemIndex / mRealFixedRowOrColumnCount;
                int column = itemIndex % mRealFixedRowOrColumnCount;
                return new RowColumnPair(row, column);
            }
            else
            {
                int column = itemIndex / mRealFixedRowOrColumnCount;
                int row = itemIndex % mRealFixedRowOrColumnCount;
                return new RowColumnPair(row, column);
            }
        }

        public Vector2 GetItemAbsPos(int itemIndex)
        {
            RowColumnPair pair = GetRowColumnByItemIndex(itemIndex);
            float x = mStartPadding.x + mItemAlginOffset.x + pair.mColumn * mItemSizeWithPadding.x;
            float y = mStartPadding.y + mItemAlginOffset.y + pair.mRow * mItemSizeWithPadding.y;
            return new Vector2(x, y);
        }

        public Vector2 GetItemAbsPos(int row, int column)
        {
            float x = mStartPadding.x + mItemAlginOffset.x + column * mItemSizeWithPadding.x;
            float y = mStartPadding.y + mItemAlginOffset.y + row * mItemSizeWithPadding.y;
            return new Vector2(x, y);
        }

        public Vector2 GetItemPos(int row, int column)
        {
            Vector2 absPos = GetItemAbsPos(row, column);
            float x = absPos.x;
            float y = absPos.y;
            if (ArrangeType == GridItemArrangeType.TopLeftToBottomRight)
            {
                return new Vector2(x, !mNeedReverse ? -y : y);
            }
            else if (ArrangeType == GridItemArrangeType.BottomLeftToTopRight)
            {
                return new Vector2(x, !mNeedReverse ? y : -y);
            }
            else if (ArrangeType == GridItemArrangeType.TopRightToBottomLeft)
            {
                return new Vector2(-x, !mNeedReverse ? -y : y);
            }
            else if (ArrangeType == GridItemArrangeType.BottomRightToTopLeft)
            {
                return new Vector2(-x, !mNeedReverse ? y : -y);
            }
            return Vector2.zero;
        }

        //get the shown item of itemIndex, if this item is not shown,then return null.
        public LoopGridViewItem GetShownItemByItemIndex(int itemIndex)
        {
            if (itemIndex < 0 || itemIndex >= mRealItemTotalCount)
            {
                return null;
            }
            if (mItemGroupList.Count == 0)
            {
                return null;
            }
            RowColumnPair val = GetRowColumnByItemIndex(itemIndex);
            return GetShownItemByRowColumn(val.mRow, val.mColumn);
        }

        //get the shown item of (row, column), if this item is not shown,then return null.
        public LoopGridViewItem GetShownItemByRowColumn(int row, int column)
        {
            if (mItemGroupList.Count == 0)
            {
                return null;
            }
            if (mGridFixedType == GridFixedType.ColumnCountFixed)
            {
                GridItemGroup group = GetShownGroup(row);
                if (group == null)
                {
                    return null;
                }
                return group.GetItemByColumn(column);
            }
            else
            {
                GridItemGroup group = GetShownGroup(column);
                if (group == null)
                {
                    return null;
                }
                return group.GetItemByRow(row);
            }
        }

        public void UpdateAllGridSetting()
        {
            UpdateStartEndPadding();
            UpdateItemSize();
            CalcRealFixedRowOrColumnCount();
            UpdateKeepFillShowItem();
            UpdateColumnRowCount();
            UpdateContentSize();
            ForceSnapUpdateCheck();
            ForceToCheckContentPos();
        }

        //set mGridFixedType and mFixedRowOrColumnCount at runtime
        public void SetGridFixedGroupCount(GridFixedType fixedType, int count)
        {
            if (mGridFixedType == fixedType && mFixedRowOrColumnCount == count)
            {
                return;
            }
            mGridFixedType = fixedType;
            mFixedRowOrColumnCount = count;
            CalcRealFixedRowOrColumnCount();
            UpdateKeepFillShowItem();
            UpdateColumnRowCount();
            UpdateContentSize();
            if (mItemGroupList.Count == 0)
            {
                return;
            }
            RecycleAllItem();
            ForceSnapUpdateCheck();
            ForceToCheckContentPos();
        }

        public void UpdateRealFixedRowOrColumnCount()
        {
            if (!CalcRealFixedRowOrColumnCount())
            {
                return;
            }
            if (mItemSnapEnable)
            {
                if (mCurSnapData.mSnapStatus == SnapStatus.NoTargetSet || mCurSnapData.mSnapStatus == SnapStatus.SnapMoveFinish)
                {
                    SetSnapTargetItemRowColumn(mCurSnapNearestItemRowColumn.mRow, mCurSnapNearestItemRowColumn.mColumn);
                }
            }
            UpdateKeepFillShowItem();
            UpdateColumnRowCount();
            UpdateContentSize();
            if (mItemGroupList.Count == 0)
            {
                return;
            }
            RecycleAllItem();
            ForceSnapUpdateCheck();
            ForceToCheckContentPos();
        }

        private void UpdateKeepFillShowItem()
        {
            mRealItemTotalCount = mItemTotalCount;
            if (mKeepFillShow < 0) return;
            int rowOrColumn = 0;
            int rowOrColumnNeed = Mathf.CeilToInt((float)mItemTotalCount / mRealFixedRowOrColumnCount) + mKeepFillShow;
            if (mGridFixedType == GridFixedType.ColumnCountFixed)
            {
                float height = ViewPortHeight - mStartPadding.y - mEndPadding.y + mItemPadding.y;
                rowOrColumn = Mathf.CeilToInt(height / mItemSizeWithPadding.y);
            }
            else
            {
                float width = ViewPortWidth - mStartPadding.x - mEndPadding.x + mItemPadding.x;
                rowOrColumn = Mathf.CeilToInt(width / mItemSizeWithPadding.x);
            }
            if (rowOrColumnNeed < rowOrColumn)
            {
                mRealItemTotalCount = mRealFixedRowOrColumnCount * rowOrColumn;
            }
            else
            {
                mRealItemTotalCount = mRealFixedRowOrColumnCount * rowOrColumnNeed;
            }
        }

        private bool CalcRealFixedRowOrColumnCount()
        {
            int lastRealFixedRowOrColumnCount = mRealFixedRowOrColumnCount;
            if (mFixedRowOrColumnCount <= 0)
            {
                if (mGridFixedType == GridFixedType.ColumnCountFixed)
                {
                    float width = ViewPortWidth - mStartPadding.x - mEndPadding.x + mItemPadding.x;
                    mRealFixedRowOrColumnCount = Mathf.FloorToInt(width / mItemSizeWithPadding.x);
                    if (mRealFixedRowOrColumnCount <= 0)
                    {
                        mRealFixedRowOrColumnCount = 1;
                    }
                    float offset = (width - mRealFixedRowOrColumnCount * mItemSizeWithPadding.x) * 0.5f;
                    mItemAlginOffset.Set(offset > 0 ? offset : 0, 0);
                }
                else
                {
                    float height = ViewPortHeight - mStartPadding.y - mEndPadding.y + mItemPadding.y;
                    mRealFixedRowOrColumnCount = Mathf.FloorToInt(height / mItemSizeWithPadding.y);
                    if (mRealFixedRowOrColumnCount <= 0)
                    {
                        mRealFixedRowOrColumnCount = 1;
                    }
                    float offset = (height - mRealFixedRowOrColumnCount * mItemSizeWithPadding.y) * 0.5f;
                    mItemAlginOffset.Set(0, offset > 0 ? offset : 0);
                }
            }
            else
            {
                mRealFixedRowOrColumnCount = mFixedRowOrColumnCount;
                mItemAlginOffset.Set(0, 0);
            }
            return lastRealFixedRowOrColumnCount != mFixedRowOrColumnCount;
        }

        //change item size at runtime
        public void SetItemSize(Vector2 newSize)
        {
            if (newSize == mItemSize)
            {
                return;
            }
            mItemSize = newSize;
            UpdateItemSize();
            UpdateContentSize();
            if (mItemGroupList.Count == 0)
            {
                return;
            }
            RecycleAllItem();
            ForceSnapUpdateCheck();
            ForceToCheckContentPos();
        }
        //change item padding at runtime
        public void SetItemPadding(Vector2 newPadding)
        {
            if (newPadding == mItemPadding)
            {
                return;
            }
            mItemPadding = newPadding;
            UpdateItemSize();
            UpdateContentSize();
            if (mItemGroupList.Count == 0)
            {
                return;
            }
            RecycleAllItem();
            ForceSnapUpdateCheck();
            ForceToCheckContentPos();
        }
        //change padding at runtime
        public void SetPadding(RectOffset newPadding)
        {
            if (newPadding == mPadding)
            {
                return;
            }
            mPadding = newPadding;
            UpdateStartEndPadding();
            UpdateContentSize();
            if (mItemGroupList.Count == 0)
            {
                return;
            }
            RecycleAllItem();
            ForceSnapUpdateCheck();
            ForceToCheckContentPos();
        }


        public void UpdateContentSize()
        {
            float width = mStartPadding.x + mItemAlginOffset.x + mColumnCount * mItemSizeWithPadding.x - mItemPadding.x + mEndPadding.x;
            float height = mStartPadding.y + mItemAlginOffset.x + mRowCount * mItemSizeWithPadding.y - mItemPadding.y + mEndPadding.y;
            if (mContainerTrans.rect.height != height)
            {
                mContainerTrans.SetSizeWithCurrentAnchors(RectTransform.Axis.Vertical, height);
            }
            if (mContainerTrans.rect.width != width)
            {
                mContainerTrans.SetSizeWithCurrentAnchors(RectTransform.Axis.Horizontal, width);
            }
        }


        public void VaildAndSetContainerPos()
        {
            Vector3 pos = mContainerTrans.anchoredPosition3D;
            mContainerTrans.anchoredPosition3D = GetContainerVaildPos(pos.x, pos.y);
        }

        public void ClearAllTmpRecycledItem()
        {
            int count = mItemPoolList.Count;
            for (int i = 0; i < count; ++i)
            {
                mItemPoolList[i].ClearTmpRecycledItem();
            }
        }


        public void RecycleAllItem()
        {
            foreach (GridItemGroup group in mItemGroupList)
            {
                RecycleItemGroupTmp(group);
            }
            mItemGroupList.Clear();
        }

        public void UpdateGridViewContent()
        {
            mListUpdateCheckFrameCount++;
            if (mRealItemTotalCount == 0)
            {
                if (mItemGroupList.Count > 0)
                {
                    RecycleAllItem();
                }
                return;
            }
            UpdateCurFrameItemRangeData();
            if (mGridFixedType == GridFixedType.ColumnCountFixed)
            {
                int groupCount = mItemGroupList.Count;
                int minRow = mCurFrameItemRangeData.mMinRow;
                int maxRow = mCurFrameItemRangeData.mMaxRow;
                for (int i = groupCount - 1; i >= 0; --i)
                {
                    GridItemGroup group = mItemGroupList[i];
                    if (group.GroupIndex < minRow || group.GroupIndex > maxRow)
                    {
                        RecycleItemGroupTmp(group);
                        mItemGroupList.RemoveAt(i);
                    }
                }
                if (mItemGroupList.Count == 0)
                {
                    GridItemGroup group = CreateItemGroup(minRow);
                    mItemGroupList.Add(group);
                }
                while (mItemGroupList[0].GroupIndex > minRow)
                {
                    GridItemGroup group = CreateItemGroup(mItemGroupList[0].GroupIndex - 1);
                    mItemGroupList.Insert(0, group);
                }
                while (mItemGroupList[mItemGroupList.Count - 1].GroupIndex < maxRow)
                {
                    GridItemGroup group = CreateItemGroup(mItemGroupList[mItemGroupList.Count - 1].GroupIndex + 1);
                    mItemGroupList.Add(group);
                }
                int count = mItemGroupList.Count;
                for (int i = 0; i < count; ++i)
                {
                    UpdateRowItemGroupForRecycleAndNew(mItemGroupList[i], i);
                }
            }
            else
            {
                int groupCount = mItemGroupList.Count;
                int minColumn = mCurFrameItemRangeData.mMinColumn;
                int maxColumn = mCurFrameItemRangeData.mMaxColumn;
                for (int i = groupCount - 1; i >= 0; --i)
                {
                    GridItemGroup group = mItemGroupList[i];
                    if (group.GroupIndex < minColumn || group.GroupIndex > maxColumn)
                    {
                        RecycleItemGroupTmp(group);
                        mItemGroupList.RemoveAt(i);
                    }
                }
                if (mItemGroupList.Count == 0)
                {
                    GridItemGroup group = CreateItemGroup(minColumn);
                    mItemGroupList.Add(group);
                }
                while (mItemGroupList[0].GroupIndex > minColumn)
                {
                    GridItemGroup group = CreateItemGroup(mItemGroupList[0].GroupIndex - 1);
                    mItemGroupList.Insert(0, group);
                }
                while (mItemGroupList[mItemGroupList.Count - 1].GroupIndex < maxColumn)
                {
                    GridItemGroup group = CreateItemGroup(mItemGroupList[mItemGroupList.Count - 1].GroupIndex + 1);
                    mItemGroupList.Add(group);
                }
                int count = mItemGroupList.Count;
                for (int i = 0; i < count; ++i)
                {
                    UpdateColumnItemGroupForRecycleAndNew(mItemGroupList[i], i);
                }
            }
        }

        public void UpdateStartEndPadding()
        {
            if (ArrangeType == GridItemArrangeType.TopLeftToBottomRight)
            {
                mStartPadding.x = mPadding.left;
                mStartPadding.y = mPadding.top;
                mEndPadding.x = mPadding.right;
                mEndPadding.y = mPadding.bottom;
                if (mNeedReverse)
                {
                    mStartPadding.y = mPadding.bottom;
                    mEndPadding.y = mPadding.top;
                }
            }
            else if (ArrangeType == GridItemArrangeType.BottomLeftToTopRight)
            {
                mStartPadding.x = mPadding.left;
                mStartPadding.y = mPadding.bottom;
                mEndPadding.x = mPadding.right;
                mEndPadding.y = mPadding.top;
                if (mNeedReverse)
                {
                    mStartPadding.y = mPadding.top;
                    mEndPadding.y = mPadding.bottom;
                }
            }
            else if (ArrangeType == GridItemArrangeType.TopRightToBottomLeft)
            {
                mStartPadding.x = mPadding.right;
                mStartPadding.y = mPadding.top;
                mEndPadding.x = mPadding.left;
                mEndPadding.y = mPadding.bottom;
                if (mNeedReverse)
                {
                    mStartPadding.y = mPadding.bottom;
                    mEndPadding.y = mPadding.top;
                }
            }
            else if (ArrangeType == GridItemArrangeType.BottomRightToTopLeft)
            {
                mStartPadding.x = mPadding.right;
                mStartPadding.y = mPadding.bottom;
                mEndPadding.x = mPadding.left;
                mEndPadding.y = mPadding.top;
                if (mNeedReverse)
                {
                    mStartPadding.y = mPadding.top;
                    mEndPadding.y = mPadding.bottom;
                }
            }
        }


        public void UpdateItemSize()
        {
            if (mItemSize.x > 0f && mItemSize.y > 0f)
            {
                mItemSizeWithPadding = mItemSize + mItemPadding;
                return;
            }
            do
            {
                if (mItemPrefabDataList.Count == 0)
                {
                    break;
                }
                GameObject obj = mItemPrefabDataList[0].mItemPrefab;
                if (obj == null)
                {
                    break;
                }
                RectTransform rtf = obj.GetComponent<RectTransform>();
                if (rtf == null)
                {
                    break;
                }
                mItemSize = rtf.rect.size;
                mItemSizeWithPadding = mItemSize + mItemPadding;

            } while (false);

            if (mItemSize.x <= 0 || mItemSize.y <= 0)
            {
                Debug.LogError("Error, ItemSize is invaild.");
            }

        }

        public void UpdateColumnRowCount()
        {
            if (mGridFixedType == GridFixedType.ColumnCountFixed)
            {
                mColumnCount = mRealFixedRowOrColumnCount;
                mRowCount = mRealItemTotalCount / mColumnCount;
                if (mRealItemTotalCount % mColumnCount > 0)
                {
                    mRowCount++;
                }
                if (mRealItemTotalCount <= mColumnCount)
                {
                    mColumnCount = mRealItemTotalCount;
                }
            }
            else
            {
                mRowCount = mRealFixedRowOrColumnCount;
                mColumnCount = mRealItemTotalCount / mRowCount;
                if (mRealItemTotalCount % mRowCount > 0)
                {
                    mColumnCount++;
                }
                if (mRealItemTotalCount <= mRowCount)
                {
                    mRowCount = mRealItemTotalCount;
                }
            }
        }




        /// ///////////////////////////////////////////////////////////////////////////////////////////////////////
        /// </summary>


        bool IsContainerTransCanMove()
        {
            if (mRealItemTotalCount == 0)
            {
                return false;
            }
            if (mScrollRect.horizontal && ContainerTrans.rect.width > ViewPortWidth)
            {
                return true;
            }
            if (mScrollRect.vertical && ContainerTrans.rect.height > ViewPortHeight)
            {
                return true;
            }
            return false;
        }



        void RecycleItemGroupTmp(GridItemGroup group)
        {
            if (group == null)
            {
                return;
            }
            while (group.First != null)
            {
                LoopGridViewItem item = group.RemoveFirst();
                RecycleItemTmp(item);
            }
            group.Clear();
            RecycleOneItemGroupObj(group);
        }



        void RecycleItemTmp(LoopGridViewItem item)
        {
            if (item == null)
            {
                return;
            }
            if (string.IsNullOrEmpty(item.ItemPrefabName))
            {
                return;
            }
            GridItemPool pool = null;
            if (mItemPoolDict.TryGetValue(item.ItemPrefabName, out pool) == false)
            {
                return;
            }
            if (mOnRecycleItem != null) mOnRecycleItem(this, item.ItemIndex, item.Row, item.Column, item);
            pool.RecycleItem(item);
            if (mSortStartIdx >= 0)
            {
                item.CachedRectTransform.SetAsLastSibling();
            }
        }


        void AdjustViewPortPivot()
        {
            RectTransform rtf = mViewPortRectTransform;
            if (ArrangeType == GridItemArrangeType.TopLeftToBottomRight)
            {
                rtf.pivot = new Vector2(0, 1);
            }
            else if (ArrangeType == GridItemArrangeType.BottomLeftToTopRight)
            {
                rtf.pivot = new Vector2(0, 0);
            }
            else if (ArrangeType == GridItemArrangeType.TopRightToBottomLeft)
            {
                rtf.pivot = new Vector2(1, 1);
            }
            else if (ArrangeType == GridItemArrangeType.BottomRightToTopLeft)
            {
                rtf.pivot = new Vector2(1, 0);
            }
        }

        void AdjustContainerAnchorAndPivot()
        {
            RectTransform rtf = ContainerTrans;

            if (ArrangeType == GridItemArrangeType.TopLeftToBottomRight)
            {
                rtf.anchorMin = new Vector2(0, 1);
                rtf.anchorMax = new Vector2(0, 1);
                rtf.pivot = new Vector2(0, 1);
            }
            else if (ArrangeType == GridItemArrangeType.BottomLeftToTopRight)
            {
                rtf.anchorMin = new Vector2(0, 0);
                rtf.anchorMax = new Vector2(0, 0);
                rtf.pivot = new Vector2(0, 0);
            }
            else if (ArrangeType == GridItemArrangeType.TopRightToBottomLeft)
            {
                rtf.anchorMin = new Vector2(1, 1);
                rtf.anchorMax = new Vector2(1, 1);
                rtf.pivot = new Vector2(1, 1);
            }
            else if (ArrangeType == GridItemArrangeType.BottomRightToTopLeft)
            {
                rtf.anchorMin = new Vector2(1, 0);
                rtf.anchorMax = new Vector2(1, 0);
                rtf.pivot = new Vector2(1, 0);
            }
        }

        void AdjustItemAnchorAndPivot(RectTransform rtf)
        {
            if (ArrangeType == GridItemArrangeType.TopLeftToBottomRight)
            {
                rtf.anchorMin = new Vector2(0, 1);
                rtf.anchorMax = new Vector2(0, 1);
                rtf.pivot = new Vector2(0, 1);
                if (mNeedReverse)
                {
                    rtf.anchorMin = new Vector2(0, 0);
                    rtf.anchorMax = new Vector2(0, 0);
                    rtf.pivot = new Vector2(0, 0);
                }

            }
            else if (ArrangeType == GridItemArrangeType.BottomLeftToTopRight)
            {
                rtf.anchorMin = new Vector2(0, 0);
                rtf.anchorMax = new Vector2(0, 0);
                rtf.pivot = new Vector2(0, 0);
                if (mNeedReverse)
                {
                    rtf.anchorMin = new Vector2(0, 1);
                    rtf.anchorMax = new Vector2(0, 1);
                    rtf.pivot = new Vector2(0, 1);
                }
            }
            else if (ArrangeType == GridItemArrangeType.TopRightToBottomLeft)
            {
                rtf.anchorMin = new Vector2(1, 1);
                rtf.anchorMax = new Vector2(1, 1);
                rtf.pivot = new Vector2(1, 1);
                if (mNeedReverse)
                {
                    rtf.anchorMin = new Vector2(1, 0);
                    rtf.anchorMax = new Vector2(1, 0);
                    rtf.pivot = new Vector2(1, 0);
                }
            }
            else if (ArrangeType == GridItemArrangeType.BottomRightToTopLeft)
            {
                rtf.anchorMin = new Vector2(1, 0);
                rtf.anchorMax = new Vector2(1, 0);
                rtf.pivot = new Vector2(1, 0);
                if (mNeedReverse)
                {
                    rtf.anchorMin = new Vector2(1, 1);
                    rtf.anchorMax = new Vector2(1, 1);
                    rtf.pivot = new Vector2(1, 1);
                }
            }
        }





        void InitItemPool()
        {
            foreach (GridViewItemPrefabConfData data in mItemPrefabDataList)
            {
                if (data.mItemPrefab == null)
                {
                    Debug.LogError("A item prefab is null ");
                    continue;
                }
                string prefabName = data.mItemPrefab.name;
                if (mItemPoolDict.ContainsKey(prefabName))
                {
                    Debug.LogError("A item prefab with name " + prefabName + " has existed!");
                    continue;
                }
                RectTransform rtf = data.mItemPrefab.GetComponent<RectTransform>();
                if (rtf == null)
                {
                    Debug.LogError("RectTransform component is not found in the prefab " + prefabName);
                    continue;
                }
                AdjustItemAnchorAndPivot(rtf);
                LoopGridViewItem tItem = data.mItemPrefab.GetComponent<LoopGridViewItem>();
                if (tItem == null)
                {
                    data.mItemPrefab.AddComponent<LoopGridViewItem>();
                }
                GridItemPool pool = new GridItemPool();
                pool.Init(data.mItemPrefab, data.mInitCreateCount, mContainerTrans);
                mItemPoolDict.Add(prefabName, pool);
                mItemPoolList.Add(pool);
            }
        }


        LoopGridViewItem GetNewItemByRowColumn(int row, int column)
        {
            int itemIndex = GetItemIndexByRowColumn(row, column);
            if (itemIndex < 0 || itemIndex >= mRealItemTotalCount)
            {
                return null;
            }
            LoopGridViewItem newItem = mOnGetItemByRowColumn(this, itemIndex, row, column);
            if (newItem == null)
            {
                return null;
            }
            newItem.NextItem = null;
            newItem.PrevItem = null;
            newItem.Row = row;
            newItem.Column = column;
            newItem.ItemIndex = itemIndex;
            newItem.ItemCreatedCheckFrameCount = mListUpdateCheckFrameCount;
            return newItem;
        }


        RowColumnPair GetCeilItemRowColumnAtGivenAbsPos(float ax, float ay)
        {
            ax = Mathf.Abs(ax);
            ay = Mathf.Abs(ay);
            int row = Mathf.CeilToInt((ay - mStartPadding.y - mItemAlginOffset.y) / mItemSizeWithPadding.y) - 1;
            int column = Mathf.CeilToInt((ax - mStartPadding.x - mItemAlginOffset.x) / mItemSizeWithPadding.x) - 1;
            if (row < 0)
            {
                row = 0;
            }
            if (row >= mRowCount)
            {
                row = mRowCount - 1;
            }
            if (column < 0)
            {
                column = 0;
            }
            if (column >= mColumnCount)
            {
                column = mColumnCount - 1;
            }
            return new RowColumnPair(row, column);
        }

        void Update()
        {
            if (mListViewInited == false)
            {
                return;
            }
            if (mRefreshRawOrColumn)
            {
                mRefreshRawOrColumn = false;
                UpdateRealFixedRowOrColumnCount();
            }
            UpdateSnapMove();
            UpdateGridViewContent();
            ClearAllTmpRecycledItem();
        }


        GridItemGroup CreateItemGroup(int groupIndex)
        {
            GridItemGroup ret = GetOneItemGroupObj();
            ret.GroupIndex = groupIndex;
            return ret;
        }
        Vector2 GetContainerMovedDistance()
        {
            Vector2 pos = GetContainerVaildPos(ContainerTrans.anchoredPosition3D.x, ContainerTrans.anchoredPosition3D.y);
            return new Vector2(Mathf.Abs(pos.x), Mathf.Abs(pos.y));
        }


        Vector2 GetContainerVaildPos(float curX, float curY)
        {
            float maxCanMoveX = Mathf.Max(ContainerTrans.rect.width - ViewPortWidth, 0);
            float maxCanMoveY = Mathf.Max(ContainerTrans.rect.height - ViewPortHeight, 0);
            if (mArrangeType == GridItemArrangeType.TopLeftToBottomRight)
            {
                curX = Mathf.Clamp(curX, -maxCanMoveX, 0);
                curY = Mathf.Clamp(curY, 0, maxCanMoveY);
            }
            else if (mArrangeType == GridItemArrangeType.BottomLeftToTopRight)
            {
                curX = Mathf.Clamp(curX, -maxCanMoveX, 0);
                curY = Mathf.Clamp(curY, -maxCanMoveY, 0);
            }
            else if (mArrangeType == GridItemArrangeType.BottomRightToTopLeft)
            {
                curX = Mathf.Clamp(curX, 0, maxCanMoveX);
                curY = Mathf.Clamp(curY, -maxCanMoveY, 0);

            }
            else if (mArrangeType == GridItemArrangeType.TopRightToBottomLeft)
            {
                curX = Mathf.Clamp(curX, 0, maxCanMoveX);
                curY = Mathf.Clamp(curY, 0, maxCanMoveY);
            }
            return new Vector2(curX, curY);
        }


        void UpdateCurFrameItemRangeData()
        {
            Vector2 distVector2 = GetContainerMovedDistance();
            if (mNeedCheckContentPosLeftCount <= 0 && mCurFrameItemRangeData.mCheckedPosition == distVector2)
            {
                return;
            }
            if (mNeedCheckContentPosLeftCount > 0)
            {
                mNeedCheckContentPosLeftCount--;
            }
            float distX = distVector2.x - mItemRecycleDistance.x;
            float distY = distVector2.y - mItemRecycleDistance.y;
            if (distX < 0)
            {
                distX = 0;
            }
            if (distY < 0)
            {
                distY = 0;
            }
            RowColumnPair val = GetCeilItemRowColumnAtGivenAbsPos(distX, distY);
            mCurFrameItemRangeData.mMinColumn = val.mColumn;
            mCurFrameItemRangeData.mMinRow = val.mRow;
            distX = distVector2.x + mItemRecycleDistance.x + ViewPortWidth;
            distY = distVector2.y + mItemRecycleDistance.y + ViewPortHeight;
            val = GetCeilItemRowColumnAtGivenAbsPos(distX, distY);
            mCurFrameItemRangeData.mMaxColumn = val.mColumn;
            mCurFrameItemRangeData.mMaxRow = val.mRow;
            mCurFrameItemRangeData.mCheckedPosition = distVector2;
        }




        void UpdateRowItemGroupForRecycleAndNew(GridItemGroup group, int idx)
        {
            int minColumn = mCurFrameItemRangeData.mMinColumn;
            int maxColumn = mCurFrameItemRangeData.mMaxColumn;
            int row = group.GroupIndex;
            while (group.First != null && group.First.Column < minColumn)
            {
                RecycleItemTmp(group.RemoveFirst());
            }
            while (group.Last != null && ((group.Last.Column > maxColumn) || (group.Last.ItemIndex >= mRealItemTotalCount)))
            {
                RecycleItemTmp(group.RemoveLast());
            }
            if (group.First == null)
            {
                LoopGridViewItem item = GetNewItemByRowColumn(row, minColumn);
                if (item == null)
                {
                    return;
                }
                item.CachedRectTransform.anchoredPosition3D = GetItemPos(item.Row, item.Column);
                if (mSortStartIdx >= 0)
                    item.CachedRectTransform.SetSiblingIndex(mSortStartIdx + idx * (maxColumn - minColumn + 1));
                group.AddFirst(item);
            }
            while (group.First.Column > minColumn)
            {
                LoopGridViewItem item = GetNewItemByRowColumn(row, group.First.Column - 1);
                if (item == null)
                {
                    break;
                }
                item.CachedRectTransform.anchoredPosition3D = GetItemPos(item.Row, item.Column);
                if (mSortStartIdx >= 0)
                    item.CachedRectTransform.SetSiblingIndex(mSortStartIdx + idx * (maxColumn - minColumn + 1) + 1);
                group.AddFirst(item);
            }
            while (group.Last.Column < maxColumn)
            {
                LoopGridViewItem item = GetNewItemByRowColumn(row, group.Last.Column + 1);
                if (item == null)
                {
                    break;
                }
                item.CachedRectTransform.anchoredPosition3D = GetItemPos(item.Row, item.Column);
                if (mSortStartIdx >= 0)
                    item.CachedRectTransform.SetSiblingIndex(mSortStartIdx + idx * (maxColumn - minColumn + 1) + (item.Column - minColumn));
                group.AddLast(item);
            }
        }

        void UpdateColumnItemGroupForRecycleAndNew(GridItemGroup group, int idx)
        {
            int minRow = mCurFrameItemRangeData.mMinRow;
            int maxRow = mCurFrameItemRangeData.mMaxRow;
            int column = group.GroupIndex;
            while (group.First != null && group.First.Row < minRow)
            {
                RecycleItemTmp(group.RemoveFirst());
            }
            while (group.Last != null && ((group.Last.Row > maxRow) || (group.Last.ItemIndex >= mRealItemTotalCount)))
            {
                RecycleItemTmp(group.RemoveLast());
            }
            if (group.First == null)
            {
                LoopGridViewItem item = GetNewItemByRowColumn(minRow, column);
                if (item == null)
                {
                    return;
                }
                item.CachedRectTransform.anchoredPosition3D = GetItemPos(item.Row, item.Column);
                if (mSortStartIdx >= 0)
                    item.CachedRectTransform.SetSiblingIndex(mSortStartIdx + idx * (maxRow - minRow + 1));
                group.AddFirst(item);
            }
            while (group.First.Row > minRow)
            {
                LoopGridViewItem item = GetNewItemByRowColumn(group.First.Row - 1, column);
                if (item == null)
                {
                    break;
                }
                item.CachedRectTransform.anchoredPosition3D = GetItemPos(item.Row, item.Column);
                if (mSortStartIdx >= 0)
                    item.CachedRectTransform.SetSiblingIndex(mSortStartIdx + idx * (maxRow - minRow + 1) + 1);
                group.AddFirst(item);
            }
            while (group.Last.Row < maxRow)
            {
                LoopGridViewItem item = GetNewItemByRowColumn(group.Last.Row + 1, column);
                if (item == null)
                {
                    break;
                }
                item.CachedRectTransform.anchoredPosition3D = GetItemPos(item.Row, item.Column);
                if (mSortStartIdx >= 0)
                    item.CachedRectTransform.SetSiblingIndex(mSortStartIdx + idx * (maxRow - minRow + 1) + (item.Row - minRow));
                group.AddLast(item);
            }
        }

        void SetScrollbarListener()
        {
            if (ItemSnapEnable == false)
            {
                return;
            }
            mScrollBarClickEventListener1 = null;
            mScrollBarClickEventListener2 = null;
            Scrollbar curScrollBar1 = null;
            Scrollbar curScrollBar2 = null;
            if (mScrollRect.vertical && mScrollRect.verticalScrollbar != null)
            {
                curScrollBar1 = mScrollRect.verticalScrollbar;

            }
            if (mScrollRect.horizontal && mScrollRect.horizontalScrollbar != null)
            {
                curScrollBar2 = mScrollRect.horizontalScrollbar;
            }
            if (curScrollBar1 != null)
            {
                ClickEventListener listener = ClickEventListener.Get(curScrollBar1.gameObject);
                mScrollBarClickEventListener1 = listener;
                listener.SetPointerUpHandler(OnPointerUpInScrollBar);
                listener.SetPointerDownHandler(OnPointerDownInScrollBar);
            }
            if (curScrollBar2 != null)
            {
                ClickEventListener listener = ClickEventListener.Get(curScrollBar2.gameObject);
                mScrollBarClickEventListener2 = listener;
                listener.SetPointerUpHandler(OnPointerUpInScrollBar);
                listener.SetPointerDownHandler(OnPointerDownInScrollBar);
            }

        }

        void OnPointerDownInScrollBar(GameObject obj)
        {
            mCurSnapData.Clear();
        }

        void OnPointerUpInScrollBar(GameObject obj)
        {
            ForceSnapUpdateCheck();
        }

        RowColumnPair FindNearestItemWithLocalPos(float x, float y)
        {
            Vector2 targetPos = new Vector2(x, y);
            RowColumnPair val = GetCeilItemRowColumnAtGivenAbsPos(targetPos.x, targetPos.y);
            int row = val.mRow;
            int column = val.mColumn;
            float distance = 0;
            RowColumnPair ret = new RowColumnPair(-1, -1);
            Vector2 pos = Vector2.zero;
            float minDistance = float.MaxValue;
            for (int r = row - 1; r <= row + 1; ++r)
            {
                for (int c = column - 1; c <= column + 1; ++c)
                {
                    if (r >= 0 && r < mRowCount && c >= 0 && c < mColumnCount)
                    {
                        pos = GetItemSnapPivotLocalPos(r, c);
                        distance = (pos - targetPos).sqrMagnitude;
                        if (distance < minDistance)
                        {
                            minDistance = distance;
                            ret.mRow = r;
                            ret.mColumn = c;
                        }
                    }
                }
            }
            return ret;
        }

        public int FindNearestItemIndex()
        {
            Vector2 pos = GetContainerVaildPos(ContainerTrans.anchoredPosition3D.x, ContainerTrans.anchoredPosition3D.y);
            Vector2 snapTartetPos = GetViewPortSnapPivotLocalPos(pos);
            RowColumnPair curVal = FindNearestItemWithLocalPos(snapTartetPos.x, snapTartetPos.y);
            int index = GetItemIndexByRowColumn(curVal.mRow, curVal.mColumn);
            return index;
        }

        public void FindItemIdxInWorldRect(Vector2 min, Vector2 max, out int startItemIdx, out int endItemIdx)
        {
            if (mArrangeType == GridItemArrangeType.TopLeftToBottomRight)
            {
                min = mContainerTrans.InverseTransformPoint(min);
                max = mContainerTrans.InverseTransformPoint(max);
                int column1 = Mathf.CeilToInt((min.x - mStartPadding.x - mItemAlginOffset.x) / mItemSizeWithPadding.x);
                int row1 = Mathf.CeilToInt((-max.y - mStartPadding.y - mItemAlginOffset.y) / mItemSizeWithPadding.y);
                int column2 = Mathf.FloorToInt((max.x - mStartPadding.x - mItemAlginOffset.x) / mItemSizeWithPadding.x);
                int row2 = Mathf.FloorToInt((-min.y - mStartPadding.y - mItemAlginOffset.y) / mItemSizeWithPadding.y);
                startItemIdx = GetItemIndexByRowColumn(row1, column1);
                startItemIdx = Mathf.Clamp(startItemIdx, 0, mRealItemTotalCount);
                endItemIdx = GetItemIndexByRowColumn(row2, column2);
                endItemIdx = Mathf.Clamp(endItemIdx, 0, mRealItemTotalCount);
            }
            else if (mArrangeType == GridItemArrangeType.BottomLeftToTopRight)
            {
                min = mContainerTrans.InverseTransformPoint(min);
                max = mContainerTrans.InverseTransformPoint(max);
                int column1 = Mathf.CeilToInt((min.x - mEndPadding.x - mItemAlginOffset.x) / mItemSizeWithPadding.x);
                int row1 = Mathf.CeilToInt((max.y - mEndPadding.y - mItemAlginOffset.y) / mItemSizeWithPadding.y);
                int column2 = Mathf.FloorToInt((max.x - mEndPadding.x - mItemAlginOffset.x) / mItemSizeWithPadding.x);
                int row2 = Mathf.FloorToInt((min.y - mEndPadding.y - mItemAlginOffset.y) / mItemSizeWithPadding.y);
                startItemIdx = GetItemIndexByRowColumn(row2, column2);
                startItemIdx = Mathf.Clamp(startItemIdx, 0, mRealItemTotalCount);
                endItemIdx = GetItemIndexByRowColumn(row1, column1);
                endItemIdx = Mathf.Clamp(endItemIdx, 0, mRealItemTotalCount);
            }
            else
            {
                startItemIdx = -1;
                endItemIdx = -1;
            }
        }

        Vector2 GetItemSnapPivotLocalPos(int row, int column)
        {
            Vector2 absPos = GetItemAbsPos(row, column);
            if (mArrangeType == GridItemArrangeType.TopLeftToBottomRight)
            {
                float x = absPos.x + mItemSize.x * mItemSnapPivot.x;
                float y = -absPos.y - mItemSize.y * (1 - mItemSnapPivot.y);
                return new Vector2(x, y);
            }
            else if (mArrangeType == GridItemArrangeType.BottomLeftToTopRight)
            {
                float x = absPos.x + mItemSize.x * mItemSnapPivot.x;
                float y = absPos.y + mItemSize.y * mItemSnapPivot.y;
                return new Vector2(x, y);
            }
            else if (mArrangeType == GridItemArrangeType.TopRightToBottomLeft)
            {
                float x = -absPos.x - mItemSize.x * (1 - mItemSnapPivot.x);
                float y = -absPos.y - mItemSize.y * (1 - mItemSnapPivot.y);
                return new Vector2(x, y);
            }
            else if (mArrangeType == GridItemArrangeType.BottomRightToTopLeft)
            {
                float x = -absPos.x - mItemSize.x * (1 - mItemSnapPivot.x);
                float y = absPos.y + mItemSize.y * mItemSnapPivot.y;
                return new Vector2(x, y);
            }
            return Vector2.zero;
        }

        Vector2 GetViewPortSnapPivotLocalPos(Vector2 pos)
        {
            float pivotLocalPosX = 0;
            float pivotLocalPosY = 0;
            if (mArrangeType == GridItemArrangeType.TopLeftToBottomRight)
            {
                pivotLocalPosX = -pos.x + ViewPortWidth * mViewPortSnapPivot.x;
                pivotLocalPosY = -pos.y - ViewPortHeight * (1 - mViewPortSnapPivot.y);
            }
            else if (mArrangeType == GridItemArrangeType.BottomLeftToTopRight)
            {
                pivotLocalPosX = -pos.x + ViewPortWidth * mViewPortSnapPivot.x;
                pivotLocalPosY = -pos.y + ViewPortHeight * mViewPortSnapPivot.y;
            }
            else if (mArrangeType == GridItemArrangeType.TopRightToBottomLeft)
            {
                pivotLocalPosX = -pos.x - ViewPortWidth * (1 - mViewPortSnapPivot.x);
                pivotLocalPosY = -pos.y - ViewPortHeight * (1 - mViewPortSnapPivot.y);
            }
            else if (mArrangeType == GridItemArrangeType.BottomRightToTopLeft)
            {
                pivotLocalPosX = -pos.x - ViewPortWidth * (1 - mViewPortSnapPivot.x);
                pivotLocalPosY = -pos.y + ViewPortHeight * mViewPortSnapPivot.y;
            }
            return new Vector2(pivotLocalPosX, pivotLocalPosY);
        }

        void UpdateNearestSnapItem(bool forceSendEvent)
        {
            if (mItemSnapEnable == false)
            {
                return;
            }
            int count = mItemGroupList.Count;
            if (count == 0)
            {
                return;
            }
            if (IsContainerTransCanMove() == false)
            {
                return;
            }
            Vector2 pos = GetContainerVaildPos(ContainerTrans.anchoredPosition3D.x, ContainerTrans.anchoredPosition3D.y);
            bool needCheck = (pos.y != mLastSnapCheckPos.y || pos.x != mLastSnapCheckPos.x);
            mLastSnapCheckPos = pos;
            if (!needCheck)
            {
                if (mLeftSnapUpdateExtraCount > 0)
                {
                    mLeftSnapUpdateExtraCount--;
                    needCheck = true;
                }
            }
            if (needCheck)
            {
                RowColumnPair curVal = new RowColumnPair(-1, -1);
                Vector2 snapTartetPos = GetViewPortSnapPivotLocalPos(pos);
                curVal = FindNearestItemWithLocalPos(snapTartetPos.x, snapTartetPos.y);
                if (curVal.mRow >= 0)
                {
                    RowColumnPair oldNearestItem = mCurSnapNearestItemRowColumn;
                    mCurSnapNearestItemRowColumn = curVal;
                    if (forceSendEvent || oldNearestItem != mCurSnapNearestItemRowColumn)
                    {
                        if (mOnSnapNearestChanged != null)
                        {
                            mOnSnapNearestChanged(this);
                        }
                    }
                }
                else
                {
                    mCurSnapNearestItemRowColumn.mRow = -1;
                    mCurSnapNearestItemRowColumn.mColumn = -1;
                }
            }
        }

        void UpdateFromSettingParam(LoopGridViewSettingParam param)
        {
            if (param == null)
            {
                return;
            }
            if (param.mItemSize != null)
            {
                mItemSize = (Vector2)(param.mItemSize);
            }
            if (param.mItemPadding != null)
            {
                mItemPadding = (Vector2)(param.mItemPadding);
            }
            if (param.mPadding != null)
            {
                mPadding = (RectOffset)(param.mPadding);
            }
            if (param.mGridFixedType != null)
            {
                mGridFixedType = (GridFixedType)(param.mGridFixedType);
            }
            if (param.mFixedRowOrColumnCount != null)
            {
                mFixedRowOrColumnCount = System.Convert.ToInt32(param.mFixedRowOrColumnCount);
            }
        }

        //snap move will finish at once.
        public void FinishSnapImmediately()
        {
            UpdateSnapMove(true);
        }

        //update snap move. if immediate is set true, then the snap move will finish at once.
        void UpdateSnapMove(bool immediate = false, bool forceSendEvent = false)
        {
            if (mItemSnapEnable == false)
            {
                return;
            }
            UpdateNearestSnapItem(false);
            Vector2 pos = mContainerTrans.anchoredPosition3D;
            if (CanSnap() == false)
            {
                ClearSnapData();
                return;
            }
            UpdateCurSnapData();
            if (mCurSnapData.mSnapStatus != SnapStatus.SnapMoving)
            {
                return;
            }
            float v = Mathf.Abs(mScrollRect.velocity.x) + Mathf.Abs(mScrollRect.velocity.y);
            if (v > 0)
            {
                mScrollRect.StopMovement();
            }
            float old = mCurSnapData.mCurSnapVal;
            mCurSnapData.mCurSnapVal = Mathf.SmoothDamp(mCurSnapData.mCurSnapVal, mCurSnapData.mTargetSnapVal, ref mSmoothDumpVel, mSmoothDumpRate);
            float dt = mCurSnapData.mCurSnapVal - old;

            if (immediate || Mathf.Abs(mCurSnapData.mTargetSnapVal - mCurSnapData.mCurSnapVal) < mSnapFinishThreshold)
            {
                pos = pos + (mCurSnapData.mTargetSnapVal - old) * mCurSnapData.mSnapNeedMoveDir;
                mCurSnapData.mSnapStatus = SnapStatus.SnapMoveFinish;
                if (mOnSnapItemFinished != null)
                {
                    LoopGridViewItem targetItem = GetShownItemByRowColumn(mCurSnapNearestItemRowColumn.mRow, mCurSnapNearestItemRowColumn.mColumn);
                    if (targetItem != null)
                    {
                        mOnSnapItemFinished(this, targetItem);
                    }
                }
            }
            else
            {
                pos = pos + dt * mCurSnapData.mSnapNeedMoveDir;
            }
            mContainerTrans.anchoredPosition3D = GetContainerVaildPos(pos.x, pos.y);
        }

        GridItemGroup GetShownGroup(int groupIndex)
        {
            if (groupIndex < 0)
            {
                return null;
            }
            int count = mItemGroupList.Count;
            if (count == 0)
            {
                return null;
            }
            if (groupIndex < mItemGroupList[0].GroupIndex || groupIndex > mItemGroupList[count - 1].GroupIndex)
            {
                return null;
            }
            int i = groupIndex - mItemGroupList[0].GroupIndex;
            return mItemGroupList[i];
        }


        void FillCurSnapData(int row, int column)
        {
            Vector2 itemSnapPivotLocalPos = GetItemSnapPivotLocalPos(row, column);
            Vector2 containerPos = GetContainerVaildPos(ContainerTrans.anchoredPosition3D.x, ContainerTrans.anchoredPosition3D.y);
            Vector2 snapTartetPos = GetViewPortSnapPivotLocalPos(containerPos);
            Vector2 dir = snapTartetPos - itemSnapPivotLocalPos;
            if (mScrollRect.horizontal == false)
            {
                dir.x = 0;
            }
            if (mScrollRect.vertical == false)
            {
                dir.y = 0;
            }
            mCurSnapData.mTargetSnapVal = dir.magnitude;
            mCurSnapData.mCurSnapVal = 0;
            mCurSnapData.mSnapNeedMoveDir = dir.normalized;
        }


        void UpdateCurSnapData()
        {
            int count = mItemGroupList.Count;
            if (count == 0)
            {
                mCurSnapData.Clear();
                return;
            }

            if (mCurSnapData.mSnapStatus == SnapStatus.SnapMoveFinish)
            {
                if (mCurSnapData.mSnapTarget == mCurSnapNearestItemRowColumn)
                {
                    return;
                }
                mCurSnapData.mSnapStatus = SnapStatus.NoTargetSet;
            }
            if (mCurSnapData.mSnapStatus == SnapStatus.SnapMoving)
            {
                if ((mCurSnapData.mSnapTarget == mCurSnapNearestItemRowColumn) || mCurSnapData.mIsForceSnapTo)
                {
                    return;
                }
                mCurSnapData.mSnapStatus = SnapStatus.NoTargetSet;
            }
            if (mCurSnapData.mSnapStatus == SnapStatus.NoTargetSet)
            {
                LoopGridViewItem nearestItem = GetShownItemByRowColumn(mCurSnapNearestItemRowColumn.mRow, mCurSnapNearestItemRowColumn.mColumn);
                if (nearestItem == null)
                {
                    return;
                }
                mCurSnapData.mSnapTarget = mCurSnapNearestItemRowColumn;
                mCurSnapData.mSnapStatus = SnapStatus.TargetHasSet;
                mCurSnapData.mIsForceSnapTo = false;
            }
            if (mCurSnapData.mSnapStatus == SnapStatus.TargetHasSet)
            {
                LoopGridViewItem targetItem = GetShownItemByRowColumn(mCurSnapData.mSnapTarget.mRow, mCurSnapData.mSnapTarget.mColumn);
                if (targetItem == null)
                {
                    mCurSnapData.Clear();
                    return;
                }
                FillCurSnapData(targetItem.Row, targetItem.Column);
                mCurSnapData.mSnapStatus = SnapStatus.SnapMoving;
            }

        }


        bool CanSnap()
        {
            if (mIsDraging)
            {
                return false;
            }
            if (mScrollBarClickEventListener1 != null)
            {
                if (mScrollBarClickEventListener1.IsPressd)
                {
                    return false;
                }
            }
            if (mScrollBarClickEventListener2 != null)
            {
                if (mScrollBarClickEventListener2.IsPressd)
                {
                    return false;
                }
            }
            if (IsContainerTransCanMove() == false)
            {
                return false;
            }
            if (Mathf.Abs(mScrollRect.velocity.x) > mSnapVecThreshold)
            {
                return false;
            }
            if (Mathf.Abs(mScrollRect.velocity.y) > mSnapVecThreshold)
            {
                return false;
            }
            Vector3 pos = mContainerTrans.anchoredPosition3D;
            Vector2 vPos = GetContainerVaildPos(pos.x, pos.y);
            if (Mathf.Abs(pos.x - vPos.x) > 3)
            {
                return false;
            }
            if (Mathf.Abs(pos.y - vPos.y) > 3)
            {
                return false;
            }
            return true;
        }

        GridItemGroup GetOneItemGroupObj()
        {
            int count = mItemGroupObjPool.Count;
            if (count == 0)
            {
                return new GridItemGroup();
            }
            GridItemGroup ret = mItemGroupObjPool[count - 1];
            mItemGroupObjPool.RemoveAt(count - 1);
            return ret;
        }
        void RecycleOneItemGroupObj(GridItemGroup obj)
        {
            mItemGroupObjPool.Add(obj);
        }

        public void Dispose()
        {
            RecycleAllItem();
            int count = mItemPoolList.Count;
            for (int i = 0; i < count; ++i)
            {
                mItemPoolList[i].DestroyAllItem();
            }
            mItemPoolList.Clear();
            mItemPoolDict.Clear();
            mListViewInited = false;
            mScrollBarClickEventListener1 = null;
            mScrollBarClickEventListener2 = null;
            mOnGetItemByRowColumn = null;
            mOnRecycleItem = null;
            mOnBeginDragAction = null;
            mOnDragingAction = null;
            mOnEndDragAction = null;
            mOnSnapItemFinished = null;
            mOnSnapNearestChanged = null;

            if (mContainerTrans != null)
            {
                mContainerTrans.anchoredPosition3D = Vector3.zero;
                mContainerTrans.sizeDelta = Vector2.zero;
            }

        }

        protected void OnRectTransformDimensionsChange()
        {
            if (!mListViewInited) return;
            mRefreshRawOrColumn = true;
        }
    }

}
