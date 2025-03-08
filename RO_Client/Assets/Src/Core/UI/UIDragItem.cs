using UnityEngine;
using System.Collections;
using LuaInterface;

public class UIDragItem : MonoBehaviour
{
    public UnityEngine.Events.UnityAction onBeginDrag;
    public UnityEngine.Events.UnityAction onEndDrag;

    public RectTransform RT
    {
        get { return rt; }
    }

    public int slotIdx = 0;

    UIEventTriggerListener triggerListener = null;
    RectTransform parentRT = null;
    RectTransform rt = null;
    RectTransform mCursor;

    private void Start()
    {
        if (this.transform.parent != null)
        {
            parentRT = this.transform.parent.GetComponent<RectTransform>();
        }

        rt = GetComponent<RectTransform>();
        triggerListener = UIEventTriggerListener.Get(this.gameObject);
        triggerListener.onBeginDrag = OnBeginDrag;
        triggerListener.onDrag = OnDrag;
        triggerListener.onEndDrag = OnEndDrag;
        triggerListener.onDrop = OnDrop;

        this.lastSlotIdx = slotIdx;
    }

    void OnBeginDrag()
    {
        if (onBeginDrag != null)
            onBeginDrag();
    }

    void OnDrag()
    {
        if (parentRT != null && mCursor != null)
        {
            Vector2 result = UIEventTriggerListener.ScreenPointToLocalPointInRectangle(parentRT, UIEventTriggerListener.currentEventData);
            mCursor.anchoredPosition = result;
        }
    }

    void OnEndDrag()
    {
        if (onEndDrag != null)
            onEndDrag();

        rt.anchoredPosition = Vector2.zero;

        DebugHelper.LogError("lastSlotIdx:"+lastSlotIdx + " curSlotIdx:"+slotIdx);
    }

    void OnDrop()
    {   
        GameObject dragObj = UIEventTriggerListener.currentEventData.pointerDrag;
        UIDragItem dragItem = dragObj.GetComponent<UIDragItem>();

        int temp = dragItem.slotIdx;
        dragItem.SetSkillSlot(this.slotIdx);
        this.slotIdx = temp;
    }

    public void RefreshParent()
    {
        parentRT = this.transform.parent.GetComponent<RectTransform>();
    }

    int lastSlotIdx = 0;
    public int LastSlotIdx
    {
        get { return lastSlotIdx; }
    }

    public void SetSkillSlot(int idx)
    {
        lastSlotIdx = this.slotIdx;
        this.slotIdx = idx;
    }

    public void Reset(int idx)
    {
        this.lastSlotIdx = idx;
        this.slotIdx = idx;
    }

    public void SetMoveItem(RectTransform cursorRT)
    {
        if (cursorRT == null) return;

        mCursor = cursorRT;
        cursorRT.SetParent(this.parentRT);
        cursorRT.anchoredPosition = Vector2.zero;
        cursorRT.gameObject.SetActive(true);
    }
}
