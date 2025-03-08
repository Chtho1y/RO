using System;
using System.Collections.Generic;
using UnityEngine;


[Serializable]
public struct VersionCode : IEquatable<VersionCode>
{
    public const uint c_Major_Multi = 1000000;
    public const uint c_Minor_Multi = 10000;
    public const uint c_Release_Multi = 100;

    public static readonly VersionCode zeroVersionCode = new VersionCode(0, 0, 0, 0);


    public uint major;
    public uint minor;
    public uint release;
    public uint patch;

    public VersionCode(uint major, uint minor, uint release, uint patch)
    {
        this.major = major;
        this.minor = minor;
        this.release = release;
        this.patch = patch;
    }

    public VersionCode(uint major, uint minor, uint release)
    {
        this.major = major;
        this.minor = minor;
        this.release = release;
        this.patch = 0;
    }

    public override int GetHashCode()
    {
        return major.GetHashCode() ^ (minor.GetHashCode() << 2) ^ (release.GetHashCode() >> 2) ^ (patch.GetHashCode() >> 1);
    }

    public override bool Equals(object obj)
    {
        if (obj is int)
        {
            return Equals((VersionCode)obj);
        }
        else if (obj is string)
        {
            return Equals((VersionCode)obj);
        }
        return base.Equals(obj);
    }

    public bool Equals(VersionCode other)
    {
        return major.Equals(other.major) && minor.Equals(other.minor) && release.Equals(other.release);
    }

    public string ToString(bool shortFormat)
    {
        if (shortFormat)
        {
            return major + "." + minor + "." + release;
        }
        return ToString();
    }

    public override string ToString()
    {
        return major + "." + minor + "." + release + "." + patch;
    }

    public static implicit operator uint(VersionCode code)
    {
        return code.major * c_Major_Multi + code.minor * c_Minor_Multi + code.release * c_Release_Multi + code.patch;
    }

    public static implicit operator VersionCode(uint code)
    {
        uint major = code / c_Major_Multi;
        code = code - major * c_Major_Multi;
        uint minor = code / c_Minor_Multi;
        code = code - minor * c_Minor_Multi;
        uint release = code / c_Release_Multi;
        code = code - release * c_Release_Multi;
        uint patch = code;
        return new VersionCode(major, minor, release, patch);
    }

    public static implicit operator string(VersionCode code)
    {
        return code.ToString();
    }

    public static implicit operator VersionCode(string codeStr)
    {
        uint major = 0;
        uint minor = 0;
        uint release = 0;
        uint patch = 0;
        if (!string.IsNullOrEmpty(codeStr))
        {
            try
            {
                string[] arr = codeStr.Split('.');
                int len = arr.Length;
                if (len >= 1)
                {
                    major = (uint.Parse(arr[0]));
                }
                if (len >= 2)
                {
                    minor = (uint.Parse(arr[1]));
                }
                if (len >= 3)
                {
                    release = (uint.Parse(arr[2]));
                }
                if (len >= 4)
                {
                    patch = (uint.Parse(arr[3]));
                }
            }
            catch (Exception e)
            {
                Debug.LogException(e);
                return VersionCode.zeroVersionCode;
            }
        }
        return new VersionCode(major, minor, release, patch);
    }


    public static bool operator ==(VersionCode lhs, VersionCode rhs)
    {
        return (lhs.major == rhs.major)
                && (lhs.minor == rhs.minor)
                && (lhs.release == rhs.release)
                && (lhs.patch == rhs.patch);
    }

    public static bool operator !=(VersionCode lhs, VersionCode rhs)
    {
        return !(lhs == rhs);
    }

    public static bool operator <(VersionCode lhs, VersionCode rhs)
    {
        if (lhs.major != rhs.major) return lhs.major < rhs.major;
        if (lhs.minor != rhs.minor) return lhs.minor < rhs.minor;
        if (lhs.release != rhs.release) return lhs.release < rhs.release;
        return lhs.patch < rhs.patch;
    }

    public static bool operator <=(VersionCode lhs, VersionCode rhs)
    {
        return !(lhs > rhs);
    }

    public static bool operator >(VersionCode lhs, VersionCode rhs)
    {
        if (lhs.major != rhs.major) return lhs.major > rhs.major;
        if (lhs.minor != rhs.minor) return lhs.minor > rhs.minor;
        if (lhs.release != rhs.release) return lhs.release > rhs.release;
        return lhs.patch > rhs.patch;
    }

    public static bool operator >=(VersionCode lhs, VersionCode rhs)
    {
        return !(lhs < rhs);
    }


    public static VersionCode operator +(VersionCode a, VersionCode b)
    {
        return new VersionCode(a.major + b.major, a.minor + b.minor, a.release + b.release, a.patch + b.patch);
    }

    public static VersionCode operator -(VersionCode a, VersionCode b)
    {
        return new VersionCode(a.major - b.major, a.minor - b.minor, a.release - b.release, a.patch - b.patch);
    }
}