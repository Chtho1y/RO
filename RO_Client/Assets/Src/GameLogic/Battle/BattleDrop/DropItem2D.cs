using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class DropItem2D
{
    private DropItemType itemType;
    private Vector3 fromPos;
    private Vector3 toPos;
    private GameObject itemGo;
    private RectTransform rt = null;
    private TweenPosition tp = null;
    private bool bDroped = false;
    private string prefabName = "";
    private float lifeTime = 0.5f;
    private float delayTime = 0.3f;

    TweenScale ts = null;

    public DropItem2D(Vector3 worldPos, DropItemType type)
    {
        prefabName = BattleDropMgr.Instance.GetItemPrefabName(type);
        itemType = type;

        Vector3 tempPos = BattleCamera.Instance.RealCamera.WorldToViewportPoint(worldPos);
        itemGo = ResourceMgr.Instance.GetGoFromPool(Constants.UIPath, prefabName);
        fromPos = new Vector3((tempPos.x - 0.5f) * UIMgr.SCREEN_WIDTH, (tempPos.y - 0.5f) * UIMgr.SCREEN_HEIGHT, 0);

        bDroped = false;
        toPos = BattleMgr.s_reward_pos;
        lifeTime = GlobalConfig.Instance.GetConfigFloatValue(82);
        delayTime = GlobalConfig.Instance.GetConfigFloatValue(81);
        InitItem();
        BeginMove(0.0f);
    }

    public DropItem2D(Vector3 pos,Vector3 toPos,float minRangeX,float maxRangeX,float minRangeY,float maxRangeY,float lifeTime,DropItemType type,string icon = "")
    {
        itemType = type;
        prefabName = BattleDropMgr.Instance.GetItemPrefabName(type);
        itemGo = ResourceMgr.Instance.GetGoFromPool(Constants.UIPath, prefabName);
        this.lifeTime = lifeTime;
        //Vector3 tempPos = pos;
        //tempPos.x += Random.Range(minRangeX, maxRangeX);
        //tempPos.y += Random.Range(minRangeY, maxRangeY);
        this.fromPos = pos;
        this.toPos = toPos;

        bDroped = false;
        delayTime = 0.0f; 
        InitItem();
        LoadItemIcon(icon);

        //BeginMove();
        if (itemGo)
        {
            Vector3 tempPos = pos;
            tempPos.x += Random.Range(minRangeX, maxRangeX);
            tp = TweenPosition.Begin(itemGo, 0.06f, tempPos);
            if (tp != null)
            {
                float dur = 0.06f;
                tp.delay = 0;
                tp.duration = dur;
                TimerManager.Instance.AddTimer((int)(dur * 1000), 1, OnChangeDropPos);
            }
        }
    }

    public void BeginMove(float scale)
    {
        if (itemGo)
        {
            rt.localScale = new Vector3(1, 1, 1);
            ts = TweenScale.Begin(itemGo, this.lifeTime, new Vector3(scale, scale, scale));
            if (ts != null)
            {
                ts.delay = delayTime;
                ts.duration = this.lifeTime;
                ts.enabled = true;
            }

            tp = TweenPosition.Begin(itemGo, this.lifeTime, toPos);
            if (tp != null)
            {
                tp.delay = delayTime;
                tp.duration = this.lifeTime;
                tp.onFinished = OnFinished;
            }
        }
    }

    void LoadItemIcon(string itemIcon)
    {
        if (itemGo == null || itemType != DropItemType.ITEM || string.IsNullOrEmpty(itemIcon)) return;

        Transform iconTrans = itemGo.transform.Find("Item/icon");
        if (iconTrans == null) return;

        Image icon = iconTrans.GetComponent<Image>();
        icon.sprite = ResourceMgr.Instance.LoadAssetSync<Sprite>(Constants.IconDir, itemIcon);
    }

    void OnChangeDropPos(int timerSeq)
    {
        BeginMove(0.5f);
    }

    void InitItem()
    {
        if (itemGo != null)
        {
            itemGo.transform.SetParent(BattleDropMgr.Instance.Root.transform);
            itemGo.transform.localScale = Vector3.one;
            itemGo.transform.localRotation = Quaternion.identity;

            rt = itemGo.GetComponent<RectTransform>();
            rt.localScale = Vector3.one;
            rt.anchorMin = new Vector2(0.5f,0.5f);
            rt.anchorMax = new Vector2(0.5f, 0.5f);
            rt.pivot =  Vector2.zero;
            rt.anchoredPosition3D = fromPos;
            ts = itemGo.GetComponent<TweenScale>();
            if (ts != null)
                ts.enabled = false;

            tp = itemGo.GetComponent<TweenPosition>();
            if (tp != null)
                tp.enabled = false;
        }
    }

    void OnFinished()
    {
        bDroped = true;
    }

    public bool IsValid(float deltatime)
    {
        if (itemGo == null) return false;

        return  !bDroped;
    }

    public void Dispose()
    {
        if (itemGo != null)
        {
            itemGo.transform.localScale = Vector3.one;
            if (ts != null)
            {
                ts.enabled = false;
            }

            ResourceMgr.Instance.RecycleGO(Constants.UIPath, prefabName, itemGo);
            itemGo = null;
        }
    }
}
