using System;
using UnityEngine;
using System.Runtime.InteropServices;

[Serializable]
public struct SFloat : IEquatable<SFloat>, IFormattable
{
    [StructLayout(LayoutKind.Explicit)]
    private struct FloatIntBytesUnion
    {
        [FieldOffset(0)]
        public float f;

        [FieldOffset(0)]
        public int i;

        [FieldOffset(0)]
        public byte b1;

        [FieldOffset(1)]
        public byte b2;

        [FieldOffset(2)]
        public byte b3;

        [FieldOffset(3)]
        public byte b4;
    }

    [SerializeField]
    private byte[] hiddenValue;

    [SerializeField]
    private float fakeValue;

    [SerializeField]
    private bool inited;

    private int _Decrypt;

    private SFloat(byte[] value)
    {
        hiddenValue = value;
        fakeValue = 0;
        _Decrypt = 0;
        inited = true;
    }

    public static SFloat Convert(float fVal)
    {
        return (SFloat)fVal;
    }

    public static float InvConvert(SFloat val)
    {
        return val;
    }

    public static int Encrypt(float value,out int decrypt)
    {
        var u = new FloatIntBytesUnion();
        u.f = value;
        u.i = SInt.Encrypt(u.i, out decrypt);

        return u.i;
    }

    public static float Decrypt(int value, int decrypt)
    {
        var u = new FloatIntBytesUnion();
        u.i = SInt.Decrypt(value,decrypt);
        return u.f;
    }

    static byte[] InternalEncrypt(float value, out int decrypt)
    {
        var u = new FloatIntBytesUnion();
        u.f = value;
        u.i =  SInt.Encrypt(u.i,out decrypt);

        return new[] { u.b1, u.b2, u.b3, u.b4 };
    }

    private float InternalDecrypt()
    {
        if (!inited)
        {
            hiddenValue = InternalEncrypt(0,out _Decrypt);
            fakeValue = 0;
            inited = true;
        }

        var union = new FloatIntBytesUnion();
        union.b1 = hiddenValue[0];
        union.b2 = hiddenValue[1];
        union.b3 = hiddenValue[2];
        union.b4 = hiddenValue[3];

        union.i = SInt.Decrypt(union.i,_Decrypt);

        float decrypted = union.f;

        if (DataCheatingDetector.IsRunning && fakeValue != 0 && Math.Abs(decrypted - fakeValue) > DataCheatingDetector.Instance.floatEpsilon)
        {
            DataCheatingDetector.Instance.OnCheatingDetected();
        }

        return decrypted;
    }

    #region operators, overrides, interface implementations
    public static implicit operator SFloat(float value)
    {
        int decrypt = 0;
        SFloat obscured = new SFloat(InternalEncrypt(value,out decrypt));
        obscured._Decrypt = decrypt;

        if (DataCheatingDetector.IsRunning)
        {
            obscured.fakeValue = value;
        }

        return obscured;
    }

    public static implicit operator float (SFloat value)
    {
        return value.InternalDecrypt();
    }

    public static SFloat operator ++(SFloat input)
    {
        int decrypt = 0;
        float decrypted = input.InternalDecrypt() + 1f;
        input.hiddenValue = InternalEncrypt(decrypted,out decrypt);
        input._Decrypt = decrypt;

        if (DataCheatingDetector.IsRunning)
        {
            input.fakeValue = decrypted;
        }

        return input;
    }

    public static SFloat operator --(SFloat input)
    {
        int decrypt = 0;
        float decrypted = input.InternalDecrypt() - 1f;
        input.hiddenValue = InternalEncrypt(decrypted,out decrypt);
        input._Decrypt = decrypt;

        if (DataCheatingDetector.IsRunning)
        {
            input.fakeValue = decrypted;
        }

        return input;
    }

    public override bool Equals(object obj)
    {
        if (!(obj is SFloat))
            return false;
        return Equals((SFloat)obj);
    }

    public bool Equals(SFloat obj)
    {
        double dParam = obj.InternalDecrypt();
        double dThis = InternalDecrypt();

        return dParam.Equals(dThis);
    }

    public override int GetHashCode()
    {
        return InternalDecrypt().GetHashCode();
    }

    public override string ToString()
    {
        return InternalDecrypt().ToString();
    }

    public string ToString(string format)
    {
        return InternalDecrypt().ToString(format);
    }

    public string ToString(IFormatProvider provider)
    {
        return InternalDecrypt().ToString(provider);
    }

    public string ToString(string format, IFormatProvider provider)
    {
        return InternalDecrypt().ToString(format, provider);
    }
    #endregion
}
