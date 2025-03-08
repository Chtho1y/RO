using System;
using UnityEngine;

[Serializable]
public struct SBool : IEquatable<SBool>
{
    [SerializeField]
    private int hiddenValue;

    [SerializeField]
    private bool fakeValue;

    [SerializeField]
    private bool fakeValueChanged;

    [SerializeField]
    private bool inited;

    private int _Decrypt;

    private SBool(int value)
    {
        hiddenValue = value;
        fakeValue = false;
        fakeValueChanged = false;
        _Decrypt = 0;
        inited = true;
    }

    public static int Encrypt(bool value,out int decrypt)
    {
        int encryptedValue = value ? 213 : 181;

        encryptedValue = SInt.Encrypt(encryptedValue,out decrypt);

        return encryptedValue;
    }

    public static bool Decrypt(int value,int decrypt)
    {
        value = SInt.Decrypt(value, decrypt);

        return value != 181;
    }

    private bool InternalDecrypt()
    {
        if (!inited)
        {
            hiddenValue = Encrypt(false,out _Decrypt);
            fakeValue = false;
            fakeValueChanged = true;
            inited = true;
        }

        int value = hiddenValue;
        value = SInt.Decrypt(value,_Decrypt);

        bool decrypted = value != 181;

        if (DataCheatingDetector.IsRunning && fakeValueChanged && decrypted != fakeValue)
        {
            DataCheatingDetector.Instance.OnCheatingDetected();
        }

        return decrypted;
    }

    #region operators, overrides, interface implementations
    //! @cond
    public static implicit operator SBool(bool value)
    {
        int decrypt = 0;
        SBool obscured = new SBool(Encrypt(value, out decrypt));
        obscured._Decrypt = decrypt;

        if (DataCheatingDetector.IsRunning)
        {
            obscured.fakeValue = value;
            obscured.fakeValueChanged = true;
        }

        return obscured;
    }

    public static implicit operator bool (SBool value)
    {
        return value.InternalDecrypt();
    }

    public override bool Equals(object obj)
    {
        if (!(obj is SBool))
            return false;
        return Equals((SBool)obj);
    }

    public bool Equals(SBool obj)
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
    #endregion
}
