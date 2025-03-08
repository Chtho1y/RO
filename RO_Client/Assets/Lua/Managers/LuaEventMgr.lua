local LuaEventMgr = class("LuaEventMgr")

function LuaEventMgr:ctor()
    self.EventListener = require("EventListener"):New("multi")
    self.EventListenerNoGroup = require("EventListener"):New("multi_nogroup")
end

function LuaEventMgr:RegisterUIEvent(...)
    self.EventListener:Register(...)
end

function LuaEventMgr:Dispatch(eventName, ...)
    self.EventListener:Dispatch(eventName, ...)
    self.EventListenerNoGroup:Dispatch(eventName, ...)
end

function LuaEventMgr:Unregister(...)
    self.EventListener:Unregister(...)
end

--- 注册事件，和 UnregisterEvent 配对使用
---@param eventName string
---@param arg1 table|function
---@param arg2 function|nil
function LuaEventMgr:RegisterEvent(eventName, arg1, arg2)
    self.EventListenerNoGroup:Register(eventName, arg1, arg2)
end

--[[
--- 触发事件
---@param eventName string
function LuaEventMgr:DispatchEvent(eventName, ...)
    self.EventListenerNoGroup:Dispatch(eventName, ...)
end
]]

--- 取消注册事件，和 RegisterEvent 配对使用
--- 只判断了传入fuction指针地址相同，所以可不传入table
---@param eventName string
---@param arg1 table|function
---@param arg2 function|nil
function LuaEventMgr:UnregisterEvent(eventName, arg1, arg2)
    self.EventListenerNoGroup:Unregister(eventName, arg1, arg2)
end

--- 取消所有eventName注册的事件
---@param eventName string
function LuaEventMgr:UnregisterEventAll(eventName)
    self.EventListenerNoGroup:UnregisterAll(eventName)
end

function LuaEventMgr:Destroy(...)
    self.EventListener:Clear()
    self.EventListenerNoGroup:Clear()
end

return LuaEventMgr