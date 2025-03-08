using System;
using UnityEngine;

[Serializable]
public struct SLong : IEquatable<SLong>, IFormattable
{
    [SerializeField]
    private long hiddenValue;

    [SerializeField]
    private long fakeValue;

    [SerializeField]
    private bool inited;

    private int _Decrypt;

    private SLong(long value)
    {
        hiddenValue = value;
        fakeValue = 0;
        _Decrypt = 0;
        inited = true;
    }

    public static long Encrypt(long value, out int decrypt)
    {
        decrypt = GameMgr.RandSeed;
        return value ^ decrypt;
    }

    public static long Decrypt(long value, int decrypt)
    {
        return value ^ decrypt;
    }

    private long InternalDecrypt()
    {
        if (!inited)
        {
            hiddenValue = Encrypt(0,out _Decrypt);
            fakeValue = 0;
            inited = true;
        }

        long decrypted = Decrypt(hiddenValue,_Decrypt);

        if (DataCheatingDetector.IsRunning && fakeValue != 0 && decrypted != fakeValue)
            DataCheatingDetector.Instance.OnCheatingDetected();

        return decrypted;
    }

    #region operators, overrides, interface implementations

    public static implicit operator SLong(long value)
    {
        int decrypt = 0;
        SLong obscured = new SLong(Encrypt(value, out decrypt));
        obscured._Decrypt = decrypt;

        if (DataCheatingDetector.IsRunning)
            obscured.fakeValue = value;

        return obscured;
    }

    public static implicit operator long (SLong value)
    {
        return value.InternalDecrypt();
    }

    public static SLong operator ++(SLong input)
    {
        int decrypt = 0;

        long decrypted = input.InternalDecrypt() + 1L;
        input.hiddenValue = Encrypt(decrypted,out decrypt);
        input._Decrypt = decrypt;

        if (DataCheatingDetector.IsRunning)
            input.fakeValue = decrypted;

        return input;
    }

    public static SLong operator --(SLong input)
    {
        int decrypt = 0;
        long decrypted = input.InternalDecrypt() - 1L;
        input.hiddenValue = Encrypt(decrypted,out decrypt);
        input._Decrypt = decrypt;

        if (DataCheatingDetector.IsRunning)
            input.fakeValue = decrypted;

        return input;
    }

    public override bool Equals(object obj)
    {
        if (!(obj is SLong))
            return false;
        return Equals((SLong)obj);
    }

    public bool Equals(SLong obj)
    {
        return Decrypt(hiddenValue,_Decrypt) == Decrypt(obj.hiddenValue,obj._Decrypt);
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