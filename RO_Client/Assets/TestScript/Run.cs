using UnityEngine;
using System.Collections;

public class Run : MonoBehaviour
{
    public float moveSpeed;

    Animator animtor;
    Vector3 moveDir = Vector3.zero;
    KeyCode curKeyCode = KeyCode.W;
    float intervalTime = 0;
    // Use this for initialization
    void Start()
    {
        animtor = GetComponent<Animator>();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.W))
        {
            curKeyCode = KeyCode.W;
            moveDir = Vector3.forward;
            this.transform.localRotation = Quaternion.Euler(0,0,0);
            if(animtor!=null)
                animtor.Play("f_run_1");
        }
        else if (Input.GetKeyDown(KeyCode.S))
        {
            curKeyCode = KeyCode.S;
            moveDir = Vector3.back;
            this.transform.localRotation = Quaternion.Euler(0,180,0);
            if (animtor != null)
                animtor.Play("f_run_1");
        }
        else if (Input.GetKeyDown(KeyCode.A))
        {
            curKeyCode = KeyCode.A;
            moveDir = Vector3.left;
            this.transform.localRotation = Quaternion.Euler(0, 270, 0);
            if (animtor != null)
                animtor.Play("f_run_1");
        }   
        else if (Input.GetKeyDown(KeyCode.D))
        {
            curKeyCode = KeyCode.D;
            moveDir = Vector3.right;
            this.transform.localRotation = Quaternion.Euler(0, 90, 0);

            if (animtor != null)
                animtor.Play("f_run_1");
        }

        if (Input.GetKeyUp(curKeyCode))
        {
            if (animtor != null)
                animtor.Play("f_idle");
            moveDir = Vector3.zero;
        }

        intervalTime -= Time.deltaTime;
        this.transform.localPosition += moveDir * moveSpeed;
    }
}
