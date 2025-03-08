local PetCollectBookData = class("PetCollectBookData")
local BitUtil = require("BitUtil")

function PetCollectBookData:ctor()
    self.data = {}

    self.totalCount = 0
    self.normalCount = 0
    self.miniCount = 0
    self.mvpCount = 0
    self.data.petManualMap = {}
end

function PetCollectBookData:InitData(pet_manual_list)
    if not pet_manual_list then return end
    for k,v in pairs(pet_manual_list) do
        local data = {}
        data.cfgId = v.pet_cfg_id
        data.advLevel = v.adv_level
        data.rewardState = v.reward_state
        if not self.data.petManualMap[data.cfgId] then
            self.totalCount = self.totalCount + 1
            local cfgId = 800 + data.cfgId
            local petCfgData = ManagerContainer.CfgMgr:GetPetDataById(cfgId)
            if petCfgData then
                if petCfgData.Quality == 1 then
                    self.normalCount = self.normalCount + 1
                elseif petCfgData.Quality == 2 then
                    self.miniCount = self.miniCount + 1
                elseif petCfgData.Quality == 3 then
                    self.mvpCount = self.mvpCount + 1
                end
            end
        end
        self.data.petManualMap[data.cfgId] = data
    end

    self:RefreshRedPoint()
end

function PetCollectBookData:RefreshRedPoint()
    for k, v in pairs(self.data.petManualMap) do
        local cfgId = v.cfgId + 800
        local state = v.rewardState
        local curAdvLv = v.advLevel
        local cfgData = ManagerContainer.CfgMgr:GetPetDataById(cfgId)
        if cfgData and cfgData.PetReward then
            for i = 1, #cfgData.PetReward do
                local adv = cfgData.PetReward[i][1]
                if curAdvLv >= adv then
                    local rewarded = BitUtil.RshiftNumBandOne(state, adv) == 1
                    if not rewarded then
                        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.PetCollection, true)
                        return
                    end
                end
            end
        end
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.PetCollection, false)
end

function PetCollectBookData:GetActivedPetCount(type)
    if type == Enum.CollectQualityType.ALL then
        return self.totalCount
    elseif type == Enum.CollectQualityType.NORMAL then
        return self.normalCount
    elseif type == Enum.CollectQualityType.MINIBOSS then
        return self.miniCount
    elseif type == Enum.CollectQualityType.MVP then
        return self.mvpCount
    end
    return 0
end

function PetCollectBookData:GetPetCollectBoolState(cfgId)
    local idx = cfgId - 800
    return self.data.petManualMap[idx] ~= nil
end

function PetCollectBookData:GetPetCollectRewardState(cfgId)
    local idx = cfgId - 800
    local state = self.data.petManualMap[idx] and self.data.petManualMap[idx].rewardState or 0
    local curAdvLv = self.data.petManualMap[idx] and self.data.petManualMap[idx].advLevel or 0
    return state, curAdvLv, self.data.petManualMap[idx] ~= nil
end

function PetCollectBookData:SendPetReward(cfgId, advLv, petId)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PET_MANUAL_REWARD_REQ, {pet_cfg_id = cfgId, pet_adv_level = advLv, pet_id = petId})
end

function PetCollectBookData:QueryFirstRank(cfgId)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PET_ADV_ACHIEVEMENT_REQ, {pet_cfg_id = cfgId})
end

function PetCollectBookData:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PET_MANUAL_REWARD_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            CommonUtil.ACKShowRewardList(data.reward_list)

            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PET_HANDBOOK_REWARD_REFRESH, data.pet_cfg_id)
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PET_ADV_ACHIEVEMENT_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            if data.brief then
                ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.CARD_HANDBOOK_RANK_REFRESH, data.brief, data.achievement_time)
            end
        end
    end)
end

function PetCollectBookData:Clear()
    self.data = {}

    self.totalCount = 0
    self.normalCount = 0
    self.miniCount = 0
    self.mvpCount = 0
    self.data.petManualMap = {}
end

function PetCollectBookData:Destroy()
    self.data = {}
    self:UnRegisterNetEvents()
end

function PetCollectBookData:UnRegisterNetEvents()
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_PET_MANUAL_REWARD_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_PET_ADV_ACHIEVEMENT_ACK)
end

return PetCollectBookData