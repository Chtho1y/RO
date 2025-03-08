using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

public enum ActiveType
{
    Default,
    Active,
    Inactive,
}
public class UINode : MonoBehaviour
{
    public string UIName;

    [HideInInspector]
    //[SerializeField]
    public List<string> keys;
    [HideInInspector]
    //[SerializeField]
    public List<bool> values;

    public UINode[] depObjs;

    public ActiveType activeType = ActiveType.Default;

    public bool GetValue(string key, out bool value)
    {
        value = false;
        for (int i = 0; i < keys.Count; i++)
        {
            if (keys[i] == key)
            {
                value = values[i];
                return true;
            }
        }

        return false;
    }

    public void SetValue(string key, bool value)
    {
        for (int i = 0; i < keys.Count; i++)
        {
            if (keys[i] == key)
            {
                values[i] = value;
                return;
            }
        }
        keys.Add(key);
        values.Add(value);
    }

    public void RemoveKeyValue(string key, bool value)
    {
        int removeindex = -1;
        for (int i = 0; i < keys.Count; ++i)
        {
            if (keys[i] == key)
            {
                removeindex = i;
                break;
            }
        }
        if (removeindex != -1)
        {
            keys.RemoveAt(removeindex);
            values.RemoveAt(removeindex);
        }
    }

    public bool HasType(Type type)
    {
        for (int i = 0; i < keys.Count; i++)
        {
            if (keys[i] == type.FullName)
            {
                return values[i];
            }
        }

        return false;
    }

    string trimName(string name)
    {
        string trim = name.Replace(" ", "");
        trim = trim.Replace("\r", "");
        trim = trim.Replace("\n", "");
        trim = trim.Replace("\t", "");
        return trim;
    }

    string getComponentArgNameWithName(string str)
    {
        return str.Substring(0, 1).ToLower() + str.Substring(1, str.Length - 1);
    }

    void PackageUINodeGOPath(ref string path)
    {
        if (UIName == string.Empty)
        {
            UIName = getComponentArgNameWithName(trimName(gameObject.name));
        }
        path = "." + path;
        path = UIName + path;
        if (depObjs.Length > 0)
        {
            UINode node1 = depObjs[0];
            if (node1 != null)
                node1.PackageUINodeGOPath(ref path);
            else
                path = path.Substring(0, path.Length - 1);
        }
        else
        {
            path = path.Substring(0, path.Length - 1);
        }
    }

    public void FindUINodeGOPath(ref string path)
    {
        PackageUINodeGOPath(ref path);
    }
}
