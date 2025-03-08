local ChipData = class("ChipData", require("DataBase"))

function ChipData:ctor()
    self.data = {}
end

function ChipData:InitChipData(data)
    local chips = {}
    local cfgMgr = ManagerContainer.CfgMgr
    if data and data.chip_list then
        for i = 1, #data.chip_list do
            local chipData = data.chip_list[i]
            if chipData then
                local chip = self:ProtocalDataToChipData(chipData)
                local itemCfgData = cfgMgr:GetItemById(chip.cfgId)
                if not itemCfgData then
                    LogError("[Wboy] .. ".. chip.cfgId .. "道具ID不存在")
                else
                    chips[chip.cfgId] = chip
                end
            end
        end
    end
    self.data.chips = chips
end

function ChipData:GetChipById(id)
    return self.data.chips[id]
end

function ChipData:GetChipCountById(id)
    local data = self.data.chips[id]
    if data then
        return data.num
    end
    return 0
end

function ChipData:GetAllChipDatas()
    return self.data.chips
end

function ChipData:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CHIP_CHANGE_NTF, function(data)
        local chips = self.data.chips
        local addChipMap = {}
        local cfgMgr = ManagerContainer.CfgMgr
        for _,chipData in ipairs(data.chip_list) do
            local cfgId = chipData.config_id
            local itemCfgData = cfgMgr:GetItemById(cfgId)
            if not itemCfgData then
                LogError("[Wboy] .. ".. cfgId .. "道具ID不存在")
            else
                local num = chipData.num
                if num <= 0 then
                    -- 删除碎片
                    chips[cfgId] = nil
                else
                    local chip = chips[cfgId]
                    local lastNum = chip and chip.num or 0
                    local newChip = self:ProtocalDataToChipData(chipData)
                    chips[cfgId] = newChip
                    local addNum = newChip.num - lastNum
                    -- 当前增加的碎片
                    if addNum > 0 then
                        if addChipMap[cfgId] then
                            addChipMap[cfgId] = addChipMap[cfgId] + addNum
                        else
                            addChipMap[cfgId] = addNum
                        end
                    end
                end
            end
        end
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_EQUIP_AND_ITEM_ADD, addChipMap)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.CHIP_CHANGE)
    end)
end

function ChipData:Clear()
    self.data = {}
end

function ChipData:Destroy()
    if self.Clear then
        self:Clear()
    end

    self:UnRegisterNetEvents()
end

function ChipData:UnRegisterNetEvents()

end

function ChipData:ProtocalDataToChipData(protocalData)
    local chipData      = {}
    chipData.cfgId      = protocalData.config_id
    chipData.num        = protocalData.num
    chipData.timeStamp  = protocalData.time_stamp
    return chipData
end

return ChipData