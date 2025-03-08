local HundredDojoAreaData = class('HundredDojoAreaData')

function HundredDojoAreaData:ctor()
end

function HundredDojoAreaData:Clear()
    self.id             = nil
    self.startTime      = nil
    self.endTime        = nil
    self.protectEndTime = nil
    self.playBrief      = nil
    self.robotId        = nil
    self.fightEndTime   = nil
    self.guildId        = nil
    self.guildName      = nil
    self.slogan         = nil
    self.valid          = nil
end

function HundredDojoAreaData:Dispose()
    self.id             = nil
    self.startTime      = nil
    self.endTime        = nil
    self.protectEndTime = nil
    self.playBrief      = nil
    self.robotId        = nil
    self.fightEndTime   = nil
    self.guildId        = nil
    self.guildName      = nil
    self.slogan         = nil
    self.valid          = nil
end

function HundredDojoAreaData:SetValidState(valid)
    self.valid = valid
end

function HundredDojoAreaData:SetData(msgData)
    self.id             = msgData.pos_idx
    self.startTime      = msgData.owner_start_time
    self.endTime        = msgData.owner_end_time
    self.protectEndTime = msgData.owner_protect_end_time
    self.playBrief      = ProtocalDataNormal.ParsePlayerBriefInfo(msgData.owner_brief)
    self.robotId        = msgData.owner_robot_id
    self.fightEndTime   = msgData.fight_end_time
    self.guildId        = msgData.guild_id
    self.guildName      = msgData.guild_name
    self.slogan         = nil

    self.valid = true
    return true
end

function HundredDojoAreaData:Clone()
    local newAreaData = HundredDojoAreaData:new()
    newAreaData.id = self.id
    newAreaData.startTime = self.endTime
    newAreaData.endTime = self.endTime
    newAreaData.protectEndTime = self.protectEndTime
    newAreaData.playBrief = self.playBrief
    newAreaData.robotId = self.robotId
    newAreaData.fightEndTime = self.fightEndTime
    newAreaData.guildId = self.guildId
    newAreaData.valid = self.valid
    return newAreaData
end

function HundredDojoAreaData:IsValidData()
    return self.valid
end

function HundredDojoAreaData:IsOccupy()
    if not self.valid then
        return false
    end
    if not self.id or self.id <= 0 then
        return false
    end
    if self.robotId and self.robotId > 0 then
        return true
    end
    if not self.endTime or self.endTime <= 0 then
        return false
    end
    return self.endTime > ManagerContainer.LuaTimerMgr:CurLuaServerTime()
end

function HundredDojoAreaData:GetStartTime()
    return self.startTime
end

function HundredDojoAreaData:GetEndTime()
    return self.endTime
end

function HundredDojoAreaData:IsProtected()
    if not self.valid then
        return false
    end
    if not self.protectEndTime or self.protectEndTime <= 0 then
        return false
    end
    return self.protectEndTime > ManagerContainer.LuaTimerMgr:CurLuaServerTime()
end

function HundredDojoAreaData:GetProtectEndTime()
    return self.protectEndTime
end

function HundredDojoAreaData:GetRobotId()
    return self.robotId
end

function HundredDojoAreaData:GetPlayBrief()
    return self.playBrief
end

function HundredDojoAreaData:IsFighting()
    if not self.valid then
        return false
    end
    if not self.fightEndTime or self.fightEndTime <= 0 then
        return false
    end
    return self.fightEndTime > ManagerContainer.LuaTimerMgr:CurLuaServerTime()
end

function HundredDojoAreaData:GetFightEndTime()
    return self.fightEndTime
end

function HundredDojoAreaData:GetGuildId()
    return self.guildId
end

function HundredDojoAreaData:GetGuildName()
    return self.guildName
end

function HundredDojoAreaData:GetSlogan()
    return self.playBrief and self.playBrief.hundredDojoSlogan or nil
end

return HundredDojoAreaData