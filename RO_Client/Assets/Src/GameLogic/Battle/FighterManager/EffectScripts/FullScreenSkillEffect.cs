using UnityEngine;
using System.Collections;

public class FullScreenSkillEffect : MonoBehaviour
{
	static FullScreenSkillEffect mActiveInstance;

	public static FullScreenSkillEffect ActiveInstance { get { return mActiveInstance; } }

	float time;
	float playTime;
	GameObject go;
	int avatarLayerBackup = -1;
	bool restoreAvatarMirror = false;
	bool isPlaying = false;
	FighterGoCtrl mFighterGoCtrl;
	Camera mCurrentFighterCamera;

	public Camera ActiveFighterCamera { get { return mCurrentFighterCamera; } }

	public void Play (string name, float time, bool follow, bool hideSelf, bool mirrorCamera)
	{
		go = BattlePrepareManager.Instance.GetMonsterPrefabGo (name);
		if (go == null) {
			enabled = false;
			return;
		}

		mFighterGoCtrl = gameObject.GetComponent<FighterGoCtrl> ();
		if (mFighterGoCtrl == null)
			return;

		this.time = time;

		PocHelper.SetObjectCameraMirror (go.transform, mirrorCamera, Screen.width);

		if (follow) {
			go.transform.SetParent (transform);
			go.transform.localPosition = Vector3.zero;
			go.transform.localEulerAngles = Vector3.zero;
		} else {
			go.transform.position = transform.position;
			go.transform.eulerAngles = transform.eulerAngles;
		}

		avatarLayerBackup = -1;
		restoreAvatarMirror = false;
		Transform avatar = transform.Find ("avatar");
		if (avatar != null) {
			if (hideSelf) {
				avatarLayerBackup = mFighterGoCtrl.Fighter.Layer;
				mFighterGoCtrl.Fighter.LayerName = BattleCamera.DisableLayerName;
			}	
			if (avatar.localScale.x < 0) {
				avatar.localScale = avatar.localScale.SetX (-avatar.localScale.x);
				restoreAvatarMirror = true;
			}	
			SkinnedMeshRenderer[] skinnedMeshRenderer = avatar.GetComponentsInChildren<SkinnedMeshRenderer> ();
			for (int i = 0; i < skinnedMeshRenderer.Length; i++)
				skinnedMeshRenderer [i].updateWhenOffscreen = true;
		}

		BattleMgr.Instance.DisableBattleCamera ();
		BattleCamera.CurrentEffectLayerName = BattleCamera.FighterLayerName;

		EffectManager.Instance.OnFullScreenEffectStart ();

		go.SetActive (true);
		playTime = 0;
		isPlaying = true;
		enabled = true;
		mActiveInstance = this;
		mCurrentFighterCamera = GetActiveFighterCamera ();
	}

	void Update ()
	{
		if (mCurrentFighterCamera == null ||
		    !mCurrentFighterCamera.enabled
		    || mCurrentFighterCamera.gameObject.activeInHierarchy)
			mCurrentFighterCamera = GetActiveFighterCamera ();
	}

	void FixedUpdate ()
	{
		playTime += Time.fixedDeltaTime;
		enabled &= playTime < time;
	}

	void OnDisable ()
	{
		if (isPlaying) {
			if (go != null) {
				go.transform.SetParent (null);
				go.SetActive (false);
			}
			Transform avatar = transform.Find ("avatar");
			if (avatar != null) {
				if (avatarLayerBackup >= 0 && mFighterGoCtrl != null)
					mFighterGoCtrl.Fighter.Layer = avatarLayerBackup;
				if (restoreAvatarMirror && avatar.transform.localScale.x > 0)
					avatar.transform.localScale = avatar.transform.localScale.SetX (-avatar.transform.localScale.x);
				SkinnedMeshRenderer[] skinnedMeshRenderer = avatar.GetComponentsInChildren<SkinnedMeshRenderer> ();
				for (int i = 0; i < skinnedMeshRenderer.Length; i++)
					skinnedMeshRenderer [i].updateWhenOffscreen = false;
			}

			if (BattleMgr.Instance != null && BattleMgr.Instance.Battle != null) {
				BattleMgr.Instance.EnableBattleCamera ();
				BattleCamera.CurrentEffectLayerName = BattleCamera.SceneEffectLayerName;
			}

			isPlaying = false;

			EffectManager.Instance.OnFullScreenEffectEnd ();
		}

		if (mActiveInstance == this)
			mActiveInstance = null;
	}

	Camera GetActiveFighterCamera ()
	{
		if (go == null)
			return null;
		foreach (var cam in go.GetComponentsInChildren<Camera> ())
			if (cam.gameObject.activeInHierarchy && (cam.cullingMask & LayerMask.GetMask (new [] { BattleCamera.FighterLayerName })) != 0)
				return cam;
		return null;
	}
}
