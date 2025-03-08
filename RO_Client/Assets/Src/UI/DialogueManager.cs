using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;

public delegate void DialogEndCallback(int dialogId);

public class PlayDialogueInfo
{
    public int dialogId;
    public LuaTable luaTable = null;
    public LuaFunction luaCallback = null;
    public DialogEndCallback callbackFun = null;

    public PlayDialogueInfo(int id)
    {
        dialogId = id;
    }

    public PlayDialogueInfo(int id,DialogEndCallback cb)
    {
        dialogId = id;
        callbackFun = cb;
    }

    public PlayDialogueInfo(int id,LuaTable luaTable,LuaFunction lua_cb)
    {
        dialogId = id;
        this.luaTable = luaTable;
        this.luaCallback = lua_cb;
    }
}

public class DialogManager : Singleton<DialogManager>
{
    readonly Queue<PlayDialogueInfo> mDialogInfos = new Queue<PlayDialogueInfo>();

    Coroutine mRunningCoroutine;

    public bool IsDoingDialog { get { return mRunningCoroutine != null || mDialogInfos.Count > 0; } }

    public void PlayDialog(int dialogId)
    {
        if (mRunningCoroutine == null)
            mRunningCoroutine = UIMgr.Instance.StartCoroutine(DoDialog(dialogId));
        else
            mDialogInfos.Enqueue(new PlayDialogueInfo(dialogId));
    }


    IEnumerator DoDialog(int dialogId,DialogEndCallback cb = null,LuaTable luaTb = null, LuaFunction luaCb = null)
    {
        bool needRestoreStoryBlackLine = false;
        Transform storyBlackLine = UIMgr.Instance.transform.Find("StoryBlackLine");
        if (storyBlackLine != null && storyBlackLine.gameObject.activeInHierarchy)
        {
            needRestoreStoryBlackLine = true;
            storyBlackLine.gameObject.SetActive(false);
        }

        yield break;
        //JSONObject param = new JSONObject();
        //param.AddField("dialog_id", dialogId);
        //UIMgr.Instance.Open(UIPageIDs.PAGE_ID_DIALOG_NEW, param);

        //while (!mDialogPage.IsOpened)
        //    yield return 1;

        //while (mDialogPage != null && mDialogPage.IsPlaying)
        //    yield return 1;

        //mDialogPage.Close(null);
        //mDialogPage = null;

        if (needRestoreStoryBlackLine && storyBlackLine != null)
            storyBlackLine.gameObject.SetActive(true);

        if (cb != null)
            cb(dialogId);

        if (luaCb != null)
            luaCb.Call(luaTb, dialogId);

        if (mDialogInfos.Count > 0)
        {
            PlayDialogueInfo info = mDialogInfos.Dequeue();
            mRunningCoroutine = UIMgr.Instance.StartCoroutine(DoDialog(info.dialogId, info.callbackFun, info.luaTable, info.luaCallback));
        }
        else
            mRunningCoroutine = null;
    }
}
