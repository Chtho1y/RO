local CompetitionData = class("CompetitionData", require("DataBase"))
local ProtocalDataNormal = require("ProtocalDataNormal")

local rankProcessParam, rankProcessParam1 = 0.75, 2000

function CompetitionData:ctor()
    self.data = {}
end

function CompetitionData:InitCurCompetitionData(data)
    local val = GlobalConfig.Instance:GetConfigStrValue(178)
    if val ~= "" and val ~= nil then
        local t = CommonUtil.DeserializeGlobalStrToTable(val)
        if t and t[1] then
            rankProcessParam = t[1][1] and tonumber(t[1][1])*0.0001 or 0.75
            rankProcessParam1 = t[1][2] and tonumber(t[1][2]) or 2000
        end
    end

    if data == nil then return end
    self.data.curCompetitionData = ProtocalDataNormal.ParseCompetitionData(data.cur_competition)
    self.data.rewardCompetitiGetIdxByIdonId = data.reward_competition_id
    self.data.rewardCompetitionSubId = data.reward_competition_sub_id
    self.data.SeasonItemList = self:GetAllSeasonItem()
    --LogError(Inspect(self.data.curCompetitionData))
end

function CompetitionData:GetAllSeasonItem()
    local list = {}
    local data = ManagerContainer.CfgMgr:GetCompetitionData()
    for k, v in pairs(data) do
        local itemList = v.HuodongItem
        if itemList and #itemList > 0 then
            for i = 1, #itemList do
                if list[v.CompetitionId] == nil then
                    list[v.CompetitionId] = {}
                end
               if list[v.CompetitionId][itemList[i]] == nil then
                list[v.CompetitionId][itemList[i]] = itemList[i]
               end 
            end
        end
    end
    return list
end
function CompetitionData:IsCurCompetitionItem(cfgid)
    local curid = self:GetCurCompetitionId()
    return self.data.SeasonItemList[curid] and self.data.SeasonItemList[curid][cfgid]
end

function CompetitionData:QueryCurCompetitionReq(ignore)
    if not ignore then
        local canOpen = self:CanOpenSeasonUI()
        if not canOpen then
            self._refreshSeason = false
            return
        end
    end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_COMPETITION_REQ, {competition_id = 0})
end

function CompetitionData:RefreshCompetitionData(data)
    if data == nil then return end
    local unlockState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(10)
    if not unlockState then return end

    local oldRank = self:GetCurSectionRank()
    self.data.curCompetitionData = ProtocalDataNormal.ParseCompetitionData(data.competition_data)
    self.data.nextCompetitionTime = data.next_competition_time
    if data.data then
        ManagerContainer.DataMgr.IdolData:InitRewardData(data.data)
    end
    self:RefreshCurCompetitionStage()

    local newRank = self:GetCurSectionRank()
    local type = 0
    if oldRank > 0 then
        if oldRank > newRank then
            type = 1
        elseif oldRank < newRank then
            type = 2
        end
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SEASON_RANK_CHANGED_NTF, type)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SEASON_EXCHANGE_NTF_MAIN)
end

--当前赛季是否结束
function CompetitionData:IsOveerCurSeason()
    local curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
    local curCompetitionData = self:GetCurCompetitionData()   
    if curTime >= curCompetitionData.curEndTime then
        return true
    end
    return false
end

function CompetitionData:RefreshCurCompetitionStage()
    local curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
    local nextTime = self:GetNextSeasonStartTime()
    self.nextSmallStageTime = nil
    local curCompetitionData = self:GetCurCompetitionData()
    if curCompetitionData.competitionId == 0 then
        self.stage = 1
        self.nextStageTime = nextTime
        self.curCompetitionId = 1
    elseif curCompetitionData.competitionId > 0 then
        if curTime <= curCompetitionData.curEndTime then
            self.stage = 2
            
            self.nextSmallStageTime = nil
            local idx = self:GetCurPeriodIdx()
            if idx then
                local periodData = self:GetCurPeriodData(idx)
                if periodData then
                    self.nextSmallStageTime = periodData.rewardEndTme
                end
            end
            if not self.nextSmallStageTime then
                self.nextSmallStageTime = curCompetitionData.curEndTime
            end
            self.nextStageTime = curCompetitionData.curEndTime
            self.curCompetitionId = curCompetitionData.competitionId
            local itemData = ManagerContainer.CfgMgr:GetCompetitionDatasByType(self.curCompetitionId)
            if itemData and itemData[1] then
                self.uiJumpId = itemData[1].UIJumpId
            end
        else
            self.stage = 3
            self.nextStageTime = nextTime
            self.curCompetitionId = curCompetitionData.competitionId
            if nextTime > 0 then
                local seasons = ManagerContainer.CfgMgr:GetCompetitionDatasByType(curCompetitionData.competitionId + 1)
                if #seasons > 0 then
                    local cfgData = seasons[1]
                    if cfgData.PrepareTime == -1 then
                        self.stage = 1
                    else
                        local hours = cfgData.PrepareTime * 3600*1000
                        local previewTime = nextTime - hours
                        if curTime >= previewTime and curTime < nextTime then
                            self.stage = 1
                            self.curCompetitionId = curCompetitionData.competitionId + 1
                        elseif curTime < previewTime then
                            self.nextStageTime = previewTime
                        end
                    end
                end
            end
        end
    end
end

function CompetitionData:GetCurStageAndNextTime(needRefresh)
    if needRefresh then
        self:RefreshCurCompetitionStage()
    end
    return self.stage, self.nextStageTime, self.nextSmallStageTime
end

function CompetitionData:GetCurCompetitionId()
    return self.curCompetitionId
end

function CompetitionData:GetUIJumpId()
    return self.uiJumpId or 0
end

function CompetitionData:GetUIJumpState()
    return self.uiJumpState or 0
end

function CompetitionData:SetUIJumpState(state)
    self.uiJumpState = state
end

function CompetitionData:GetCurSeasonTitle()
    local title = I18N.T("None")
    local titleIcon = nil;
    local competitionTitleIcon = nil;
    --local paramsList = self.data.curCompetitionData.paramList
    --title, titleIcon, competitionTitleIcon = CommonUtil.GetCurSeasonTitle(paramsList);
    return title, titleIcon, competitionTitleIcon
end

function CompetitionData:GetCurCompetitionData()
    return self.data.curCompetitionData
end

function CompetitionData:GetCurMaxSeason()
    return self.data.curCompetitionData.competitionId
end

function CompetitionData:GetNextSeasonStartTime()
    return self.data.nextCompetitionTime or 0
end

function CompetitionData:GetRankPercent()
    local totalRank = self.data.curCompetitionData.totalRank
    local selfRank = self.data.curCompetitionData.selfRank

    if selfRank == 0 or totalRank == 0 then
        return 0
    end
    if selfRank == 1 then
        return 100
    end
    --1- 实际排名 * 0.75 / MAX（总人数，500）
    return (1 - (selfRank*rankProcessParam)/math.max(totalRank, rankProcessParam1)) * 100
end

function CompetitionData:GetRank()
    return self.data and self.data.curCompetitionData and self.data.curCompetitionData.selfRank or 0
end

function CompetitionData:GetScore()
    return self.data and self.data.curCompetitionData and self.data.curCompetitionData.comParam or 0
end

function CompetitionData:SetRankAndScore(data)
    if self.data and self.data.curCompetitionData then
        self.data.curCompetitionData.comParam = data.score
        self.data.curCompetitionData.selfRank = data.rank
    end
end


function CompetitionData:GetCurPeriodIdx()
    local curCompetitionData = self.data.curCompetitionData
    if not curCompetitionData then return end
    local curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
    for i = 1, #curCompetitionData.rewardInfoList do
        local v = curCompetitionData.rewardInfoList[i]
        if v.rewardEndTme > curTime then
            return v.rewardIdx
        end
    end
    return nil
end

function CompetitionData:GetCurPeriodData(idx)
    local curCompetitionData = self.data.curCompetitionData
    if not curCompetitionData then return end

    for _,v in pairs(curCompetitionData.rewardInfoList) do
        if v.rewardIdx == idx then
            return v
        end
    end
    return nil
end

function CompetitionData:GetCurSectionRank()
    local idx = self:GetCurPeriodIdx()
    local periodData = self:GetCurPeriodData(idx)
    return periodData and periodData.paramList[1] or 0
end

function CompetitionData:SendExchangeScoreReq(itemList)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_COMPETITION_SCORE_REQ, {item_list = itemList})
end

--这个标记说明是不是仅仅数刷新赛季数据，如果是true那么只刷新数据，不打开界面
function CompetitionData:SetRefreshSeasonState(_state)
    self._refreshSeason = _state;
end

function CompetitionData:RefreshSecondData(data)
    local oldRank = self:GetCurSectionRank()

    local curCompetitionData = self.data.curCompetitionData
    curCompetitionData.comParam  = data.com_score
    curCompetitionData.nextComScore = data.next_com_score
    curCompetitionData.lastComScore = data.last_com_score
    curCompetitionData.selfRank  = data.self_rank
    curCompetitionData.totalRank  = data.total_rank

    local idx = self:GetCurPeriodIdx()
    local periodData = self:GetCurPeriodData(idx)
    if not periodData then
        return
    end
    periodData.paramList[1] = data.section_id

    local newRank = data.section_id
    local type = 0
    if oldRank > newRank then
        type = 1
    elseif oldRank < newRank then
        type = 2
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SEASON_RANK_CHANGED_NTF, type)
end

function CompetitionData:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_COMPETITION_NTF, function(data)
        self:RefreshCompetitionData(data)
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_COMPETITION_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SEASON_OPEN_NTF, data.competition_id, self._refreshSeason)
            self._refreshSeason = false;        --这个值是事先设置的，要想他生效每次调用的时候都要设置一下，然后这里返回消息之后自动设置未false
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_COMPETITION_SCORE_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            local oldScore = self.data.curCompetitionData.comParam
            self:RefreshSecondData(data)
            local newScore = self.data.curCompetitionData.comParam
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SEASON_EXCHANGE_NTF, newScore - oldScore)
        end
    end)
end

function CompetitionData:CanOpenSeasonUI()
    local curSeasonData = self:GetCurCompetitionData()
    if curSeasonData == nil then return false end

    local endTime = curSeasonData.curEndTime
    local curServerTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
    if endTime > 0 and endTime < curServerTime then
        local delta = (curServerTime - endTime)/1000
        local minutes = ManagerContainer.LuaTimerMgr:TransSeconds2Minutes(#delta)
        if minutes < 5 then
            ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("DscSeasonResult8")
            return false
        end
    end
    return true
end

function CompetitionData:UpdateCompetitionTime()
    local unlockState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(10)
    if not unlockState then return end

    local curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
    local nextTime = self:GetNextSeasonStartTime()
    local curCompetitionData = self:GetCurCompetitionData()
    if curCompetitionData.competitionId > 0 and curTime > curCompetitionData.curEndTime and nextTime == 0 then
        return
    end
    local stage, nextTime1 = self:GetCurStageAndNextTime()
    if stage == nil then
        self:SetRefreshSeasonState(true)
        self:QueryCurCompetitionReq(true)
        return
    end
    if curTime >= nextTime1 then
        self:SetRefreshSeasonState(true)
        self:QueryCurCompetitionReq(true)
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SEASON_MINUTE_UPDATE)
end

function CompetitionData:Clear()
    self.data = {}
end

function CompetitionData:Destroy()
    if self.Clear then
        self:Clear()
    end

    self:UnRegisterNetEvents()
end

function CompetitionData:UnRegisterNetEvents()

end

return CompetitionData