local HeroRPCtr = class("HeroRPCtr", require("RPBase"))
local HeroSkillRPCtr = require("HeroSkillRPCtr")
local BitUtil = require("BitUtil")

function HeroRPCtr:ctor()

end

--function HeroRPCtr:RefreshRoleUIRedPointNtfById(id)
--    if id == 1 then
--        self:HeroEquipDressRPNotify()
--        self:HeroEquipForgeRPNotify()
--        self:HeroEquipRefineRPNotify()
--    else
--        self:PartnerEquipDressNotify(id)
--        self:PartnerEquipForgeNotify(id)
--        self:PartnerEquipRefineRPNotify(id)
--    end
--end

function HeroRPCtr:Init()
    self.heroAttrRP = false
    self.heroEquipDressRP = { false, false, false, false, false, false}
    self.heroEquipForgeRP =  { false, false, false, false, false, false}
    self.heroEquipRefineRP = { false, false, false, false, false, false}
    self.heroTransferRP = false

    self.partnerAttrRP = { [2] = false, [3] = false, [4] = false, [5] = false, [6] = false}

    self.partnerEquipDressRP = {
        [2] = {false,false,false,false,false,false},
        [3] = {false,false,false,false,false,false},
        [4] = {false,false,false,false,false,false},
        [5] = {false,false,false,false,false,false},
        [6] = {false,false,false,false,false,false}
    }
    self.partnerEquipForgeRP =  {
        [2] = {false,false,false,false,false,false},
        [3] = {false,false,false,false,false,false},
        [4] = {false,false,false,false,false,false},
        [5] = {false,false,false,false,false,false},
        [6] = {false,false,false,false,false,false}
    }
    self.partnerEquipRefineRP =  {
        [2] = {false,false,false,false,false,false},
        [3] = {false,false,false,false,false,false},
        [4] = {false,false,false,false,false,false},
        [5] = {false,false,false,false,false,false},
        [6] = {false,false,false,false,false,false}
    }
    self.partnerLvUpRP = {[2] = false, [3] = false, [4] = false, [5] = false, [6] = false}
    self.partnerStrengthRP = {[2] = false, [3] = false, [4] = false, [5] = false, [6] = false}
    self.partnerTransferRP = {[2] = false, [3] = false, [4] = false, [5] = false, [6] = false}

    self.partnerRecruitRP = {[2] = false, [3] = false, [4] = false, [5] = false, [6] = false}

    self.fashionNewRP = false

    if self.heroSkillRPCtr then
        self.heroSkillRPCtr:Dispose()
    end
    self.heroSkillRPCtr = HeroSkillRPCtr:new()

    self.cardSlotState = {0,0,0,0,0,0}
    self.roleCardSlotRP = {
        [1] = {0,0,0,0,0,0},
        [2] = {0,0,0,0,0,0},
        [3] = {0,0,0,0,0,0},
        [4] = {0,0,0,0,0,0},
        [5] = {0,0,0,0,0,0},
        [6] = {0,0,0,0,0,0},
    }

    self.roleCardEmptySlotRP = {
        [1] = {false,false,false,false,false,false},
        [2] = {false,false,false,false,false,false},
        [3] = {false,false,false,false,false,false},
        [4] = {false,false,false,false,false,false},
        [5] = {false,false,false,false,false,false},
        [6] = {false,false,false,false,false,false},
    }

    self.roleCardSlotUpRP = {
        [1] = false,
        [2] = false,
        [3] = false,
        [4] = false,
        [5] = false,
        [6] = false,
    }

    self.skillEquipSlotRP = {
        [1] = false,
        [2] = false,
        [3] = false,
        [4] = false,
        [5] = false,
        [6] = false,
    }
end

function HeroRPCtr:GetEquipDressRPByUid(uid)
    if uid == 1 then
        return self.heroEquipDressRP
    else
        local index = ManagerContainer.DataMgr.UserData:GetSlotIndexByHeroId(uid)
        return self.partnerEquipDressRP[index]
    end
end

function HeroRPCtr:GetEquipUpgradeRPByUid(uid)
    if uid == 1 then
        return self.heroEquipForgeRP
    else
        local index = ManagerContainer.DataMgr.UserData:GetSlotIndexByHeroId(uid)
        return self.partnerEquipForgeRP[index]
    end
end

function HeroRPCtr:GetEquipRefineRPByUid(uid)
    if uid == 1 then
        return self.heroEquipRefineRP
    else
        local index = ManagerContainer.DataMgr.UserData:GetSlotIndexByHeroId(uid)
        return self.partnerEquipRefineRP[index]
    end
end

function HeroRPCtr:RoleRedPointNotify()
    self:HeroRedPointNotify()
    self:PartnerRedPointNotify()

    self:RefreshRoleCardRP()
    self:RefreshRoleSkillEquipRP()
end

function HeroRPCtr:RoleTransferRedPointNotify()
    self:HeroTransferNotify()
    for i = 2, 6 do
        self:PartnerTransferNotify(i)
    end
end

function HeroRPCtr:HeroRedPointNotify()
    self:HeroAttrRPNotify()
    self:HeroTransferNotify()
    self:HeroEquipDressRPNotify()
    self:HeroEquipForgeRPNotify()
    self:HeroEquipRefineRPNotify()
end

function HeroRPCtr:HeroEquipNotify()
    self:HeroEquipDressRPNotify()
    self:HeroEquipForgeRPNotify()
    self:HeroEquipRefineRPNotify()
end

function HeroRPCtr:RefreshRoleCardRP()
    for i = 1, 6 do
        self:RefreshRoleCardSlotEmptyRP(i)
        self:RefreshRoleCardSlotUpRP(i)
    end

    self:RefreshRoleCardSlotEmptyRPNtf()
    self:RefreshRoleCardSlotUpRPNtf()
end

function HeroRPCtr:RefreshRoleSkillEquipRP()
    for i = 1, 6 do
        self:RefreshRoleSkillEquipSlotRP(i)
    end

    self:RefreshRoleSkillEquipSlotNtf()
end

function HeroRPCtr:RefreshRoleSkillEquipRPById(id)
    self:RefreshRoleSkillEquipSlotRP(id)

    self:RefreshRoleSkillEquipSlotNtf()
end

function HeroRPCtr:HeroAttrRPNotify()
    self.heroAttrRP = false

    local logicData = ManagerContainer.DataMgr.UserData:GetHeroData()
    local pointNum = ManagerContainer.DataMgr.UserData:GetRoleDataAttrPoints()
    local pointData = ManagerContainer.CfgMgr.QualityPointCfg

    local strAttr = SDataUtil.InvConvert(logicData.attrs[Enum.HeroAttrType.STR])
    if SDataUtil.IsLess(strAttr, #pointData) and SDataUtil.IsLessEqual(pointData[strAttr].cost, pointNum) then
        self.heroAttrRP = true
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.LeaderAttr, true)
        return
    end

    local agiAttr = SDataUtil.InvConvert(logicData.attrs[Enum.HeroAttrType.AGI])
    if SDataUtil.IsLess(agiAttr, #pointData) and SDataUtil.IsLessEqual(pointData[agiAttr].cost, pointNum) then
        self.heroAttrRP = true
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.LeaderAttr, true)
        return
    end

    local intAttr = SDataUtil.InvConvert(logicData.attrs[Enum.HeroAttrType.INT])
    if SDataUtil.IsLess(intAttr, #pointData) and SDataUtil.IsLessEqual(pointData[intAttr].cost, pointNum) then
        self.heroAttrRP = true
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.LeaderAttr, true)
        return
    end

    local vitAttr = SDataUtil.InvConvert(logicData.attrs[Enum.HeroAttrType.VIT])
    if SDataUtil.IsLess(vitAttr, #pointData) and SDataUtil.IsLessEqual(pointData[vitAttr].cost, pointNum) then
        self.heroAttrRP = true
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.LeaderAttr, true)
        return
    end

    local dexAttr = SDataUtil.InvConvert(logicData.attrs[Enum.HeroAttrType.DEX])
    if SDataUtil.IsLess(dexAttr, #pointData) and SDataUtil.IsLessEqual(pointData[dexAttr].cost, pointNum) then
        self.heroAttrRP = true
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.LeaderAttr, true)
        return
    end

    local lukAttr = SDataUtil.InvConvert(logicData.attrs[Enum.HeroAttrType.LUK])
    if SDataUtil.IsLess(lukAttr, #pointData) and SDataUtil.IsLessEqual(pointData[lukAttr].cost, pointNum) then
        self.heroAttrRP = true
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.LeaderAttr, true)
        return
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.LeaderAttr, false)
end

function HeroRPCtr:HeroEquipDressRPNotify()
    self.heroEquipDressRP = { false, false, false, false, false, false}

    local count = ManagerContainer.DataMgr.EquipData:GetAllEquipCount()
    if count == 0 then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.EquipDress, false, 1)
        return
    end

    local slots = ManagerContainer.DataMgr.UserData:GetCurSlotInfos(1)

    if #slots > 0 then
        for i = 1, #slots do
            local equiDatas
            if i == Enum.SlotEquipType.Weapon then
                local jobData = ManagerContainer.CfgMgr:GetJobDataById(ManagerContainer.DataMgr.UserData:GetJobCfgId())
                equiDatas = ManagerContainer.DataMgr.EquipData:GetAllWeaponEquipDatasFlterJobType(jobData.JobType)
            else
                equiDatas = ManagerContainer.DataMgr.EquipData:GetAllEquipDatasByType(i)
            end
            if equiDatas ~= nil then
                local slotEquipData = ManagerContainer.CfgMgr:GetEquipById(slots[i].equip_id)
                for _,v in pairs(equiDatas) do
                    local cfgData = ManagerContainer.CfgMgr:GetEquipById(v.cfgId)
                    if slotEquipData == nil and cfgData.Type == i then
                        self.heroEquipDressRP[i] = true
                    elseif slotEquipData ~= nil and cfgData.Type == slotEquipData.Type and cfgData.EquipLevel > slotEquipData.EquipLevel then
                        self.heroEquipDressRP[i] = true
                    end
                end
            else
            end
        end
    else
        for i = 1, 6 do
            local equiDatas
            if i == Enum.SlotEquipType.Weapon then
                local jobData = ManagerContainer.CfgMgr:GetJobDataById(ManagerContainer.DataMgr.UserData:GetJobCfgId())
                equiDatas = ManagerContainer.DataMgr.EquipData:GetAllWeaponEquipDatasFlterJobType(jobData.JobType)
            else
                equiDatas = ManagerContainer.DataMgr.EquipData:GetAllEquipDatasByType(i)
            end
            if equiDatas ~= nil then
                for _,v in pairs(equiDatas) do
                    local cfgData = ManagerContainer.CfgMgr:GetEquipById(v.cfgId)
                    if cfgData.Type == i then
                        self.heroEquipDressRP[i] = true
                    end
                end
            end
        end
    end

    local state = false
    for i = 1,#self.heroEquipDressRP do
        if self.heroEquipDressRP[i] then
            state = true
        end
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.EquipDress, state, 1)
end

function HeroRPCtr:HeroEquipForgeRPNotify()
    self.heroEquipForgeRP =  { false, false, false, false, false, false}
    --local unlockState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(13)
    --if not unlockState then
    --    return
    --end

    local canForge, slotsForgeStatus = ManagerContainer.DataMgr.EquipData:GetForgeStatus(1)
    self.heroEquipForgeRP = slotsForgeStatus
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.EquipLvUp, canForge, 1)
end

function HeroRPCtr:HeroEquipRefineRPNotify()
    self.heroEquipRefineRP = { false, false, false, false, false, false}
    --local unlockState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(17)
    --if not unlockState then
    --    return
    --end

    local slots = ManagerContainer.DataMgr.UserData:GetCurSlotInfos(1)

    if #slots > 0 then
        for i = 1, #slots do
            if slots[i].equip_id > 0 then
                local refineLv = slots[i].level + 1
                local curRefineData = ManagerContainer.CfgMgr:GetEquipRefineDataByLv(refineLv)
                if curRefineData ~= nil then
                    local is1 = CommonUtil.EleInTable(i, curRefineData.Place1)
                    local index = is1 and 1 or 2

                    local ownedCoin = ManagerContainer.DataMgr.UserData:GetCurrency(Enum.ItemType.Coin)
                    local ownedItem = ManagerContainer.DataMgr.BagData:GetItemCountByCfgId( curRefineData["Costitem"..index][1][1])
                    if curRefineData["Costzeny"..index] <= ownedCoin and curRefineData["Costitem"..index][1][2] <= ownedItem then
                        self.heroEquipRefineRP[i] = true
                    end
                end
           end
        end
    end

    local state = false
    for i = 1,#self.heroEquipRefineRP do
        if self.heroEquipRefineRP[i] then
            state = true
        end
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.EquipRefine, state, 1)
end

function HeroRPCtr:PartnerRedPointNotify()
    for i = 2, 6 do
        self:PartnerRedPointNotifyById(i)
        self:PartnerRecruitNotifyById(i)
    end
end

function HeroRPCtr:PartnerRedPointNotifyById(id)
    self:PartnerAttrRPNotify(id)
    self:PartnerLvUpNotify(id)
    self:PartnerStrengthNotify(id)
    self:PartnerTransferNotify(id)
    self:PartnerEquipDressNotify(id)
    self:PartnerEquipForgeNotify(id)
    self:PartnerEquipRefineRPNotify(id)
end

function HeroRPCtr:PartnerEquipNotify()
    for i = 2, 6 do
        self:PartnerEquipDressNotify(i)
        self:PartnerEquipForgeNotify(i)
        self:PartnerEquipRefineRPNotify(i)
    end
end

function HeroRPCtr:PartnerItemChangeRPNotify()
    for i = 2, 6 do
        self:PartnerStrengthNotify(i)
        self:PartnerEquipRefineRPNotify(i)
    end
end

function HeroRPCtr:PartnerRecruitNotify()
    for i = 2, 6 do
        self:PartnerRecruitNotifyById(i)
        self:PartnerAttrRPNotify(i)
    end
end

function HeroRPCtr:PartnerAttrRPNotify(id)
    self.partnerAttrRP[id] = false

    local logicData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(id)
    if not logicData.owned then return end

    local pointNum = ManagerContainer.DataMgr.PartnerData:GetRoleDataAttrPoints(id)
    local pointData = ManagerContainer.CfgMgr.QualityPointCfg

    local strAttr = SDataUtil.InvConvert(logicData.attrs[Enum.HeroAttrType.STR] or 0)
    if SDataUtil.IsLess(strAttr, #pointData) and SDataUtil.IsLessEqual(pointData[strAttr].cost, pointNum) then
        self.partnerAttrRP[id] = true
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.PtAttr, true)
        return
    end

    local agiAttr = SDataUtil.InvConvert(logicData.attrs[Enum.HeroAttrType.AGI] or 0)
    if SDataUtil.IsLess(agiAttr, #pointData) and SDataUtil.IsLessEqual(pointData[agiAttr].cost, pointNum) then
        self.partnerAttrRP[id] = true
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.PtAttr, true)
        return
    end

    local intAttr = SDataUtil.InvConvert(logicData.attrs[Enum.HeroAttrType.INT] or 0)
    if SDataUtil.IsLess(intAttr, #pointData) and SDataUtil.IsLessEqual(pointData[intAttr].cost, pointNum) then
        self.partnerAttrRP[id] = true
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.PtAttr, true)
        return
    end

    local vitAttr = SDataUtil.InvConvert(logicData.attrs[Enum.HeroAttrType.VIT] or 0)
    if SDataUtil.IsLess(vitAttr, #pointData) and SDataUtil.IsLessEqual(pointData[vitAttr].cost, pointNum) then
        self.partnerAttrRP[id] = true
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.PtAttr, true)
        return
    end

    local dexAttr = SDataUtil.InvConvert(logicData.attrs[Enum.HeroAttrType.DEX] or 0)
    if SDataUtil.IsLess(dexAttr, #pointData) and SDataUtil.IsLessEqual(pointData[dexAttr].cost, pointNum) then
        self.partnerAttrRP[id] = true
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.PtAttr, true)
        return
    end

    local lukAttr = SDataUtil.InvConvert(logicData.attrs[Enum.HeroAttrType.LUK] or 0)
    if SDataUtil.IsLess(lukAttr, #pointData) and SDataUtil.IsLessEqual(pointData[lukAttr].cost, pointNum) then
        self.partnerAttrRP[id] = true
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.PtAttr, true)
        return
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.PtAttr, false)
end

function HeroRPCtr:PartnerLvUpNotify(id)
    self.partnerLvUpRP[id] = false

    local partnerDatas = ManagerContainer.DataMgr.PartnerData:GetPartnerDatas()

    for _, v1 in pairs(partnerDatas) do
        if v1.id > 0 and v1.owned and v1.id == id then
            local index = ManagerContainer.DataMgr.UserData:GetSlotIndexByHeroId(v1.id)
            local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(v1.configId)
            local stepData = ManagerContainer.CfgMgr:GetParterProgressById(cfgData.ParterJob)
            local curMaxLv
            if stepData ~= nil then
                curMaxLv = stepData.AddLv[v1.advanceLevel + 1]
                if v1.baseLevel >= curMaxLv and v1.advanceLevel < #stepData.CostMoney then
                    local canAdvence = curMaxLv == v1.baseLevel and (v1.advanceLevel + 1) < #stepData.AddLv
                    local ownCoin = ManagerContainer.DataMgr.UserData:GetOwnCoin()
                    local coinResult = stepData.CostMoney[v1.advanceLevel + 1] <= ownCoin
                    local ownStone = ManagerContainer.DataMgr.BagData:GetItemByCfgId(Enum.ItemIndex.PartnerStone)
                    local stoneResult = stepData.CostStone[v1.advanceLevel + 1] <= (ownStone ~= nil and ownStone.num or 0)
                    if canAdvence and coinResult and stoneResult then
                        self.partnerLvUpRP[index] = true
                    end
                end
            end

            if not self.partnerLvUpRP[index] then
                if v1.baseLevel < curMaxLv then
                    local lvData = ManagerContainer.CfgMgr:GetParterAttributeByLv(v1.baseLevel)
                    local ownCoin = ManagerContainer.DataMgr.UserData:GetOwnCoin()
                    local coinResult = lvData.Money <= ownCoin
                    local ownExp = ManagerContainer.DataMgr.UserData:GetHeroExp()
                    local expResult = lvData.Exp <= ownExp
                    self.partnerLvUpRP[index] = coinResult and v1.baseLevel < curMaxLv and expResult and (stepData == nil and true or v1.advanceLevel <= #stepData.AddLv)
                end
            end
        end
    end
end

function HeroRPCtr:PartnerStrengthNotify(id)
    self.partnerStrengthRP[id] = false
    local unlockState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(16)
    if not unlockState then
        return
    end

    local partnerDatas = ManagerContainer.DataMgr.PartnerData:GetPartnerDatas()

    for _, v1 in pairs(partnerDatas) do
        if v1.id > 0 and v1.owned and v1.id == id then
            local index = ManagerContainer.DataMgr.UserData:GetSlotIndexByHeroId(v1.id)
            local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(v1.configId)
            local stepData = ManagerContainer.CfgMgr:GetParterProgressById(cfgData.ParterJob)
            if stepData ~= nil then
                if v1.strengthLevel < stepData.BreachTimes then
                    local canStrength = true
                    local ownCoin = ManagerContainer.DataMgr.UserData:GetOwnCoin()
                    local cost = stepData.BreachMoney[v1.strengthLevel + 1]
                    if cost then
                        local coinResult = cost <= ownCoin
                        local resCount = CommonUtil.GetOwnResCountByItemId(stepData.BreachCost[v1.strengthLevel + 1][1])
                        local resResult = stepData.BreachCost[v1.strengthLevel + 1][2] <= resCount
                        if canStrength and coinResult and resResult then
                            self.partnerStrengthRP[index] = true
                        end
                    end
                end
            end
        end
    end

    --ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.PtBreak, self.partnerStrengthRP[id])
end

function HeroRPCtr:PartnerEquipDressNotify(id)
    self.partnerEquipDressRP[id] = {false,false,false,false,false,false}

    local logicData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(id)
    if not logicData.owned or not logicData.isBattle then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.EquipDress, false, id)
        return
    end

    local partnerDatas = ManagerContainer.DataMgr.PartnerData:GetPartnerDatas()

    for _, v1 in pairs(partnerDatas) do
        if v1.id > 0 and v1.owned and v1.id == id then
            --equip
            local count = ManagerContainer.DataMgr.EquipData:GetAllEquipCount()
            if count == 0 then
                ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.EquipDress, false, id)
                return
            end

            local slots = v1.slot.slot_list
            local slotIndex = v1.id
            if slots ~= nil and #slots > 0 then
                for i = 1, #slots do
                    local equiDatas
                    if i == Enum.SlotEquipType.Weapon then
                        local partnerData = ManagerContainer.CfgMgr:GetPartnerDataById(v1.configId)
                        equiDatas = ManagerContainer.DataMgr.EquipData:GetAllWeaponEquipDatasFlterJobType(partnerData.JobType)
                    else
                        equiDatas = ManagerContainer.DataMgr.EquipData:GetAllEquipDatasByType(i)
                    end
                    if equiDatas ~= nil then
                        local slotEquipData = ManagerContainer.CfgMgr:GetEquipById(slots[i].equip_id)
                        for _,v in pairs(equiDatas) do
                            local cfgData = ManagerContainer.CfgMgr:GetEquipById(v.cfgId)
                            if slotEquipData == nil and cfgData.Type == i then
                                self.partnerEquipDressRP[slotIndex][i] = true
                            elseif slotEquipData ~= nil and cfgData.Type == slotEquipData.Type and cfgData.EquipLevel > slotEquipData.EquipLevel then
                                self.partnerEquipDressRP[slotIndex][i] = true
                            end
                        end
                    end
                end
            else
                for i = 1, 6 do
                    local equiDatas
                    if i == Enum.SlotEquipType.Weapon then
                        local partnerData = ManagerContainer.CfgMgr:GetPartnerDataById(v1.configId)
                        equiDatas = ManagerContainer.DataMgr.EquipData:GetAllWeaponEquipDatasFlterJobType(partnerData.JobType)
                    else
                        equiDatas = ManagerContainer.DataMgr.EquipData:GetAllEquipDatasByType(i)
                    end
                    if equiDatas ~= nil then
                        for _,v in pairs(equiDatas) do
                            local cfgData = ManagerContainer.CfgMgr:GetEquipById(v.cfgId)
                            if cfgData.Type == i then
                                self.partnerEquipDressRP[slotIndex][i] = true
                            end
                        end
                    end
                end
            end
        end
    end

    local state = false
    for i = 1,#self.partnerEquipDressRP[id] do
        if self.partnerEquipDressRP[id][i] then
            state = true
        end
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.EquipDress, state, id)
end

function HeroRPCtr:PartnerEquipForgeNotify(id)
    self.partnerEquipForgeRP[id] =  {false,false,false,false,false,false}

    local logicData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(id)
    if not logicData.owned or not logicData.isBattle then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.EquipLvUp, false, id)
        return
    end

    --local unlockState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(13)
    --if not unlockState then
    --    return
    --end
    local partnerDatas = ManagerContainer.DataMgr.PartnerData:GetPartnerDatas()

    for _, v1 in pairs(partnerDatas) do
        if v1.id > 0 and v1.owned and v1.id == id then
            --equip
            local count = ManagerContainer.DataMgr.EquipData:GetAllEquipCount()
            if count == 0 then
                return
            end

            local result, status = ManagerContainer.DataMgr.EquipData:GetForgeStatus(v1.id)
            self.partnerEquipForgeRP[v1.id] = status
        end
    end

    local state = false
    for i = 1,#self.partnerEquipForgeRP[id] do
        if self.partnerEquipForgeRP[id][i] then
            state = true
        end
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.EquipLvUp, state, id)
end


function HeroRPCtr:PartnerEquipRefineRPNotify(id)
    self.partnerEquipRefineRP[id] =  {false,false,false,false,false,false}

    local logicData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(id)
    if not logicData.owned or not logicData.isBattle then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.EquipRefine, false, id)
        return
    end
    --local unlockState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(17)
    --if not unlockState then
    --    return
    --end
    local partnerDatas = ManagerContainer.DataMgr.PartnerData:GetPartnerDatas()
    for _, v1 in pairs(partnerDatas) do
        if v1.id > 0 and v1.owned and v1.id == id then
            local slots = v1.slot.slot_list
            local slotIndex = v1.id
            if #slots > 0 then
                for i = 1, #slots do
                    if slots[i].equip_id > 0 then
                        local refineLv = slots[i].level + 1
                        local curRefineData = ManagerContainer.CfgMgr:GetEquipRefineDataByLv(refineLv)
                        if curRefineData ~= nil then
                            local is1 = CommonUtil.EleInTable(i, curRefineData.Place1)
                            local index = is1 and 1 or 2

                            local ownedCoin = ManagerContainer.DataMgr.UserData:GetCurrency(Enum.ItemType.Coin)
                            local ownedItem = ManagerContainer.DataMgr.BagData:GetItemCountByCfgId( curRefineData["Costitem"..index][1][1])
                            if curRefineData["Costzeny"..index] <= ownedCoin and curRefineData["Costitem"..index][1][2] < ownedItem then
                                self.partnerEquipRefineRP[slotIndex][i] = true
                            end
                        end
                    end
                end
            end
        end
    end

    local state = false
    for i = 1,#self.partnerEquipRefineRP[id] do
        if self.partnerEquipRefineRP[id][i] then
            state = true
        end
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.EquipRefine, state, id)
end

function HeroRPCtr:HeroTransferNotify()
    self.heroTransferRP = false
    --local lockState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(11)
    --if not lockState then
    --    return
    --end
    local logicData = ManagerContainer.DataMgr.UserData:GetHeroData()
    local jobData = ManagerContainer.CfgMgr:GetJobDataById(logicData.configId)
    if jobData.ChangeCond then
        for i = 1, #jobData.ChangeCond do
            local condId = jobData.ChangeCond[i]
            local task = ManagerContainer.DataMgr.TaskDataNew:GetChangeJobTaskData(logicData.id, condId)
            self.heroTransferRP = task ~= nil and task.state ~= Enum.TaskStateType.NoCompeleted
        end
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.LeaderTransfer, self.heroTransferRP)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.Transfer, self.heroTransferRP, 1)
end

function HeroRPCtr:PartnerTransferNotify(id)
    self.partnerTransferRP[id] = false
    --local lockState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(12)
    --if not lockState then
    --    return
    --end
    self:PartnerTransferNotifyById(id)
end

function HeroRPCtr:PartnerTransferNotifyById(id)
    local logicData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(id)
    if logicData == nil then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.PtTransfer, false, id)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.Transfer, false, id)
        return
    end

    local jobData = ManagerContainer.CfgMgr:GetPartnerDataById(logicData.configId)
    local canTransfer = false
    if jobData.ChangeCond then
        for i = 1, #jobData.ChangeCond do
            local condId = jobData.ChangeCond[i]
            local task = ManagerContainer.DataMgr.TaskDataNew:GetChangeJobTaskData(logicData.id, condId)
            canTransfer = task ~= nil and task.state ~= Enum.TaskStateType.NoCompeleted
        end
    end
    if jobData.JobStage >= GlobalConfig.Instance:GetConfigIntValue(103) then
        canTransfer = false
    end

    self.partnerTransferRP[id] = canTransfer
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.PtTransfer, canTransfer, id)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.Transfer, canTransfer, id)
end

function HeroRPCtr:PartnerRecruitNotifyById(id)
    self.partnerRecruitRP[id] = false
    local logicData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(id)
    if logicData == nil then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.PtRecruit, false, id)
        return
    end

    local resNum = CommonUtil.GetOwnResCountByItemId(Enum.ItemIds.Recruit)
    self.partnerRecruitRP[id] = resNum > 0 and not logicData.owned

    if self.partnerRecruitRP[id] then
        local userLogicData = ManagerContainer.DataMgr.UserData:GetHeroData()
        local jobData = ManagerContainer.CfgMgr:GetJobDataById(userLogicData.configId)
        local resCount = CommonUtil.GetOwnResCountByItemId(Enum.ItemIds.Recruit)
        local owndCount = ManagerContainer.DataMgr.PartnerData:GetOwnedPartnerCount()

        if jobData.JobStage == 1 and resCount >= 1 and owndCount == 0 then
            local partnerData = ManagerContainer.CfgMgr:GetPartnerDataById(logicData.configId)
            local recommend = Enum.JobRecommend[jobData.JobType]
            if partnerData.JobType ~= recommend[1] then
                self.partnerRecruitRP[id] = false
            end
        end
    end

    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.PtRecruit, self.partnerRecruitRP[id], id)
end

function HeroRPCtr:InitCardSlotState(cardSlotList)
    for k,v in pairs(cardSlotList) do
        self.cardSlotState[k] = v
    end
end

function HeroRPCtr:RoleCardSlotRPNotify(cardSlotList)
    local list
    for k,v in pairs(cardSlotList) do
        local key = v.key
        local val = v.value
        if val > self.cardSlotState[key] then
            local delta = val - self.cardSlotState[key]
            list = {}
            for i = 0, 3 do
                local opened = BitUtil.RshiftNumBandOne(delta, i) == 1
                if opened then
                    list[#list + 1] = i
                end
            end
            self.cardSlotState[key] = val

            for k1,v1 in pairs(self.roleCardSlotRP) do
                if k1 == 1 then
                    for k2,v2 in pairs(list) do
                        v1[key] = v1[key] + delta
                    end
                else
                    local logicData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(k1)
                    if logicData.owned and logicData.isBattle then
                        for k2,v2 in pairs(list) do
                            v1[key] = v1[key] + delta
                        end
                    end
                end
            end

            self:RefreshRoleCardRP()
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.CardSlot, true)
        end
    end
end

function HeroRPCtr:RefreshRoleCardSlotRP(id)
    if id == nil or id < 1 or id > 6 then return end
    --if equipIdx < 1 or equipIdx > 6 then return end

    --if self.roleCardSlotRP[id][equipIdx] == 0 then return end

    for i = 1, 6 do
        self.roleCardSlotRP[id][i] = 0
    end

    local result = false
    for k,v in pairs(self.roleCardSlotRP) do
        for k1,v1 in pairs(v) do
            if v1 > 0 then
                result = true
            end
        end
    end

    if not result then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.CardSlot, false)
    end

    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.CARDSLOT_REDPOINT_ROLE_UI_NTF)
end

function HeroRPCtr:GetRoleCardSlotRP(id, equipIdx, cardIdx)
    if id == nil or id < 1 or id > 6 then return Enum.RedPointEnum.None end

    local state = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(20)
    if not state then
        return Enum.RedPointEnum.None
    end

    if not equipIdx then
        local result = false
        for k,v in pairs(self.roleCardSlotRP[id]) do
            if v > 0 then
                result = true
            end
        end
        return result and Enum.RedPointEnum.CardSlotRP or Enum.RedPointEnum.None
    else
        if equipIdx < 1 or equipIdx > 6 then return Enum.RedPointEnum.None end
        if not cardIdx then
            return self.roleCardSlotRP[id][equipIdx] > 0 and Enum.RedPointEnum.CardSlotRP or Enum.RedPointEnum.None
        else
            if cardIdx < 0 or cardIdx > 3 then return Enum.RedPointEnum.None end

            local opened = BitUtil.RshiftNumBandOne(self.roleCardSlotRP[id][equipIdx], cardIdx) == 1
            return opened and Enum.RedPointEnum.CardSlotRP or Enum.RedPointEnum.None
        end
    end
end

function HeroRPCtr:GetCardSlotCountByType(type)
    local count = 0
    for i = 0, 3 do
        local cardSlot = self.cardSlotState[type]
        local opened = BitUtil.RshiftNumBandOne(cardSlot, i) == 1
        if opened then
            count = i + 1
        end
    end
    return count
end

function HeroRPCtr:RefreshRoleCardSlotEmptyRP(id)
    self.roleCardEmptySlotRP[id] = {false,false,false,false,false,false}

    local state = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(41)
    if not state then
        return false
    end

    local logicData, jobType
    if id == 1 then
        logicData = ManagerContainer.DataMgr.UserData:GetHeroData()
        local jobData = ManagerContainer.CfgMgr:GetJobDataById(logicData.configId)
        jobType = jobData.JobType
    else
        logicData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(id)
        local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(logicData.configId)
        jobType = cfgData.JobType

        if not logicData.owned or not logicData.isBattle then return end
    end

    local slot = ManagerContainer.DataMgr.UserData:GetSlotInfoById(id)
    local slotList = slot.slot_list

    if slotList == nil then return end

    for i = 1, 6 do
        local emptySlot = 0
        if slotList[i] ~= nil and slotList[i].equip_id > 0 then
            local cardList = slotList[i].card_id_list
            local cardSlotCount = self:GetCardSlotCountByType(i)
            for j = 1, cardSlotCount do
                if cardList[j] == 0 or cardList[j] == nil then
                    emptySlot = emptySlot + 1
                end
            end
            if emptySlot > 0 then
                local list = ManagerContainer.DataMgr.CardData:GetAllCardDatasByType(i)
                local cardDatas = CommonUtil.ArrayFilterSelections(list, Enum.FilterType.AND, {"Profession"}, {jobType})
                if cardDatas ~= nil and next(cardDatas) then
                    self.roleCardEmptySlotRP[id][i] = true
                end
            end
        end
    end
end

function HeroRPCtr:RefreshRoleCardSlotEmptyRPNtf()
    for _,v in pairs(self.roleCardEmptySlotRP) do
        for _,v1 in pairs(v) do
            if v1 then
                ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.CardEmpty, true)
                return
            end
        end
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.CardEmpty, false)
end

function HeroRPCtr:GetRoleCardSlotEmptyRP(id, slot)
    if not slot then
        for _,v in pairs(self.roleCardEmptySlotRP[id]) do
            if v then
                return true
            end
        end
    else
        return self.roleCardEmptySlotRP[id][slot]
    end
    return false
end

function HeroRPCtr:RefreshRoleCardSlotUpRP(id)
    self.roleCardSlotUpRP[id] = false

    local state = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(53)
    if not state then
        return false
    end

    local logicData
    if id == 1 then
        logicData = ManagerContainer.DataMgr.UserData:GetHeroData()
    else
        logicData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(id)

        if not logicData.owned or not logicData.isBattle then return end
    end

    local slot = ManagerContainer.DataMgr.UserData:GetSlotInfoById(id)
    local slotList = slot.slot_list

    if slotList == nil then return end

    local costId = Enum.ItemIds.Coin
    local remainRes = CommonUtil.GetOwnResCountByItemId(costId)
    --if remainRes < ManagerContainer.DataMgr.CardData:GetComposeOnceCostNum() then
    --    return
    --end

    for i = 1, 6 do
        if slotList[i] ~= nil and slotList[i].equip_id > 0 then
            local cardList = slotList[i].card_id_list
            for j = 1, #cardList do
                local cfgId = cardList[j]
                if cfgId > 0 then
                    local result = ManagerContainer.DataMgr.CardData:CanCurCardUp(cfgId, 1, remainRes, true)
                    if result then
                        self.roleCardSlotUpRP[id] = true
                        return
                    end
                end
            end
        end
    end
end

function HeroRPCtr:RefreshRoleCardSlotUpRPNtf()
    for _,v in pairs(self.roleCardSlotUpRP) do
        if v then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.CardLvUp, true)
            return
        end
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.CardLvUp, false)
end

function HeroRPCtr:RefreshRoleSkillEquipSlotRP(id)
    self.skillEquipSlotRP[id] = false

    local state = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(74)
    if not state then
        return false
    end

    local heroData = CommonUtil.GetHeroLogicDataByUid(id)
    if not heroData then return end
    if heroData.id > 1 and (not heroData.owned or not heroData.isBattle) then return end

    local skillEquipSlot = heroData.skillEquipSlot
    local slotList = skillEquipSlot.slotList
    local skillEquipData = slotList and slotList[1] or nil
    if not skillEquipData or skillEquipData.id == 0 then 
        local equipDatas = ManagerContainer.DataMgr.SkillEquipData:GetSkillEquips()
        self.skillEquipSlotRP[id] = #equipDatas > 0
    else
        local starUpRP = ManagerContainer.DataMgr.SkillEquipData:SkillEquipDataCanLvUp(skillEquipData)
        if starUpRP then
            self.skillEquipSlotRP[id] = true
            return 
        end
       
        local lvUpRP = ManagerContainer.DataMgr.SkillEquipData:SkillEquipSlotCanLvUp(id)
        if lvUpRP then
            self.skillEquipSlotRP[id] = true
            return 
        end
    end
end

function HeroRPCtr:RefreshRoleSkillEquipSlotNtf()
    for _,v in pairs(self.skillEquipSlotRP) do
        if v then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.SkillEquip, true)
            return
        end
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.SkillEquip, false)
end

function HeroRPCtr:GetRoleCardSlotUpRP(id)
    local state = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(53)
    if not state then
        return false
    end
    return self.roleCardSlotUpRP[id]
end

function HeroRPCtr:GetRoleSkillEuipSlotRP(id)
    return self.skillEquipSlotRP[id]
end

function HeroRPCtr:GetHeroRPStatus()
    local id = ManagerContainer.DataMgr.UserData:GetId()
    local redPointEnum = self:GetRoleCardSlotRP(id)
    if redPointEnum == Enum.RedPointEnum.None then
        redPointEnum = self:GetHeroSkillUnlockRPStatus(id)
    end
    if redPointEnum == Enum.RedPointEnum.None then
        --装备
        redPointEnum = self:GetHeroEquipRPStatus()
    end

    if redPointEnum == Enum.RedPointEnum.None then
        --卡片
        local emptyRP = self:GetRoleCardSlotEmptyRP(id)
        if emptyRP then
            redPointEnum = Enum.RedPointEnum.CardEmptyRP
        end
    end
    if redPointEnum == Enum.RedPointEnum.None then
        --卡片
        local lvUpRP = self:GetRoleCardSlotUpRP(id)
        if lvUpRP then
            redPointEnum = Enum.RedPointEnum.CardLvUpRP
        end
    end
    if redPointEnum == Enum.RedPointEnum.None then
        --神器
        local slotRP = self:GetRoleSkillEuipSlotRP(1)
        if slotRP then
            redPointEnum = Enum.RedPointEnum.SkillEquip
        end
    end
    if redPointEnum == Enum.RedPointEnum.None then
        redPointEnum = self:GetFashionNewRPStatus()
    end
    return redPointEnum
end

function HeroRPCtr:GetPartnerRPStatus(id)
    local redPointEnum = self:GetRoleCardSlotRP(id)
    if redPointEnum == Enum.RedPointEnum.None then
        redPointEnum = self:GetPartnerRecruitRPStatusById(id)
    end
    if redPointEnum == Enum.RedPointEnum.None then
        redPointEnum = self:GetHeroSkillUnlockRPStatus(id)
    end
    if redPointEnum == Enum.RedPointEnum.None then
        --装备
        redPointEnum = self:GetPartnerEquipRPStatusById(id)
    end
    if redPointEnum == Enum.RedPointEnum.None then
        --卡片
        local emptyRP = self:GetRoleCardSlotEmptyRP(id)
        if emptyRP then
            redPointEnum = Enum.RedPointEnum.CardEmptyRP
        end
    end
    if redPointEnum == Enum.RedPointEnum.None then
        --卡片
        local lvUpRP = self:GetRoleCardSlotUpRP(id)
        if lvUpRP then
            redPointEnum = Enum.RedPointEnum.CardLvUpRP
        end
    end
    if redPointEnum == Enum.RedPointEnum.None then
        --神器
        local slotRP = self:GetRoleSkillEuipSlotRP(id)
        if slotRP then
            redPointEnum = Enum.RedPointEnum.SkillEquip
        end
    end
    return redPointEnum
end

function HeroRPCtr:GetHeroEquipRPStatus()
    for _,v in pairs(self.heroEquipDressRP) do
        if v then
            return Enum.RedPointEnum.EquipDressRP
        end
    end

    for _,v in pairs(self.heroEquipForgeRP) do
        if v then
            local state = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(13)
            if state then
                return Enum.RedPointEnum.EquipForgeRP
            end
        end
    end

    for _,v in pairs(self.heroEquipRefineRP) do
        if v then
            local state = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(17)
            if state then
                return Enum.RedPointEnum.EquipRefineRP
            end
        end
    end

    return Enum.RedPointEnum.None
end

function HeroRPCtr:GetPartnerEquipRPStatus()
    for _,v in pairs(self.partnerEquipDressRP) do
        for _, v1 in pairs(v) do
            if v1 then
                return Enum.RedPointEnum.EquipDressRP
            end
        end
    end

    for _,v in pairs(self.partnerEquipForgeRP) do
        for _, v1 in pairs(v) do
            if v1 then
                local state = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(13)
                if state then
                    return Enum.RedPointEnum.EquipForgeRP
                end
            end
        end
    end

    for _,v in pairs(self.partnerEquipRefineRP) do
        for _, v1 in pairs(v) do
            if v1 then
                local state = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(17)
                if state then
                    return Enum.RedPointEnum.EquipRefineRP
                end
            end
        end
    end

    return Enum.RedPointEnum.None
end

function HeroRPCtr:GetPartnerEquipRPStatusById(id)
    local index = ManagerContainer.DataMgr.UserData:GetSlotIndexByHeroId(id)
    for _,v in pairs(self.partnerEquipDressRP[index]) do
        if v then
            return Enum.RedPointEnum.EquipDressRP
        end
    end

    for _,v in pairs(self.partnerEquipForgeRP[index]) do
        if v then
            local state = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(13)
            if state then
                return Enum.RedPointEnum.EquipForgeRP
            end
        end
    end

    for _,v in pairs(self.partnerEquipRefineRP[index]) do
        if v then
            local state = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(17)
            if state then
                return Enum.RedPointEnum.EquipRefineRP
            end
        end
    end

    return Enum.RedPointEnum.None
end

function HeroRPCtr:GetHeroEquipDressRPStatus()
    for _,v in pairs(self.heroEquipDressRP) do
        if v then
            return Enum.RedPointEnum.EquipDressRP
        end
    end

    return Enum.RedPointEnum.None
end

function HeroRPCtr:GetHeroEquipForgeRPStatus()
    local state = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(13)
    if not state then
        return Enum.RedPointEnum.None
    end
    for _,v in pairs(self.heroEquipForgeRP) do
        if v then
            return Enum.RedPointEnum.EquipForgeRP
        end
    end

    return Enum.RedPointEnum.None
end

function HeroRPCtr:GetHeroEquipRefineRPStatus()
    local state = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(13)
    if not state then
        return Enum.RedPointEnum.None
    end
    for _,v in pairs(self.heroEquipRefineRP) do
        if v then
            return Enum.RedPointEnum.EquipRefineRP
        end
    end

    return Enum.RedPointEnum.None
end

function HeroRPCtr:GetHeroEquipRefineRPStatusByIdx(idx)
    local state = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(17)
    if not state then
        return Enum.RedPointEnum.None
    end
    if self.heroEquipRefineRP[idx] then
        return Enum.RedPointEnum.EquipRefineRP
    end

    return Enum.RedPointEnum.None
end

function HeroRPCtr:GetHeroAttrRPStatus()
    return self.heroAttrRP
end

function HeroRPCtr:GetHeroEquipDressRPStatusByIdx(idx)
    if self.heroEquipDressRP[idx] then
        return Enum.RedPointEnum.EquipDressRP
    end

    return Enum.RedPointEnum.None
end

function HeroRPCtr:GetPartnerEquipDressRPStatusById(id)
    local index = ManagerContainer.DataMgr.UserData:GetSlotIndexByHeroId(id)
    for _,v in pairs(self.partnerEquipDressRP[index]) do
        if v then
            return Enum.RedPointEnum.EquipDressRP
        end
    end

    return Enum.RedPointEnum.None
end

function HeroRPCtr:GetPartnerEquipDressRPStatusByIdAndIdx(id, idx)
    local index = ManagerContainer.DataMgr.UserData:GetSlotIndexByHeroId(id)
    if self.partnerEquipDressRP[index][idx] then
        return Enum.RedPointEnum.EquipDressRP
    end

    return Enum.RedPointEnum.None
end

function HeroRPCtr:GetpartnerEquipForgeRPStatusById(id)
    local state = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(13)
    if not state then
        return Enum.RedPointEnum.None
    end

    local index = ManagerContainer.DataMgr.UserData:GetSlotIndexByHeroId(id)
    for _,v in pairs(self.partnerEquipForgeRP[index]) do
        if v then
            return Enum.RedPointEnum.EquipForgeRP
        end
    end

    return Enum.RedPointEnum.None
end

function HeroRPCtr:GetpartnerEquipRefineRPStatusById(id)
    local state = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(17)
    if not state then
        return Enum.RedPointEnum.None
    end

    local index = ManagerContainer.DataMgr.UserData:GetSlotIndexByHeroId(id)
    for _,v in pairs(self.partnerEquipRefineRP[index]) do
        if v then
            return Enum.RedPointEnum.EquipRefineRP
        end
    end

    return Enum.RedPointEnum.None
end

function HeroRPCtr:GetpartnerEquipRefineRPStatusByIdAndIdx(id, idx)
    local state = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(17)
    if not state then
        return Enum.RedPointEnum.None
    end

    local index = ManagerContainer.DataMgr.UserData:GetSlotIndexByHeroId(id)
    if self.partnerEquipRefineRP[index][idx] then
        return Enum.RedPointEnum.EquipRefineRP
    end

    return Enum.RedPointEnum.None
end

function HeroRPCtr:GetPartnerLvUpRPStatusById(id)
    return self.partnerLvUpRP[id] or false
end

function HeroRPCtr:GetPartnerStrengthRPStatusById(id)
    return self.partnerStrengthRP[id] or false
end

function HeroRPCtr:GetHeroTransferRPStatus()
    return self.heroTransferRP
end

function HeroRPCtr:GetPartnerTransferRPStatusById(id)
    return self.partnerTransferRP[id]
end

function HeroRPCtr:GetPartnerRecruitRPStatusById(id)
    return self.partnerRecruitRP[id] and Enum.RedPointEnum.RecruitRP or Enum.RedPointEnum.None
end

function HeroRPCtr:FashionDataNotify()
    --local lockState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(9)
    --if not lockState then
    --    return
    --end

    -- local fashionMap = ManagerContainer.DataMgr.FashionData:GetFashionMap()
    -- if fashionMap then
    --     for _, value in pairs(fashionMap) do
    --         if value.isNew then
    --             if self.fashionNewRP then
    --                 return
    --             end
    --             self.fashionNewRP = true
    --             -- 红点有变化
    --             ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_NOTICE, Enum.RedPointEnum.FashionNewRP)
    --             ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.NewFashion, true)
    --             return
    --         end
    --     end
    -- end
    -- if not self.fashionNewRP then
    --     return
    -- end
    -- self.fashionNewRP = false
    -- -- 红点有变化
    -- ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_NOTICE, Enum.RedPointEnum.FashionNewRP)
    -- ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.NewFashion, false)
end

function HeroRPCtr:GetAttrPointRPStatus(id)
    if id == 1 then
        return self.heroAttrRP
    else
        return self.partnerAttrRP[id]
    end
end

function HeroRPCtr:GetFashionNewRPStatus()
    local state = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(9)
    if not state then
        return Enum.RedPointEnum.None
    end
    if self.fashionNewRP then
        return Enum.RedPointEnum.FashionNewRP
    end
    return Enum.RedPointEnum.None
end

function HeroRPCtr:SkillUnlockNotify()
    if self.heroSkillRPCtr then
        self.heroSkillRPCtr:SkillUnlockNotify()
    end
end

function HeroRPCtr:CancelSkillUnlockNotify(heroId, skillId)
    if self.heroSkillRPCtr then
        self.heroSkillRPCtr:CancelSkillUnlockNotify(heroId, skillId)
    end
end

function HeroRPCtr:GetAllSkillUnlockRPStatus()
    local state = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(21)
    if not state then
        return Enum.RedPointEnum.None
    end

    if self.heroSkillRPCtr then
        return self.heroSkillRPCtr:GetAllSkillUnlockRPStatus()
    end
    return Enum.RedPointEnum.None
end

function HeroRPCtr:GetHeroSkillUnlockRPStatus(heroId)
    local state = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(21)
    if not state then
        return Enum.RedPointEnum.None
    end

    if self.heroSkillRPCtr then
        return self.heroSkillRPCtr:GetHeroSkillUnlockRPStatus(heroId)
    end
    return Enum.RedPointEnum.None
end

function HeroRPCtr:GetSkillUnlockRPStatus(heroId, skillId)
    local state = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(21)
    if not state then
        return Enum.RedPointEnum.None
    end
    if self.heroSkillRPCtr then
        return self.heroSkillRPCtr:GetSkillUnlockRPStatus(heroId, skillId)
    end
    return Enum.RedPointEnum.None
end

function HeroRPCtr:Dispose()
    self.heroAttrRP = nil
    self.heroEquipDressRP = nil
    self.heroEquipForgeRP =  nil
    self.heroTransferRP = nil
    self.partnerEquipDressRP = nil
    self.partnerEquipForgeRP = nil
    self.partnerLvUpRP = nil
    self.partnerStrengthRP = nil
    self.partnerTransferRP = nil
    self.partnerRecruitRP = nil
    self.fashionNewRP = nil
    if self.heroSkillRPCtr then
        self.heroSkillRPCtr:Dispose()
    end
    self.heroSkillRPCtr = nil

    self.roleCardSlotRP = nil

    self.skillEquipSlotRP = nil
end

return HeroRPCtr