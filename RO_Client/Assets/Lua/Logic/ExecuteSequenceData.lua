local ExecuteSequenceData = class('ExecuteSequenceData')


function ExecuteSequenceData:ctor()
    self.isExecuting = nil
    self.datas = {}
    self.timer = nil
end

function ExecuteSequenceData:Dispose()
    self.isExecuting = nil
    self.datas = nil
    if self.timer then
        self.timer:Stop()
    end
    self.timer = nil
end

function ExecuteSequenceData:Reset()
    self:Dispose()
    self.datas = {}
end

function ExecuteSequenceData:ClearDatas()
    self.datas = {}
    if self.timer then
        self.timer:Stop()
    end
    self.timer = nil
end

---添加执行函数
---@param forceAfterErr boolean 在顺序执行的过程中，发生错误后，是否还需要强制执行
---@param owner table|nil
---@param ownerFunc function
function ExecuteSequenceData:AppendFunc(forceAfterErr, owner, ownerFunc, ...)
    if not ownerFunc then return end
    local data = { type = Enum.ExecuteSequenceType.Func, forceAfterErr = forceAfterErr, owner = owner, ownerFunc = ownerFunc, args = {...} }
    self:AppendData(data)
end

function ExecuteSequenceData:InsertNextFunc(forceAfterErr, owner, ownerFunc, ...)
    if not ownerFunc then return end
    local data = { type = Enum.ExecuteSequenceType.Func, forceAfterErr = forceAfterErr, owner = owner, ownerFunc = ownerFunc, args = {...} }
    self:InsertDataNext(data)
end

function ExecuteSequenceData:FindFunc(forceAfterErr, owner, ownerFunc, ...)
    if not ownerFunc then return end
    if not self.datas then return end
    for i = 1, #self.datas do
        local data = self.datas[i]
        if data.type == Enum.ExecuteSequenceType.Func and data.forceAfterErr == forceAfterErr and data.owner == owner and data.ownerFunc == ownerFunc then
            if self:CheckArgsSome(data.args, {...}) then
                return i
            end
        end
    end
    return 0
end

---添加执行函数,在监听完成后, 一般来说只在 AppendUIListener或AppendListener 之后立即调用
---@param forceAfterErr boolean 在顺序执行的过程中，发生错误后，是否还需要强制执行
---@param owner table|nil
---@param ownerFunc function
function ExecuteSequenceData:AppendFuncAfterListener(forceAfterErr, owner, ownerFunc, ...)
    if not ownerFunc then return end
    local data = { type = Enum.ExecuteSequenceType.FuncAfterListener, forceAfterErr = forceAfterErr, owner = owner, ownerFunc = ownerFunc, args = {...} }
    self:AppendData(data)
end

function ExecuteSequenceData:InsertNextFuncAfterListener(forceAfterErr, owner, ownerFunc, ...)
    if not ownerFunc then return end
    local data = { type = Enum.ExecuteSequenceType.FuncAfterListener, forceAfterErr = forceAfterErr, owner = owner, ownerFunc = ownerFunc, args = {...} }
    self:InsertDataNext(data)
end

function ExecuteSequenceData:FindFuncAfterListener(forceAfterErr, owner, ownerFunc, ...)
    if not ownerFunc then return end
    if not self.datas then return end
    for i = 1, #self.datas do
        local data = self.datas[i]
        if data.type == Enum.ExecuteSequenceType.FuncAfterListener and data.forceAfterErr == forceAfterErr and data.owner == owner and data.ownerFunc == ownerFunc then
            if self:CheckArgsSome(data.args, {...}) then
                return i
            end
        end
    end
    return 0
end

---添加UI消息监听
---@param id integer UI的配置ID
---@param eventName UIEventNames 消息类型
---@param timeOut number|nil 回调时间,当为空时，会一直监听直到界面打开
function ExecuteSequenceData:AppendUIListener(id, eventName, timeOut)
    if not id then return end
    if not eventName then return end
    local data = { type = Enum.ExecuteSequenceType.Listener, id = id, eventName = eventName, duration = timeOut}
    self:AppendData(data)
end

function ExecuteSequenceData:InsertNextUIListener(id, eventName, timeOut)
    if not id then return end
    if not eventName then return end
    local data = { type = Enum.ExecuteSequenceType.Listener, id = id, eventName = eventName, duration = timeOut}
    self:InsertDataNext(data)
end

function ExecuteSequenceData:FindUIListener(id, eventName, timeOut)
    if not id then return end
    if not eventName then return end
    if not self.datas then return end
    for i = 1, #self.datas do
        local data = self.datas[i]
        if data.type == Enum.ExecuteSequenceType.Listener and data.id == id and data.eventName == eventName and data.duration == timeOut then
            return i
        end
    end
    return 0
end

---添加消息监听
---@param eventName UIEventNames 消息类型
---@param timeOut number|nil 回调时间,当为空时，会一直监听直到界面打开
function ExecuteSequenceData:AppendListener(eventName, timeOut)
    if not eventName then return end
    local data = { type = Enum.ExecuteSequenceType.Listener, eventName = eventName, duration = timeOut}
    self:AppendData(data)
end

function ExecuteSequenceData:InsertNextListener(eventName, timeOut)
    if not eventName then return end
    local data = { type = Enum.ExecuteSequenceType.Listener, eventName = eventName, duration = timeOut}
    self:InsertDataNext(data)
end

function ExecuteSequenceData:FindListener(eventName, timeOut)
    if not eventName then return end
    if not self.datas then return end
    for i = 1, #self.datas do
        local data = self.datas[i]
        if data.type == Enum.ExecuteSequenceType.Listener and data.eventName == eventName and data.duration == timeOut then
            return i
        end
    end
    return 0
end

---添加执行函数
---@param forceAfterErr boolean 在顺序执行的过程中，发生错误后，是否还需要强制执行
---@param id integer UI的配置ID
---@param funcName string 执行的函数名字
function ExecuteSequenceData:AppendUIViewFunc(forceAfterErr, id, funcName, ...)
    local data = { type = Enum.ExecuteSequenceType.UIViewFunc, forceAfterErr = forceAfterErr, id = id, funcName = funcName, args = {...} }
    self:AppendData(data)
end

function ExecuteSequenceData:InsertNextUIViewFunc(forceAfterErr, id, funcName, ...)
    local data = { type = Enum.ExecuteSequenceType.UIViewFunc, forceAfterErr = forceAfterErr, id = id, funcName = funcName, args = {...} }
    self:InsertDataNext(data)
end

function ExecuteSequenceData:FindUIViewFunc(forceAfterErr, id, funcName, ...)
    if not self.datas then return end
    for i = 1, #self.datas do
        local data = self.datas[i]
        if data.type == Enum.ExecuteSequenceType.UIViewFunc and data.forceAfterErr == forceAfterErr and data.id == id and data.funcName == funcName then
            if self:CheckArgsSome(data.args, {...}) then
                return i
            end
        end
    end
    return 0
end

---添加执行函数, 在监听完成后, 一般来说只在 AppendUIListener或AppendListener 之后立即调用
---@param forceAfterErr boolean 在顺序执行的过程中，发生错误后，是否还需要强制执行
---@param id integer UI的配置ID
---@param funcName string 执行的函数名字
function ExecuteSequenceData:AppendUIViewFuncAfterListener(forceAfterErr, id, funcName, ...)
    local data = { type = Enum.ExecuteSequenceType.UIViewFuncAfterListener, forceAfterErr = forceAfterErr, id = id, funcName = funcName, args = {...} }
    self:AppendData(data)
end

function ExecuteSequenceData:InsertNextUIViewFuncAfterListener(forceAfterErr, id, funcName, ...)
    local data = { type = Enum.ExecuteSequenceType.UIViewFuncAfterListener, forceAfterErr = forceAfterErr, id = id, funcName = funcName, args = {...} }
    self:InsertDataNext(data)
end

function ExecuteSequenceData:FindUIViewFuncAfterListener(forceAfterErr, id, funcName, ...)
    if not self.datas then return end
    for i = 1, #self.datas do
        local data = self.datas[i]
        if data.type == Enum.ExecuteSequenceType.UIViewFuncAfterListener and data.forceAfterErr == forceAfterErr and data.id == id and data.funcName == funcName then
            if self:CheckArgsSome(data.args, {...}) then
                return i
            end
        end
    end
    return 0
end

---添加延迟
---@param duration number 延迟时间
function ExecuteSequenceData:AppendInterval(duration)
    if not duration or duration <= 0 then return end
    local data = { type = Enum.ExecuteSequenceType.Interval, duration = duration}
    self:AppendData(data)
end

function ExecuteSequenceData:InsertNextInterval(duration)
    if not duration or duration <= 0 then return end
    local data = { type = Enum.ExecuteSequenceType.Interval, duration = duration}
    self:InsertDataNext(data)
end

function ExecuteSequenceData:FindInterval(duration)
    if not duration or duration <= 0 then return end
    if not self.datas then return end
    for i = 1, #self.datas do
        local data = self.datas[i]
        if data.type == Enum.ExecuteSequenceType.Interval and not data.isFrame and data.duration == duration then
            return i
        end
    end
    return 0
end

---添加延迟帧数
---@param duration number 延迟时间
function ExecuteSequenceData:AppendFrameInterval(frameCount)
    if not frameCount or frameCount <= 0 then return end
    local data = { type = Enum.ExecuteSequenceType.Interval, isFrame = true, duration = frameCount}
    self:AppendData(data)
end

function ExecuteSequenceData:InsertNextFrameInterval(frameCount)
    if not frameCount or frameCount <= 0 then return end
    local data = { type = Enum.ExecuteSequenceType.Interval, isFrame = true, duration = frameCount}
    self:InsertDataNext(data)
end

function ExecuteSequenceData:FindFrameInterval(frameCount)
    if not frameCount or frameCount <= 0 then return end
    if not self.datas then return end
    for i = 1, #self.datas do
        local data = self.datas[i]
        if data.type == Enum.ExecuteSequenceType.Interval and data.isFrame and data.duration == frameCount then
            return i
        end
    end
    return 0
end

function ExecuteSequenceData:HasDelayMethod()
    if not self.datas then return false end
    for i = 1, #self.datas do
        local data = self.datas[i]
        if data.type == Enum.ExecuteSequenceType.Interval or data.type == Enum.ExecuteSequenceType.Listener then
            return true
        end
    end
    return false
end


function ExecuteSequenceData:AppendData(data)
    self.datas[#self.datas + 1] = data
end

function ExecuteSequenceData:InsertDataNext(data)
    table.insert(self.datas, 1, data)
end

function ExecuteSequenceData:CheckArgsSome(args1, args2)
    local len1 = #args1
    local len2 = #args2
    if len1 ~= len2 then return false end
    for i = 1, len1 do
        if args1[i] ~= args2[i] then
            return false
        end
    end
    return true
end


function ExecuteSequenceData:GetCurExecuteData()
    return self.datas and self.datas[1] or nil
end

function ExecuteSequenceData:RemoveCurExecuteData()
    if self.datas then
        table.remove(self.datas, 1)
    end
end

function ExecuteSequenceData:GetNextExecuteData()
    return self.datas and self.datas[2] or nil
end

function ExecuteSequenceData:RemoveNextExecuteData()
    if self.datas then
        table.remove(self.datas, 2)
    end
end

function ExecuteSequenceData:GetExecuteDataLength()
    return self.datas and #self.datas or 0
end

function ExecuteSequenceData:GetExecuteDataByIdx(idx)
    return self.datas[idx]
end

function ExecuteSequenceData:GetIsExecuting()
    return self.isExecuting
end

function ExecuteSequenceData:SetIsExecuting(state)
    self.isExecuting = state
end

function ExecuteSequenceData:StartTimer(func, data)
    self:StopTimer()
    if data.isFrame then
        self.timer = FrameTimer.New(func, data.duration)
    else
        self.timer = Timer.New(func, data.duration)
    end
    self.timer:Start()
end

function ExecuteSequenceData:StopTimer()
    if self.timer then
        self.timer:Stop()
        self.timer = nil
    end
end

return ExecuteSequenceData