using UnityEngine;
using System.Collections;

public class UnscaleTimeEffect : MonoBehaviour {
   
	// Use this for initialization
	void Start () {
        ParticleSystem[] pss = GetComponentsInChildren<ParticleSystem>(true);
        for (int i = 0; i < pss.Length; i++)
        {
            UnscaleTimePartical utp = pss[i].gameObject.GetComponent<UnscaleTimePartical>();
            if (utp == null)
                utp = pss[i].gameObject.AddComponent<UnscaleTimePartical>();
        }

        Animator[] animators = GetComponentsInChildren<Animator>(true);
        for (int i = 0; i < animators.Length; i++)
        {
            animators[i].updateMode = AnimatorUpdateMode.UnscaledTime;
        }
	}	
}
