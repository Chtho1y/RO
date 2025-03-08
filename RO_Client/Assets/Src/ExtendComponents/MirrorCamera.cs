using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class MirrorCamera : MonoBehaviour
{
    public Camera lookCamera;
    public Transform reflectionTransform;
    public Vector3 reflectionPosition;
    public Quaternion reflectionRotation;
    public Vector3 reflectionUp;
    public float clipPlaneOffset = 0.07f;



    private Camera m_Camera;
    

    private void Awake() {
        m_Camera = GetComponent<Camera>();
    }

    private void OnPreRender() {
        GL.invertCulling = true;
        if (reflectionTransform)
        {
            ResetCamera();
        }
    }

    private void OnPostRender() {
        GL.invertCulling = false;
    }

    public void ResetCamera() {
        if (!lookCamera) return;

        Vector3 pos, normal;
        Quaternion rotation;

        if (reflectionTransform)
        {
            pos = reflectionTransform.position;
            normal = reflectionTransform.up;
            rotation = reflectionTransform.rotation;
        }
        else
        {
            pos = reflectionPosition;
            normal = reflectionUp;
            rotation = reflectionRotation;
        }

        transform.position = pos;
        transform.rotation = rotation;

        float d = -Vector3.Dot (normal, pos) - clipPlaneOffset;
		Vector4 reflectionPlane = new Vector4 (normal.x, normal.y, normal.z, d);

		Matrix4x4 reflection = Matrix4x4.zero;
		reflection = CalculateReflectionMatrix (reflection, reflectionPlane);
		Vector3 oldpos = lookCamera.transform.position;
		Vector3 newpos = reflection.MultiplyPoint( oldpos );
		m_Camera.worldToCameraMatrix = lookCamera.worldToCameraMatrix * reflection;

        // Setup oblique projection matrix so that near plane is our reflection
		// plane. This way we clip everything below/above it for free.
		Vector4 clipPlane = CameraSpacePlane( m_Camera, pos, normal, 1.0f );
		//Matrix4x4 projection = cam.projectionMatrix;
		Matrix4x4 projection = lookCamera.CalculateObliqueMatrix(clipPlane);
		m_Camera.projectionMatrix = projection;

        m_Camera.transform.position = newpos;
		Vector3 euler = lookCamera.transform.eulerAngles;
		m_Camera.transform.eulerAngles = new Vector3(0, euler.y, euler.z);
		m_Camera.transform.position = oldpos;
    }

    Vector4 CameraSpacePlane(Camera cam, Vector3 pos, Vector3 normal, float sideSign)
    {
        Vector3 offsetPos = pos + normal * clipPlaneOffset;
        Matrix4x4 m = cam.worldToCameraMatrix;
        Vector3 cpos = m.MultiplyPoint(offsetPos);
        Vector3 cnormal = m.MultiplyVector(normal).normalized * sideSign;

        return new Vector4(cnormal.x, cnormal.y, cnormal.z, -Vector3.Dot(cpos, cnormal));
    }

    static float Sgn(float a)
    {
        if (a > 0.0F)
        {
            return 1.0F;
        }
        if (a < 0.0F)
        {
            return -1.0F;
        }
        return 0.0F;
    }

    static Matrix4x4 CalculateReflectionMatrix(Matrix4x4 reflectionMat, Vector4 plane)
    {
        reflectionMat.m00 = (1F - 2F * plane[0] * plane[0]);
		reflectionMat.m01 = (   - 2F * plane[0] * plane[1]);
		reflectionMat.m02 = (   - 2F * plane[0] * plane[2]);
		reflectionMat.m03 = (   - 2F * plane[3] * plane[0]);
 
		reflectionMat.m10 = (   - 2F * plane[1] * plane[0]);
		reflectionMat.m11 = (1F - 2F * plane[1] * plane[1]);
		reflectionMat.m12 = (   - 2F * plane[1] * plane[2]);
		reflectionMat.m13 = (   - 2F * plane[3] * plane[1]);

		reflectionMat.m20 = (   - 2F * plane[2] * plane[0]);
		reflectionMat.m21 = (   - 2F * plane[2] * plane[1]);
		reflectionMat.m22 = (1F - 2F * plane[2] * plane[2]);
		reflectionMat.m23 = (   - 2F * plane[3] * plane[2]);
 
		reflectionMat.m30 = 0F;
		reflectionMat.m31 = 0F;
		reflectionMat.m32 = 0F;
		reflectionMat.m33 = 1F;

        return reflectionMat;
    }
}
