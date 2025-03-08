local GuildWarDataMgr = class('GuildWarDataMgr', require('DataBase'))
local GuildWarMatchMapData = require('GuildWar/GuildWarMatchMapData')
local GuildWarBattleFieldData = require('GuildWar/GuildWarBattleFieldData')
local GuildWarBattleRankData = require('GuildWar/GuildWarBattleRankData')
local CreateActorSystem = require("CreateActorSystem")

local REQ_GUILD_CD = 1000

function GuildWarDataMgr:ctor()
end

function GuildWarDataMgr:Clear()
    if self.matchMapData then
        self.matchMapData:Clear()
        self.matchMapData = nil
    end
    if self.battleFieldData then
        self.battleFieldData:Clear()
        self.battleFieldData = nil
    end
    if self.battleRankData then
        self.battleRankData:Clear()
        self.battleRankData = nil
    end
    if self.battlingTimer then
        if self.battlingTimer.running then
            self.battlingTimer:Stop()
        end
        self.battlingTimer = nil
    end

    self.lastSendMsgTimeMap = nil
    self.isOpen = nil
    self.lastAttackBattleIdx = nil
    self.lastAttackAreaId = nil
    self.actorSystem = nil
    self.matchFighterName = nil
    self.ourMembers = nil
    self.enemyActors = nil
end

function GuildWarDataMgr:Destroy()
    self:UnRegisterNetEvents()
    self:Clear()
end

function GuildWarDataMgr:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_BATTLE_CP_RANK_ACK, self.OnGuildWarCPRankAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_BATTLE_STAGE_NTF, self.OnGuildWarDataStageNtf, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_BATTLE_COUNT_PART_ACK, self.OnGuildWarMatchMapAck, self)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_BATTLE_INFO_ACK, self.OnGuildWarFieldInfoAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_BATTLE_PK_DATA_ACK, self.OnGuildWarScoreDataAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_BATTLE_POS_IDX_LIST_ACK, self.OnGuildWarAreaDatasAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_BATTLE_DATA_CHANGE_NTF, self.OnGuildWarAreaDataNtf, self)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_BATTLE_CHALLENGE_ACK, self.OnGuildWarChallengeAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_BATTLE_CHALLENGE_NTF, self.OnGuildWarChallengeNtf, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_BATTLE_SETTING_ACK, self.OnGuildWarSettingAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_BATTLE_BUY_CHALLENGE_ACK, self.OnGuildWarBuyChallengeAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_BATTLE_REBORN_ACK, self.OnGuildWarBuyRebornAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_BATTLE_BUY_BUFF_ACK, self.OnGuildWarBuyBuffAck, self)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_BATTLE_LOG_ACK, self.OnGuildWarLogAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_GUILD_BATTLE_RANK_LIST_ACK, self.OnGuildWarRankAck, self)
end

function GuildWarDataMgr:UnRegisterNetEvents()
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GUILD_BATTLE_CP_RANK_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GUILD_BATTLE_STAGE_NTF)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GUILD_BATTLE_COUNT_PART_ACK)

    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GUILD_BATTLE_INFO_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GUILD_BATTLE_PK_DATA_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GUILD_BATTLE_POS_IDX_LIST_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GUILD_BATTLE_DATA_CHANGE_NTF)

    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GUILD_BATTLE_CHALLENGE_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GUILD_BATTLE_SETTING_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GUILD_BATTLE_BUY_CHALLENGE_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GUILD_BATTLE_REBORN_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GUILD_BATTLE_BUY_BUFF_ACK)

    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_GUILD_BATTLE_LOG_ACK)
end

function GuildWarDataMgr:IsCanSend(key, cdTime)
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

function GuildWarDataMgr:CheckErrorCode(data)
    if not data then
        return 1
    end
    if data.error and data.error ~= Enum.NetErrorCode.ERROR_OK then
		if data.error == Enum.NetErrorCode.ERROR_GUILDBATTLE_NOT_IN_GUILDBATTLE then
            self:SetOpenState(false)
            return 3
        elseif data.error == Enum.NetErrorCode.ERROR_GUILDBATTLE_CUR_BATTLE_FINISH then
            if self.battleFieldData then
                if self.battleFieldData:IsSameBattleField(data) then
                    if self.battleFieldData:ChangeFinishState(true) then
                        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_WAR_BATTLE_FIELD_ENDED, data.guild_battle_idx)
                        self:SendGuildWarScoreDataReq(data.guild_battle_idx)
                    end
                end
            end
            return 2
        end
        return 1
	end
    return 0
end


function GuildWarDataMgr:OnGuildWarCPRankAck(data)
    -- LogError("[wboy] GuildWarDataMgr:OnGuildBattleCPRankAck " .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_CP_RANK_LIST_CHANGED, data)
end

function GuildWarDataMgr:OnGuildWarDataStageNtf(data)
    -- LogError("[wboy] GuildWarDataMgr:OnGuildWarDataStageNtf " .. Inspect(data))
    if self:CheckErrorCode(data) ~= 0 then
        return
    end
    self:SetOpenState(data.in_guild_battle)
end

function GuildWarDataMgr:OnGuildWarMatchMapAck(data)
    -- LogError("[wboy] GuildWarDataMgr:OnGuildWarMatchMapAck " .. Inspect(data))
    if self:CheckErrorCode(data) ~= 0 then
        return
    end
    if not self.matchMapData then
        self.matchMapData = GuildWarMatchMapData:new()
    end
    self.matchMapData:InitData(data)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_WAR_MATCH_MAP_CHANGED)
end

function GuildWarDataMgr:OnGuildWarFieldInfoAck(data)
    -- LogError("[wboy] GuildWarDataMgr:OnGuildWarFieldInfoAck " .. Inspect(data))
    if self:CheckErrorCode(data) ~= 0 then
        return
    end
    local battleIdxChanged = false
    if not self.battleFieldData then
        self.battleFieldData = GuildWarBattleFieldData:new()
    else
        if not self.battleFieldData:IsSameBattleField(data) then
            battleIdxChanged = true
            self.battleFieldData:Clear()
            LogError('[wboy] FieldInfoAck, GuildWarBattleFieldData is not same !!!' .. tostring(self.battleFieldData.id) .. '     ' .. tostring(data.guild_battle_idx))
        end
    end
    self.battleFieldData:InitData(data)
    if data.challenge_pos_data then
        self.lastAttackBattleIdx = self.battleFieldData.id
        self.lastAttackAreaId = data.challenge_pos_data.pos_idx
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_WAR_BATTLE_FIELD_INFO_CHANGED, battleIdxChanged)
end

function GuildWarDataMgr:OnGuildWarScoreDataAck(data)
    -- LogError("[wboy] GuildWarDataMgr:OnGuildWarScoreDataAck " .. Inspect(data))
    local errorCode = self:CheckErrorCode(data)
    if errorCode ~= 0 and errorCode ~= 2 then
        return
    end
    if not self.battleFieldData then
        LogWarning('[wboy] ScoreDataAck, GuildWarBattleFieldData is null !!!')
        return
    end
    if not self.battleFieldData:IsSameBattleField(data) then
        LogError('[wboy] ScoreDataAck, GuildWarBattleFieldData is not same !!!' .. tostring(self.battleFieldData.id) .. '     ' .. tostring(data.guild_battle_idx))
        return
    end
    if self.battleFieldData:ChangeScoreData(data) then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_WAR_BATTLE_SCORE_DATA_CHANGED)
    end
end

function GuildWarDataMgr:ChangeGuildWarAreaData(changedIds, areaMsgData)
    if not areaMsgData then return end
    local areaId = areaMsgData.pos_idx
    local changed, oldId, newId, selfId = self.battleFieldData:ChangeAreaData(self.battleFieldData:GetAreaDataById(areaId), areaMsgData)
    if changed then
        if not changedIds then
            changedIds = {}
        end
        if oldId and not CommonUtil.EleInTable(oldId, changedIds) then
            changedIds[#changedIds + 1] = oldId
        end
        if newId and not CommonUtil.EleInTable(newId, changedIds) then
            changedIds[#changedIds + 1] = newId
        end
        if selfId and not CommonUtil.EleInTable(selfId, changedIds) then
            changedIds[#changedIds + 1] = selfId
        end
    end
    return changedIds
end

function GuildWarDataMgr:OnGuildWarAreaDatasAck(data)
    -- LogError("[wboy] GuildWarDataMgr:OnGuildWarAreaDatasAck " .. Inspect(data))
    if self:CheckErrorCode(data) ~= 0 then
        return
    end
    if not self.battleFieldData then
        LogWarning('[wboy] AreaDatasAck, GuildWarBattleFieldData is null !!!')
        return
    end
    if not self.battleFieldData:IsSameBattleField(data) then
        LogError('[wboy] AreaDatasAck, GuildWarBattleFieldData is not same !!!' .. tostring(self.battleFieldData.id) .. '     ' .. tostring(data.guild_battle_idx))
        return
    end
    local changedIds = nil
    local areaInfos = data.pos_data_list
    if areaInfos then
        for i = 1, #areaInfos do
            local areaInfo = areaInfos[i]
            if areaInfo then
                changedIds = self:ChangeGuildWarAreaData(changedIds, areaInfo)
            end
        end
    end
    if changedIds and #changedIds > 0 then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_WAR_BATTLE_AREA_DATA_CHANGED, changedIds)
    end
end

function GuildWarDataMgr:OnGuildWarAreaDataNtf(data)
    -- LogError("[wboy] GuildWarDataMgr:OnGuildWarAreaDataNtf " .. Inspect(data))
    if self:CheckErrorCode(data) ~= 0 then
        return
    end
    if not self.battleFieldData then
        LogWarning('[wboy] AreaDatasNtf, GuildWarBattleFieldData is null !!!')
        return
    end
    if not self.battleFieldData:IsSameBattleField(data) then
        LogError('[wboy] AreaDatasNtf, GuildWarBattleFieldData is not same !!!' .. tostring(self.battleFieldData.id) .. '     ' .. tostring(data.guild_battle_idx))
        return
    end
    self.battleFieldData:ChangeSelfData(data)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_WAR_BATTLE_SELF_DATA_CHANGED, false)
    local areaInfo = data.pos_data
    local changedIds = nil
    changedIds = self:ChangeGuildWarAreaData(changedIds, areaInfo)
    if changedIds and #changedIds > 0 then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_WAR_BATTLE_AREA_DATA_CHANGED, changedIds)
    end
end

function GuildWarDataMgr:OnGuildWarChallengeAck(data)
    -- LogError("[wboy] GuildWarDataMgr:OnGuildWarChallengeAck " .. Inspect(data))
    if not self.battleFieldData then
        LogWarning('[wboy] ChallengeAck, GuildWarBattleFieldData is null !!!')
        return
    end
    if not self.battleFieldData:IsSameBattleField(data) then
        LogError('[wboy] ChallengeAck, GuildWarBattleFieldData is not same !!!' .. tostring(self.battleFieldData.id) .. '     ' .. tostring(data.guild_battle_idx))
        return
    end
    if self:CheckErrorCode(data) ~= 0 then
        if data.challenge_pos_data then
            local changedIds = nil
            changedIds = self:ChangeGuildWarAreaData(changedIds, data.challenge_pos_data)
            if changedIds and #changedIds > 0 then
                ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_WAR_BATTLE_AREA_DATA_CHANGED, changedIds)
            end
        end
        return
    end
    if data.challenge_pos_data then
        local changedIds = nil
        changedIds = self:ChangeGuildWarAreaData(changedIds, data.challenge_pos_data)
        if changedIds and #changedIds > 0 then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_WAR_BATTLE_AREA_DATA_CHANGED, changedIds)
        end
    elseif data.fight_info then
        local actorSystem = CreateActorSystem:new()
        actorSystem:ParseFightRoleInfo(data.fight_info)
        self:EnterBattle(data.guild_battle_idx, data.pos_idx, actorSystem, data.self_buff_list, data.fight_buff_list)
    end
end

function GuildWarDataMgr:OnGuildWarChallengeNtf(data)
    -- LogError("[wboy] GuildWarDataMgr:OnGuildWarChallengeNtf " .. Inspect(data))
    if self:CheckErrorCode(data) ~= 0 then
        return
    end
    if not self.battleFieldData then
        LogWarning('[wboy] ChallengeNtf, GuildWarBattleFieldData is null !!!')
        return
    end
    if not self.battleFieldData:IsSameBattleField(data) then
        LogError('[wboy] ChallengeNtf, GuildWarBattleFieldData is not same !!!' .. tostring(self.battleFieldData.id) .. '     ' .. tostring(data.guild_battle_idx))
        return
    end
    self.battleFieldData:ChangeSelfData(data)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_WAR_BATTLE_SELF_DATA_CHANGED, false)

    local areaInfo = data.pos_data
    local changedIds = nil
    changedIds = self:ChangeGuildWarAreaData(changedIds, areaInfo)
    if changedIds and #changedIds > 0 then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_WAR_BATTLE_AREA_DATA_CHANGED, changedIds)
    end
end

function GuildWarDataMgr:OnGuildWarSettingAck(data)
    -- LogError("[wboy] GuildWarDataMgr:OnGuildWarSettingAck " .. Inspect(data))
    if self:CheckErrorCode(data) ~= 0 then
        return
    end
    if not self.battleFieldData then
        LogWarning('[wboy] SettingAck, GuildWarBattleFieldData is null !!!')
        return
    end
    if not self.battleFieldData:IsSameBattleField(data) then
        LogError('[wboy] SettingAck, GuildWarBattleFieldData is not same !!!' .. tostring(self.battleFieldData.id) .. '     ' .. tostring(data.guild_battle_idx))
        return
    end
    self.battleFieldData:ChangeSelfData(data)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_WAR_BATTLE_SELF_DATA_CHANGED, false)
end

function GuildWarDataMgr:OnGuildWarBuyChallengeAck(data)
    -- LogError("[wboy] GuildWarDataMgr:OnGuildWarBuyChallengeAck " .. Inspect(data))
    if self:CheckErrorCode(data) ~= 0 then
        return
    end
    if not self.battleFieldData then
        LogWarning('[wboy] BuyChallengeAck, GuildWarBattleFieldData is null !!!')
        return
    end
    if not self.battleFieldData:IsSameBattleField(data) then
        LogError('[wboy] BuyChallengeAck, GuildWarBattleFieldData is not same !!!' .. tostring(self.battleFieldData.id) .. '     ' .. tostring(data.guild_battle_idx))
        return
    end
    self.battleFieldData:ChangeSelfData(data)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_WAR_BATTLE_SELF_DATA_CHANGED, false)
end

function GuildWarDataMgr:OnGuildWarBuyRebornAck(data)
    -- LogError("[wboy] GuildWarDataMgr:OnGuildWarBuyRebornAck " .. Inspect(data))
    if self:CheckErrorCode(data) ~= 0 then
        return
    end
    if not self.battleFieldData then
        LogWarning('[wboy] BuyRebornAck, GuildWarBattleFieldData is null !!!')
        return
    end
    if not self.battleFieldData:IsSameBattleField(data) then
        LogError('[wboy] BuyRebornAck, GuildWarBattleFieldData is not same !!!' .. tostring(self.battleFieldData.id) .. '     ' .. tostring(data.guild_battle_idx))
        return
    end
    self.battleFieldData:ChangeSelfData(data)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_WAR_BATTLE_SELF_DATA_CHANGED, false)
end

function GuildWarDataMgr:OnGuildWarBuyBuffAck(data)
    -- LogError("[wboy] GuildWarDataMgr:OnGuildWarBuyBuffAck " .. Inspect(data))
    if self:CheckErrorCode(data) ~= 0 then
        return
    end
    if not self.battleFieldData then
        LogWarning('[wboy] BuyBuffAck, GuildWarBattleFieldData is null !!!')
        return
    end
    if not self.battleFieldData:IsSameBattleField(data) then
        LogError('[wboy] BuyBuffAck, GuildWarBattleFieldData is not same !!!' .. tostring(self.battleFieldData.id) .. '     ' .. tostring(data.guild_battle_idx))
        return
    end
    self.battleFieldData:ChangeSelfData(data)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_WAR_BATTLE_SELF_DATA_CHANGED, false)
end

function GuildWarDataMgr:OnGuildWarLogAck(data)
    -- LogError("[wboy] GuildWarDataMgr:OnGuildWarLogAck " .. Inspect(data))
    if self:CheckErrorCode(data) ~= 0 then
        return
    end
    if not self.battleFieldData then
        LogWarning('[wboy] LogAck, GuildWarBattleFieldData is null !!!')
        return
    end
    if not self.battleFieldData:IsSameBattleField(data) then
        LogError('[wboy] LogAck, GuildWarBattleFieldData is not same !!!' .. tostring(self.battleFieldData.id) .. '     ' .. tostring(data.guild_battle_idx))
        return
    end
    local changed, startChanged, endChanged = self.battleFieldData:SetLogs(data.log_list, data.is_end)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_WAR_BATTLE_LOG_DATA_CHANGED, changed, startChanged, endChanged)
end

function GuildWarDataMgr:OnGuildWarRankAck(data)
    -- LogError("[wboy] GuildWarDataMgr:OnGuildWarRankAck " .. Inspect(data))
    if self:CheckErrorCode(data) ~= 0 then
        return
    end
    if self.battleRankData then
        if not self.battleRankData:IsSameBattleField(data) then
            LogError('[wboy] RankAck, GuildWarBattleRankData is not same !!!' .. tostring(self.battleRankData.id) .. '     ' .. tostring(data.guild_battle_idx))
            return
        end
    else
        self.battleRankData = GuildWarBattleRankData:new()
    end
    self.battleRankData:SetData(data)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_WAR_BATTLE_RANK_DATA_CHANGED)
end









function GuildWarDataMgr:SendGuildWarCPRankReq()
    if not self:IsCanSend(1) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GUILD_BATTLE_CP_RANK_REQ)
    return true
end

function GuildWarDataMgr:SendGetGuildWarMatchMapReq()
    if not self:IsCanSend(2) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GUILD_BATTLE_COUNT_PART_REQ)
    return true
end

function GuildWarDataMgr:SendGuildWarInfoReq(battleIdx)
    if not self:IsCanSend(3) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GUILD_BATTLE_INFO_REQ, {guild_battle_idx = battleIdx})
    return true
end

function GuildWarDataMgr:SendGuildWarScoreDataReq(battleIdx)
    if not self:IsCanSend(4) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GUILD_BATTLE_PK_DATA_REQ, {guild_battle_idx = battleIdx})
    return true
end

function GuildWarDataMgr:SendGuildWarAreaDatasReq(battleIdx, areaIds)
    if not self:IsCanSend(5) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GUILD_BATTLE_POS_IDX_LIST_REQ, {guild_battle_idx = battleIdx, pos_idx_list = areaIds})
    return true
end

function GuildWarDataMgr:SendGuildWarChallengeReq(battleIdx, areaId)
    if not self:IsCanSend(6) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GUILD_BATTLE_CHALLENGE_REQ, {guild_battle_idx = battleIdx, pos_idx = areaId})
    return true
end

function GuildWarDataMgr:SendGuildWarChallengeStayReq(battleIdx, areaId)
    if not self:IsCanSend(7) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GUILD_BATTLE_CHALLENGE_PING_REQ, {guild_battle_idx = battleIdx, pos_idx = areaId})
    return true
end

function GuildWarDataMgr:SendGuildWarChallengeResultReq(battleIdx, areaId, uid, battleTime, battleResult)
    if not self:IsCanSend(8) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GUILD_BATTLE_CHALLENGE_RESULT_REQ, {guild_battle_idx = battleIdx, pos_idx = areaId, pos_uid = uid, battle_time = battleTime, battle_result = battleResult})
    return true
end

function GuildWarDataMgr:SendGuildWarSettingReq(battleIdx, autoChallenge, autoReborn)
    if not self:IsCanSend(9) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GUILD_BATTLE_SETTING_REQ, {guild_battle_idx = battleIdx, auto_challenge = autoChallenge, auto_reborn = autoReborn})
    return true
end
function GuildWarDataMgr:SendGuildWarBuyChallengeNumReq(battleIdx)
    if not self:IsCanSend(10) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GUILD_BATTLE_BUY_CHALLENGE_REQ, {guild_battle_idx = battleIdx})
    return true
end

function GuildWarDataMgr:SendGuildWarBuyRebornReq(battleIdx)
    if not self:IsCanSend(11) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GUILD_BATTLE_REBORN_REQ, {guild_battle_idx = battleIdx})
    return true
end

function GuildWarDataMgr:SendGuildWarBuyBuffReq(battleIdx, buffId)
    if not self:IsCanSend(12) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GUILD_BATTLE_BUY_BUFF_REQ, {guild_battle_idx = battleIdx, buff_id_list = {buffId}})
    return true
end

function GuildWarDataMgr:SendGuildWarLogReq(battleIdx, beginTime)
    if not self:IsCanSend(13) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GUILD_BATTLE_LOG_REQ, {guild_battle_idx = battleIdx, begin_time = beginTime})
    return true
end

function GuildWarDataMgr:SendGuildWarRankReq(battleIdx, rankType, pageIdx)
    if not self:IsCanSend(14, 0.5) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GUILD_BATTLE_RANK_LIST_REQ, {guild_battle_idx = battleIdx, rank_type = rankType, page_idx = pageIdx})
    return true
end







function GuildWarDataMgr:GetOpenState()
    return self.isOpen
end

function GuildWarDataMgr:SetOpenState(state)
    if self.isOpen == state then
        return
    end
    self.isOpen = state
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GUILD_WAR_OPEN_STATE_CHANGED, state)
end

function GuildWarDataMgr:GetMatchMapData()
    return self.matchMapData
end

function GuildWarDataMgr:GetBattleFieldData()
    return self.battleFieldData
end

function GuildWarDataMgr:GetBattleRankData()
    return self.battleRankData
end

function GuildWarDataMgr:ClearBattleRankData()
    self.battleRankData = nil
end


----------------------------------------- 战斗 -----------------------------------------
function GuildWarDataMgr:EnterBattle(battleId, areaId, actorSystem, selfBuffs, fightBuffs)
    self.lastAttackBattleIdx = battleId
    self.lastAttackAreaId = areaId
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
    local len = nil
    local buff = nil
    local selfMaskDatas = nil
    if selfBuffs then
        len = #selfBuffs
        selfMaskDatas = {}
        for i = 1, len do
            buff = selfBuffs[i]
            local cfgData = ManagerContainer.CfgMgr:GetGuildWarBuffCfgById(buff.key)
            if cfgData then
                selfMaskDatas[#selfMaskDatas + 1] = GvGMark.New(cfgData.Mark, buff.value)
            end
        end
    end

    local enemyPvPVal = actorSystem:GetSkillPvPVal()
    local OurPvPVal = ManagerContainer.DataMgr.UserData:GetCurrRoleSkillPress()
    local IsPresspoint,BuffId = ManagerContainer.CfgMgr:GetPresspointPvPCfg(OurPvPVal,enemyPvPVal)
    if BuffId > -1 then
        if nil == selfMaskDatas then
            selfMaskDatas = {}
        end
        --设置压制ID
        --LogError("添加压制markid"..tostring(BuffId))
        selfMaskDatas[#selfMaskDatas + 1] = GvGMark.New(BuffId, 1)
    end

    local fightMaskDatas = nil
    if fightBuffs then
        len = #fightBuffs
        fightMaskDatas = {}
        for i = 1, len do
            buff = fightBuffs[i]
            local cfgData = ManagerContainer.CfgMgr:GetGuildWarBuffCfgById(buff.key)
            if cfgData then
                fightMaskDatas[#fightMaskDatas + 1] = GvGMark.New(cfgData.Mark, buff.value)
            end
        end
    end
    local limitedTime = self:GetLimitedTime()
    local battleEndCondList = System.Array.CreateInstance(Enum.TypeInfo.BattleEndCondition, 2)
    battleEndCondList[0] = BattleEndCondition.New(Constants.EndBattle_By_UndeadCount, Constants.ResultType_Normal)
    battleEndCondList[1] = BattleEndCondition.New(Constants.EndBattle_By_BattleTime, limitedTime, Constants.ResultType_Normal, false)
    ManagerContainer.LuaGameMgr:EnterGvGBattle('scenes_test_pvp', self.ourMembers, self.enemyActors, limitedTime, battleEndCondList, selfMaskDatas, fightMaskDatas,IsPresspoint,OurPvPVal+enemyPvPVal)
end

function GuildWarDataMgr:StartStayBatting()
    if not self.battlingTimer then
        self.battlingTimer = Timer.New(slot(self.UploadBatting, self), 30, -1)
    end
    if not self.battlingTimer.running then
        self.battlingTimer:Start()
    end
    self:UploadBatting()
end

function GuildWarDataMgr:UploadBatting()
    self:SendGuildWarChallengeStayReq(self.lastAttackBattleIdx, self.lastAttackAreaId)
end

function GuildWarDataMgr:BattleEnd(result)
    if self.battlingTimer and self.battlingTimer.running then
        self.battlingTimer:Stop()
    end
    local battleTime = LuaBattleBridge.GetFightingTime()
    if battleTime < 0 then
        battleTime = 0
    else
        battleTime = Mathf.Ceil(battleTime)
    end
    self:SendGuildWarChallengeResultReq(self.lastAttackBattleIdx, self.lastAttackAreaId, self.actorSystem and self.actorSystem:GetUserId() or nil, battleTime, (result == 1))
    self.actorSystem = nil
    self.matchFighterName = nil
    self.enemyActors = nil
    self.ourMembers = nil
end


function GuildWarDataMgr:GetMatchFighterName()
    return self.matchFighterName
end

function GuildWarDataMgr:GetOurMembers()
    return self.ourMembers
end

function GuildWarDataMgr:GetEnemyMembers()
    return self.enemyActors
end

function GuildWarDataMgr:GetLimitedTime()
    return GlobalConfig.Instance:GetConfigIntValue(251)
end

function GuildWarDataMgr:GetLastAttackBattleIdx()
    return self.lastAttackBattleIdx
end

function GuildWarDataMgr:GetLastAttackAreaId()
    return self.lastAttackAreaId
end

function GuildWarDataMgr:ClearLastAttackInfo()
    self.lastAttackBattleIdx = nil
    self.lastAttackAreaId = nil
end

return GuildWarDataMgr