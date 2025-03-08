using UnityEngine;
using System.Collections;
using System.IO;

public static class BattleSimulator
{
	public static void TestRecord()
	{
		//TextAsset ta = UnityEditor.AssetDatabase.LoadAssetAtPath<TextAsset>("Assets/Content/Test/records.txt");
		//if (ta == null) return;

		//string recordContent = CompressionUtil.UnCompress(ta.text);

		//DebugHelper.LogError(recordContent);
		//JSONObject json = JSONObject.Create(recordContent);
		//BattleRecorder battleRecord = new BattleRecorder(json);
		//BattleMgr.Instance.Replay(battleRecord);
	}

	public static void SaveBattleRecorder(string battleRecorder)
	{
		if (battleRecorder == null) return;

		string dir = Application.dataPath + "/Content/Test";
		if (!System.IO.Directory.Exists(dir))
			System.IO.Directory.CreateDirectory(dir);

		string filePath = Application.dataPath + "/Content/Test/records.txt";

		FileStream fs = new FileStream(filePath, FileMode.Create);
		string recorderStr = battleRecorder;
		byte[] buff = System.Text.Encoding.Default.GetBytes(recorderStr);
		fs.Write(buff, 0, buff.Length);
		fs.Flush();
		fs.Close();
	}

	public static void SaveSkillDataRecorder(JSONObject recorder)
	{
		if (recorder == null) return;

		string filePath = Application.dataPath + "/Content/Test/skilldata.txt";

		FileStream fs = new FileStream(filePath, FileMode.Create);
		string recorderStr = recorder.Print(true);
		byte[] buff = System.Text.Encoding.Default.GetBytes(recorderStr);
		fs.Write(buff, 0, buff.Length);
		fs.Flush();
		fs.Close();
	}


	public static int ReplayBattle(BattleRecorder recorder)
	{
		//LogicBattle battle = new LogicBattle(recorder, true);
		//battle.Start();
		//while (battle.CurrentState != LogicBattleStateType.End)
		//{
		//	battle.Update(BattleMgr.c_targetFrameTime);
		//	if (battle.FrameCount > 5400)
		//	{
		//		DebugHelper.LogError("simulate error!");
		//		break;
		//	}
		//}
		//return recorder.ReplayResultCode;
		return 0;
	}
}
