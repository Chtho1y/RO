----Define Require Function
function RequireBehaviorTreeDesigner(name_)
    return require("RequireBehaviorTreeDesigner/" .. name_)
end


function GetTableMsg(tbl, level, filteDefault)
    local msg = ""
    filteDefault = filteDefault or true
    -- 默认过滤关键字（DeleteMe, _class_type）
    level = level or 1
    local indent_str = ""
    for i = 1, level do
        indent_str = indent_str .. "  "
    end

    msg = msg .. indent_str .. "{\n"
    if (tbl == nil) then
        msg = msg .. "nil\n";
    else
        for k, v in pairs(tbl) do
            local item_str = string.format("%s%s = %s\n", indent_str .. " ", tostring(k), tostring(v))
            msg = msg .. item_str
            if type(v) == "table" and tostring(k) ~= "owner" then
                msg = msg .. GetTableMsg(v, level + 1)
                -- tostring(v)
            end
        end
    end
    msg = msg .. indent_str .. "}\n"
    return msg
end

----打印table里面的值...
function ShowTable (tbl)
    ----print(GetTableMsg(tbl))
end

-- 包含缩进的table打印log
function ShowTableIndent(data)
    local indent = "│ "
    local tableBegin = "├─"
    local tableEnd = "└─"

    local function print_table(t, i)
        local tab = ""
        for j = 1, i do
            tab = tab .. indent
        end
        tab = tab .. tableBegin
        for k, v in pairs(t) do
            if (type(v) == "table") then
                ----print(tab .. k)
                print_table(v, i + 1)
            else
                if type(v) == "boolean" then
                    ----print(tab .. k .. ": " ..((v and "true") or "false"))
                elseif type(v) == "nil" then
                    ----print(tab .. k .. ": " .. "nil")
                else
                    ----print(tab .. k .. ": " .. v)
                end
            end
        end
    end
    print_table(data, 0)
end

-- lua层初始化类的一个构造器...
function InitCtor(tb_, mt_)
    tb_ = tb_ or { };
    setmetatable(tb_, mt_);
    mt_.__index = mt_;
    return tb_;
end

--
function DeepCopy(obj)
    local tempTable = { };

    local function copy(obj)
        if type(obj) ~= "table" then
            return obj
        elseif tempTable[obj] then
            return tempTable[obj]
        end
        local newTable = { };
        tempTable[obj] = newTable;
        for index, value in pairs(obj) do
            newTable[copy(index)] = copy(value);
        end
        return setmetatable(newTable, getmetatable(obj))
    end

    return copy(obj);
end

--浅拷贝，仅拷贝非table数据。.
function ShallowCopy(orig)
    local copy
    if type(orig) == "table" then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            if type(orig_value) == "table" then
                ----print("table cant ShallowCopy" ..orig_key);
            else  -- number, string, boolean, etc
                copy[orig_key] = orig_value
            end
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end


function TableRelease(orig)
    local function release(tb)
        for k, v in pairs(tb) do
            if type(v) == "table" then
                release(tb[k]);
            end
            tb[k] = nil;
        end
    end
    return release(orig);
end

-- 设置table里面的初始字段的值为dv_(default value)...
-- tips:如果有大量table要设置初始值，请使用下面的SetDefaultValue3Agrs来设置
function SetDefaultValue2Agrs(t_, dv_)
    local mt = { __index = function() return dv_ end };
    setmetatable(t_, mt);
end

-- local mt = {__index = function() return t_[k_] end}
-- function SetDefaultValue3Agrs(t_,k_,dv_)
-- t_[k_] = dv_;
-- setmetatable(t_,mt);
-- end

-- 提供给你一个默认值的原表mt_，然你自己脚本设置此原表 setmetatable(tbMe,mt_)
function SetDefaultValue3Agrs(mt_, k_, dv_)
    mt_.__index = function(table, k_)
        mt_[k_] = dv_;
        return mt_[k_];
    end
end

-- 提供允许通过table里面的key来进行排序函数(默认 ASC)...
function Pairs2Key(t_, f_)
    local tempTb = { }
    for n in pairs(t_) do
        tempTb[#tempTb + 1] = n
    end
    -- ASC or DESC
    table.sort(tempTb, f_)
    local i = 0
    return function()
        i = i + 1;
        return tempTb[i], t_[tempTb[i]]
    end
end

-- 提供字符串分割返回字符串list(如StringSplit("123|wwe|eee", "|")之后，返回的list中有123,wwe,eee三个元素)
function StringSplit(szFullString, szSeparator)
    local nSplitArray = { }
    -- 长度
    local n = string.len(szFullString)
    local start = 1
    while start <= n do
        -- find 'next szSeparator'
        local i = string.find(szFullString, szSeparator, start)
        if i == nil then
            table.insert(nSplitArray, string.sub(szFullString, start, n))
            break
        end

        table.insert(nSplitArray, string.sub(szFullString, start, i - 1))
        if i == n then
            table.insert(nSplitArray, "")
            break
        end
        start = i + 1
    end

    return nSplitArray
end

function GetLuaBitwiseFlag(tb_)
    return LuaUtilityHelper.LuaBitwise(tb_)
end

function GetLuaBitwiseTable(flag_)
    local flagAll = LuaUtilityHelper.LuaBitwiseLuaTable(flag_);

    return StringSplit(flagAll,";");
end

local eventGUID = 0;
local eventValue = { };
function EventGUID2Tb(tb_)
    eventGUID = eventGUID + 1;
    eventValue[eventGUID] = tb_;
    return eventGUID;
end

function EventValue2GUID(eventGUID_)
    if eventValue[eventGUID_] ~= nil then
        local tb = eventValue[eventGUID_];
        eventValue[eventGUID_] = nil;
        return tb;
    end
end

-- 判断函数隐藏参数self是否为空...
function IsSelfNil(self_)
    if self_ == nil or self_ == -1 then
        return true;
    end

    return false;
end

--异步分发执行函数
function DispatchAsyn(func_,argsTb_)
    local OnCoroutine = function()
        Yield(null)
        func_(argsTb_);
    end

    StartCoroutine(OnCoroutine);
end

--注册一个延迟一帧执行的函数.
function RegisterDelayStep(func_)
    local coDelay = nil;
    local OnDelay = function()      
        coroutine.step();
        func_();       
        coroutine.stop(coDelay);                    
    end
    coDelay = coroutine.start(OnDelay);
    return coDelay
end
function CreateEnumTable(tb_, index_)
    local enumTb = { };
    local enumIndex = index_ or 0;

    for k, v in ipairs(tb_) do
        enumTb[v] = enumIndex + k;
    end

    return enumTb;
end

-- 是否是百分比型属性...
function IsGamePropPer(argPropIdx)
    if argPropIdx >= EBattleAttribute.Atk and argPropIdx <= EBattleAttribute.Speed then
        return false;
    elseif argPropIdx == EBattleAttribute.MaxPower then
        return false;
    elseif argPropIdx == EBattleAttribute.MaxEnnrgy then
        return false;
    else
        return true;
    end
end

-- 删除table数组表中元素
function RemoveElementByVal(table, value, removeAll)
    local rmCount = 0
    for i = 1, #table do
        if list[i - rmCount] == value then
            table.remove(table, i - rmCount)
            if removeAll then
                rmCount = rmCount + 1
            else
                break
            end
        end
    end
end

--取当前的系统时区..
function GetTimeZone(bHour_)
    if bHour_ then
        return os.difftime(os.time(), os.time(os.date("!*t", os.time())))/3600;
    else
        return os.difftime(os.time(), os.time(os.date("!*t", os.time())));
    end
end

--UTC标准时间转换成当地时间..
function GetLocalTime(utcTime_)
    return (utcTime_ + os.difftime(os.time(), os.time(os.date("!*t", os.time()))));
end

-- 把时间X秒，转化为xx天xx时xx分xx秒 的形式..
function ConvertTimeForm(second)
    local timeDay = math.floor(second / 86400);
    local timeHour = math.fmod(math.floor(second / 3600), 24);
    local timeMinute = math.fmod(math.floor(second / 60), 60);
    local timeSecond = math.fmod(second, 60);

    return timeDay, timeHour, timeMinute, timeSecond;
end

-- 把时间X秒，转化为xx时xx分xx秒 的形式..
function FormatTime(time)
    local hour = math.floor(time / 3600);
    local minute = math.fmod(math.floor(time / 60), 60);
    local second = math.fmod(time, 60);
    if hour > 0 then
        return string.format("%02d:%02d:%02d", hour, minute, second);
    else
        return string.format("%02d:%02d", minute, second);
    end
end

function FormatTime2(time)
    local hour = math.floor(time / 3600);
    local minute = math.fmod(math.floor(time / 60), 60);
    local second = math.fmod(time, 60);
    if hour > 0 then
        return string.format("%02d:%02d:%02d", hour, minute, second);
    else
        return string.format("00:%02d:%02d", minute, second);
    end
end

-- 把时间X秒，xx分xx秒 的形式..
function FormatTimeMS(time)
    local minute = math.fmod(math.floor(time / 60), 60);
    local second = math.fmod(time, 60);
    local rtTime = string.format("%02d:%02d", minute, second);

    return rtTime;
end

-- 获取table长度(处理#识别不出的表单)
function CountTB(tbl)
    local count = 0;
    if (tbl) then
        for k, v in pairs(tbl) do
            count = count + 1;
        end
    end
    return count;
end

--取随机数..
function GetRandomNumber(nMin_, nMax_)
    math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)));
    return math.random(nMin_, nMax_);
end


--获取中英文混合字符串的实际字符个数...
function GetActualStringLength(str_)
	local lenInByte = #str_
	local width = 0
	local i = 1
	while i <= lenInByte do
		local curByte = string.byte(str_, i)
		local byteCount = 1
		if curByte>0 and curByte<=127 then
            byteCount = 1
        elseif curByte>=192 and curByte<223 then
            byteCount = 2
        elseif curByte>=224 and curByte<240 then
            byteCount = 3
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4
        end
		i = i + byteCount
		width = width + 1
	end
	return width
end

--获取中英文混合字符串中文字符（含标点）的个数（主要用于计算全宽字符的个数）...
function GetChineseCharCount(str_)
	local lenInByte = #str_
	local width = 0
	local i = 1
	while i <= lenInByte do
		local curByte = string.byte(str_, i)
		local byteCount = 1
		if curByte>0 and curByte<=127 then
            byteCount = 1
        elseif curByte>=192 and curByte<223 then
            byteCount = 2
        elseif curByte>=224 and curByte<240 then
            byteCount = 3
			width = width + 1
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4
        end
		i = i + byteCount

	end
	return width
end

--utf8字符长度..
local function Utf8CharSize(char_)
    if not char_ then
        return 0;
    elseif char_ > 240 then
        return 4;
    elseif char_ > 225 then
        return 3;
    elseif char_ > 192 then
        return 2;
    else
        return 1;
    end
end

--utf8字符串长度(数字字母算1个长度)..
function Utf8StrLen(str_)
    local len = 0;
    local currentIndex = 1;
    while currentIndex <= #str_ do
        local char = string.byte(str_, currentIndex);
        currentIndex = currentIndex + Utf8CharSize(char);
        len = len +1;
    end

    return len;
end

--utf8字符串长度(2个数字字母算1个长度)..
function Utf8StrLen2(str_)
    local fullCharCount = GetChineseCharCount(str_);
    local totalCharCount = GetActualStringLength(str_);
    local nameCharWidth = fullCharCount + (totalCharCount - fullCharCount) / 2;
    return nameCharWidth;
end

-- 截取utf8 字符串..
-- str_:         要截取的字符串..
-- startChar_:   开始字符下标,从1开始..
-- numChars_:    要截取的字符长度..
function Utf8StrSub(str_, startChar_, numChars_)
    local startIndex = 1;
    while startChar_ > 1 do
        local char = string.byte(str_, startIndex);
        startIndex = startIndex + Utf8CharSize(char);
        startChar_ = startChar_ - 1;
    end

    local currentIndex = startIndex;
    while numChars_ > 0 and currentIndex <= #str_ do
        local char = string.byte(str_, currentIndex);
        currentIndex = currentIndex + Utf8CharSize(char);
        numChars_ = numChars_ -1;
    end

    return str_:sub(startIndex, currentIndex - 1);
end

--取整a_/b_..
function GetMathInteger(a_, b_)
    local a = a_;
    local b = b_;

    local num = 0;
    if a < b then
        return 0;
    elseif b==0 then
        return a;
    elseif a == b then
        return 1;
    elseif a > b then
        while a >= b do
            a = a - b;
            num = num + 1;
        end
    end

    return num;
end

--取余a_%b_..
function GetMathRemainder(a_, b_)
    local a = a_;
    local b = b_;

    if a < b then
        return a;
    elseif b==0 then
        return 0;
    elseif a == b then
        return 0;
    elseif a > b then
        while a >= b do
            a = a - b;
        end
    end

    return a;
end

-- Lua内存记录功能
local preLuaSnapshot = nil
function SnapshotLuaMemory(sender, menu, value)
    -- 首先统计Lua内存占用的情况
    DebugHelper.LogError("GC前, Lua内存为:"..collectgarbage("count").."Kb")
    --collectgarbage()
    ------print("GC后, Lua内存为:", collectgarbage("count"))

    local snapshot = require "snapshot"
    local curLuaSnapshot = snapshot.snapshot()
    local ret = {}
    local count = 0
    if preLuaSnapshot ~= nil then
        for k,v in pairs(curLuaSnapshot) do
            if preLuaSnapshot[k] == nil then
                count = count + 1
                ret[k] = v
            end
        end
    end

    for k, v in pairs(ret) do
		DebugHelper.LogError(tostring(k).." -- "..v);
    end

    DebugHelper.LogError ("Lua snapshot diff object count is " .. count)
    preLuaSnapshot = curLuaSnapshot
end
local profiler = nil;
function StartLuaProfiler()
	if  profiler == nil then
		profiler = require "profiler"
	end
	if  profiler ~= nil then
		profiler.start("profiler.txt")
	end
end

function StopLuaProfiler()
	if  profiler ~= nil then
		profiler.stop()
	end
end

-- 对数值进行四舍五入，如果不是数值则返回 0
-- @function [parent=#math] round
-- @param number value 输入值
-- @return number#number

function math.round(value)
    value = tonumber(value) or 0
    return math.floor(value + 0.5)
end

--判断table是否为空
function table_is_empty(t)  
    return _G.next( t ) == nil
end

--A,B夹角[-180 ~ 180]
function GetAngleByPos(p1, p2)  
    local w = p2.x - p1.x;
    local h = p2.y - p1.y;
    return math.atan2(w, h)*180/math.pi; 
end

--取两点的中间世界坐标
function GetMiddleOfTwoPoints(p1, p2)  
    local x = p1.x + (p2.x - p1.x) / 2;
    local y = p1.y + (p2.y - p1.y) / 2;
    local z = p1.z + (p2.z - p1.z) / 2;
    return NewVector3(x, y, z);
end

function string.formatbykey(strI18Nkey, ...)
    local i18nStr = I18N.SetLanguageValue(strI18Nkey,...)
    return i18nStr
end

-- 表中是否含有该value
function IsTableHasValue(tb_,val_)
    if tb_ ~= nil then
        for k,v in pairs(tb_) do
            if v == val_ then
                return true
            end
        end
    end
    return false
end
--判断字符是否是中文
local function CheckCharIsChinese(char_)
    if #char_<3 then
        return false;
    end
    local c1=string.byte(char_,1)
    if c1>229 and c1<233 then
        return true;
    end
    local c2=string.byte(char_,2)
    local c3=string.byte(char_,3)
    local total=c1*256*256+c2*256+c3
    if 228*256*256+184*256+128<=total and 233*256*256+190*256+165>=total then
        return true;
    else
        return false;
    end
end
--判断字符串是否是全中文
function CheckStringIsChinese(s)
    local f = '[%z\1-\127\194-\244][\128-\191]*';
    for v in string.gmatch(s,f) do
        if not CheckCharIsChinese(v) then
            return false;
        end
    end
    return true;
end
--根据分隔符分隔字符串
function SplitFunc( str,reps )
    local resultStrList = {}
    string.gsub(str,'[^'..reps..']+',function ( w )
        table.insert(resultStrList,w)
    end)
    return resultStrList
end