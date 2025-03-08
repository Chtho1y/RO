local PetDataMgr = class("PetDataMgr",require("DataBase"))
local PetAttrData = require("Pet/PetAttrData")
local PetRelationData = require("Pet/PetRelationData")
local PetCollectBookData = require("Pet/PetCollectBookData")
local PetStampData = require("Pet/PetStampData")

function PetDataMgr:ctor()
    self.data = {}

    self.petAttrData = PetAttrData:new()
    self.petRelationData = PetRelationData:new()
    self.petCollectBookData = PetCollectBookData:new()
    self.petStampData = PetStampData:new()
end

function PetDataMgr:InitData()

end

function PetDataMgr:GetPetDatas()
    return self.petAttrData:GetPetDatas()
end

function PetDataMgr:GetPetDataById(id)
    return self.petAttrData:GetPetDataById(id)
end
function PetDataMgr:GetPetCountById(id)
    return self.petAttrData:GetPetCountById(id)
end

function PetDataMgr:GetPetDataByIdAndLv(id,lv,skillLv)
    return self.petAttrData:GetPetDataByIdAndLv(id,lv,skillLv)
end

function PetDataMgr:GetPetDataByQulityAndLv(quality,lv,skillLv)
    return self.petAttrData:GetPetDataByQulityAndLv(quality,lv,skillLv)
end

function PetDataMgr:GetPetCountByIdAndLv(id,lv,skillLv)
    return self.petAttrData:GetPetCountByIdAndLv(id,lv,skillLv)
end

function PetDataMgr:GetPetCountByQulityAndLv(quality,lv,skillLv)
    return self.petAttrData:GetPetCountByQulityAndLv(quality,lv,skillLv)
end

function PetDataMgr:GetPetActorData(id)
    return self.petAttrData:GetPetActorData(id)
end

function PetDataMgr:SendPetLvUp(id)
    return self.petAttrData:SendPetLvUp(id)
end

function PetDataMgr:SendPetAdvence(id, costList)
    return self.petAttrData:SendPetAdvence(id, costList)
end

function PetDataMgr:GetNextSortId(id, isAdd)
    return self.petAttrData:GetNextSortId(id, isAdd)
end

function PetDataMgr:SendPetDecompose(ids)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PET_DECOMPOSE_REQ, {pet_id_list = ids})
end

function PetDataMgr:SendPetSkillUp(id, matId)
    self.petAttrData:SendPetSkillUp(id, matId)
end

function PetDataMgr:SendPetBattle(map)
    self.petAttrData:SendPetBattle(map)
end

function PetDataMgr:QueryPetRelation()
    self.petRelationData:QueryPetRelation()
end

function PetDataMgr:GetAllPetRelationDatas()
    return self.petRelationData:GetAllPetRelationDatas()
end

function PetDataMgr:GetPetRelationDataByCfgId(cfgId)
    return self.petRelationData:GetPetRelationDataByCfgId(cfgId)
end

function PetDataMgr:GetRelationPlayerNameByUid(uid)
    return self.petRelationData:GetRelationPlayerNameByUid(uid)
end

function PetDataMgr:QueryAssistList(cfgId)
    return self.petRelationData:QueryAssistList(cfgId)
end

function PetDataMgr:GetCurFriendSupportDatas()
    return self.petRelationData:GetCurFriendSupportDatas()
end

function PetDataMgr:GetMySupportPets()
    return self.petRelationData:GetMySupportPets()
end

function PetDataMgr:SendMySupport(list)
    return self.petRelationData:SendMySupport(list)
end

function PetDataMgr:DeleteMySupportPets(list)
    self.petRelationData:DeleteMySupportPets(list)
end

function PetDataMgr:SendPetRelationActive(datas)
    return self.petRelationData:SendPetRelationActive(datas)
end

function PetDataMgr:GetReplacePetRelationDataByUidAndPetId(uid, petId)
    return self.petRelationData:GetReplacePetRelationDataByUidAndPetId(uid,petId)
end

function PetDataMgr:GetMySupportSlotCDTime(idx)
    return self.petRelationData:GetMySupportSlotCDTime(idx)
end

function PetDataMgr:QueryFirstRank(cfgId)
    self.petCollectBookData:QueryFirstRank(cfgId)
end

function PetDataMgr:RefreshAllPetRPState()
    local petDatas = self:GetPetDatas()
    for _,v in pairs(petDatas) do
        ManagerContainer.RedPointMgr.PetRPCtr:GetPetCultivatingState(v.id)
    end

    ManagerContainer.RedPointMgr.PetRPCtr:RefreshRelationRPState()
    ManagerContainer.RedPointMgr.PetRPCtr:RefreshPetStampRPState()
end

function PetDataMgr:RefreshMasterAttr(id)
    self.petAttrData:RefreshMasterAttr(id)
end

function PetDataMgr:GetPetCurSkillTotalFightPower(id)
    local petData = self:GetPetDataById(id)
    if not petData then
        return 0
    end
    local totalPower = 0
    for _,v in pairs(petData.skillList) do
        local cfgId = v.cfgId
        local level = v.level
        local cfgData = ManagerContainer.CfgMgr:GetSkillCfgById(cfgId)
        if cfgData then
            totalPower = totalPower + level * cfgData.AddFight
        end
    end
    return math.floor(totalPower/10)
end

function PetDataMgr:GetPetStampTotalFightPower(id)
    local petData = self:GetPetDataById(id)
    if not petData then
        return 0
    end
    local totalPower = 0
    for _,v in pairs(petData.slots) do
        local id = v.stampId
        local stampData = self.petStampData:GetPetStampDataMapById(id)
        if stampData then
            local lvCfgData = ManagerContainer.CfgMgr:GetPetEquipExpCfgDataByLvAndCfgId(stampData.lv, stampData.cfgId)
            if lvCfgData then
                totalPower = totalPower + lvCfgData.FightPower
            end
        end
    end
    return math.floor(totalPower/10)
end

function PetDataMgr:GetTotalFightPower(id)
    local relationTotalFightPower = ManagerContainer.DataMgr.UserData:GetPetRelationTotalFightPower()
    local skillTotalFightPower = self:GetPetCurSkillTotalFightPower(id)
    local stampTotalFightPower = self:GetPetStampTotalFightPower(id)
    local petData = self.petAttrData:GetPetDataById(id)
    if nil ~= petData.pet_svrfight_power and petData.pet_svrfight_power > 0 then
        return petData.pet_svrfight_power
    end
    if petData.heroId > 0 then
        local masterData = CommonUtil.GetHeroLogicDataByUid(petData.heroId)
        if masterData.isBattle then
            return tonumber(tostring(masterData.petFightPower))
        else
            return petData.baseFightPower + relationTotalFightPower + skillTotalFightPower + stampTotalFightPower
        end
    end
    return petData.baseFightPower + relationTotalFightPower + skillTotalFightPower + stampTotalFightPower
end

function PetDataMgr:GetActivedPetCount(type)
    return self.petCollectBookData:GetActivedPetCount(type)
end

function PetDataMgr:GetPetCollectBoolState(cfgId)
    return self.petCollectBookData:GetPetCollectBoolState(cfgId)
end

function PetDataMgr:GetPetCollectRewardState(cfgId)
    return self.petCollectBookData:GetPetCollectRewardState(cfgId)
end

function PetDataMgr:SendPetReward(cfgId, idx, petId)
    self.petCollectBookData:SendPetReward(cfgId, idx, petId)
end

function PetDataMgr:RecalcBattlePetRelationAttr(isBattle, id)
    self.petRelationData:RecalcBattlePetRelationAttr(isBattle, id)
end

function PetDataMgr:GetSomePetMaxAdvLvByCfgId(cfgId)
    return self.petAttrData:GetSomePetMaxAdvLvByCfgId(cfgId)
end

function PetDataMgr:InitPetRelationAttrs()
    return self.petRelationData:AddPetRelationAttrs()
end

function PetDataMgr:GetRelationRPStates()
    return self.petRelationData:GetRelationRPStates()
end

function PetDataMgr:RefreshRelationRPStates()
    return self.petRelationData:RefreshRelationRPStates()
end

local lockIds = {42,43,44,45,46,47}
function PetDataMgr:GetBattleUnlockSlotCount()
    local unlockCount = 0
    for i = 1,#lockIds do
        local unLockState, val, content = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(lockIds[i])
        if unLockState then
            unlockCount = unlockCount + 1
        end
    end
    return unlockCount
end

function PetDataMgr:SendStampLvUpReq(id)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PET_EQUIP_LEVEL_UP_REQ, {pet_equip_id = id})
end

function PetDataMgr:SendStampUpReq(petId, list)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PET_EQUIP_UP_REQ, {pet_id = petId, slot_list = list})
end

function PetDataMgr:SendStampDownReq(petId, slotIdx)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PET_EQUIP_DOWN_REQ, {pet_id = petId, slot_index = slotIdx})
end

function PetDataMgr:UpdatePetQiyueData(data)
    --LogHRWarning("UpdatePetQiyueData    "..Inspect(data))
    local heroData = CommonUtil.GetHeroLogicDataByUid(data.hero_id)
    if not heroData then return end

    heroData.petQiyueData = ProtocalDataNormal.ParsePetQiyueData(heroData.petQiyueData, data.qiyue_info)
    self.petAttrData:UpdatePetExtGoShowData1(heroData)
end

function PetDataMgr:SendQiyueUnlockReq(heroId)
    --LogHRWarning("SendQiyueUnlockReq")
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PET_QIYUE_SLOT_UNLOCK_REQ, {hero_id = heroId})
end

function PetDataMgr:OnQiyueUnlockAck(data)
    --LogHRWarning("OnQiyueUnlockAck  ")
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.QIYUE_PET_CHANGE_SUCCESS)
end

function PetDataMgr:SendQiyueSlotInReq(heroId, slotIdx, petId)
    --LogHRWarning("SendQiyueSlotInReq")
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PET_QIYUE_SLOT_IN_REQ, {hero_id = heroId, slot_idx = slotIdx, pet_id = petId})
end

function PetDataMgr:OnQiyueSlotInAck(data)
    --LogHRWarning("OnQiyueSlotInAck")
    self.qiyueSuccess = data.error == Enum.NetErrorCode.ERROR_OK
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.QIYUE_PET_CHANGE_SUCCESS)
    self.qiyueSuccess = false
end

function PetDataMgr:IsQiyueSuccess()
    return self.qiyueSuccess
end

function PetDataMgr:SendQiyueSlotOutReq(heroId, slotIdx)
    --LogHRWarning("SendQiyueSlotOutReq")
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PET_QIYUE_SLOT_OUT_REQ, {hero_id = heroId, slot_idx = slotIdx})
end

function PetDataMgr:OnQiyueSlotOutAck(data)
    --LogHRWarning("OnQiyueSlotOutAck")
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.QIYUE_PET_CHANGE_SUCCESS)
end

function PetDataMgr:RefreshPetQiyueAttrs(data)
    if data.error ~= Enum.NetErrorCode.ERROR_OK then return end

    self.curQiyueAttrs = {}
    for i = 1, #data.actor_list do
        local actorData = data.actor_list[i]
        if not actorData.is_hero_pet and actorData.actor_id > 0 then
            self.curQiyueAttrs[actorData.actor_id] = {}
            for k,v in pairs(actorData.attr_list) do
                self.curQiyueAttrs[actorData.actor_id][v.key] = v.value
            end
        end
    end
    --LogHRWarning(Inspect(self.curQiyueAttrs))
end

function PetDataMgr:GetQiyueAttrsById(id)
    return self.curQiyueAttrs[id]
end

function PetDataMgr:QueryQiyueBattlePetAttrReq()
    --LogHRWarning("QueryQiyueBattlePetAttrReq")
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PET_QIYUE_BATTLE_PET_ATTR_REQ, {})
end

function PetDataMgr:OnQueryQiyueBattlePetAttrAck(data)
    --LogHRWarning("OnQueryQiyueBattlePetAttrAck    "..Inspect(data))
    self:RefreshPetQiyueAttrs(data)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.QUERY_PET_QIYUE_ATTRS_SUCCESS)
end

function PetDataMgr:QueryPetDetailInfos(petIdList)
    local needQuery = false
    local list = {}
    for i = 1, #petIdList do
        local data = self.petAttrData:GetPetDataById(petIdList[i])
        if not data.is_queried then
            list[#list + 1] = petIdList[i]
        end
    end
    if #list > 0 then
        ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PET_DETAIL_INFO_REQ, {pet_id_list = petIdList})
    else
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PET_DETAIL_QUERY_SUCCESS)
    end
end

function PetDataMgr:RegisterNetEvents()
    self.petAttrData:RegisterNetEvents()
    self.petRelationData:RegisterNetEvents()
    self.petCollectBookData:RegisterNetEvents()
    self.petStampData:RegisterNetEvents()

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_STARTUP_INFO_PET_NTF, function(data)
        if self.petStampData then
            self.petStampData:InitPetStampData(data.role_pet_info.pet_equip_list)
        end

        if data.role_pet_info then
            self.petAttrData:InitData(data.role_pet_info.pet_list)
        end
        if data.role_pet_info then
            self.petRelationData:InitData(data.role_pet_info)
        end
        if data.role_pet_info then
            self.petRelationData:RefreshMySupportPets(data.role_pet_info.assist_list)
        end
        if self.petCollectBookData then
            self.petCollectBookData:InitData(data.role_pet_info.pet_manual_reward_list)
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PET_CHANGE_NTF, function(data)
        local slotChanged = self.petAttrData:RefreshData(data.pet_list, data.del_pet_list)
        self.petCollectBookData:InitData(data.pet_manual_list)

        if slotChanged then
            ManagerContainer.RedPointMgr.PetRPCtr:RefreshPetStampRPState()
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PET_DECOMPOSE_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            CommonUtil.ACKShowRewardList(data.item_list)
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PET_DECOMPOSE_SUCCESS_NTF)
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PET_QIYUE_DATA_NTF, function(data)
        self:UpdatePetQiyueData(data)
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PET_QIYUE_SLOT_UNLOCK_ACK, function(data)
        self:OnQiyueUnlockAck(data)
        ManagerContainer.RedPointMgr.PetRPCtr:RefreshTotalQiyueRPState()
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PET_QIYUE_SLOT_IN_ACK, function(data)
        self:OnQiyueSlotInAck(data)
        ManagerContainer.RedPointMgr.PetRPCtr:RefreshTotalQiyueRPState()
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PET_QIYUE_SLOT_OUT_ACK, function(data)
        self:OnQiyueSlotOutAck(data)
        ManagerContainer.RedPointMgr.PetRPCtr:RefreshTotalQiyueRPState()
    end)
    
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PET_DETAIL_INFO_ACK, function(data)
        self.petAttrData:InitPetDetailDatas(data.pet_info_list)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PET_DETAIL_QUERY_SUCCESS)
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PET_QIYUE_BATTLE_PET_ATTR_ACK, function(data)
        self:OnQueryQiyueBattlePetAttrAck(data)
    end)
end

function PetDataMgr:Clear()
    self.data = {}

    self.petAttrData:Clear()
    self.petRelationData:Clear()
    self.petCollectBookData:Clear()
    self.petStampData:Clear()
end

function PetDataMgr:Destroy()
    if self.Clear then
        self:Clear()
    end

    self:UnRegisterNetEvents()

    self.petAttrData:Destroy()
    self.petAttrData = nil

    self.petRelationData:Destroy()
    self.petRelationData = nil

    self.petCollectBookData:Destroy()
    self.petCollectBookData = nil

    self.petStampData:Destroy()
    self.petStampData = nil
end

function PetDataMgr:UnRegisterNetEvents()

end

return PetDataMgr