using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class MarkData
{
    public int markId;
    public string markIcon;
    public int maxLayer;
    public float duration;
    public bool isOverlay;
    public int effectId;
    public List<FValType> funList;
    public List<FValType> funIncList;
    public int ShowTypes;

    public enum EnShowType
    {
        En_ShowAll = 0,
        En_ShowInDesc = 1,
        En_ShowBattle = 2,
        en_UnShowAll = 3,
    }

    public bool IsShow(EnShowType enType)
    {
        switch((EnShowType)ShowTypes)
        {
            case EnShowType.En_ShowAll:
                return true;
            case EnShowType.en_UnShowAll:
                return false;
            case EnShowType.En_ShowBattle:
            case EnShowType.En_ShowInDesc:
                return (int)enType != ShowTypes;
        }
        return true;
    }

    private bool bValid = false;
    public bool Valid
    {
        get { return bValid; }
    }

    public MarkData(int id)
    {
        Dictionary<string, string> dic = ConfigMgr.Instance.getLine(id, Config.MarkCfgName);
        if(dic == null)
        {
            DebugHelper.LogError(string.Format("印记 {0} 没有配置", id));
            return;
        }

        this.markId = id;
        if(dic.ContainsKey("Icon"))
        {
            this.markIcon = dic["Icon"];
        }

        if(dic.ContainsKey("MaxLayer"))
        {
            int.TryParse(dic["MaxLayer"], out maxLayer);
        }

        if(dic.ContainsKey("Duration"))
        {
            float.TryParse(dic["Duration"], out duration);
        }

        if(dic.ContainsKey("Overlay"))
        {
            int temp = 0;
            int.TryParse(dic["Overlay"], out temp);
            isOverlay = temp > 0;
        }

        if(dic.ContainsKey("EffectId"))
        {
            int.TryParse(dic["EffectId"], out effectId);
        }

        if(dic.ContainsKey("FunList"))
        {
            string tempStr = dic["FunList"];
            if (!string.IsNullOrEmpty(tempStr))
            {
                string[] tempStrList = tempStr.Split(';');
                funList = new List<FValType>();
                for (int idx =0; idx < tempStrList.Length;idx++)
                {
                    string[] tempStr2 = tempStrList[idx].Split(':');
                    if(tempStr2.Length >= 2)
                    {
                        int funType = 0;
                        float funVal = 0;
                        int.TryParse(tempStr2[0], out funType);
                        float.TryParse(tempStr2[1], out funVal);
                        funList.Add(new FValType(funType, funVal));
                    }
                }
            }
        }

        if(dic.ContainsKey("FunIncList"))
        {
            string tempStr = dic["FunIncList"];
            if (!string.IsNullOrEmpty(tempStr))
            {
                string[] tempStrList = tempStr.Split(';');
                funIncList = new List<FValType>();
                for (int idx = 0; idx < tempStrList.Length; idx++)
                {
                    string[] tempStr2 = tempStrList[idx].Split(':');
                    if (tempStr2.Length >= 2)
                    {
                        int funType = 0;
                        float funVal = 0;
                        int.TryParse(tempStr2[0], out funType);
                        float.TryParse(tempStr2[1], out funVal);
                        funIncList.Add(new FValType(funType, funVal));
                    }
                }
            }
        }

        if (dic.ContainsKey("ShowTypes"))
        {
            int.TryParse(dic["ShowTypes"], out ShowTypes);
        }

        bValid = true;
    }
}
