using System;
using System.IO;
using System.Text;

public class SerializeUtil
{
    public static void WriteInteger(ref Stream input, int val)
    {
        byte[] b = BitConverter.GetBytes(val);
        Array.Reverse(b);
        input.Write(b, 0, b.Length);
    }

    public static void WriteFloat(ref Stream input, float val)
    {
        byte[] b = BitConverter.GetBytes(val);
        Array.Reverse(b);
        input.Write(b, 0, b.Length);
    }

    public static void WriteString(ref Stream input, string str)
    {
        if (str == null)
        {
            WriteVariant(ref input, 0);
            return;
        }

        byte[] b = Encoding.UTF8.GetBytes(str);
        int count = b.Length;
        WriteVariant(ref input, count + 1);
        input.Write(b, 0, b.Length);
    }

    public static int ReadInteger(Stream input)
    {
        return (input.ReadByte() << 24) + (input.ReadByte() << 16) + (input.ReadByte() << 8) + input.ReadByte();
    }

    /// <summary>
    /// 读取浮点类型值
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    public static float ReadFloat(Stream input)
    {
        byte[] buffer = new byte[4];
        buffer[3] = (byte)input.ReadByte();
        buffer[2] = (byte)input.ReadByte();
        buffer[1] = (byte)input.ReadByte();
        buffer[0] = (byte)input.ReadByte();
        return BitConverter.ToSingle(buffer, 0);
    }

    public static string ReadString(Stream input)
    {
        int byteCount = ReadVariant(input);
        switch (byteCount)
        {
            case 0:
                return null;
            case 1:
                return "";
        }
        byteCount--;
        byte[] buffer = new byte[byteCount];
        ReadFully(input, buffer, 0, byteCount);
        return Encoding.UTF8.GetString(buffer, 0, byteCount);
    }

    static void ReadFully(Stream input, byte[] buffer, int offset, int length)
    {
        while (length > 0)
        {
            int count = input.Read(buffer, offset, length);
            if (count <= 0) throw new EndOfStreamException();
            offset += count;
            length -= count;
        }
    }

    public static void WriteVariant(ref Stream input, int val)
    {
        if (input == null)
            return;

        if (val <= (Math.Pow(2, 7) - 1))
        {
            input.WriteByte((byte)val);
        }
        else if (val <= (Math.Pow(2, 14) - 1))
        {
            input.WriteByte((byte)((val & 0x7F) | 0x80));
            input.WriteByte((byte)(val >> 7));
        }
        else if (val <= (Math.Pow(2, 21) - 1))
        {
            input.WriteByte((byte)((val & 0x7F) | 0x80));
            input.WriteByte((byte)(((val >> 7) & 0x7F) | 0x80));
            input.WriteByte((byte)((val >> 14)));
        }
        else if (val <= (Math.Pow(2, 28) - 1))
        {
            input.WriteByte((byte)((val & 0x7F) | 0x80));
            input.WriteByte((byte)(((val >> 7) & 0x7F) | 0x80));
            input.WriteByte((byte)(((val >> 14) & 0x7F) | 0x80));
            input.WriteByte((byte)((val >> 21)));
        }
        else
        {
            input.WriteByte((byte)((val & 0x7F) | 0x80));
            input.WriteByte((byte)(((val >> 7) & 0x7F) | 0x80));
            input.WriteByte((byte)(((val >> 14) & 0x7F) | 0x80));
            input.WriteByte((byte)(((val >> 21) & 0x7F) | 0x80));
            input.WriteByte((byte)((val >> 28)));
        }
    }

    /// <summary>
    /// 读取变长数据【读取的字节是和WriteVariant相对应的，一个数值7位表示】
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    public static int ReadVariant(Stream input)
    {
        int b = input.ReadByte();
        int result = b & 0x7F;
        if ((b & 0x80) != 0)
        {
            b = input.ReadByte();
            result |= (b & 0x7F) << 7;
            if ((b & 0x80) != 0)
            {
                b = input.ReadByte();
                result |= (b & 0x7F) << 14;
                if ((b & 0x80) != 0)
                {
                    b = input.ReadByte();
                    result |= (b & 0x7F) << 21;
                    if ((b & 0x80) != 0) result |= (input.ReadByte() & 0x7F) << 28;
                }
            }
        }
        return result;
    }
}
