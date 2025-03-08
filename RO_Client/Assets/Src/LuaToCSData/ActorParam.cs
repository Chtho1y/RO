using UnityEngine;
using System.Collections;

public class ServerFighterParam
{
    public long uid;
    public int hp;
    public int sp;
    public float hpPercent;
    public float spPercent;

    public ServerFighterParam(long uid,int hp,int sp,float hpPercent,float spPercent)
    {
        this.uid = uid;
        this.hp = hp;
        this.sp = sp;
        this.hpPercent = hpPercent;
        this.spPercent = spPercent;
    }
}

public class GvGMark
{
    public int m_nMarkid;
    public int m_nMarkNum;
    public GvGMark(int nMarkid, int nMarkNum)
    {
        this.m_nMarkid = nMarkid;
        this.m_nMarkNum = nMarkNum;      
    }

    public GvGMark(JSONObject json)
    {
        this.m_nMarkid = (int)json[0].n;
        this.m_nMarkNum = (int)json[1].n;     
    }

    public JSONObject ToJson()
    {
        JSONObject json = new JSONObject();
        json.Add(this.m_nMarkid);
        json.Add(this.m_nMarkNum);     
        return json;
    }
}

public struct SkillParam
{
    public int skillId;
    public int skillLv;
    public int skillRate;

    public SkillParam(int id, int lv)
    {
        skillId = id;
        skillLv = lv;
        skillRate = 100;
    }

    public SkillParam(int id,int lv,int rate)
    {
        skillId = id;
        skillLv = lv;
        skillRate = rate;
    }

    public SkillParam(JSONObject json)
    {
        skillId = (int)json[0].n;
        skillLv = (int)json[1].n;
        skillRate = (int)json[2].n;
    }

    public JSONObject ToJson()
    {
        JSONObject json = new JSONObject();
        json.Add(skillId);
        json.Add(skillLv);
        json.Add(skillRate);
        return json;
    }
}

public struct BuffParam
{
    public int buffId;
    public int ratio;
    public int cd;
    public int type;
    public int casterType;
    public int extendPara;
    public string funStr;

    public BuffParam(int id,int ratio,int cd,int type)
    {
        this.buffId = id;
        this.ratio = ratio;
        this.cd = cd;
        this.casterType = type / 100;
        this.type = type - this.casterType * 100;
        this.extendPara = 0;
        this.funStr = "";
    }

    public BuffParam(int id, int ratio, int cd, int type,string funStr)
    {
        this.buffId = id;
        this.ratio = ratio;
        this.cd = cd;
        this.casterType = type / 100;
        this.type = type - this.casterType * 100;
        this.extendPara = 0;
        this.funStr = funStr;
    }

    public BuffParam(int id, int ratio, int cd, int type,int extendPara, string funStr)
    {
        this.buffId = id;
        this.ratio = ratio;
        this.cd = cd;
        this.casterType = type / 100;
        this.type = type - this.casterType * 100;
        this.extendPara = extendPara;
        this.funStr = funStr;
    }

    public BuffParam(JSONObject json)
    {
        this.buffId = (int)json[0].n;
        this.ratio = (int)json[1].n;
        this.cd = (int)json[2].n;
        this.type = (int)json[3].n;
        this.casterType = (int)json[4].n;
        this.funStr = json[5].str;
        this.extendPara = (int)json[6].n;
    }

    public JSONObject ToJson()
    {
        JSONObject json = new JSONObject();
        json.Add(this.buffId);
        json.Add(this.ratio);
        json.Add(this.cd);
        json.Add(this.type);
        json.Add(this.casterType);
        json.Add(this.funStr);
        json.Add(this.extendPara);
        return json;
    }
}

public struct HairColorParam
{
    public Color clr;
    public Vector2 uvOffset;
    public HairColorParam(Color clr,Vector2 uvOffset)
    {
        this.clr = clr;
        this.uvOffset = uvOffset;
    }

    public HairColorParam(JSONObject json)
    {
        this.clr = BattleRecorder.ColorFromJson(json[0]);
        this.uvOffset = BattleRecorder.Vector2FromJson(json[1]);
    }

    public JSONObject ToJson()
    {
        JSONObject json = new JSONObject();
        json.Add(BattleRecorder.ColorToJson(this.clr));
        json.Add(BattleRecorder.Vector2ToJson(this.uvOffset));
        return json;
    }
}

public struct BodyPartParam
{
    public int part;
    public string modelPrefab;
    public string linkPoint;
    public Vector3 pos;
    public Vector3 rot;
    public Vector3 scale;

    public BodyPartParam(int part,string modelPrefab,string linkPoint,Vector3 pos,Vector3 rot,Vector3 scale)
    {
        this.part = part;
        this.modelPrefab = modelPrefab;
        this.linkPoint = linkPoint;
        this.pos = pos;
        this.rot = rot;
        this.scale = scale;
    }

    public BodyPartParam(JSONObject json)
    {
        this.part = (int)json[0].n;
        this.modelPrefab = json[1].str;
        this.linkPoint = json[2].str;
        this.pos = BattleRecorder.Vector3FromJson(json[3]);
        this.rot = BattleRecorder.Vector3FromJson(json[4]);
        this.scale = BattleRecorder.Vector3FromJson(json[5]);
    }

    public JSONObject ToJson()
    {
        JSONObject json = new JSONObject();
        json.Add(part);
        json.Add(modelPrefab);
        json.Add(linkPoint);
        json.Add(BattleRecorder.Vector3ToJson(pos));
        json.Add(BattleRecorder.Vector3ToJson(rot));
        json.Add(BattleRecorder.Vector3ToJson(scale));
        return json;
    }
}


public struct FashionParam
{
    public HairColorParam hairClrParam;
    public BodyPartParam[] parts;

    public FashionParam(BodyPartParam[] parts, HairColorParam hairClrParam)
    {
        this.hairClrParam = hairClrParam;

        if(parts != null) { 
            this.parts = new BodyPartParam[parts.Length];
            for (int idx = 0; idx < parts.Length; idx++)
                this.parts[idx] = parts[idx];
        }
        else
        {
            this.parts = null;
        }
    }

    public FashionParam(JSONObject json)
    {
        if(json.HasField("Parts"))
        {
            JSONObject partsJson = json.GetField("Parts");
            this.parts = new BodyPartParam[partsJson.Count];
            for(int idx =0; idx < partsJson.Count;idx++)
            {
                BodyPartParam part = new BodyPartParam(partsJson.list[idx]);
                this.parts[idx] = part;
            }
        }
        else
        {
            this.parts = null;
        }
        
        if(json.HasField("hairColor"))
        {
            JSONObject hairColorJson = json.GetField("hairColor");
            hairClrParam = new HairColorParam(hairColorJson);
        }
        else
        {
            hairClrParam = default(HairColorParam);
        }
    }

    public JSONObject ToJson()
    {
        JSONObject json = new JSONObject();
        if (parts != null)
        {
            JSONObject partsJson = new JSONObject();
            for (int idx = 0; idx < parts.Length; idx++)
            {
                partsJson.Add(parts[idx].ToJson());
            }
            json.AddField("Parts", partsJson);
        }
        json.AddField("hairColor", hairClrParam.ToJson());
        return json;
    }
}

public class ActorParam
{
    public int uid;
    public int baseId;
    public int level;
    public int jobId;
    public int petId;
    public bool isMainRole;
    public bool isRole;
    public int headFrameId;
    public int strengthLevel;
    public SkillParam[] skills;
    public BuffParam[] buffs;
    public FashionParam fashion;
}
