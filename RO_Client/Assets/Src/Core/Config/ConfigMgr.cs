using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class ConfigMgr : Singleton<ConfigMgr>
{
    private int linestart = 1;
    private int rowstart = 1;
    private string splitword = ",";
    private static bool m_bInitCSVFinished = false;
    private static bool m_bInitXMLFinished = false;

    public static bool InitFinished
    {
        get { return m_bInitCSVFinished && m_bInitXMLFinished; }
    }
    private static string m_strCurLangKey = LangKeys.ChinaSimplifiedFull;
    public static string CurLangKey
    {
        get { return m_strCurLangKey; }
        set
        {
            if (m_strCurLangKey != value)
            {
                m_bInitCSVFinished = false;
            }
        }
    }
    public Dictionary<string, Dictionary<string, Dictionary<string, string>>> ConfigDictionary;
    public Dictionary<string, int> ConfigLongthDictionary;

    private Dictionary<string, string> mXmlConfigDict;
    public Dictionary<string, string> XmlConfigDict
    {
        get { return mXmlConfigDict; }
    }

    public override void Init()
    {
        base.Init();
        m_bInitCSVFinished = false;
        m_bInitXMLFinished = false;
        ConfigDictionary = new Dictionary<string, Dictionary<string, Dictionary<string, string>>>(19);
        ConfigLongthDictionary = new Dictionary<string, int>(19);
        mXmlConfigDict = new Dictionary<string, string>();
        GetConfigAsset();
    }

    public override void UnInit()
    {
        if (LaunchThread.HasInstance())
        {
            LaunchThread.Instance.Stop(LaunchThread.AsyncLaunchState.ConfigInit);
        }
        base.UnInit();
    }

    private void GetConfigAsset()
    {
        if (InitFinished)
            return;
        ResourceMgr.Instance.LoadDirAsset<List<TextAsset>>(OnLoadXmlCallback, Constants.XmlConfig);
        ResourceMgr.Instance.LoadDirAsset<List<TextAsset>>(OnCallBack, Constants.CsvConfig);
    }

    public void ResetKeywords()
    {
        if (InitFinished)
            return;
        string m_tableName = string.Format("LanguagePackage{0}", ConfigMgr.CurLangKey);
        if (ConfigDictionary != null && ConfigDictionary.ContainsKey(m_tableName))
        {
            m_bInitCSVFinished = true;
            DebugHelper.Log(" [ConfigMgr] getKeywordsConfigAsset");
        }
        else
        {
            ResourceMgr.Instance.LoadAsset<List<TextAsset>>(OnResetKeywordsCallBack, Constants.CsvConfig, ELoadType.UI, m_tableName);
        }
    }

    void OnCallBack(List<TextAsset> objs, string path_, string[] assetNames_)
    {
        if (objs == null || objs.Count <= 0)
        {
            EventMgr.DispatchEvent(new CoreEvent<int>(ECoreEventType.EID_ConfigMgrInit, 0));
            return;
        }

        if (LaunchThread.HasInstance())
        {
            string keyword = "LanguagePackage";
            string keywordname = string.Format("{0}{1}", keyword, CurLangKey);
            string curname = string.Empty;
            TextAsset tx;
            List<string> names = new List<string>();
            List<string> contents = new List<string>();
            for (int i = 0; i < objs.Count; ++i)
            {
                tx = objs[i];
                curname = tx.name;

                if (curname.Contains(keyword) && !curname.Equals(keywordname) || tx.text.Length <= 0)
                    continue;
                names.Add(curname);
                contents.Add(tx.text);
            }
            keyword = string.Empty;
            keywordname = string.Empty;
            curname = string.Empty;
            System.Action action = () =>
            {
                for (int i = 0, iMax = names.Count; i < iMax; i++)
                {
                    curname = names[i];
                    Dictionary<string, Dictionary<string, string>> ts = getData(curname, contents[i]);
                    if (ConfigDictionary.ContainsKey(curname))
                    {
                        ConfigDictionary[curname] = ts;
                    }
                    else
                    {
                        ConfigDictionary.Add(curname, ts);
                    }
                }
                m_bInitCSVFinished = true;
            };
            LaunchThread.Instance.Start(LaunchThread.AsyncLaunchState.ConfigInit, action, CheckCfgOk, null);
        }
        else
        {
            string keyword = "LanguagePackage";
            string keywordname = string.Format("{0}{1}", keyword, CurLangKey);
            string curname = string.Empty;
            TextAsset tx;
            for (int i = 0; i < objs.Count; ++i)
            {
                tx = objs[i];
                curname = tx.name;

                if (curname.Contains(keyword) && !curname.Equals(keywordname) || tx.text.Length <= 0)
                    continue;

                Dictionary<string, Dictionary<string, string>> ts = getData(curname, tx.text);
                if (ConfigDictionary.ContainsKey(curname))
                {
                    ConfigDictionary[curname] = ts;
                }
                else
                {
                    ConfigDictionary.Add(curname, ts);
                }
            }
            m_bInitCSVFinished = true;
            keyword = string.Empty;
            keywordname = string.Empty;
            curname = string.Empty;
            tx = null;
            CheckCfgOk();
        }
    }

    void OnLoadXmlCallback(List<TextAsset> objs, string path_, string[] assetNames_)
    {
        TextAsset tx;
        for (int i = 0; i < objs.Count; ++i)
        {
            tx = objs[i];
            mXmlConfigDict.Add(tx.name, tx.text);
        }
        m_bInitXMLFinished = true;

        CheckCfgOk();
    }

    void CheckCfgOk()
    {
        if(InitFinished)
        {
            EventMgr.DispatchEvent(new CoreEvent<int>(ECoreEventType.EID_ConfigMgrInit, 1));
        }
    }

    void OnResetKeywordsCallBack(List<TextAsset> objs, string assetPath_, string[] assetNames_)
    {
        if (objs == null || objs.Count <= 0)
        {
            DebugHelper.Log("No Config Data AssetBundle");
            return;
        }
        string keyword = "LanguagePackage";
        string keywordname = string.Format("{0}{1}", keyword, CurLangKey);

        TextAsset tx;
        string curname = string.Empty;
        for (int i = 0; i < objs.Count; ++i)
        {
            tx = objs[i];
            curname = tx.name;
            if (curname.Contains(keyword) && !curname.Equals(keywordname) || tx.text.Length <= 0)
                continue;
            Dictionary<string, Dictionary<string, string>> ts = getData(curname, tx.text);
            if (ConfigDictionary != null)
            {
                if (ConfigDictionary.ContainsKey(curname))
                {
                    ConfigDictionary[curname] = ts;
                }
                else
                {
                    ConfigDictionary.Add(curname, ts);
                }
            }
        }
        m_bInitCSVFinished = true;
    }

    private Dictionary<string, Dictionary<string, string>> getData(string name, string content)
    {
        string[] lineArray;
        string[] charArray;
        // string text = content.Replace("\r", "@");
        // lineArray = text.Split("@"[0]);
        System.IO.StringReader reader = new System.IO.StringReader(content);
        string str = reader.ReadLine();
        List<string> tempList = new List<string>();
        while (!string.IsNullOrEmpty(str))
        {
            tempList.Add(str);
            str = reader.ReadLine();
        }
        lineArray = tempList.ToArray();
        //DebugHelper.LogWarning("[TableName: {0}]lineArray {1}",name, lineArray[0]);
        string[] indexname = lineArray[1].Split(splitword[0]);
        Dictionary<string, Dictionary<string, string>> Table = new Dictionary<string, Dictionary<string, string>>(lineArray.Length);
        int linelength = 0;
        for (int i = linestart; i < lineArray.Length; ++i)
        {
            charArray = lineArray[i].Split(splitword[0]);
            linelength = charArray.Length;
            if (linelength > 0 && charArray[0] == string.Empty)
            {
                //DebugHelper.LogWarning("[ConfigMgr. getData] Empty Index {0} {1}", name, i);
                continue;
            }

            Dictionary<string, string> Row = new Dictionary<string, string>(linelength);
            for (int j = rowstart; j < linelength; ++j)
            {
                if (j == rowstart && indexname[j] == string.Empty)
                {
                    DebugHelper.LogWarning("[ConfigMgr. getData] Empty key {0} {1}", name, j);
                    continue;
                }
#if UNITY_EDITOR
                if (j >= indexname.Length)
                {
                    DebugHelper.LogError("{0},Split error in {1}", name, charArray[0]);
                }
#endif
                if (Row.ContainsKey(indexname[j]))
                {
                    //DebugHelper.LogWarning("[ConfigMgr. getData] {0} {1}", name, indexname[j]);
                    continue;
                }
                Row.Add(indexname[j], charArray[j]);
            }
            if (Table.ContainsKey(charArray[0]))
            {
                //DebugHelper.LogWarning("[ConfigMgr. getData] {0} {1} {2}" , name , i, lineArray[i-1]);
                continue;
            }
            Table.Add(charArray[0], Row);
        }
        if (ConfigLongthDictionary != null && !ConfigLongthDictionary.ContainsKey(name))
        {
            //int length = lineArray.Length - (linestart + 1);
            int length = lineArray.Length - (linestart);
            ConfigLongthDictionary.Add(name, length);
        }
        return Table;
    }

    public Dictionary<string, Dictionary<string, string>> getTable(string tablename)
    {
        if (!InitFinished || ConfigDictionary == null)
            return null;
        Dictionary<string, Dictionary<string, string>> ts;
        ConfigDictionary.TryGetValue(tablename, out ts);
        if (ts != null && ts.Count > 0)
            return ts;
        else
        {
            DebugHelper.LogWarning("[ConfigMgr] {0} cant find", tablename);
            return null;
        }
    }

    public string GetXmlCfg(string fileName)
    {
        string cfg;
        mXmlConfigDict.TryGetValue(fileName, out cfg);
        return cfg;
    }

    public int getTableLength(string tablename)
    {
        if (!InitFinished)
            return -1;

        if (ConfigLongthDictionary.ContainsKey(tablename))
            return ConfigLongthDictionary[tablename];
        return 0;
    }

    public Dictionary<string, string> getLine(int id, string tablename)
    {
        return getLine(id.ToString(), tablename);
    }

    public Dictionary<string, string> getLine(string id, string tablename)
    {
        if (!InitFinished) {
            Debug.LogError("配置未加载!!!");
            return null;
        }
        Dictionary<string, Dictionary<string, string>> ts = getTable(tablename);

        if (ts != null && ts.ContainsKey(id))
        {
            return ts[id];
        }
        else
            return null;
    }

    public string getValue(int id, string keyname, string tablename)
    {
        return getValue(id.ToString(), keyname, tablename);
    }

    public string getValue(string id, string keyname, string tablename)
    {
        if (!InitFinished)
            return null;
        Dictionary<string, Dictionary<string, string>> ts = getTable(tablename);
        //Log.E("id {0}  {1} {2}",id,keyname,tablename);
        if (ts != null && ts.ContainsKey(id) && ts[id].ContainsKey(keyname))
        {
            return ts[id][keyname];
        }
        else
            return null;
    }
}

public class I18N
{
    static string m_tableName = "";
    static string tableName
    {
        get
        {
            if (string.IsNullOrEmpty(m_tableName))
                m_tableName = string.Format("LanguagePackage{0}", ConfigMgr.CurLangKey);
            return m_tableName;
        }
    }

    public static string T(string key)
    {
        string result = key;
        if (key == null)
        {
            DebugHelper.LogWarning("[ I18N.T ] keyword is null!!!");
            return "";
        }

        if (ConfigMgr.HasInstance())
        {
            if (!ConfigMgr.InitFinished)
            {
                ConfigMgr.Instance.ResetKeywords();
                m_tableName = string.Empty;
            }
            string value = ConfigMgr.Instance.getValue(key, "Language", tableName);

            if (value != null)
            {
                result = value.Replace("\\n", "\n");
            }
        }
        return result;
    }

    public static string SetLanguageValue(string key, params string[] param)
    {
        if (param == null || param.Length == 0)
        {
            return T(key);
        }

        string result = key;
        if (key == null)
        {
            DebugHelper.LogWarning("[ I18N.T ] keyword is null!!!");
            return "";
        }

        if (ConfigMgr.HasInstance())
        {
            if (!ConfigMgr.InitFinished)
            {
                ConfigMgr.Instance.ResetKeywords();
                m_tableName = string.Empty;
            }
            string value = ConfigMgr.Instance.getValue(key, "Language", tableName);

            if (value != null)
            {
                result = value.Replace("\\n", "\n");
                result = string.Format(result, param);
            }
            else
            {
                DebugHelper.LogWarning("[ I18N.T ]ConfigMgr.cant find the key or keyword is null!!!  " + key);
            }
        }
        return result;
    }
}

public class I18NOpera
{
    static string m_tableName = "";
    static string tableName
    {
        get
        {
            if (string.IsNullOrEmpty(m_tableName))
                m_tableName = string.Format("OperaKeywords{0}", ConfigMgr.CurLangKey);
            return m_tableName;
        }
    }

    public static string T(int key)
    {
        string result = key.ToString();

        if (ConfigMgr.HasInstance())
        {
            if (!ConfigMgr.InitFinished)
            {
                ConfigMgr.Instance.ResetKeywords();
                m_tableName = string.Empty;
            }
            result = ConfigMgr.Instance.getValue(key, "info", tableName);
            result = result.Replace("\\n", "\n");//��������
                                                 //if (value != null)
                                                 //{
                                                 //    result = value.Replace("|", "\r\n");
                                                 //}
                                                 //else
                                                 //{
                                                 //    DebugHelper.LogWarning("[ I18NOpera.T ]ConfigMgr.cant find the key or keyword is null!!!");
                                                 //}
        }
        return result;
    }
}

public class I18NOperaBranch
{
    static string m_tableName = "";
    static string tableName
    {
        get
        {
            if (string.IsNullOrEmpty(m_tableName))
                m_tableName = string.Format("OperaBranchwords{0}", ConfigMgr.CurLangKey);
            return m_tableName;
        }
    }

    public static string T(int key)
    {
        string result = key.ToString();

        if (ConfigMgr.HasInstance())
        {
            if (!ConfigMgr.InitFinished)
            {
                ConfigMgr.Instance.ResetKeywords();
                m_tableName = string.Empty;
            }
            result = ConfigMgr.Instance.getValue(key, "info", tableName);
            if (result == null)
            {
                DebugHelper.LogError(string.Format("in {0},can not find value by key :{1}", tableName, key));
            }
            result = result.Replace("\\n", "\n");//��������
        }
        return result;
    }
}

public class EditorConfigCSV
{
    private string m_tableName = "";
    public string TableName
    {
        get
        {
            return m_tableName;
        }
    }

    private int linestart = 1;
    private int rowstart = 1;
    private string splitword = ",";

    private Dictionary<string, Dictionary<string, string>> m_tableData;
    public string T(string key, string filed, string tableName_)
    {
        m_tableName = tableName_;
        string result = key;
#if UNITY_EDITOR
        string value = GetValue(key, filed);
        if (value != null)
        {
            result = value.Replace("\\n", "\n");
        }
#endif //UNITY_EDITOR
        return result;
    }

    public string GetValue(string id, string keyName_, string tableName_ = null)
    {
#if UNITY_EDITOR
        if (m_tableData == null)
        {
            if (tableName_ != null)
                m_tableName = tableName_;

            string path = string.Format("{0}/{1}.csv", Constants.CsvConfig, TableName);
            TextAsset tx = UnityEditor.AssetDatabase.LoadAssetAtPath<TextAsset>(path) as TextAsset;
            m_tableData = GetData(tx);
        }
        if (id == null)
        {
            return null;
        }
        if (m_tableData.ContainsKey(id) && m_tableData[id].ContainsKey(keyName_))
        {
            return m_tableData[id][keyName_];
        }
#endif //UNITY_EDITOR
        return null;
    }

    public List<string> GetId2Key(string keyName_, string keyValue_, string tableName_ = null)
    {
        List<string> idList = new List<string>();
#if UNITY_EDITOR
        if (m_tableData == null)
        {
            if (tableName_ != null)
                m_tableName = tableName_;

            string path = string.Format("{0}/{1}.csv", Constants.CsvConfig, TableName);
            TextAsset tx = UnityEditor.AssetDatabase.LoadAssetAtPath<TextAsset>(path) as TextAsset;
            m_tableData = GetData(tx);
        }

        foreach (var dic in m_tableData)
        {
            if (dic.Value[keyName_] == keyValue_)
            {
                idList.Add(dic.Key);
            }
        }

#endif //UNITY_EDITOR
        return idList;
    }
    private Dictionary<string, Dictionary<string, string>> GetData(Object obj)
    {
        if (obj == null)
            return null;
        string[] lineArray;
        string[] charArray;

        TextAsset binAsset = obj as TextAsset;
        string text = binAsset.text.Replace("\r\n", "@");
        lineArray = text.Split("@"[0]);
        //DebugHelper.LogWarning("[TableName: {0}]lineArray {1}",binAsset.name, lineArray[0]);
        string[] indexname = lineArray[1].Split(splitword[0]);
        Dictionary<string, Dictionary<string, string>> Table = new Dictionary<string, Dictionary<string, string>>();

        for (int i = linestart; i < lineArray.Length; ++i)
        {
            charArray = lineArray[i].Split(splitword[0]);
            if (charArray.Length > 0 && charArray[0] == string.Empty)
            {
                DebugHelper.LogWarning("[ConfigMgr. GetData] Empty Index {0} {1}", binAsset.name, i);
                continue;
            }

            Dictionary<string, string> Row = new Dictionary<string, string>();
            for (int j = rowstart; j < charArray.Length; ++j)
            {
                if (indexname[j] == "" || indexname[j] == string.Empty)
                {
                    DebugHelper.LogWarning("[ConfigMgr. GetData] Empty key {0} {1}", binAsset.name, j);
                    continue;
                }
                if (Row.ContainsKey(indexname[j]))
                {
                    DebugHelper.LogWarning("[ConfigMgr. GetData] {0} {1}", binAsset.name, indexname[j]);
                    continue;
                }
                Row.Add(indexname[j], charArray[j]);
            }
            if (Table.ContainsKey(charArray[0]))
            {
                DebugHelper.LogWarning("[ConfigMgr. GetData] {0} {1} {2}", binAsset.name, i, lineArray[i - 1]);
                continue;
            }
            Table.Add(charArray[0], Row);
        }
        return Table;
    }
}