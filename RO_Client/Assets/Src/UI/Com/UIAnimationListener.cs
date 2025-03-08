using UnityEngine;
using System.Collections;

public class UIAnimationListener : MonoBehaviour
{
    private UIBase mListenerPage;

    public void OnOpenAnimEnd()
    {
        if (mListenerPage != null) mListenerPage.OnOpenAnimEnd();
    }

    public void OnCloseAnimEnd()
    {
        if (mListenerPage != null) mListenerPage.OnCloseAnimEnd();
    }

    public void OnSubCloseAnimEnd(string path)
    {
        if (mListenerPage != null) mListenerPage.OnSubCloseAnimEnd(path);
    }

    public UIBase ListenerPage
    {
        get { return mListenerPage; }
        set { mListenerPage = value; }
    }

    void OnDestroy()
    {
        mListenerPage = null;
    }
}
