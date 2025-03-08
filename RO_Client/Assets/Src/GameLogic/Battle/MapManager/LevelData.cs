using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;

//关卡数据
public class LevelItem : IComparable<LevelItem>
{
    #region Config Field
    public int LevelId = 0;//level id
    public int MapId = 0;//所在的地图 id
    public string Name = "";//小副本的名称.
    public string Describe = string.Empty;
    public Level_Type LevelType = Level_Type.Small_Level;             //关卡类型

    private bool mbDisposed = false;
    private bool bValid = false;
    private float bossDelayEndTime = 3;
    private float monsterDelayEndTime = 1;
    private int mShowBossIntroType = 0;        //是否显示boss出场表现

    private float mShowBossIntroUITime = 0;     //boss界面开始显示的时间戳
    public float ShowBossIntroUITime
    {
        get { return mShowBossIntroUITime; }
    }

    private float mShowBossIntroDuration = 0;   //boss入场持续总的时长
    public float ShowBossIntroDuration
    {
        get { return mShowBossIntroDuration; }
    }

    private int[] dropItems;                    //掉落的物品
    public int[] DropItems
    {
        get { return dropItems; }
    }

    private float showDropDuration;             //显示掉落物品时长
    public float ShowDropDuration
    {
        get { return showDropDuration; }
    }

    public int[] PathList;
    public int bossBornIdx = 0;

    public int ShowBossIntroType
    {
        get { return mShowBossIntroType; }
    }

    //通关可获得的经验值
    private int mExp = 0;
    public int Exp
    {
        get { return mExp; }
        set { mExp = value; }
    }

    private int mPartnerExp;
    public int PartnerExp
    {
        get { return mPartnerExp; }
        set { mPartnerExp = value; }
    }

    private int mCruiseVal;
    public int CruiseVal
    {
        get { return mCruiseVal; }
    }

    private int mGold = 0;
    public int Gold
    {
        get { return mGold; }
        set { mGold = value; }
    }

    private int mEvil = 0;
    public int Evil
    {
        get { return mEvil; }
        set { mEvil = value; }
    }

    //通关可获得的zeny
    private int mZeny = 0;
    public int Zeny
    {
        get { return mZeny; }
        set { mZeny = value; }
    }

    private int mMonsterLv;
    public int MonsterLv
    {
        get { return mMonsterLv; }
    }

    private int mChallengeLv;
    public int ChallengeLv
    {
        get { return mChallengeLv; }
    }

    public bool HasPassed = false;      //场景是否通关【kill boss】

    public List<int> ShowEnemyBoss;
	public List<int> ShowEnemyBossIntro;

    private List<ActorData> mMonsters;
    public List<ActorData> Monsters
    {
        get { return mMonsters; }
    }

    public bool Valid
    {
        get { return bValid; }
    }

    public int bossId;
    public int bossPos;

    private ActorData mBossActor;
    public ActorData BossActor
    {
        get { return mBossActor; }
    }

    public float BossDelayEndTime
    {
        get { return bossDelayEndTime; }
    }

    public float MonsterDelayEndTime
    {
        get { return monsterDelayEndTime; }
    }

    private int rageId;

    private int mDlgId;
    public int DlgId
    {
        get { return mDlgId; }
    }

    private string mBattleBgm;
    public string BattleBgm
    {
        get { return mBattleBgm; }
    }

    #endregion

    public LevelItem(int mapId, int levelId)
    {
        this.LevelId = levelId;
        this.MapId = mapId;
        ReadFromConfig();
        InitMonsterData();
    }

    void ReadFromConfig()
    {
        int miniRewardTime = GlobalConfig.Instance.GetConfigIntValue(GlobalConfig.c_miniRewardTime_cfg_id) / 60;
        if (miniRewardTime == 0) miniRewardTime = 1;

        int id = MapId * 10000 + LevelId;
        Dictionary<string, string> dic = ConfigMgr.Instance.getLine(id, Config.LevelCfgName);
        if (dic != null)
        {
            this.Name = dic["Name"];

            if(dic.ContainsKey("BaseExpOl"))
            {
                int.TryParse(dic["BaseExpOl"], out mExp);
                mExp /= miniRewardTime;
            }

            if(dic.ContainsKey("ZenyOl"))
            {
                int.TryParse(dic["ZenyOl"], out mZeny);
                mZeny /= miniRewardTime;
            }

            if(dic.ContainsKey("ParterOl"))
            {
                int.TryParse(dic["ParterOl"], out mPartnerExp);
                mPartnerExp /= miniRewardTime;
            }

            if(dic.ContainsKey("CruiseOl"))
            {
                int.TryParse(dic["CruiseOl"], out mCruiseVal);
                mCruiseVal /= miniRewardTime;
            }

            if (dic.ContainsKey("GoldOl"))
            {
                int.TryParse(dic["GoldOl"], out mGold);
                mGold /= miniRewardTime;
            }

            if(dic.ContainsKey("EvilOl"))
            {
                int.TryParse(dic["EvilOl"], out mEvil);
                mEvil /= miniRewardTime;
            }

            int temp;
            if (int.TryParse(dic["LevelType"], out temp))
            {
                this.LevelType = (Level_Type)temp;
            }

            int.TryParse(dic["BossId"], out bossId);
           
            if (dic.ContainsKey("BossDeadDelay"))
            {
                float.TryParse(dic["BossDeadDelay"], out this.bossDelayEndTime);
            }

            if (dic.ContainsKey("MonsterDeadDelay"))
            {
                float.TryParse(dic["MonsterDeadDelay"], out this.monsterDelayEndTime);
            }

            if(dic.ContainsKey("BossAnimation"))
            {
                int.TryParse(dic["BossAnimation"], out this.mShowBossIntroType);
            }

            if(dic.ContainsKey("UiShowTime"))
            {
                float.TryParse(dic["UiShowTime"], out this.mShowBossIntroUITime);
            }

            if(dic.ContainsKey("BossAnimationTime"))
            {
                float.TryParse(dic["BossAnimationTime"], out this.mShowBossIntroDuration);
            }

            if (dic.ContainsKey("Drops"))
            {
                dropItems = StringUtil.split2Int(dic["Drops"], ';');
            }

            if(dic.ContainsKey("DropTime"))
            {
                float.TryParse(dic["DropTime"], out this.showDropDuration);
            }

            if(dic.ContainsKey("BossPosition"))
            {
                int.TryParse(dic["BossPosition"], out this.bossPos);
            }

            if(dic.ContainsKey("BossRageBuffId"))
            {
                int.TryParse(dic["BossRageBuffId"], out this.rageId);
            }

            if(dic.ContainsKey("PathList"))
            {
                PathList = StringUtil.split2Int(dic["PathList"], ';');
            }

            if(dic.ContainsKey("BossBorn"))
            {
                int.TryParse(dic["BossBorn"], out bossBornIdx);
            }

            if(dic.ContainsKey("MonsterLv"))
            {
                int.TryParse(dic["MonsterLv"], out mMonsterLv);
            }

            if(dic.ContainsKey("FightLv"))
            {
                int.TryParse(dic["FightLv"], out mChallengeLv);
            }

            if(dic.ContainsKey("DlgId"))
            {
                int.TryParse(dic["DlgId"], out mDlgId);
            }

            if(dic.ContainsKey("BattleBgm"))
            {
                mBattleBgm = dic["BattleBgm"].Trim();
            }

            if(dic.ContainsKey("Monsters"))
            {
                string tempStr =  dic["Monsters"];
                string[] strList = StringUtil.split(tempStr, ';');
                if(strList!=null)
                {
                    mMonsters = new List<ActorData>();
                    for (int idx =0; idx < strList.Length;idx++)
                    {
                        int[] intVals = StringUtil.split2Int(strList[idx], ':');
                        if(intVals != null && intVals.Length >= 2)
                        {
                            int loc = intVals[0];
                            int monsterId = intVals[1];
                            if(loc>=1 && loc<=6 && monsterId > 0)
                            {
                                ActorData ad = ActorData.CreateNpcPlayerActor(MapId, LevelId, loc, monsterId, 1);
                                ad.PositionValue = loc;
                                mMonsters.Add(ad);
                            }
                        }
                    }
                }
            }

            bValid = true;
        }
    }

    void InitMonsterData()
    {
        if (!bValid) return;


        if(bossId > 0)
        {
            int baseId = bossId / 1000;
            int bossLv = bossId - baseId * 1000;
            mBossActor = ActorData.CreateNpcPlayerActor(MapId, LevelId, bossPos, baseId, bossLv);
            mBossActor.IsBoss = true;
            mBossActor.PositionValue = bossPos;
            mBossActor.RageId = this.rageId;
        }  
    }

    public int CompareTo(LevelItem other)
    {
        return this.LevelId - other.LevelId;
    }

    public bool UnLocked()
    {
        return true;
    }

    public void Dispose()
    {
		if (mbDisposed)
			return;

		mbDisposed = true;
    }
}
