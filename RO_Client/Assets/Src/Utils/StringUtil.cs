using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System.Text.RegularExpressions;

public class StringUtil
{
    public static bool isIpString(string str)
    {
        string[] tempList = str.Split('.');
        if (tempList == null || tempList.Length != 4) return false;

        for (int idx = 0; idx < tempList.Length; idx++)
        {
            string temp = tempList[idx];
            int iVal = 0;
            if (!int.TryParse(temp,out iVal))
                return false;
        }
        return true;

    }

    public static string[] split(string str,char sperator)
    {
        if (str == null || str.Length == 0)
            return null;

        return str.Split(sperator);
    }

    public static int[] split2Int(string str,char sperator)
    {
        string[] strList = split(str, sperator);
        if (strList == null || strList.Length == 0)
            return null;

        int[] intList = new int[strList.Length];
        for(int idx =0;idx < strList.Length;idx++)
        {
            string temp = strList[idx];
            int iVal;
            if(int.TryParse(temp, out iVal))
            {
                intList[idx] = iVal;
            }else
            {
                float fVal;
                if(float.TryParse(temp, out  fVal))
                {
                    intList[idx] = (int)fVal;
                }
                else
                {
                    intList[idx] = 0;
                }
            }
        }
        return intList;
    }

    public static float[] split2Float(string str, char sperator)
    {
        string[] strList = split(str, sperator);
        if (strList == null || strList.Length == 0)
            return null;

        float[] floatList = new float[strList.Length];
        for (int idx = 0; idx < strList.Length; idx++)
        {
            string temp = strList[idx];
            float fVal;
            if (float.TryParse(temp, out fVal))
            {
                floatList[idx] = fVal;
            }
            else
            {
                floatList[idx] = 0;
            }
        }
        return floatList;
    }

    public static List<int> convert2IntList(string str, char seperator)
    {
        string[] strList = split(str, seperator);
        if (strList == null || strList.Length == 0)
            return null;

        List<int> intList = new List<int>(strList.Length);
        for (int idx = 0; idx < strList.Length; idx++)
        {
            string temp = strList[idx];
            int fVal;
            if (int.TryParse(temp, out fVal))
            {
                intList.Add(fVal);
            }
            else
            {
                intList.Add(0);
            }
        }
        return intList;
    }

    public static Vector3 convertVector3(string str)
    {
        if (string.IsNullOrEmpty(str))
            return Vector3.zero;

        string[] strList = split(str, ';');
        if (strList == null || strList.Length !=3)
            return Vector3.zero;

        float x, y, z;
        float.TryParse(strList[0],out x);
        float.TryParse(strList[1],out y);
        float.TryParse(strList[2],out z);

        return new Vector3(x,y,z);
    }

    public static Vector2 convertVector2(string str)
    {
        if (string.IsNullOrEmpty(str))
            return Vector2.zero;

        string[] strList = split(str, ';');
        if (strList == null || strList.Length != 2)
            return Vector2.zero;

        float x, y;
        float.TryParse(strList[0], out x);
        float.TryParse(strList[1], out y);

        return new Vector2(x,y);
    }

    public static string ConvertVector2Str(Vector3 v)
    {
        return v.x + ";" + v.y + ";" + v.z;
    }

    /// <summary>
    /// 获取obj中的vector3数据
    /// </summary>
    /// <param name="jsonObj"></param>
    /// <param name="name"></param>
    /// <returns></returns>
    public static Vector3 GetVector3Field(Dictionary<object, object> jsonObj,string name)
    {
        if(jsonObj.ContainsKey(name))
        {
            List<object> objList = (List<object>)jsonObj[name];
            if (objList == null || objList.Count < 3)
                return Vector3.zero;

            float x, y, z;
            float.TryParse(objList[0].ToString(),out x);
            float.TryParse(objList[1].ToString(),out y);
            float.TryParse(objList[2].ToString(), out z);
            return new Vector3(x,y,z);
        }
        return Vector3.zero;
    }

    public static Vector2 GetVector2Field(Dictionary<object, object> jsonObj, string name)
    {
        if (jsonObj.ContainsKey(name))
        {
            List<object> objList = (List<object>)jsonObj[name];
            if (objList == null || objList.Count < 2)
                return Vector2.zero;

            float x, y;
            float.TryParse(objList[0].ToString(), out x);
            float.TryParse(objList[1].ToString(), out y);
            return new Vector2(x,y);
        }
        return Vector2.zero;
    }

    public static string PrintLong(ulong uid)
    {
        return uid.ToString();
    }

    /// <summary>
    /// 获取字符串在text中的长度
    /// </summary>
    /// <param name="text"></param>
    /// <param name="str"></param>
    /// <returns></returns>
    public static int GetTextLeng(Text text, string str = null)
    {
        Font mFont = text.font;
        string mStr = string.IsNullOrEmpty(str) ? text.text : str;
        mFont.RequestCharactersInTexture(mStr, text.fontSize, text.fontStyle);
        char[] charArr = mStr.ToCharArray();
        int totalTextLeng = 0;
        CharacterInfo character = new CharacterInfo();
        for (int i = 0; i < charArr.Length; i++)
        {
            mFont.GetCharacterInfo(charArr[i], out character, text.fontSize);
            totalTextLeng += character.advance;
        }
        return totalTextLeng;
    }

    public static string TrimEdgeSpace(string str)
    {
        return str.TrimStart(' ').TrimEnd(' ');
    }

    public static string Trim(string str)
    {
        return str.Trim();
    }

    /// <summary>
    /// 截取字符串，这里有一个约定，_count这个数量，一个中文字算2，其他的字符算1，这是迎合策划的要求产生的
    /// 这个函数只能截取0-_count,比如："aaa哈哈"，如果_count == 4，截取的结果是"aaa哈",但是_count == 5也同样是这个结果
    /// </summary>
    /// <param name="_str"></param>
    /// <param name="_count"></param>
    /// <returns></returns>
    public static string CutOutString(string _str, int _count)
    {
        int _totalCount = GetStringByteLength(_str);
        if (_totalCount <= _count)
        {
            return _str;
        }
        else
        {
            string _newStr = "";
            string _newStrL = "";
            var _charArr = _str.ToCharArray();
            int _index = 0;
            while (GetStringByteLength(_newStrL) < _count || _index > _charArr.Length)
            {
                _newStrL += _charArr[_index].ToString();
                _newStr = _newStrL;
                _index++;
            }
            return _newStr;
        }
    }

    /// <summary>
    /// 获取一个字符串的字节数
    /// </summary>
    /// <param name="_str"></param>
    /// <returns></returns>
    public static int GetStringByteLength(string _str)
    {
        if (string.IsNullOrEmpty(_str))
            return 0;
        else
        {
            var _chrArray = _str.ToCharArray();
            int _cnCount = 0;
            foreach (var _item in _chrArray)
            {
                bool _isCn = JudgeCharType(_item) == 1;
                _cnCount += _isCn ? 1 : 0;
            }
            return _cnCount * 2 + (_chrArray.Length - _cnCount);
        }
    }

    /*****判断字符传是否是由中文英文和数组组成的start*****/
    /// <summary>
    /// 判断字符的语言是什么类型
    /// 0 --当前没有判断的类型
    /// 1 --中文
    /// 2 --英文
    /// 3 --数字
    /// </summary>
    /// <param name="_chr"></param>
    /// <returns></returns>
    public static int JudgeCharType(char _chr)
    {
        string _str = _chr.ToString();
        int _match = 0;
        if (Regex.IsMatch(_str, "[\u4e00-\u9fa5]"))
            _match = 1;
        else if (Regex.IsMatch(_str, "[a-zA-Z]"))
            _match = 2;
        else if (Regex.IsMatch(_str, "[0-9]"))
            _match = 3;
        return _match;
    }

    /// <summary>
    /// 判断字符串是否是由中文英文和数字组成的
    /// </summary>
    /// <param name="_str"></param>
    /// <returns></returns>
    public static bool JudgeString_CN_EN_NUM(string _str)
    {
        if (string.IsNullOrEmpty(_str))
        {
            Debug.LogErrorFormat("null or empty string:{0}", _str);
            return false;
        }
        bool _isTarget = true;
        var _chrArray = _str.ToCharArray();
        foreach (var _item in _chrArray)
        {
            _isTarget = JudgeCharType(_item) != 0;
            if (_isTarget == false)
                break;
        }
        return _isTarget;
    }
    /*****判断字符传是否是由中文英文和数组组成的end*****/


    public static string FilterEmoji(string str)
    {
        str = Regex.Replace(str, @"\p{Cs}", "");
        str = Regex.Replace(str, @"\p{Co}", "");
        str = Regex.Replace(str, @"\p{Cn}", "");
        str = Regex.Replace(str, @"[\u2702-\u27B0]", "");
        return str;
    }
}
