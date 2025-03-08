using UnityEngine;
using System.Collections;
using System;

/// <summary>
/// 神秘数字
/// </summary>
public struct CrypticInt32
{
    private int hiddenValue;
    private int _Decrypt;

    private int fakeValue;
    private bool inited;

    public CrypticInt32(int nValue)
    {
        hiddenValue = nValue;
        fakeValue = 0;
        _Decrypt = 0;
        inited = true;
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
            hiddenValue = Encrypt(0, out _Decrypt);
            fakeValue = 0;
            inited = true;
        }

        int decrypted = Decrypt(hiddenValue, _Decrypt);

        if (DataCheatingDetector.IsRunning && fakeValue != 0 && decrypted != fakeValue)
            DataCheatingDetector.Instance.OnCheatingDetected();

        return decrypted;
    }


    public static implicit operator CrypticInt32(int nValue)
    {
        int decrypt = 0;
        CrypticInt32 obscured = new CrypticInt32(Encrypt(nValue, out decrypt));

        if (DataCheatingDetector.IsRunning)
        {
            obscured.fakeValue = nValue;
        }
        obscured._Decrypt = decrypt;

        return obscured;
    }

    public static implicit operator int(CrypticInt32 inData)
    {
        return inData.InternalDecrypt();
    }

    public static explicit operator UInt32(CrypticInt32 inData)
    {
        return (UInt32)inData.InternalDecrypt();
    }

    public static explicit operator UInt16(CrypticInt32 inData)
    {
        return (UInt16)inData.InternalDecrypt();
    }

    public override bool Equals(object obj)
    {
        return (obj != null && this.GetType() == obj.GetType() && ((int)this == (int)((CrypticInt32)obj)));
    }


    public int ToInt()
    {
        return (int)this;
    }

    public uint ToUint()
    {
        return (uint)this;
    }

    public override string ToString()
    {
        return ToInt().ToString();
    }

    public string ToUintString()
    {
        return ToUint().ToString();
    }
}