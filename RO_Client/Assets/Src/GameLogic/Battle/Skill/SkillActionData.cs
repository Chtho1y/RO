using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Mono.Xml;
using System.Security;

public class ActionEventParam
{
    public int startFrame;
    public int endFrame;
    public int eventType;
    public bool bAffectBySing;
    public List<FrameEventParam> frameParams;

    public void Dispose()
    {
        if (frameParams != null)
            frameParams.Clear();

        frameParams = null;
    }
}

public class ActionEventData
{
    private int mId;
    public int Id
    {
        get { return mId; }
    }

    private int mTotalFrame = 0;
    public int TotalFrame
    {
        get { return mTotalFrame; }
    }

    private int mJobType;
    public int JobType
    {
        get { return mJobType; }
    }

    private int mJobStage;
    public int JobStage
    {
        get { return mJobStage; }
    }

    private int mJobBranch;
    public int JobBranch
    {
        get { return mJobBranch; }
    }

    private int mGender;
    public int Gender
    {
        get { return mGender; }
    }

    private bool mIsFemale = false;
    private bool mIsMale = false;

    public bool IsFemale
    {
        get { return mIsFemale; }
    }

    public bool IsMale
    {
        get { return mIsMale; }
    }

    public List<ActionEventParam> ActionEventList
    {
        get; private set;
    }

    public ActionEventData(int id,int totalFrame,int gender,int jobType,int jobStage,int jobBranch)
    {
        this.mId = id;
        this.mTotalFrame = totalFrame;
        this.mGender = gender;
        this.mJobType = jobType;
        this.mJobStage = jobStage;
        this.mJobBranch = jobBranch;

        this.mIsFemale = (gender & (int)Role_Gender.Female) == (int)Role_Gender.Female;
        this.mIsMale = (gender & (int)Role_Gender.Male) == (int)Role_Gender.Male;
    }

    public void AddEvent(ActionEventParam eve)
    {
        if(ActionEventList == null)
        {
            ActionEventList = new List<ActionEventParam>();
        }

        ActionEventList.Add(eve);
    }

    public void Dispose()
    {
        if (ActionEventList != null)
        {
            for(int idx =0; idx < ActionEventList.Count; idx++)
            {
                ActionEventList[idx].Dispose();
            }
            ActionEventList.Clear();
            ActionEventList = null;
        }
    }
}
//技能配置xml
public class SkillActionEventCfgMgr : Singleton<SkillActionEventCfgMgr>
{
    List<ActionEventData> mBuffEvents = new List<ActionEventData>();

    public override void Init()
    {
        base.Init();
        ReadEventCfg();
    }

    public override void UnInit()
    {
        base.UnInit();
    }

    void ReadEventCfg()
    {
        mBuffEvents.Clear();
        foreach (var p in ConfigMgr.Instance.XmlConfigDict)
        {
            string frameEventName = p.Key;
            if (!frameEventName.Contains("buff_")) continue;

            if(!ReadBuffEventFile(p.Value))
            {
                DebugHelper.LogError(frameEventName+" 加载有问题");
            }
        }
    }

    bool ReadBuffEventFile(string ta)
    {
        if (ta == null) return false;


        SecurityParser doc = new SecurityParser();
        try
        {
            doc.LoadXml(ta);
        }
        catch (System.Exception e)
        {
            return false;
        }

        SecurityElement root = doc.SelectSingleNode("FrameEvent");
        if (root == null || root.Children == null) return false;

        for (int idx = 0; idx < root.Children.Count; idx++)
        {
            var buffNode = root.Children[idx] as SecurityElement;
            string idStr = buffNode.Attribute("id");
            int id = int.Parse(idStr);
            string frameStr = buffNode.Attribute("endFrame");
            int frame = int.Parse(frameStr);
            int gender = 3;
            if (!int.TryParse(buffNode.Attribute("gender"), out gender))
            {
                gender = 3;
            }

            int jobBranch = 0;
            int jobStage = 0;
            int jobType = 0;
            string tempStr = buffNode.Attribute("jobBranch");
            if(!string.IsNullOrEmpty(tempStr))
            {
                int.TryParse(tempStr, out jobBranch);
            }

            tempStr = buffNode.Attribute("jobStage");
            if(!string.IsNullOrEmpty(tempStr))
            {
                int.TryParse(tempStr, out jobStage);
            }

            tempStr = buffNode.Attribute("jobType");
            if(!string.IsNullOrEmpty(tempStr))
            {
                int.TryParse(tempStr, out jobType);
            }
            
            if (buffNode.Children == null) continue;

            ActionEventData aed = new ActionEventData(id, frame,gender,jobType,jobStage,jobBranch);
            for (int jdx = 0; jdx < buffNode.Children.Count; jdx++)
            {
                var eventNode = buffNode.Children[jdx] as SecurityElement;

                ActionEventParam aep = new ActionEventParam();
                int.TryParse(eventNode.Attribute("startFrame"), out aep.startFrame);
                int.TryParse(eventNode.Attribute("endFrame"), out aep.endFrame);
                int.TryParse(eventNode.Attribute("type"), out aep.eventType);
                bool.TryParse(eventNode.Attribute("affectBySing"), out aep.bAffectBySing);

                aep.frameParams = new List<FrameEventParam>();
                if (eventNode.Children != null)
                {
                    for (int kdx = 0; kdx < eventNode.Children.Count; kdx++)
                    {
                        var paramNode = eventNode.Children[kdx] as SecurityElement;

                        FrameEventParam param = new FrameEventParam();
                        param.name = paramNode.Attribute("name");

                        string valueType = paramNode.Attribute("valueType");
                        if (string.IsNullOrEmpty(valueType))
                        {
                            param.sValue = paramNode.Attribute("value");
                        }
                        else if (valueType.CompareTo("int") == 0)
                        {
                            int.TryParse(paramNode.Attribute("value"), out param.nValue);
                        }
                        else if (valueType.CompareTo("float") == 0)
                        {
                            float.TryParse(paramNode.Attribute("value"), out param.fValue);
                        }
                        else
                        {
                            param.sValue = paramNode.Attribute("value");
                        }

                        aep.frameParams.Add(param);
                    }
                }

                aed.AddEvent(aep);
            }

            mBuffEvents.Add(aed);
        }

        return true;
    }

    public ActionEventData GetActionEventData(int id,int gender,int jobType,int jobStage,int jobBranch)
    {
        bool isFemale = gender == (int)Role_Gender.Female;
        for(int idx =0; idx <  mBuffEvents.Count;idx++)
        {
            var temp = mBuffEvents[idx];
            if(isFemale)
            {
                if (temp.Id == id && temp.IsFemale && temp.JobType == jobType && temp.JobStage == jobStage && temp.JobBranch == jobBranch)
                {
                    return temp;
                }
            }
            else
            {
                if (temp.Id == id && temp.IsMale && temp.JobType == jobType && temp.JobStage == jobStage && temp.JobBranch == jobBranch)
                {
                    return temp;
                }
            }
        }

        for(int idx =0; idx < mBuffEvents.Count;idx++)
        {
            var temp = mBuffEvents[idx];
            if(isFemale)
            {
                if (temp.Id == id && temp.IsFemale)
                    return temp;
            }
            else
            {
                if (temp.Id == id && temp.IsMale)
                    return temp;
            }
        }

        for(int idx =0; idx < mBuffEvents.Count;idx++)
        {
            var temp = mBuffEvents[idx];
            if (temp.Id == id) return temp;
        }
        return null;
    }

    public void Clear()
    {
        mBuffEvents.Clear();
    }
}
