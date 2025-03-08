using UnityEngine;
using System.Collections;
using System.Collections.Generic;

//public enum FighterTriggerEvent
//{
//    TEvent_Fighter_TurnForwardTo = 0,
//    TEvent_Fighter_Offset = 1,
//    TEvent_Fighter_FixedOffset = 2,
//    TEvent_Fighter_MoveTo = 3,
//}

public class FighterTrigger : MonoBehaviour {

    //public FighterTriggerEvent triggerEvent;
    //public List<TriggerParam> triggerParams;
    //public bool enableInFighting = false;

    ////void OnTriggerEnter(Collider other)
    ////{
    ////    if (other.gameObject.tag == "Fighter")
    ////    {
    ////        if (!FighterOnTrigger.IsObjectSpawnedLeftFighter(other.gameObject))
    ////            return;

    ////        if (!FighterOnTrigger.IsColliderFighterBox(other))
    ////            return;

    ////        //Log.D("{0} 进入触发器 {1}，当前位置{2}， 相机位置{3}，旋转{4}", other.gameObject.name, gameObject.name, other.gameObject.transform.position,
    ////        //    GameMgr.Instance.Camera3DContainer.transform.position, GameMgr.Instance.Camera3DContainer.transform.eulerAngles);

    ////        FighterOnTrigger fighterOnTrigghter = other.gameObject.GetComponent<FighterOnTrigger>();
    ////        if (fighterOnTrigghter != null)
    ////        {
    ////            if (fighterOnTrigghter.Fighter.IsFighting && !enableInFighting)
    ////                return;
    ////            fighterOnTrigghter.Fighter.DoFighterTriggerEvent(this);
    ////        }
                
    ////    }
    ////}

    //public float GetFloat(string paramName)
    //{
    //    foreach (TriggerParam param in triggerParams)
    //    {
    //        if (param.name == paramName)
    //        {
    //            return param.floatValue;
    //        }
    //    }

    //    return 0f;
    //}

    //public float[] GetFloats(string paramName)
    //{
    //    List<float> values = new List<float>();

    //    foreach (TriggerParam param in triggerParams)
    //    {
    //        if (param.name == paramName)
    //        {
    //            values.Add(param.floatValue);
    //        }
    //    }

    //    return values.ToArray();
    //}

    //public string GetString(string paramName)
    //{
    //    foreach (TriggerParam param in triggerParams)
    //    {
    //        if (param.name == paramName)
    //        {
    //            return param.stringValue;
    //        }
    //    }

    //    return "";
    //}

    //public string[] GetStrings(string paramName)
    //{
    //    List<string> values = new List<string>();

    //    foreach (TriggerParam param in triggerParams)
    //    {
    //        if (param.name == paramName)
    //        {
    //            values.Add(param.stringValue);
    //        }
    //    }

    //    return values.ToArray();
    //}

}
