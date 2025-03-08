local PetStampData = class("PetStampData", require("DataBase"))

function PetStampData:ctor()
    self.data = {}
end

function PetStampData:InitPetStampData(data)
    if not self.data.stampMap then
        self.data.stampMap = {}
    end
    if not self.data.typeStamps then
        self.data.typeStamps = {}
    end
    local stampMap = self.data.stampMap
    local typeStamps = self.data.typeStamps
    if data then
        for i = 1, #data do
            local petStampData = data[i]
            if petStampData then
                local stamp = stampMap[petStampData.id]
                local type
                if not stamp then
                    stamp, type = self:ProtocalDataToPetStampData(petStampData)
                    stampMap[stamp.id] = stamp

                    if typeStamps[type] == nil then
                        typeStamps[type] = {}
                    end
                    typeStamps[type][#typeStamps[type] + 1] = stamp
                else
                    stamp = self:ProtocalDataToPetStampData(petStampData, stamp)
                end
            end
        end
    end
end

function PetStampData:GetAllPetStampDataMap()
    return self.data.stampMap
end

function PetStampData:GetPetStampDataMapById(id)
    return self.data.stampMap[id]
end

function PetStampData:GetAllPetStampDatasByTypeExcludeId(type, id)
    if self.data.typeStamps[type] == nil then return {} end
    local list = {}
    local qualityStamp
    for k, v in pairs(self.data.typeStamps[type]) do
        if v.petId == 0 then
            if id == nil then
                list[#list + 1] = v
            else
                if id ~= v.id then
                    list[#list + 1] = v
                end
            end
            if not qualityStamp then
                qualityStamp = v
            else
                if v.cfgData.Quality > qualityStamp.cfgData.Quality then
                    qualityStamp = v
                end
            end
        end
    end
    return list, qualityStamp
end

function PetStampData:GetPetStampDatasByTypeAndId(type, id)
    if self.data.typeStamps[type] == nil then return nil end

    for i = 1, #self.data.typeStamps[type] do
        if self.data.typeStamps[type][i].cfgId == id then
            return self.data.typeStamps[type][i]
        end
    end
    return nil
end

function PetStampData:RefreshPetStampDatas(equip_list)
    if equip_list == nil then return nil end
    local addStamps = {}
    local stampMap = self.data.stampMap
    local typeStamps = self.data.typeStamps
    for _,item in ipairs(equip_list) do
        local isNew = false
        local id = item.id
        local stamp = stampMap[id]
        -- 更新装备
        if stamp then
            stamp = self:ProtocalDataToPetStampData(item, stamp)
        else
            local type = 1
            stamp, type = self:ProtocalDataToPetStampData(item)
            stampMap[id] = stamp

            if typeStamps[type] == nil then
                typeStamps[type] = {}
            end
            typeStamps[type][#typeStamps[type] + 1] = stamp
            isNew = true
        end

        if isNew then
            addStamps[stamp.cfgId] = stamp.lv
        end
    end

    return addStamps
end

function PetStampData:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PET_EQUIP_DATA_NTF, function(data)
        local addStamps = self:RefreshPetStampDatas(data.pet_equip_list)
        if next(addStamps) ~= nil then
            ManagerContainer.RedPointMgr.PetRPCtr:RefreshPetStampRPState()
            if not data.ignore then
                ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_EQUIP_AND_ITEM_ADD, addStamps)
            end
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PET_EQUIP_LEVEL_UP_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            ManagerContainer.RedPointMgr.PetRPCtr:RefreshPetStampRPState()

            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PET_STAMP_LEVEL_UP_REFRESH)
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PET_STAMP_SLOT_REFRESH)
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PET_EQUIP_UP_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            ManagerContainer.RedPointMgr.PetRPCtr:RefreshPetStampRPState()

            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PET_STAMP_SLOT_REFRESH)
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_PET_EQUIP_DOWN_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PET_STAMP_SLOT_REFRESH)
        end
    end)
end

function PetStampData:Clear()
    self.data = {}
end

function PetStampData:Destroy()
    if self.Clear then
        self:Clear()
    end

    self:UnRegisterNetEvents()
end

function PetStampData:UnRegisterNetEvents()

end

function PetStampData:ProtocalDataToPetStampData(protocalData, stampData)
    if not stampData then
        stampData     = {}
    end
    stampData.id         = protocalData.id
    stampData.cfgId      = protocalData.equip_cfg_id
    if stampData.lv then
        stampData.oldLv = stampData.lv
    end
    stampData.lv         = protocalData.level
    stampData.petId      = protocalData.equip_pet_id

    local cfgData = ManagerContainer.CfgMgr:GetPetEquipCfgDataById(stampData.cfgId)
    if not cfgData then
        LogError("找不到该宠物印记" .. stampData.cfgId)
        return stampData, 1
    end
    stampData.cfgData = cfgData
    stampData.type = cfgData.Type
    stampData.quality = cfgData.Quality
    return stampData, cfgData.Type
end

return PetStampData