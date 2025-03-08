local HeadProtraitData = class('HeadProtraitData', require('DataBase'))

function HeadProtraitData:ctor()
    self.data = {}
end

function HeadProtraitData:Clear()
    self.data = {}
end

function HeadProtraitData:Destroy()
    if self.Clear then
        self:Clear()
    end

    self:UnRegisterNetEvents()
end

function HeadProtraitData:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_HEAD_INFO_ACK, self.OnHeadInfoAck, self)
	ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ACTIVE_HEAD_ACK, self.OnActiveHeadAck, self)
end

function HeadProtraitData:UnRegisterNetEvents()
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_HEAD_INFO_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_ACTIVE_HEAD_ACK)
end

function HeadProtraitData:OnHeadInfoAck(data)
    --LogError("[Wboy]  SC_HEAD_INFO_ACK  " .. Inspect(data))
    if not data then return end
    local headMap = {}
    local condData = data.head_Info

    if condData then
        local conditions = condData.conditions
        if conditions then
            for i = 1, #conditions do
                local condition = conditions[i]
                local cfgId = condition.head_id
                local taskData = ProtocalDataNormal.ParseTaskDataList(condition.task_list)
                local itemData = headMap[cfgId]
                if not itemData then
                    itemData = {}
                    headMap[cfgId] = itemData
                end
                itemData.cfgId = cfgId
                itemData.taskData = taskData
                itemData.state = self:CheckState(taskData)
            end
        end
    end

    local activeds = data.head_list
    if activeds then
        for i = 1, #activeds do
            local cfgId = activeds[i]
            local itemData = headMap[cfgId]
            if not itemData then
                itemData = {}
                headMap[cfgId] = itemData
            end
            itemData.cfgId = cfgId
            itemData.state = Enum.TaskStateType.Received
        end
    end
    self.data.headMap = headMap
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.USER_HEADPROTRAIT_DATA_TIDY)
end

function HeadProtraitData:OnActiveHeadAck(data)
	local cfgId = data.head_id
	local itemData = self.data.headMap[cfgId]
    if not itemData then
        itemData = {}
        self.data.headMap[cfgId] = itemData
    end
    itemData.cfgId = cfgId
    if itemData.state == Enum.TaskStateType.Received then return end
    itemData.state = Enum.TaskStateType.Received
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.USER_HEADPROTRAIT_DATA_CHANGED)
end

function HeadProtraitData:IsVaild()
    return self.data.headMap ~= nil
end

function HeadProtraitData:SetVaild()
    self.data.headMap = nil
end

function HeadProtraitData:SendGetHeadInfo()
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_HEAD_INFO_REQ, {})
end

function HeadProtraitData:SendActiveHead(cfgId)
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ACTIVE_HEAD_REQ, { head_id = cfgId })
end

function HeadProtraitData:SendSetHead(cfgId)
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_SET_HEAD_ID_REQ, { head_id = cfgId })
end

function HeadProtraitData:GetDataByCfgId(cfgId)
    return self.data.headMap[cfgId]
end

function HeadProtraitData:Contains(cfgId)
    return self.data.headMap[cfgId] ~= nil
end

function HeadProtraitData:GetState(cfgId)
    local itemData = self.data.headMap[cfgId]
    if itemData then
        return itemData.state
    end
    return Enum.TaskStateType.NoCompeleted
end

function HeadProtraitData:GetProgress(cfgId, conditionId, conditionTypeId)
    local itemData = self.data.headMap[cfgId]
    if itemData then
        local conditionData = itemData.taskData[conditionId]
        if conditionData then
            for _, value in pairs(conditionData.progress) do
                if value.key == conditionTypeId then
                    return value.value
                end
            end
        end
    end
    return 0
end

function HeadProtraitData:CheckState(taskData)
    for key, value in pairs(taskData) do
        local condCfgData = ManagerContainer.CfgMgr:GetCondDataById(key)
        if condCfgData then
            if value.state == Enum.TaskStateType.NoCompeleted then
                return Enum.TaskStateType.NoCompeleted
            end
        else
            taskData[key] = nil
            LogError("ConditionCfg not has id : " .. key)
            return Enum.TaskStateType.NoCompeleted
        end
    end
    return Enum.TaskStateType.CompletedAndNoReceive
end

return HeadProtraitData