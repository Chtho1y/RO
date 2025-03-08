--[[
    顺序执行设定代码
]]
local ExecuteSequenceMgr = class('ExecuteSequenceMgr')

local executeSequenceDatas = nil
local executeSequenceDataNum = nil

function ExecuteSequenceMgr:ctor()
    executeSequenceDatas = {}
    executeSequenceDataNum = 0
    self:RegisterEvent()
end

function ExecuteSequenceMgr:Destroy()
    self:UnRegisterEvent()
    if executeSequenceDatas and executeSequenceDataNum then
        for i = 1, executeSequenceDataNum do
            executeSequenceDatas[i]:Dispose()
        end
    end
    executeSequenceDatas = nil
    executeSequenceDataNum = nil
end

function ExecuteSequenceMgr:RegisterEvent()
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.UI_FILLCONTENT_COMPELETED, self, self._UIOpenCompleted)
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.UI_CLOSE_COMPELETED, self, self._UICloseCompleted)
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.UI_PAGE_IN_END_NTF, self, self._UIViewOpenAnimEnd)
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.UI_PAGE_OUT_END_NTF, self, self._UIViewCloseAnimEnd)
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.STORY_DATA_CHANGED, self, self._OnStoryDataChanged)
end

function ExecuteSequenceMgr:UnRegisterEvent()
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.UI_FILLCONTENT_COMPELETED, self, self._UIOpenCompleted)
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.UI_CLOSE_COMPELETED, self, self._UICloseCompleted)
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.UI_PAGE_IN_END_NTF, self, self._UIViewOpenAnimEnd)
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.UI_PAGE_OUT_END_NTF, self, self._UIViewCloseAnimEnd)
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.STORY_DATA_CHANGED, self, self._OnStoryDataChanged)
end

function ExecuteSequenceMgr:SkipToStep(executeSequenceData, stepId)
    if not executeSequenceData then return end
    if not executeSequenceData:GetIsExecuting() then return end
    local len = executeSequenceData:GetExecuteDataLength()
    if stepId < len then len = stepId end
    executeSequenceData:StopTimer()
    for i = 1, len - 1 do
        executeSequenceData:RemoveCurExecuteData()
    end
    self:_Execute(executeSequenceData)
end

function ExecuteSequenceMgr:Execute(executeSequenceData)
    if not executeSequenceData then return end
    executeSequenceDataNum = executeSequenceDataNum + 1
    executeSequenceDatas[executeSequenceDataNum] = executeSequenceData
    if executeSequenceData:GetIsExecuting() then return end
    executeSequenceData:SetIsExecuting(true)
    self:_Execute(executeSequenceData)
end

function ExecuteSequenceMgr:Exit(executeSequenceData)
    if not executeSequenceData then return end
    if not executeSequenceData:GetIsExecuting() then return end
    self:_Exit(executeSequenceData)
end

function ExecuteSequenceMgr:_Execute(executeSequenceData)
    local data = executeSequenceData:GetCurExecuteData()
    local isError = true
    while data do
        local type = data.type
        if type == Enum.ExecuteSequenceType.Func then
            executeSequenceData:RemoveCurExecuteData()
            if self:_ExecuteFunc(data) then
                data = executeSequenceData:GetCurExecuteData()
            else
                break
            end
        elseif type == Enum.ExecuteSequenceType.Listener then
            self:_ExecuteListenerTimeOut(executeSequenceData, data)
            if not self:_ExecuteAfterListener(executeSequenceData) then
                isError = false
            end
            break
        elseif type == Enum.ExecuteSequenceType.UIViewFunc then
            executeSequenceData:RemoveCurExecuteData()
            if self:_ExecuteUIViewFunc(data) then
                data = executeSequenceData:GetCurExecuteData()
            else
                break
            end
        elseif type == Enum.ExecuteSequenceType.Interval then
            self:_ExecuteInterval(executeSequenceData, data)
            isError = false
            break
        elseif type == Enum.ExecuteSequenceType.FuncAfterListener or type == Enum.ExecuteSequenceType.UIViewFuncAfterListener then
            LogError("execute error, " .. tostring(type) .. ' Can\'t execute this')
            break
        else
            LogError("execute error, unkown type " .. tostring(type))
            break
        end
    end
    if isError then
        self:_Exit(executeSequenceData)
    end
end

function ExecuteSequenceMgr:_ExecuteAfterListener(executeSequenceData)
    local data = executeSequenceData:GetNextExecuteData()
    local isError = false
    while data do
        local type = data.type
        if type == Enum.ExecuteSequenceType.FuncAfterListener then
            executeSequenceData:RemoveNextExecuteData()
            if self:_ExecuteFunc(data) then
                data = executeSequenceData:GetNextExecuteData()
            else
                isError = true
                break
            end
        elseif type == Enum.ExecuteSequenceType.UIViewFuncAfterListener then
            executeSequenceData:RemoveNextExecuteData()
            if self:_ExecuteUIViewFunc(data) then
                data = executeSequenceData:GetNextExecuteData()
            else
                isError = true
                break
            end
        else
            break
        end
    end
    return isError
end

function ExecuteSequenceMgr:_Exit(executeSequenceData)
    if not executeSequenceData then return end
    executeSequenceData:SetIsExecuting(false)
    for i = 1, executeSequenceData:GetExecuteDataLength() do
        local data = executeSequenceData:GetExecuteDataByIdx(i)
        if data.forceAfterErr then
            local type = data.type
            if type == Enum.ExecuteSequenceType.Func or type == Enum.ExecuteSequenceType.FuncAfterListener then
                self:_ExecuteFunc(data)
            -- elseif data.type == ExecuteSequenceType.Listener then
            elseif type == Enum.ExecuteSequenceType.UIViewFunc or type == Enum.ExecuteSequenceType.UIViewFuncAfterListener then
                self:_ExecuteUIViewFunc(data)
            -- elseif data.type == ExecuteSequenceType.Interval then
            end
        end
    end
    for i = executeSequenceDataNum, 1, -1 do
        if executeSequenceDatas[i] == executeSequenceData then
            table.remove(executeSequenceDatas, i)
            executeSequenceDataNum = executeSequenceDataNum - 1
        end
    end
    executeSequenceData:Dispose()
end


function ExecuteSequenceMgr:_UIOpenCompleted(owner)
    for i = 1, executeSequenceDataNum do
        self:_ExecuteUIListener(executeSequenceDatas[i], UIEventNames.UI_FILLCONTENT_COMPELETED, owner.uiData.id)
    end
end

function ExecuteSequenceMgr:_UICloseCompleted(owner)
    for i = 1, executeSequenceDataNum do
        self:_ExecuteUIListener(executeSequenceDatas[i], UIEventNames.UI_CLOSE_COMPELETED, owner.uiData.id)
    end
end

function ExecuteSequenceMgr:_UIViewOpenAnimEnd(id)
    for i = 1, executeSequenceDataNum do
        self:_ExecuteUIListener(executeSequenceDatas[i], UIEventNames.UI_PAGE_IN_END_NTF, id)
    end
end

function ExecuteSequenceMgr:_UIViewCloseAnimEnd(id)
    for i = 1, executeSequenceDataNum do
        self:_ExecuteUIListener(executeSequenceDatas[i], UIEventNames.UI_PAGE_OUT_END_NTF, id)
    end
end

function ExecuteSequenceMgr:_OnStoryDataChanged()
    for i = 1, executeSequenceDataNum do
        self:_ExecuteListener(executeSequenceDatas[i], UIEventNames.STORY_DATA_CHANGED)
    end
end

function ExecuteSequenceMgr:_ExecuteFunc(data)
    local ok, err
    if data.ownerFunc then
        if data.owner then
            ok, err = RO_XPCALL(data.ownerFunc, debug.traceback, data.owner, unpack(data.args))
        else
            ok, err = RO_XPCALL(data.ownerFunc, debug.traceback, unpack(data.args))
        end
    end
    if not ok then
        if data.args and #data.args > 0 then
            local argStr = 'args ('
            for i = 1, #data.args do
                if i == 1 then
                    argStr = argStr .. tostring(data.args[i])
                else
                    argStr = argStr .. ',' .. tostring(data.args[i])
                end
            end
            LogError('[Wboy] ExecuteSequenceMgr:_ExecuteFunc error !  ' .. argStr .. ')' .. '  ' .. tostring(err))
        else
            LogError('[Wboy] ExecuteSequenceMgr:_ExecuteFunc error !  ' .. tostring(err))
        end
    end
    return ok
end

function ExecuteSequenceMgr:_ExecuteUIListener(executeSequenceData, eventName, id)
    if not executeSequenceData then return end
    local data = executeSequenceData:GetCurExecuteData()
    if not data then return end
    if data.type == Enum.ExecuteSequenceType.Listener and data.eventName == eventName and data.id == id then
        self:_ExecuteListenerComplete(executeSequenceData)
    end
end

function ExecuteSequenceMgr:_ExecuteListener(executeSequenceData, eventName)
    if not executeSequenceData then return end
    local data = executeSequenceData:GetCurExecuteData()
    if not data then return end
    if data.type == Enum.ExecuteSequenceType.Listener and data.eventName == eventName then
        self:_ExecuteListenerComplete(executeSequenceData)
    end
end

function ExecuteSequenceMgr:_ExecuteListenerComplete(executeSequenceData)
    executeSequenceData:StopTimer()
    executeSequenceData:RemoveCurExecuteData()
    self:_Execute(executeSequenceData)
end

function ExecuteSequenceMgr:_ExecuteListenerTimeOut(executeSequenceData, data)
    if data.duration then
        executeSequenceData:StartTimer(function()
            self:_Exit(executeSequenceData)
        end, data)
    end
    return true
end

function ExecuteSequenceMgr:_ExecuteUIViewFunc(data)
    local uibase = ManagerContainer.LuaUIMgr:GetPage(data.id)
    if not uibase then
        LogError('[Wboy] ExecuteSequenceMgr:_ExecuteUIViewFunc error, not find UIBase ' .. tostring(data.id))
        return false
    end
    local luaTable = uibase.MLuaTable
    if not luaTable then
        LogError('[Wboy] ExecuteSequenceMgr:_ExecuteUIViewFunc error, not find UIBase\'s luatable ' .. tostring(data.id))
        return false
    end
    local func = luaTable[data.funcName]
    if type(func) ~= 'function' then
        LogError('[Wboy] ExecuteSequenceMgr:_ExecuteUIViewFunc error, not find ' .. tostring(data.funcName) .. 'is not exist or not function in UIBase\'s luatable' .. tostring(data.id))
            return false
    end
    local ok, err = RO_XPCALL(func, debug.traceback, luaTable, unpack(data.args))
    if not ok then
        if data.args and #data.args > 0 then
            local argStr = 'args ('
            for i = 1, #data.args do
                if i == 1 then
                    argStr = argStr .. tostring(data.args[i])
                else
                    argStr = argStr .. ',' .. tostring(data.args[i])
                end
            end
            LogError('[Wboy] ExecuteSequenceMgr:_ExecuteUIViewFunc fun error !  ' .. argStr .. ')' .. ' ' .. tostring(err))
        else
            LogError('[Wboy] ExecuteSequenceMgr:_ExecuteUIViewFunc fun error !  ' .. tostring(err))
        end
        return false
    end
    return ok
end

function ExecuteSequenceMgr:_ExecuteInterval(executeSequenceData, data)
    if data.duration then
        executeSequenceData:StartTimer(function()
            self:_ExecuteIntervalComplete(executeSequenceData)
        end, data)
    else
        self:_ExecuteIntervalComplete(executeSequenceData)
    end
    return true
end

function ExecuteSequenceMgr:_ExecuteIntervalComplete(executeSequenceData)
    executeSequenceData:StopTimer()
    executeSequenceData:RemoveCurExecuteData()
    self:_Execute(executeSequenceData)
end

return ExecuteSequenceMgr