using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public enum SimulateRecordType
{
	Spawn = 0,
	Run = 1,
	Jump = 2,
	Attack = 3,
	Behit = 4,
	LifeChange = 5,
	ManaChange = 6,
	RageChange = 7,
}

public class SimulateBattleInfo
{
	public class SimulateRecord
	{
		int mFighterIdx;
		int mFrame;
		SimulateRecordType mType;
		object mParam;

		public SimulateRecord (int fighterIdx, int frame, SimulateRecordType type, object param)
		{
			mFighterIdx = fighterIdx;
			mFrame = frame;
			mType = type;
			mParam = param;
		}

		public JSONObject ToJson ()
		{
			JSONObject json = new JSONObject ();
			json.Add (mFighterIdx);
			json.Add (mFrame);
			json.Add ((int)mType);
			switch (mType) {
			case SimulateRecordType.Spawn:
				JSONObject paramJson = new JSONObject ();
				paramJson.Add (Vector3ToJson ((Vector3)((object[])mParam) [0]));
				paramJson.Add (Vector3ToJson ((Vector3)((object[])mParam) [1]));
				break;
			}
			return json;
		}
	}

	public ActorData[] mLeftActors;
	public ActorData[] mRightActors;
	public int mLeftCaptainIdx = -1;
	public int mRightCaptainIdx = -1;
	public int mRandomSeed;

	List<SimulateRecord> mRecords;

	public void Record (Fighter fighter, int frame, SimulateRecordType type, object param)
	{
		if (mRecords == null)
			mRecords = new List<SimulateRecord> ();
		int fighterIdx = GetFighterIdx (fighter);
		if (fighterIdx < 0)
			return;
		mRecords.Add (new SimulateRecord (fighterIdx, frame, type, param));
	}

	public int GetFighterIdx (Fighter fighter)
	{
		if (fighter.TeamSide == eTeamType.Friend) {
			for (int i = 0; i < mLeftActors.Length; i++)
				if (mLeftActors [i] == fighter.Actor)
					return i;
		} else {
			for (int i = 0; i < mRightActors.Length; i++)
				if (mRightActors [i] == fighter.Actor)
					return mLeftActors.Length + i;
		}
		return -1;
	}

	JSONObject RecordsToJson ()
	{
		JSONObject json = new JSONObject ();
		if (mRecords == null)
			return json;
		for (int i = 0; i < mRecords.Count; i++)
			json.Add (mRecords [i].ToJson ());
		return json;
	}

	static JSONObject Vector3ToJson(Vector3 v, int intPrecise = 10000)
	{
		JSONObject json = new JSONObject ();
		json.Add (Mathf.RoundToInt(v.x * intPrecise));
		json.Add (Mathf.RoundToInt(v.y * intPrecise));
		json.Add (Mathf.RoundToInt(v.z * intPrecise));
		return json;
	}

	static Vector3 Vector3FromJson(JSONObject json, int intPrecise = 10000)
	{
		float p = 1.0f / intPrecise;
		return new Vector3 (json[0].n * p, json[1].n * p, json[2].n * p);
	}
}

