using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class BattleFormulaParamMgr : Singleton<BattleFormulaParamMgr>
{
    Dictionary<int, SFloat> formulaParamDic = new Dictionary<int, SFloat>();
    Dictionary<int, SInt> mFunPointDic = new Dictionary<int, SInt>();

    public Dictionary<int, SInt> FunPointBuffs
    {
        get { return mFunPointDic; }
    }

    public override void Init()
    {
        base.Init();
        LoadCfg();
    }

    public void LoadCfg()
    {
        formulaParamDic.Clear();
        mFunPointDic.Clear();
        string content = ConfigMgr.Instance.GetXmlCfg("BattleFormulaParamCfg");
        if (string.IsNullOrEmpty(content))
        {
            DebugHelper.LogError("BattleFormulaParamCfg 不存在");
            return;
        }

        Mono.Xml.SecurityParser doc = new Mono.Xml.SecurityParser();
        try
        {
            doc.LoadXml(content);
        }
        catch (System.Exception e)
        {
            DebugHelper.Assert(false, "exception = {0}", e.Message);
            return;
        }

        System.Security.SecurityElement root = doc.SelectSingleNode("Params");
        if (root == null || root.Children == null) return;

        for (int idx = 0; idx < root.Children.Count; idx++)
        {
            var paramNode = root.Children[idx] as System.Security.SecurityElement;
            int paramId = 0;
            float paramVal = 0;

            int.TryParse(paramNode.Attribute("id"), out paramId);
            float.TryParse(paramNode.Attribute("value"), out paramVal);
            if (paramId == 0) continue;

            ///10000以下是战斗公式中的数据，10000以上表示效果点buff配置
            if(paramId < 10000)
            {
                if (!formulaParamDic.ContainsKey(paramId))
                    formulaParamDic.Add(paramId, paramVal);
            }
            else
            {
                if (!mFunPointDic.ContainsKey(paramId))
                    mFunPointDic.Add(paramId, (int)paramVal);
            }
        }
    }

    /// <summary>
    /// 获取战斗公式参数，具体参数说明请看BattleFormulaParamCfg.xml配置
    /// </summary>
    /// <param name="id"></param>
    /// <returns></returns>
    public SFloat GetParam(int id)
    {
        SFloat val;
        formulaParamDic.TryGetValue(id, out val);

        return val;
    }

    public SInt GetFunPoint(int buffId)
    {
        SInt point = 0;
        mFunPointDic.TryGetValue(buffId, out point);
        return point;
    }
}
