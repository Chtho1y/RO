local ForceGuideData = class("ForceGuideData", require("DataBase"))

function ForceGuideData:ctor()
    self.data = {}
    self.data.forceGuideDatas = {}
end

function ForceGuideData:InitForceGuideData(data)
    ManagerContainer.ForceGuideMgr:InitMgrData()

    if data == nil then return end

    if self.data.forceGuideDatas == nil then
        self.data.forceGuideDatas = {}
    end
    self.data.forceGuideDatas[data.key] = data.value
    ManagerContainer.ForceGuideMgr:InitDataRecords(self.data.forceGuideDatas)
end

function ForceGuideData:RefreshForceGuideData(storyId, status)
    self.data.forceGuideDatas[storyId] = status

    ManagerContainer.ForceGuideMgr:InitDataRecords(self.data.forceGuideDatas)
end

function ForceGuideData:GetForceGuideDatas()
    return self.data.forceGuideDatas
end

function ForceGuideData:GetForceGuideRecordByGroupId(groupId, id)
    local maxK = 0
    for k,v in pairs(self.data.forceGuideDatas) do
        if k > maxK then
            maxK = k
        end
    end
    if maxK > groupId then
        return true
    elseif maxK == groupId then
        return self.data.forceGuideDatas[groupId] >= id
    end
    return false
end

function ForceGuideData:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_COMPULSORY_GUIDANCE_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            self:RefreshForceGuideData(data.story_id, data.status)
        end
    end)
end

function ForceGuideData:Clear()
    self.data = {}
    self.data.forceGuideDatas = {}
end

function ForceGuideData:Destroy()
    if self.Clear then
        self:Clear()
    end

    self:UnRegisterNetEvents()
end

function ForceGuideData:UnRegisterNetEvents()

end

return ForceGuideData