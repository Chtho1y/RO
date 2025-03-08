local EquipData = class("EquipData", require("DataBase"))

local function SortRule(a, b)
    if a.fightPower == b.fightPower then
        return a.cfgId > b.cfgId
    else
        return a.fightPower > b.fightPower
    end
end

function EquipData:ctor()
    self.data = {}
end

function EquipData:InitEquipData(data)
    local equipMap = {}
    local typeEquips = {}
    if data and data.equip_list then
        local cfgMgr = ManagerContainer.CfgMgr
        local list = data.equip_list
        local equip, equipCfgData, type
        for i = 1, #list do
            local equipData = list[i]
            if equipData and equipData.num > 0 then
                equip = self:ProtocalDataToEquipData(equipData)
                equipCfgData = cfgMgr:GetEquipById(equip.cfgId)
                if not equipCfgData then
                    LogError("[Wboy] .. ".. tostring(equip.cfgId) .. " 装备ID不存在")
                else
                    type = equipCfgData.Type
                    equipMap[equip.cfgId] = equip

                    if typeEquips[type] == nil then
                        typeEquips[type] = {}
                    end
                    typeEquips[type][#typeEquips[type] + 1] = equip
                end
            end
        end
    end

    self.data.equipMap = equipMap
    self.data.typeEquips = typeEquips
    for _,v in pairs(self.data.typeEquips) do
        table.sort(v, SortRule)
    end
end

function EquipData:GetAllEquipDataMap()
    return self.data.equipMap
end

function EquipData:GetEquipDataMapById(id)
    return self.data.equipMap[id]
end

function EquipData:GetEquipCountById(id)
    local data = self.data.equipMap[id]
    if data then
        return data.num
    end
    return 0
end

function EquipData:GetAllEquipCount()
    local count = 0
    for i = 1, 6 do
        local equipList = self.data.typeEquips[i]
        if equipList ~= nil then
            count = count + #equipList
        end
    end
    return count
end

function EquipData:GetAllEquipDatasByType(type, cfgId)
    if self.data.typeEquips[type] == nil then return {} end
    local list = {}
    for k, v in pairs(self.data.typeEquips[type]) do
        if cfgId == nil then
            list[#list + 1] = v
        else
            if cfgId ~= v.cfgId then
                list[#list + 1] = v
            end
        end
    end
    return list
end

function EquipData:GetAllEquipDatasByTypeAndJob(type, jobType)
    if self.data.typeEquips[type] == nil then return nil end
    local list = {}
    for _, v in pairs(self.data.typeEquips[type]) do
        if type == Enum.SlotEquipType.Weapon then
            local equipData = ManagerContainer.CfgMgr:GetEquipById(v.cfgId)
            if equipData.JobType[1] == jobType then
                list[#list + 1] = v
            end
        else
            list[#list + 1] = v
        end
    end
    return list
end


function EquipData:GetAllWeaponEquipDatasFlterJobType(jobType)
    if self.data.typeEquips[Enum.SlotEquipType.Weapon] == nil then return end

    local list
    for _,v in pairs(self.data.typeEquips[Enum.SlotEquipType.Weapon]) do
        local equipData = ManagerContainer.CfgMgr:GetEquipById(v.cfgId)
        if CommonUtil.EleInTable(jobType, equipData.JobType) then
            if list == nil then list = {} end

            list[#list + 1] = v
        end
    end

    return list
end

function EquipData:GetEquipDatasByTypeAndId(type, id)
    if self.data.typeEquips[type] == nil then return nil end

    for i = 1, #self.data.typeEquips[type] do
        if self.data.typeEquips[type][i].cfgId == id then
            return self.data.typeEquips[type][i]
        end
    end
    return nil
end

function EquipData:RefreshEquipDatas(equip_list, ignore)
    if equip_list == nil then return nil end
    -- 是否为新增道具， 默认为新增
    --ignore = ignore and ignore or false
    local addEquips = {}
    local equipMap = self.data.equipMap
    local typeEquips = self.data.typeEquips
    local isNeedSort = {false,false,false,false,false,false}
    local cfgMgr = ManagerContainer.CfgMgr
    local equip, equipCfgData, type, isValid
    for _,item in ipairs(equip_list) do
        local cfgId = item.config_id
        local num = item.num
        equip = equipMap[cfgId]
        if num <= 0 then
            -- 删除装备
            if equip then
                equipMap[cfgId] = nil

                for i = 1, 6 do
                    local equipList = typeEquips[i]
                    if equipList ~= nil then
                        for j,v in ipairs(equipList) do
                            if v.cfgId == equip.cfgId then
                                table.remove(equipList, j)
                            end
                        end
                    end
                end
            end

        else
            -- 更新装备
            isValid = true
            local lastnum = equip and equip.num or 0
            if equip then
                equip.num = num
            else
                equipCfgData = cfgMgr:GetEquipById(cfgId)
                if not equipCfgData then
                    LogError("[Wboy] .. ".. tostring(cfgId) .. " 装备ID不存在")
                    isValid = false
                else
                    equip = self:ProtocalDataToEquipData(item)
                    type = equipCfgData.Type
                    equipMap[cfgId] = equip

                    if typeEquips[type] == nil then
                        typeEquips[type] = {}
                    end
                    typeEquips[type][#typeEquips[type] + 1] = equip
                    isNeedSort[type] = true
                end
            end
            if isValid then
                local addNum = num - lastnum
                if addNum > 0 then
                    if addEquips[cfgId] then
                        addEquips[cfgId] = addEquips[cfgId] + addNum
                    else
                        addEquips[cfgId] = addNum
                    end
                end
            end
        end
    end
    for i = 1, 6 do
        local needSort = isNeedSort[i]
        if needSort then
            table.sort(typeEquips[i], SortRule)
        end
    end

    return addEquips
end

function EquipData:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_STARTUP_INFO_EQUIP_NTF, function(data)
        self:InitEquipData(data.role_equip_info)
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_EQUIP_CHANGE_NTF, function(data)
        local addEquips = self:RefreshEquipDatas(data.equip_list, data.ignore)

        if next(addEquips) ~= nil then
            if not data.ignore then
                ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_EQUIP_AND_ITEM_ADD, addEquips)
            end
        end

        ManagerContainer.RedPointMgr.HeroRPCtr:HeroEquipNotify()
        ManagerContainer.RedPointMgr.HeroRPCtr:PartnerEquipNotify()

        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EQUIP_CHANGE)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.ONE_KEY_EQUIP_REDPOINT_NOTICE)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.MAIN_UI_ROLE_REDPOINT_NOTICE)
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_EQUIP_FORGE_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            ----单件装备锻造
            --local addEquips = self:RefreshEquipDatas({data.old_data, data.new_data})
            --
            --ManagerContainer.RedPointMgr.HeroRPCtr:HeroEquipNotify()
            --ManagerContainer.RedPointMgr.HeroRPCtr:PartnerEquipNotify()
            --
            --ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_EQUIP_AND_ITEM_ADD, addEquips)
            --ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EQUIP_CHANGE)
            --ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.ONE_KEY_EQUIP_REDPOINT_NOTICE)
            --ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.MAIN_UI_ROLE_REDPOINT_NOTICE)
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EQUIP_FORGE_SUCCESS, data.type)
        end
    end)
end

function EquipData:Clear()
    self.data = {}
end

function EquipData:Destroy()
    if self.Clear then
        self:Clear()
    end

    self:UnRegisterNetEvents()
end

function EquipData:UnRegisterNetEvents()

end

function EquipData:GetForgeStatus(slotIndex, onlyOne)
    local slots = ManagerContainer.DataMgr.UserData:GetCurSlotInfos(slotIndex)
    local canForge = false
    local slotsForgeStatus = {false,false,false,false,false,false}
    local lackEquip, lackCoin = false, false

    if slotIndex == nil then return end

    local function CanForgeCurEquip(id, needCount, remainCoin)
        local data = ManagerContainer.CfgMgr:GetEquipById(id)
        local consumeId = data.ForgeOld
        if consumeId == 0 then
            return false
        end

        local consumeEquip = self.data.equipMap[data.ForgeOld]
        local consumeEquipData = ManagerContainer.CfgMgr:GetEquipById(data.ForgeOld)
        local count = consumeEquip == nil and 0 or consumeEquip.num
        local cost = consumeEquipData.CostMoney * (needCount / 3)
        --LogError(consumeId.."  "..count.."  forge id  "..id.."   consume  "..needCount)
        if cost <= remainCoin then
            remainCoin = remainCoin - cost
            if count < needCount then
                local lackCount = needCount - count
                local result = CanForgeCurEquip(consumeId, lackCount * 3, remainCoin)
                return result
            else
                return true
            end
        else
            lackCoin = true
            return false
        end
    end
    
    for k,v in pairs(slots) do
        local cfgId = v.equip_id
        if cfgId > 0 then
            local curEquip = ManagerContainer.CfgMgr:GetEquipById(cfgId)

            if self.data.typeEquips[curEquip.Type] ~= nil and curEquip.Forge > 0 then
                local ownCoin = ManagerContainer.DataMgr.UserData:GetOwnCoin()
                local remainOwn = ownCoin
                local logicData = self.data.equipMap[cfgId]
                local count = logicData == nil and 0 or logicData.num

                if curEquip.CostMoney <= remainOwn then
                    if count < 2 then
                        remainOwn = remainOwn - curEquip.CostMoney
                        local lackCount = 2 - count
                        local result = CanForgeCurEquip(cfgId, lackCount * 3, remainOwn)
                        slotsForgeStatus[k] = result
                    else
                        slotsForgeStatus[k] = true
                        lackCoin = false
                    end
                else
                    slotsForgeStatus[k] = false
                    lackCoin = true
                end

                if slotsForgeStatus[k] then
                    canForge = true
                    if onlyOne then
                        return canForge, slotsForgeStatus, lackCoin, lackEquip
                    end
                end
            end
        end
    end

    return canForge, slotsForgeStatus, lackCoin, lackEquip
end

function EquipData:GetAllCanForgeEquipIds(type, jobType, equipedId)
    local list = {}
    if self.data.typeEquips[type] == nil then return list end

    local ownCoin = ManagerContainer.DataMgr.UserData:GetOwnCoin()
    local totalCost = 0
    local remainCoin = ownCoin - totalCost
    local noMate = true

    local equipCfgDatas = ManagerContainer.CfgMgr:GetAllEquipDatasByTypeAndJob1(type, jobType, Enum.TableSortRule.Up)
    local minEquipData = equipCfgDatas[1]

    local tempCur = {}
    for i = 1,#equipCfgDatas do
        tempCur[equipCfgDatas[i].Id] = self.data.equipMap[equipCfgDatas[i].Id] and {cfgId = self.data.equipMap[equipCfgDatas[i].Id].cfgId, num = self.data.equipMap[equipCfgDatas[i].Id].num} or {cfgId = equipCfgDatas[i].Id, num = 0}
    end

    while(remainCoin >= minEquipData.CostMoney) do
        local needOver = true
        for i = #equipCfgDatas, 1, -1 do
            local cfgId = equipCfgDatas[i].Id
            local count = 3
            local continue = true
            if equipedId then
                if cfgId == equipedId then
                    count = 2
                elseif cfgId > equipedId then
                    continue = false
                end
            end
            if continue and tempCur[cfgId].num >= count and remainCoin >= equipCfgDatas[i].CostMoney and equipCfgDatas[i].Forge > 0 then
                local addCount = 1 --math.floor(tempCur[cfgId].num / 3)
                local forgeCost = addCount * equipCfgDatas[i].CostMoney
                if forgeCost > remainCoin then
                    addCount = math.floor(remainCoin/equipCfgDatas[i].CostMoney)
                    forgeCost = addCount * equipCfgDatas[i].CostMoney
                end

                noMate = false
                needOver = false

                tempCur[equipCfgDatas[i + 1].Id].num = tempCur[equipCfgDatas[i + 1].Id].num + addCount
                tempCur[cfgId].num = tempCur[cfgId].num - addCount * 3
                tempCur[cfgId].num = math.max(tempCur[cfgId].num, 0)
                remainCoin = remainCoin - forgeCost
                totalCost = totalCost + forgeCost
                if cfgId == equipedId then
                    needOver = true
                end
                break
            end
        end
        if needOver then
            break
        end
    end

    for k, v in pairs(tempCur) do
        if v.num > 0 then
            if self.data.equipMap[k] == nil then
                list[#list + 1] = {cfgId = k, num = v.num }
            elseif self.data.equipMap[k] ~= nil and self.data.equipMap[k].num < v.num then
                list[#list + 1] = {cfgId = k, num = v.num - self.data.equipMap[k].num }
            end
        end
    end
    if list then
        --CommonUtil.ArraySortSelections(list, Enum.TableSortRule.Down, "cfgId")
        table.sort(list, function (a,b)
            return a.cfgId > b.cfgId
        end)
    end
    return list, totalCost, noMate, ownCoin < totalCost
end

function EquipData:CanForgeById(consumeId)
    local consumeData = self:GetEquipDataMapById(consumeId)
    local coinEnough = false
    if consumeData ~= nil then
        local cfgData = ManagerContainer.CfgMgr:GetEquipById(consumeData.cfgId)
        local ownCoin = ManagerContainer.DataMgr.UserData:GetOwnCoin()
        coinEnough = cfgData.CostMoney <= ownCoin
    end
    return consumeData ~= nil and consumeData.num >= 3 and coinEnough
end

function EquipData:ProtocalDataToEquipData(protocalData)
    local equipData      = {}
    equipData.cfgId      = protocalData.config_id
    equipData.num        = protocalData.num
    return equipData
end

function EquipData:SortRule(a, b)
    local equipCfgDataA = ManagerContainer.CfgMgr:GetEquipById(a.cfgId)
    local equipCfgDataB = ManagerContainer.CfgMgr:GetEquipById(b.cfgId)
    if equipCfgDataA.EquipLevel == equipCfgDataB.EquipLevel then
        return a.cfgId > b.cfgId
    else
        return equipCfgDataA.EquipLevel > equipCfgDataB.EquipLevel
    end
end

return EquipData