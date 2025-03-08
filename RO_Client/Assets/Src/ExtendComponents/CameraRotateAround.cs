using UnityEngine;  
using System.Collections;  

/** 
 
 * 备注：本脚本必须赋予主镜头 
 
 */  
public class CameraRotateAround : MonoBehaviour
{
    public Transform target;//主相机要围绕其旋转的物体  

    public float distance = 7.0f;//主相机与目标物体之间的距离  

    public float xSpeed = 70.0f;//主相机水平方向旋转速度  

    public float minAngleX = -15;
    public float maxAngleX = 15;

    public Vector3 offset;

    private bool rotated = false;

    private float eulerAngles_x;

    private float eulerAngles_y;

    private float initAngleX = 0;
    private float minAngle = 0;
    private float maxAngle = 0;
    private float movedAngle = 0;
    private Vector3 dir;

    void LateUpdate()
    {
        if (rotated)
        {
            movedAngle += ((Input.GetAxis("Mouse X") * this.xSpeed) * this.distance) * 0.02f;
            if(movedAngle <= minAngle)
            {
                movedAngle = minAngle;
            }else if(movedAngle >= maxAngle)
            {
                movedAngle = maxAngle;
            }

            Quaternion quaternion = Quaternion.Euler(0, movedAngle, 0);
            Vector3 vector = ((Vector3)(quaternion * this.offset)) + BattleMgr.Instance.Battle.TeamCenter;

            this.transform.rotation = Quaternion.Euler(this.eulerAngles_y, movedAngle + initAngleX, 0);
            this.transform.position = vector;

            //this.eulerAngles_x += ((Input.GetAxis("Mouse X") * this.xSpeed) * this.distance) * 0.02f;

            //Quaternion quaternion = Quaternion.Euler(0, this.eulerAngles_x - initAngleX,0);
            //Vector3 vector = ((Vector3)(quaternion * this.offset)) + BattleMgr.Instance.Battle.TeamCenter;

            //this.transform.rotation = Quaternion.Euler(this.eulerAngles_y, this.eulerAngles_x,0);
            //this.transform.position = vector;
        }
    }

    public void StartRotate()
    {
        if (this.target == null) return;

        Vector3 eulerAngles = this.transform.eulerAngles;//当前物体的欧拉角  
        this.eulerAngles_x = eulerAngles.y;
        this.eulerAngles_y = eulerAngles.x;
        minAngle = this.minAngleX + this.target.eulerAngles.y;
        maxAngle = this.maxAngleX + this.target.eulerAngles.y;
        initAngleX = this.eulerAngles_x;
        movedAngle = 0;

        rotated = true;

        dir = new Vector3(0, 0, 1);
        this.offset = this.transform.position - BattleMgr.Instance.Battle.TeamCenter;
    }

    public void StopRotate()
    {
        rotated = false;
    }
}
