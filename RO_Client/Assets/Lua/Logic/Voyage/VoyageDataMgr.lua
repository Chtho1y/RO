local VoyageDataMgr = class("VoyageDataMgr", require("DataBase"))
local VoyageAirShipData = require('Voyage/VoyageAirShipData')
local CommonLogData = require('CommomLogData')
local CreateActorSystem = require('CreateActorSystem')

local REQ_GUILD_CD = 1000

local AirShipSort = function (a, b)
    if a.endTime == b.endTime then
        if a.quality == b.quality then
            return a.uid < b.uid
        else
            return a.quality < b.quality
        end
    end
    return a.endTime < b.endTime
end


function VoyageDataMgr:ctor()
    self.lastSendMsgTimeMap = nil           -- 发送消息的冷却时间，避免操作过快

    self.rpStatus = nil

    self.challengeNum = 0
    self.voyageNum = 0
    self.curAirShipId = 1

    self.notifyAirShipUpTip = false

    self.refreshAirShipResult = nil

    self:ClearLastAttackData()
    self.keepVoyageing = nil
    self:ClearViewListData()
    self.selfAirShipData = nil
    -- if self.selfAirShipCompleteTimer then
    --     self.selfAirShipCompleteTimer:Stop()
    --     self.selfAirShipCompleteTimer = nil
    -- end
    self:ClearLogData()
end

function VoyageDataMgr:Clear()
    self.lastSendMsgTimeMap = nil

    self.rpStatus = nil

    self.challengeNum = 0
    self.voyageNum = 0
    self.curAirShipId = 1

    self.notifyAirShipUpTip = false

    self.refreshAirShipResult = nil

    self:ClearLastAttackData()
    self.keepVoyageing = nil
    self:ClearViewListData()
    self.selfAirShipData = nil
    -- if self.selfAirShipCompleteTimer then
    --     self.selfAirShipCompleteTimer:Stop()
    --     self.selfAirShipCompleteTimer = nil
    -- end
    self:ClearLogData()
end

function VoyageDataMgr:Destroy()
    self.lastSendMsgTimeMap = nil

    self.rpStatus = nil

    self.challengeNum = nil
    self.voyageNum = nil
    self.curAirShipId = nil

    self.notifyAirShipUpTip = nil

    self.refreshAirShipResult = nil

    self:ClearLastAttackData()
    self.keepVoyageing = nil
    self:DisposeViewListData()
    self.selfAirShipData = nil
    -- if self.selfAirShipCompleteTimer then
    --     self.selfAirShipCompleteTimer:Stop()
    --     self.selfAirShipCompleteTimer = nil
    -- end
    self:ClearLogData()
    self:UnRegisterNetEvents()
end

function VoyageDataMgr:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CROSS_YUAN_HANG_TRIAL_DATA_NTF, self.OnVoyageSelfDataNtf, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CROSS_YUAN_HANG_TRIAL_VIEW_LIST_ACK, self.OnVoyageKeepAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CROSS_YUAN_HANG_TRIAL_VIEW_LIST_NTF, self.OnVoyageKeepNtf, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CROSS_YUAN_HANG_TRIAL_REFRESH_TRIAL_TYPE_ACK, self.OnVoyageRefreshAirShipAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CROSS_YUAN_HANG_TRIAL_ACK, self.OnVoyageTakeOffAirShipAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CROSS_YUAN_HANG_TRIAL_REWARD_ACK, self.OnVoyageGetRewardAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CROSS_YUAN_HANG_TRIAL_INFO_ACK, self.OnVoyageCheckInfoAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CROSS_YUAN_HANG_TRIAL_CHALLENGE_ACK, self.OnVoyageChallengeAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CROSS_YUAN_HANG_TRIAL_CHALLENGE_RESULT_ACK, self.OnVoyageChallengeResultAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CROSS_YUAN_HANG_TRIAL_RANK_LIST_ACK, self.OnVoyageRankDatasAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CROSS_YUAN_HANG_TRIAL_LOG_ACK, self.OnVoyageLogAck, self)
end

function VoyageDataMgr:UnRegisterNetEvents()
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_CROSS_YUAN_HANG_TRIAL_DATA_NTF)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_CROSS_YUAN_HANG_TRIAL_VIEW_LIST_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_CROSS_YUAN_HANG_TRIAL_VIEW_LIST_NTF)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_CROSS_YUAN_HANG_TRIAL_REFRESH_TRIAL_TYPE_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_CROSS_YUAN_HANG_TRIAL_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_CROSS_YUAN_HANG_TRIAL_REWARD_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_CROSS_YUAN_HANG_TRIAL_INFO_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_CROSS_YUAN_HANG_TRIAL_CHALLENGE_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_CROSS_YUAN_HANG_TRIAL_CHALLENGE_RESULT_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_CROSS_YUAN_HANG_TRIAL_RANK_LIST_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_CROSS_YUAN_HANG_TRIAL_LOG_ACK)
end

function VoyageDataMgr:IsCanSend(key, cdTime)
    local curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
    if not self.lastSendMsgTimeMap then
        self.lastSendMsgTimeMap = {}
        self.lastSendMsgTimeMap[key] = curTime
        return true
    end
    local lastTime = self.lastSendMsgTimeMap[key]
    if lastTime then
        local cd = cdTime or REQ_GUILD_CD
        if (curTime - lastTime) < cd then
            return false
        end
    end
    self.lastSendMsgTimeMap[key] = curTime
    return true
end

function VoyageDataMgr:OnVoyageSelfDataNtf(data)
    -- LogError("[wboy] SC_CROSS_YUAN_HANG_TRIAL_DATA_NTF " .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    data = data.yuanhangtrial_data
    self:RefreshSelfVoyageData(data)
end

function VoyageDataMgr:RefreshSelfVoyageData(data)
    if not data then
        return
    end
    local challengeNum = data.challenge_num or 0
    local voyageNum = data.trial_num or 0
    local curAirShipId = data.refresh_trial_type or 1
    local changed1 = (self.challengeNum ~= challengeNum)
    local changed2 = (self.voyageNum ~= voyageNum)
    local changed3 = (self.curAirShipId ~= curAirShipId)
    self.challengeNum = challengeNum
    self.voyageNum = voyageNum
    self.curAirShipId = curAirShipId

    self:RefreshSelfAirShip(data.trial_data)

    if changed1 then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.VOYAGE_CHALLENGE_NUM_CHANGED)
    end
    if changed2 then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.VOYAGE_NUM_CHANGED)
    end
    if changed3 then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.VOYAGE_AIRSHIP_CHANGED)
    end
    if self.rpStatus == nil or self.rpStatus then
        local rpStatus = (self.voyageNum < GlobalConfig.Instance:GetConfigIntValue(323))
        self:SetRpStatus(rpStatus)
    end
end

function VoyageDataMgr:RefreshSelfAirShip(data)
    local changed = true
    if data and data.uid and data.uid ~= 0 then
        if self.selfAirShipData then
            self.selfAirShipData:SetData(data)
            if not self.selfAirShipData:IsChange() then
                changed = false
            end
        else
            self.selfAirShipData = VoyageAirShipData:new(data)
        end
    else
        if self.selfAirShipData then
            self.selfAirShipData = nil
        else
            changed = false
        end
    end
    if changed then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.VOYAGE_SELF_AIRSHIP_DATA_CHANGED)
    end
    if self.selfAirShipData and not self.selfAirShipData.awardReceived then
        if self.selfAirShipData:IsChangeEndTime() then
            -- local curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
            -- local remindTime = (self.selfAirShipData.endTime - curTime) / 1000
            -- remindTime = type(remindTime) == "number" and remindTime or (#remindTime + 1)
            -- if not self.selfAirShipCompleteTimer then
            --     self.selfAirShipCompleteTimer = Timer.New(slot(self.CompleteSelfAirShip, self), remindTime, 1)
            -- else
            --     self.selfAirShipCompleteTimer.time = remindTime
            --     self.selfAirShipCompleteTimer.duration = remindTime
            --     self.selfAirShipCompleteTimer.loop = 1
            -- end
        end
        -- if self.selfAirShipCompleteTimer then
        --     if not self.selfAirShipCompleteTimer.running then
        --         self.selfAirShipCompleteTimer:Start()
        --     end
        -- end
    else
        -- if self.selfAirShipCompleteTimer then
        --     self.selfAirShipCompleteTimer:Stop()
        --     self.selfAirShipCompleteTimer = nil
        -- end
        -- self:CompleteSelfAirShip(true)
    end
end

-- function VoyageDataMgr:CompleteSelfAirShip(noRewards)
--     ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.VoyageCompleteReward, not noRewards)
-- end

function VoyageDataMgr:OnVoyageKeepAck(data)
    -- LogError("[wboy] SC_CROSS_YUAN_HANG_TRIAL_VIEW_LIST_ACK " .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    self:RefreshAirShipDatas(data.trial_view_list)
end

function VoyageDataMgr:OnVoyageKeepNtf(data)
    -- LogError("[wboy] SC_CROSS_YUAN_HANG_TRIAL_VIEW_LIST_NTF " .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    self:RefreshAirShipDatas(data.trial_view_list)
end

function VoyageDataMgr:RefreshAirShipDatas(list)
    local airShipDatas = self.airShipDatas
    local airShipDataMap = self.airShipDataMap
    local len = #airShipDatas
    local uid = nil
    local endTime = nil
    local airShipDataIdx = nil
    local airShipData = nil
    local needReset = false
    local curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
    local selfuid = ManagerContainer.DataMgr.UserData:GetUserId()
    for _, value in pairs(list) do
        uid = value.uid
        endTime = value.end_time_stamp
        -- 超出一分钟的数据就不管了
        if (endTime - curTime) > 60000 and selfuid ~= uid then
            if airShipDataMap[uid] then
                airShipData = airShipDataMap[uid]
                airShipData:SetData(value)
                if airShipData:IsChangeEndTime() then
                    needReset = true
                end
            else
                airShipData = VoyageAirShipData:new(value)
                len = len + 1
                airShipDatas[len] = airShipData
                airShipDataMap[uid] = airShipData
                needReset = true
            end
        end
    end
    if needReset then
        table.sort(airShipDatas, AirShipSort)
    end
    for i = len, 1, -1 do
        airShipData = airShipDatas[i]
        endTime = (airShipData.endTime - curTime)
        -- 超出一分钟的数据就不管了
        if endTime <= -60000 then
            table.remove(airShipDatas, i)
            airShipDataMap[airShipData.uid] = nil
            len = len - 1
        elseif endTime < 0 then
            -- 缓存数据过多，清理一下
            if len > 300 then
                table.remove(airShipDatas, i)
                airShipDataMap[airShipData.uid] = nil
                len = len - 1
            end
        else
            break
        end
    end
end

function VoyageDataMgr:OnVoyageRefreshAirShipAck(data)
    -- LogError("[wboy] SC_CROSS_YUAN_HANG_TRIAL_REFRESH_TRIAL_TYPE_ACK " .. Inspect(data))
    if not data then
        return
    end
    if not data.error or data.error == 0 then
        self.refreshAirShipResult = true
    elseif data.error == Enum.NetErrorCode.ERROR_CROSS_YUANHANGTRIAL_REFRESH_FAILED then
        self.refreshAirShipResult = false
    else
        self.refreshAirShipResult = false
    end
end

function VoyageDataMgr:OnVoyageTakeOffAirShipAck(data)
    -- LogError("[wboy] SC_CROSS_YUAN_HANG_TRIAL_ACK " .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    -- self:RefreshSelfAirShip(data.trial_data)
end

function VoyageDataMgr:OnVoyageGetRewardAck(data)
    -- LogError("[wboy] SC_CROSS_YUAN_HANG_TRIAL_REWARD_ACK " .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    CommonUtil.ACKShowRewardList(data.reward_list)
end

function VoyageDataMgr:OnVoyageCheckInfoAck(data)
    -- LogError("[wboy] SC_CROSS_YUAN_HANG_TRIAL_INFO_ACK " .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    if not data.trial_data then
        return
    end
    self:RefreshAirShipDatas({data.trial_data})
    local uid = data.trial_data.uid
    local airShipData = self:GetAirShipDataByUid(uid)
    if airShipData then
        airShipData:SetName(CommonUtil.GetVaildNickName(data.nick_name))
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.VOYAGE_CHECK_AIRSHIP_CHANGED, uid)
end

function VoyageDataMgr:OnVoyageChallengeAck(data)
    -- LogError("[wboy] SC_CROSS_YUAN_HANG_TRIAL_CHALLENGE_ACK " .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    local actorSystem = CreateActorSystem:new()
    actorSystem:ParseFightRoleInfo(data.fight_info)
    self:EnterBattle(data.challenge_uid, data.challenge_uid_end_time, actorSystem)
end

function VoyageDataMgr:OnVoyageChallengeResultAck(data)
    -- LogError("[wboy] SC_CROSS_YUAN_HANG_TRIAL_CHALLENGE_RESULT_ACK " .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        self.lastBattleRewards = nil
        return
    end
    local rewards = {}
    local rewardLs = data.reward_list
    if rewardLs then
        for i = 1, #rewardLs do
            local rewardData = rewardLs[i]
            rewards[#rewards + 1] = {rewardData.key, rewardData.value}
        end
    end
    self.lastBattleRewards = rewards
    self.lastBattleScores = {data.old_score, data.new_score}
    if self.waitChallengeResultTimer then
        self.waitChallengeResultTimer:Stop()
        self.waitChallengeResultTimer = nil
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.DOJO_CHALLENGE_RESULT_CHANGED)
end

function VoyageDataMgr:OnVoyageRankDatasAck(data)
    -- LogError("[wboy] SC_CROSS_YUAN_HANG_TRIAL_RANK_LIST_ACK " .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    self.selfRank = data.self_rank
    self.selfScore = data.self_score
    local rankDatas = self.rankDatas
    if not rankDatas then
        rankDatas = {}
        self.rankDatas = rankDatas
    end
    local rankLs = data.rank_list
    local rank = nil
    for i = 1, #rankLs do
        rank = rankLs[i]
        rankDatas[rank.rank] = {
            rank = rank.rank,
            playerBrief = ProtocalDataNormal.ParsePlayerBriefInfo(rank.brief_info),
            score = rank.score
        }
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.VOYAGE_RANK_CHANGED)
end

function VoyageDataMgr:OnVoyageLogAck(data)
    -- LogError("[wboy] SC_CROSS_YUAN_HANG_TRIAL_LOG_ACK " .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    if not self.logsData then
        self.logsData = CommonLogData:new()
    end
    local changed, startChanged, endChanged = self.logsData:SetLogs(data.log_list, data.is_end)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.VOYAGE_LOG_CHANGED, changed, startChanged, endChanged)
end


function VoyageDataMgr:SendKeepVoyageReq(isNew)
    -- if not self:IsCanSend(1) then
    --     return false
    -- end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CROSS_YUAN_HANG_TRIAL_VIEW_LIST_REQ, { notify = (not isNew) })
    -- return true
end

function VoyageDataMgr:SendExitVoyageReq()
    -- if not self:IsCanSend(2) then
    --     return false
    -- end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CROSS_YUAN_HANG_TRIAL_VIEW_LIST_OUT_REQ)
    -- return true
end

function VoyageDataMgr:SendRefreshAirShipReq(upHighest)
    if not self:IsCanSend(3) then
        return false
    end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CROSS_YUAN_HANG_TRIAL_REFRESH_TRIAL_TYPE_REQ, {force = upHighest})
    return true
end

function VoyageDataMgr:SendTakeOffAirShipReq()
    if not self:IsCanSend(4) then
        return false
    end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CROSS_YUAN_HANG_TRIAL_REQ)
    return true
end

function VoyageDataMgr:SendGetRewardReq()
    if not self:IsCanSend(5) then
        return false
    end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CROSS_YUAN_HANG_TRIAL_REWARD_REQ)
    return true
end

function VoyageDataMgr:SendCheckInfoReq(uid, endTime)
    if not self:IsCanSend(6) then
        return false
    end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CROSS_YUAN_HANG_TRIAL_INFO_REQ, { trial_uid = uid, trial_end_time = endTime })
    return true
end

function VoyageDataMgr:SendChallengeReq(uid, endTime)
    if not self:IsCanSend(7) then
        return false
    end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CROSS_YUAN_HANG_TRIAL_CHALLENGE_REQ, {challenge_uid = uid, challenge_uid_end_time = endTime})
    return true
end

function VoyageDataMgr:SendChallengeResultReq(uid, endTime, fightTime, isWin)
    if not self:IsCanSend(8) then
        return false
    end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CROSS_YUAN_HANG_TRIAL_CHALLENGE_RESULT_REQ, {challenge_uid = uid, challenge_uid_end_time = endTime, fight_time = fightTime, win = isWin})
    return true
end

function VoyageDataMgr:SendGetVoyageRankDatasReq(startIdx)
    if not self:IsCanSend(9) then
        return false
    end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CROSS_YUAN_HANG_TRIAL_RANK_LIST_REQ, { start_idx = startIdx })
    return true
end

function VoyageDataMgr:SendLogReq(logTime)
    if not self:IsCanSend(10) then
        return false
    end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CROSS_YUAN_HANG_TRIAL_LOG_REQ, { log_time = logTime })
    return true
end


function VoyageDataMgr:GetChallengeNum()
    return self.challengeNum
end

function VoyageDataMgr:GetVoyageNum()
    return self.voyageNum
end

function VoyageDataMgr:GetRpStatus()
    return self.rpStatus
end

function VoyageDataMgr:SetRpStatus(status)
    if self.rpStatus == status then
        return
    end
    self.rpStatus = status
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.VoyageCanChallage, status)
end

function VoyageDataMgr:GetCurAirShipId()
    return self.curAirShipId
end

function VoyageDataMgr:GetNotifyAirShipUpTip()
    return self.notifyAirShipUpTip
end

function VoyageDataMgr:SetNotifyAirShipUpTip(status)
    if self.notifyAirShipUpTip == status then
        return false
    end
    self.notifyAirShipUpTip = status
    return true
end

function VoyageDataMgr:GetRefreshAirShipResult()
    return self.refreshAirShipResult
end


function VoyageDataMgr:GetSelfAirShipData()
    return self.selfAirShipData
end


function VoyageDataMgr:SetKeepVoyageState(status)
    if self.keepVoyageing == status then
        return
    end
    self.keepVoyageing = status
    if status then
        if self.exitVoyageTimer then
            self.exitVoyageTimer:Stop()
            self.exitVoyageTimer = nil
        else
            self:SendKeepVoyageReq(true)
            self:ClearViewListData()
        end
        if not self.keepVoyageTimer then
            self.keepVoyageTimer = Timer.New(slot(self.SendKeepVoyageReq, self), 300, -1)
        else
            self.keepVoyageTimer.time = 300
        end
        if not self.keepVoyageTimer.running then
            self.keepVoyageTimer:Start()
        end
    else
        if self.keepVoyageTimer then
            self.keepVoyageTimer:Stop()
            self.keepVoyageTimer = nil
        end
        if not self.exitVoyageTimer then
            self.exitVoyageTimer = Timer.New(slot(self.ExitVoyage, self), 5, -1)
        else
            self.exitVoyageTimer.time = 5
        end
        if not self.exitVoyageTimer.running then
            self.exitVoyageTimer:Start()
        end
    end
end

function VoyageDataMgr:ExitVoyage()
    self:SendExitVoyageReq()
    self:ClearViewListData()
    self:ClearLogData()
end


function VoyageDataMgr:GetAirShipDatas()
    return self.airShipDatas
end

function VoyageDataMgr:GetAirShipDataByUid(uid)
    return self.airShipDataMap[uid]
end

function VoyageDataMgr:ClearViewListData()
    if self.keepVoyageTimer then
        self.keepVoyageTimer:Stop()
    end
    self.keepVoyageTimer = nil
    if self.exitVoyageTimer then
        self.exitVoyageTimer:Stop()
    end
    self.exitVoyageTimer = nil
    self.airShipDatas = {}
    self.airShipDataMap = {}
end

function VoyageDataMgr:DisposeViewListData()
    if self.keepVoyageTimer then
        self.keepVoyageTimer:Stop()
    end
    self.keepVoyageTimer = nil
    if self.exitVoyageTimer then
        self.exitVoyageTimer:Stop()
    end
    self.exitVoyageTimer = nil
    self.airShipDatas = nil
    self.airShipDataMap = nil
end

function VoyageDataMgr:GetSelfRank()
    return self.selfRank
end

function VoyageDataMgr:GetSelfScore()
    return self.selfScore
end

function VoyageDataMgr:GetRankDatas()
    return self.rankDatas
end

function VoyageDataMgr:ClearRankData()
    self.selfRank = nil
    self.selfScore = nil
    self.rankDatas = nil
end


function VoyageDataMgr:GetLogsData()
    return self.logsData
end

function VoyageDataMgr:ClearLogData()
    self.logsData = nil
end








----------------------------------------- 战斗 -----------------------------------------
function VoyageDataMgr:EnterBattle(attackUid, endTime, actorSystem)
    self:ClearLastAttackData()
    self.lastAttackUid = attackUid
    self.lastEndTime = endTime
    self.actorSystem = actorSystem
    ManagerContainer.LuaGameMgr:RefreshTeamData()
    self.matchFighterName = actorSystem:GetUserNickname()
    self.enemyActors = {}

    if actorSystem:GetPlayerActorParam() ~= nil then
        self.enemyActors[#self.enemyActors+1] = actorSystem:GetPlayerActorParam()
    end

    local fellowActors = actorSystem:GetFellowActorParam()
    if fellowActors ~= nil then
        for k,actor in pairs(fellowActors) do
            self.enemyActors[#self.enemyActors +1] = actor
        end
    end

    self.ourMembers = {}
    local actorData = ManagerContainer.LuaActorDataMgr:GetActorData(true, ManagerContainer.DataMgr.UserData:GetId())
    if actorData then
        self.ourMembers[#self.ourMembers + 1] = actorData
    end

    local list = ManagerContainer.DataMgr.PartnerData:GetPartnerDatas()
    if list ~= nil then
        for _,v in pairs(list) do
            if v.owned and v.isBattle then
                actorData = ManagerContainer.LuaActorDataMgr:GetActorData(false, v.configId)
                if actorData then
                    self.ourMembers[#self.ourMembers + 1] = actorData
                end
            end
        end
    end

    local selfMaskDatas = nil
    local enemyPvPVal = actorSystem:GetSkillPvPVal()
    local OurPvPVal = ManagerContainer.DataMgr.UserData:GetCurrRoleSkillPress()
    local IsPresspoint,BuffId = ManagerContainer.CfgMgr:GetPresspointPvPCfg(OurPvPVal,enemyPvPVal)   
    if BuffId > -1 then
        selfMaskDatas = {}
        selfMaskDatas[1] = GvGMark.New(BuffId, 1)
    end

    local limitedTime = self:GetLimitedTime()
    local battleEndCondList = System.Array.CreateInstance(Enum.TypeInfo.BattleEndCondition, 2)
    battleEndCondList[0] = BattleEndCondition.New(Constants.EndBattle_By_UndeadCount, Constants.ResultType_Normal)
    battleEndCondList[1] = BattleEndCondition.New(Constants.EndBattle_By_BattleTime, limitedTime, Constants.ResultType_Normal, false)
    ManagerContainer.LuaGameMgr:EnterVoyageBattle('scenes_test_pvp', self.ourMembers, self.enemyActors, limitedTime,selfMaskDatas,IsPresspoint,OurPvPVal+enemyPvPVal, battleEndCondList)
end

function VoyageDataMgr:BattleEnd(result)
    local battleTime = LuaBattleBridge.GetFightingTime()
    if battleTime < 0 then
        battleTime = 0
    else
        battleTime = Mathf.Ceil(battleTime)
    end
    self.lastBattleWin = result
    local isWin = (result == 1)
    if isWin then
        self:SendChallengeResultReq(self.lastAttackUid, self.lastEndTime, battleTime, isWin)
        if self.waitChallengeResultTimer then
            self.waitChallengeResultTimer.time = 5
            self.waitChallengeResultTimer.loop = 1
        else
            self.waitChallengeResultTimer = Timer.New(slot(self.ForceExitBattle, self), 5, 1)
        end
        if not self.waitChallengeResultTimer.running then
            self.waitChallengeResultTimer:Start()
        end
    end
    self.actorSystem = nil
    self.matchFighterName = nil
    self.enemyActors = nil
    self.ourMembers = nil
end

function VoyageDataMgr:ForceExitBattle()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.DOJO_CHALLENGE_RESULT_CHANGED)
end

function VoyageDataMgr:GetMatchFighterName()
    return self.matchFighterName
end

function VoyageDataMgr:GetOurMembers()
    return self.ourMembers
end

function VoyageDataMgr:GetEnemyMembers()
    return self.enemyActors
end

function VoyageDataMgr:GetLimitedTime()
    return GlobalConfig.Instance:GetConfigIntValue(251)
end

function VoyageDataMgr:GetLastAttackUid()
    return self.lastAttackUid
end

function VoyageDataMgr:GetLastBattleRewards()
    return self.lastBattleRewards
end

function VoyageDataMgr:GetLastBattleScores()
    return self.lastBattleScores
end

function VoyageDataMgr:GetLastBattleWin()
    return self.lastBattleWin
end

function VoyageDataMgr:ClearLastAttackData()
    self.lastAttackUid = nil
    self.lastEndTime = nil
    self.lastBattleRewards = nil
    self.lastBattleScores = nil
    self.lastBattleWin = nil
    if self.waitChallengeResultTimer then
        self.waitChallengeResultTimer:Stop()
        self.waitChallengeResultTimer = nil
    end
end

return VoyageDataMgr