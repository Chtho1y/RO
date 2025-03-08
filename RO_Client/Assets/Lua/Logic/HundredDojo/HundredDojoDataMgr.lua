local HundredDojoDataMgr = class("HundredDojoDataMgr", require("DataBase"))
local HundredDojoAreaData = require('HundredDojo/HundredDojoAreaData')
local HundredDojoLogData = require('HundredDojo/HundredDojoLogData')
local CreateActorSystem = require("CreateActorSystem")

local REQ_CD = 1000

function HundredDojoDataMgr:ctor()
end

function HundredDojoDataMgr:Clear()
    self.challengeCount = 0
    self.buyChallengeCount = 0
    self.baseRewardTime = nil
    self.logState = false
    self.selfAreaData = nil
    self.tempAreaData = nil         -- 在自身未占道场数据时，用于填充数据进道场列表中
    self.areaDatas = nil
    self.areaMaxId = nil
    self.logData = nil
    self.rewardRedPoint = nil
    if self.rewardTimer then
        self.rewardTimer:Stop()
        self.rewardTimer = nil
    end
end

function HundredDojoDataMgr:Destroy()
    self.challengeCount = nil
    self.buyChallengeCount = nil
    self.baseRewardTime = nil
    self.logState = nil
    self.selfAreaData = nil
    self.tempAreaData = nil
    self.areaDatas = nil
    self.areaMaxId = nil
    self.logData = nil
    self.rewardRedPoint = nil
    if self.rewardTimer then
        self.rewardTimer:Stop()
        self.rewardTimer = nil
    end

    self.lastSendMsgTimeMap = nil
    self:UnRegisterNetEvents()
end

function HundredDojoDataMgr:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_DAO_CHANG100_DATA_CHANG_NTF, self.OnDataChangeNtf, self)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_DAO_CHANG100_PLAYER_INFO_ACK, self.OnAreaInfoAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_DAO_CHANG100_ACK, self.OnAreaInfosAck, self)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_DAO_CHANG100_LOG_ACK, self.OnBattleLogAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_DAO_CHANG100_TIME_REWARD_ACK, self.OnGetRewardAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_DAO_CHANG100_BUY_CHALLENGE_COUNT_ACK, self.OnBuyChallengeCountAck, self)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_DAO_CHANG100_CHALLENGE_ACK, self.OnChallengeAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_DAO_CHANG100_SET_TIPS_ACK, self.OnSloganAck, self)
end

function HundredDojoDataMgr:UnRegisterNetEvents()
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_DAO_CHANG100_DATA_CHANG_NTF)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_DAO_CHANG100_PLAYER_INFO_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_DAO_CHANG100_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_DAO_CHANG100_LOG_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_DAO_CHANG100_TIME_REWARD_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_DAO_CHANG100_BUY_CHALLENGE_COUNT_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_DAO_CHANG100_CHALLENGE_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_DAO_CHANG100_SET_TIPS_ACK)
end

function HundredDojoDataMgr:OnDataChangeNtf(data)
    -- LogError('[wboy] SC_DAO_CHANG100_DATA_CHANG_NTF ' .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end

    local changed, oldId, newId = self:ChangeSelfAreaData(data.self_pos_data)
    local challengeCount, buyChallengeCount, rewardTime, logState, lastBeAttackUid, slogan
    if data.ntf_data then
        local challengeCount1 = data.ntf_data.challenge_count or 0
        local challengeCount2 = data.ntf_data.challenge_buy_count or 0
        challengeCount = challengeCount1 + challengeCount2
        buyChallengeCount = data.ntf_data.buy_count or 0
        rewardTime = data.ntf_data.base_reward_time
        logState = data.ntf_data.log_state or false
        lastBeAttackUid = data.ntf_data.last_attack_uid
        slogan = data.ntf_data.tips_desc or ''
    else
        challengeCount = 0
        buyChallengeCount = 0
        rewardTime = nil
        logState = false
        lastBeAttackUid = nil
        slogan = ''
    end

    local changed1 = (self.challengeCount ~= challengeCount)
    local changed2 = (self.baseRewardTime ~= rewardTime)
    local changed3 = (self.logState ~= logState)
    -- local changed4 = (self.lastBeAttackUid ~= lastBeAttackUid)
    local changed5 = (self.slogan ~= slogan)

    self.challengeCount = challengeCount
    self.buyChallengeCount = buyChallengeCount
    self.baseRewardTime = rewardTime
    self.logState = logState
    self.lastBeAttackUid = lastBeAttackUid
    self.slogan = slogan

    if changed then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.HUNDRED_DOJO_SELF_AREA_DATA_CHANGED, oldId, newId)
    end
    if changed1 then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.HUNDRED_DOJO_CHALLENGE_NUM_CHANGED)
    end
    if changed2 then
        self:HandleRewardRedPoint()
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.HUNDRED_DOJO_BASE_TIME_CHANGED)
    end
    if changed3 then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.HundredDojo, logState)
    end
    if changed5 then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.HUNDRED_DOJO_SLOGAN_CHANGED)
    end
end

function HundredDojoDataMgr:OnAreaInfoAck(data)
    -- LogError('[wboy] SC_DAO_CHANG100_SELF_INFO_ACK ' .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    local uid = data.player_uid
    local areaId = nil
    if data.player_pos_data then
        areaId = data.player_pos_data.pos_idx
        if areaId and areaId <= 0 then
            areaId = nil
        end
    end
    if int64.equals(data.player_uid, ManagerContainer.DataMgr.UserData:GetUserId()) then
        local changed, oldId, newId = self:ChangeSelfAreaData(data.player_pos_data)
        if changed then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.HUNDRED_DOJO_SELF_AREA_DATA_CHANGED, oldId, newId)
        end
    else
        if data.player_pos_data then
            local id = data.player_pos_data.pos_idx
            local changed, oldId, newId = self:ChangeAreaData(self:GetAreaDataById(id), data.player_pos_data)
            if changed then
                local changedIds = {}
                if oldId then
                    changedIds[#changedIds + 1] = oldId
                end
                if newId and oldId ~= newId then
                    changedIds[#changedIds + 1] = newId
                end
                if #changedIds > 0 then
                    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.HUNDRED_DOJO_OTHER_AREA_DATA_CHANGED, changedIds)
                end
            end
        end
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.HUNDRED_DOJO_QUERY_AREA_DATA_COMPLETED, uid, areaId)
end

function HundredDojoDataMgr:OnAreaInfosAck(data)
    -- LogError('[wboy] SC_DAO_CHANG100_ACK ' .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    local changedIds = {}
    local areaInfos = data.pos_data_list
    if areaInfos then
        for i = 1, #areaInfos do
            local areaInfo = areaInfos[i]
            if areaInfo then
                local id = areaInfo.pos_idx
                local childChanged, oldId, newId = self:ChangeAreaData(self:GetAreaDataById(id), areaInfo)
                if childChanged then
                    if not CommonUtil.EleInTable(oldId, changedIds) then
                        changedIds[#changedIds + 1] = oldId
                    end
                    if oldId ~= newId then
                        if not CommonUtil.EleInTable(newId, changedIds) then
                            changedIds[#changedIds + 1] = newId
                        end
                    end
                end
            end
        end
    end
    if #changedIds > 0 then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.HUNDRED_DOJO_OTHER_AREA_DATA_CHANGED, changedIds)
    end
end

function HundredDojoDataMgr:OnBattleLogAck(data)
    -- LogError('[wboy] SC_DAO_CHANG100_LOG_ACK ' .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    if not self.logData then
        self.logData = HundredDojoLogData:new()
    end
    local changed, startChanged, endChanged = self.logData:SetLogs(data.log_list, data.is_end)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.HUNDRED_DOJO_LOG_CHANGED, changed, startChanged, endChanged)
end

function HundredDojoDataMgr:OnGetRewardAck(data)
    -- LogError('[wboy] SC_DAO_CHANG100_TIME_REWARD_ACK ' .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
    local rewardNum = data.reward_num
    local rewardList = data.reward_list
    if not rewardNum or rewardNum <= 0 or not rewardList or #rewardList <= 0 then
        ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(250)
        return
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.HUNDRED_DOJO_GET_REWARD_COMPLETED, rewardNum, rewardList)
end

function HundredDojoDataMgr:OnBuyChallengeCountAck(data)
    -- LogError('[wboy] SC_DAO_CHANG100_BUY_CHALLENGE_COUNT_ACK ' .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
end

function HundredDojoDataMgr:OnChallengeAck(data)
    --LogError('[wboy] SC_DAO_CHANG100_CHALLENGE_ACK ' .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        if data.challenge_pos_data then
            local _, changed, oldId, newId = self:ChangeAreaData(self:GetAreaDataById(data.pos_idx), data.challenge_pos_data)
            if changed then
                local changedIds = {}
                changedIds[#changedIds + 1] = oldId
                if newId ~= oldId then
                    changedIds[#changedIds + 1] = newId
                end
                ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.HUNDRED_DOJO_OTHER_AREA_DATA_CHANGED, changedIds)
            end
        end
        return
    end
    if data.challenge_pos_data then
        local _, changed, oldId, newId = self:ChangeAreaData(self:GetAreaDataById(data.pos_idx), data.challenge_pos_data)
        if changed then
            local changedIds = {}
            changedIds[#changedIds + 1] = oldId
            if newId ~= oldId then
                changedIds[#changedIds + 1] = newId
            end
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.HUNDRED_DOJO_OTHER_AREA_DATA_CHANGED, changedIds)
        end
    elseif data.fight_info then
        local actorSystem = CreateActorSystem:new()
        actorSystem:ParseFightRoleInfo(data.fight_info)
        self:EnterBattle(data.pos_idx, actorSystem)
    end
    self:ReportChallenge(true)
end

function HundredDojoDataMgr:ReportChallenge(success)
    if not SDKMgr.Instance:IsReportAction() then
        return
    end
    local datas = System.Collections.Generic.Dictionary_object_object()
    datas:Add('event', 'mj_daochang')
    datas:Add('is_achieve', (success and 1 or 0))
    SDKMgr.Instance:ReportAction(datas)
end

function HundredDojoDataMgr:OnSloganAck(data)
    -- LogError('[wboy] SC_DAO_CHANG100_SET_TIPS_ACK ' .. Inspect(data))
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end
end







function HundredDojoDataMgr:SendGetAreaInfoReq(uid)
    if not self:IsCanSend(1) then return false end
    if int64.equals(uid, ManagerContainer.DataMgr.UserData:GetUserId()) then
        if self.selfAreaData then
            self.selfAreaData:SetValidState(false)
        end
    end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_DAO_CHANG100_PLAYER_INFO_REQ, {player_uid = uid})
    return true
end

function HundredDojoDataMgr:SendGetOtherInfosReq(areaIds)
    if not self:IsCanSend(2) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_DAO_CHANG100_REQ, {pos_idx_list = areaIds})
    return true
end

function HundredDojoDataMgr:SendGetLogReq(beginTime)
    if not self:IsCanSend(3) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_DAO_CHANG100_LOG_REQ, {begin_time = beginTime})
    return true
end

function HundredDojoDataMgr:SendGetRewardReq()
    if not self:IsCanSend(4) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_DAO_CHANG100_TIME_REWARD_REQ)
    return true
end

function HundredDojoDataMgr:SendBuyChallengeNumReq()
    if not self:IsCanSend(5) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_DAO_CHANG100_BUY_CHALLENGE_COUNT_REQ)
    return true
end

function HundredDojoDataMgr:SendChallengeReq(id)
    if not self:IsCanSend(6) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_DAO_CHANG100_CHALLENGE_REQ, {pos_idx = id})
    return true
end

function HundredDojoDataMgr:SendChallengeResultReq(id, uid, battleTime, battleResult)
    if not self:IsCanSend(7) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_DAO_CHANG100_CHALLENGE_RESULT_REQ, {pos_idx = id, pos_uid = uid, battle_time = battleTime, battle_result = battleResult})
    return true
end

function HundredDojoDataMgr:SendChangeSlogan(slogan)
    if not self:IsCanSend(8) then return false end
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_DAO_CHANG100_SET_TIPS_REQ, {tip_desc = slogan})
    return true
end


function HundredDojoDataMgr:IsCanSend(key, cdTime)
    local curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
    if not self.lastSendMsgTimeMap then
        self.lastSendMsgTimeMap = {}
        self.lastSendMsgTimeMap[key] = curTime
        return true
    end
    local lastTime = self.lastSendMsgTimeMap[key]
    if lastTime then
        local cd = cdTime or REQ_CD
        if (curTime - lastTime) < cd then
            return false
        end
    end
    self.lastSendMsgTimeMap[key] = curTime
    return true
end

function HundredDojoDataMgr:InitData(data)
    if data then
        local challengeCount1 = data.challenge_count or 0
        local challengeCount2 = data.challenge_buy_count or 0
        self.challengeCount = challengeCount1 + challengeCount2
        self.buyChallengeCount = data.buy_count or 0
        self.baseRewardTime = data.base_reward_time
        self.logState = data.log_state or false
        self.lastBeAttackUid = data.last_attack_uid
        self.slogan = data.tips_desc or ''
    else
        self.challengeCount = 0
        self.buyChallengeCount = 0
        self.baseRewardTime = nil
        self.logState = false
        self.lastBeAttackUid = nil
        self.slogan = ''
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.HundredDojo, self.logState)
    self:HandleRewardRedPoint(true)
end

function HundredDojoDataMgr:HandleRewardRedPoint(first)
    local rewardMaxTime = GlobalConfig.Instance:GetConfigIntValue(255) * 3600
    local remainTime = 0
    if self.baseRewardTime and self.baseRewardTime > 0 then
        remainTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime() - self.baseRewardTime
        remainTime = remainTime / 1000
		if type(remainTime) == 'userdata' then
			remainTime = #remainTime
		end
    end
    if remainTime >= rewardMaxTime then
        if not self.rewardRedPoint then
            if self.rewardTimer then
                self.rewardTimer:Stop()
                self.rewardTimer = nil
            end
            self.rewardRedPoint = true
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.HundredDojoReward, true)
        end
    else
        remainTime = (rewardMaxTime - remainTime)
        if self.rewardRedPoint then
            self.rewardRedPoint = nil
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.HundredDojoReward, false)
        elseif first then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.HundredDojoReward, false)
        end
        if self.rewardTimer then
            self.rewardTimer.time = remainTime
            self.rewardTimer.duration = remainTime
        else
            self.rewardTimer = Timer.New(slot(self.HandleRewardRedPoint, self), remainTime, 1)
        end
        if not self.rewardTimer.running then
            self.rewardTimer:Start()
        end
    end
end


function HundredDojoDataMgr:ChangeSelfAreaData(msgData)
    local oldId = nil
    local newId = nil
    if self.selfAreaData then
        oldId = self.selfAreaData.id
        if oldId and oldId <= 0 then
            oldId = nil
        end
    else
        self.selfAreaData = HundredDojoAreaData:new()
    end
    if msgData then
        self.selfAreaData:SetData(msgData)
    else
        self.selfAreaData:Clear()
        self.selfAreaData:SetValidState(true)
    end
    newId = self.selfAreaData.id
    if newId and newId <= 0 then
        newId = nil
    end

    if not self.areaDatas then
        self.areaDatas = {}
    end
    if oldId ~= newId then
        if newId then
            local areaData = self.areaDatas[newId]
            if areaData then
                if oldId then
                    areaData:Clear()
                    areaData.id = oldId
                    areaData:SetValidState(true)
                    self.areaDatas[oldId] = areaData
                else
                    areaData:Dispose()
                    self.tempAreaData = areaData
                end
            end
            self.areaDatas[newId] = self.selfAreaData
        else
            local areaData = self.areaDatas[oldId]
            if areaData == self.selfAreaData then
                if not self.tempAreaData then
                    self.tempAreaData = HundredDojoAreaData:new()
                end
                self.tempAreaData.id = oldId
                self.tempAreaData:Clear()
                self.tempAreaData:SetValidState(true)
                self.areaDatas[oldId] = self.tempAreaData
                self.tempAreaData = nil
                self.selfAreaData:Clear()
                self.selfAreaData:SetValidState(true)
            else
                LogError('[wboy] data is expection self area data and areaDatas is not same. id : ' .. tostring(oldId))
            end
        end
    end
    return true, oldId, newId
end


function HundredDojoDataMgr:ChangeAreaData(areaData, msgData)
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
        areaData = HundredDojoAreaData:new()
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
    return changed, oldId, id
end

function HundredDojoDataMgr:GetAreaMaxId()
    if not self.areaMaxId then
        self.areaMaxId = 0
        for key, _ in pairs(ManagerContainer.CfgMgr:GetHundredDojoCfg()) do
            if key > self.areaMaxId then
                self.areaMaxId = key
            end
        end
    end
    return self.areaMaxId
end

function HundredDojoDataMgr:GetSelfAreaData()
    return self.selfAreaData
end

function HundredDojoDataMgr:GetAreaDataById(id)
    if not self.areaDatas then
        return nil
    end
    return self.areaDatas[id]
end

function HundredDojoDataMgr:GetChallengeCount()
    return self.challengeCount
end

function HundredDojoDataMgr:GetBuyChallengeCount()
    return self.buyChallengeCount
end

function HundredDojoDataMgr:GetBaseRewardStartTime()
    return self.baseRewardTime
end

function HundredDojoDataMgr:GetLogData()
    return self.logData
end

function HundredDojoDataMgr:GetLastBeAttackUid()
    return self.lastBeAttackUid
end

function HundredDojoDataMgr:GetSlogan()
    return self.slogan
end

function HundredDojoDataMgr:SetLogState(state)
    if self.logState ~= state then
        self.logState = state
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.HundredDojo, state)
    end
end













----------------------------------------- 战斗 -----------------------------------------
function HundredDojoDataMgr:EnterBattle(areaId, actorSystem)
    self.areaId = areaId
    self.actorSystem = actorSystem
    if not self.actorSystem.userData.inited then
        return
    end
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
        --设置压制ID
        --LogError("添加压制markid"..tostring(BuffId))
        selfMaskDatas = {}
        selfMaskDatas[1] = GvGMark.New(BuffId, 1)
    end

    local limitedTime = self:GetLimitedTime()
    local battleEndCondList = System.Array.CreateInstance(Enum.TypeInfo.BattleEndCondition, 2)
    battleEndCondList[0] = BattleEndCondition.New(Constants.EndBattle_By_UndeadCount, Constants.ResultType_Normal)
    battleEndCondList[1] = BattleEndCondition.New(Constants.EndBattle_By_BattleTime, limitedTime, Constants.ResultType_Normal, false)
    ManagerContainer.LuaGameMgr:EnterHundredDojo('scenes_test_pvp', self.ourMembers, self.enemyActors, limitedTime,selfMaskDatas,IsPresspoint,OurPvPVal+enemyPvPVal, battleEndCondList)
end

function HundredDojoDataMgr:BattleEnd(result)
    local battleTime = LuaBattleBridge.GetFightingTime()
    if battleTime < 0 then
        battleTime = 0
    else
        battleTime = Mathf.Ceil(battleTime)
    end
    self:SendChallengeResultReq(self.areaId, self.actorSystem and self.actorSystem:GetUserId() or nil, battleTime, (result == 1))
    self.actorSystem = nil
    self.matchFighterName = nil
    self.enemyActors = nil
    self.ourMembers = nil
end


function HundredDojoDataMgr:GetMatchFighterName()
    return self.matchFighterName
end

function HundredDojoDataMgr:GetOurMembers()
    return self.ourMembers
end

function HundredDojoDataMgr:GetEnemyMembers()
    return self.enemyActors
end

function HundredDojoDataMgr:GetLimitedTime()
    return GlobalConfig.Instance:GetConfigIntValue(251)
end

function HundredDojoDataMgr:GetLastAttackAreaId()
    return self.areaId
end

function HundredDojoDataMgr:ClearLastAttackAreaId()
    self.areaId = nil
end

return HundredDojoDataMgr