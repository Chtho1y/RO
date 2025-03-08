using System;
using UnityEngine;
using System.Collections.Generic;

public class UIAnimationEvent : MonoBehaviour
{
    private UIBase mBasePage;

    public UIBase BasePage
    {
        get { return mBasePage; }
        set { mBasePage = value; }
    }

    public void ActiveEffect(string effectName)
    {
		//if (mBasePage == null) {
		//	Transform effectTrans = transform.Find(effectName);
		//	if (effectTrans != null) {
		//		effectTrans.gameObject.SetActive (true);
		//		Canvas canvas = effectTrans.GetComponentInParent<Canvas> ();
		//		if (canvas != null)
		//			EffectUtility.Instance.SetEffectSortingOrder (effectTrans, canvas.sortingOrder + 1);
		//	}
		//}
  //      else if(!BasePage.ActiveAnimEffect(effectName))
  //      {
  //          Transform effectTrans = transform.Find(effectName);
		//	if (effectTrans != null) {
		//		effectTrans.gameObject.SetActive (true);
		//		EffectUtility.Instance.SetEffectSortingOrder (effectTrans, mBasePage.SortingOrder + 1);
		//	}
  //      }
    }

    public void DisActiveEffect(string effectName)
    {
		//if (mBasePage == null) {
		//	Transform effectTrans = transform.Find(effectName);
		//	if (effectTrans != null)
		//		effectTrans.gameObject.SetActive(false);
		//}
  //      else if (!BasePage.DisActiveAnimEffect(effectName))
  //      {
  //          Transform effectTrans = transform.Find(effectName);
  //          if (effectTrans != null)
  //              effectTrans.gameObject.SetActive(false);
  //      }
    }


    /// <summary>
    /// 播放UI声音
    /// </summary>
    /// <param name="soundName"></param>
    public void PlayUISound(string soundName)
    {
        if (MusicMgr.Instance == null) return;

        //MusicMgr.Instance.PlayUISound(soundName, false);
    }

    /// <summary>
    /// 空事件不进行任何处理
    /// </summary>
    public void EmptyEvent()
    {

    }

    /// <summary>
    /// 隐藏自己事件
    /// </summary>
    public void HideSelf()
    {
        gameObject.SetActive(false);
    }

    public void OnAnimCompleted(string pageName)
    {
        //EventMgr.DispatchEvent<string>(new CoreEvent<string>(ECoreEventType.EID_ANIMATION_COMPLETED, pageName));
        if (mBasePage == null) return;

        mBasePage.animListener.OnOpenAnimEnd();
    }

    public void OnCloseAnimCompleted()
    {
        if (mBasePage == null) return;

        mBasePage.animListener.OnCloseAnimEnd();
    }

    public void OnSubCloseAnimCompleted()
    {
        if (mBasePage == null) return;

        UINode node = GetComponent<UINode>();
        if (node == null)
        {
            return;
        }
        string path = string.Empty;
        node.FindUINodeGOPath(ref path);
        mBasePage.animListener.OnSubCloseAnimEnd(path);
    }
}