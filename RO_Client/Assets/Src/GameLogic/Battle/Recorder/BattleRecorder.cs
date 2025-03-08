using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;

public struct RecordParamFighterSpawn
{
	public long mFighterId;
	public int mTeamSide;
	public Vector3 mPosition;
	public Vector3 mForward;
	public Vector3 mRotation;

	public RecordParamFighterSpawn(long fighterId, int teamSide, Vector3 position, Vector3 forward, Vector3 rot)
	{
		mFighterId = fighterId;
		mPosition = position;
		mForward = forward;
		mRotation = rot;
		mTeamSide = teamSide;
	}

	public RecordParamFighterSpawn(JSONObject json)
	{
		mFighterId = json[0].l;
		mTeamSide = (int)json[1].n;
		mPosition = BattleRecorder.Vector3FromJson(json[2]);
		mForward = BattleRecorder.Vector3FromJson(json[3]);
		mRotation = BattleRecorder.Vector3FromJson(json[4]);
	}

	public JSONObject ToJson()
	{
		JSONObject json = new JSONObject();
		json.Add(mFighterId);
		json.Add(mTeamSide);
		json.Add(BattleRecorder.Vector3ToJson(mPosition));
		json.Add(BattleRecorder.Vector3ToJson(mForward));
		json.Add(BattleRecorder.Vector3ToJson(mRotation));
		return json;
	}
}

public struct RecordParamFighterSkill
{
	public long mFighterId;
	public int mTeamSide;
	public int mSkillType;
	public int mSkillId;

	public RecordParamFighterSkill(long fighterId, int teamSide, int skillType, int skillId)
	{
		mFighterId = fighterId;
		mTeamSide = teamSide;
		mSkillType = skillType;
		mSkillId = skillId;
	}

	public RecordParamFighterSkill(JSONObject json)
	{
		mFighterId = json[0].l;
		mTeamSide = (int)json[1].n;
		mSkillType = (int)json[2].n;
		mSkillId = (int)json[3].n;
	}

	public JSONObject ToJson()
	{
		JSONObject json = new JSONObject();
		json.Add(mFighterId);
		json.Add(mTeamSide);
		json.Add(mSkillType);
		json.Add(mSkillId);
		return json;
	}
}

public struct RecordParamFighterPassiveSkill
{
	public long mFighterId;
	public int mTeamSide;
	public int mSkillId;

	public RecordParamFighterPassiveSkill(long fighterId, int teamSide, int skillId)
	{
		mFighterId = fighterId;
		mTeamSide = teamSide;
		mSkillId = skillId;
	}

	public RecordParamFighterPassiveSkill(JSONObject json)
	{
		mFighterId = json[0].l;
		mTeamSide = (int)json[1].n;
		mSkillId = (int)json[2].n;
	}

	public JSONObject ToJson()
	{
		JSONObject json = new JSONObject();
		json.Add(mFighterId);
		json.Add(mTeamSide);
		json.Add(mSkillId);
		return json;
	}
}

public struct RecordParamFighterStartFighting
{
	public long mFighterId;
	public int mTeamSide;

	public RecordParamFighterStartFighting(long fighterId, int teamSide)
	{
		mFighterId = fighterId;
		mTeamSide = teamSide;
	}

	public RecordParamFighterStartFighting(JSONObject json)
	{
		mFighterId = json[0].l;
		mTeamSide = (int)json[1].n;
	}

	public JSONObject ToJson()
	{
		JSONObject json = new JSONObject();
		json.Add(mFighterId);
		json.Add(mTeamSide);
		return json;
	}
}

public struct RecordParamFighterMove
{
	public long mFighterId;
	public int mTeamSide;
	public long mTargetId;
	public int mTargetTeamSide;
	public float mStopDist;

	public RecordParamFighterMove(long fighterId, int teamSide, long targetIdx, int targetTeamSide, float stopDist)
	{
		mFighterId = fighterId;
		mTeamSide = teamSide;
		mTargetId = targetIdx;
		mTargetTeamSide = targetTeamSide;
		mStopDist = stopDist;
	}

	public RecordParamFighterMove(JSONObject json)
	{
		mFighterId = json[0].l;
		mTeamSide = (int)json[1].n;
		mTargetId = json[2].l;
		mTargetTeamSide = (int)json[3].n;
		mStopDist = json[4].f;
	}

	public JSONObject ToJson()
	{
		JSONObject json = new JSONObject();
		json.Add(mFighterId);
		json.Add(mTeamSide);
		json.Add(mTargetId);
		json.Add(mTargetTeamSide);
		json.Add(mStopDist);
		return json;
	}
}

public struct RecordParamFighterSkillData
{
	public int mSkillId;
	public float mCastingTime;
	public long mActorId;
	public int mActorBaseId;
	public int mTeamSide;
	public List<stDamageParam> mDamages;

	public RecordParamFighterSkillData(int skillId,float castingTime,long actorId,int actorBaseId,int teamSide, List<stDamageParam> damages)
	{
		this.mSkillId = skillId;
		this.mCastingTime = castingTime;
		this.mActorId = actorId;
		this.mActorBaseId = actorBaseId;
		this.mTeamSide = teamSide;
		this.mDamages = damages;
	}
}

public struct RecordActorParam
{
	public int uid;
	public int baseId;
	public int teamSide;
	public int life;
	public int sp;

	public RecordActorParam(int id, int bId, int team, int life, int sp)
	{
		this.uid = id;
		this.baseId = bId;
		this.teamSide = team;
		this.life = life;
		this.sp = sp;
	}
}

public class BattleRecorder
{
	public static JSONObject Vector3ToJson(Vector3 v, float multiply = 1e3f)
	{
		JSONObject json = new JSONObject();
		json.Add((int)(v.x * multiply));
		json.Add((int)(v.y * multiply));
		json.Add((int)(v.z * multiply));
		return json;
	}

	public static Vector3 Vector3FromJson(JSONObject json, float multiply = 1e-3f)
	{
		return new Vector3(json[0].n * multiply, json[1].n * multiply, json[2].n * multiply);
	}

	public static JSONObject ColorToJson(Color clr)
	{
		JSONObject json = new JSONObject();
		json.Add((int)clr.r * 255);
		json.Add((int)clr.g * 255);
		json.Add((int)clr.b * 255);
		json.Add((int)clr.a * 255);
		return json;
	}

	public static Color ColorFromJson(JSONObject json)
	{
		float multipy = 1.0f / 255;
		return new Color(json[0].n * multipy, json[1].n * multipy, json[2].n * multipy, json[3].n * multipy);
	}

	public static JSONObject Vector2ToJson(Vector2 v, float multiply = 1e3f)
	{
		JSONObject json = new JSONObject();
		json.Add((int)(v.x * multiply));
		json.Add((int)(v.y * multiply));
		return json;
	}

	public static Vector2 Vector2FromJson(JSONObject json, float multiply = 1e-3f)
	{
		return new Vector2(json[0].n * multiply, json[1].n * multiply);
	}

	static List<int> mFullRecData;
    static int mFullRecCompIdx;

    public static bool EnableFullRecCompare = false;

    public static int LastErrorIndex = -1;

	public enum RecordType
	{
		FighterSpawn = 0,
		FighterStartFighting = 1,
		FighterSkill = 2,
		FighterMove = 3,
		BattleEnd = 4,
		FighterPassiveSkill = 5,
	}

	public class Record
	{
		public int mFieldState;
		public int mStateFrame;
		public RecordType mRecordType;
		public object mParams;

		public Record(BaseBattle battle, RecordType recType, object param)
		{
			mFieldState = battle.CurBattleField == null ? 0 : battle.CurBattleField.CurrentFieldState;
			if(recType == RecordType.FighterSpawn)
			{
				mStateFrame = 0;
			}
			else
			{
				mStateFrame = battle.CurBattleField == null ? battle.FrameCount : battle.CurBattleField.CurrentStateFrame;
			}
			
			mRecordType = recType;
			mParams = param;
		}

		public Record(JSONObject json)
		{
			int tmpIdx = 0;
			mFieldState = (int)json[tmpIdx++].n;
			mStateFrame = (int)json[tmpIdx++].n;
			mRecordType = (RecordType)(int)json[tmpIdx++].n;
			JSONObject paramJson = json[tmpIdx++];
			switch (mRecordType)
			{
				case RecordType.FighterSpawn:
					mParams = new RecordParamFighterSpawn(paramJson);
					break;
				case RecordType.FighterStartFighting:
					mParams = new RecordParamFighterStartFighting(paramJson);
					break;
				case RecordType.FighterSkill:
					mParams = new RecordParamFighterSkill(paramJson);
					break;
				case RecordType.FighterPassiveSkill:
					mParams = new RecordParamFighterPassiveSkill(paramJson);
					break;
				case RecordType.FighterMove:
					mParams = new RecordParamFighterMove(paramJson);
					break;
				case RecordType.BattleEnd:
					int[] lifeArray = new int[paramJson.Count];
					for (int i = 0; i < lifeArray.Length; i++)
						lifeArray[i] = (int)paramJson[i].n;
					mParams = lifeArray;
					break;
			}
		}

		public JSONObject ToJson()
		{
			JSONObject json = new JSONObject();
			json.Add(mFieldState);
			json.Add(mStateFrame);
			json.Add((int)mRecordType);
			switch (mRecordType)
			{
				case RecordType.FighterSpawn:
					json.Add(((RecordParamFighterSpawn)mParams).ToJson());
					break;
				case RecordType.FighterStartFighting:
					json.Add(((RecordParamFighterStartFighting)mParams).ToJson());
					break;
				case RecordType.FighterSkill:
					json.Add(((RecordParamFighterSkill)mParams).ToJson());
					break;
				case RecordType.FighterPassiveSkill:
					json.Add(((RecordParamFighterPassiveSkill)mParams).ToJson());
					break;
				case RecordType.FighterMove:
					json.Add(((RecordParamFighterMove)mParams).ToJson());
					break;
				case RecordType.BattleEnd:
					JSONObject lifesJson = new JSONObject();
					int[] lifeArray = (int[])mParams;
					for (int i = 0; i < lifeArray.Length; i++)
						lifesJson.Add(lifeArray[i]);
					json.Add(lifesJson);
					break;
			}
			return json;
		}
	}

	private int mMapId = 0;
	private int mLevelId = 0;
	private int mBattleMode = 0;
	private int mBattleSubMode = 0;
	private BaseBattle mBattle;
	private List<Record> mRecords;
	private int mNextRecordIdx; 
    private List<ActorData> mLeftActors;
	private List<ActorData> mRightActors;

    //检测录像错误超时
    const int nCheckReplayErrorTime = 5;
    int nCurrReplayErrorTime = -1;
    bool bIsReplayError = false;

    public bool ResultCode { get; private set; }

	public int ReplayResultCode { get; private set; }

	public int Seed { get; set; }

	public ValType[] Factors { get; set; }

	public bool SwapReplay { get; set; }

	public int MapId
	{
		get { return mMapId; }
	}

	public int LevelId
	{
		get { return mLevelId; }
	}

	public int BattleMode
	{
		get { return mBattleMode; }
	}

	public int BattleSubMode
	{
		get { return mBattleSubMode; }
	}


	private string recordStr;

	public string RecordStr
	{
		get { return recordStr; }
	}

	public List<ActorData> LeftActors
	{
		get { return mLeftActors; }
	}

	public List<ActorData> RightActors
	{
		get { return mRightActors; }
	}

    private List<RecordParamFighterSkillData> mSkillHitRecords = new List<RecordParamFighterSkillData>();
	public List<RecordParamFighterSkillData> SkillHitRecords
	{
		get { return mSkillHitRecords; }
	}

	public BattleRecorder(JSONObject json)
	{
		if(json.HasField("result"))
		{
			ResultCode = json.GetField("result").b;
		}

		if(json.HasField("mapId"))
		{
			mMapId = (int)json.GetField("mapId").n;
		}

		if(json.HasField("levelId"))
		{
			mLevelId = (int)json.GetField("levelId").n;
		}

		if(json.HasField("mode"))
		{
			mBattleMode = (int)json.GetField("mode").n;
		}

		if(json.HasField("subMode"))
		{
			mBattleSubMode = (int)json.GetField("subMode").n;
		}
		
		if (json.HasField("seed"))
		{
			Seed = (int)json.GetField("seed").n;
		}

		if(json.HasField("factors"))
		{
			JSONObject factorsJson = json.GetField("factors");     
			if(factorsJson.isContainer)
            {
                Factors = new ValType[factorsJson.Count];
                for (int idx = 0; idx < factorsJson.Count; idx++)
                {
                    JSONObject factorJson = factorsJson[idx];
                    int id = (int)factorJson.GetField("id").n;
                    int val = (int)factorJson.GetField("val").n;
                    Factors[idx] = new ValType(id, val);
                }
            }
		}

		mLeftActors = new List<ActorData>();
		mRightActors = new List<ActorData>();
		if (json.HasField("actors"))
		{
			JSONObject obj = json.GetField("actors");
			if(obj.HasField("LA"))
			{
				JSONObject leftActorsJson = obj.GetField("LA");
				for(int idx = 0;idx < leftActorsJson.Count;idx++)
				{
					ActorData actor = ActorData.CreateActorFromJson(leftActorsJson[idx]);
					if(actor!=null)
					{
						actor.IsRecordActor = true;
                        actor.IsMainRole = false;   //此处一定要加 录像模式 否则会把现有主角的模型替换（IsMainRole会引用一个模型OBJ）
                        mLeftActors.Add(actor);
					}
				}
			}

			if(obj.HasField("RA"))
			{
				JSONObject rightActorsJson = obj.GetField("RA");
				for (int idx = 0; idx < rightActorsJson.Count; idx++)
				{
					ActorData actor = ActorData.CreateActorFromJson(rightActorsJson[idx]);
                    if (actor != null)
                    {
                        actor.IsMainRole = false;
                        mRightActors.Add(actor);
                    }
				}
			}

			for(int idx =0; idx < mLeftActors.Count;idx++)
			{
				var actor = mLeftActors[idx];
				if(actor.IsFellow || actor.IsHero)
				{
					if(actor.PetId > 0)
					{
						var petActor = GetActorById(actor.PetId, 0);
						actor.SetPet(petActor);
					}
				}
			}

			for(int idx =0; idx < mRightActors.Count;idx++)
			{
				var actor = mRightActors[idx];
				if (actor.IsFellow || actor.IsHero)
				{
					if (actor.PetId > 0)
					{
						var petActor = GetActorById(actor.PetId, 1);
						actor.SetPet(petActor);
					}
				}
			}
		}

		if(json.HasField("records"))
		{
			JSONObject recordsJson = json.GetField("records");
			mRecords = new List<Record>();
			for (int i = 0; i < recordsJson.Count; i++)
				mRecords.Add(new Record(recordsJson[i]));
		}
	}

    public void SetLeftHeroName(string strName)
    {
        for (int idx = 0; idx < mLeftActors.Count; idx++)
        {
            var actor = mLeftActors[idx];
            if (actor.IsHero)
            {
                actor.Name = strName;
            }
        }
    }

    public BattleRecorder(BaseBattle battle)
	{
		mBattle = battle;
		mBattleMode = (int)mBattle.Mode;
		mBattleSubMode = (int)mBattle.SubBattleMode;
		if (mBattle.IsNormalBattle)
		{
			mMapId = battle.CurBattleField.BattleInfo.MapId;
			mLevelId = battle.CurBattleField.BattleInfo.LevelId;
		}	
		Seed = battle.RandSeed;
		Factors = battle.Factors;

		mRecords = new List<Record>();

		mLeftActors = new List<ActorData>();
		mRightActors = new List<ActorData>();

		mLeftActors.AddRange(mBattle.CurBattleField.TeamActors);
		mRightActors.Clear();
        bIsReplayError = false;
        nCurrReplayErrorTime = -1;
    }

	public void ResetToPlayRecord(BaseBattle battle)
	{
		mBattle = battle;
		mNextRecordIdx = 0;
        bIsReplayError = false;
        nCurrReplayErrorTime = -1;
    }

    //检测录像错误
    public void CheckErrorRecord(bool bIsProcessOk)
    {        
        //if (BattleMgr.Instance.GetLeftFightingTime() <= 0.0f)
        //{           
        //    return;
        //}
        if (bIsProcessOk)
        {
            nCurrReplayErrorTime = (int)Time.realtimeSinceStartup;
            return;
        }
        if (nCurrReplayErrorTime == -1)
            return;
        if (mBattle.IsPlayRecord && !bIsReplayError)
        {          
            int nTime = (int)Time.realtimeSinceStartup - nCurrReplayErrorTime;            
            if (nTime >= nCheckReplayErrorTime)//长时间 执行失败 退出战斗
            {
                nCurrReplayErrorTime = -1;
                //弹窗 退出战斗
                bIsReplayError = true;
                //录像错误框
                ShowErrorMsgBox();
            }         
        }
    }

	public int ProcessFrameRecord(RecordType expectedRecType, Fighter expectFighter = null)
	{
		int state = mBattle.CurBattleField.CurrentFieldState;
		int stateFrame = mBattle.CurBattleField.CurrentStateFrame;
		int cnt = 0;
		//DebugHelper.LogError(string.Format("<color=#00ffff>{0} -----ProcessFrameRecord ---- stateFrame = {1} mNextRecordIdx={2}</color>", state, stateFrame, mNextRecordIdx));
		while (mNextRecordIdx < mRecords.Count)
		{
			Record rec = mRecords[mNextRecordIdx];
			if (rec.mFieldState > state)
			{
                //DebugHelper.LogError("11:" + expectedRecType + " -- " + rec.mStateFrame + " 不同:" + stateFrame + " mNextRecordIdx = " + mNextRecordIdx);
                CheckErrorRecord(false);
                return cnt;
			}
			if (rec.mFieldState == state && rec.mStateFrame > stateFrame)
			{
                //DebugHelper.LogError("22:" + expectedRecType + " -- " + rec.mStateFrame + " 不同:" + stateFrame + " mNextRecordIdx = " + mNextRecordIdx);
                CheckErrorRecord(false);
                return cnt;
			}
			if (rec.mRecordType != expectedRecType)
			{
                //DebugHelper.LogError("33:" + rec.mRecordType + " -- " + expectedRecType + " 不同:" + stateFrame + " mNextRecordIdx = " + mNextRecordIdx);
                CheckErrorRecord(false);
                return cnt;
			}
            bool bIsok = ProcessRecord(rec, expectFighter);
            CheckErrorRecord(bIsok);
            if (!bIsok)
			{                
                //DebugHelper.LogError("44: ProcessRecord 失败:"+ expectedRecType+"  " + stateFrame + " mNextRecordIdx = " + mNextRecordIdx);
                return cnt;
			}
			else
			{	
				//DebugHelper.LogError(string.Format("<color=#ff0000>{0} srcFrame= {1} currentFrame={2} mNextRecordIdx={3}</color>", expectedRecType, rec.mStateFrame, stateFrame, mNextRecordIdx));
			}
			cnt++;
			mNextRecordIdx++;
		}
		return cnt;
	}

	public void RecordFighterSpawn(Fighter fighter)
	{
		if(fighter.TeamSide == eTeamType.Friend)
		{
			if (!mLeftActors.Contains(fighter.Actor))
			{
				mLeftActors.Add(fighter.Actor);
			}
		}
		else if(fighter.TeamSide == eTeamType.Enemy)
		{
			if (!mRightActors.Contains(fighter.Actor))
			{
				mRightActors.Add(fighter.Actor);
			}
		}

		mRecords.Add(new Record(mBattle, RecordType.FighterSpawn, new RecordParamFighterSpawn(fighter.Id, (int) fighter.TeamSide, fighter.Position, fighter.Forward,fighter.Ctrl.transform.rotation.eulerAngles)));
	}

	public void RecordFighterStartFighting(Fighter fighter)
	{
		mRecords.Add(new Record(mBattle, RecordType.FighterStartFighting, new RecordParamFighterStartFighting(fighter.Id, (int)fighter.TeamSide)));
	}

	public void RecordFighterSkill(Fighter fighter, int skillType,int skillId)
	{
		mRecords.Add(new Record(mBattle, RecordType.FighterSkill, new RecordParamFighterSkill(fighter.Id, (int)fighter.TeamSide, skillType, skillId)));
	}

	public void RecordFighterPassiveSkill(Fighter fighter,int skillId)
	{
		mRecords.Add(new Record(mBattle, RecordType.FighterPassiveSkill, new RecordParamFighterPassiveSkill(fighter.Id, (int)fighter.TeamSide, skillId)));
	}

	public void RecordFighterMove(Fighter fighter, Fighter target,float stopDist)
	{
		mRecords.Add(new Record(mBattle, RecordType.FighterMove, new RecordParamFighterMove(fighter.Id, (int)fighter.TeamSide, target.Id, (int)target.TeamSide,stopDist)));
	}

	public void RecordFighterSkillData(int skillId,float castingTime,long actorId,int actorBaseId,int teamSide,List<stDamageParam> damages)
	{
		RecordParamFighterSkillData data = new RecordParamFighterSkillData(skillId,castingTime,actorId,actorBaseId,teamSide, damages);
		mSkillHitRecords.Add(data);
	}

	public void RecordBattleEnd(bool win)
	{
		List<Fighter> allFigher = mBattle.FighterMgr.AllFighters;

		int leftLifeTotal = 0;
		int rightLifeTotal = 0;

		int[] lifeArray = new int[mLeftActors.Count + mRightActors.Count];
		for (int i = 0; i < mLeftActors.Count; i++)
		{
			Fighter fighter = allFigher.Find(a => a.Actor == mLeftActors[i]);
			if (fighter != null)
			{
				lifeArray[i] = fighter.Life;
				leftLifeTotal += fighter.Life;
			}
		}


		for (int i = 0; i < mRightActors.Count; i++)
		{
			Fighter fighter = allFigher.Find(a => a.Actor == mRightActors[i]);
			if (fighter != null)
			{
				lifeArray[i + mLeftActors.Count] = fighter.Life;
				rightLifeTotal += fighter.Life;
			}
		}

		ResultCode = win;

		mRecords.Add(new Record(mBattle, RecordType.BattleEnd, lifeArray));
		recordStr = CompressionUtil.Compress(ToJson().ToString());
		//BattleSimulator.SaveBattleRecorder(recordStr);
	}

	public JSONObject ToJson()
	{
		JSONObject json = new JSONObject();
		json.AddField("result",ResultCode);
		json.AddField("mapId",mMapId);
		json.AddField("levelId", mLevelId);
		json.AddField("mode", mBattleMode);
		json.AddField("subMode", mBattleSubMode);
		json.AddField("seed",Seed);

		JSONObject factorsJson = new JSONObject();
		if(Factors!=null && Factors.Length > 0)
		{
			for(int idx =0; idx < Factors.Length;idx++)
			{
				JSONObject factorJson = new JSONObject();
				factorJson.AddField("id", Factors[idx].id);
				factorJson.AddField("val", Factors[idx].val);
				factorsJson.Add(factorJson);
			}
		}
		json.AddField("factors", factorsJson);


		JSONObject actorsJson = new JSONObject();
		JSONObject leftActorsJson = new JSONObject();
		for(int idx =0; idx < mBattle.CurBattleField.TeamFighters.Count;idx++)
		{
			Fighter f = mBattle.CurBattleField.TeamFighters[idx];
			leftActorsJson.Add(f.RecordJson);
		}
		actorsJson.AddField("LA", leftActorsJson);


		JSONObject rightActorsJson = new JSONObject();
		for (int idx =0; idx < mBattle.CurBattleField.EnemyFighters.Count;idx++)
		{
			Fighter f = mBattle.CurBattleField.EnemyFighters[idx];
			rightActorsJson.Add(f.RecordJson);
		}
		actorsJson.AddField("RA", rightActorsJson);
		json.AddField("actors",actorsJson);

		JSONObject recordsJson = new JSONObject();
		for (int i = 0; i < mRecords.Count; i++)
			recordsJson.Add(mRecords[i].ToJson());
		json.AddField("records",recordsJson);
		return json;
	}

	public void Skip()
	{
		if (mNextRecordIdx >= mRecords.Count || mRecords.Count == 0)
			return;

		Record lastRec = mRecords[mRecords.Count - 1];
		if (lastRec.mRecordType != RecordType.BattleEnd)
			return;
		int[] lifeArray = (int[])lastRec.mParams;
		List<Fighter> allFigher = mBattle.FighterMgr.AllFighters;
		int leftAliveCount = 0;
		for (int i = 0; i < mLeftActors.Count; i++)
		{
			Fighter fighter = allFigher.Find(a => a.Actor == mLeftActors[i]);
			if (fighter != null && fighter.IsSpawned && !fighter.IsDisposed && fighter.IsAlive)
			{
				fighter.ForceIdle();
				fighter.StateData.BuffMgr.Clear();
				//fighter.Life = lifeArray[i];
				//if (fighter.IsAlive)
				//	leftAliveCount++;
			}
		}

		int rightAliveCount = 0;
		for (int i = 0; i < mRightActors.Count; i++)
		{
			Fighter fighter = allFigher.Find(a => a.Actor == mRightActors[i]);
			int idx = i + mLeftActors.Count;
			if (fighter != null && fighter.IsSpawned && !fighter.IsDisposed && fighter.IsAlive)
			{
				fighter.ForceIdle();
				fighter.StateData.BuffMgr.Clear();
				//fighter.Life = lifeArray[idx];
				//if (fighter.IsAlive)
				//	rightAliveCount++;
			}
		}

		if (mBattle.CurBattleField != null &&
		    (mBattle.CurBattleField.IsFightingState || 
			mBattle.CurBattleField.IsIdleState))
			mBattle.CurBattleField.PeaceEnd();
	}

	Fighter GetFighterById(long id,int teamSide)
	{
		ActorData actor = null;
		if (teamSide == 0)
		{
			for(int idx =0; idx < mLeftActors.Count;idx++)
			{
				if(mLeftActors[idx].ID == id)
				{
					actor = mLeftActors[idx];
					break;
				}
			}
		}
		else
		{
			for(int idx =0; idx < mRightActors.Count;idx++)
			{
				if(mRightActors[idx].ID == id)
				{
					actor = mRightActors[idx];
					break;
				}
			}
		}

		if (actor == null) 
			return null;

		return mBattle.FighterMgr.GetFighterByID(actor.ID, (eTeamType)teamSide);
	}

	ActorData GetActorById(long id, int teamSide)
	{
		if(teamSide == 0)
		{
			if (mLeftActors == null) return null;
			for(int idx =0; idx < mLeftActors.Count;idx++)
			{
				if(mLeftActors[idx].ID == id)
				{
					return mLeftActors[idx];
				}
			}
		}
		else
		{
			if (mRightActors == null) return null;

			for(int idx =0; idx < mRightActors.Count;idx++)
			{
				if (mRightActors[idx].ID == id)
					return mRightActors[idx];
			}
		}
		return null;
	}

	bool ProcessRecord(Record rec, object expectFighter)
	{
		switch (rec.mRecordType)
		{
			case RecordType.FighterSpawn:
				{
					RecordParamFighterSpawn param = (RecordParamFighterSpawn)rec.mParams;
					Fighter fighter = GetFighterById(param.mFighterId,param.mTeamSide);
					if (expectFighter != null && fighter != expectFighter)
						return false;

					if (fighter == null) return false;

					if (fighter.IsSpawned)
					{
						DebugHelper.Log("invalid fighter state!");
						return false;
					}

					fighter.Spawn(param.mPosition, param.mForward, Quaternion.Euler(param.mRotation));
				}
				break;
			case RecordType.FighterStartFighting:
				{
					RecordParamFighterStartFighting param = (RecordParamFighterStartFighting)rec.mParams;
					Fighter fighter = GetFighterById(param.mFighterId,param.mTeamSide);
                    if (null == fighter ||
                      !fighter.IsAlive ||
                      !fighter.IsSpawned ||
                      fighter.IsDisposed ||
                      fighter.Actor.IsDisposed)
                    {
                        DebugHelper.LogError("invalid fighter state! random value {0}", Seed);
                        return true;//角色无效跳过
                    }

                    if (expectFighter != null && fighter != expectFighter)
						return false;
                    
					if (!fighter.IsAlive || fighter.IsFighting)
					{
						
						return false;
					}
					fighter.OnFightingStart();
				}
				break;
			case RecordType.FighterSkill:
				{
					RecordParamFighterSkill param = (RecordParamFighterSkill)rec.mParams;
					Fighter fighter = GetFighterById(param.mFighterId, param.mTeamSide);
                    if (null == fighter ||
                        !fighter.IsAlive ||
                        !fighter.IsSpawned ||
                        fighter.IsDisposed ||  
                        fighter.Actor.IsDisposed)
                    {
                        return true;//角色无效跳过
                    }
                    if (expectFighter != null && fighter != expectFighter)
						return false;
                    
					fighter.ForceDoSkill(param.mSkillType, param.mSkillId);
				}
				break;
			case RecordType.FighterPassiveSkill:
				{
					RecordParamFighterPassiveSkill param = (RecordParamFighterPassiveSkill)rec.mParams;
					Fighter fighter = GetFighterById(param.mFighterId, param.mTeamSide);
                    if (null == fighter ||
                     !fighter.IsAlive ||
                     !fighter.IsSpawned ||
                     fighter.IsDisposed ||
                     fighter.Actor.IsDisposed)
                    {
                        return true;//角色无效跳过
                    }

                    if (expectFighter != null && fighter != expectFighter)
						return false;
                    
					fighter.DoPassiveSkill(param.mSkillId);
				}
				break;
			case RecordType.FighterMove:
				{
					RecordParamFighterMove param = (RecordParamFighterMove)rec.mParams;
					Fighter fighter = GetFighterById(param.mFighterId, param.mTeamSide);
					Fighter target = GetFighterById(param.mTargetId, param.mTargetTeamSide);

					if (target == null)
					{
						DebugHelper.LogError("FighterMove 目标不存在");
						return true;
					}

					if (expectFighter != null && fighter != expectFighter)
					{
						//DebugHelper.LogError("FighterMove 执行者 不存在");
						return false;
					}

					if (fighter == null) return true;
					
					bool ret = fighter.AutoChaseTo(target, param.mStopDist);
				}
				break;
		}
		return true;
	}

	public void CalculateReplayResult()
	{
		List<Fighter> allFigher = mBattle.FighterMgr.AllFighters;
		int leftLifeTotal = 0;
		int rightLifeTotal = 0;

		int[] lifeArray = new int[mLeftActors.Count + mRightActors.Count];
		for (int i = 0; i < mLeftActors.Count; i++)
		{
			Fighter fighter = allFigher.Find(a => a.Actor == mLeftActors[i]);
			if (fighter != null)
			{
				lifeArray[i] = fighter.Life;
				leftLifeTotal += fighter.Life;
			}
		}

		for (int i = 0; i < mRightActors.Count; i++)
		{
			Fighter fighter = allFigher.Find(a => a.Actor == mRightActors[i]);
			if (fighter != null)
			{
				lifeArray[i + mLeftActors.Count] = fighter.Life;
				rightLifeTotal += fighter.Life;
				//				Log.D ("  team {0}, actor {1}, life {2}", fighter.Id, fighter.TeamSide, fighter.Life);
			}
		}

		ReplayResultCode = (leftLifeTotal - rightLifeTotal) % 100000;
		DebugHelper.Log(string.Format("result code:{0}, replay result code:{1}", ResultCode, ReplayResultCode));
	}

    private void ShowErrorMsgBox()
    {
        LuaInterface.LuaState pLuaState = LuaMgr.GetMainState();
        if (null != pLuaState)
        {            
            string strLuaOpen = "ManagerContainer.LuaBattleMgr:ShowErrorQuitBattleMsgBox()";
            LuaMgr.GetMainState().DoString(strLuaOpen);
        }
    }

    private void CloseErrorMsgBox()
    {
        LuaInterface.LuaState pLuaState = LuaMgr.GetMainState();
        if (null != pLuaState)
        {            
            string strLuaClose = "ManagerContainer.LuaBattleMgr:CloseErrorQuitBattleMsgBox()";
            LuaMgr.GetMainState().DoString(strLuaClose);
        }
    }
}
