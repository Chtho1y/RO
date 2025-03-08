local PetRelationData = class("PetRelationData")

local function GetMaxActiveRelationIdx(relationPets, cfgData)
    if not cfgData then
        return 0
    end
    local count = 3
    local maxIdx = 0
    for j = 3, 1, -1 do
        local condition = cfgData['Condition'..j]
        local state
        if condition then
            local curCount = 0
            if relationPets then
                for k,v1 in pairs(relationPets) do
                    local cfgId = condition[k][1]
                    local num = condition[k][2]
                    if v1.cfgId == cfgId and v1.advanceLevel >= num and v1.petId > 0 then
                        curCount = curCount + 1
                    end
                end
            end

            state = curCount >= count
            if state then
                if maxIdx == 0 then
                    maxIdx = j
                end
            end
        end
    end
    return maxIdx
end


function PetRelationData:ctor()
    self.data = {}

    self.data.relationDatas = {}
    self.data.relationPlayerNameMap = {}
    self.data.relationAttrMap = {}
    self.data.mySupportPets = {}
    for i = 1, Constant.MyPetSupportLimit do
        self.data.mySupportPets[i] = {}
        self.data.mySupportPets[i].id = 0
        self.data.mySupportPets[i].cd = 0
        self.data.mySupportPets[i].idx = i
    end

    self.data.relationRPStates = nil
end

function PetRelationData:InitData(datas)
    if datas and datas.bond_list then
        for _,v in pairs(datas.bond_list) do
            local data = ProtocalDataNormal.ParsePetBondData(v)
            self.data.relationDatas[data.cfgId] = data
            for _,v in pairs(data.relationPets) do
                if v.uid == 0 and v.petId > 0 then
                    local petData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(v.petId)
                    if petData then
                        petData.isRelevant = true
                    end
                else
                    if v.petId == 0 then
                        v.cfgId = 0
                        v.advanceLevel = 0
                    end
                end
            end
            self:IsNewRelationActived(data.cfgId, nil, data, nil, nil)
        end
    end

    if datas.uid_name_list then
        for k,v in pairs(datas.uid_name_list) do
            self.data.relationPlayerNameMap[v.key] = v.str_val
        end
    end
end

function PetRelationData:RefreshData(bondDataList, nameList)
    self:RefreshRelationBondList(bondDataList)

    if nameList then
        for k,v in pairs(nameList) do
            self.data.relationPlayerNameMap[v.key] = v.str_val
        end
    end
end

function PetRelationData:RefreshRelationBondList(bondDataList)
    if bondDataList then
        local oldAttrDatas, newAttrDatas = {}, {}
        local changedList = {}
        for _,v in pairs(bondDataList) do
            local data = ProtocalDataNormal.ParsePetBondData(v)
            local oldData = self.data.relationDatas[data.cfgId]
            if oldData then
                for _,v in pairs(oldData.relationPets) do
                    if v.uid == 0 and v.petId > 0 then
                        local petData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(v.petId)
                        if petData then
                            petData.isRelevant = false

                            ManagerContainer.DataMgr.PetDataMgr:RefreshMasterAttr(v.petId)
                        end
                    end
                end
            end
            self:RemovePetRelationAttrs(oldData, data.cfgId)
            changedList[#changedList + 1] = data.cfgId
            --self:RecalcMasterAttr()

            self.data.relationDatas[data.cfgId] = data
            for _,v in pairs(data.relationPets) do
                if v.uid == 0 and v.petId > 0 then
                    local petData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(v.petId)
                    petData.isRelevant = true
                else
                    if v.petId == 0 then
                        v.cfgId = 0
                        v.advanceLevel = 0
                    end
                end
            end
            self:IsNewRelationActived(data.cfgId, oldData, data, oldAttrDatas, newAttrDatas)
        end

        self:AddPetRelationAttrs(changedList)
        self:RecalcMasterAttr()

        ManagerContainer.LuaUIMgr:AttrNoticeDisplay1({oldAttrDatas, newAttrDatas})

        ManagerContainer.RedPointMgr.PetRPCtr:RefreshRelationRPState()
    end
end

function PetRelationData:RecalcBattlePetRelationAttr(isBattle, id)
    local relationDatas = self:GetAllPetRelationDatas()
    local list = {}
    for _,v in pairs(relationDatas) do
        local cfgData = ManagerContainer.CfgMgr:GetPetPartnerDataById(v.cfgId)
        local maxIdx = GetMaxActiveRelationIdx(v.relationPets, cfgData)
        if maxIdx > 0 then
            for i = maxIdx, 1, -1 do
                for k, v1 in pairs(cfgData["attribute"..i]) do
                    if not list[v1[1]] then
                        list[v1[1]] = 0
                    end
                    list[v1[1]] = list[v1[1]] + v1[2]
                end
            end
        end
    end

    local petActorData = ManagerContainer.DataMgr.PetDataMgr:GetPetActorData(id)
    for k,v in pairs(list) do
        if isBattle then
            if k <= Enum.HeroAttrType.RealHurt then
                local eAttr = petActorData:GetAdditionalAttr(k)
                local value = SDataUtil.Add(eAttr,v)
                petActorData:SetAdditionalAttr(k, value)
            elseif k >= Enum.HeroAttrType.STR_Percent then
                local eAttr = petActorData:GetAdditionalAttrPercent(k)
                local value = SDataUtil.Add(eAttr,v*0.0001)
                petActorData:SetAdditionalAttrPercent(k, value)
            end
        else
            if k <= Enum.HeroAttrType.RealHurt then
                local eAttr = petActorData:GetAdditionalAttr(k)
                local value = SDataUtil.InvConvert(SDataUtil.Sub(eAttr,v))
                if value < 0 then
                    value = 0
                end
                petActorData:SetAdditionalAttr(k, value)
            elseif k >= Enum.HeroAttrType.STR_Percent then
                local eAttr = petActorData:GetAdditionalAttrPercent(k)
                local value = SDataUtil.InvConvert(SDataUtil.Sub(eAttr,v*0.0001))
                if value < 0 then
                    value = 0
                end
                petActorData:SetAdditionalAttrPercent(k, value)
            end
        end
    end
end

function PetRelationData:AddPetRelationAttrs(changedList)
    local totalList = {}
    for k,v in pairs(self.data.relationDatas) do
        if not changedList or (changedList and CommonUtil.EleInTable(v.cfgId, changedList)) then
            local cfgData = ManagerContainer.CfgMgr:GetPetPartnerDataById(v.cfgId)

            local maxIdx = GetMaxActiveRelationIdx(v.relationPets, cfgData)
            if maxIdx > 0 and v.relationPets then
                for j = maxIdx,1,-1 do
                    local attribute = cfgData['attribute'..j]
                    if attribute then
                        for i = 1,#attribute do
                            local attrId = attribute[i][1]
                            local value = attribute[i][2]
                            if not totalList[attrId] then
                                totalList[attrId] = 0
                            end
                            totalList[attrId] = totalList[attrId] + value
                        end
                    end
                end
            end
        end
    end

    for m = 1, 6 do
        local heroData = CommonUtil.GetHeroLogicDataByUid(m)
        if (m == 1 or heroData.owned) and heroData.battlePetId > 0 then
            local petId = heroData.battlePetId
            local petActorData = ManagerContainer.DataMgr.PetDataMgr:GetPetActorData(petId)
            for k,v1 in pairs(totalList) do
                if k <= Enum.HeroAttrType.RealHurt then
                    local eAttr = petActorData:GetAdditionalAttr(k)
                    petActorData:SetAdditionalAttr(k, SDataUtil.Add(eAttr,v1))
                elseif k >= Enum.HeroAttrType.STR_Percent then
                    local eAttr = petActorData:GetAdditionalAttrPercent(k)
                    petActorData:SetAdditionalAttrPercent(k, SDataUtil.Add(eAttr,v1 * 0.0001))
                end
            end
        end
    end
end

function PetRelationData:RecalcMasterAttr()
    for m = 1, 6 do
        local heroData = CommonUtil.GetHeroLogicDataByUid(m)
        if heroData.battlePetId > 0 then
            if m == 1 then
                ManagerContainer.DataMgr.UserData:CalcPetAttrs()
            elseif heroData.owned then
                ManagerContainer.DataMgr.PartnerData:CalcPetAttrsById(m)
            end
        end
    end
end

function PetRelationData:IsNewRelationActived(cfgId, oldData, newData, oldAttrDatas, newAttrDatas)
    local cfgData = ManagerContainer.CfgMgr:GetPetPartnerDataById(cfgId)

    local oldMaxIdx = oldData and GetMaxActiveRelationIdx(oldData.relationPets, cfgData) or 0
    local newMaxIdx = GetMaxActiveRelationIdx(newData.relationPets, cfgData)
    if newMaxIdx > 0 then
        if oldAttrDatas and newAttrDatas and newMaxIdx > oldMaxIdx then
            for i = newMaxIdx , oldMaxIdx + 1, -1 do
                for k, v in pairs(cfgData["attribute"..i]) do
                    local key = v[1]
                    local val = key > 21 and CommonUtil.GetPreciseDecimal(v[2] * 0.0001, 3) or math.floor(v[2])
                    oldAttrDatas[key] = 0
                    newAttrDatas[key] = newAttrDatas[key] and newAttrDatas[key] + val or val
                end
            end
        end
    end

    newData.newActived = newMaxIdx > oldMaxIdx and newMaxIdx or 0
end

function PetRelationData:RemovePetRelationAttrs(oldData, cfgId)
    local totalList = {}
    local cfgData = ManagerContainer.CfgMgr:GetPetPartnerDataById(cfgId)
    local maxIdx = oldData and GetMaxActiveRelationIdx(oldData.relationPets, cfgData) or 0

    if maxIdx > 0 and oldData and oldData.relationPets then
        for j = maxIdx,1,-1 do
            local attribute = cfgData['attribute'..j]
            if attribute then
                for i = 1,#attribute do
                    local attrId = attribute[i][1]
                    local value = attribute[i][2]
                    if not totalList[attrId] then
                        totalList[attrId] = 0
                    end
                    totalList[attrId] = totalList[attrId] + value
                end
            end
        end
    end

    for m = 1, 6 do
        local heroData = CommonUtil.GetHeroLogicDataByUid(m)
        if (m == 1 or heroData.owned) and heroData.battlePetId > 0 then
            local petId = heroData.battlePetId
            local petActorData = ManagerContainer.DataMgr.PetDataMgr:GetPetActorData(petId)
            for k,v1 in pairs(totalList) do
                if k <= Enum.HeroAttrType.RealHurt then
                    local eAttr = petActorData:GetAdditionalAttr(k)
                    local value = SDataUtil.InvConvert(SDataUtil.Sub(eAttr,v1))
                    if value < 0 then
                        value = 0
                    end
                    petActorData:SetAdditionalAttr(k, value)
                elseif k >= Enum.HeroAttrType.STR_Percent then
                    local eAttr = petActorData:GetAdditionalAttrPercent(k)
                    local value = SDataUtil.InvConvert(SDataUtil.Sub(eAttr,v1*0.0001))
                    if value < 0 then
                        value = 0
                    end
                    petActorData:SetAdditionalAttrPercent(k, value)
                end
            end
        end
    end
end

function PetRelationData:RefreshMySupportPets(list)
    if #list == 0 then
        return
    end

    local supportList = {}
    for k,v in pairs(list) do
        supportList[#supportList + 1] = v.pet_id
        if not self.data.mySupportPets[k] then
            self.data.mySupportPets[k] = {}
        end
        self.data.mySupportPets[k].id = v.pet_id
        self.data.mySupportPets[k].cd = v.end_cd_time
        self.data.mySupportPets[k].idx = k
    end

    local petDatas = ManagerContainer.DataMgr.PetDataMgr:GetPetDatas()
    for _,v in pairs(petDatas) do
        v.isSupport = CommonUtil.EleInTable(v.id, supportList)
    end
end

function PetRelationData:DeleteMySupportPets(list)
    if not list or #list == 0 then
        return
    end
    for k,v in pairs(self.data.mySupportPets) do
        if CommonUtil.EleInTable(v.id, list) then
            v.id = 0
            v.cd = 0
        end
    end
end

function PetRelationData:GetMySupportPets()
    return self.data.mySupportPets
end

function PetRelationData:GetAllPetRelationDatas()
    return self.data.relationDatas
end

function PetRelationData:GetPetRelationDataByCfgId(cfgId)
    return self.data.relationDatas[cfgId]
end

function PetRelationData:GetRelationPlayerNameByUid(uid)
    return self.data.relationPlayerNameMap[uid]
end

function PetRelationData:RefreshFriendSupportDatas(list)
    self.data.curFriendSupportDatas = {}
    for _,v in pairs(list) do
        local data = ProtocalDataNormal.ParseAssistData(v)
        self.data.curFriendSupportDatas[#self.data.curFriendSupportDatas + 1] = data
    end
end

function PetRelationData:GetCurFriendSupportDatas()
    return self.data.curFriendSupportDatas
end

function PetRelationData:QueryPetRelation()
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PET_BOND_LIST_REQ, {})
end

function PetRelationData:QueryAssistList(cfgId)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PET_BOND_ASSIST_LIST_REQ, {bond_cfg_id = cfgId})
end

function PetRelationData:SendMySupport(datas)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PET_ASSIST_REQ, {pet_id_list = datas})
end

function PetRelationData:GetReplacePetRelationDataByUidAndPetId(uid, petId)
    for _,v in pairs(self.data.relationDatas) do
        for _,v1 in pairs(v.relationPets) do
            if v1.uid == uid and v1.petId == petId then
                return v
            end
        end
    end
    return nil
end

function PetRelationData:SendPetRelationActive(datas)
    local list = {}
    for _,v in pairs(datas) do
        local bondData = {}
        bondData.bond_cfg_id = v.cfgId
        bondData.bond_list = {}
        if v.relationPets then
            for i = 1, 3 do
                local data1 = v.relationPets[i]
                bondData.bond_list[i] = {}
                if data1 then
                    bondData.bond_list[i].owner_uid = data1.uid
                    bondData.bond_list[i].pet_id = data1.petId
                    bondData.bond_list[i].pet_cfg_id = data1.cfgId
                    bondData.bond_list[i].advance_level = data1.advanceLevel
                else
                    bondData.bond_list[i].owner_uid = 0
                    bondData.bond_list[i].pet_id = 0
                    bondData.bond_list[i].pet_cfg_id = 0
                    bondData.bond_list[i].advance_level = 0
                end
            end
        end
        list[#list + 1] = bondData
    end

    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PET_BOND_ACTIVE_REQ, {bond_data_list = list})
end

function PetRelationData:GetRelationRPStates()
    return self.data.relationRPStates
end

function PetRelationData:RefreshRelationRPStates()
    if not self.data.relationRPStates then
        self.data.relationRPStates = {}
    end

    local relationCfgs = ManagerContainer.CfgMgr:GetAllPetPartnerDatas()
    for i = 1, #relationCfgs do
        local cfgId = relationCfgs[i].Id

        if not self.data.relationRPStates[cfgId] then
            self.data.relationRPStates[cfgId] = {false, false, false}
        end

        local rpIdxList = ManagerContainer.RedPointMgr.PetRPCtr:RefresgPetRelationState(cfgId)
        for i = 1, 3 do
            local isIn = CommonUtil.EleInTable(i, rpIdxList)
            self.data.relationRPStates[cfgId][i] = isIn
        end
    end
end

function PetRelationData:RegisterNetEvents()

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PET_BOND_LIST_NTF, function(data)
        self:RefreshRelationBondList(data.bond_list)
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PET_BOND_LIST_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            self:InitData(data)

            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PET_RELATION_OPEN_NTF)
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PET_BOND_ASSIST_LIST_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            self:RefreshFriendSupportDatas(data.bond_pet_list)

            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PET_FRIEND_SUPPORT_OPEN_NTF, data.bond_cfg_id)
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PET_ASSIST_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            self:RefreshMySupportPets(data.assist_list)

            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PET_MY_SUPPORT_CHANGE_SUCCESS_NTF, true)
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PET_BOND_ACTIVE_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            self:RefreshData(data.bond_data_list, data.uid_name_list)
            self:RefreshRelationRPStates()
            --ManagerContainer.RedPointMgr.PetRPCtr:RefreshRelationRPState()
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PET_RELATION_CHANGE_SUCCESS_NTF)
        end
    end)

end

function PetRelationData:Clear()
    self.data = {}

    self.data.relationDatas = {}
    self.data.relationPlayerNameMap = {}
    self.data.relationAttrMap = {}
    self.data.mySupportPets = {}
    for i = 1, Constant.MyPetSupportLimit do
        self.data.mySupportPets[i] = {}
        self.data.mySupportPets[i].id = 0
        self.data.mySupportPets[i].cd = 0
        self.data.mySupportPets[i].idx = i
    end

    self.data.relationRPStates = nil
end

function PetRelationData:Destroy()
    if self.Clear then
        self:Clear()
    end

    self:UnRegisterNetEvents()
end

function PetRelationData:UnRegisterNetEvents()
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_PET_BOND_LIST_NTF)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_PET_BOND_LIST_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_PET_BOND_ASSIST_LIST_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_PET_ASSIST_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_PET_BOND_ACTIVE_ACK)
end

return PetRelationData