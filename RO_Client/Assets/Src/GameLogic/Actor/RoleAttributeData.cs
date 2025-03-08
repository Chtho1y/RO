using UnityEngine;
using System.Collections;
using System.Collections.Generic;
/// <summary>
/// 角色基础属性内容相关信息
/// </summary>
public class RoleAttributeData
{
    #region properties
    public int id;
    public int exp;
    public int gainPoint;       //获取的能量点
    public SInt[] attrs = new SInt[ActorData.s_SecondAttrNum];
    #endregion

    private bool bValid = false;
    public bool valid { get { return bValid; } }

    public RoleAttributeData(int level)
    {
        this.id = level;
        Dictionary<string,string> dic = ConfigMgr.Instance.getLine(level, Config.RoleAttrCfgName);   
        if(dic == null)
        {
            DebugHelper.LogError(string.Format("加载角色属性数据失败 id = {0}", id));
            bValid = false;
            return;
        }

        if(dic.ContainsKey("Exp"))
        {
            int.TryParse(dic["Exp"], out exp);
        }

        if(dic.ContainsKey("GetPoint"))
        {
            int.TryParse(dic["GetPoint"], out gainPoint);
        }
        
        int iTemp = 0;
        if(dic.ContainsKey("Hp") && int.TryParse(dic["Hp"], out iTemp))
        {
            attrs[ActorData.Attr_Life - ActorData.Attr_Life] = iTemp;
        }

        if(dic.ContainsKey("Sp") &&  int.TryParse(dic["Sp"],out iTemp))
        {
            attrs[ActorData.Attr_Sp - ActorData.Attr_Life] = iTemp;
        }

        if(dic.ContainsKey("Atk") && int.TryParse(dic["Atk"],out iTemp))
        {
            attrs[ActorData.Attr_Attack - ActorData.Attr_Life] = iTemp;
        }

        if(dic.ContainsKey("Matk") && int.TryParse(dic["Matk"],out iTemp))
        {
            attrs[ActorData.Attr_MagicAttack - ActorData.Attr_Life] = iTemp;
        }

        if(dic.ContainsKey("Def") && int.TryParse(dic["Def"],out iTemp))
        {
            attrs[ActorData.Attr_Defense - ActorData.Attr_Life] = iTemp;
        }

        if(dic.ContainsKey("Mdef") && int.TryParse(dic["Mdef"],out iTemp))
        {
            attrs[ActorData.Attr_MagicDefense - ActorData.Attr_Life] = iTemp;
        }

        if(dic.ContainsKey("Hit") && int.TryParse(dic["Hit"],out iTemp))
        {
            attrs[ActorData.Attr_Hit - ActorData.Attr_Life] = iTemp;
        }

        if(dic.ContainsKey("Dodge") && int.TryParse(dic["Dodge"],out iTemp))
        {
            attrs[ActorData.Attr_Dodge - ActorData.Attr_Life] = iTemp;
        }

        if(dic.ContainsKey("Crit") && int.TryParse(dic["Crit"], out iTemp))
        {
            attrs[ActorData.Attr_Crit - ActorData.Attr_Life] = iTemp;
        }

        if (dic.ContainsKey("Ten") && int.TryParse(dic["Ten"], out iTemp))
        {
            attrs[ActorData.Attr_Ten - ActorData.Attr_Life] = iTemp;
        }
        bValid = true;
    }

    public SInt GetAttr(int attrId)
    {
        if (attrId < ActorData.Attr_Life)
            return 0;

        return attrs[attrId - ActorData.Attr_Life];
    }

	private bool mbDisposed = false;
	public void Dispose()
	{
		if (mbDisposed)
			return;
		attrs = null;

		mbDisposed = true;
	}
}

/// <summary>
/// 角色基础数据
/// </summary>
public class RoleBaseData
{
    public int Id;
    public string Name;
    public string Desc;
    public int professionId;
    public int sex;
    public int avatarId;
    public string headId;
    public string WeaponPath;
    public string ClothPath;
    public string BattleCtrlPath;
    public string ShowCtrlPath;
    public string frameEventName;
    public string battleBigIcon;

    public bool valid
    {
        get { return isvalid; }
    }

    private bool isvalid = false;
    private bool mbDisposed = false;
    public RoleBaseData(int id)
    {
        Id = id;
        Dictionary<string, string> dic = ConfigMgr.Instance.getLine(id, Config.RoleCfgName);
        if(dic!=null)
        {
            if (dic.ContainsKey("Name"))
                this.Name = dic["Name"];

            if (dic.ContainsKey("Desc"))
                this.Desc = dic["Desc"];

            if (dic.ContainsKey("JobId"))
                int.TryParse(dic["JobId"], out professionId);

            if (dic.ContainsKey("Sex"))
                int.TryParse(dic["Sex"], out sex);

            if (dic.ContainsKey("AvatarId"))
                int.TryParse(dic["AvatarId"], out avatarId);

            if (dic.ContainsKey("HeadId"))
                headId = dic["HeadId"];

            if (dic.ContainsKey("BattleCartoonImg"))
            {
                battleBigIcon = dic["BattleCartoonImg"];
            }

            if(dic.ContainsKey("WeaponId"))
            {
                WeaponPath = dic["WeaponId"];
            }

            if (dic.ContainsKey("ClothId"))
            {
                ClothPath = dic["ClothId"];
            }

            if(dic.ContainsKey("BattleCtrl"))
            {
                BattleCtrlPath = dic["BattleCtrl"];
            }

            if(dic.ContainsKey("RoleShowCtrl"))
            {
                ShowCtrlPath = dic["RoleShowCtrl"];
            }

            isvalid = true;
        }
        else
        {
            DebugHelper.LogError(string.Format("角色{0}不存在", id));
        }
    }

    public void Dispose()
    {
        isvalid = false;
    }
}

/// <summary>
/// NPC相关数据
/// </summary>
public class NpcBaseData
{
    public int npcId;
    public int monsterId;
    public string npcName;
    public int level;
    public int avatarId;
    public int headId;
    public int professionType;
    public int position;
    public int bornEffectId;
    public SFloat life;
    public SFloat sp;
    public SFloat minAttack;
    public SFloat attack;
    public SFloat minMagicAttack;
    public SFloat magicAttack;
    public SFloat defense;
    public SFloat magicDefense;
    public SFloat hit;
    public SFloat dodge;
    public SFloat crit;
    public SFloat ten;
    public SFloat attackSpeed;
    public SFloat GodPower;
    public string[] normalSkillIds;
    public string[] skillIds;
    public string[] alternativeSkills;
    public string[] PassiveSkills;
    public int natureId;
    public int raceId;

    public SFloat hpRate;
    public SFloat spRate;
    public SFloat atkRate;
    public SFloat matkRate;
    public SFloat defRate;
    public SFloat mdefRate;
    public SFloat hitRate;
    public SFloat dodgeRate;
    public SFloat critRate;
    public SFloat tenRate;
    public SFloat GodPowerRate;
    public string headIcon;
    public string battleBigIcon;

    public string frameEventName;

    public bool showHpBar;

    public bool valid
    {
        get { return isvalid; }
    }

    private bool isvalid = false;
    private bool mbDisposed = false;
    public NpcBaseData(int id)
    {
        npcId = id;
        ReadFromConfig();
    }

    void ReadFromConfig()
    {
        Dictionary<string, string> dic = ConfigMgr.Instance.getLine(this.npcId, Config.NpcCfgName);
        if (dic != null)
        {
            this.npcName = dic["Name"];

            if(dic.ContainsKey("MonsterId"))
            {
                int.TryParse(dic["MonsterId"], out monsterId);
            }

            if(dic.ContainsKey("BaseLv"))
            {
                int.TryParse(dic["BaseLv"], out level);
            }

            if(dic.ContainsKey("AvatarId"))
            {
                int.TryParse(dic["AvatarId"], out avatarId);
            }

            if(dic.ContainsKey("HeadId"))
            {
                int.TryParse(dic["HeadId"], out headId);
            }

            if(dic.ContainsKey("JobType"))
            {
                int.TryParse(dic["JobType"], out professionType);
            }

            if(dic.ContainsKey("Position"))
            {
                int.TryParse(dic["Position"], out position);
            }

            if(dic.ContainsKey("Hp"))
            {
                float temp = 0;
                float.TryParse(dic["Hp"], out temp);
                life = temp;
            }

            if(dic.ContainsKey("Sp"))
            {
                float temp = 0;
                float.TryParse(dic["Sp"], out temp);
                sp = temp;
            }

            if(dic.ContainsKey("Atk"))
            {
                float temp = 0;
                float.TryParse(dic["Atk"], out temp);
                attack = temp;
            }

            if(dic.ContainsKey("MinAtk"))
            {
                float temp = 0;
                float.TryParse(dic["MinAtk"], out temp);
                minAttack = temp;
            }

            if(dic.ContainsKey("Matk"))
            {
                float temp = 0;
                float.TryParse(dic["Matk"], out temp);
                magicAttack = temp;
            }

            if(dic.ContainsKey("MinMatk"))
            {
                float temp = 0;
                float.TryParse(dic["MinMatk"], out temp);
                minMagicAttack = temp;
            }

            if(dic.ContainsKey("Def"))
            {
                float temp = 0;
                float.TryParse(dic["Def"], out temp);
                defense = temp;
            }

            if(dic.ContainsKey("Mdef"))
            {
                float temp = 0;
                float.TryParse(dic["Mdef"], out temp);
                magicDefense = temp;
            }

            if(dic.ContainsKey("Hit"))
            {
                float temp = 0;
                float.TryParse(dic["Hit"], out temp);
                hit = temp;
            }

            if(dic.ContainsKey("Dodge"))
            {
                float temp = 0;
                float.TryParse(dic["Dodge"], out temp);
                dodge = temp;
            }

            if(dic.ContainsKey("Crit"))
            {
                float temp = 0;
                float.TryParse(dic["Crit"], out temp);
                crit = temp;
            }

            if(dic.ContainsKey("Ten"))
            {
                float temp = 0;
                float.TryParse(dic["Ten"], out temp);
                ten = temp;
            }

            if(dic.ContainsKey("AttackSpeed"))
            {
                float temp  = 0;
                float.TryParse(dic["AttackSpeed"], out temp);
                attackSpeed = temp;
            }

            if(dic.ContainsKey("NatureId"))
            {
                int.TryParse(dic["NatureId"], out natureId);
            }

            if(dic.ContainsKey("RaceId"))
            {
                int.TryParse(dic["RaceId"], out raceId);
            }

            if (dic.ContainsKey("NormalSkillIds"))
            {
                normalSkillIds = StringUtil.split(dic["NormalSkillIds"], ';');
            }

            if(dic.ContainsKey("SkillIds"))
            {
                skillIds = StringUtil.split(dic["SkillIds"], ';');
            }

            if(dic.ContainsKey("AlternativeSkills"))
            {
                alternativeSkills = StringUtil.split(dic["AlternativeSkills"], ';');
            }

            if (dic.ContainsKey("PassiveSkills"))
            {
                PassiveSkills = StringUtil.split(dic["PassiveSkills"], ';');        
            }            

            if (dic.ContainsKey("BattleCartoonImg"))
            {
                battleBigIcon = dic["BattleCartoonImg"];
            }

            if(dic.ContainsKey("Head"))
            {
                headIcon = dic["Head"];
            }

            if(dic.ContainsKey("HPBar"))
            {
                int temp = 0;
                int.TryParse(dic["HPBar"], out temp);
                showHpBar = temp > 0;
            }

            if(dic.ContainsKey("BornEffect"))
            {
                int.TryParse(dic["BornEffect"], out bornEffectId);
            }

            if(dic.ContainsKey("ArtifactValue"))
            {
                float temp = 0;
                float.TryParse(dic["ArtifactValue"], out temp);
                GodPower = temp;                
            }
            if (dic.ContainsKey("ArtifactValueRate"))
            {
                float temp = 0;
                float.TryParse(dic["ArtifactValueRate"], out temp);
                GodPowerRate = temp;                
            }            

            hpRate = ReadAttrRate(dic, "HpRate");
            spRate = ReadAttrRate(dic, "SpRate");
            atkRate = ReadAttrRate(dic, "AtkRate");
            matkRate = ReadAttrRate(dic, "MatkRate");
            defRate = ReadAttrRate(dic, "DefRate");
            mdefRate = ReadAttrRate(dic, "MdefRate");
            hitRate = ReadAttrRate(dic, "HitRate");
            dodgeRate = ReadAttrRate(dic, "DodgeRate");
            critRate = ReadAttrRate(dic, "CritRate");
            tenRate = ReadAttrRate(dic, "TenRate");

            isvalid = true;
        }
        else
        {
            DebugHelper.Log("NPC配置不存在！ID: " + npcId);
        }
    }

    SFloat ReadAttrRate(Dictionary<string, string> dic, string attrName)
    {
        if (dic == null)
        {
            return 0;
        }

        if(dic.ContainsKey(attrName))
        {
            int temp;
            int.TryParse(dic[attrName], out temp);
            return temp/10000.0f;
        }
        return 0;
    }

    public void Dispose()
    {
        if (mbDisposed)
            return;

        skillIds = null;
        normalSkillIds = null;
        PassiveSkills = null;
        mbDisposed = true;
    }
}

public struct stPetSkillData
{
    private int mSkillId;
    private List<int> mTriggerRate;

    public int SkillId
    {
        get { return mSkillId; }
        set { mSkillId = value; }
    }

    public List<int> TriggerRate
    {
        get { return mTriggerRate; }
        set { mTriggerRate = value; }
    }
}


public class PetBossBaseData: PetBaseData
{
    public PetBossBaseData(int id):base(id)
    {
        petId = id;
        ReadFromConfig();
    }
    protected override void ReadFromConfig()
    {
        Dictionary<string, string> dic = ConfigMgr.Instance.getLine(petId, Config.PetBossCfgName);
        if (dic != null)
        {
            this.petName = dic["Name"];

            if (dic.ContainsKey("AvatarId"))
            {
                int.TryParse(dic["AvatarId"], out avatarId);
            }

            if (dic.ContainsKey("JobType"))
            {
                int.TryParse(dic["JobType"], out profession);
            }

            if (dic.ContainsKey("Head"))
            {
                headIcon = dic["Head"];
            }

            if (dic.ContainsKey("Quality"))
            {
                int.TryParse(dic["Quality"], out quality);
            }

            if (dic.ContainsKey("NatureType"))
            {
                int.TryParse(dic["NatureType"], out natureId);
            }

            if (dic.ContainsKey("Pos"))
            {
                int.TryParse(dic["Pos"], out position);
            }

            if (dic.ContainsKey("Hp"))
            {
                float temp = 0;
                float.TryParse(dic["Hp"], out temp);
                life = temp;
            }

            if (dic.ContainsKey("Sp"))
            {
                float temp = 0;
                float.TryParse(dic["Sp"], out temp);
                sp = temp;
            }

            if (dic.ContainsKey("Atk"))
            {
                float temp = 0;
                float.TryParse(dic["Atk"], out temp);
                attack = temp;
            }

            if (dic.ContainsKey("Matk"))
            {
                float temp = 0;
                float.TryParse(dic["Matk"], out temp);
                magicAttack = temp;
            }

            if (dic.ContainsKey("Def"))
            {
                float temp = 0;
                float.TryParse(dic["Def"], out temp);
                defense = temp;
            }

            if (dic.ContainsKey("Mdef"))
            {
                float temp = 0;
                float.TryParse(dic["Mdef"], out temp);
                magicDefense = temp;
            }

            if (dic.ContainsKey("Hit"))
            {
                float temp = 0;
                float.TryParse(dic["Hit"], out temp);
                hit = temp;
            }

            if (dic.ContainsKey("Dodge"))
            {
                float temp = 0;
                float.TryParse(dic["Dodge"], out temp);
                dodge = temp;
            }

            if (dic.ContainsKey("Crit"))
            {
                float temp = 0;
                float.TryParse(dic["Crit"], out temp);
                crit = temp;
            }

            if (dic.ContainsKey("Ten"))
            {
                float temp = 0;
                float.TryParse(dic["Ten"], out temp);
                ten = temp;
            }

            if (dic.ContainsKey("AttackSpeed"))
            {
                float temp = 0;
                float.TryParse(dic["AttackSpeed"], out temp);
                attackSpeed = temp;
            }

            if (dic.ContainsKey("NormalSkillIds"))
            {
                normalSkillIds = StringUtil.split(dic["NormalSkillIds"], ';');
            }

            skills = new stPetSkillData[3];
            for (int idx = 1; idx <= 3; idx++)
            {
                string skillKey = "Skill" + idx;
                string skillRateKey = skillKey + "Rate";
                if (dic.ContainsKey(skillKey))
                {
                    int skillId = 0;
                    stPetSkillData skillData = new stPetSkillData();
                    int.TryParse(dic[skillKey], out skillId);
                    if (skillId > 0)
                    {
                        skillData.SkillId = skillId;

                        if (dic.ContainsKey(skillRateKey))
                        {
                            skillData.TriggerRate = StringUtil.convert2IntList(dic[skillRateKey], ';');
                        }
                        skills[idx - 1] = skillData;

                        if (idx == 1)
                        {
                            SkillParam p = new SkillParam(skillId, 1);
                            testSkills.Add(p);
                        }
                        else
                        {
                            SkillParam p = new SkillParam(skillId, 1, skillData.TriggerRate[0]);
                            testSkills.Add(p);
                        }
                    }
                }
            }

            if (dic.ContainsKey("EmptySkill"))
            {
                int.TryParse(dic["EmptySkill"], out emptySkillId);
            }

            if (dic.ContainsKey("BattleCtrl"))
            {
                battleCtrl = dic["BattleCtrl"];
            }

            if (dic.ContainsKey("ShowCtrl"))
            {
                showCtrl = dic["ShowCtrl"];
            }

            hpRate = ReadAttrRate(dic, "HpRate");
            spRate = ReadAttrRate(dic, "SpRate");
            atkRate = ReadAttrRate(dic, "AtkRate");
            matkRate = ReadAttrRate(dic, "MatkRate");
            defRate = ReadAttrRate(dic, "DefRate");
            mdefRate = ReadAttrRate(dic, "MdefRate");
            hitRate = ReadAttrRate(dic, "HitRate");
            dodgeRate = ReadAttrRate(dic, "DodgeRate");
            critRate = ReadAttrRate(dic, "CritRate");
            tenRate = ReadAttrRate(dic, "TenRate");

            isvalid = true;
        }
        else
        {
            DebugHelper.LogError("宠物配置不存在！ID: " + petId);
        }
    }
}

public class PetBaseData
{
    public int petId;
    public string petName;
    public int avatarId;
    public int position;
    public int quality;
    public int natureId;
    public int profession;
    public string headIcon;
    public string battleCtrl;
    public string showCtrl;


    public string[] normalSkillIds;
    public stPetSkillData[] skills;
    public int emptySkillId;

    public SFloat life;
    public SFloat sp;
    public SFloat attack;
    public SFloat magicAttack;
    public SFloat defense;
    public SFloat magicDefense;
    public SFloat hit;
    public SFloat dodge;
    public SFloat crit;
    public SFloat ten;
    public SFloat attackSpeed;
   
    public SFloat hpRate;
    public SFloat spRate;
    public SFloat atkRate;
    public SFloat matkRate;
    public SFloat defRate;
    public SFloat mdefRate;
    public SFloat hitRate;
    public SFloat dodgeRate;
    public SFloat critRate;
    public SFloat tenRate;

    public List<SkillParam> testSkills = new List<SkillParam>();
    public bool valid
    {
        get { return isvalid; }
    }

    protected bool isvalid = false;
    private bool mbDisposed = false;
    public PetBaseData(int id)
    {
        petId = id;
        ReadFromConfig();
    }

    protected virtual void ReadFromConfig()
    {
        Dictionary<string, string> dic = ConfigMgr.Instance.getLine(petId, Config.PetCfgName);
        if (dic != null)
        {
            this.petName = dic["Name"];

            if (dic.ContainsKey("AvatarId"))
            {
                int.TryParse(dic["AvatarId"], out avatarId);
            }

            if(dic.ContainsKey("JobType"))
            {
                int.TryParse(dic["JobType"], out profession);
            }

            if (dic.ContainsKey("Icon"))
            {
                headIcon = dic["Icon"];
            }

            if(dic.ContainsKey("Quality"))
            {
                int.TryParse(dic["Quality"], out quality);
            }

            if (dic.ContainsKey("NatureType"))
            {
                int.TryParse(dic["NatureType"], out natureId);
            }

            if (dic.ContainsKey("Pos"))
            {
                int.TryParse(dic["Pos"], out position);
            }

            if (dic.ContainsKey("Hp"))
            {
                float temp = 0;
                float.TryParse(dic["Hp"], out temp);
                life = temp;
            }

            if (dic.ContainsKey("Sp"))
            {
                float temp = 0;
                float.TryParse(dic["Sp"], out temp);
                sp = temp;
            }

            if (dic.ContainsKey("Atk"))
            {
                float temp = 0;
                float.TryParse(dic["Atk"], out temp);
                attack = temp;
            }

            if (dic.ContainsKey("Matk"))
            {
                float temp = 0;
                float.TryParse(dic["Matk"], out temp);
                magicAttack = temp;
            }

            if (dic.ContainsKey("Def"))
            {
                float temp = 0;
                float.TryParse(dic["Def"], out temp);
                defense = temp;
            }

            if (dic.ContainsKey("Mdef"))
            {
                float temp = 0;
                float.TryParse(dic["Mdef"], out temp);
                magicDefense = temp;
            }

            if (dic.ContainsKey("Hit"))
            {
                float temp = 0;
                float.TryParse(dic["Hit"], out temp);
                hit = temp;
            }

            if (dic.ContainsKey("Dodge"))
            {
                float temp = 0;
                float.TryParse(dic["Dodge"], out temp);
                dodge = temp;
            }

            if (dic.ContainsKey("Crit"))
            {
                float temp = 0;
                float.TryParse(dic["Crit"], out temp);
                crit = temp;
            }

            if (dic.ContainsKey("Ten"))
            {
                float temp = 0;
                float.TryParse(dic["Ten"], out temp);
                ten = temp;
            }

            if (dic.ContainsKey("AttackSpeed"))
            {
                float temp = 0;
                float.TryParse(dic["AttackSpeed"], out temp);
                attackSpeed = temp;
            }

            if (dic.ContainsKey("NormalSkillIds"))
            {
                normalSkillIds = StringUtil.split(dic["NormalSkillIds"], ';');
            }

            skills = new stPetSkillData[3];
            for (int idx =1; idx <= 3; idx++)
            {
                string skillKey = "Skill" + idx;
                string skillRateKey = skillKey + "Rate";
                if (dic.ContainsKey(skillKey))
                {
                    int skillId = 0;
                    stPetSkillData skillData = new stPetSkillData();
                    int.TryParse(dic[skillKey], out skillId);
                    if (skillId > 0)
                    {
                        skillData.SkillId = skillId;

                        if (dic.ContainsKey(skillRateKey))
                        {
                            skillData.TriggerRate = StringUtil.convert2IntList(dic[skillRateKey], ';');
                        }
                        skills[idx-1] = skillData;
                        
                        if(idx == 1)
                        {
                            SkillParam p = new SkillParam(skillId, 1);
                            testSkills.Add(p);
                        }
                        else
                        {
                            SkillParam p = new SkillParam(skillId, 1,skillData.TriggerRate[0]);
                            testSkills.Add(p);
                        }
                    }
                }
            }

            if(dic.ContainsKey("EmptySkill"))
            {
                int.TryParse(dic["EmptySkill"], out emptySkillId);
            }

            if(dic.ContainsKey("BattleCtrl"))
            {
                battleCtrl = dic["BattleCtrl"];
            }

            if(dic.ContainsKey("ShowCtrl"))
            {
                showCtrl = dic["ShowCtrl"];
            }

            hpRate = ReadAttrRate(dic, "HpRate");
            spRate = ReadAttrRate(dic, "SpRate");
            atkRate = ReadAttrRate(dic, "AtkRate");
            matkRate = ReadAttrRate(dic, "MatkRate");
            defRate = ReadAttrRate(dic, "DefRate");
            mdefRate = ReadAttrRate(dic, "MdefRate");
            hitRate = ReadAttrRate(dic, "HitRate");
            dodgeRate = ReadAttrRate(dic, "DodgeRate");
            critRate = ReadAttrRate(dic, "CritRate");
            tenRate = ReadAttrRate(dic, "TenRate");

            isvalid = true;
        }
        else
        {
            DebugHelper.LogError("宠物配置不存在！ID: " + petId);
        }
    }

    protected SFloat ReadAttrRate(Dictionary<string, string> dic, string attrName)
    {
        if (dic == null)
        {
            return 0;
        }

        if (dic.ContainsKey(attrName))
        {
            int temp;
            int.TryParse(dic[attrName], out temp);
            return temp / 10000.0f;
        }
        return 0;
    }

    public void Dispose()
    {
        if (mbDisposed)
            return;

        normalSkillIds = null;
        skills = null;

        mbDisposed = true;
    }
}

public class PetAdvanceData
{
    public Dictionary<int, List<ValType>> advanceData;
    public Dictionary<int, List<ValType>> advanceRateData;
    public PetAdvanceData(int id)
    {
        ReadFromConfig(id);
    }

    void ReadFromConfig(int petId)
    {
        Dictionary<string, string> dic = ConfigMgr.Instance.getLine(petId, Config.PetProgressCfgName);
        if (dic != null)
        {
            advanceData = new Dictionary<int, List<ValType>>();
            advanceRateData = new Dictionary<int, List<ValType>>();

            for (int idx = 1; idx <= 5; idx++)
            {
                string attributeKey = "Attribute" + idx;
                string attributeRateKey = "AttributeRateAdd" + idx;
                if (dic.ContainsKey(attributeKey))
                {
                    string temp = dic[attributeKey];
                    if(!string.IsNullOrEmpty(temp))
                    {
                        List<ValType> advanceVals = new List<ValType>();
                        string[] tempList = temp.Split(';');
                        for(int jdx = 0; jdx < tempList.Length;jdx++)
                        {
                            string[] valList = tempList[jdx].Split(':');
                            if(valList.Length == 2)
                            {
                                int keyVal = 0;
                                int iVal = 0;
                                int.TryParse(valList[0], out keyVal);
                                int.TryParse(valList[1], out iVal);
                                ValType valType = new ValType(keyVal, iVal);
                                advanceVals.Add(valType);
                            }
                        }
                        advanceData.Add(idx, advanceVals);
                    }
                }

                if(dic.ContainsKey(attributeRateKey))
                {
                    string temp = dic[attributeRateKey];
                    if (!string.IsNullOrEmpty(temp))
                    {
                        List<ValType> advanceRateVals = new List<ValType>();
                        string[] tempList = temp.Split(';');
                        for (int jdx = 0; jdx < tempList.Length; jdx++)
                        {
                            string[] valList = tempList[jdx].Split(':');
                            if (valList.Length == 2)
                            {
                                int keyVal = 0;
                                int iVal = 0;
                                int.TryParse(valList[0], out keyVal);
                                int.TryParse(valList[1], out iVal);
                                ValType valType = new ValType(keyVal, iVal);
                                advanceRateVals.Add(valType);
                            }
                        }
                        advanceRateData.Add(idx, advanceRateVals);
                    }
                }
            }
        }
        else
        {
            DebugHelper.LogError("宠物进阶表中没有宠物配置！ID: " + petId);
        }
    }
}

//伙伴基础数据
public class FellowBaseData
{
    private string[] mNormalSkillIds;
    private string[] mSkillIds;
    private string[] mAlternativeSkills;
    private bool isValid = false;
    public bool valid
    {
        get { return isValid; }
    }

    public int Id;
    public string Name;
    public string Desc;
    public int AvatarId;
    public int NatureId;
    public int RaceId;
    public int Position;
    public int JobType;
    public int JobStage;
    public int JobBranch;
    public SFloat STRRate;
    public SFloat INTRate;
    public SFloat AGIRate;
    public SFloat DEXRate;
    public SFloat LUCKRate;
    public SFloat VITRate;
    public SFloat AttackSpeed;
    public string[] NormalSkillIds { get { return mNormalSkillIds; } }
    public string[] SkillIds { get { return mSkillIds; } }
    public string[] AlternativeSkills { get { return mAlternativeSkills; } }


    public SInt[] attrs = new SInt[ActorData.s_SecondAttrNum];
    public string frameEventName;
    public string ProfessionIcon;
    public string HeadIcon;
    public string ShowAnimCtrl;
    public string BattleAnimCtrl;
    public string battleBigIcon;


    public FellowBaseData(int id)
    {
        Dictionary<string, string> dic = ConfigMgr.Instance.getLine(id, Config.FellowCfgName);
        if (dic != null)
        {
            this.Id = id;
            this.Name = dic["Name"];
            this.Desc = dic["Desc"];
            this.ProfessionIcon = dic["JobIcon"];
            this.HeadIcon = dic["HeadId"];

            int.TryParse(dic["AvatarId"], out this.AvatarId);
            int.TryParse(dic["Position"], out this.Position);
            int.TryParse(dic["NatureId"], out this.NatureId);
            int.TryParse(dic["RaceId"], out this.RaceId);
            int.TryParse(dic["JobType"], out this.JobType);      

            int temp = 0; 
            int.TryParse(dic["StrRate"], out temp);
            STRRate = temp * 0.0001f;


            int.TryParse(dic["IntRate"], out temp);
            INTRate = temp * 0.0001f;

            int.TryParse(dic["AgiRate"], out temp);
            AGIRate = temp * 0.0001f;

            int.TryParse(dic["DexRate"], out temp);
            DEXRate = temp * 0.0001f;

            int.TryParse(dic["LucRate"], out temp);
            LUCKRate = temp * 0.0001f;

            int.TryParse(dic["ViteRate"], out temp);
            VITRate = temp * 0.0001f;
  
            int.TryParse(dic["Aspd"], out temp);
            AttackSpeed = temp;

            if(dic.ContainsKey("JobStage"))
            {
                int.TryParse(dic["JobStage"], out this.JobStage);
            }

            if(dic.ContainsKey("JobBranch"))
            {
                int.TryParse(dic["JobBranch"], out this.JobBranch);
            }

            if (dic.ContainsKey("Hp") && int.TryParse(dic["Hp"], out temp))
            {
                attrs[ActorData.Attr_Life - ActorData.Attr_Life] = temp;
            }

            if (dic.ContainsKey("Sp") && int.TryParse(dic["Sp"], out temp))
            {
                attrs[ActorData.Attr_Sp - ActorData.Attr_Life] = temp;
            }

            if (dic.ContainsKey("Atk") && int.TryParse(dic["Atk"], out temp))
            {
                attrs[ActorData.Attr_Attack - ActorData.Attr_Life] = temp;
            }

            if (dic.ContainsKey("Matk") && int.TryParse(dic["Matk"], out temp))
            {
                attrs[ActorData.Attr_MagicAttack - ActorData.Attr_Life] = temp;
            }

            if (dic.ContainsKey("Def") && int.TryParse(dic["Def"], out temp))
            {
                attrs[ActorData.Attr_Defense - ActorData.Attr_Life] = temp;
            }

            if (dic.ContainsKey("Mdef") && int.TryParse(dic["Mdef"], out temp))
            {
                attrs[ActorData.Attr_MagicDefense - ActorData.Attr_Life] = temp;
            }

            if (dic.ContainsKey("Hit") && int.TryParse(dic["Hit"], out temp))
            {
                attrs[ActorData.Attr_Hit - ActorData.Attr_Life] = temp;
            }

            if (dic.ContainsKey("Dodge") && int.TryParse(dic["Dodge"], out temp))
            {
                attrs[ActorData.Attr_Dodge - ActorData.Attr_Life] = temp;
            }

            if (dic.ContainsKey("Crit") && int.TryParse(dic["Crit"], out temp))
            {
                attrs[ActorData.Attr_Crit - ActorData.Attr_Life] = temp;
            }

            if (dic.ContainsKey("Ten") && int.TryParse(dic["Ten"], out temp))
            {
                attrs[ActorData.Attr_Ten - ActorData.Attr_Life] = temp;
            }

            if (dic.ContainsKey("NormalSkillIds"))
            {
                mNormalSkillIds = StringUtil.split(dic["NormalSkillIds"], ';');
            }

            if (dic.ContainsKey("SkillIds"))
            {
                mSkillIds = StringUtil.split(dic["SkillIds"], ';');
            }

            if(dic.ContainsKey("AlternativeSkills"))
            {
                mAlternativeSkills = StringUtil.split(dic["AlternativeSkills"], ';');
            }

            if(dic.ContainsKey("ShowCtrl"))
            {
                ShowAnimCtrl = dic["ShowCtrl"];
            }

            if(dic.ContainsKey("BattleCtrl"))
            {
                BattleAnimCtrl = dic["BattleCtrl"];
            }

            if (dic.ContainsKey("BattleCartoonImg"))
            {
                battleBigIcon = dic["BattleCartoonImg"];
            }

            isValid = true;
        }
    }

    public SInt GetAttr(int attrId)
    {
        if (attrId < ActorData.Attr_Life)
            return 0;

        return attrs[attrId - ActorData.Attr_Life];
    }

    public void Dispose()
    {
        isValid = false;
        mNormalSkillIds = null;
        mSkillIds = null;
        attrs = null;
    }
}

//伙伴属性数据
public class FellowAttributeData
{
    #region properties
    public int id;
    public int exp;
    public int gainPoint;       //获取的能量点
    public int upgradeCost;     //升级费用
    #endregion

    private bool bValid = false;
    public bool valid { get { return bValid; } }

    public FellowAttributeData(int level)
    {
        this.id = level;
        Dictionary<string, string> dic = ConfigMgr.Instance.getLine(level, Config.FellowAttrCfgName);
        if (dic == null)
        {
            DebugHelper.LogError(string.Format("加载角色属性数据失败 id = {0}", id));
            bValid = false;
            return;
        }

        if (dic.ContainsKey("Exp"))
        {
            int.TryParse(dic["Exp"], out exp);
        }

        if (dic.ContainsKey("Money"))
        {
            int.TryParse(dic["Money"], out upgradeCost);
        }

        bValid = true;
    }

    private bool mbDisposed = false;
    public void Dispose()
    {
        if (mbDisposed)
            return;
        mbDisposed = true;
    }
}