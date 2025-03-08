using UnityEngine;
using System.Collections;

public class BulletGoCtrl : MonoBehaviour
{
	public Bullet Bullet { get; set; }

   
	void Update ()
	{
        if (Bullet != null && Bullet.MoveProcessor!=null)
        {
            Bullet.FrameUpdate(Time.deltaTime);
        }
    }

	void OnDisable ()
	{
		Bullet = null;
	}

	void OnEnable()
	{
		if (Bullet != null)
        { 
			Bullet.ForceSync (transform);
        }
    }
}

