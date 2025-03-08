using UnityEngine;
using System.Collections;
using UnityEngine.EventSystems;
using UnityEngine.Events;
using System.Collections.Generic;

public class UIBattleMouseMove : MonoBehaviour
{
    bool startMoving = false; 
    UIEventTriggerListener trigger;

    CoreEvent<Vector2> startCE = new CoreEvent<Vector2>(ECoreEventType.EID_START_MOVE_MOUSE, Vector2.zero);
    CoreEvent<Vector2> ce = new CoreEvent<Vector2>(ECoreEventType.EID_MOUSE_DELTA, Vector2.zero);
    CoreEvent<Vector2> endCE = new CoreEvent<Vector2>(ECoreEventType.EID_END_MOVE_MOUSE, Vector2.zero);

    private void Start()
    {
        trigger = UIEventTriggerListener.Get(this.gameObject);
        trigger.onBeginDrag = OnBeginDrag;
        trigger.onDrag = OnDrag;
        trigger.onEndDrag = OnEndDrag;
        trigger.onPointerExit = OnDeselect;
    }

    private void OnBeginDrag()
    {
        startMoving = true;
        startCE.SetData(UIEventTriggerListener.currentEventData.delta);
        EventMgr.DispatchEvent<Vector2>(startCE);
    }

    private void OnDrag()
    {
        if(startMoving)
        {
            Vector2 delta = UIEventTriggerListener.currentEventData.delta;
            ce.SetData(delta);
            EventMgr.DispatchEvent<Vector2>(ce);
        }
    }

    private void OnEndDrag()
    {
        if(startMoving)
        {
            startMoving = false;
            endCE.SetData(UIEventTriggerListener.currentEventData.delta);
            EventMgr.DispatchEvent<Vector2>(endCE);
        }
    }

    private void OnDeselect()
    {
        //OnEndDrag();
    }
}
