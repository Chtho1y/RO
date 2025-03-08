local HeadFrameData = class("HeadFrameData")

function HeadFrameData:ctor(cfg)
    self.frameId = cfg.HeadFrameId
    self.cfgId = cfg.HeadFrameId
    self.name = I18N.T(cfg.HeadFrameName)
    self.desc = I18N.T(cfg.HeadFrameDesc)
    self.source = cfg.HeadFrameSource
    self.icon = cfg.HeadFrameIcon
    self.type = cfg.HeadFrameType
    self.tips = I18N.T(cfg.HeadFrameGetTips)
    self.jumpId = cfg.HeadFrameGetJump
    self.attrs = cfg.HeadFrameQuality
    self.state = Enum.HeadFrameState.Loss
    if cfg.ResolveItem~= nil and #cfg.ResolveItem > 0  then 
        self.resolveCost = cfg.ResolveItem[1][2]
    else
        self.resolveCost = 0
    end
    self.redPointState = false   
    self.deadlineTime = nil            
end

function HeadFrameData:SyncServerData(headFrameTime)
    self.deadlineTime = headFrameTime
end

function HeadFrameData:SetFrameState(state)
    if self.state ~= state then
        if self.state == Enum.HeadFrameState.Using then
            self.redPointState = false
        end
        self.state = state
    end
end

function HeadFrameData:SetRedPointStatus(hasRP)
    if self.redPointState ~= hasRP then
        self.redPointState = hasRP
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_HeadFrame_RP)
    end
end

function HeadFrameData:GetAttrs()
    return self.attrs
end

function HeadFrameData:IsUsing()
    return self.state == Enum.HeadFrameState.Using
end

function HeadFrameData:IsActivated()
    return self.state == Enum.HeadFrameState.GotFrame
end

function HeadFrameData:IsGot()
    return self.state == Enum.HeadFrameState.GotItem
end

function HeadFrameData:IsOwned()
    return self:IsActivated() or self:IsUsing()
end

function HeadFrameData:IsLoss()
    return self.state == Enum.HeadFrameState.Loss
end

function HeadFrameData:GetLeftTime()
    if self.deadlineTime == nil  or self.deadlineTime == -1 then
        return -1
    end

    local leftTime =  self.deadlineTime - ManagerContainer.LuaTimerMgr:GetTimeSecond()
    if leftTime < 0 then
        leftTime = 0
    end
    return leftTime
end

function HeadFrameData:IsForever()
    return self.deadlineTime == nil or self.deadlineTime == -1
end

function HeadFrameData:IsTimeLimited()
    return self.deadlineTime ~= -1
end

return HeadFrameData