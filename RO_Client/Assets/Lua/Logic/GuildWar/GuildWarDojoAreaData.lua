local GuildWarDojoAreaData = class('GuildWarDojoAreaData')

function GuildWarDojoAreaData:ctor()
end

function GuildWarDojoAreaData:Clear()
    self.id             = nil
    self.guildId        = nil
    self.uid            = nil
    self.playBrief      = nil
    self.fightEndTime   = nil
    self.challengeUid   = nil
    self.valid          = nil
end

function GuildWarDojoAreaData:Dispose()
    self.id             = nil
    self.guildId        = nil
    self.uid            = nil
    self.playBrief      = nil
    self.fightEndTime   = nil
    self.valid          = nil
end

function GuildWarDojoAreaData:SetValidState(valid)
    self.valid = valid
end

function GuildWarDojoAreaData:SetData(msgData)
    self.id             = msgData.pos_idx
    self.guildId        = msgData.guild_id
    self.uid            = msgData.uid
    self.playBrief      = ProtocalDataNormal.ParsePlayerBriefInfo(msgData.owner_brief)
    self.fightEndTime   = msgData.fight_end_time
    self.valid = true
    return true
end

function GuildWarDojoAreaData:Clone()
    local newAreaData = GuildWarDojoAreaData:new()
    newAreaData.id              = self.id
    newAreaData.guildId         = self.guildId
    newAreaData.uid             = self.uid
    newAreaData.playBrief       = self.playBrief
    newAreaData.fightEndTime    = self.fightEndTime
    newAreaData.valid           = self.valid
    return newAreaData
end

function GuildWarDojoAreaData:IsValidData()
    return self.valid
end

function GuildWarDojoAreaData:IsOccupy()
    if not self.valid then
        return false
    end
    if not self.id or self.id <= 0 then
        return false
    end
    if self.guildId and self.guildId > 0 and self.uid and self.uid > 0 then
        return true
    end
    return false
end

function GuildWarDojoAreaData:IsPeopleOccupy()
    if self:IsOccupy() then
        return self.playBrief and self.playBrief.uid and self.playBrief.uid > 0
    end
    return false
end

function GuildWarDojoAreaData:IsPeopleUid()
    return self.playBrief and self.playBrief.uid or nil
end

function GuildWarDojoAreaData:GetPlayBrief()
    return self.playBrief
end

function GuildWarDojoAreaData:ClearPeopleOccupy()
    self.playBrief = nil
end

function GuildWarDojoAreaData:IsFighting()
    if not self.valid then
        return false
    end
    if not self.fightEndTime or self.fightEndTime <= 0 then
        return false
    end
    return self.fightEndTime > ManagerContainer.LuaTimerMgr:CurLuaServerTime()
end

function GuildWarDojoAreaData:GetFightEndTime()
    return self.fightEndTime
end

function GuildWarDojoAreaData:GetGuildId()
    return self.guildId
end

function GuildWarDojoAreaData:GetSlogan()
    return self.playBrief and self.playBrief.hundredDojoSlogan or nil
end

return GuildWarDojoAreaData