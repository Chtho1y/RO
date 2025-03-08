using UnityEngine;
using System.Collections;

public class UnscaleTimePartical : MonoBehaviour {

    ParticleSystem ps;

    void Start()
    {
        ps = GetComponent<ParticleSystem>();
    }

    void Update()
    {
        if (ps != null)
        {
            ps.Simulate(Time.unscaledDeltaTime, true, false);
        }
    }
}
