using System;
using System.IO;
using System.Security.Cryptography;
using Org.BouncyCastle.Crypto;
using Org.BouncyCastle.Security;
using System.Text;
using UnityEngine;
using System.Collections.Generic;

public class SecurityLayer
{
    const string publicKey = @"MIGdMA0GCSqGSIb3DQEBAQUAA4GLADCBhwKBgQCNLFHMPdlOb+fZW1qzgTY+pDTRtWxYyyd3iqzIwaUe72WOsg5B/6kHIlyyqmGXRdrJVK4BzSixJ6EDmkBBX1cNLsnNo7s2+IAxpfj9EwiISyc5c8lj/N3e6f3oQqXKd+IttRZow0xBP9jupORX8rcWyhZt94msXdArTRpdE7wB1wIBAw==";
    const string privateKey = @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAI0sUcw92U5v59lbWrOBNj6kNNG1bFjLJ3eKrMjBpR7vZY6yDkH/qQciXLKqYZdF2slUrgHNKLEnoQOaQEFfVw0uyc2juzb4gDGl+P0TCIhLJzlzyWP83d7p/ehCpcp34i21FmjDTEE/2O6k5FfytxbKFm33iaxd0CtNGl0TvAHXAgEDAoGAF4di91+kN71RTuSPHereX8YIzZ48uXcxPpcczCBGL9KQ7R2tCv/xgTBkyHG67oukduNyVaIxctvwK0RgCuU5LJxM4phwr+YOUgfiv0qjEqzrj10YqQ4C5qc1JQPs/q1BhSJp8nY5AgrUtBvZWsyM1i+A9nDlZqpRAn2y6+LaXGMCQQDrkcn4n/clnCmnt84IWhtO6quWspPy2qYf4pirvAd2w019WQdD1IFbptYjIzMj7x4HXYEtUob5apB6CFzuJuNvAkEAmWq0GHcgbo4bzvCzStv87rcxroLZtfHQ3txxf1vK8ZXBaUGyuiGzozXf2qkEA3rzpbMmJNa9Zn+L4OB41Hb0GQJBAJ0L2/sVT25oG8UlNAWRZ4nxx7nMYqHnGWqXEHJ9Wk8s3lOQr4KNq5JvOWzCIhf0vq+Tq3OMWfucYFFa6J7El58CQGZHIrr6FZ8JZ99LIjHn/fR6IR8B5nlL4JSS9lTn3KEOgPDWdybBImzOlTxwrVenTRkiGW3kfkRVB+tAUI2korsCQQCbEQHa0XbFjA230nejo8y1umltCvtD1eeomzblXLSLPqwenqd380B1vkZEUaSDafmo248THmWOfDom6T/hmvvW";

    private static SecurityLayer sInstance = null;
    public static SecurityLayer Instance
    {
        get
        {
            if (sInstance == null)
            {
                sInstance = new SecurityLayer();
            }
            return sInstance;
        }
    }

    private byte[] _aesKeyByte = null;
    private byte[] _ivKeyByte = null;
    private CipherMode _aesMode = CipherMode.CBC;
    private PaddingMode _aesPadding = PaddingMode.PKCS7;
    private bool bInited = false;

    private AsymmetricKeyParameter pubKey = null;
    private AsymmetricKeyParameter prvKey = null;
    protected SecurityLayer()
    {
    }

    public void Init()
    {
        if (bInited) return;

        pubKey = RsaKeyHelper.loadPublicKey(publicKey);
        prvKey = RsaKeyHelper.loadPrivateKeyPk8(privateKey);
        bInited = true;
        EventMgr.DispatchEvent(new CoreEvent<int>(ECoreEventType.EID_LOADKEY_OK, 1));
    }

    public void SetAesKey(string aesKey)
    {
        if (string.IsNullOrEmpty(aesKey)) return;

        _aesKeyByte = System.Text.Encoding.Default.GetBytes(aesKey);
        _ivKeyByte = System.Text.Encoding.Default.GetBytes(aesKey);
    }

    public byte[] RSAEncrypt(byte[] data)
    {
        if (data == null || data.Length == 0) return data;

        IBufferedCipher cipher = CipherUtilities.GetCipher("RSA/ECB/PKCS1Padding");
        cipher.Init(true, pubKey);//true表示加密  
        byte[] encryptData = cipher.DoFinal(data);
        string encryptBase64Str = Convert.ToBase64String(encryptData);
        return System.Text.Encoding.Default.GetBytes(encryptBase64Str);
    }

    public byte[] RSADecrypt(byte[] data)
    {
        if (data == null || data.Length == 0) return data;
        var encryptData = default(byte[]);
        try
        {
            IBufferedCipher cipher = CipherUtilities.GetCipher("RSA/ECB/PKCS1Padding");
            cipher.Init(false, prvKey);//false表示解密  
            var str = System.Text.Encoding.Default.GetString(data);
            encryptData = Convert.FromBase64String(str);
            var decryptData = cipher.DoFinal(encryptData);
            return decryptData;
        }
        catch (Exception e)
        {
            DebugHelper.LogError(e.Message + " buffLen:" + data.Length + " From64Len:" + encryptData.Length);
            return data;
        }
    }

    public byte[] AESEncrypt(byte[] data)
    {
        if (data == null || data.Length == 0) return data;

        MemoryStream ms = new MemoryStream();
        AesCryptoServiceProvider aes = new AesCryptoServiceProvider();
        aes.Mode = _aesMode;
        aes.Padding = _aesPadding;
        ICryptoTransform ct = aes.CreateEncryptor(_aesKeyByte, _ivKeyByte);

        CryptoStream cs = new CryptoStream(ms, ct, CryptoStreamMode.Write);
        cs.Write(data, 0, data.Length);
        cs.FlushFinalBlock();
        cs.Close();
        return ms.ToArray();
    }

    public byte[] AESDecrypt(byte[] encData)
    {
        if (encData == null || encData.Length == 0) return encData;

        using (ICryptoTransform ct = new AesCryptoServiceProvider()
        {
            Mode = CipherMode.CBC,
            Padding = PaddingMode.PKCS7
        }.CreateDecryptor(_aesKeyByte, _ivKeyByte))
        {
            using (MemoryStream ms = new MemoryStream())
            {
                using (CryptoStream cs = new CryptoStream(ms, ct, CryptoStreamMode.Write))
                {
                    try
                    {
                        cs.Write(encData, 0, encData.Length);
                        cs.FlushFinalBlock();
                        cs.Close();
                    }
                    catch (Exception e)
                    {
                        DebugHelper.LogError(e.Message);
                        return encData;
                    }
                }
                return ms.ToArray();
            }
        }
    }
}
