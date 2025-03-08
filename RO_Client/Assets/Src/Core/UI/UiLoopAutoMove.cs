using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using LuaInterface;

public delegate void LuaAutoMoveCallback(UnityEngine.UI.Text Text);
public class UiLoopAutoMove : MonoBehaviour
{
    public GameObject[] mArrayItem;
    public float fHeight = 40.0f;
    private float fAllHeight = 40.0f;
    public float fMoveSpeed = 10.0f;
    private bool bIsRun = false;
    private LuaAutoMoveCallback mLuaOnSelectedCallback = null;

    void Start()
    {
        
    }

    void Update()
    {
        if(bIsRun)
        {
            Move();
        }
    }

    public void SetText(int nIndex ,string strInfo)
    {
        if (null != mArrayItem)
        {
            fAllHeight = fHeight * mArrayItem.Length;
        }

        if (nIndex > mArrayItem.Length)
            return;
    
        UnityEngine.UI.Text UiText = mArrayItem[nIndex].GetComponentInChildren<UnityEngine.UI.Text>();
        if (null != UiText)
        {
            UiText.text = strInfo;
        }        
    }

    public void Init(string[] ArrayStrInfo)
    {
        if (null != mArrayItem)
        {
            fAllHeight = fHeight * mArrayItem.Length;
        }

        int nMinLenth = ArrayStrInfo.Length > mArrayItem.Length ? mArrayItem.Length : ArrayStrInfo.Length;

        for (int i = 0; i < nMinLenth; i++)
        {
            UnityEngine.UI.Text UiText = mArrayItem[i].GetComponentInChildren<UnityEngine.UI.Text>();
            if (null != UiText)
            {
                UiText.text = ArrayStrInfo[i];
            }
        }
    }

    public void RunMove()
    {
        bIsRun = true;
    }

    public void StopMove()
    {
        bIsRun = false;
    }

    public void SetChangeInfoCb(LuaAutoMoveCallback cb)
    {
        mLuaOnSelectedCallback = cb;
    }

    private void Move()
    {
        if (null != mArrayItem)
        for(int i=0;i< mArrayItem.Length;i++)
        {
            RectTransform RectTrans = mArrayItem[i].GetComponentInChildren<RectTransform>();
            Vector2 v2MovePos = RectTrans.anchoredPosition;
            v2MovePos.y += fMoveSpeed * Time.deltaTime;
            RectTrans.anchoredPosition = v2MovePos;
        }
        Refresh();
    }

    private void Refresh()
    {
        for (int i = 0; i < mArrayItem.Length; i++)
        {
            RectTransform RectTrans = mArrayItem[i].GetComponentInChildren<RectTransform>();
            Vector2 v2MovePos = RectTrans.anchoredPosition;
            if(v2MovePos.y > fHeight * 0.5f)
            {
                ChangeInfo(i);
            }
        }
    }

    private void ChangeInfo(int nIndex)
    {
        if(null != mArrayItem)
        if (mArrayItem.Length > nIndex)
        {
            //set Pos
            int nNext = GetNext(nIndex);
            //Debug.Log("Change"+nIndex.ToString());
            //Debug.Log("nNext" + nNext.ToString());
            RectTransform RectNextTrans = mArrayItem[nNext].GetComponentInChildren<RectTransform>();
            RectTransform RectTrans = mArrayItem[nIndex].GetComponentInChildren<RectTransform>();
            Vector2 v2MovePos = RectTrans.anchoredPosition;
            float fOffset = fHeight;
            v2MovePos.y = RectNextTrans.anchoredPosition.y - fOffset;
            RectTrans.anchoredPosition = v2MovePos;
            
            UnityEngine.UI.Text UiText = mArrayItem[nIndex].GetComponentInChildren<UnityEngine.UI.Text>();
            if (mLuaOnSelectedCallback != null)
            {
                mLuaOnSelectedCallback.DynamicInvoke(UiText);
            }
        }       
    }

    private int GetNext(int nIndex)
    {
        nIndex += 1;
        int nNext = ((mArrayItem.Length - 1) + nIndex) % mArrayItem.Length;        
        nNext -= 1;
        if (nNext < 0)
            nNext = mArrayItem.Length - 1;
        return nNext;       
    }
}
