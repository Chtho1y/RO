using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public sealed class GoAxis
{
	public const int Forward = 1;
	public const int Up = 2;
	public const int Right = 3;
	public const int InverseForward = 4;
	public const int InverseUp = 5;
	public const int InverseRight = 6;
}

public class FighterSkillRotateWeapon : MonoBehaviour
{
	public string nodeName;
	public Transform lookAt;
	public float speed;
	public int upAxis;
	public int forwardAxis;

	void Start ()
	{
	}

	void Update ()
	{
	}

	void OnDisable()
	{
	}
}