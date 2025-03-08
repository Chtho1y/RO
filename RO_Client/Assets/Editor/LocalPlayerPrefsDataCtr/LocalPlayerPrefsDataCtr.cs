using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System;
using LuaInterface;
using System.IO;

public class LocalPlayerPrefsDataCtr : EditorWindow
{
    private static void OnQuit(PlayModeStateChange state)
    {
        if (state == PlayModeStateChange.EnteredEditMode)
        {
            for (int i = 0; i < clearList.Count; i++)
            {
                PlayerPrefs.DeleteKey(clearList[i]);
            }
        }
    }


    string[] keyTypes = new string[] { "Cache_Skill_Key", "PrivateChatInfos" };
    string[] keyTypeDes = new string[] { "技能红点数据", "私聊信息数据" };
    static int index = 0;
    static PlayerPrefPair[] pairs;
    static long uid = 0;
    static LocalPlayerPrefsDataCtr window;
    [MenuItem("Tools/LocalPlayerPrefsDataCtr")]
    static void Init()
    {
        uidKeys = new Dictionary<string, List<string>>();
        uidKeyList = new List<string>();
        otherKeyList = new List<string>();
        clearList = new List<string>();
        index = 0;
        uid = 0;
        pairs = GetAll();
        DisposalData();
        GetUserUidByLua();
        window = (LocalPlayerPrefsDataCtr)GetWindow(typeof(LocalPlayerPrefsDataCtr));
        EditorApplication.playModeStateChanged += OnQuit;
        window.Show();
    }
    static Dictionary<string, List<string>> uidKeys = new Dictionary<string, List<string>>();
    static List<string> uidKeyList = new List<string>();
    static List<string> otherKeyList = new List<string>();
    static List<string> clearList = new List<string>();
    private static void DisposalData()
    {
        foreach (var item in pairs)
        {
            int index = FindCharIndex(item.Key);
            if (index == 1)
            {
                //无效key  uid为0
                string uid = item.Key.Substring(0, 1);
                string value = item.Key.Substring(1);
                if (uidKeys.ContainsKey(uid))
                {
                    uidKeys[uid].Add(value);
                }
                else
                {
                    uidKeyList.Add(uid);
                    uidKeys[uid] = new List<string>();
                    uidKeys[uid].Add(value);
                }
            }
            else if (index == 19)
            {
                string uid = item.Key.Substring(0, 19);
                string value = item.Key.Substring(19);
                if (uidKeys.ContainsKey(uid))
                {
                    uidKeys[uid].Add(value);
                }
                else
                {
                    uidKeyList.Add(uid);
                    uidKeys[uid] = new List<string>();
                    uidKeys[uid].Add(value);
                }
            }
            else
            {
                otherKeyList.Add(item.Key);
            }
        }
    }


    private static int FindCharIndex(string key)
    {
        for (int i = 0; i < key.Length; i++)
        {
            if (!(key[i] >= (char)48 && key[i] <= (char)58))
            {
                return i;
            }
        }
        return 0;
    }
    bool isShowUid = false;
    bool isShowOhter = false;
    bool isShowcurrUid = false;
    bool isShowKeyDes = false;
    Vector2 pos;
    static void GetUserUidByLua()
    {
        if (Application.isPlaying &&LuaMgr.Instance != null && LuaMgr.GetMainState() != null)
        {
            try
            {
                LuaTable table = LuaMgr.GetMainState().GetTable("ManagerContainer.DataMgr.UserData");
                if (table == null) return;
                LuaFunction func = table.GetLuaFunction("GetUserId");
                func.BeginPCall();
                func.Push(table);
                func.PCall();
                uid = func.CheckLong();
                func.EndPCall();
            }
            catch (LuaException e)
            {
                Debug.LogError("LuaBuffer.ManagerContainer.DataMgr.UserData  " + e.Message);
                return;
            }
        }
    }
    private void OnGUI()
    {
        pos = EditorGUILayout.BeginScrollView(pos);
        EditorGUILayout.LabelField("-------------对应key的描述（持续添加）-------------");
        isShowKeyDes = EditorGUILayout.Foldout(isShowKeyDes, "显示隐藏对应key描述");
        if (isShowKeyDes)
        {
            for (int i = 0; i < keyTypes.Length; i++)
            {
                EditorGUILayout.BeginHorizontal();
                EditorGUILayout.LabelField(keyTypes[i]);
                EditorGUILayout.LabelField(keyTypeDes[i]);
                EditorGUILayout.EndHorizontal();
            }
        }
        if (uid != 0)
        {
            EditorGUILayout.LabelField("-------------当前玩家UID所有key数据-------------");
            isShowcurrUid = EditorGUILayout.Foldout(isShowcurrUid, "显示隐藏当前玩家UID所有key数据");
            if (isShowcurrUid)
            {
                if (uidKeys.ContainsKey(uid.ToString()))
                {
                    for (int i = 0; i < uidKeys[uid.ToString()].Count; i++)
                    {
                        EditorGUILayout.BeginHorizontal();
                        EditorGUILayout.LabelField(uid.ToString() + uidKeys[uid.ToString()][i]);
                        if (GUILayout.Button("打印", GUILayout.Width(50), GUILayout.Height(20)))
                        {
                            string data = PlayerPrefs.GetString(uid.ToString() + uidKeys[uid.ToString()][i]);
                            if (data != null)
                            {
                                Debug.Log(data);
                            }
                        }
                        if (GUILayout.Button("清除", GUILayout.Width(50), GUILayout.Height(20)))
                        {
                            if (!clearList.Contains(uid.ToString() + uidKeys[uid.ToString()][i]))
                            {
                                clearList.Add(uid.ToString() + uidKeys[uid.ToString()][i]);
                            }
                        }
                        EditorGUILayout.EndHorizontal();
                    }
                }
            }
        }

        EditorGUILayout.LabelField("-------------UID类型key数据-------------");
        isShowUid = EditorGUILayout.Foldout(isShowUid, "显示隐藏UID类型key数据");
        if (isShowUid)
        {
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("请选择UID");
            index = EditorGUILayout.Popup(index, uidKeyList.ToArray());
            EditorGUILayout.EndHorizontal();
            for (int i = 0; i < uidKeys[uidKeyList[index]].Count; i++)
            {
                EditorGUILayout.BeginHorizontal();
                EditorGUILayout.LabelField(uidKeyList[index] + uidKeys[uidKeyList[index]][i]);
                if (GUILayout.Button("打印", GUILayout.Width(50), GUILayout.Height(20)))
                {
                    string data = PlayerPrefs.GetString(uidKeyList[index] + uidKeys[uidKeyList[index]][i]);
                    if (data != null)
                    {
                        Debug.Log(data);
                    }
                }
                if (GUILayout.Button("清除", GUILayout.Width(50), GUILayout.Height(20)))
                {
                    PlayerPrefs.DeleteKey(uidKeyList[index] + uidKeys[uidKeyList[index]][i]);
                }
                EditorGUILayout.EndHorizontal();
            }
        }
        EditorGUILayout.LabelField("-------------其他类型key数据-------------");
        isShowOhter = EditorGUILayout.Foldout(isShowOhter, "显示隐藏其他类型key数据");
        if (isShowOhter)
        {
            for (int i = 0; i < otherKeyList.Count; i++)
            {
                EditorGUILayout.BeginHorizontal();
                EditorGUILayout.LabelField(otherKeyList[i]);
                if (GUILayout.Button("打印", GUILayout.Width(50), GUILayout.Height(20)))
                {
                    string data = PlayerPrefs.GetString(otherKeyList[i]);
                    if (data != null)
                    {
                        Debug.Log(data);
                    }
                }
                if (GUILayout.Button("清除", GUILayout.Width(50), GUILayout.Height(20)))
                {
                    PlayerPrefs.DeleteKey(otherKeyList[i]);
                }
                EditorGUILayout.EndHorizontal();
            }
        }
        EditorGUILayout.EndScrollView();
        Repaint();
    }
    private void OnDestroy()
    {
        EditorApplication.playModeStateChanged -= OnQuit;
    }
    [Serializable]
    public struct PlayerPrefPair
    {
        public string Key { get; set; }
        public object Value { get; set; }
    }
    public static PlayerPrefPair[] GetAll()
    {
        return GetAll(PlayerSettings.companyName, PlayerSettings.productName);
    }

    public static PlayerPrefPair[] GetAll(string companyName, string productName)
    {
        if (Application.platform == RuntimePlatform.WindowsEditor)
        {
            // From Unity docs: On Windows, PlayerPrefs are stored in the registry under HKCU\Software\[company name]\[product name] key, where company and product names are the names set up in Project Settings.
#if UNITY_5_5_OR_NEWER
            // From Unity 5.5 editor player prefs moved to a specific location
            Microsoft.Win32.RegistryKey registryKey =
                Microsoft.Win32.Registry.CurrentUser.OpenSubKey("Software\\Unity\\UnityEditor\\" + companyName + "\\" + productName);
#else
                Microsoft.Win32.RegistryKey registryKey = Microsoft.Win32.Registry.CurrentUser.OpenSubKey("Software\\" + companyName + "\\" + productName);
#endif

            // Parse the registry if the specified registryKey exists
            if (registryKey != null)
            {
                // Get an array of what keys (registry value names) are stored
                string[] valueNames = registryKey.GetValueNames();

                // Create the array of the right size to take the saved player prefs
                PlayerPrefPair[] tempPlayerPrefs = new PlayerPrefPair[valueNames.Length];

                // Parse and convert the registry saved player prefs into our array
                int i = 0;
                foreach (string valueName in valueNames)
                {
                    string key = valueName;
                    //移除注册表中的存储时间字符串后缀
                    // Remove the _h193410979 style suffix used on player pref keys in Windows registry
                    int index = key.LastIndexOf("_");
                    key = key.Remove(index, key.Length - index);

                    // Get the value from the registry
                    object ambiguousValue = registryKey.GetValue(valueName);

                    // Unfortunately floats will come back as an int (at least on 64 bit) because the float is stored as
                    // 64 bit but marked as 32 bit - which confuses the GetValue() method greatly! 
                    if (ambiguousValue.GetType() == typeof(int))
                    {
                        // If the player pref is not actually an int then it must be a float, this will evaluate to true
                        // (impossible for it to be 0 and -1 at the same time)
                        if (PlayerPrefs.GetInt(key, -1) == -1 && PlayerPrefs.GetInt(key, 0) == 0)
                        {
                            // Fetch the float value from PlayerPrefs in memory
                            ambiguousValue = PlayerPrefs.GetFloat(key);
                        }
                    }
                    else if (ambiguousValue.GetType() == typeof(byte[]))
                    {
                        // On Unity 5 a string may be stored as binary, so convert it back to a string
                        ambiguousValue = System.Text.Encoding.Default.GetString((byte[])ambiguousValue);
                    }

                    // Assign the key and value into the respective record in our output array
                    tempPlayerPrefs[i] = new PlayerPrefPair() { Key = key, Value = ambiguousValue };
                    i++;
                }

                // Return the results
                return tempPlayerPrefs;
            }
            else
            {
                // No existing player prefs saved (which is valid), so just return an empty array
                return new PlayerPrefPair[0];
            }
        }
        else
        {
            throw new NotSupportedException("PlayerPrefsEditor doesn't support this Unity Editor platform");
        }
    }
}
