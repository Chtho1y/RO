using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;

public enum OutputType
{
    BeginFighting = 1,      //开始战斗
    EndFighting = 2,        //结束战斗
    Dead = 3,               //角色死亡
    Damage = 4,             //技能伤害
    Heal = 5,               //治疗
    Shield = 6,             //护盾
    Disperse = 7,           //驱散
    Clean = 8,              //净化
    Break = 9,              //打断
    Vertigo = 10,           //眩晕
}

public struct OutputInfo
{
    public OutputType type;
    public string timeStr;
    public string casterName;
    public string targetName;
    public string skillName;
    public object val;

    public OutputInfo(OutputType type)
    {
        this.type = type;
        timeStr = DateTime.Now.ToLongTimeString();
        casterName = null;
        targetName = null;
        skillName = null;
        val = null;
    }
}

/// <summary>
/// 超链接信息类
/// </summary>
public class HrefInfo
{
    public string color;
    public string text;
    public HrefInfo(string clr,string content)
    {
        color = clr;
        text = content;
    }
}

public class BattleOutput
{
    const int MaxNum = 200;
    private List<string> mOutputList = new List<string>();
    public List<string> OutputList
    {
        get { return mOutputList; }
    }


    public void Begin()
    {
        ConvertLogToStr(OutputType.BeginFighting);
    }

    public void End()
    {
        ConvertLogToStr(OutputType.EndFighting);
    }

    public void Output(OutputType type, Fighter caster, Fighter target = null, string skillName = null, object val = null)
    {
        ConvertLogToStr(type, caster, target, skillName, val);
    }

    private void ConvertLogToStr(OutputType type, Fighter caster = null, Fighter target = null, string skillName = null, object val = null)
    {
        string timeStr = DateTime.Now.ToLongTimeString();
        string str = "";
        string casterName = caster != null ? caster.Name : "";
        string targetName = target != null ? target.Name : "";
        string sName = skillName != null ? I18N.SetLanguageValue("BattleOutput_SkillName", skillName) : "";
        string valStr = val != null ? val.ToString() : "";
        bool team = caster != null ? caster.TeamSide == 0 : false;
        switch (type)
        {
            case OutputType.BeginFighting:
                str = I18N.SetLanguageValue("BattleOutput_001", timeStr);
                break;
            case OutputType.EndFighting:
                str = I18N.SetLanguageValue("BattleOutput_002", timeStr);
                break;
            case OutputType.Dead:
                if(team)
                    str = I18N.SetLanguageValue("BattleOutput_003", timeStr, casterName, sName, targetName, valStr);
                else
                    str = I18N.SetLanguageValue("BattleOutput_011", timeStr, casterName, sName, targetName, valStr);
                break;
            case OutputType.Damage:
                if(team)
                    str = I18N.SetLanguageValue("BattleOutput_004", timeStr, casterName, sName, targetName, valStr);
                else
                    str = I18N.SetLanguageValue("BattleOutput_012", timeStr, casterName, sName, targetName, valStr);
                break;
            case OutputType.Heal:
                if(team)
                    str = I18N.SetLanguageValue("BattleOutput_005", timeStr, casterName, sName, targetName, valStr);
                else
                    str = I18N.SetLanguageValue("BattleOutput_013", timeStr, casterName, sName, targetName, valStr);
                break;
            case OutputType.Shield:
                if(team)
                    str = I18N.SetLanguageValue("BattleOutput_006", timeStr, casterName, sName, targetName, valStr);
                else
                    str = I18N.SetLanguageValue("BattleOutput_014", timeStr, casterName, sName, targetName, valStr);
                break;
            case OutputType.Disperse:
                if(team)
                    str = I18N.SetLanguageValue("BattleOutput_007", timeStr, casterName, sName, targetName, valStr);
                else
                    str = I18N.SetLanguageValue("BattleOutput_015", timeStr, casterName, sName, targetName, valStr);
                break;
            case OutputType.Clean:
                if(team)
                    str = I18N.SetLanguageValue("BattleOutput_008", timeStr, casterName, sName, targetName, valStr);
                else
                    str = I18N.SetLanguageValue("BattleOutput_016", timeStr, casterName, sName, targetName, valStr);
                break;
            case OutputType.Break:
                if(team)
                    str = I18N.SetLanguageValue("BattleOutput_009", timeStr, casterName, sName, targetName, valStr);
                else
                    str = I18N.SetLanguageValue("BattleOutput_017", timeStr, casterName, sName, targetName, valStr);
                break;
            case OutputType.Vertigo:
                if(team)
                    str = I18N.SetLanguageValue("BattleOutput_010", timeStr, casterName, sName, targetName, valStr);
                else
                    str = I18N.SetLanguageValue("BattleOutput_018", timeStr, casterName, sName, targetName, valStr);
                break;
        }


        GetOutputText(str);
        string tempStr = "";
        int lastCnt = 0;
        int deltaCnt = 0;
        int cursor = 0;
        for(int idx = 0; idx < mTextInfos.Count;idx++)
        {
            tempStr += mTextInfos[idx].text;
            int cnt = StringUtil.GetStringByteLength(tempStr);
            if(cnt >= 50)
            {
                cursor = idx;
                deltaCnt = 50 - lastCnt;
                break;
            }else
            {
                lastCnt = cnt;
            }
        }
        if(deltaCnt > 0)
        {
            var info = mTextInfos[cursor];
            string temp = StringUtil.CutOutString(info.text, deltaCnt);
            string temp2 = info.text.Replace(temp, "");
            mTextInfos.Insert(cursor,new HrefInfo(info.color, temp));
            cursor++;
            info.text = temp2;
        }

        string str1 = "";
        string str2 = "";
        for(int idx =0; idx < cursor;idx++)
        {
            var info = mTextInfos[idx];
            if (!string.IsNullOrEmpty(info.text))
            {
                if (string.IsNullOrEmpty(info.color))
                {
                    str1 += info.text;
                }
                else
                {
                    str1 = str1 + string.Format("<color=#{0}>{1}</color>", info.color, info.text);
                }
            }
        }

        for(int idx = cursor; idx < mTextInfos.Count;idx++)
        {
            var info = mTextInfos[idx];
            if(!string.IsNullOrEmpty(info.text))
            {
                if (string.IsNullOrEmpty(info.color))
                {
                    str2 += info.text;
                }
                else
                {
                    str2 = str2 + string.Format("<color=#{0}>{1}</color>", info.color, info.text);
                }
            }
        }

        if (!string.IsNullOrEmpty(str1))
        {
            if (mOutputList.Count >= MaxNum)
            {
                mOutputList.RemoveAt(0);
            }
            mOutputList.Add(str1);
        }

        if (!string.IsNullOrEmpty(str2))
        {
            if (mOutputList.Count >= MaxNum)
            {
                mOutputList.RemoveAt(0);
            }
            mOutputList.Add(str2);
        }
        NotifyOutput();
    }

    List<HrefInfo> mTextInfos = new List<HrefInfo>();
    Regex s_HrefRegex = new Regex(@"<color=#(.+?)>(.*?)(</color>)", RegexOptions.Singleline);

    protected void GetOutputText(string text)
    {
        mTextInfos.Clear();
        var indexText = 0;
        foreach (Match match in s_HrefRegex.Matches(text))
        {
            var hrefInfo = new HrefInfo(null, text.Substring(indexText, match.Index - indexText));
            mTextInfos.Add(hrefInfo);

            var hrefInfo2 = new HrefInfo(match.Groups[1].Value, match.Groups[2].Value);
            mTextInfos.Add(hrefInfo2);

            indexText = match.Index + match.Length;
        }

        string lastText = text.Substring(indexText, text.Length - indexText);
        if (!string.IsNullOrEmpty(lastText))
        {
            var lastInfo = new HrefInfo(null, lastText);
            mTextInfos.Add(lastInfo);
        }
    }

    private void NotifyOutput()
    {
        BattleMgr.Instance.OnRefreshBattleOutput();
    }

    public void Clean()
    {
        mOutputList.Clear();
    }


    public void Dispose()
    {
        Clean();
    }
}
