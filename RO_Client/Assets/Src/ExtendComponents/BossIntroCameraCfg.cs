using UnityEngine;
using System.Collections;
using System;
using UnityEngine.Rendering.PostProcessing;

public class BossIntroCameraCfg : MonoBehaviour
{
    [Serializable]
    public struct ShowBossCam
    {
        public Transform cam;
        public float duration;
    }

    public ShowBossCam[] Cams;
    public Vector3 bossInitPos;
    public float enableShakeTime;

    public Vector3 pos;
    public Vector3 rot;

    public float magnitude = 1; //振幅
    public float roughness = 1; //频率

    public float keepTime = 1;

    int curCamIdx = 0;
    private bool begined = false;
    private float beginTime = 0;
    private float showTime = 0;

    int timer = 0;
    GameObject bossIntroGo = null;
    Animator bossAnimator = null;
    PostProcessLayer ppLayer;
    
    private void Awake()
    {
    }

    private void Start()
    {
        bossIntroGo = GameObject.Find("bossintro");
        if(bossIntroGo != null)
        {
            bossAnimator = bossIntroGo.GetComponent<Animator>();
            if (bossAnimator != null)
                bossAnimator.enabled = true;
        }
        bossIntroGo.gameObject.SetActive(false);

        //ppLayer = this.GetComponentInChildren<PostProcessLayer>();
        //if (ppLayer != null)
        //{
        //    ppLayer.enabled = false;
        //}
    }

    void Update()
    {
        if (!begined || Cams == null) return;

        float passedTime = Time.realtimeSinceStartup - beginTime;
        if (passedTime >= showTime)
        {
            if (curCamIdx < Cams.Length-1)
            {
                Cams[curCamIdx].cam.SetSafeActive(false);
                curCamIdx++;
                PlayCam();            
            }
        }
    }

    public void Begin()
    {
        curCamIdx = 0;
        showTime = 0;
        beginTime = Time.realtimeSinceStartup;
        PlayCam();
        begined = true;
        bossIntroGo.gameObject.SetActive(true);
        if(enableShakeTime > 0)
        {
            timer =  TimerManager.Instance.AddTimer((int)(enableShakeTime * 1000), 1, OnStartShake);
        }

    }

    public void Stop()
    {
        TimerManager.Instance.RemoveTimer(timer);
        begined = false;
        StopCam();
        bossIntroGo.gameObject.SetActive(false);
        //if (ppLayer != null)
        //{
        //    ppLayer.enabled = false;
        //}
    }

    void OnStartShake(int seq)
    {
        AddCameraShake();
        if (Cams[curCamIdx].cam != null)
        {
            Cams[curCamIdx].cam.GetComponent<Animator>().enabled = false;
        }
    }

    void StopCam()
    {
        if (Cams != null)
        {
            for (int idx = 0; idx < Cams.Length; idx++)
            {
                Cams[idx].cam.gameObject.SetSafeActive(false);
            }
        }
    }

    void PlayCam()
    {
        ShowBossCam bossCam = Cams[curCamIdx];
        showTime += bossCam.duration;
        bossCam.cam.SetSafeActive(false);
        bossCam.cam.GetComponent<Animator>().enabled = true;
        bossCam.cam.SetSafeActive(true);
    }

    public void AddCameraShake()
    {
        CameraShakeInstance c = CameraShaker.Instance.ShakeOnce(magnitude, roughness, 0, keepTime);
        c.PositionInfluence = pos;
        c.RotationInfluence = rot;
    }
}
