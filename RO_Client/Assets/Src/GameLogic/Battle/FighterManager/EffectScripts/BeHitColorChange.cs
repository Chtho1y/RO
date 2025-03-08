using UnityEngine;
using System.Collections;

public class BeHitColorChange : MonoBehaviour {

	public float time;
	public Color color; 

	float mPlayTime;
	SkinnedMeshRenderer[] mRenderers;
    float speed;

	// Use this for initialization
	void Start () {
		mRenderers = gameObject.GetComponentsInChildren<SkinnedMeshRenderer> ();
	}

	void OnEnable()
	{
		mPlayTime = 0;
        if(time > 0)
            speed = 0.8f / time;

        if (mRenderers == null)
			mRenderers = gameObject.GetComponentsInChildren<SkinnedMeshRenderer> ();
		if (mRenderers != null) {
			for (int i = 0; i < mRenderers.Length; i++) {
				if (mRenderers [i] != null && mRenderers [i].material != null) {
					mRenderers [i].material.SetFloat ("_Rim_Strength", 0.8f);
					mRenderers [i].material.SetColor ("_Rim_Color", color);
				}
			}
		}
	}

	void OnDisable()
	{
		if (mRenderers != null) {
			for (int i = 0; i < mRenderers.Length; i++) {
				mRenderers [i].material.SetFloat ("_Rim_Strength", 0);
                mRenderers[i].material.SetColor("_Rim_Color", Color.black);
            }
		}
	}
	
	// Update is called once per frame
	void Update () {
		mPlayTime += Time.deltaTime;	
		if (mPlayTime >= time)
        { 
			enabled = false;
        }
        else
        {
            if (mRenderers != null)
            {
                for (int i = 0; i < mRenderers.Length; i++)
                {
                    if (mRenderers[i] != null && mRenderers[i].material != null)
                    {
                        mRenderers[i].material.SetFloat("_Rim_Strength", 0.8f - speed * mPlayTime);
                    }
                }
            }
        }
	}
}
