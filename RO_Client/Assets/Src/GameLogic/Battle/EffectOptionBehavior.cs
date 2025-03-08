using UnityEngine;
using System.Collections;

public class EffectOptionBehavior : MonoBehaviour
{
	public Effect Effect { get; set; }
	EffectOption mOption;

	void Start()
	{
		mOption = GetComponent<EffectOption> ();
	}

	void OnDisable()
	{
		Effect = null;
	}

	void Update()
	{
		if (Effect != null && mOption != null) {
			if (mOption.forceGround)
				UpdateGround ();
		}
	}

	void UpdateGround()
	{
		if (Effect.FollowType == EffectFollowType.Effect_Follow_Self && Effect.OwnerFighter != null)
			transform.position = transform.position.SetY (Effect.OwnerFighter.FloorY);
		else if (Effect.FollowType == EffectFollowType.Effect_Follow_Target && Effect.TargetFighter != null)
			transform.position = transform.position.SetY (Effect.TargetFighter.FloorY);
	}
}
