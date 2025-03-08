using UnityEngine;
using System.Collections;
using System.Collections.Generic;

//掉落类型
public enum DropItemType
{
    GOLD = 1,       //金币
    EXP = 2,        //经验
    PARTNEREXP = 3, //伙伴经验
    JOBEXP = 4,        //职业经验
    ITEM = 5,       //道具
}

public class DropItemInfo
{
    public Vector3 dropPos;
    public DropItemType itemType;

    public DropItemInfo(Vector3 pos,DropItemType type)
    {
        this.dropPos = pos;
        this.itemType = type;
    }
}

public class BattleDropMgr : Singleton<BattleDropMgr>
{
    public const int c_max_cache_dropitem_num = 30;
    public const string drop_gold_prefab_name = "Battle/DropGold";
    public const string drop_exp_prefab_name = "Battle/DropExp";
    public const string drop_jobexp_prefab_name = "Battle/DropJobExp";
    public const string drop_partnerexp_prefab_name = "Battle/DropParnterExp";
    public const string drop_item_prefab_name = "Battle/DropItem";

    private List<DropItem2D> mDropItems = new List<DropItem2D>();
    private Queue<DropItemInfo> mWaitingDropItems = new Queue<DropItemInfo>();

    private GameObject mDropRoot = null;
    public GameObject Root { get { return mDropRoot; } }

    public override void Init()
    {
        base.Init();
        
        InitRoot();
        EventMgr.AddEventListener<Vector3[]>(ECoreEventType.EID_DROP_ITEMS, OnDropItem);
        EventMgr.AddEventListener<int, bool>(ECoreEventType.EID_UI_VISIBLE, OnUIChangeVis);
    }

    void InitRoot()
    {
        if(mDropRoot == null)
        {
            mDropRoot = new GameObject("DropRoot");
            mDropRoot.transform.SetParent(UIMgr.Instance.UIBattleRootTrans);

            RectTransform rt = mDropRoot.AddComponent<RectTransform>();
            rt.anchorMin = Vector2.zero;
            rt.anchorMax = Vector2.one;
            rt.anchoredPosition3D = Vector3.zero;
            rt.offsetMin = rt.offsetMax = Vector2.zero;
            rt.localScale = Vector3.one;

            Canvas canvas = mDropRoot.AddComponent<Canvas>();
            canvas.overrideSorting = true;
            canvas.sortingOrder = GlobalConfig.Instance.GetConfigIntValue(149);
            mDropRoot.layer = LayerMask.NameToLayer("UI");
        }
    }

    public override void UnInit()
    {
        base.UnInit();
        EventMgr.RemoveEventListener<Vector3[]>(ECoreEventType.EID_DROP_ITEMS, OnDropItem);
    }

    public void Update(float deltaTime)
    {
        if(null != mDropItems)
        {
            for (int idx = mDropItems.Count - 1; idx >= 0; idx--)
            {
                if (mDropItems[idx].IsValid(deltaTime)) continue;

                mDropItems[idx].Dispose();
                mDropItems.RemoveAt(idx);
            }
        }
       
        if(null != mWaitingDropItems)
        {
            if (mWaitingDropItems.Count > 0)
            {
                for (int idx = 0; idx < 3 && idx < mWaitingDropItems.Count; idx++)
                {
                    DropItemInfo itemInfo = mWaitingDropItems.Dequeue();
                    if (null != itemInfo)
                    {
                        DropItem2D item = new DropItem2D(itemInfo.dropPos, itemInfo.itemType);
                        mDropItems.Add(item);
                    }
                }
            }
        }        
    }

    public string GetItemPrefabName(DropItemType type)
    {
        if (type == DropItemType.GOLD)
            return BattleDropMgr.drop_gold_prefab_name;
        if (type == DropItemType.EXP)
            return BattleDropMgr.drop_exp_prefab_name;

        if (type == DropItemType.PARTNEREXP)
            return BattleDropMgr.drop_partnerexp_prefab_name;

        if (type == DropItemType.JOBEXP)
            return BattleDropMgr.drop_jobexp_prefab_name;

        return BattleDropMgr.drop_item_prefab_name;
    }

    public void PrecacheGo()
    {
        ResourceMgr.Instance.SetGoPoolMaxCacheNum(Constants.UIPath, drop_gold_prefab_name, c_max_cache_dropitem_num);

        for(int idx =0; idx < c_max_cache_dropitem_num;idx++)
        {
            GameObject go = ResourceMgr.Instance.GetGoFromPool(Constants.UIPath, drop_gold_prefab_name);
            if (go != null)
            {
                ResourceMgr.Instance.RecycleGO(Constants.UIPath, drop_gold_prefab_name, go);
            }
        }

        for (int idx = 0; idx < 5; idx++)
        {
            GameObject go = ResourceMgr.Instance.GetGoFromPool(Constants.UIPath, drop_exp_prefab_name);
            if (go != null)
            {
                ResourceMgr.Instance.RecycleGO(Constants.UIPath, drop_exp_prefab_name, go);
            }
        }

        for (int idx = 0; idx < 5; idx++)
        {
            GameObject go = ResourceMgr.Instance.GetGoFromPool(Constants.UIPath, drop_partnerexp_prefab_name);
            if (go != null)
            {
                ResourceMgr.Instance.RecycleGO(Constants.UIPath, drop_partnerexp_prefab_name, go);
            }
        }

        for (int idx = 0; idx < 5; idx++)
        {
            GameObject go = ResourceMgr.Instance.GetGoFromPool(Constants.UIPath, drop_jobexp_prefab_name);
            if (go != null)
            {
                ResourceMgr.Instance.RecycleGO(Constants.UIPath, drop_jobexp_prefab_name, go);
            }
        }

        for (int idx = 0; idx < 5; idx++)
        {
            GameObject go = ResourceMgr.Instance.GetGoFromPool(Constants.UIPath, drop_item_prefab_name);
            if (go != null)
            {
                ResourceMgr.Instance.RecycleGO(Constants.UIPath, drop_item_prefab_name, go);
            }
        }
    }

    Vector3 sPos = Vector3.zero;
    Vector3 tGoldPos = Vector3.zero;
    Vector3 tExpPos = Vector3.zero;
    Vector3 tPExpPos = Vector3.zero;
    Vector3 tJobExpPos = Vector3.zero;
    float lifeTime = 1.0f;
    int goldCnt = 0;
    int expCnt = 0;
    int pExpCnt = 0;
    int jobExpCnt = 0;
    List<DropItem2D> tempItems = new List<DropItem2D>();
    float goldRange = 0.15f;
    float expRange = 0.25f;

    public void GenerateDropItems(Vector3 startPos,bool createGold,Vector3 toGoldPos,bool createExp,Vector3 toExpPos,bool createPartnerExp,Vector3 toPartnerExpPos, bool createJobExp, Vector3 toJobExpPos,string[] itemIcons,float goldRange,float expRange)
    {
        if (!mDropRoot.activeSelf) return;

        tempItems.Clear();
        lifeTime = GlobalConfig.Instance.GetConfigFloatValue(57);

        sPos = startPos;
        tGoldPos = toGoldPos;
        tExpPos = toExpPos;
        tPExpPos = toPartnerExpPos;
        tJobExpPos = toJobExpPos;
        this.goldRange = goldRange;
        this.expRange = expRange;

        if (createGold)
        {
            int maxGold = GlobalConfig.Instance.GetConfigIntValue(59);
            int minGold = GlobalConfig.Instance.GetConfigIntValue(58);
            goldCnt = Random.Range(minGold, maxGold);
            int delttime = (int)(GlobalConfig.Instance.GetConfigFloatValue(70) * 1000);

            OnDelayCreateGold(0);
            if (goldCnt > 1)
                TimerManager.Instance.AddTimer(delttime, goldCnt-1, OnDelayCreateGold);
        }

        if(createExp)
        {
            int maxExp = GlobalConfig.Instance.GetConfigIntValue(60);
            int minExp = GlobalConfig.Instance.GetConfigIntValue(61);
            expCnt = Random.Range(minExp, maxExp);
            int delttime = (int)(GlobalConfig.Instance.GetConfigFloatValue(71) * 1000);

            OnDelayCreateExp(0);
            if ( expCnt > 1)
                TimerManager.Instance.AddTimer(delttime, expCnt - 1, OnDelayCreateExp);
        }

        if (createPartnerExp)
        {
            int maxPartnerExp = GlobalConfig.Instance.GetConfigIntValue(62);
            int minPartnerExp = GlobalConfig.Instance.GetConfigIntValue(63);
            pExpCnt = Random.Range(minPartnerExp, maxPartnerExp);

            int delttime = (int)(GlobalConfig.Instance.GetConfigFloatValue(72) * 1000);
            OnDelayCreatePExp(0);

            if (pExpCnt > 1)
                TimerManager.Instance.AddTimer(delttime, pExpCnt - 1, OnDelayCreatePExp);
        }

        if(createJobExp)
        {
            int maxExp = GlobalConfig.Instance.GetConfigIntValue(60);
            int minExp = GlobalConfig.Instance.GetConfigIntValue(61);
            jobExpCnt = Random.Range(minExp, maxExp);
            int delttime = (int)(GlobalConfig.Instance.GetConfigFloatValue(71) * 1000);

            OnDelayCreateJobExp(0);
            if (expCnt > 1)
                TimerManager.Instance.AddTimer(delttime, jobExpCnt - 1, OnDelayCreateJobExp);
        }

        if(itemIcons!=null)
        {
            for(int idx =0; idx < itemIcons.Length;idx++)
            {
                DropItem2D item = new DropItem2D(startPos, toPartnerExpPos, 0, 300,0,1,0.5f, DropItemType.ITEM,itemIcons[idx]);
                mDropItems.Add(item);
                tempItems.Add(item);
            }
        }
    }

    void OnDelayCreateGold(int seq)
    {
        DropItem2D item = new DropItem2D(sPos, tGoldPos, -goldRange * UIMgr.SCREEN_WIDTH, goldRange * UIMgr.SCREEN_WIDTH,-goldRange*100, goldRange * 100, 0.5f * lifeTime, DropItemType.GOLD);
        mDropItems.Add(item);
        tempItems.Add(item);
        goldCnt--;
        CheckCreateOk();
    }

    void OnDelayCreateExp(int seq)
    {
        DropItem2D item = new DropItem2D(sPos, tExpPos, -expRange * UIMgr.SCREEN_WIDTH, expRange * UIMgr.SCREEN_WIDTH,0,1, 0.5f * lifeTime, DropItemType.EXP);
        mDropItems.Add(item);
        tempItems.Add(item);
        expCnt--;
        CheckCreateOk();
    }

    void OnDelayCreateJobExp(int seq)
    {
        DropItem2D item = new DropItem2D(sPos, tJobExpPos, -expRange * UIMgr.SCREEN_WIDTH, expRange * UIMgr.SCREEN_WIDTH, 0, 1, 0.5f * lifeTime, DropItemType.JOBEXP);
        mDropItems.Add(item);
        tempItems.Add(item);
        jobExpCnt--;
        CheckCreateOk();
    }

    void OnDelayCreatePExp(int seq)
    {
        DropItem2D item = new DropItem2D(sPos, tPExpPos, 0, 200, 0, 1, 0.5f * lifeTime, DropItemType.PARTNEREXP);
        mDropItems.Add(item);
        tempItems.Add(item);
        pExpCnt--;
        CheckCreateOk();
    }

    void CheckCreateOk()
    {
        //if(pExpCnt <= 1 && goldCnt <= 1 && expCnt<=1)
        //{
        //    for (int idx = 0; idx < tempItems.Count; idx++)
        //        tempItems[idx].BeginMove();

        //    tempItems.Clear();
        //}
        tempItems.Clear();
    }

    void OnDropItem(CoreEvent<Vector3[]> ce)
    {
        Vector3[] posList = ce.Data;
        for(int idx =0; idx < posList.Length; idx++)
        {
            CreateDropItem(posList[idx], DropItemType.GOLD);
        }
    }

    void OnUIChangeVis(CoreEvent<int,bool> ce)
    {
        int pageId = ce.Data;
        bool vis = ce.Data1;

        if(pageId == UIPageIDs.PAGE_ID_BATTLE)
        {
            mDropRoot.SetActive(vis);
        }
    }

    void CreateDropItem(Vector3 worldPos, DropItemType type)
    {
        if (!mDropRoot.activeSelf) return;

        DropItemInfo itemInfo = new DropItemInfo(worldPos, type);
        mWaitingDropItems.Enqueue(itemInfo);
    }
}
