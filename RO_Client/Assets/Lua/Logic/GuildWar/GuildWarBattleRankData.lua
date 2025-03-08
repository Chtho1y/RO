local GuildWarBattleRankData = class('GuildWarBattleRankData')
local GuildWarBattleRankPageDataData = require('GuildWar/GuildWarBattleRankPageData')

function GuildWarBattleRankData:ctor()
end

function GuildWarBattleRankData:Clear()
    self.id = nil
    self.isFinish = nil
    self.isWin = nil
    self.guildId1 = nil
    self.guildName1 = nil
    self.guildBadge1 = nil
    self.guildOccupy1 = nil
    self.guildScore1 = nil
    self.guildId2 = nil
    self.guildName2 = nil
    self.guildBadge2 = nil
    self.guildOccupy2 = nil
    self.guildScore2 = nil
    self.rankMap = nil
end

function GuildWarBattleRankData:Dispose()
    self:Clear()
end

function GuildWarBattleRankData:SetData(msgData)
    self.id = msgData.guild_battle_idx
    self.isFinish = msgData.is_finish
    self.isWin = msgData.win_guild
    local dataLs = msgData.battle_data_list
    if dataLs then
        local guild1 = dataLs[1]
        if guild1 then
            self.guildId1 = guild1.key
            self.guildName1 = guild1.str_val
            self.guildBadge1 = guild1.value3
            self.guildOccupy1 = guild1.value2
            self.guildScore1 = guild1.value
        else
            self.guildId1 = nil
            self.guildName1 = nil
            self.guildBadge1 = nil
            self.guildOccupy1 = nil
            self.guildScore1 = nil
        end
        local guild2 = dataLs[2]
        if guild2 then
            self.guildId2 = guild2.key
            self.guildName2 = guild2.str_val
            self.guildBadge2 = guild2.value3
            self.guildOccupy2 = guild2.value2
            self.guildScore2 = guild2.value
        else
            self.guildId2 = nil
            self.guildName2 = nil
            self.guildBadge2 = nil
            self.guildOccupy2 = nil
            self.guildScore2 = nil
        end
    else
        self.guildId1 = nil
        self.guildName1 = nil
        self.guildBadge1 = nil
        self.guildOccupy1 = nil
        self.guildScore1 = nil
        self.guildId2 = nil
        self.guildName2 = nil
        self.guildBadge2 = nil
        self.guildOccupy2 = nil
        self.guildScore2 = nil
    end

    local rankType = msgData.rank_type
    if not self.rankMap then
        self.rankMap = {}
    end
    local rankPageData = self.rankMap[rankType]
    if not rankPageData then
        rankPageData = GuildWarBattleRankPageDataData:new()
        self.rankMap[rankType] = rankPageData
    end
    rankPageData:SetData(msgData)
end

function GuildWarBattleRankData:IsSameBattleField(msgData)
    if self.id then
        return self.id == msgData.guild_battle_idx
    end
    return true
end

function GuildWarBattleRankData:GetRankDataByType(type)
    if self.rankMap then
        return self.rankMap[type]
    end
    return nil
end



return GuildWarBattleRankData