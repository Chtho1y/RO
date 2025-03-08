using UnityEngine;
using System;
using System.IO;
using System.Text;
using ICSharpCode.SharpZipLib.GZip;
using ICSharpCode.SharpZipLib.Zip;
using ICSharpCode.SharpZipLib.BZip2;

/// <summary>
 /// 压缩方式。
 /// </summary>
public enum CompressionType
{
    /// <summary>
      /// GZip 压缩格式
      /// </summary>
    GZip,

    /// <summary>
      /// BZip2 压缩格式
      /// </summary>
    BZip2,

    /// <summary>
      /// Zip 压缩格式
      /// </summary>
    Zip
}

public static class CompressionUtil
{
    public static CompressionType CompressionProvider = CompressionType.GZip;

    public static byte[] Compress(byte[] bytesToCompress)
    {
        MemoryStream ms = new MemoryStream();
        Stream s = OutputStream(ms);
        s.Write(bytesToCompress, 0, bytesToCompress.Length);
        s.Close();
        return ms.ToArray();
    }

    public static string Compress(string stringToCompress)
    {
        byte[] compressedData = CompressToByte(stringToCompress);
        string strOut = Convert.ToBase64String(compressedData);
        return strOut;
    }

    public static byte[] CompressToByte(string stringToCompress)
    {
        byte[] bytData = Encoding.Unicode.GetBytes(stringToCompress);
        return Compress(bytData);
    }

    public static string UnCompress(string stringToDecompress)
    {
        string outString = string.Empty;
        if (stringToDecompress == null)
        {
            throw new ArgumentNullException("stringToDecompress", "You tried to use an empty string");
        }

        try
        {
            byte[] inArr = Convert.FromBase64String(stringToDecompress.Trim());
            outString = Encoding.Unicode.GetString(UnCompress(inArr));
        }
        catch (NullReferenceException nEx)
        {
            return nEx.Message;
        }

        return outString;
    }

    public static byte[] UnCompress(byte[] bytesToDecompress)
    {
        byte[] writeData = new byte[4096];
        Stream s2 = InputStream(new MemoryStream(bytesToDecompress));
        MemoryStream outStream = new MemoryStream();

        while (true)
        {
            int size = s2.Read(writeData, 0, writeData.Length);
            if (size > 0)
            {
                outStream.Write(writeData, 0, size);
            }
            else
            {
                break;
            }
        }
        s2.Close();
        byte[] outArr = outStream.ToArray();
        outStream.Close();
        return outArr;
    }

    private static Stream OutputStream(Stream inputStream)
    {
        switch (CompressionProvider)
        {
            case CompressionType.BZip2:
                return new BZip2OutputStream(inputStream);

            case CompressionType.GZip:
                return new GZipOutputStream(inputStream);

            case CompressionType.Zip:
                return new ZipOutputStream(inputStream);

            default:
                return new GZipOutputStream(inputStream);
        }
    }


    private static Stream InputStream(Stream inputStream)
    {
        switch (CompressionProvider)
        {
            case CompressionType.BZip2:
                return new BZip2InputStream(inputStream);

            case CompressionType.GZip:
                return new GZipInputStream(inputStream);

            case CompressionType.Zip:
                return new ZipInputStream(inputStream);

            default:
                return new GZipInputStream(inputStream);
        }
    }
}
