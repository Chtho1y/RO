local GuildWarBattleFieldData = class('GuildWarBattleFieldData')
local GuildWarDojoAreaData = require('GuildWar/GuildWarDojoAreaData')
local GuildWarBattleLogData = require('GuildWar/GuildWarBattleLogData')

function GuildWarBattleFieldData:ctor()
end

function GuildWarBattleFieldData:Clear()
    self.id = nil
    self.isFinish = nil
    self.startTime = nil
    self.endTime = nil
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
    self.uid = nil
    self.guildId = nil
    self.challengeNum = nil
    self.rebornTime = nil
    self.autoChallenge = false
    self.autoReborn = false
    self.winNum = 0
    self.winStrak = 0
    self.buffDic = nil
    self.selfAreaData = nil
    self.tempAreaData = nil         -- 在自身未占道场数据时，用于填充数据进道场列表中
    self.areaDatas = nil
    self.areaMaxId = nil
    self.logsData = nil
end

function GuildWarBattleFieldData:Dispose()
    self.id = nil
    self.isFinish = nil
    self.startTime = nil
    self.endTime = nil
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
    self.uid = nil
    self.guildId = nil
    self.challengeNum = nil
    self.rebornTime = nil
    self.autoChallenge = false
    self.autoReborn = false
    self.winNum = 0
    self.winStrak = 0
    self.buffDic = nil
    self.selfAreaData = nil
    self.tempAreaData = nil
    self.areaDatas = nil
    self.areaMaxId = nil
    self.logsData = nil
end

function GuildWarBattleFieldData:InitData(msgData)
    self.id = msgData.guild_battle_idx
    self.startTime = msgData.battle_start_time
    self.endTime = msgData.battle_end_time

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

    self:ChangeSelfData(msgData)
end

function GuildWarBattleFieldData:ChangeScoreData(msgData)
    local dataLs = msgData.battle_data_list
    if dataLs then
        local guild1 = dataLs[1]
        if guild1 then
            self.guildOccupy1 = guild1.value2
            self.guildScore1 = guild1.value
        else
            self.guildOccupy1 = nil
            self.guildScore1 = nil
        end
        local guild2 = dataLs[2]
        if guild2 then
            self.guildOccupy2 = guild2.value2
            self.guildScore2 = guild2.value
        else
            self.guildOccupy2 = nil
            self.guildScore2 = nil
        end
    else
        self.guildOccupy1 = nil
        self.guildScore1 = nil
        self.guildOccupy2 = nil
        self.guildScore2 = nil
    end
    return true
end

function GuildWarBattleFieldData:ChangeSelfData(msgData)
    local data = msgData.self_data
    if data then
        self.uid = data.uid
        self.guildId = data.guild_id
        self.rebornTime = data.reborn_end_time
        self.autoChallenge = data.auto_challenge
        self.autoReborn = data.auto_reborn
        self.winNum = data.win_num
        self.winStrak = data.win_strak
        local buffls = data.buff_list
        if buffls then
            self.buffDic = {}
            for _,v in pairs(buffls) do
                self.buffDic[v.key] = v.value
            end
        else
            self.buffDic = nil
        end
        if msgData.buy_challenge_num then
            self.challengeNum = msgData.buy_challenge_num + data.challenge_num
        end
    else
        self.uid = nil
        self.guildId = nil
        self.challengeNum = 0
        self.rebornTime = nil
        self.autoChallenge = false
        self.autoReborn = false
        self.winNum = 0
        self.winStrak = 0
        self.buffDic = nil
    end
end

function GuildWarBattleFieldData:ChangeFinishState(state)
    if self.isFinish == state then
        return false
    end
    self.isFinish = state
    return true
end






function GuildWarBattleFieldData:IsSameBattleField(msgData)
    if self.id then
        return self.id == msgData.guild_battle_idx
    end
    return true
end

function GuildWarBattleFieldData:IsBattlingMy()
    return self.guildId == self.guildId1 or self.guildId == self.guildId2
end

function GuildWarBattleFieldData:ChangeAreaData(areaData, msgData)
    if not msgData then
        if areaData then
            local oldId = areaData.id
            areaData:SetValidState(false)
            local id = areaData.id
            return areaData, true, oldId, id
        else
            return areaData, false, 0, 0
        end
    end
    if not areaData then
        areaData = GuildWarDojoAreaData:new()
    end
    if not self.areaDatas then
        self.areaDatas = {}
    end

    local oldId = areaData.id
    local changed = areaData:SetData(msgData)
    local id = areaData.id
    if changed then
        if oldId ~= id then
            if id and id > 0 then
                local tempAreaData = self.areaDatas[id]
                if tempAreaData then
                    if oldId and oldId > 0 then
                        tempAreaData:Clear()
                        tempAreaData.id = oldId
                        tempAreaData:SetValidState(true)
                        self.areaDatas[oldId] = tempAreaData
                    end
                end
                self.areaDatas[id] = areaData
            end
        end
    end

    local selfId = nil
    if areaData:IsValidData() then
        if areaData:IsPeopleUid() == self.uid then
            if self.selfAreaData
                and self.selfAreaData:IsValidData()
                and self.selfAreaData.id ~= areaData.id
                and self.selfAreaData:IsPeopleUid() == self.uid
            then
                selfId = self.selfAreaData.id
                self.selfAreaData:ClearPeopleOccupy()
                changed = true
            end
            self.selfAreaData = areaData
        end
    end
    return changed, oldId, id, selfId
end

function GuildWarBattleFieldData:GetAreaMaxId()
    if not self.areaMaxId then
        self.areaMaxId = 0
        for key, _ in pairs(ManagerContainer.CfgMgr:GetGuildWarDojoCfg()) do
            if key > self.areaMaxId then
                self.areaMaxId = key
            end
        end
    end
    return self.areaMaxId
end

function GuildWarBattleFieldData:GetAreaDataById(id)
    if not self.areaDatas then
        return nil
    end
    return self.areaDatas[id]
end

function GuildWarBattleFieldData:SetLogs(logs, isEnd)
    if not self.logsData then
        self.logsData = GuildWarBattleLogData:new()
    end
    return self.logsData:SetLogs(logs, isEnd)
end

function GuildWarBattleFieldData:GetLogsData()
    return self.logsData
end

return GuildWarBattleFieldData