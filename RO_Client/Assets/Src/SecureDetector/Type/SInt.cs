using System;
using UnityEngine;

[Serializable]
public struct SInt : IEquatable<SInt>, IFormattable
{
    [SerializeField]
    private int hiddenValue;

    [SerializeField]
    private int fakeValue;

    [SerializeField]
    private bool inited;

    private int _Decrypt;

    private SInt(int value)
    {
        hiddenValue = value;
        fakeValue = 0;
        _Decrypt = 0;
        inited = true;
    }

    public static SInt Convert(int iVal)
    {
        return (SInt)iVal;
    }

    public static int InvConvert(SInt val)
    {
        return val;
    }

    public static int Encrypt(int value, out int decrypt)
    {
        decrypt = GameMgr.RandSeed;
        return value ^ decrypt;
    }

    public static int Decrypt(int value, int decrypt)
    {
        return value ^ decrypt;
    }

    int InternalDecrypt()
    {
        if (!inited)
        {
            hiddenValue = Encrypt(0,out _Decrypt);
            fakeValue = 0;
            inited = true;
        }

        int decrypted = Decrypt(hiddenValue,_Decrypt);

        if (DataCheatingDetector.IsRunning && fakeValue != 0 && decrypted != fakeValue)
            DataCheatingDetector.Instance.OnCheatingDetected();

        return decrypted;
    }

    #region operators,overrides,interface implementations
    public static implicit operator SInt(CrypticInt32 value)
    {
        int decrypt = 0;
        SInt obscured = new SInt(Encrypt((int)value, out decrypt));

        if (DataCheatingDetector.IsRunning)
        {
            obscured.fakeValue = value;
        }
        obscured._Decrypt = decrypt;

        return obscured;
    }

    public static implicit operator SInt(int value)
    {
        int decrypt = 0;
        SInt obscured = new SInt(Encrypt(value,out decrypt));

        if (DataCheatingDetector.IsRunning)
        { 
            obscured.fakeValue = value;
        }
        obscured._Decrypt = decrypt;

        return obscured;
    }

    public static implicit operator int(SInt value)
    {
        return value.InternalDecrypt();
    }

    public static implicit operator uint(SInt value)
    {
        return (uint)value.InternalDecrypt();
    }

    public static implicit operator SFloat(SInt value)
    {
        return value.InternalDecrypt();
    }

    public static implicit operator float(SInt value)
    {
        return (float)value.InternalDecrypt();
    }

    public static implicit operator SDouble(SInt value)
    {
        return value.InternalDecrypt();
    }

    public static explicit operator UInt16(SInt value)
    {
        return (UInt16)value.InternalDecrypt();
    }

    public static SInt operator ++(SInt input)
    {
        int decrypt = 0;
        int decrypted = input.InternalDecrypt() + 1;
        input.hiddenValue = Encrypt(decrypted, out decrypt);
        input._Decrypt = decrypt;

        if (DataCheatingDetector.IsRunning)
        {
            input.fakeValue = decrypted;
        }

        return input;
    }

    public static SInt operator --(SInt input)
    {
        int decrypt = 0;
        int decrypted = input.InternalDecrypt() - 1;
        input.hiddenValue = Encrypt(decrypted,out decrypt);
        input._Decrypt = decrypt;

        if (DataCheatingDetector.IsRunning)
        {
            input.fakeValue = decrypted;
        }

        return input;
    }

    public override bool Equals(object obj)
    {
        if (!(obj is SInt))
            return false;
        return Equals((SInt)obj);
    }

    public bool Equals(SInt obj)
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
