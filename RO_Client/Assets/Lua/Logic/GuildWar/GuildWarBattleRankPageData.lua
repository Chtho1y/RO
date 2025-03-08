local GuildWarBattleRankPageData = class('GuildWarBattleRankPageData')

function GuildWarBattleRankPageData:ctor()
end

function GuildWarBattleRankPageData:Clear()
    self.reqPageIdx = nil
    self.lastUpdteTime = nil
    self.pageIdx = nil
    self.dataNum = nil
    self.datas = nil
    self.isFinish = nil
    self.isEnd = nil
    self.validStartId = nil
    self.validEndId = nil
end

function GuildWarBattleRankPageData:Dispose()
end

function GuildWarBattleRankPageData:SetData(msgData)
    if not msgData then
        return
    end
    local pageIdx = msgData.page_idx
    local isFinish = msgData.is_finish
    local dataLs = msgData.rank_data_list
    if self.reqPageIdx == pageIdx then
        self.reqPageIdx = nil
    end
    local datas = self.datas
    if not datas then
        datas = {}
        self.dataNum = 0
        self.datas = datas
    end
    local num = dataLs and #dataLs or 0
    if num <= 0 then
        if isFinish then
            if not self.dataNum or self.dataNum <= 0 then
                self.isFinish = isFinish
            end
            self.isEnd = true
        end
        return
    end
    self.pageIdx = pageIdx
    if isFinish and self.isFinish ~= isFinish then
        if self.dataNum and self.dataNum > 0 then
            datas = {}
            self.dataNum = 0
            self.datas = datas
        end
    end
    self.isFinish = isFinish
    local data = nil
    local oneData = nil
    local id = nil
    local validStartId = nil
    local validEndId = nil
    if isFinish then
        validStartId = self.validStartId
        validEndId = self.validEndId
    end
    for i = 1, num do
        data = dataLs[i]
        if isFinish then
            id = data.rank
        else
            id = i
        end
        oneData = datas[id]
        if not oneData then
            oneData = {}
            datas[id] = oneData
        end
        oneData.id = data.rank
        oneData.guildId = data.guild_id
        oneData.value = data.score
        oneData.playerBrief = ProtocalDataNormal.ParsePlayerBriefInfo(data.info)
        if not validStartId or validStartId > id then
            validStartId = id
        end
        if not validEndId or validEndId < id then
            validEndId = id
        end
    end
    self.validStartId = validStartId
    self.validEndId = validEndId
    self.dataNum = (validEndId - validStartId) + 1
end

function GuildWarBattleRankPageData:GetDataNum()
    return self.dataNum
end

function GuildWarBattleRankPageData:GetDatas()
    return self.datas
end

function GuildWarBattleRankPageData:GetDataByIdx(idx)
    if self.datas then
        return self.datas[idx]
    end
    return nil
end

function GuildWarBattleRankPageData:GetIsFinish()
    return self.isFinish
end

function GuildWarBattleRankPageData:GetPageIdx(isBegin)
    if self.reqPageIdx then
        if self.lastUpdteTime then
            local curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
            if (curTime - self.lastUpdteTime) <= 1 then
                return nil
            end
        end
    end
    local reqPageIdx = nil
    if isBegin then
        if self.pageIdx then
            reqPageIdx = self.pageIdx - 1
        end
        if not reqPageIdx or reqPageIdx <= 0 then
            reqPageIdx = 1
        end
        if self.isFinish then
            if self.datas then
                if self.datas[1] then
                    reqPageIdx = nil
                elseif not self.validStartId or self.validStartId <= 1 then
                    reqPageIdx = nil
                end
            end
        end
    else
        if self.pageIdx then
            reqPageIdx = self.pageIdx + 1
        else
            reqPageIdx = 1
        end
        if self.isFinish then
            if self.isEnd then
                reqPageIdx = nil
            end
        end
    end
    self.reqPageIdx = reqPageIdx
    return reqPageIdx
end

return GuildWarBattleRankPageData