using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIParticleHelper : MonoBehaviour
{

    public int AddSortingNum = 0;

    ParticleSystem[] pSystems;
    Renderer[] pRenderers;
    // Start is called before the first frame update
    void Start()
    {
        pSystems = GetComponentsInChildren<ParticleSystem>();
        pRenderers = GetComponentsInChildren<Renderer>();
    }

    public void Init(int baseSortingOrder)
    {
        if (pSystems == null)
            pSystems = GetComponentsInChildren<ParticleSystem>();
        if (pRenderers == null)
            pRenderers = GetComponentsInChildren<Renderer>();

        foreach (var renderer in pRenderers)
        {
            renderer.sortingOrder += baseSortingOrder + AddSortingNum;
        }
    }

    public void OnDestroy()
    {
        pSystems = null;
        pRenderers = null;
    }

    public void Update()
    {
        if (pSystems == null) return;

        bool isPlaying = false;
        foreach(var system in pSystems)
        {
            if (system.isPlaying)
            {
                isPlaying = true;
                return;
            }
        }

        if (!isPlaying)
        {
            gameObject.SetActive(false);
        }
    }

    public void StartPlayParticle()
    {
        gameObject.SetActive(true);
    }
}
