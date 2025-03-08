using UnityEngine;
using System.Collections;

public static class MathUtil
{
    public static Vector2 Lerp(this Vector2 left, Vector2 right, float lerp)
    {
        return new Vector2(Mathf.Lerp(left.x, right.x, lerp), Mathf.Lerp(left.y, right.y, lerp));
    }

    public static Vector3 Lerp(this Vector3 left, Vector3 right, float lerp)
    {
        return new Vector3(Mathf.Lerp(left.x, right.x, lerp), Mathf.Lerp(left.y, right.y, lerp), Mathf.Lerp(left.z, right.z, lerp));
    }

    public static Vector4 Lerp(this Vector4 left, Vector4 right, float lerp)
    {
        return new Vector4(Mathf.Lerp(left.x, right.x, lerp), Mathf.Lerp(left.y, right.y, lerp), Mathf.Lerp(left.z, right.z, lerp), Mathf.Lerp(left.w, right.w, lerp));
    }

    public static bool FEqual(this float f1, float f2, float compareDeviation = 1e-5f)
    {
        return Mathf.Abs(f1 - f2) <= compareDeviation;
    }

    public static bool FEqual(this Vector3 v1, Vector3 v2, float compareDeviation = 1e-5f)
    {
        return v1.x.FEqual(v2.x, compareDeviation) && v1.y.FEqual(v2.y, compareDeviation) && v1.z.FEqual(v2.z, compareDeviation);
    }

    public static bool FEqual(this Vector3 v1, Vector3 v2, Vector3 compareDeviation)
    {
        return v1.x.FEqual(v2.x, compareDeviation.x) && v1.y.FEqual(v2.y, compareDeviation.y) && v1.z.FEqual(v2.z, compareDeviation.z);
    }

    public static bool FEqualXZ(this Vector3 v1, Vector3 v2, float compareDeviation = 1e-5f)
    {
        return v1.x.FEqual(v2.x, compareDeviation) && v1.z.FEqual(v2.z, compareDeviation);
    }

    public static Vector3 SetXY(this Vector3 vector, float x, float y)
    {
        vector.x = x;
        vector.y = y;
        return vector;
    }

    public static bool CloseTo(this Vector3 v1, Vector3 v2)
    {
        return Mathf.Abs(v1.x - v2.x) < 0.001f && Mathf.Abs(v1.y - v2.y) < 0.001f && Mathf.Abs(v1.z - v2.z) < 0.001f;
    }

    public static Vector3 SetX(this Vector3 vector, float x)
    {
        vector.x = x;
        return vector;
    }

    public static Vector3 SetY(this Vector3 vector, float y)
    {
        vector.y = y;
        return vector;
    }

    public static Vector3 SetZ(this Vector3 vector, float z)
    {
        vector.z = z;
        return vector;
    }
    public static Vector2 SetX(this Vector2 vector, float x)
    {
        vector.x = x;
        return vector;
    }

    public static Vector2 SetY(this Vector2 vector, float y)
    {
        vector.y = y;
        return vector;
    }

    public static Vector3 AddXY(this Vector3 vector, Vector2 V)
    {
        return new Vector3(vector.x + V.x, vector.y + V.y, vector.z);
    }

    public static Vector3 AddXYZ(this Vector3 vector, Vector3 V)
    {
        return new Vector3(vector.x + V.x, vector.y + V.y, vector.z + V.z);
    }

    public static Vector3 AddX(this Vector3 vector, float x)
    {
        return new Vector3(vector.x + x, vector.y, vector.z);
    }

    public static Vector3 AddY(this Vector3 vector, float y)
    {
        return new Vector3(vector.x, vector.y + y, vector.z);
    }

    public static Vector3 AddZ(this Vector3 vector, float z)
    {
        return new Vector3(vector.x, vector.y, vector.z + z);
    }

    public static Vector3 Dividing(this Vector3 a, Vector3 b)
    {
        return new Vector3(a.x / b.x, a.y / b.y, a.z / b.z);
    }

    public static Vector3 Multiply(this Vector3 a, Vector3 b)
    {
        return new Vector3(a.x * b.x, a.y * b.y, a.z * b.z);
    }

    public static Vector2 Multiply(this Vector2 a, Vector2 b)
    {
        return new Vector2(a.x * b.x, a.y * b.y);
    }

    public static Vector3 AbsVector3(this Vector3 a)
    {
        return new Vector3(Mathf.Abs(a.x), Mathf.Abs(a.y), Mathf.Abs(a.z));
    }

    public static bool IsOverlap(Rect r1, Rect r2)
    {
        if (r1.x + r1.width > r2.x &&
           r2.x + r2.width > r1.x &&
           r1.y + r1.height > r2.y &&
           r2.y + r2.height > r1.y)
            return true;
        else
            return false;
    }

    public static Vector3 RotateRound(Vector3 position, Vector3 center, Vector3 axis, float angle)
    {
        Vector3 point = Quaternion.AngleAxis(angle, axis) * (position - center);
        Vector3 resultVec3 = center + point;
        return resultVec3;
    }

    //向上保留两位小数
    public static void ConverFloatRound(ref float fValue)
    {
        int nValue = (int)(fValue * 100);
        fValue += (fValue * 100) - nValue > 0.0f ? 0.01f : 0.0f;
        fValue = (int)(fValue * 100) * 0.01f;
    }
}
