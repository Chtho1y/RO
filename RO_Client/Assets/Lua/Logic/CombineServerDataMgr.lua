local CombineServerDataMgr = class('CombineServerDataMgr', require('DataBase'))

function CombineServerDataMgr:ctor()
end

function CombineServerDataMgr:Clear()
    self.nextTime = nil
end

function CombineServerDataMgr:Destroy()
    self.nextTime = nil
    self:UnRegisterNetEvents()
end

function CombineServerDataMgr:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_COMBINE_SERVER_ONLINE_NTF, self.OnCombineServerOnlineNtf, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_COMBINE_SERVER_INFO_ACK, self.OnCombineServerInfoAck, self)
end

function CombineServerDataMgr:UnRegisterNetEvents()
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_COMBINE_SERVER_ONLINE_NTF)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_COMBINE_SERVER_INFO_ACK)
end

function CombineServerDataMgr:OnCombineServerOnlineNtf(data)
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    local nextTime = data.combine_time
    local changed = (nextTime ~= self.nextTime)
    self.nextTime = nextTime
    if changed then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.COMBINE_SERVER_TIME_CHANGED)
    end
end

function CombineServerDataMgr:OnCombineServerInfoAck(data)
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    local nextTime = data.combine_time
    local changed = (nextTime ~= self.nextTime)
    self.nextTime = nextTime
    if changed then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.COMBINE_SERVER_TIME_CHANGED)
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.COMBINE_SERVER_CONTENT_CHANGED, data.notice)
end

function CombineServerDataMgr:SendCombineServerInfoReq()
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_COMBINE_SERVER_INFO_REQ)
end

function CombineServerDataMgr:GetNextTime()
    return self.nextTime
end

return CombineServerDataMgr