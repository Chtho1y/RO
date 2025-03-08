using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public static class SceneEventCtl
{
    public static Ray ray;
    public static RaycastHit hit;
    public static float updateTimeDown, updateTimeUp;
    public static Vector3 originPos = Vector3.zero;


    private static Vector3 s_downMousePos = Vector3.zero;
    private static bool s_mouseDown = false;

    public static bool s_enableSceneEvent = false;
    public static bool s_dragged = false;
    public static float timeDown, timeUp;

    public static bool GetRaycastHit(Camera cam, int layerMask,ref RaycastHit hit_, bool ifPlay = true)
    {

        if (Input.GetMouseButtonDown(0))
            timeDown = Time.time;

        if (Input.GetMouseButtonUp(0))
        {
            timeUp = Time.time;

            if (timeUp - timeDown > 0.2)
            {
                return false;
            }

            Ray ray = cam.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;
            if (Physics.Raycast(ray, out hit, 100, layerMask, QueryTriggerInteraction.Collide))
            {
                hit_ = hit;
                return true;
            }
        }
        return false;
    }

    public static bool UpdateRaycastHit(Camera cam, int layerMask)
    {
        if (Input.GetMouseButtonDown(0))
        {
            s_mouseDown = true;
            s_dragged = false;
            updateTimeDown = Time.time;
            s_downMousePos = Input.mousePosition;
        }

        if (s_mouseDown && !s_dragged && Vector3.Distance(Input.mousePosition, s_downMousePos) >= 5.0f)
        {
            s_dragged = true;
        }

        if (Input.GetMouseButtonUp(0) && !s_dragged)
        {
            s_mouseDown = false;
            ray = cam.ScreenPointToRay(Input.mousePosition);
            if (Physics.Raycast(ray, out hit, 100, layerMask,QueryTriggerInteraction.Collide))
            {
                return true;
            }
        }
        return false;
    }
}
