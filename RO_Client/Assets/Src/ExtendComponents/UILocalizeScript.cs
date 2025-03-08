using System.Collections;
using TMPro;
using UnityEngine;
using UnityEngine.UI;


public class UILocalizeScript : MonoBehaviour
{
    public string m_key;

    private string mContent;
    private object[] m_Values;

    private Text mText;
    private TextMeshProUGUI mTextMeshProUGUI;

    bool hasSeted = false;
    private void Awake()
    {
        mText = GetComponent<Text>();
        mTextMeshProUGUI = GetComponent<TextMeshProUGUI>();
        Inner_SetContent(m_key);
    }

    void OnEnable()
    {
#if UNITY_EDITOR
        string old = mContent;
        Inner_SetContent(m_key);
        if (old != mContent)
            Refresh();
#endif
    }

    void Start()
    {
        if (hasSeted) return;

        if (!string.IsNullOrEmpty(m_key))
        {
            Inner_SetContent(m_key);
        }

        Refresh();
    }


    public void OnChangeLang()
    {
        if (!string.IsNullOrEmpty(m_key))
        {
            Inner_SetContent(m_key);
            Refresh();
        }
    }

    void Refresh()
    {
        if (mText == null)
        {
            mText = GetComponent<Text>();
        }
        if (!mTextMeshProUGUI)
        {
            mTextMeshProUGUI = GetComponent<TextMeshProUGUI>();
        }

        if (!string.IsNullOrEmpty(mContent))
        {
            string content;
            if (m_Values != null && m_Values.Length > 0)
            {
                content = string.Format(mContent, m_Values);
            }
            else
            {
                content = mContent;
            }
            if (mText)
            {
                mText.text = content;
            }
            if (mTextMeshProUGUI)
            {
                mTextMeshProUGUI.text = content;
            }
        }
    }

    void RefreshWithColor(string colorText)
    {
        if (mText == null)
        {
            mText = GetComponent<Text>();
        }
        if (!mTextMeshProUGUI)
        {
            mTextMeshProUGUI = GetComponent<TextMeshProUGUI>();
        }

        if (!string.IsNullOrEmpty(mContent))
        {
            string content;
            if (m_Values != null && m_Values.Length > 0)
            {
                content = string.Format(mContent, m_Values);
            }
            else
            {
                content = mContent;
            }
            colorText = colorText.Replace("%s", "{0}");
            content = string.Format(colorText, content);
            if (mText)
            {
                mText.text = content;
            }
            if (mTextMeshProUGUI)
            {
                mTextMeshProUGUI.text = content;
            }
        }
        else
        {
            CleanContent();
        }
    }

    public void SetContent(string contentKey)
    {
        hasSeted = true;

        if (!string.IsNullOrEmpty(contentKey))
        {
            m_key = contentKey;
            Inner_SetContent(m_key);
            Refresh();
        }
        else
        {
            CleanContent();
        }
    }

    public void CleanContent()
    {
        m_key = "";
        if (mText)
        {
            mText.text = "";
        }
        if (mTextMeshProUGUI)
        {
            mTextMeshProUGUI.text = "";
        }
    }

    public void SetValues(object[] values)
    {
        hasSeted = true;
        if (m_Values != values)
        {
            m_Values = values;
            Refresh();
        }
    }

    public void SetContentAndValues(string contentKey, object[] values)
    {
        hasSeted = true;
        bool isChanged = false;
        if (!string.IsNullOrEmpty(contentKey))
        {
            m_key = contentKey;
            Inner_SetContent(m_key);
            isChanged = true;
        }
        if (m_Values != values)
        {
            m_Values = values;
            isChanged = true;
        }

        if (isChanged)
        {
            Refresh();
        }
    }

    public void SetContentWithColor(string contentKey, string colorText)
    {
        hasSeted = true;
        if (!string.IsNullOrEmpty(contentKey))
        {
            m_key = contentKey;
            Inner_SetContent(m_key);
            RefreshWithColor(colorText);
        }
        else
        {
            CleanContent();
        }
    }

    public void SetValuesWithColor(object[] values, string colorText)
    {
        hasSeted = true;
        if (m_Values != values)
        {
            m_Values = values;
            RefreshWithColor(colorText);
        }
    }

    public void SetContentAndValuesWithColor(string contentKey, object[] values, string colorText)
    {
        hasSeted = true;
        bool isChanged = false;
        if (!string.IsNullOrEmpty(contentKey))
        {
            m_key = contentKey;
            Inner_SetContent(m_key);
            isChanged = true;
        }
        if (m_Values != values)
        {
            m_Values = values;
            isChanged = true;
        }

        if (isChanged)
        {
            RefreshWithColor(colorText);
        }
    }

    private void Inner_SetContent(string contentKey)
    {
        mContent = I18N.T(contentKey);
        mContent = mContent.Replace("\\n", "\n");
    }
}
