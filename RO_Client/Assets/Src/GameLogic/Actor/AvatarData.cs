using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class AvatarData
{
    public int id;
    public Vector3 bloodBarPos;
    public Vector3 skillNamePos;
    public Vector3 hurtPos;
    public Vector3 crazyPos;
    public Vector3 buffIconPos;
    public Vector3 buffTextPos;
    public Vector3 rot = Vector3.zero;
    public Vector3 offset = Vector3.zero;

    public string prefab;
    public float scale;
    public string bodyTexture;
    public string headTexture;
    public string leftWeapon;
    public string rightWeapon;
    public int[] initEffects;
    public string leftWeaponNode;
    public string rightWeaponNode;
    public string weaponTexture;
    public float modelSize;
    public float shadowScale;

    public bool valid = false;

    private bool mbDisposed = false;

    private string mIdleSound;
    private string mRunSound;
    private string mDieSound;
    private string mHitSound;

    public string IdleSound
    {
        get { return mIdleSound; }
    }

    public string RunSound
    {
        get { return mRunSound; }
    }

    public string DieSound
    {
        get { return mDieSound; }
    }

    public string HitSound
    {
        get { return mHitSound; }
    }

    public AvatarData(int id)
    {
        Dictionary<string, string> dic = ConfigMgr.Instance.getLine(id,Config.AvatarCfgName);
        if(dic==null)
        {
            DebugHelper.Log("没有找到相应的avatar配置: {0}", id);
            return;
        }

        this.id = id;
        float tempX = 0,tempY = 0;
        float.TryParse(dic["BloodBarX"], out tempX);
        float.TryParse(dic["BloodBarY"], out tempY);
        bloodBarPos = new Vector3(tempX, tempY, 0);

        float.TryParse(dic["SkillnamePosX"], out tempX);
        float.TryParse(dic["SkillnamePosY"], out tempY);
        skillNamePos = new Vector3(tempX, tempY, 0);

        float.TryParse(dic["DamagePosX"], out tempX);
        float.TryParse(dic["DamagePosY"], out tempY);
        hurtPos = new Vector3(tempX, tempY, 0);

        float.TryParse(dic["CrazyPosX"], out tempX);
        float.TryParse(dic["CrazyPosY"], out tempY);
        crazyPos = new Vector3(tempX, tempY, 0);

        if(dic.ContainsKey("BuffIconPosX"))
            float.TryParse(dic["BuffIconPosX"], out tempX);

        if(dic.ContainsKey("BuffIconPosY"))
            float.TryParse(dic["BuffIconPosY"], out tempY);
        buffIconPos = new Vector3(tempX, tempY, 0);

        if (dic.ContainsKey("BuffTextPosX"))
            float.TryParse(dic["BuffTextPosX"], out tempX);

        if (dic.ContainsKey("BuffTextPosY"))
            float.TryParse(dic["BuffTextPosY"], out tempY);
        buffTextPos = new Vector3(tempX, tempY, 0);


        prefab = dic["AvatarPrefab"];
        float.TryParse(dic["AvatarScale"], out scale);
        if(scale == 0)
        {
            scale = 1.0f;
        }

        if (dic.ContainsKey("AvatarSize"))
        {
            float.TryParse(dic["AvatarSize"], out modelSize);
        }
        else
        {
            modelSize = 0.5f;
        }

        if (dic.ContainsKey("ShadowScale"))
        {
            float.TryParse(dic["ShadowScale"], out shadowScale);
        }
        else
        {
            shadowScale = 1.0f;
        }

        if(dic.ContainsKey("Rot"))
        {
            rot = StringUtil.convertVector3(dic["Rot"]);
        }

        if(dic.ContainsKey("Offset"))
        {
            offset = StringUtil.convertVector3(dic["Offset"]);
        }

        if(dic.ContainsKey("IdleSound"))
        {
            mIdleSound = dic["IdleSound"].Trim();
        }

        if(dic.ContainsKey("RunSound"))
        {
            mRunSound = dic["RunSound"].Trim();
        }

        if(dic.ContainsKey("DieSound"))
        {
            mDieSound = dic["DieSound"].Trim();
        }

        if(dic.ContainsKey("HitSound"))
        {
            mHitSound = dic["HitSound"].Trim();
        }

        valid = true;
    }

	public void Dispose()
	{
		if (mbDisposed)
			return;

		initEffects = null;

		bodyTexture = null;
		headTexture = null;
		leftWeapon = null;
		rightWeapon = null;

		mbDisposed = true;
	}
}

