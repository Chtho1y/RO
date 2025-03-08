using UnityEngine;
using System.Collections;

public static class SDataUtil
{
    public static bool IsLess(int a,int b)
    {
        return a < b;
    }

    public static bool IsLess(int a,SInt b)
    {
        return a < b;
    }

    public static bool IsLess(SInt a, int b)
    {
        return a < b;
    }

    public static bool IsLess(SInt a, SInt b)
    {
        return a < b;
    }

    public static bool IsLessEqual(int a, int b)
    {
        return a <= b;
    }

    public static bool IsLessEqual(int a, SInt b)
    {
        return a <= b;
    }

    public static bool IsLessEqual(SInt a, int b)
    {
        return a <= b;
    }

    public static bool IsLessEqual(SInt a, SInt b)
    {
        return a <= b;
    }

    public static bool IsGreater(int a,int b)
    {
        return a > b;
    }

    public static bool IsGreater(float a, float b)
    {
        return a > b;
    }

    public static bool IsGreater(int a, float b)
    {
        return a > b;
    }

    public static bool IsGreater(float a, int b)
    {
        return a > b;
    }

    public static bool IsGreater(SFloat a, int b)
    {
        return a > b;
    }

    public static bool IsGreater(int a, SFloat b)
    {
        return a > b;
    }

    public static bool IsGreater(SFloat a, SFloat b)
    {
        return a > b;
    }

    public static bool IsGreater(SInt a, SFloat b)
    {
        return a > b;
    }

    public static bool IsGreater(SFloat a, SInt b)
    {
        return a > b;
    }

    public static bool IsGreater(int a, SInt b)
    {
        return a > b;
    }

    public static bool IsGreater(SInt a, int b)
    {
        return a > b;
    }

    public static bool IsGreater(SInt a, SInt b)
    {
        return a > b;
    }

    public static bool IsGreaterEqual(int a,int b)
    {
        return a >= b;
    }

    public static bool IsGreaterEqual(SInt a, int b)
    {
        return a >= b;
    }

    public static bool IsGreaterEqual(int a, SInt b)
    {
        return a >= b;
    }

    public static bool IsGreaterEqual(SInt a, SInt b)
    {
        return a >= b;
    }

    public static bool IsEqual(int a, int b)
    {
        return a == b;
    }

    public static bool IsEqual(int a, SInt b)
    {
        return a == b;
    }

    public static bool IsEqual(SInt a, int b)
    {
        return a == b;
    }

    public static bool IsEqual(SInt a, SInt b)
    {
        return a == b;
    }

    public static SInt Add(int a, int b)
    {
        return a + b;
    }

    public static SInt Add(int a, SInt b)
    {
        return a + b;
    }


    public static SInt Add(SInt a, SInt b)
    {
        return a + b;
    }

    public static SInt Add(SInt a, int b)
    {
        return a + b;
    }

    public static SFloat Add(SFloat a, int b)
    {
        return a + b;
    }

    public static SFloat Add(SFloat a, float b)
    {
        return a + b;
    }

    public static SFloat Add(SFloat a, SInt b)
    {
        return a + b;
    }

    public static SFloat Add(SFloat a, SFloat b)
    {
        return a + b;
    }

    public static SInt Sub(int a, int b)
    {
        return a - b;
    }

    public static SInt Sub(SInt a, int b)
    {
        return a - b;
    }

    public static SInt Sub(SInt a, SInt b)
    {
        return a - b;
    }

    public static SFloat Sub(SFloat a, int b)
    {
        return a - b;
    }

    public static SFloat Sub(SFloat a, SInt b)
    {
        return a - b;
    }

    public static SFloat Sub(SFloat a, float b)
    {
        return a - b;
    }

    public static SFloat Sub(SFloat a, SFloat b)
    {
        return a - b;
    }

    public static SInt Multiply(SInt a, int b)
    {
        return a * b;
    }

    public static SInt Multiply(SInt a, SInt b)
    {
        return a * b;
    }

    public static SFloat Multiply(SFloat a, int b)
    {
        return a * b;
    }

    public static SFloat Multiply(SFloat a, SInt b)
    {
        return a * b;
    }

    public static SFloat Multiply(SFloat a, float b)
    {
        return a * b;
    }

    public static SFloat Multiply(SFloat a, SFloat b)
    {
        return a * b;
    }

    public static SInt Div(SInt a, int b)
    {

        if (b == 0) return a;

        return a / b;
    }

    public static SInt Div(SInt a, SInt b)
    {
        if (b == 0) return a;

        return a / b;
    }

    public static SFloat Div(SFloat a, int b)
    {
        if (b == 0) return a;

        return a / b;
    }

    public static SFloat Div(SFloat a, SInt b)
    {
        if (b == 0) return a;

        return a / b;
    }

    public static SFloat Div(SFloat a , float b)
    {
        if (b == 0) return a;

        return a / b;
    }

    public static SFloat Div(SFloat a, SFloat b)
    {
        if (b == 0) return a;

        return a / b;
    }

    public static SInt InverseDiv(SInt a,int b)
    {
        if (a == 0) return b;

        return b / a;
    }

    public static SFloat InverseDiv(SFloat a, int b)
    {
        if (a == 0) return b;


        return b / a;
    }

    public static SFloat InverseDiv(SFloat a, float b)
    {
        if (a == 0) return b;


        return b / a;
    }

    public static SInt IsMax(SInt a, int b)
    {
        if(a >= b)
        {
            return a;
        }
        else
        {
            return b;
        }
    }

    public static SInt IsMax(int a, SInt b)
    {
        if (a >= b)
        {
            return a;
        }
        else
        {
            return b;
        }
    }

    public static SInt IsMax(int a, int b)
    {
        if (a >= b)
        {
            return a;
        }
        else
        {
            return b;
        }
    }

    public static SInt IsMax(SInt a, SInt b)
    {
        if (a >= b)
        {
            return a;
        }
        else
        {
            return b;
        }
    }

    public static int InvConvert(SInt a)
    {
        return SInt.InvConvert(a);
    }

    public static float InvConvert(SFloat b)
    {
        return SFloat.InvConvert(b);
    }

    public static int InvConvert(int a)
    {
        return a;
    }

    public static float InvConvert(float b)
    {
        return b;
    }

    public static double InvConvertDouble(SFloat b)
    {
        float value = SFloat.InvConvert(b);
        return InvConvertDouble(value);
    }

    public static double InvConvertDouble(float b)
    {
        double value = b;
        double.TryParse(b.ToString(), out value);
        return value;
    }
}
