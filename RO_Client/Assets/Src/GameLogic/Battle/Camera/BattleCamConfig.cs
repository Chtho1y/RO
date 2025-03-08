using UnityEngine;
using System.Collections;

public class BattleCamConfig : MonoBehaviour
{
    public float speedRate = 1;
    public float offsetDist = 2;

    public Vector3 followCamOffset = new Vector3(0, 0, 0);
    public Vector3 batttleCamOffset = new Vector3(0, 0, 0);
    public Vector3 rotateCamOffset = new Vector3(0, 6, 0);

    public float followCameraFov = 75;

    public float battleCameraFov = 75;

    public float bossCameraFov = 75;

    public float followDist = 15;

    public float CamMoveSpeed = 30;

    public float CamRotSpeed = 30;

    public float CamFovSpeed = 30;

    public float CamMoveSpeedInBattle = 20;

    public float CamRotSpeedInBattle = 20;

    public float BossCamPosChangeTime = 0.25f;

    public float BossCamRotChangeTime = 0.25f;

    public float ManualRotateMoveSpeed = 60;

    float bInitCamMoveSpeed;
    private void Start()
    {
        bInitCamMoveSpeed = CamMoveSpeed;
    }

    public void ChangeMoveSpeed(float speed)
    {
        CamMoveSpeed = speed;
    }

    public void RestoreMoveSpeed()
    {
        CamMoveSpeed = bInitCamMoveSpeed;
    }
}
