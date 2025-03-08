using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public struct ValType
{
    public int id;
    public int val;
    public ValType(int id, int val)
    {
        this.id = id;
        this.val = val;
    }
}

public struct FValType
{
    public int id;
    public float val;
    public FValType(int id, float val)
    {
        this.id = id;
        this.val = val;
    }
}

public enum eNatureAntiType
{
    Damage = 1,     //伤害加成
    Crit = 2,       //暴击加成
    Hit = 3,        //命中加成
}

public enum EnNatureType
{
    en_None = 1,
    en_Water,   //水
    en_Land,    //地
    en_Fire,    //火
    en_Wind,    //风
    en_Holy,    //圣
    en_Dark,    //暗
    en_Pray,    //念
}

public enum EnAttr_NatureType
{
    Attr_Nature_None_Damage_Percent = 71,      //对无属性目标伤害加成/减免百分比
    Attr_Nature_Water_Damage_Percent = 72,     //对水属性目标的伤害加成/减免百分比
    Attr_Nature_Ground_Damage_Percent = 73,    //对地属性目标的伤害加成/减免百分比
    Attr_Nature_Fire_Damage_Percent = 74,      //对火属性目标的伤害加成/减免百分比
    Attr_Nature_Wind_Damage_Percent = 75,      //对风属性目标的伤害加成/减免百分比
    Attr_Nature_Saint_Damage_Percent = 76,     //对圣属性目标的伤害加成/减免百分比
    Attr_Nature_Dark_Damage_Percent = 77,      //对暗属性目标的伤害加成/减免百分比
    Attr_Nature_Read_Damage_Percent = 78,      //对念属性目标的伤害加成/减免百分比

    Attr_Nature_None_AntiDamage_Percent = 81,      //抗无属性伤害加成/减免百分比
    Attr_Nature_Water_AntiDamage_Percent = 82,     //抗水属性伤害加成/减免百分比
    Attr_Nature_Ground_AntiDamage_Percent = 83,    //抗地属性伤害加成/减免百分比
    Attr_Nature_Fire_AntiDamage_Percent = 84,      //抗火属性伤害加成/减免百分比
    Attr_Nature_Wind_AntiDamage_Percent = 85,      //抗风属性伤害加成/减免百分比
    Attr_Nature_Saint_AntiDamage_Percent = 86,     //抗圣属性伤害加成/减免百分比
    Attr_Nature_Dark_AntiDamage_Percent = 87,      //抗暗属性伤害加成/减免百分比
    Attr_Nature_Read_AntiDamage_Percent = 88,      //抗念属性伤害加成/减免百分比
}

public class StrategyMgr : Singleton<StrategyMgr>
{
    Dictionary<int, Dictionary<EnNatureType, int>> mAnitNatureCfg = new Dictionary<int, Dictionary<EnNatureType, int>>();
    Dictionary<int, Dictionary<EnAttr_NatureType, int>> mAddNatureCfg = new Dictionary<int, Dictionary<EnAttr_NatureType, int>>();
  
    NPack.MersenneTwister rand = null;

    public override void Init()
    {
        base.Init();

        rand = new NPack.MersenneTwister(100);
        ReadAntiNatureCfg();
    }

    public override void UnInit()
    {
        base.UnInit();
    }

    void ReadAntiNatureCfg()
    {
        mAnitNatureCfg.Clear();
        mAddNatureCfg.Clear();
        Dictionary<string, Dictionary<string, string>> table = ConfigMgr.Instance.getTable(Config.NatureCfgName);
        if (table != null)
        {
            foreach (var cfg in table)
            {
                if (cfg.Key.ToLower() == "id" || cfg.Key.ToLower() == "int") continue;

                int natureId = 0;
                int.TryParse(cfg.Key, out natureId);

                if (natureId < 1) continue;

                Dictionary<string, string> dic = cfg.Value;
                if (dic != null)
                {  
                    if (dic.ContainsKey("AntiNature"))
                    {
                        string[] temp = StringUtil.split(dic["AntiNature"], ';');
                        Dictionary<EnNatureType, int> DicantiVals = new Dictionary<EnNatureType, int>();
                        for (int i=0;i< temp.Length;i++)
                        {
                            string[] ArrayValue = StringUtil.split(temp[i], ':');
                            if(ArrayValue.Length==2)
                            {
                                EnNatureType enType = (EnNatureType)int.Parse(ArrayValue[0]);
                                int Val = int.Parse(ArrayValue[1]);
                                DicantiVals.Add(enType, Val);
                            }                           
                        }
                        mAnitNatureCfg.Add(natureId, DicantiVals);
                    }

                    if(dic.ContainsKey("NatureAttribute"))
                    {
                        string[] temp = StringUtil.split(dic["NatureAttribute"], ';');
                        Dictionary<EnAttr_NatureType, int> DicantiVals = new Dictionary<EnAttr_NatureType, int>();
                        if(null != temp)
                        for (int i = 0; i < temp.Length; i++)
                        {
                            string[] ArrayValue = StringUtil.split(temp[i], ':');
                            if (ArrayValue.Length == 2)
                            {
                                EnAttr_NatureType nArrtiId = (EnAttr_NatureType)int.Parse(ArrayValue[0]);
                                int nVal = int.Parse(ArrayValue[1]);
                                DicantiVals.Add(nArrtiId, nVal);
                            }
                        }
                        mAddNatureCfg.Add(natureId, DicantiVals);
                    }
                }
            }
        }
    }


    //附加属性
    public void GetAddAntiAttr(int nNatureId, EnAttr_NatureType enNatureType, out SFloat AntiRatio)
    {
        AntiRatio = 0;      
        if (nNatureId < 0) return;
        int nOutRatio = 0;
        Dictionary<EnAttr_NatureType, int> valList;
        if (mAddNatureCfg.TryGetValue(nNatureId, out valList))
        {
            valList.TryGetValue(enNatureType, out nOutRatio);
            AntiRatio = SFloat.Convert( nOutRatio * 0.0001f);
        }
    }

    //系数获取
    public void GetAntiVals(int nNatureId, EnNatureType enNatureType, out SFloat AntiRatio)
    {       
        AntiRatio = 0.0f;       
        if (nNatureId < 0) return;
        int nOutRatio = 0;
        Dictionary<EnNatureType, int> valList;
        if (mAnitNatureCfg.TryGetValue(nNatureId, out valList))
        {
            valList.TryGetValue(enNatureType, out nOutRatio);
            AntiRatio = SFloat.Convert(nOutRatio * 0.0001f);
        }
    }

    //总值加成获取
    public void GetAllAntiVals(Fighter caster, Fighter target, out SFloat fAddValue)
    {
        fAddValue = 0;       
        SFloat[] ArrayAddAttr = new SFloat[8] { 0, 0, 0, 0, 0, 0, 0, 0 };
        SFloat[] ArrayAntiAttr = new SFloat[8] { 0, 0, 0, 0, 0, 0, 0, 0 };
        int nIndex = 0;
        int nFuncOffset = 42;//效果偏移枚举
        int nAntiTypeOffset = 10;//加成抵抗偏移
        for (int i= (int)EnAttr_NatureType.Attr_Nature_None_Damage_Percent; i <= (int)EnAttr_NatureType.Attr_Nature_Read_Damage_Percent; i++)
        {            
            GetAddAntiAttr(caster.NatureId, (EnAttr_NatureType)i, out ArrayAddAttr[nIndex]);//加成   
            GetAddAntiAttr(target.NatureId, (EnAttr_NatureType)(i+10), out ArrayAntiAttr[nIndex]);//抵抗   
            //加入角色属性 fun 枚举
            /*
                Nature_None_Change_Value = 113,
                Nature_Water_Change_Value = 114,
                Nature_Ground_Change_Value = 115,
                Nature_Fire_Change_Value = 116,
                Nature_Wind_Change_Value = 117,
                Nature_Saint_Change_Value = 118,
                Nature_Dark_Change_Value = 119,
                Nature_Read_Change_Value = 120,

                AntiNature_None_Change_Value = 121,
                AntiNature_Water_Change_Value = 122,
                AntiNature_Ground_Change_Value = 123,
                AntiNature_Fire_Change_Value = 124,
                AntiNature_Wind_Change_Value = 125,
                AntiNature_Saint_Change_Value = 126,
                AntiNature_Dark_Change_Value = 127,
                AntiNature_Read_Change_Value = 128,
             */ 
            ArrayAddAttr[nIndex] += caster.Actor.GetAdditionalAttrPercent(i) + caster.GetBuffFunctionValue((Buff_Function_Type)(i + nFuncOffset));//加成   
            ArrayAntiAttr[nIndex] += target.Actor.GetAdditionalAttrPercent(i + nAntiTypeOffset) + target.GetBuffFunctionValue((Buff_Function_Type)(i + nAntiTypeOffset + nFuncOffset));//抵抗      
            ArrayAntiAttr[nIndex] = Mathf.Max(ArrayAntiAttr[nIndex], 0.0f);//抵抗最小为0
            nIndex += 1;
        }
        
        for (int i= (int)EnNatureType.en_None; i <= (int)EnNatureType.en_Pray; i++)
        {
            SFloat AntiRatio = 0;
            GetAntiVals(target.NatureId, (EnNatureType)i, out AntiRatio);
            fAddValue += Mathf.Min(Mathf.Max((ArrayAddAttr[i-1] - ArrayAntiAttr[i-1]) * AntiRatio, 0.0f), 0.3f);
        }
        fAddValue = Mathf.Min(fAddValue, 1.0f);      
    }
}
