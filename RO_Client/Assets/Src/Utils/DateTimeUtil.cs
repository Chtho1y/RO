using UnityEngine;
using System.Collections;
using System;

public class DateTimeUtil {

    public static int ONE_DAY = 24 * 3600;

    public static readonly DateTime unixTPStart =
            TimeZone.CurrentTimeZone.ToLocalTime(new DateTime(1970, 1, 1));
            

    public static long toUTP(DateTime dt) {
        TimeSpan toNow = dt.Subtract(unixTPStart);
        return (long)Math.Round(toNow.TotalSeconds);
    }

    public static DateTime fromUTP(long tp) {
        return unixTPStart.Add(new TimeSpan(tp * 10000000));
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="startTimeStr">开始时间</param>
    /// <param name="endTimeStr">结束时间</param>
    /// <param name="curTime">当前时间 单位s</param>
    /// <returns></returns>
    public static bool ContainTime(string startTimeStr,string endTimeStr,long curTime)
    {
        if (string.IsNullOrEmpty(startTimeStr) || string.IsNullOrEmpty(endTimeStr)) return false;

        long startTime = DateTime2UtcTimeStamp(convertTime(startTimeStr));
        long endTime = DateTime2UtcTimeStamp(convertTime(endTimeStr));

        return curTime >= startTime && curTime <= endTime;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="curTime">当前时间 单位s</param>
    /// <param name="endTimeStr">结束时间</param>
    /// <returns></returns>
    public static int CaclLeftTime(long curTime,string endTimeStr)
    {
        if (string.IsNullOrEmpty(endTimeStr)) return 0;

        long endTime = DateTime2UtcTimeStamp(convertTime(endTimeStr));
        if (curTime >= endTime) return 0;

        return (int)(endTime - curTime);
    }

    public static int CaclLeftTimeWitTimeStamp(ulong curTime,string endTimeStr)
    {
        if (string.IsNullOrEmpty(endTimeStr)) return 0;

        ulong endTime = 0;
        ulong.TryParse(endTimeStr, out endTime);

        if (curTime >= endTime) return 0;

        return (int)((endTime - curTime)/1000);
    }

    public static String convertTime2Str(long tp, string format)
    {
        DateTime dt = fromUTP(tp);
        return dt.ToString(format);
    }

    /// <summary>
    /// 将字符串格式时间转换为DateTime格式
    /// </summary>
    /// <param name="str">时间字符串</param>
    /// <returns></returns>
    public static DateTime convertTime(string str)
    {
        if (str == "" || str == null)
        {
            return new DateTime();
        }
        str = str.Replace("-", "");
        str = str.Replace(" ", "");
        str = str.Replace(":", "");

        int year = int.Parse(str.Substring(0, 4));
        int month = int.Parse(str.Substring(4, 2));
        int day = int.Parse(str.Substring(6, 2));
        int hour = int.Parse(str.Substring(8, 2));
        int minute = int.Parse(str.Substring(10, 2));
        int second = int.Parse(str.Substring(12, 2));
        return new DateTime(year, month, day, hour, minute, second);
    }

    /// <summary>
    /// 转换时间为字符串
    /// </summary>
    /// <param name="seconds"></param>
    /// <returns></returns>
    public static String convertSeconds2TimeStr(int seconds, bool showSecond)
    {
        string timeStr = "";
        if (seconds <= 0)
        {
            return showSecond ? "0分0秒" : "0分";
        }
        int hours = seconds / 3600;
        int minutes = (seconds - hours * 3600) / 60;
        int leftSecond = seconds - (hours * 3600 + minutes * 60);
        if (hours > 0)
        {
            int day = hours / 24;
            hours = hours - day * 24;

            if(day > 0)
            {
                timeStr += day + "天";
            }

            timeStr += hours + "时";
        }


        if (minutes > 0)
            timeStr += minutes +"分";
        else if(hours == 0)
            timeStr += "0分";

        if (showSecond)
        {
            if(leftSecond > 0)
                timeStr += leftSecond + "秒";
            else if(hours==0 && minutes == 0)
                timeStr += "0秒";
        }

        return timeStr;
    }

    public static String convertSeconds2TimeStr1(int seconds, bool needMinutes = false, bool needSeconds = false, bool longStr = true)
    {
        string _dayStr = longStr ? "D" : "DAYS";
        string _hourStr = longStr ? "H" : "HRS";
        string _minuteStr = longStr ? "M" : "MINS";
        if (seconds <= 0 && needSeconds)
        {
            return "0" + I18N.T("S");
        }
        else if (seconds < 60 && needSeconds)
        {
            return seconds + I18N.T("S");
        }

        int days = seconds / 24 / 3600;
        seconds = Math.Max(0, seconds - days * 3600 * 24);

        int hours = seconds / 3600;
        seconds = Math.Max(0, seconds - hours * 3600);

        int minutes = seconds / 60;
        seconds = Math.Max(0, seconds - minutes * 60);

        int leftSecond = seconds;

        if (days > 0)
        {
            if (hours > 0)
            {
                return days + I18N.T(_dayStr) + hours + I18N.T(_hourStr);
            }
            else
            {
                return days + I18N.T(_dayStr);
            }
        }
        else
        {
            if (hours > 0)
            {
                string timeStr = hours + I18N.T(_hourStr);
                if (minutes > 0 && needMinutes)
                {
                    timeStr += minutes + I18N.T(_minuteStr);
                }
                return timeStr;
            }
            else
            {
                string timeStr = "";
                if (minutes > 0 && needMinutes)
                {
                    timeStr += minutes + I18N.T(_minuteStr);
                    if (leftSecond > 0 && needSeconds)
                    {
                        timeStr += leftSecond + I18N.T("S");
                    }
                }
                return timeStr;
            }
        }
       
        return "";
    }

    public static long DateTime2UtcTimeStamp(DateTime d)
    {
        return (int)((d - new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc)).TotalSeconds);
    }


    public static string TransTimeSecondIntToString(int second)
    {
        string str = "";
        if (second > ONE_DAY)
        {
            str += (second / ONE_DAY) + I18N.T("D");
        }
        else
        {
            long hour = second / 3600;
            long min = second % 3600 / 60;
            long sec = second % 60;
            str += string.Format("{0:D2}", hour);
            str += ":";
            str += string.Format("{0:D2}", min);
            str += ":";
            str += string.Format("{0:D2}", sec);
        }
     
        return str;
    }

    public static long GetCurrentUtcTimeStamp()
    {
        return DateTime2UtcTimeStamp(DateTime.Now);
    }

    public static long GetCurrentTimeStamp()
    {
        return toUTP(DateTime.Now);
    }
}

public class Tmath{
	public static float floatRemoveTail(float f)
	{
		return (( float)Mathf.RoundToInt( f * 1000f)) / 1000f;
	}
	public static float floatChangeTail(float f)
	{
		return (( float)Mathf.RoundToInt( f * 100f)) / 100f;
	}
}

public class Ticker
{
	private float mTime =0; 
	//private bool isCount=false;
	public bool Count(float time)
	{
		mTime+=Time.deltaTime;
		if(mTime>=time)
		{
			mTime=0;
			return true;
		}
		else
		{
			return false;
		}	
	}
	
	public void Reset()
	{
		mTime = 0;
	}
}