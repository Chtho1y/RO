local PetRPCtr = class("PetRPCtr", require("RPBase"))
local BitUtil = require("BitUtil")

local advenceLvStage
local qiyueSlotUnlockCost
function PetRPCtr:ctor()
    if not qiyueSlotUnlockCost then
        local val = GlobalConfig.Instance:GetConfigStrValue(350)
        if val ~= "" and val ~= nil then
            qiyueSlotUnlockCost = CommonUtil.DeserializeGlobalStrToTable(val)
        end
    end
end

function PetRPCtr:RefreshPetLvUpState(id)
    if not advenceLvStage then
        local val = GlobalConfig.Instance:GetConfigStrValue(208)
        if val ~= "" and val ~= nil then
            advenceLvStage = CommonUtil.DeserializeGlobalStrToTable(val)
        end
    end

    local petData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(id)
    if not petData.isBattle then
        ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.PetLvUp, false)
        return
    end

    local petExpData = ManagerContainer.CfgMgr:GetPetExpCfgDataById(petData.level + 1)
    if not petExpData then
        ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.PetLvUp, false)
        return
    end

    local expCost = petExpData["experience"..petData.quality] or 0
    local zenyCost = petExpData["CostMoney"..petData.quality] or 0

    local zenyOwned = CommonUtil.GetOwnResCountByItemId(Enum.ItemIds.Coin)
    local expOwned = ManagerContainer.DataMgr.UserData:GetResById(Enum.ItemIds.PetExp) or 0

    local isZenyLack = zenyCost > zenyOwned
    local isExpLack = expCost > expOwned

    local curMaxLv = tonumber(advenceLvStage[petData.advanceLevel + 1] or 0)

    local canLvUp = not isZenyLack and not isExpLack and petData.level < curMaxLv
    ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.PetLvUp, canLvUp)

    return canLvUp
end

function PetRPCtr:RefreshPetAdvenceState(id)
    if not advenceLvStage then
        local val = GlobalConfig.Instance:GetConfigStrValue(208)
        if val ~= "" and val ~= nil then
            advenceLvStage = CommonUtil.DeserializeGlobalStrToTable(val)
        end
    end

    local petData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(id)
    if not petData.isBattle then
        ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.PetAdvance, false)
        return
    end

    local petProgressCfgData = ManagerContainer.CfgMgr:GetPetProgressCfgDataById(petData.cfgId)
    local nextAdvenceLv = petData.advanceLevel + 1
    if nextAdvenceLv > #advenceLvStage then
        ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.PetAdvance, false)
        return false
    end

    local curMaxLv = tonumber(advenceLvStage[petData.advanceLevel + 1] or 0)
    if petData.level < curMaxLv then
        ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.PetAdvance, false)
        return false
    end

    if petData.level >= curMaxLv and nextAdvenceLv >= #advenceLvStage then
        ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.PetAdvance, false)
        return false
    end

    local zenyCost = petProgressCfgData.CostMoney[nextAdvenceLv]
    local zenyOwned = CommonUtil.GetOwnResCountByItemId(Enum.ItemIds.Coin)

    local petDatasSource = ManagerContainer.DataMgr.PetDataMgr:GetPetDatas()
    local curPetCfgData = ManagerContainer.CfgMgr:GetPetProgressCfgDataById(petData.cfgId)

    local nextAdvenceLv = petData.advanceLevel + 1
    local filters = curPetCfgData["Condition"..nextAdvenceLv.."1"]
    local list = {}
    if filters then
        local qulity = filters[1] and filters[1][2] or nil
        local advanceLevel = filters[2] and filters[2][2] or nil
        local natureType = filters[3] and filters[3][2] or nil
        list = CommonUtil.ArrayFilterSelections(petDatasSource, Enum.FilterType.AND, {"quality", "advanceLevel", "natureType", "isBattle", "qiyueHeroId"}, {qulity, advanceLevel, natureType, false, 0})
    end

    local canAdvence = #list >= 2 and zenyCost <= zenyOwned
    ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.PetAdvance, canAdvence)

    return canAdvence
end

function PetRPCtr:RefreshSkillUpState(id)
    local petData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(id)
    if not petData.isBattle then
        ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.PetSkillUp, false)
        return
    end
    local cfgData = ManagerContainer.CfgMgr:GetPetDataById(petData.cfgId)
    local canSkillUp = false
    for i = 1, #petData.skillList do
        local skillRate = cfgData["Skill"..i.."Rate"]
        if skillRate then
            if petData.skillList[i].level < #skillRate then
                canSkillUp = true
                break
            end
        end
    end

    local skillUpCost = GlobalConfig.Instance:GetConfigIntValue(207)
    local zenyOwned = CommonUtil.GetOwnResCountByItemId(Enum.ItemIds.Coin)

    local petDatasSource = ManagerContainer.DataMgr.PetDataMgr:GetPetDatas()

    local list = CommonUtil.ArrayFilterSelections(petDatasSource, Enum.FilterType.AND, {"cfgId", "isBattle", "qiyueHeroId"}, {petData.cfgId, false, 0})
    canSkillUp = canSkillUp and skillUpCost <= zenyOwned and #list > 0

    ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.PetSkillUp, canSkillUp)

    return canSkillUp
end

function PetRPCtr:RefresgPetRelationState(relationCfgId)
    local advanceLimit = 5
    if not advenceLvStage then
        local val = GlobalConfig.Instance:GetConfigStrValue(208)
        if val ~= "" and val ~= nil then
            advenceLvStage = CommonUtil.DeserializeGlobalStrToTable(val)
        end
    end
    advanceLimit = #advenceLvStage

    local relationCfgData = ManagerContainer.CfgMgr:GetPetPartnerDataById(relationCfgId)
    local relationData = ManagerContainer.DataMgr.PetDataMgr:GetPetRelationDataByCfgId(relationCfgId)
    local petDatas = ManagerContainer.DataMgr.PetDataMgr:GetPetDatas()

    local idx = nil
    local condition = relationCfgData['Condition1']
    if condition then
        for k,v in pairs(condition) do
            local advenceNum = {}
            local cfgId = v[1]
            local num = v[2]
            advenceNum[#advenceNum + 1] = num

            if #advenceNum > 0 then
                for i = 1, advanceLimit do
                    if i > advenceNum[1] and not CommonUtil.EleInTable(i, advenceNum) then
                        advenceNum[#advenceNum + 1] = i
                    end
                end
            end

            local list = CommonUtil.ArrayFilterSelections(petDatas, Enum.FilterType.AND, {"cfgId", "advanceLevel","isRelevant"}, {cfgId, advenceNum, false})
            --local friendDatas = clone(ManagerContainer.DataMgr.PetDataMgr:GetCurFriendSupportDatas())

            if relationData then
                local v1 = relationData.relationPets[k]
                for i = #list, 1, -1 do
                    local v2 = list[i]
                    local needBreak = false
                    while(true) do
                        if v1.uid == 0 and v2.id == v1.petId then
                            table.remove(list, i)
                            break
                        end
                        if v1.cfgId == 0 then
                            if idx == nil then idx = {} end
                            idx[k] = k
                            needBreak = true
                            break
                        end
                        if v2.advanceLevel > v1.advanceLevel then

                            if idx == nil then idx = {} end
                            if not CommonUtil.EleInTable(k, idx) then
                                idx[#idx + 1] = k
                                needBreak = true
                            end
                        end
                        break
                    end
                    if needBreak or (idx and #idx >= 3) then
                        break
                    end
                end
            else
                if #list > 0 then
                    if idx == nil then idx = {} end
                    idx[k] = k
                end
            end

            --if (not idx or #idx < 3) and friendDatas then
            --    if relationData then
            --        local v1 = relationData.relationPets[k]
            --        for _,v2 in pairs(friendDatas) do
            --            local uid = v2.uid
            --            for i = #v2.supportPets, 1, -1 do
            --                local v3 = v2.supportPets[i]
            --                local needBreak = false
            --                if v3.cfgId == cfgId then
            --                    while(true) do
            --                        if v1.uid == uid and v3.id == v1.petId then
            --                            table.remove(v2.supportPets, i)
            --                            break
            --                        end
            --
            --                        if v1.cfgId == 0 then
            --                            if idx == nil then idx = {} end
            --                            idx[k] = k
            --                            needBreak = true
            --                            break
            --                        end
            --
            --                        if v3.advanceLevel > v1.advanceLevel then
            --
            --                            if idx == nil then idx = {} end
            --                            if not CommonUtil.EleInTable(k, idx) then
            --                                idx[k] = k
            --                                needBreak = true
            --                            end
            --                        end
            --                        break
            --                    end
            --                    if idx == nil then idx = {} end
            --                    if needBreak or #idx >= 3 then
            --                        break
            --                    end
            --                end
            --            end
            --        end
            --    else
            --        for _,v2 in pairs(friendDatas) do
            --            for i = #v2.supportPets, 1, -1 do
            --                local v3 = v2.supportPets[i]
            --                if v3.cfgId == cfgId then
            --                    if idx == nil then idx = {} end
            --                    idx[k] = k
            --                    break
            --                end
            --            end
            --        end
            --    end
            --end
        end
    end
    --ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.PetRelation, idx ~= nil and #idx > 0)
    return idx
end

function PetRPCtr:GetPetCultivatingState(id)
    local result = self:RefreshPetLvUpState(id)
    if result then
        return true
    end

    local result = self:RefreshPetAdvenceState(id)
    if result then
        return true
    end

    local result = self:RefreshSkillUpState(id)
    if result then
        return true
    end
end

function PetRPCtr:RefreshRelationRPState()
    local relationCfgDatas = ManagerContainer.CfgMgr:GetAllPetPartnerDatas()
    local relationRedPoint = false
    for _,v in pairs(relationCfgDatas) do
        local idxList = ManagerContainer.RedPointMgr.PetRPCtr:RefresgPetRelationState(v.Id)
        if idxList and next(idxList) then
            relationRedPoint = true
            break
        end
    end
    ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.PetRelation, relationRedPoint)
end

function PetRPCtr:RefreshPetStampRPState()
    self.stampInsertRp = {}
    self.stampLvUpRp = {}
    self.stampAdvanceRp = {}

    local battlePets = ManagerContainer.DataMgr.PetDataMgr.petAttrData:GetAllBattlePetDatas()
    if #battlePets == 0 then
        ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.PetStampInsert, false)
        ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.PetStampLvUp, false)
        ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.PetStampAdvance, false)
        return
    end

    local function IsCostEnough(costs)
        for i = 1, #costs do
            local cost = costs[i]
            if cost then
                local ownCount = CommonUtil.GetOwnResCountByItemId(cost[1])
                if ownCount < cost[2] then
                    return false
                end
            end
        end
        return true
    end

    local canInsert, canLvUp, canAdvance = false, false, false

    for _,v in pairs(battlePets) do
        local petId = v.id
        if not self.stampInsertRp[petId] then
            self.stampInsertRp[petId] = {}
        end
        if not self.stampLvUpRp[petId] then
            self.stampLvUpRp[petId] = {}
        end
        if not self.stampAdvanceRp[petId] then
            self.stampAdvanceRp[petId] = {}
        end
        local slots = v.slots
        for i = 1, 6 do
            local slot = slots[i]
            local idx = i
            local stampId = slot and slot.stampId or 0
            local stamps = ManagerContainer.DataMgr.PetDataMgr.petStampData:GetAllPetStampDatasByTypeExcludeId(idx, stampId)
            if stampId == 0 then
                if #stamps > 0 then
                    self.stampInsertRp[petId][idx] = true
                    if not canInsert then
                        canInsert = true
                    end
                end
            else
                local stampData = ManagerContainer.DataMgr.PetDataMgr.petStampData:GetPetStampDataMapById(stampId)
                if stampData then
                    local cfgData = stampData.cfgData
                    local isMaxLv = stampData.lv >= cfgData.MaxLevel
                    local canAdvance1 = cfgData.Advance > 0
                    if not isMaxLv then
                        local lvCfgData = ManagerContainer.CfgMgr:GetPetEquipExpCfgDataByLvAndCfgId(stampData.lv, stampData.cfgId)
                        if lvCfgData then
                            local result = IsCostEnough(lvCfgData.Cost)
                            if result then
                                self.stampLvUpRp[petId][idx] = true
                                if not canLvUp then
                                    canLvUp = true
                                end
                            end
                        end
                    elseif isMaxLv and canAdvance1 then
                        local result = IsCostEnough(cfgData.AdvanceCost)
                        if result then
                            self.stampAdvanceRp[petId][idx] = true
                            if not canAdvance then
                                canAdvance = true
                            end
                        end
                    end
                end
            end
        end
    end

    ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.PetStampInsert, canInsert)
    ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.PetStampLvUp, canLvUp)
    ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.PetStampAdvance, canAdvance)
end

function PetRPCtr:GetPetSlotInsertRPState(petId, idx)
    if idx then
        return self.stampInsertRp and (self.stampInsertRp[petId] and self.stampInsertRp[petId][idx]) or false
    else
        if self.stampLvUpRp and self.stampInsertRp[petId] then
            for _,v in pairs(self.stampInsertRp[petId]) do
                if v then
                    return true
                end
            end
        end
        return false
    end
end

function PetRPCtr:GetPetSlotLvUpRPState(petId, idx)
    if idx then
        return self.stampLvUpRp and (self.stampLvUpRp[petId] and self.stampLvUpRp[petId][idx]) or false
    else
        if self.stampLvUpRp and self.stampLvUpRp[petId] then
            for _,v in pairs(self.stampLvUpRp[petId]) do
                if v then
                    return true
                end
            end
        end
        return false
    end
end

function PetRPCtr:GetPetSlotAdvanceRPState(petId, idx)
    if idx then
        return self.stampAdvanceRp and (self.stampAdvanceRp[petId] and self.stampAdvanceRp[petId][idx]) or false
    else
        if self.stampAdvanceRp and self.stampAdvanceRp[petId] then
            for _,v in pairs(self.stampAdvanceRp[petId]) do
                if v then
                    return true
                end
            end
        end
        return false
    end
end

local function CalcUnlockSlot(slotList)
	local state = false
	local idx = #slotList + 1
	local cost = qiyueSlotUnlockCost[idx]
	if not cost then
		return false
	end
	local costId = tonumber(cost[1])
	local costNum = tonumber(cost[2])
	local count = CommonUtil.GetOwnResCountByItemId(costId)
	return count >= costNum
end

function PetRPCtr:RefreshBattlePetQiyueRPState(petData)
   

    local qiyueFunc = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(77)
    if not qiyueFunc then
        return false
    end
    if not petData or petData.heroId == 0 then return false end
    local heroData = CommonUtil.GetHeroLogicDataByUid(petData.heroId)
    if not heroData then return false end

    local hasFreePet = false
	local petDatas = ManagerContainer.DataMgr.PetDataMgr:GetPetDatas()
	for i = 1, #petDatas do
		if not petDatas[i].isBattle and petDatas[i].qiyueHeroId == 0 then
			hasFreePet = true
			break
		end
	end

    local slotList = heroData.petQiyueData.slotList
    if CalcUnlockSlot(slotList) then
        return true
    end

    if heroData.battlePetId > 0 then
        if #slotList > 0 then
            for j = 1, #slotList do
                local slotData = slotList[j]
                if slotData.petId == 0 and hasFreePet then
                    return true
                end
            end
        end
    end
    return false
end

function PetRPCtr:RefreshTotalQiyueRPState()
    local qiyueFunc = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(77)
    if not qiyueFunc then
        ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.PetQiyueFunc, false)
        return
    end

    local hasFreePet = false
	local petDatas = ManagerContainer.DataMgr.PetDataMgr:GetPetDatas()
	for i = 1, #petDatas do
		if not petDatas[i].isBattle and petDatas[i].qiyueHeroId == 0 then
			hasFreePet = true
			break
		end
	end
    for i = 1, 6 do
        local heroData = CommonUtil.GetHeroLogicDataByUid(i)
        if i == 1 then
            local slotList = heroData.petQiyueData.slotList
            if CalcUnlockSlot(slotList) then
                ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.PetQiyueFunc, true)  
                return 
            end
            if #slotList > 0 then
                if heroData.battlePetId > 0 then
                    for j = 1, #slotList do
                        local slotData = slotList[j]
                        if slotData.petId == 0 and hasFreePet then
                            ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.PetQiyueFunc, true)
                            return
                        end
                    end
                end
            end
        else
            if heroData.owned then
                local slotList = heroData.petQiyueData.slotList
                if CalcUnlockSlot(slotList) then
                    ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.PetQiyueFunc, true)  
                    return 
                end
                if #slotList > 0 then
                    if heroData.battlePetId > 0 then
                        for j = 1, #slotList do
                            local slotData = slotList[j]
                            if slotData.petId == 0 and hasFreePet then
                                ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.PetQiyueFunc, true)
                                return
                            end
                        end
                    end
                end
            end
        end
    end
    ManagerContainer.RedPointSimpleMgr:RPNotify(Enum.RPNotifyType.PetQiyueFunc, false)
end

function PetRPCtr:Dispose()

end

return PetRPCtr