local VoyageAirShipData = class('VoyageAirShipData')

function VoyageAirShipData:ctor(msgData)
    self.uid = msgData.uid
    self.serverId = msgData.zone
    self.quality = msgData.trial_type
    self.endTime = msgData.end_time_stamp
    self.beChallengeNum = msgData.be_challenge_num or 0
    self.awardReceived = msgData.reward_state
    self.duration = msgData.duration_time
    self.slotId = Mathf.Clamp(msgData.line_num, 1, 10)
    self.changed1 = true
    self.changed2 = true
    self.changed3 = true
    self.changed4 = true
    self.changed = true
end

function VoyageAirShipData:Dispose()
    self.uid = nil
    self.serverId = nil
    self.quality = nil
    self.endTime = nil
    self.beChallengeNum = nil
    self.duration = nil
    self.slotId = nil
    self.changed1 = nil
    self.changed2 = nil
    self.changed3 = nil
    self.changed = nil
    self.name = nil
end

function VoyageAirShipData:SetData(msgData)
    local newQuality = msgData.trial_type
    local newEndTime = msgData.end_time_stamp
    local newBeChallengeNum = msgData.be_challenge_num or 0
    local newAwardReceived = msgData.reward_state
    local newDuration = msgData.duration_time
    local newSlotId = Mathf.Clamp(msgData.line_num, 1, 10)
    self.changed1 = self.changed1 or (self.quality ~= newQuality)
    self.changed2 = self.changed2 or (self.endTime ~= newEndTime)
    self.changed3 = self.changed3 or (self.beChallengeNum ~= newBeChallengeNum)
    self.changed4 = self.changed4 or (self.awardReceived ~= newAwardReceived)
    self.changed = self.changed or (self.changed1 or self.changed2 or self.changed3 or self.changed4)
    self.quality = newQuality
    self.endTime = newEndTime
    self.beChallengeNum = newBeChallengeNum
    self.awardReceived = newAwardReceived
    self.duration = newDuration
    self.slotId = newSlotId
    self.serverId = msgData.zone
end

function VoyageAirShipData:GetServerId()
    return self.serverId or 0
end

function VoyageAirShipData:GetName()
    return self.name
end

function VoyageAirShipData:SetName(name)
    self.name = name
end

function VoyageAirShipData:IsSame(uid)
    return self.uid == uid
end

function VoyageAirShipData:IsChange()
    return self.changed
end

function VoyageAirShipData:ResetChange()
    self.changed1 = false
    self.changed2 = false
    self.changed3 = false
    self.changed4 = false
    self.changed = false
end

function VoyageAirShipData:IsChangeQuality()
    return self.changed1
end

function VoyageAirShipData:IsChangeEndTime()
    return self.changed2
end

function VoyageAirShipData:IsChangeNum()
    return self.changed3
end

function VoyageAirShipData:IsChangeAwardReceived()
    return self.changed4
end

function VoyageAirShipData:GetSlotId()
    return self.slotId
end

function VoyageAirShipData:SetSlotId(slotId)
    self.slotId = slotId
end

return VoyageAirShipData