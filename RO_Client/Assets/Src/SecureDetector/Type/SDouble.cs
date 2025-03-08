using System;
using UnityEngine;
using System.Runtime.InteropServices;

[Serializable]
public struct SDouble : IEquatable<SDouble>, IFormattable
{
    [StructLayout(LayoutKind.Explicit)]
    private struct DoubleLongBytesUnion
    {
        [FieldOffset(0)]
        public double d;

        [FieldOffset(0)]
        public long l;

        [FieldOffset(0)]
        public byte b1;

        [FieldOffset(1)]
        public byte b2;

        [FieldOffset(2)]
        public byte b3;

        [FieldOffset(3)]
        public byte b4;

        [FieldOffset(4)]
        public byte b5;

        [FieldOffset(5)]
        public byte b6;

        [FieldOffset(6)]
        public byte b7;

        [FieldOffset(7)]
        public byte b8;
    }

    [SerializeField]
    private byte[] hiddenValue;

    [SerializeField]
    private double fakeValue;

    [SerializeField]
    private bool inited;

    private int _Decrypt;

    private SDouble(byte[] value)
    {
        hiddenValue = value;
        fakeValue = 0;
        _Decrypt = 0;
        inited = true;
    }

    public static SDouble Convert(double val)
    {
        return (SDouble)val;
    }

    public static long Encrypt(double value,out int decrypt)
    {
        var u = new DoubleLongBytesUnion();
        u.d = value;
        u.l = SLong.Encrypt(u.l, out decrypt);

        return u.l;
    }

    public static double Decrypt(long value,int decrypt)
    {
        var u = new DoubleLongBytesUnion();
        u.l = SLong.Decrypt(value,decrypt);
        return u.d;
    }

    static byte[] InternalEncrypt(double value,out int decrypt)
    {
        var u = new DoubleLongBytesUnion();
        u.d = value;
        u.l = SLong.Encrypt(u.l,out decrypt);

        return new[] { u.b1, u.b2, u.b3, u.b4, u.b5, u.b6, u.b7, u.b8 };
    }

    private double InternalDecrypt()
    {
        if (!inited)
        {
            hiddenValue = InternalEncrypt(0,out _Decrypt);
            fakeValue = 0;
            inited = true;
        }

        var union = new DoubleLongBytesUnion();
        union.b1 = hiddenValue[0];
        union.b2 = hiddenValue[1];
        union.b3 = hiddenValue[2];
        union.b4 = hiddenValue[3];
        union.b5 = hiddenValue[4];
        union.b6 = hiddenValue[5];
        union.b7 = hiddenValue[6];
        union.b8 = hiddenValue[7];

        union.l = SLong.Decrypt(union.l,_Decrypt);

        double decrypted = union.d;

        if (DataCheatingDetector.IsRunning && fakeValue != 0 && Math.Abs(decrypted - fakeValue) > 0.000001d)
        {
            DataCheatingDetector.Instance.OnCheatingDetected();
        }

        return decrypted;
    }

    #region operators, overrides, interface implementations
    //! @cond
    public static implicit operator SDouble(double value)
    {
        int decrypt = 0;
        SDouble obscured = new SDouble(InternalEncrypt(value,out decrypt));
        obscured._Decrypt = decrypt;

        if (DataCheatingDetector.IsRunning)
        {
            obscured.fakeValue = value;
        }

        return obscured;
    }

    public static implicit operator double (SDouble value)
    {
        return value.InternalDecrypt();
    }

    public static SDouble operator ++(SDouble input)
    {
        int decrypt = 0;
        double decrypted = input.InternalDecrypt() + 1d;
        input.hiddenValue = InternalEncrypt(decrypted,out decrypt);
        input._Decrypt = decrypt;

        if (DataCheatingDetector.IsRunning)
        {
            input.fakeValue = decrypted;
        }

        return input;
    }

    public static SDouble operator --(SDouble input)
    {
        int decrypt = 0;
        double decrypted = input.InternalDecrypt() - 1d;
        input.hiddenValue = InternalEncrypt(decrypted,out decrypt);
        input._Decrypt = decrypt;

        if (DataCheatingDetector.IsRunning)
        {
            input.fakeValue = decrypted;
        }

        return input;
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

    public override bool Equals(object obj)
    {
        if (!(obj is SDouble))
            return false;
        return Equals((SDouble)obj);
    }

    public bool Equals(SDouble obj)
    {
        return obj.InternalDecrypt().Equals(InternalDecrypt());
    }

    public override int GetHashCode()
    {
        return InternalDecrypt().GetHashCode();
    }
    #endregion
}