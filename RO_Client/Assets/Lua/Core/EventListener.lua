local one_to_one_listener = {}
one_to_one_listener.__index = one_to_one_listener

function one_to_one_listener:Init()

end

function one_to_one_listener:Register(event_name, handler)
    self[event_name] = handler
end

function one_to_one_listener:Dispatch(event_name, ...)
    local handler = self[event_name]
    if handler then
        handler(...)
    else
        --print(event_name .. '    handler not found')
    end
end

function one_to_one_listener:Unregister(event_name)
    local handler = self[event_name]
    if handler then
        self[event_name] = nil
    end
end

local one_to_multi_listener = {}
one_to_multi_listener.__index = one_to_multi_listener

function one_to_multi_listener:Init()

end

function one_to_multi_listener:Register(group_name, event_name, ...)
    local function GetHandlerList(group)
        for i = 1, #self.handlers do
            if self.handlers[i].group_name == group then
                return self.handlers[i]
            end
        end
        return nil
    end

    local handler_list = GetHandlerList(group_name)
    if not handler_list then
        handler_list = {group_name = group_name, events = {}}
        self.handlers[#self.handlers + 1] = handler_list
    end

    if event_name == nil then return end

    local list = {...}
    handler_list.events[event_name] = list
end

function one_to_multi_listener:Dispatch(event_name, ...)
    for _,v in pairs(self.handlers) do
        for k1,v1 in pairs(v.events) do
            if k1 == event_name then
                if type(v1[1]) == "function" then
                    v1[1](...)
                elseif type(v1[2]) == "function" then
                    v1[2](v1[1],...)
                end
            end
        end
    end
end

function one_to_multi_listener:Unregister(group_name)
    for i = 1, #self.handlers do
        if self.handlers[i].group_name == group_name then
            --table.remove(self.handlers, i)
            self.handlers[i].events = {}
            return
        end
    end
end

function one_to_multi_listener:Clear()
    self.handlers = {}
end

local one_to_multi_nogroup_listener = {}
one_to_multi_nogroup_listener.__index = one_to_multi_nogroup_listener

function one_to_multi_nogroup_listener:Init()
    self.handlers = {}
end

function one_to_multi_nogroup_listener:CheckArgs(event_name, ...)
    if event_name == nil then
        LogError('EventName can not nil!')
        return nil, nil
    end
    local args = {...}
    if #args > 2 then
        LogError('EventName : ' .. event_name .. ' args’ len is error!')
        return
    end
    if type(args[1]) == "function" then
        return nil, args[1]
    elseif type(args[2]) == "function" then
        return args[1], args[2]
    else
        LogError('EventName : ' .. event_name .. ' args type is error!')
        return nil, nil
    end
end

function one_to_multi_nogroup_listener:Register(event_name, ...)
    local owner, ownerCb = self:CheckArgs(event_name, ...)
    if not ownerCb then return end
    local handlers = self.handlers[event_name]
    local handler = nil
    if handlers then
        for i = 1, #handlers do
            handler = handlers[i]
            if handler.owner == owner and handler.ownerCb == ownerCb then
                -- 注册过，不需要再注册
                return
            end
        end
    else
        handlers = {}
        self.handlers[event_name] = handlers
    end
    handler = {owner = owner, ownerCb = ownerCb}
    handlers[#handlers + 1] = handler
end

function one_to_multi_nogroup_listener:Dispatch(event_name, ...)
    if event_name == nil then
        LogError('EventName can not nil!')
        return
    end
    local handlers = self.handlers[event_name]
    if handlers == nil then return end
    local owner, ownerCb, handler
    for i = 1, #handlers do
        handler = handlers[i]
        owner = handler.owner
        ownerCb = handler.ownerCb
        if ownerCb then
            if owner then
                ownerCb(owner, ...)
            else
                ownerCb(...)
            end
        end
    end
end

function one_to_multi_nogroup_listener:Unregister(event_name, ...)
    local owner, ownerCb = self:CheckArgs(event_name, ...)
    if not ownerCb then return end
    local handlers = self.handlers[event_name]
    if handlers then
        local handler
        for i = #handlers, 1, -1 do
            handler = handlers[i]
            if handler.ownerCb == ownerCb then
                handler.owner = nil
                handler.ownerCb = nil
                table.remove(handlers, i)
            end
        end
    end
end

function one_to_multi_nogroup_listener:UnregisterAll(event_name)
    if event_name == nil then
        LogError('EventName can not nil!')
        return
    end
    local handlers = self.handlers[event_name]
    if handlers then
        local handler
        for i = #handlers, 1, -1 do
            handler = handlers[i]
            handler.owner = nil
            handler.ownerCb = nil
            table.remove(handlers, i)
        end
    end
end


function one_to_multi_nogroup_listener:Clear()
    for event_name, _ in pairs(self.handlers) do
        self:UnregisterAll(event_name)
        self.handlers[event_name] = nil
    end
end



local EventListener = {}
function EventListener:New(type, ...)
    local new_event_listener = {}

    new_event_listener.handlers = {}
    if type == "multi" then
        setmetatable(new_event_listener, one_to_multi_listener)
    elseif type == 'multi_nogroup' then
        setmetatable(new_event_listener, one_to_multi_nogroup_listener)
    else
        setmetatable(new_event_listener, one_to_one_listener)
    end

    new_event_listener:Init(...)

    return new_event_listener
end

return EventListener