using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;

public class BattlePositionConfig
{
	public Vector2[] positionInBlock = { 
		new Vector2 (0, -2.5f), 
		new Vector2 (0.375f, 0),
		new Vector2 (0.75f, 2.5f),
		new Vector2 (1.125f, -1.25f),
		new Vector2 (1.5f, 1.25f)
	};
	public float attackDistanceFront = 3.5f;
	public float attackDistanceMiddle = 6.5f;
	public float attackDistanceBack = 9.5f;
	public bool keepCenter = true;
}

public class ResourceBattlePositionConfig
{
	public Vector2[] front = { 
		new Vector2 (-2, 0), 
		new Vector2 (-1.732f, -1),
		new Vector2 (-1.732f, 1),
		new Vector2 (-1, -1.732f),
		new Vector2 (-1, 1.732f)
	};

	public Vector2[] middle = { 
		new Vector2 (-4, 0), 
		new Vector2 (-3.464f, -2),
		new Vector2 (-3.464f, 2),
		new Vector2 (-2, -3.464f),
		new Vector2 (-2, 3.464f)
	};

	public Vector2[] back = { 
		new Vector2 (-6, 0), 
		new Vector2 (-5.796f, -3),
		new Vector2 (-5.796f, 3),
		new Vector2 (-3, -5.796f),
		new Vector2 (-3, 5.796f)
	};

	public Vector2[] enemy = {
		new Vector2 (0, 0), 
		new Vector2 (0, 0), 
		new Vector2 (0, 0), 
		new Vector2 (0, 0), 
		new Vector2 (0, 0), 
	};
}

public class DropDownConfig
{
	public float downEffectSpeedThreshold = 20f;    //下落特效的速度阀值
	public int downEffect = 0;  //下落特效
	public string downSound = "";   //下落音效

	public float downFloorEffectSpeedThreshold = 20f;   //下落特效的速度阀值
	public int downFloorEffect = 0; //落地特效
	public string downFloorSound = "Audio_Ragati_Hit";  //落地音效
	public string beHurtDownFloorSound = "";

	public float shakeSpeedThreshold = 20f; //震动速度阀值
	public float shakeRate = 0.015f;    // 速度 * Scale * Rate为震动幅度
	public float shakeTime = 0.5f;      //震动时间
	public float shakeCycle = 0.2f;     //震动周期

	public float autoStartDownSpeed = 15f;      //下落初始速度
}
