local LuaTimerMgr = class("LuaTimerMgr", function()
    return TimerManager.Instance
end)

local frameCount = 0

local curServerTimeStamp
local curServerTimeSecond   --通过心跳包获取的时间，单位是秒
function LuaTimerMgr:ctor()
    self.OneMinuteSeconds = 60
    self.OneDaySeconds = 24*3600
end

function LuaTimerMgr:GetOneDaySeconds()
    return self.OneDaySeconds
end

function LuaTimerMgr:AddLuaTimer(inter, times, cb, params)
    return self:AddTimer(inter, times, false, cb, params)
end

function LuaTimerMgr:SyncServerTime(serverTime)
    curServerTimeStamp = serverTime
    curServerTimeSecond = serverTime / 1000
    curServerTimeSecond = type(curServerTimeSecond) == "number" and curServerTimeSecond or #curServerTimeSecond
    if serverTime ~= nil then
        self:SetServerTime(serverTime)
    end
end

function LuaTimerMgr:Update()
    if curServerTimeStamp ~= nil then
        curServerTimeStamp = curServerTimeStamp + Time.unscaledDeltaTime*1000
        curServerTimeSecond = curServerTimeSecond + Time.unscaledDeltaTime
    end
end

function LuaTimerMgr:CurLuaServerTime()
    return curServerTimeStamp
end

function LuaTimerMgr:GetTimeSecond()
    return math.floor(curServerTimeSecond or 0)
end

function LuaTimerMgr:CurServerTime()
    return self:LuaGetServerTime()
end

--秒时间戳 转为小时
function LuaTimerMgr:Getstamp2TimeH(Format,Seconds)
    local LocalSeconds = type(Seconds) == "number" and Seconds or #Seconds
    return os.date(Format,LocalSeconds)
end

--日期转 秒时间戳
function LuaTimerMgr:GetTime2StampS(Date)    
    return os.time({day=Date.day, month=Date.month, year=Date.year, hour=Date.hour, minute=Date.minute, second=Date.second})
end

function LuaTimerMgr:ParseSeconds2Time(seconds)
    return string.format("%02d:%02d:%02d", seconds/(60*60), seconds/60%60, seconds%60)
end

function LuaTimerMgr:ParseTimeStamp2HS(time)
    if type(time) == "userdata" then
        time = time/1000
        time = #time
    end
    return self:ParseTimeStamp2Format(time, "%H:%M")
end

function LuaTimerMgr:ParseTimeStamp2Format(time, format)
    if type(time) == "userdata" then
        time = time/1000
        time = #time
    end
    return os.date(format,time);
end

function LuaTimerMgr:ParseEndTimeStamp2Time(endTime)
    local s = self:GetRemainSeconds(endTime)
    return self:ParseSeconds2Time(s)
end

function LuaTimerMgr:ParseEndTimeStamp2TimeWithUInt64(endTime)
    local endSeconds = endTime*0.001
    return self:ParseEndTimeStamp2Time(endSeconds)
end

function LuaTimerMgr:GetRemainSecondsWithUInt64(endTime, needAbs)
    local endSeconds = endTime/1000
    return self:GetRemainSeconds(endSeconds, needAbs)
end

function LuaTimerMgr:GetRemainSeconds(endTime, needAbs)
    local currentTime = self:CurLuaServerTime()/1000
    local CoolingTime = endTime - currentTime
    CoolingTime = type(CoolingTime) == "number" and CoolingTime or #CoolingTime
    if needAbs then
        CoolingTime = math.abs(CoolingTime)
    end
    CoolingTime = math.max(0, CoolingTime)
    return CoolingTime
end

function LuaTimerMgr:Get2TimeStampDeltaSeconds(time1, time2)
    local CoolingTime = (time2 - time1)/1000
    CoolingTime = type(CoolingTime) == "number" and CoolingTime or #CoolingTime
    CoolingTime = math.abs(CoolingTime)
    CoolingTime = math.max(0, CoolingTime)
    return CoolingTime
end

function LuaTimerMgr:TransSeconds2Minutes(seconds)
    return seconds/self.OneMinuteSeconds
end

function LuaTimerMgr:PrintTimeStamp2DayStr(time)
    local time1 = time/1000
    LogError(os.date("%Y-%m-%d %H:%M:%S", #time1))
end

function LuaTimerMgr:TwoTimeStampBetweenOneDay(time, time1)
    if type(time) == "userdata" then
        time = time/1000
        time = #time
    end
    if type(time1) == "userdata" then
        time1 = time1/1000
        time1 = #time1
    end
    return self:TwoTimeSecondBetweenOneDay(time, time1)
end

function LuaTimerMgr:TwoTimeSecondBetweenOneDay(time, time1)
    if type(time) == "userdata" then
        time = time/1000
        time = #time
    end
    if type(time1) == "userdata" then
        time1 = time1/1000
        time1 = #time1
    end
    local str = os.date("%Y-%m-%d", time)
    local str1 = os.date("%Y-%m-%d", time1)
    return str == str1
end

function LuaTimerMgr:IsSomeFrameCount()
    if frameCount >= Time.frameCount then
        return true
    end
    frameCount = Time.frameCount
    return false
end

function LuaTimerMgr:Destroy()
    if tolua.getpeer(self) ~= nil then
	    tolua.setpeer(self, nil)
    end
end

return LuaTimerMgr