-- print("luaMain")

if jit then
    jit.off();jit.flush()
end


RO_XPCALL = function (func, msgh, ...)
    if jit then
        return xpcall(func, msgh, ...)
    else
        local args = {...}
        local localfunc = function() return func(unpack(args, 1, table.maxn(args))) end
        return xpcall(localfunc, msgh)
    end
end



local LuaMgr = LuaMgr.Instance
LuaMgr:AddLuaSearchPath("Lua/Core")
LuaMgr:AddLuaSearchPath("Lua/Pb")
LuaMgr:AddLuaSearchPath("Lua/Enum")
LuaMgr:AddLuaSearchPath("Lua/Config")
LuaMgr:AddLuaSearchPath("Lua/UI")
LuaMgr:AddLuaSearchPath("Lua/FSMState")
LuaMgr:AddLuaSearchPath("Lua/Logic")
LuaMgr:AddLuaSearchPath("Lua/Managers")
LuaMgr:AddLuaSearchPath("Lua/Util")
LuaMgr:AddLuaSearchPath("ToLua/Lua")
LuaMgr:AddLuaSearchPath("ToLua/Lua/cjson")
LuaMgr:AddLuaSearchPath("Lua/Entities")
LuaMgr:AddLuaSearchPath("Lua/System")
LuaMgr:AddLuaSearchPath("Lua/RedPoint")

require("class")
require("LuaExtension")

Log = function(obj, ...)
    local info = debug.getinfo(2, "Sln")
    DebugHelper.Log(obj, info.source, ...)
end 
LogError = function(str)
    local info = debug.getinfo(2, "Sln")
    DebugHelper.LogError(info.source.."  "..str)
end 
LogWarning = function(str)
    local info = debug.getinfo(2, "Sln")
    DebugHelper.LogWarning(info.source.."  "..str)
end

LogHRWarning = function(str)
    local info = debug.getinfo(2, "Sln")
    DebugHelper.LogWarning("[hr]  "..info.source.."  "..info.currentline.."   "..str)
end

LogHRWarningStack = function (str)
    local s = ""
    for i = 2, 8 do
        local info = debug.getinfo(i, "nlS")

        if info then
            s = s .. string.format("%s:%d: in %s\n", info.source, info.currentline, info.name or "")
        end
    end
    DebugHelper.LogWarning(string.format("[hr]  %s\n%s", tostring(str), s))
end

local percent = 0
InternalRequire = function(name, endStep)
    if percent then
        percent = percent + 1
        LuaMgr:StartMainPrecent(percent / 180)
    end
    local data = require(name)
    if data and type(data) == 'function' then
        data = data()
        package.loaded[name] = nil
    end
    return data
end

local LuaMain = class("LuaMain")

-- 这里是异步初始化, 初始化的耗时操作可放这里面
function LuaMain:Init()
    Constant = InternalRequire("Constant")
    PlatformPack = InternalRequire("PlatformPack")
    Inspect = InternalRequire("inspect")
    Enum = InternalRequire("Enum")
    Enum.UIPageName = InternalRequire("UIPageName")
    UIEventNames = InternalRequire("UIEventNames")
    ProtoMsgId = InternalRequire("ProtoMsgId")
    ProtoConfirmMsgId = InternalRequire("ProtoConfirmMsgId")
    Bit = InternalRequire "bit"
    JSON = InternalRequire('json')

    InternalRequire("CommonUtil")

    ProtocalDataNormal = InternalRequire("ProtocalDataNormal")

	ManagerContainer = InternalRequire("ManagerContainer")
	ManagerContainer:Init()
    LogWarning(tostring(percent))
    percent = nil
    collectgarbage("collect")
end

local updateHandle = nil
function LuaMain:Start()
    collectgarbage("setpause",100)
    collectgarbage("setstepmul",5000)

    LogHRWarning("lua init   "..collectgarbage("count"))

    ManagerContainer = require("ManagerContainer")
    ManagerContainer:InitMgr()

    ManagerContainer.FSMMgr:RegisterStates()
    ManagerContainer.DataMgr:RegisterAllDataEvents()

    if not updateHandle then
        updateHandle = UpdateBeat:CreateListener(self.Update, self)
    end

    UpdateBeat:AddListener(updateHandle)
    LuaMgr:StartMainComplete()
end

function LuaMain:Update()
    if ManagerContainer ~= nil then
        ManagerContainer:Update()
    end
    if UnityEngine.Input.GetKeyUp(UnityEngine.KeyCode.Escape) then
        if SDKMgr.Instance:CheckHasModul(SDKModulType.EXIT_VIEW) then
            SDKMgr.Instance:OpenModul(SDKModulType.EXIT_VIEW)
        end
    end
end

function LuaMain:EnterLogin(relogin)
    if ManagerContainer.FSMMgr then
        if not ManagerContainer.FSMMgr.currentState
            or ManagerContainer.FSMMgr.currentState.stateId ~= Enum.StateEnum.LoginState.stateId
        then
            ManagerContainer.FSMMgr:ChangeState(Enum.StateEnum.LoginState.stateId, relogin)
        else
            ManagerContainer.FSMMgr:GetCurrentState():Enter(relogin)
        end
    end
end

function LuaMain:Destroy()
    if updateHandle ~= nil then
        UpdateBeat:RemoveListener(updateHandle)
        updateHandle = nil
    end

    if ManagerContainer then
        ManagerContainer:Destroy()
    end
    ManagerContainer = nil
    collectgarbage("collect")
    LogHRWarning("lua destroy   "..collectgarbage("count"))
end

return LuaMain